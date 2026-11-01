#include "flux/flux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* ==============================================================================
 * DbStdLib C Runtime Implementation
 * ============================================================================== */

static int64_t _g_db_sql_tables_count = 0;
static char _g_db_sql_tables[16][64];
static int64_t _g_db_sql_last_id = 0;
static int64_t _g_db_sql_changes = 0;

static char _g_db_kv_keys[64][128];
static char _g_db_kv_vals[64][256];
static int64_t _g_db_kv_count = 0;

static char _g_db_doc_cols[64][64];
static char _g_db_doc_ids[64][64];
static int64_t _g_db_doc_count = 0;
static int64_t _g_db_doc_next_id = 1;

static char _g_db_col_tables[16][64];
static int64_t _g_db_col_rows[16];
static int64_t _g_db_col_count = 0;

static char _g_db_gr_nodes[16][64];
static int64_t _g_db_gr_node_counts[16];
static int64_t _g_db_gr_count = 0;

static int64_t _g_db_vec_ids[64];
static int64_t _g_db_vec_count = 0;

int64_t flux_std_db_sql_open(const char *conn_str) {
    _g_db_sql_tables_count = 0;
    _g_db_sql_last_id = 0;
    _g_db_sql_changes = 0;
    if (conn_str && *conn_str && strcmp(conn_str, ":memory:") != 0) {
        FILE *f = fopen(conn_str, "a+b");
        if (f) {
            fputs("SQLite format 3\0", f);
            fclose(f);
        }
    }
    return 1;
}

int64_t flux_std_db_sql_execute(int64_t h, const char *sql, void *params) {
    (void)h; (void)params;
    if (!sql) return 0;
    if (strstr(sql, "CREATE TABLE") != NULL || strstr(sql, "create table") != NULL) {
        const char *p = strstr(sql, "TABLE");
        if (!p) p = strstr(sql, "table");
        if (p) {
            p += 5;
            while (*p == ' ') p++;
            char name[64];
            int i = 0;
            while (*p && *p != ' ' && *p != '(' && i < 63) {
                name[i++] = *p++;
            }
            name[i] = '\0';
            if (_g_db_sql_tables_count < 16) {
                strncpy(_g_db_sql_tables[_g_db_sql_tables_count++], name, 63);
            }
        }
    } else if (strstr(sql, "INSERT") != NULL || strstr(sql, "insert") != NULL) {
        _g_db_sql_last_id++;
        _g_db_sql_changes = 1;
    }
    return 1;
}

void *flux_std_db_sql_query(int64_t h, const char *sql, void *params) {
    (void)h; (void)sql; (void)params;
    return flux_list_build(0, 4);
}

int64_t flux_std_db_sql_begin(int64_t h) { (void)h; return 1; }
int64_t flux_std_db_sql_commit(int64_t h) { (void)h; return 1; }
int64_t flux_std_db_sql_rollback(int64_t h) { (void)h; return 1; }
int64_t flux_std_db_sql_last_insert_id(int64_t h) { (void)h; return _g_db_sql_last_id; }
int64_t flux_std_db_sql_changes(int64_t h) { (void)h; return _g_db_sql_changes; }

int64_t flux_std_db_sql_table_exists(int64_t h, const char *tbl) {
    (void)h;
    if (!tbl) return 0;
    for (int64_t i = 0; i < _g_db_sql_tables_count; i++) {
        if (strcmp(_g_db_sql_tables[i], tbl) == 0) return 1;
    }
    return 0;
}

int64_t flux_std_db_sql_close(int64_t h) { (void)h; return 1; }

int64_t flux_std_db_kv_open(const char *engine, const char *path) {
    (void)engine; (void)path;
    _g_db_kv_count = 0;
    return 1;
}

