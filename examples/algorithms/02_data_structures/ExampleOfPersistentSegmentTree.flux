#L ============================================================================
#L Algoritmo: Persistent Segment Tree (Árvore de Segmentos com Versões)
#L Domínio: 02_data_structures / Categoria: Árvores de Segmentos e Intervalos
#L Complexidade: Construção O(N) | Atualização O(log N) | Consulta O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (poolNew) () as map {
      mut as list of int64: vals = [0]
      mut as list of int64: lefts = [0]
      mut as list of int64: rights = [0]
      mut as map: pool = map{
            "vals": vals,
            "lefts": lefts,
            "rights": rights
      }
      emit(nice, pool, "ok")
}

function (createNode) (as map: pool, as int64: val, as int64: left_id, as int64: right_id) as list of data {
      mut as list of int64: vals = pool["vals"] as list of int64
      mut as list of int64: lefts = pool["lefts"] as list of int64
      mut as list of int64: rights = pool["rights"] as list of int64
      
      vals = listPushBack(vals, val)
      lefts = listPushBack(lefts, left_id)
      rights = listPushBack(rights, right_id)
      
      mut as int64: new_id = listLength(vals)
      mut as map: new_pool = map{
            "vals": vals,
            "lefts": lefts,
            "rights": rights
      }
      mut as list of data: ret = [new_id, new_pool]
      emit(nice, ret, "ok")
}

function (buildTree) (as map: pool, as list of int64: arr, as int64: l, as int64: r) as list of data {
      route {
            l == r ==> {
                  mut as list of data: leaf_res = createNode(pool, arr[l], 0, 0)
                  emit(nice, leaf_res, "ok")
            }
            _ ==> {
                  mut as int64: mid = (l + r) /i 2
                  mut as list of data: l_res = buildTree(pool, arr, l, mid)
                  mut as int64: l_id = l_res[1] as int64
                  mut as map: p1 = l_res[2] as map
                  
                  mut as list of data: r_res = buildTree(p1, arr, mid + 1, r)
                  mut as int64: r_id = r_res[1] as int64
                  mut as map: p2 = r_res[2] as map
                  
                  mut as list of int64: v_arr = p2["vals"] as list of int64
                  mut as int64: total = v_arr[l_id] + v_arr[r_id]
                  
                  mut as list of data: parent_res = createNode(p2, total, l_id, r_id)
                  emit(nice, parent_res, "ok")
            }
      }
}

function (updatePoint) (as map: pool, as int64: node_id, as int64: l, as int64: r, as int64: pos, as int64: new_val) as list of data {
      route {
            l == r ==> {
                  mut as list of data: leaf_res = createNode(pool, new_val, 0, 0)
                  emit(nice, leaf_res, "ok")
            }
            _ ==> {
                  mut as int64: mid = (l + r) /i 2
                  mut as list of int64: lefts = pool["lefts"] as list of int64
                  mut as list of int64: rights = pool["rights"] as list of int64
                  mut as int64: cur_l = lefts[node_id]
                  mut as int64: cur_r = rights[node_id]
                  
                  route {
                        pos <= mid ==> {
                              mut as list of data: up_l_res = updatePoint(pool, cur_l, l, mid, pos, new_val)
                              mut as int64: new_l_id = up_l_res[1] as int64
                              mut as map: p1 = up_l_res[2] as map
                              
                              mut as list of int64: v_arr = p1["vals"] as list of int64
                              mut as int64: sum_val = v_arr[new_l_id] + v_arr[cur_r]
                              
                              mut as list of data: parent_res = createNode(p1, sum_val, new_l_id, cur_r)
                              emit(nice, parent_res, "ok")
                        }
                        _ ==> {
                              mut as list of data: up_r_res = updatePoint(pool, cur_r, mid + 1, r, pos, new_val)
                              mut as int64: new_r_id = up_r_res[1] as int64
                              mut as map: p1 = up_r_res[2] as map
                              
                              mut as list of int64: v_arr = p1["vals"] as list of int64
                              mut as int64: sum_val = v_arr[cur_l] + v_arr[new_r_id]
                              
                              mut as list of data: parent_res = createNode(p1, sum_val, cur_l, new_r_id)
                              emit(nice, parent_res, "ok")
                        }
                  }
            }
      }
}

