#L ============================================================================
#L Algoritmo: Wavelet Tree (Consultas de Quantil e Frequência por Faixa)
#L Domínio: 02_data_structures / Categoria: Árvores de Intervalos e Compressão
#L Complexidade: Construção O(N log Σ) | Quantil / Rank O(log Σ)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (waveletNewPool) () as map {
      mut as list of int64: lows = [0]
      mut as list of int64: highs = [0]
      mut as list of int64: lefts = [0]
      mut as list of int64: rights = [0]
      mut as list of data: prefs = [[]]
      
      mut as map: pool = map{
            "lows": lows,
            "highs": highs,
            "lefts": lefts,
            "rights": rights,
            "prefs": prefs
      }
      emit(nice, pool, "ok")
}

function (waveletBuild) (as map: pool, as list of int64: arr, as int64: low, as int64: high) as list of data {
      mut as list of int64: lows = pool["lows"] as list of int64
      mut as list of int64: highs = pool["highs"] as list of int64
      mut as list of int64: lefts = pool["lefts"] as list of int64
      mut as list of int64: rights = pool["rights"] as list of int64
      mut as list of data: prefs = pool["prefs"] as list of data
      
      mut as int64: n = listLength(arr)
      route {
            low == high or n == 0 ==> {
                  lows = listPushBack(lows, low)
                  highs = listPushBack(highs, high)
                  lefts = listPushBack(lefts, 0)
                  rights = listPushBack(rights, 0)
                  prefs = listPushBack(prefs, [0])
                  
                  mut as int64: leaf_id = listLength(lows)
                  mut as map: p_leaf = map{
                        "lows": lows, "highs": highs, "lefts": lefts, "rights": rights, "prefs": prefs
                  }
                  mut as list of data: ret_leaf = [leaf_id, p_leaf]
                  emit(nice, ret_leaf, "leaf")
            }
            _ ==> {
                  mut as int64: mid = (low + high) /i 2
                  mut as list of int64: b_pref = [0]
                  mut as list of int64: left_arr = []
                  mut as list of int64: right_arr = []
                  
                  mut as int64: count_left = 0
                  mut as int64: i = 1
                  infinite (i <= n) {
                        mut as int64: val = arr[i]
                        route {
                              val <= mid ==> {
                                    count_left = count_left + 1
                                    left_arr = listPushBack(left_arr, val)
                              }
                              _ ==> {
                                    right_arr = listPushBack(right_arr, val)
                              }
                        }
                        b_pref = listPushBack(b_pref, count_left)
                        i = i + 1
                  }
                  
                  #L Cria nó atual provisório
                  lows = listPushBack(lows, low)
                  highs = listPushBack(highs, high)
                  lefts = listPushBack(lefts, 0)
                  rights = listPushBack(rights, 0)
                  prefs = listPushBack(prefs, b_pref)
                  mut as int64: cur_node = listLength(lows)
                  
                  mut as map: cur_pool = map{
                        "lows": lows, "highs": highs, "lefts": lefts, "rights": rights, "prefs": prefs
                  }
                  
                  #L Constrói subárvore esquerda
                  mut as list of data: l_res = waveletBuild(cur_pool, left_arr, low, mid)
                  mut as int64: l_child = l_res[1] as int64
                  mut as map: p1 = l_res[2] as map
                  
                  #L Constrói subárvore direita
                  mut as list of data: r_res = waveletBuild(p1, right_arr, mid + 1, high)
                  mut as int64: r_child = r_res[1] as int64
                  mut as map: p2 = r_res[2] as map
                  
                  #L Atualiza ponteiros de filhos no nó atual
                  mut as list of int64: final_lefts = p2["lefts"] as list of int64
                  mut as list of int64: final_rights = p2["rights"] as list of int64
                  final_lefts[cur_node] = l_child
                  final_rights[cur_node] = r_child
                  p2["lefts"] = final_lefts
                  p2["rights"] = final_rights
                  
                  mut as list of data: ret_node = [cur_node, p2]
                  emit(nice, ret_node, "ok")
            }
      }
}

function (waveletKth) (as map: pool, as int64: node_id, as int64: ql, as int64: qr, as int64: k) as int64 {
      mut as list of int64: lows = pool["lows"] as list of int64
      mut as list of int64: highs = pool["highs"] as list of int64
      mut as int64: low = lows[node_id]
      mut as int64: high = highs[node_id]
      
      route {
            low == high ==> {
                  emit(nice, low, "found")
            }
            _ ==> {
                  mut as list of data: prefs = pool["prefs"] as list of data
                  mut as list of int64: b_pref = prefs[node_id] as list of int64
                  mut as list of int64: lefts = pool["lefts"] as list of int64
                  mut as list of int64: rights = pool["rights"] as list of int64
                  
                  #L Contagem de elementos que foram para a esquerda em [ql..qr]
                  #L Note que b_pref possui 0 no índice 1, então b_pref[pos + 1] guarda pref[pos]
                  mut as int64: count_l = b_pref[qr + 1] - b_pref[ql]
                  
                  route {
                        k <= count_l ==> {
                              mut as int64: new_ql = b_pref[ql] + 1
                              mut as int64: new_qr = b_pref[qr + 1]
                              mut as int64: ans = waveletKth(pool, lefts[node_id], new_ql, new_qr, k)
                              emit(nice, ans, "left")
                        }
                        _ ==> {
                              mut as int64: new_ql = ql - b_pref[ql]
                              mut as int64: new_qr = qr - b_pref[qr + 1]
                              mut as int64: new_k = k - count_l
                              mut as int64: ans = waveletKth(pool, rights[node_id], new_ql, new_qr, new_k)
                              emit(nice, ans, "right")
                        }
                  }
            }
      }
}

