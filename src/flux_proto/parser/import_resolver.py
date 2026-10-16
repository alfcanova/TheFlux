from __future__ import annotations

import os

from flux_proto.lexer.lexer import lex, LexicalError
from flux_proto.parser.ast import (
    ASTNode, FdslFile, UseDecl, UseAgent, UseOp, UseGroup,
)
from flux_proto.parser.parser import parse_fdsl_file
from flux_proto.parser.token_stream import TokenStream


class ImportError(Exception):
    pass


def collect_op_aliases(program: ASTNode) -> dict[str, str]:
    """Mapeia alias -> nome real da op a partir de declarações `use Agent::op as alias`."""
    aliases: dict[str, str] = {}
    for decl in getattr(program, "use_decls", []):
        target = decl.target
        if isinstance(target, UseOp) and target.alias:
            aliases[target.alias] = target.op
        elif isinstance(target, UseGroup):
            for item in target.items:
                if item.alias:
                    aliases[item.alias] = item.name
    return aliases


def resolve_imports(program: ASTNode, source_path: str) -> dict[str, FdslFile]:
    use_decls: list[UseDecl] = getattr(program, "use_decls", [])
    if not use_decls:
        return {}

    source_dir = os.path.dirname(os.path.abspath(source_path))
    project_root = _find_project_root(source_path)

    imports: dict[str, FdslFile] = {}
    queue: list[UseDecl] = list(use_decls)
    loaded_agents: dict[str, FdslFile] = {}

    while queue:
        decl = queue.pop(0)
        target = decl.target
        if isinstance(target, UseAgent):
            name = target.name
            key = target.alias or name
            if name not in loaded_agents:
                fdsl_file = _load_agent_or_modular(name, source_dir, project_root)
                loaded_agents[name] = fdsl_file
                for child_decl in getattr(fdsl_file, "use_decls", []):
                    queue.append(child_decl)
            else:
                fdsl_file = loaded_agents[name]
            _register_import_keys(imports, fdsl_file, primary_key=key, fallback_names=[name])
        elif isinstance(target, UseOp):
            agent_name = target.path[0] if getattr(target, "path", None) else target.agent
            op_name = target.path[-1] if getattr(target, "path", None) else target.op
            key = target.alias or agent_name
            cache_key = f"{agent_name}::{op_name}" if op_name else agent_name
            if cache_key not in loaded_agents:
                fdsl_file = _load_agent_or_modular(agent_name, source_dir, project_root, target_ops=[op_name] if op_name else None)
                loaded_agents[cache_key] = fdsl_file
                for child_decl in getattr(fdsl_file, "use_decls", []):
                    queue.append(child_decl)
            else:
                fdsl_file = loaded_agents[cache_key]
            extra_keys = [op_name] if op_name else []
            if getattr(target, "path", None) and len(target.path) > 2:
                for i in range(1, len(target.path) - 1):
                    seg = target.path[i]
                    extra_keys.append(seg)
                    extra_keys.append("::".join(target.path[:i+1]))
            _register_import_keys(imports, fdsl_file, primary_key=key, fallback_names=[agent_name], extra_keys=extra_keys)
        elif isinstance(target, UseGroup):
            agent_name = target.agent
            group_ops = [it.name for it in target.items if it.name]
            path_segments = getattr(target, "path", [])
            if agent_name:
                cache_key = f"{agent_name}::{','.join(group_ops)}" if group_ops else agent_name
                if cache_key not in loaded_agents:
                    fdsl_file = _load_agent_or_modular(agent_name, source_dir, project_root, target_ops=group_ops or None)
                    loaded_agents[cache_key] = fdsl_file
                    for child_decl in getattr(fdsl_file, "use_decls", []):
                        queue.append(child_decl)
                else:
                    fdsl_file = loaded_agents[cache_key]
                fallback_names = [agent_name]
                if path_segments and len(path_segments) > 1:
                    for i in range(1, len(path_segments)):
                        fallback_names.append(path_segments[i])
                        fallback_names.append("::".join(path_segments[:i+1]))
                _register_import_keys(imports, fdsl_file, primary_key=agent_name, fallback_names=fallback_names)
                for item in target.items:
                    imports[item.alias or item.name] = fdsl_file
            else:
                for item in target.items:
                    agent = item.agent or item.name
                    if agent not in loaded_agents:
                        fdsl_file = _load_agent_or_modular(agent, source_dir, project_root)
                        loaded_agents[agent] = fdsl_file
                        for child_decl in getattr(fdsl_file, "use_decls", []):
                            queue.append(child_decl)
                    else:
                        fdsl_file = loaded_agents[agent]
                    _register_import_keys(imports, fdsl_file, primary_key=agent, fallback_names=[agent], extra_keys=[item.alias or item.name])

    return imports


def _register_import_keys(
    imports: dict[str, FdslFile],
    fdsl_file: FdslFile,
    primary_key: str,
    fallback_names: list[str] | None = None,
    extra_keys: list[str] | None = None,
) -> None:
    imports[primary_key] = fdsl_file
    for name in fallback_names or []:
        imports[name] = fdsl_file
    for agent in getattr(fdsl_file, "agents", []):
        imports[agent.name] = fdsl_file
    for k in extra_keys or []:
        imports[k] = fdsl_file


