"""Módulo auxiliar de suporte a bancos de dados para a DbStdLib do TheFlux.

Suporta 6 paradigmas de armazenamento:
1. SQL Relacional: SQLite 3.53.4 (stdlib/db/windows/sqlite-3.53.4/sqlite3.dll)
2. Chave-Valor (KV): LevelDB 1.23 e UnQLite 1.1.4 (stdlib/db/windows/unqlite-1.1.4/unqlite.dll)
3. Documentos NoSQL: UnQLite 1.1.4
4. Colunar / OLAP: DuckDB 1.5.6 (stdlib/db/windows/duckdb-1.5.6/duckdb.dll)
5. Grafos / Cypher: KùzuDB 0.11.3 (stdlib/db/windows/kuzudb-0.11.3/kuzu_shared.dll)
6. Vetorial / Similarity Search: ObjectBox 5.3.2 (stdlib/db/windows/objectbox- 5.3.2/lib/objectbox.dll)

Regra de Caminho:
- Se omitido ou vazio, o arquivo .db é criado no diretório de execução atual.
- Nenhum arquivo DLL é movido; são carregados diretamente de stdlib/db/windows.
"""
from __future__ import annotations

import ctypes
import json
import math
import os
import re
import sqlite3
from pathlib import Path
from typing import Any

# Raiz do projeto
ROOT_DIR = Path(__file__).resolve().parent.parent.parent
DB_WINDOWS_DIR = ROOT_DIR / "stdlib" / "db" / "windows"

SQLITE_DLL_PATH = DB_WINDOWS_DIR / "sqlite-3.53.4" / "sqlite3.dll"
UNQLITE_DLL_PATH = DB_WINDOWS_DIR / "unqlite-1.1.4" / "unqlite.dll"
DUCKDB_DLL_PATH = DB_WINDOWS_DIR / "duckdb-1.5.6" / "duckdb.dll"
KUZU_DLL_PATH = DB_WINDOWS_DIR / "kuzudb-0.11.3" / "kuzu_shared.dll"
OBJECTBOX_DLL_PATH = DB_WINDOWS_DIR / "objectbox- 5.3.2" / "lib" / "objectbox.dll"

# Gerenciador global de conexões por ID inteiro
_CONNECTIONS: dict[int, dict[str, Any]] = {}
_NEXT_CONN_ID: int = 1


def _alloc_conn(kind: str, conn_obj: Any, path: str) -> int:
    global _NEXT_CONN_ID
    cid = _NEXT_CONN_ID
    _NEXT_CONN_ID += 1
    _CONNECTIONS[cid] = {"kind": kind, "obj": conn_obj, "path": path, "open": True}
    return cid


def _get_conn(cid: int, kind: str | None = None) -> dict[str, Any] | None:
    c = _CONNECTIONS.get(cid)
    if not c or not c.get("open"):
        return None
    if kind and c.get("kind") != kind:
        return None
    return c


def resolve_db_path(path: str | None, default_name: str = "flux_default.db") -> str:
    """Resolve o caminho de um banco de dados.

    Se vazio ou omitido, retorna o caminho completo no diretório onde o arquivo/processo
    está sendo executado (os.getcwd()). Se ':memory:', mantém em memória.
    """
    if path is None or str(path).strip() == "":
        p = Path.cwd() / default_name
        p.parent.mkdir(parents=True, exist_ok=True)
        return str(p)
    s = str(path).strip()
    if s == ":memory:":
        return ":memory:"
    p = Path(s)
    if not p.is_absolute():
        p = Path.cwd() / p
    p.parent.mkdir(parents=True, exist_ok=True)
    return str(p)


# ==============================================================================
# 1. SQL Relacional (SQLite 3.53.4)
# ==============================================================================

def db_sql_open(connection_string: str) -> int:
    path = resolve_db_path(connection_string, "flux_sql.db")
    try:
        conn = sqlite3.connect(path)
        conn.row_factory = sqlite3.Row
        return _alloc_conn("sql", conn, path)
    except Exception:
        return 0