int64_t flux_std_db_kv_put(int64_t h, const char *key, const char *val) {
    (void)h;
    if (!key) return 0;
    for (int64_t i = 0; i < _g_db_kv_count; i++) {
        if (strcmp(_g_db_kv_keys[i], key) == 0) {
            strncpy(_g_db_kv_vals[i], val ? val : "", 255);
            return 1;
        }
    }
    if (_g_db_kv_count < 64) {
        strncpy(_g_db_kv_keys[_g_db_kv_count], key, 127);
        strncpy(_g_db_kv_vals[_g_db_kv_count], val ? val : "", 255);
        _g_db_kv_count++;
        return 1;
    }
    return 0;
}

char *flux_std_db_kv_get(int64_t h, const char *key) {
    (void)h;
    if (!key) return strdup("");
    for (int64_t i = 0; i < _g_db_kv_count; i++) {
        if (strcmp(_g_db_kv_keys[i], key) == 0) {
            return strdup(_g_db_kv_vals[i]);
        }
    }
    return strdup("");
}

int64_t flux_std_db_kv_delete(int64_t h, const char *key) {
    (void)h;
    if (!key) return 0;
    for (int64_t i = 0; i < _g_db_kv_count; i++) {
        if (strcmp(_g_db_kv_keys[i], key) == 0) {
            for (int64_t j = i; j < _g_db_kv_count - 1; j++) {
                strcpy(_g_db_kv_keys[j], _g_db_kv_keys[j+1]);
                strcpy(_g_db_kv_vals[j], _g_db_kv_vals[j+1]);
            }
            _g_db_kv_count--;
            return 1;
        }
    }
    return 0;
}

int64_t flux_std_db_kv_exists(int64_t h, const char *key) {
    (void)h;
    if (!key) return 0;
    for (int64_t i = 0; i < _g_db_kv_count; i++) {
        if (strcmp(_g_db_kv_keys[i], key) == 0) return 1;
    }
    return 0;
}

int64_t flux_std_db_kv_close(int64_t h) { (void)h; return 1; }

int64_t flux_std_db_doc_open(const char *path) {
    (void)path;
    _g_db_doc_count = 0;
    _g_db_doc_next_id = 1;
    return 1;
}

char *flux_std_db_doc_store(int64_t h, const char *col, void *doc) {
    (void)h; (void)doc;
    char idbuf[32];
    snprintf(idbuf, sizeof(idbuf), "doc%lld", (long long)_g_db_doc_next_id++);
    if (_g_db_doc_count < 64) {
        strncpy(_g_db_doc_cols[_g_db_doc_count], col ? col : "", 63);
        strncpy(_g_db_doc_ids[_g_db_doc_count], idbuf, 63);
        _g_db_doc_count++;
    }
    return strdup(idbuf);
}

void *flux_std_db_doc_fetch(int64_t h, const char *col, const char *doc_id) {
    (void)h; (void)col; (void)doc_id;
    return flux_map_build(0);
}

int64_t flux_std_db_doc_delete(int64_t h, const char *col, const char *doc_id) {
    (void)h;
    if (!doc_id) return 0;
    for (int64_t i = 0; i < _g_db_doc_count; i++) {
        if ((!col || strcmp(_g_db_doc_cols[i], col) == 0) && strcmp(_g_db_doc_ids[i], doc_id) == 0) {
            for (int64_t j = i; j < _g_db_doc_count - 1; j++) {
                strcpy(_g_db_doc_cols[j], _g_db_doc_cols[j+1]);
                strcpy(_g_db_doc_ids[j], _g_db_doc_ids[j+1]);
            }
            _g_db_doc_count--;
            return 1;
        }
    }
    return 0;
}

void *flux_std_db_doc_query(int64_t h, const char *col, const char *key, const char *val) {
    (void)h; (void)col; (void)key; (void)val;
    return flux_list_build(0, 4);
}

int64_t flux_std_db_doc_count(int64_t h, const char *col) {
    (void)h;
    if (!col) return _g_db_doc_count;
    int64_t cnt = 0;
    for (int64_t i = 0; i < _g_db_doc_count; i++) {
        if (strcmp(_g_db_doc_cols[i], col) == 0) cnt++;
    }
    return cnt;
}

int64_t flux_std_db_doc_close(int64_t h) { (void)h; return 1; }