def _find_project_root(source_path: str) -> str:
    abs_path = os.path.abspath(source_path)
    dir_path = os.path.dirname(abs_path)
    for _ in range(10):
        if os.path.isdir(os.path.join(dir_path, "fdsl")):
            return dir_path
        if os.path.isdir(os.path.join(dir_path, "src")):
            return dir_path
        if os.path.isdir(os.path.join(dir_path, "stdlib")):
            return dir_path
        parent = os.path.dirname(dir_path)
        if parent == dir_path:
            break
        dir_path = parent
    return os.path.dirname(abs_path)


def _search_modular_dir(name: str, source_dir: str, project_root: str) -> tuple[str, str] | None:
    """Verifica se existe um diretório modular correspondente a 'name'.
    A convenção mandatória exige que o arquivo agregador mestre tenha o mesmo
    nome da pasta: <dir>/<dir_basename>.fdsl.
    Dentro do diretório existem exclusivamente arquivos planos .fdsl."""
    clean_name = name[:-5] if name.endswith(".fdsl") else name
    candidates = [
        os.path.join(project_root, "stdlib", clean_name),
        os.path.join(source_dir, "stdlib", clean_name),
        os.path.join(project_root, "fdsl", clean_name),
        os.path.join(source_dir, "fdsl", clean_name),
        os.path.join(source_dir, clean_name),
    ]
    if clean_name != name:
        candidates.extend([
            os.path.join(project_root, "stdlib", name),
            os.path.join(source_dir, "stdlib", name),
            os.path.join(project_root, "fdsl", name),
            os.path.join(source_dir, "fdsl", name),
            os.path.join(source_dir, name),
        ])
    for d in candidates:
        if os.path.isdir(d):
            base = os.path.basename(os.path.normpath(d))
            master = os.path.join(d, f"{base}.fdsl")
            if os.path.isfile(master):
                return (d, master)
    return None


def _search_fdsl(name: str, source_dir: str, project_root: str) -> str | None:
    filename = name if name.endswith(".fdsl") else f"{name}.fdsl"

    if filename.endswith("StdLib.fdsl"):
        search_paths = [
            os.path.join(project_root, "stdlib", filename),
            os.path.join(source_dir, "stdlib", filename),
        ]
    elif filename.startswith("AgentOf"):
        search_paths = [
            os.path.join(project_root, "fdsl", filename),
            os.path.join(source_dir, "fdsl", filename),
            os.path.join(source_dir, filename),
        ]
    else:
        search_paths = [
            os.path.join(project_root, "fdsl", filename),
            os.path.join(source_dir, "fdsl", filename),
            os.path.join(source_dir, filename),
            os.path.join(project_root, "stdlib", filename),
            os.path.join(source_dir, "stdlib", filename),
        ]
    for path in search_paths:
        if os.path.exists(path):
            return path

    target_basename = os.path.basename(filename)
    for base in [os.path.join(project_root, "fdsl"), os.path.join(source_dir, "fdsl")]:
        if os.path.isdir(base):
            for root, _, files in os.walk(base):
                if target_basename in files:
                    return os.path.join(root, target_basename)

    return None


def _parse_fdsl_file_path(fdsl_path: str, context_name: str) -> FdslFile:
    with open(fdsl_path, "rb") as f:
        raw = f.read()
    source = raw.decode("utf-8", errors="replace")

    try:
        token_gen = lex(source)
    except LexicalError as e:
        raise ImportError(f"use '{context_name}': erro léxico em '{fdsl_path}': {e.message}") from e

    try:
        result = parse_fdsl_file(TokenStream(token_gen))
    except Exception as e:
        raise ImportError(f"use '{context_name}': erro de parsing em '{fdsl_path}': {e}") from e

    if isinstance(result, FdslFile):
        return result
    raise ImportError(f"use '{context_name}': arquivo '{fdsl_path}' não é um fdsl válido")