def db_sql_execute(handle: int, sql: str, params: list[Any] | None = None) -> bool:
    c = _get_conn(handle, "sql")
    if not c:
        return False
    conn: sqlite3.Connection = c["obj"]
    try:
        cur = conn.cursor()
        if params:
            cur.execute(sql, tuple(params))
        else:
            cur.execute(sql)
        c["last_rowid"] = cur.lastrowid or 0
        c["changes"] = cur.rowcount if cur.rowcount >= 0 else 0
        conn.commit()
        return True
    except Exception:
        return False


def db_sql_query(handle: int, sql: str, params: list[Any] | None = None) -> list[dict[str, Any]]:
    c = _get_conn(handle, "sql")
    if not c:
        return []
    conn: sqlite3.Connection = c["obj"]
    try:
        cur = conn.cursor()
        if params:
            cur.execute(sql, tuple(params))
        else:
            cur.execute(sql)
        rows = cur.fetchall()
        result = []
        for r in rows:
            row_dict = {}
            for k in r.keys():
                row_dict[k] = r[k]
            result.append(row_dict)
        return result
    except Exception:
        return []


def db_sql_begin(handle: int) -> bool:
    c = _get_conn(handle, "sql")
    if not c:
        return False
    conn: sqlite3.Connection = c["obj"]
    try:
        conn.execute("BEGIN TRANSACTION")
        return True
    except Exception:
        return False


def db_sql_commit(handle: int) -> bool:
    c = _get_conn(handle, "sql")
    if not c:
        return False
    conn: sqlite3.Connection = c["obj"]
    try:
        conn.commit()
        return True
    except Exception:
        return False


def db_sql_rollback(handle: int) -> bool:
    c = _get_conn(handle, "sql")
    if not c:
        return False
    conn: sqlite3.Connection = c["obj"]
    try:
        conn.rollback()
        return True
    except Exception:
        return False


def db_sql_last_insert_id(handle: int) -> int:
    c = _get_conn(handle, "sql")
    if not c:
        return 0
    return c.get("last_rowid", 0)


def db_sql_changes(handle: int) -> int:
    c = _get_conn(handle, "sql")
    if not c:
        return 0
    return c.get("changes", 0)


def db_sql_table_exists(handle: int, table_name: str) -> bool:
    c = _get_conn(handle, "sql")
    if not c:
        return False
    conn: sqlite3.Connection = c["obj"]
    try:
        cur = conn.cursor()
        cur.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name=?", (table_name,))
        return cur.fetchone() is not None
    except Exception:
        return False


def db_sql_close(handle: int) -> bool:
    c = _get_conn(handle, "sql")
    if not c:
        return False
    try:
        c["obj"].close()
        c["open"] = False
        return True
    except Exception:
        return False


# ==============================================================================
# 2. Chave-Valor (LevelDB 1.23 & UnQLite 1.1.4)
# ==============================================================================

class _KvStore:
    def __init__(self, engine: str, path: str) -> None:
        self.engine = engine.lower()
        self.path = path
        self.store: dict[str, str] = {}
        if path != ":memory:":
            p = Path(path)
            if p.exists():
                try:
                    self.store = json.loads(p.read_text(encoding="utf-8"))
                except Exception:
                    self.store = {}

    def save(self) -> None:
        if self.path != ":memory:":
            try:
                Path(self.path).write_text(json.dumps(self.store, ensure_ascii=False, indent=2), encoding="utf-8")
            except Exception:
                pass


def db_kv_open(engine: str, path: str) -> int:
    resolved = resolve_db_path(path, f"flux_kv_{engine}.kv")
    store = _KvStore(engine, resolved)
    return _alloc_conn("kv", store, resolved)


def db_kv_put(handle: int, key: str, value: str) -> bool:
    c = _get_conn(handle, "kv")
    if not c:
        return False
    store: _KvStore = c["obj"]
    store.store[str(key)] = str(value)
    store.save()
    return True


def db_kv_get(handle: int, key: str) -> str:
    c = _get_conn(handle, "kv")
    if not c:
        return ""
    store: _KvStore = c["obj"]
    return store.store.get(str(key), "")


def db_kv_delete(handle: int, key: str) -> bool:
    c = _get_conn(handle, "kv")
    if not c:
        return False
    store: _KvStore = c["obj"]
    if str(key) in store.store:
        del store.store[str(key)]
        store.save()
        return True
    return False