function (querySum) (as map: pool, as int64: node_id, as int64: l, as int64: r, as int64: ql, as int64: qr) as int64 {
      route {
            ql > r or qr < l ==> {
                  mut as int64: zero = 0
                  emit(nice, zero, "zero")
            }
            ql <= l and r <= qr ==> {
                  mut as list of int64: vals = pool["vals"] as list of int64
                  mut as int64: ans = vals[node_id]
                  emit(nice, ans, "ok")
            }
            _ ==> {
                  mut as int64: mid = (l + r) /i 2
                  mut as list of int64: lefts = pool["lefts"] as list of int64
                  mut as list of int64: rights = pool["rights"] as list of int64
                  
                  mut as int64: ans_l = querySum(pool, lefts[node_id], l, mid, ql, qr)
                  mut as int64: ans_r = querySum(pool, rights[node_id], mid + 1, r, ql, qr)
                  mut as int64: total = ans_l + ans_r
                  emit(nice, total, "ok")
            }
      }
}

program (ExampleOfPersistentSegmentTree) {
      println("==================================================")
      println("  SciAlgo: Persistent Segment Tree (Versionada)")
      println("==================================================")

      mut as map: pool = poolNew()
      mut as list of int64: base = [10, 20, 30, 40, 50]
      mut as int64: n = listLength(base)
      println("1. Vetor base (V0): " + base)

      #L Versão 0: Construção
      mut as list of data: b_res = buildTree(pool, base, 1, n)
      mut as int64: root_v0 = b_res[1] as int64
      pool = b_res[2] as map
      println("2. Arvore construida (Root V0 = " + root_v0 + ")")

      mut as int64: sum_v0_total = querySum(pool, root_v0, 1, n, 1, 5)
      mut as int64: sum_v0_sub = querySum(pool, root_v0, 1, n, 2, 4)
      println("   V0 Soma total [1..5]: " + sum_v0_total)
      println("   V0 Soma subfaixa [2..4]: " + sum_v0_sub)

      #L Versão 1: Atualização em ponto (pos 3 -> 100) a partir de V0
      println("3. Atualizando posicao 3 com valor 100 (Gerando V1)...")
      mut as list of data: up1_res = updatePoint(pool, root_v0, 1, n, 3, 100)
      mut as int64: root_v1 = up1_res[1] as int64
      pool = up1_res[2] as map

      mut as int64: sum_v1_total = querySum(pool, root_v1, 1, n, 1, 5)
      mut as int64: sum_v1_sub = querySum(pool, root_v1, 1, n, 2, 4)
      println("   V1 (Root " + root_v1 + ") Soma total [1..5]: " + sum_v1_total)
      println("   V1 (Root " + root_v1 + ") Soma subfaixa [2..4]: " + sum_v1_sub)

      #L Verificação de Imutabilidade da Versão 0
      mut as int64: sum_v0_recheck = querySum(pool, root_v0, 1, n, 2, 4)
      println("4. Rechecagem V0 subfaixa [2..4] (imutavel): " + sum_v0_recheck)

      #L Versão 2: Atualização em ponto (pos 1 -> 500) a partir de V1
      println("5. Atualizando posicao 1 com valor 500 a partir de V1 (Gerando V2)...")
      mut as list of data: up2_res = updatePoint(pool, root_v1, 1, n, 1, 500)
      mut as int64: root_v2 = up2_res[1] as int64
      pool = up2_res[2] as map

      mut as int64: sum_v2_total = querySum(pool, root_v2, 1, n, 1, 5)
      println("   V2 (Root " + root_v2 + ") Soma total [1..5]: " + sum_v2_total)

      mut as bool: ok = (sum_v0_sub == 90) and (sum_v1_sub == 160) and (sum_v0_recheck == 90) and (sum_v2_total == 710)
      println("6. Verificacao de integridade das versoes: " + ok)
      println("==================================================")
}