def _fuse_fdsl(master: FdslFile, child: FdslFile) -> None:
    # 1. Fusão de Agents e Ops
    master_agents = {a.name: a for a in master.agents}
    for ca in child.agents:
        if ca.name in master_agents:
            ma = master_agents[ca.name]
            if ma.body is None and ca.body is not None:
                ma.body = ca.body
            elif ma.body is not None and ca.body is not None:
                existing_ops = {op.name: op for op in ma.body.ops}
                for op in ca.body.ops:
                    if op.name in existing_ops:
                        idx = ma.body.ops.index(existing_ops[op.name])
                        ma.body.ops[idx] = op
                    else:
                        ma.body.ops.append(op)
                        existing_ops[op.name] = op
                ma.body.storages.extend(ca.body.storages)
                ma.body.functions.extend(ca.body.functions)
            for cname in ca.impl_contracts:
                if cname not in ma.impl_contracts:
                    ma.impl_contracts.append(cname)
        else:
            master.agents.append(ca)
            master_agents[ca.name] = ca

    # 2. Fusão de Structs
    existing_structs = {s.name: s for s in master.structs}
    for s in child.structs:
        if s.name not in existing_structs:
            master.structs.append(s)
            existing_structs[s.name] = s

    # 3. Fusão de Enums
    existing_enums = {e.name: e for e in master.enums}
    for e in child.enums:
        if e.name not in existing_enums:
            master.enums.append(e)
            existing_enums[e.name] = e

    # 4. Fusão de Contratos
    existing_contracts = {c.name: c for c in master.contracts}
    for c in child.contracts:
        if c.name not in existing_contracts:
            master.contracts.append(c)
            existing_contracts[c.name] = c

    # 5. Fusão de Storages, Functions e Macros
    master.storages.extend(child.storages)
    existing_funcs = {f.name: f for f in master.functions}
    for f in child.functions:
        if f.name not in existing_funcs:
            master.functions.append(f)
            existing_funcs[f.name] = f
    existing_macros = {m.name: m for m in master.macros}
    for m in child.macros:
        if m.name not in existing_macros:
            master.macros.append(m)
            existing_macros[m.name] = m


def _load_modular_dir(
    dir_path: str,
    master_fdsl_path: str,
    name: str,
    target_ops: list[str] | None = None,
) -> FdslFile:
    master_file = _parse_fdsl_file_path(master_fdsl_path, name)
    master_basename = os.path.basename(master_fdsl_path)

    # 1. Extrai módulos declarados explicitamente via diretivas 'use' no arquivo agregador mestre,
    # separando módulos locais (que existem em dir_path) de dependências externas.
    target_files: list[tuple[str, str]] = []
    external_uses: list[UseDecl] = []

    if master_file.use_decls:
        for decl in master_file.use_decls:
            target = decl.target
            mod_names: list[str] = []
            if isinstance(target, UseAgent):
                mod_names.append(target.name)
            elif isinstance(target, UseGroup):
                for item in target.items:
                    if item.name:
                        mod_names.append(item.name)
            elif isinstance(target, UseOp):
                mod_name = target.path[0] if getattr(target, "path", None) else (target.agent or target.op)
                if mod_name:
                    mod_names.append(mod_name)

            is_local = False
            for mod in mod_names:
                fname = mod if mod.endswith(".fdsl") else f"{mod}.fdsl"
                cpath = os.path.join(dir_path, fname)
                if os.path.isfile(cpath):
                    target_files.append((fname, cpath))
                    is_local = True
                elif mod.endswith(".fdsl"):
                    # Módulo com extensão explícita declarado no manifesto mas não encontrado na pasta
                    raise ImportError(
                        f"use '{name}': módulo declarado '{mod}' ('{fname}') "
                        f"não foi encontrado no diretório da biblioteca '{dir_path}'"
                    )

            if not is_local:
                # É uma dependência externa à biblioteca modular (ex.: use IoStdLib)
                external_uses.append(decl)
    else:
        # Fallback de compatibilidade para diretórios que não declaram manifesto explícito
        target_files = [
            (f, os.path.join(dir_path, f))
            for f in sorted(os.listdir(dir_path))
            if f.endswith(".fdsl") and f != master_basename and os.path.isfile(os.path.join(dir_path, f))
        ]

    for fname, child_path in target_files:
        child_fdsl = _parse_fdsl_file_path(child_path, f"{name}/{fname}")
        for cdecl in getattr(child_fdsl, "use_decls", []):
            external_uses.append(cdecl)
        _fuse_fdsl(master_file, child_fdsl)

    # Preserva apenas as dependências externas legítimas para resolução no escopo global,
    # descartando os módulos locais que já foram carregados e fundidos.
    master_file.use_decls = external_uses

    return master_file


def _load_agent_or_modular(
    name: str,
    source_dir: str,
    project_root: str,
    target_ops: list[str] | None = None,
) -> FdslFile:
    # 1. Verifica se é diretório modular com arquivo mestre <dir>/<dir>.fdsl
    mod_info = _search_modular_dir(name, source_dir, project_root)
    if mod_info is not None:
        dir_path, master_path = mod_info
        return _load_modular_dir(dir_path, master_path, name, target_ops=target_ops)

    # 2. Caso contrário, carrega arquivo .fdsl monolítico legado
    fdsl_path = _search_fdsl(name, source_dir, project_root)
    if fdsl_path is None:
        filename = name if name.endswith(".fdsl") else f"{name}.fdsl"
        target_folder = "stdlib" if filename.endswith("StdLib.fdsl") else "fdsl"
        raise ImportError(
            f"use '{name}': arquivo fdsl '{filename}' não encontrado na pasta '{target_folder}'"
        )
    return _parse_fdsl_file_path(fdsl_path, name)


def _load_fdsl(name: str, source_dir: str, project_root: str) -> FdslFile:
    return _load_agent_or_modular(name, source_dir, project_root)