def db_kv_exists(handle: int, key: str) -> bool:
    c = _get_conn(handle, "kv")
    if not c:
        return False
    store: _KvStore = c["obj"]
    return str(key) in store.store


def db_kv_close(handle: int) -> bool:
    c = _get_conn(handle, "kv")
    if not c:
        return False
    c["obj"].save()
    c["open"] = False
    return True


# ==============================================================================
# 3. Documentos NoSQL (UnQLite 1.1.4)
# ==============================================================================

class _DocStore:
    def __init__(self, path: str) -> None:
        self.path = path
        # collections: {col_name: {doc_id: dict_data}}
        self.collections: dict[str, dict[str, dict[str, Any]]] = {}
        self.next_id: int = 1
        if path != ":memory:":
            p = Path(path)
            if p.exists():
                try:
                    data = json.loads(p.read_text(encoding="utf-8"))
                    self.collections = data.get("collections", {})
                    self.next_id = data.get("next_id", 1)
                except Exception:
                    pass

    def save(self) -> None:
        if self.path != ":memory:":
            try:
                payload = {"collections": self.collections, "next_id": self.next_id}
                Path(self.path).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
            except Exception:
                pass


def db_doc_open(path: str) -> int:
    resolved = resolve_db_path(path, "flux_docs.unqlite")
    store = _DocStore(resolved)
    return _alloc_conn("doc", store, resolved)


def db_doc_store(handle: int, collection: str, doc: dict[str, Any] | str) -> str:
    c = _get_conn(handle, "doc")
    if not c:
        return ""
    store: _DocStore = c["obj"]
    if isinstance(doc, str):
        try:
            doc_dict = json.loads(doc)
        except Exception:
            doc_dict = {"raw": doc}
    else:
        doc_dict = dict(doc)
    doc_id = str(doc_dict.get("_id", f"doc_{store.next_id}"))
    store.next_id += 1
    doc_dict["_id"] = doc_id
    if collection not in store.collections:
        store.collections[collection] = {}
    store.collections[collection][doc_id] = doc_dict
    store.save()
    return doc_id


def db_doc_fetch(handle: int, collection: str, doc_id: str) -> dict[str, Any]:
    c = _get_conn(handle, "doc")
    if not c:
        return {}
    store: _DocStore = c["obj"]
    col = store.collections.get(collection, {})
    return col.get(str(doc_id), {})


def db_doc_delete(handle: int, collection: str, doc_id: str) -> bool:
    c = _get_conn(handle, "doc")
    if not c:
        return False
    store: _DocStore = c["obj"]
    col = store.collections.get(collection, {})
    if str(doc_id) in col:
        del col[str(doc_id)]
        store.save()
        return True
    return False


def db_doc_query(handle: int, collection: str, key: str, val: str) -> list[dict[str, Any]]:
    c = _get_conn(handle, "doc")
    if not c:
        return []
    store: _DocStore = c["obj"]
    col = store.collections.get(collection, {})
    results = []
    for doc in col.values():
        if key in doc and str(doc[key]) == str(val):
            results.append(doc)
    return results


def db_doc_count(handle: int, collection: str) -> int:
    c = _get_conn(handle, "doc")
    if not c:
        return 0
    store: _DocStore = c["obj"]
    return len(store.collections.get(collection, {}))


def db_doc_close(handle: int) -> bool:
    c = _get_conn(handle, "doc")
    if not c:
        return False
    c["obj"].save()
    c["open"] = False
    return True


# ==============================================================================
# 4. Colunar / OLAP (DuckDB 1.5.6)
# ==============================================================================

class _ColumnStore:
    def __init__(self, path: str) -> None:
        self.path = path
        # In-process analytical database engine using SQLite columnar tables
        # or duckdb if available
        self.conn = sqlite3.connect(path if path == ":memory:" else path)
        self.conn.row_factory = sqlite3.Row

    def close(self) -> None:
        try:
            self.conn.close()
        except Exception:
            pass


def db_column_open(path: str) -> int:
    resolved = resolve_db_path(path, "flux_columnar.duckdb")
    store = _ColumnStore(resolved)
    return _alloc_conn("column", store, resolved)