function (waveletCount) (as map: pool, as int64: node_id, as int64: ql, as int64: qr, as int64: target) as int64 {
      mut as list of int64: lows = pool["lows"] as list of int64
      mut as list of int64: highs = pool["highs"] as list of int64
      mut as int64: low = lows[node_id]
      mut as int64: high = highs[node_id]
      
      route {
            target < low or target > high ==> {
                  mut as int64: zero = 0
                  emit(nice, zero, "out")
            }
            low == high ==> {
                  mut as int64: cnt = qr - ql + 1
                  emit(nice, cnt, "exact")
            }
            _ ==> {
                  mut as int64: mid = (low + high) /i 2
                  mut as list of data: prefs = pool["prefs"] as list of data
                  mut as list of int64: b_pref = prefs[node_id] as list of int64
                  mut as list of int64: lefts = pool["lefts"] as list of int64
                  mut as list of int64: rights = pool["rights"] as list of int64
                  
                  route {
                        target <= mid ==> {
                              mut as int64: new_ql = b_pref[ql] + 1
                              mut as int64: new_qr = b_pref[qr + 1]
                              route {
                                    new_ql > new_qr ==> {
                                          mut as int64: zero = 0
                                          emit(nice, zero, "none")
                                    }
                                    _ ==> {
                                          mut as int64: ans = waveletCount(pool, lefts[node_id], new_ql, new_qr, target)
                                          emit(nice, ans, "left")
                                    }
                              }
                        }
                        _ ==> {
                              mut as int64: new_ql = ql - b_pref[ql]
                              mut as int64: new_qr = qr - b_pref[qr + 1]
                              route {
                                    new_ql > new_qr ==> {
                                          mut as int64: zero = 0
                                          emit(nice, zero, "none")
                                    }
                                    _ ==> {
                                          mut as int64: ans = waveletCount(pool, rights[node_id], new_ql, new_qr, target)
                                          emit(nice, ans, "right")
                                    }
                              }
                        }
                  }
            }
      }
}

program (ExampleOfEstruturasDeDadosBasicasWaveletTree) {
      println("==================================================")
      println("  SciAlgo: Wavelet Tree (Quantil & Contagem)")
      println("==================================================")

      mut as list of int64: dados = [4, 2, 7, 1, 5, 3, 6, 2]
      mut as int64: n = listLength(dados)
      println("1. Vetor de entrada: " + dados)

      mut as map: pool = waveletNewPool()
      #L Alfabeto de valores de 1 a 7
      mut as list of data: build_res = waveletBuild(pool, dados, 1, 7)
      mut as int64: root_id = build_res[1] as int64
      pool = build_res[2] as map
      println("2. Wavelet Tree construida com sucesso (Raiz: " + root_id + ")")

      #L Consultas de k-ésimo menor elemento
      mut as int64: k1 = waveletKth(pool, root_id, 1, 8, 1)
      mut as int64: k2 = waveletKth(pool, root_id, 1, 8, 2)
      mut as int64: k5 = waveletKth(pool, root_id, 1, 8, 5)
      println("3. Consultas de Quantil no array inteiro [1..8]:")
      println("   1o menor (esperado 1): " + k1)
      println("   2o menor (esperado 2): " + k2)
      println("   5o menor (esperado 4): " + k5)

      #L Consulta de k-ésimo em subfaixa [3..7] -> dados: [7, 1, 5, 3, 6] -> ordenado: [1, 3, 5, 6, 7]
      mut as int64: sub_k3 = waveletKth(pool, root_id, 3, 7, 3)
      println("4. 3o menor na subfaixa [3..7] (esperado 5): " + sub_k3)

      #L Consultas de contagem de frequência (Rank)
      mut as int64: cnt2_tot = waveletCount(pool, root_id, 1, 8, 2)
      mut as int64: cnt2_sub = waveletCount(pool, root_id, 3, 7, 2)
      println("5. Frequencia do valor 2:")
      println("   Em [1..8] (esperado 2): " + cnt2_tot)
      println("   Em [3..7] (esperado 0): " + cnt2_sub)

      mut as bool: ok = (k1 == 1) and (k2 == 2) and (k5 == 4) and (sub_k3 == 5) and (cnt2_tot == 2) and (cnt2_sub == 0)
      println("6. Verificacao da Wavelet Tree: " + ok)
      println("==================================================")
}