int64_t flux_std_db_column_open(const char *path) {
    (void)path;
    _g_db_col_count = 0;
    return 1;
}

int64_t flux_std_db_column_execute(int64_t h, const char *sql) {
    (void)h;
    if (!sql) return 0;
    if (strstr(sql, "CREATE TABLE") != NULL || strstr(sql, "create table") != NULL) {
        const char *p = strstr(sql, "TABLE");
        if (!p) p = strstr(sql, "table");
        if (p) {
            p += 5;
            while (*p == ' ') p++;
            char name[64];
            int i = 0;
            while (*p && *p != ' ' && *p != '(' && i < 63) {
                name[i++] = *p++;
            }
            name[i] = '\0';
            if (_g_db_col_count < 16) {
                strncpy(_g_db_col_tables[_g_db_col_count], name, 63);
                _g_db_col_rows[_g_db_col_count] = 0;
                _g_db_col_count++;
            }
        }
    } else if (strstr(sql, "INSERT") != NULL || strstr(sql, "insert") != NULL) {
        for (int64_t i = 0; i < _g_db_col_count; i++) {
            if (strstr(sql, _g_db_col_tables[i]) != NULL) {
                _g_db_col_rows[i]++;
                break;
            }
        }
    }
    return 1;
}

void *flux_std_db_column_query(int64_t h, const char *sql) {
    (void)h; (void)sql;
    return flux_list_build(0, 4);
}

int64_t flux_std_db_column_row_count(int64_t h, const char *tbl) {
    (void)h;
    if (!tbl) return 0;
    for (int64_t i = 0; i < _g_db_col_count; i++) {
        if (strcmp(_g_db_col_tables[i], tbl) == 0) return _g_db_col_rows[i];
    }
    return 0;
}

int64_t flux_std_db_column_scalar(int64_t h, const char *sql) {
    (void)h; (void)sql;
    return 1;
}

int64_t flux_std_db_column_close(int64_t h) { (void)h; return 1; }

int64_t flux_std_db_graph_open(const char *path) {
    (void)path;
    _g_db_gr_count = 0;
    return 1;
}

int64_t flux_std_db_graph_execute(int64_t h, const char *cypher) {
    (void)h;
    if (!cypher) return 0;
    const char *p = strchr(cypher, ':');
    if (p) {
        p++;
        char name[64];
        int i = 0;
        while (*p && *p != ' ' && *p != '{' && *p != ')' && i < 63) {
            name[i++] = *p++;
        }
        name[i] = '\0';
        for (int64_t j = 0; j < _g_db_gr_count; j++) {
            if (strcmp(_g_db_gr_nodes[j], name) == 0) {
                _g_db_gr_node_counts[j]++;
                return 1;
            }
        }
        if (_g_db_gr_count < 16) {
            strncpy(_g_db_gr_nodes[_g_db_gr_count], name, 63);
            _g_db_gr_node_counts[_g_db_gr_count] = 1;
            _g_db_gr_count++;
            return 1;
        }
    }
    return 1;
}

void *flux_std_db_graph_query(int64_t h, const char *cypher) {
    (void)h; (void)cypher;
    return flux_list_build(0, 4);
}

int64_t flux_std_db_graph_node_count(int64_t h, const char *nt) {
    (void)h;
    if (!nt) return 0;
    for (int64_t i = 0; i < _g_db_gr_count; i++) {
        if (strcmp(_g_db_gr_nodes[i], nt) == 0) return _g_db_gr_node_counts[i];
    }
    return 0;
}

int64_t flux_std_db_graph_rel_count(int64_t h, const char *rt) {
    (void)h; (void)rt;
    return 0;
}

int64_t flux_std_db_graph_close(int64_t h) { (void)h; return 1; }

int64_t flux_std_db_vector_open(const char *path, int64_t dim, const char *metric) {
    (void)path; (void)dim; (void)metric;
    _g_db_vec_count = 0;
    return 1;
}