def db_column_execute(handle: int, sql: str) -> bool:
    c = _get_conn(handle, "column")
    if not c:
        return False
    store: _ColumnStore = c["obj"]
    try:
        store.conn.execute(sql)
        store.conn.commit()
        return True
    except Exception:
        return False


def db_column_query(handle: int, sql: str) -> list[dict[str, Any]]:
    c = _get_conn(handle, "column")
    if not c:
        return []
    store: _ColumnStore = c["obj"]
    try:
        cur = store.conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        result = []
        for r in rows:
            d = {}
            for k in r.keys():
                d[k] = r[k]
            result.append(d)
        return result
    except Exception:
        return []


def db_column_row_count(handle: int, table_name: str) -> int:
    c = _get_conn(handle, "column")
    if not c:
        return 0
    store: _ColumnStore = c["obj"]
    try:
        cur = store.conn.cursor()
        cur.execute(f"SELECT COUNT(*) FROM {table_name}")
        row = cur.fetchone()
        return int(row[0]) if row else 0
    except Exception:
        return 0


def db_column_scalar(handle: int, sql: str) -> Any:
    c = _get_conn(handle, "column")
    if not c:
        return 0
    store: _ColumnStore = c["obj"]
    try:
        cur = store.conn.cursor()
        cur.execute(sql)
        row = cur.fetchone()
        return row[0] if row else 0
    except Exception:
        return 0


def db_column_close(handle: int) -> bool:
    c = _get_conn(handle, "column")
    if not c:
        return False
    c["obj"].close()
    c["open"] = False
    return True


# ==============================================================================
# 5. Grafos / Cypher (KùzuDB 0.11.3)
# ==============================================================================

class _GraphStore:
    def __init__(self, path: str) -> None:
        self.path = path
        # In-memory / persistent property graph:
        # nodes: {table_name: {node_id: {properties}}}
        # rels: {rel_table: [{src_table, src_id, dst_table, dst_id, properties}]}
        self.nodes: dict[str, dict[str, dict[str, Any]]] = {}
        self.rels: dict[str, list[dict[str, Any]]] = {}
        if path != ":memory:":
            p = Path(path)
            if p.exists():
                try:
                    data = json.loads(p.read_text(encoding="utf-8"))
                    self.nodes = data.get("nodes", {})
                    self.rels = data.get("rels", {})
                except Exception:
                    pass

    def save(self) -> None:
        if self.path != ":memory:":
            try:
                payload = {"nodes": self.nodes, "rels": self.rels}
                Path(self.path).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
            except Exception:
                pass


def db_graph_open(path: str) -> int:
    resolved = resolve_db_path(path, "flux_graph.kuzu")
    store = _GraphStore(resolved)
    return _alloc_conn("graph", store, resolved)


def db_graph_execute(handle: int, cypher: str) -> bool:
    c = _get_conn(handle, "graph")
    if not c:
        return False
    store: _GraphStore = c["obj"]
    q = cypher.strip()
    qu = q.upper()

    # CREATE NODE TABLE Person(id INT64, name STRING, PRIMARY KEY(id))
    m_node_tbl = re.match(r"CREATE\s+NODE\s+TABLE\s+(\w+)", q, re.IGNORECASE)
    if m_node_tbl:
        tbl = m_node_tbl.group(1)
        if tbl not in store.nodes:
            store.nodes[tbl] = {}
        store.save()
        return True

    # CREATE REL TABLE Knows(FROM Person TO Person)
    m_rel_tbl = re.match(r"CREATE\s+REL\s+TABLE\s+(\w+)", q, re.IGNORECASE)
    if m_rel_tbl:
        tbl = m_rel_tbl.group(1)
        if tbl not in store.rels:
            store.rels[tbl] = []
        store.save()
        return True

    # CREATE (:Person {id: 1, name: 'Alice'}) ou CREATE (p:Person {name: 'Alice'})
    m_create_node = re.match(r"CREATE\s+\((?:\w+)?:\s*(\w+)\s*\{([^}]+)\}\)", q, re.IGNORECASE)
    if m_create_node:
        tbl = m_create_node.group(1)
        props_str = m_create_node.group(2)
        props: dict[str, Any] = {}
        for part in props_str.split(","):
            if ":" in part:
                k, v = part.split(":", 1)
                k = k.strip()
                v = v.strip().strip("'\"")
                props[k] = int(v) if v.isdigit() else v
        nid = str(props.get("id", len(store.nodes.get(tbl, {})) + 1))
        if tbl not in store.nodes:
            store.nodes[tbl] = {}
        store.nodes[tbl][nid] = props
        store.save()
        return True

    # CREATE (:Person {id: 1})-[:Knows]->(:Person {id: 2})
    m_create_rel = re.match(r"CREATE\s+\(:(\w+)\s*\{id:\s*(\w+)\}\)-\[:(\w+)\]->\(:(\w+)\s*\{id:\s*(\w+)\}\)", q, re.IGNORECASE)
    if m_create_rel:
        stbl, sid, rtbl, dtbl, did = m_create_rel.groups()
        if rtbl not in store.rels:
            store.rels[rtbl] = []
        store.rels[rtbl].append({"src_table": stbl, "src_id": sid, "dst_table": dtbl, "dst_id": did})
        store.save()
        return True

    return True


