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
    loaded_agents: set[str] = set()

    while queue:
        decl = queue.pop(0)
        target = decl.target
        if isinstance(target, UseAgent):
            name = target.name
            key = target.alias or name
            if name not in loaded_agents:
                fdsl_file = _load_fdsl(name, source_dir, project_root)
                loaded_agents.add(name)
                for child_decl in getattr(fdsl_file, "use_decls", []):
                    queue.append(child_decl)
            else:
                fdsl_file = imports[name]
            imports[key] = fdsl_file
            if target.alias:
                imports[name] = fdsl_file
        elif isinstance(target, UseOp):
            agent_name = target.agent
            key = target.alias or agent_name
            if agent_name not in loaded_agents:
                fdsl_file = _load_fdsl(agent_name, source_dir, project_root)
                loaded_agents.add(agent_name)
                for child_decl in getattr(fdsl_file, "use_decls", []):
                    queue.append(child_decl)
            else:
                fdsl_file = imports[agent_name]
            imports[key] = fdsl_file
            if target.alias:
                imports[agent_name] = fdsl_file
        elif isinstance(target, UseGroup):
            agent_name = target.agent
            if agent_name:
                if agent_name not in loaded_agents:
                    fdsl_file = _load_fdsl(agent_name, source_dir, project_root)
                    loaded_agents.add(agent_name)
                    for child_decl in getattr(fdsl_file, "use_decls", []):
                        queue.append(child_decl)
                else:
                    fdsl_file = imports[agent_name]
                imports.setdefault(agent_name, fdsl_file)
                for item in target.items:
                    imports[item.alias or item.name] = fdsl_file
            else:
                for item in target.items:
                    agent = item.agent or item.name
                    if agent not in loaded_agents:
                        fdsl_file = _load_fdsl(agent, source_dir, project_root)
                        loaded_agents.add(agent)
                        for child_decl in getattr(fdsl_file, "use_decls", []):
                            queue.append(child_decl)
                    else:
                        fdsl_file = imports[agent]
                    imports.setdefault(agent, fdsl_file)
                    imports[item.alias or item.name] = fdsl_file

    return imports


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


def _search_fdsl(name: str, source_dir: str, project_root: str) -> str | None:
    filename = name if name.endswith(".fdsl") else f"{name}.fdsl"

    # Se o sufixo for *StdLib.fdsl busca em stdlib
    if filename.endswith("StdLib.fdsl"):
        search_paths = [
            os.path.join(project_root, "stdlib", filename),
            os.path.join(source_dir, "stdlib", filename),
        ]
    # Se o prefixo for AgentOf*.fdsl busca em fdsl
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
    return None


def _load_fdsl(name: str, source_dir: str, project_root: str) -> FdslFile:
    fdsl_path = _search_fdsl(name, source_dir, project_root)
    if fdsl_path is None:
        filename = name if name.endswith(".fdsl") else f"{name}.fdsl"
        target_folder = "stdlib" if filename.endswith("StdLib.fdsl") else "fdsl"
        raise ImportError(
            f"use '{name}': arquivo fdsl '{filename}' não encontrado na pasta '{target_folder}'"
        )

    with open(fdsl_path, "rb") as f:
        raw = f.read()
    source = raw.decode("utf-8", errors="replace")

    try:
        token_gen = lex(source)
    except LexicalError as e:
        raise ImportError(f"use '{name}': erro léxico em '{fdsl_path}': {e.message}") from e

    try:
        result = parse_fdsl_file(TokenStream(token_gen))
    except Exception as e:
        raise ImportError(f"use '{name}': erro de parsing em '{fdsl_path}': {e}") from e

    if isinstance(result, FdslFile):
        return result
    raise ImportError(f"use '{name}': arquivo '{fdsl_path}' não é um fdsl válido")