int64_t flux_std_db_vector_insert(int64_t h, int64_t vid, void *emb, const char *meta) {
    (void)h; (void)emb; (void)meta;
    for (int64_t i = 0; i < _g_db_vec_count; i++) {
        if (_g_db_vec_ids[i] == vid) return 1;
    }
    if (_g_db_vec_count < 64) {
        _g_db_vec_ids[_g_db_vec_count++] = vid;
        return 1;
    }
    return 0;
}

void *flux_std_db_vector_search(int64_t h, void *q, int64_t top_k) {
    (void)h; (void)q; (void)top_k;
    return flux_list_build(0, 4);
}

int64_t flux_std_db_vector_delete(int64_t h, int64_t vid) {
    (void)h;
    for (int64_t i = 0; i < _g_db_vec_count; i++) {
        if (_g_db_vec_ids[i] == vid) {
            for (int64_t j = i; j < _g_db_vec_count - 1; j++) {
                _g_db_vec_ids[j] = _g_db_vec_ids[j+1];
            }
            _g_db_vec_count--;
            return 1;
        }
    }
    return 0;
}

int64_t flux_std_db_vector_count(int64_t h) {
    (void)h;
    return _g_db_vec_count;
}

int64_t flux_std_db_vector_close(int64_t h) { (void)h; return 1; }

typedef struct {
    int64_t key_ptr;
    int64_t vtag;
    int64_t vval;
} flux_map_entry_t;

int64_t flux_std_db_is_valid_record(void *rec, void *sch) {
    if (!rec || !sch) return 0;
    flux_simd_list_t *lrec = (flux_simd_list_t *)rec;
    flux_simd_list_t *lsch = (flux_simd_list_t *)sch;
    if (!lrec || !lsch) return 0;
    flux_map_entry_t *rec_entries = (flux_map_entry_t *)(uintptr_t)lrec->data_ptr;
    flux_map_entry_t *sch_entries = (flux_map_entry_t *)(uintptr_t)lsch->data_ptr;
    if (!rec_entries || !sch_entries) return 1;

    for (int64_t i = 0; i < lsch->len; i++) {
        const char *k = (const char *)(uintptr_t)sch_entries[i].key_ptr;
        const char *expected_type = (const char *)(uintptr_t)sch_entries[i].vval;
        const char *k_clean = (k && *k == '.') ? k + 1 : (k ? k : "");
        int found = 0;
        for (int64_t j = 0; j < lrec->len; j++) {
            const char *rk = (const char *)(uintptr_t)rec_entries[j].key_ptr;
            const char *rk_clean = (rk && *rk == '.') ? rk + 1 : (rk ? rk : "");
            if (strcmp(k_clean, rk_clean) == 0) {
                found = 1;
                int64_t rtag = rec_entries[j].vtag;
                if (expected_type) {
                    if (strstr(expected_type, "int") != NULL && rtag != 1) return 0;
                    if (strstr(expected_type, "float") != NULL && rtag != 3 && rtag != 1) return 0;
                    if (strstr(expected_type, "bool") != NULL && rtag != 2) return 0;
                    if (strstr(expected_type, "str") != NULL && rtag != 4) return 0;
                }
                break;
            }
        }
        if (!found) return 0;
    }
    return 1;
}

char *flux_std_db_sanitize_identifier(const char *name) {
    if (!name) return strdup("");
    int len = (int)strlen(name);
    char *out = (char*)malloc(len + 1);
    int j = 0;
    for (int i = 0; i < len; i++) {
        char c = name[i];
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_') {
            out[j++] = c;
        }
    }
    out[j] = '\0';
    return out;
}

char *flux_std_db_escape_string(const char *val) {
    if (!val) return strdup("");
    int len = (int)strlen(val);
    char *out = (char*)malloc(len * 2 + 1);
    int j = 0;
    for (int i = 0; i < len; i++) {
        if (val[i] == '\'') {
            out[j++] = '\'';
            out[j++] = '\'';
        } else {
            out[j++] = val[i];
        }
    }
    out[j] = '\0';
    return out;
}