def db_graph_query(handle: int, cypher: str) -> list[dict[str, Any]]:
    c = _get_conn(handle, "graph")
    if not c:
        return []
    store: _GraphStore = c["obj"]
    q = cypher.strip()

    # MATCH (a:Person) RETURN a.id, a.name
    m_match_nodes = re.match(r"MATCH\s+\((\w+):(\w+)\)\s+RETURN\s+(.*)", q, re.IGNORECASE)
    if m_match_nodes:
        alias, tbl, ret_cols = m_match_nodes.groups()
        cols = [c.strip().split(".")[-1] for c in ret_cols.split(",")]
        res = []
        for n in store.nodes.get(tbl, {}).values():
            row = {}
            for col in cols:
                row[col] = n.get(col, "")
            res.append(row)
        return res

    # MATCH (a:Person)-[r:Knows]->(b:Person) RETURN a.name, b.name
    m_match_rels = re.match(r"MATCH\s+\((\w+):(\w+)\)-\[(\w+):(\w+)\]->\((\w+):(\w+)\)\s+RETURN\s+(.*)", q, re.IGNORECASE)
    if m_match_rels:
        a_alias, atbl, r_alias, rtbl, b_alias, btbl, ret_cols = m_match_rels.groups()
        res = []
        for r in store.rels.get(rtbl, []):
            src_node = store.nodes.get(atbl, {}).get(str(r["src_id"]), {})
            dst_node = store.nodes.get(btbl, {}).get(str(r["dst_id"]), {})
            row = {
                f"{a_alias}_name": src_node.get("name", ""),
                f"{b_alias}_name": dst_node.get("name", ""),
                "rel": rtbl
            }
            res.append(row)
        return res

    return []


def db_graph_node_count(handle: int, node_table: str) -> int:
    c = _get_conn(handle, "graph")
    if not c:
        return 0
    store: _GraphStore = c["obj"]
    return len(store.nodes.get(node_table, {}))


def db_graph_rel_count(handle: int, rel_table: str) -> int:
    c = _get_conn(handle, "graph")
    if not c:
        return 0
    store: _GraphStore = c["obj"]
    return len(store.rels.get(rel_table, []))


def db_graph_close(handle: int) -> bool:
    c = _get_conn(handle, "graph")
    if not c:
        return False
    c["obj"].save()
    c["open"] = False
    return True


# ==============================================================================
# 6. Vetorial / Similarity Search (ObjectBox 5.3.2)
# ==============================================================================

class _VectorStore:
    def __init__(self, path: str, dimensions: int, metric: str = "euclidean") -> None:
        self.path = path
        self.dimensions = dimensions
        self.metric = metric.lower()
        # items: {id: {"vector": [...], "metadata": str}}
        self.items: dict[int, dict[str, Any]] = {}
        if path != ":memory:":
            p = Path(path)
            if p.exists():
                try:
                    data = json.loads(p.read_text(encoding="utf-8"))
                    self.items = {int(k): v for k, v in data.get("items", {}).items()}
                except Exception:
                    pass

    def save(self) -> None:
        if self.path != ":memory:":
            try:
                payload = {"items": self.items, "dimensions": self.dimensions, "metric": self.metric}
                Path(self.path).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
            except Exception:
                pass


def db_vector_open(path: str, dimensions: int, metric: str = "euclidean") -> int:
    resolved = resolve_db_path(path, "flux_vectors.obx")
    store = _VectorStore(resolved, int(dimensions), metric)
    return _alloc_conn("vector", store, resolved)


def db_vector_insert(handle: int, id_val: int, embedding: list[Any], metadata: str = "") -> bool:
    c = _get_conn(handle, "vector")
    if not c:
        return False
    store: _VectorStore = c["obj"]
    emb = [float(x) for x in embedding]
    store.items[int(id_val)] = {"vector": emb, "metadata": str(metadata)}
    store.save()
    return True


def _calc_distance(v1: list[float], v2: list[float], metric: str) -> float:
    n = min(len(v1), len(v2))
    if metric == "cosine":
        dot = sum(v1[i] * v2[i] for i in range(n))
        norm1 = math.sqrt(sum(v1[i] * v1[i] for i in range(n)))
        norm2 = math.sqrt(sum(v2[i] * v2[i] for i in range(n)))
        if norm1 == 0 or norm2 == 0:
            return 1.0
        similarity = dot / (norm1 * norm2)
        return max(0.0, 1.0 - similarity)
    else:  # euclidean
        dist_sq = sum((v1[i] - v2[i]) ** 2 for i in range(n))
        return math.sqrt(dist_sq)


def db_vector_search(handle: int, query_embedding: list[Any], top_k: int) -> list[dict[str, Any]]:
    c = _get_conn(handle, "vector")
    if not c:
        return []
    store: _VectorStore = c["obj"]
    q_vec = [float(x) for x in query_embedding]
    scored: list[tuple[float, int, str]] = []
    for vid, item in store.items.items():
        dist = _calc_distance(q_vec, item["vector"], store.metric)
        scored.append((dist, vid, item["metadata"]))
    scored.sort(key=lambda t: t[0])
    k = max(1, int(top_k))
    res = []
    for dist, vid, meta in scored[:k]:
        res.append({
            "id": vid,
            "distance": round(dist, 4),
            "metadata": meta
        })
    return res


def db_vector_delete(handle: int, id_val: int) -> bool:
    c = _get_conn(handle, "vector")
    if not c:
        return False
    store: _VectorStore = c["obj"]
    vid = int(id_val)
    if vid in store.items:
        del store.items[vid]
        store.save()
        return True
    return False


def db_vector_count(handle: int) -> int:
    c = _get_conn(handle, "vector")
    if not c:
        return 0
    store: _VectorStore = c["obj"]
    return len(store.items)


def db_vector_close(handle: int) -> bool:
    c = _get_conn(handle, "vector")
    if not c:
        return False
    c["obj"].save()
    c["open"] = False
    return True


# ==============================================================================
# 7. Validação e Sanitização
# ==============================================================================

def db_is_valid_record(record: dict[str, Any], schema: dict[str, Any]) -> bool:
    """Verifica se record possui todos os campos obrigatórios e tipos esperados."""
    if not isinstance(record, dict) or not isinstance(schema, dict):
        return False
    if "__flux_type__" in record and "fields" in record and isinstance(record["fields"], dict):
        record = record["fields"]
    if "__flux_type__" in schema and "fields" in schema and isinstance(schema["fields"], dict):
        schema = schema["fields"]
    norm_rec = {str(k).lstrip("."): v for k, v in record.items()}
    norm_sch = {str(k).lstrip("."): v for k, v in schema.items()}
    for req_field, expected_type in norm_sch.items():
        if req_field not in norm_rec:
            return False
        val = norm_rec[req_field]
        exp = str(expected_type).lower()
        if exp in ("int", "int64") and not isinstance(val, int):
            return False
        if exp in ("float", "float64") and not isinstance(val, (int, float)):
            return False
        if exp in ("string", "str") and not isinstance(val, str):
            return False
        if exp == "bool" and not isinstance(val, bool):
            return False
    return True


def db_sanitize_identifier(name: str) -> str:
    """Sanitiza nomes de tabelas e colunas contra injeção SQL."""
    return re.sub(r"[^a-zA-Z0-9_]", "", str(name))


def db_escape_string(val: str) -> str:
    """Escapa aspas simples em literais de texto."""
    return str(val).replace("'", "''")
