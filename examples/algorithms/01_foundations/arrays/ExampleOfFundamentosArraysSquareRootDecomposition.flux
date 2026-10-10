#L ============================================================================
#L Algoritmo: Square-Root Decomposition (Decomposicao em Raiz Quadrada)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(1) atualizacao | O(sqrt(N)) consulta de soma/minimo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysSquareRootDecomposition) {
      println("==================================================")
      println("  SciAlgo: Square-Root Decomposition")
      println("==================================================")

      mut as list of int64: arr = [1, 5, 2, 4, 6, 1, 3, 5, 7]
      mut as int64: n = listLength(arr)
      mut as int64: b_size = 3
      mut as int64: num_blocks = 3

      println("1. Array original (N = " + n + ", Bloco B = " + b_size + "): " + arr)

      #L Pre-computacao dos blocos: soma e minimo
      mut as list of int64: b_sum = [0, 0, 0]
      mut as list of int64: b_min = [999999, 999999, 999999]

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: b_id = ((i - 1) /i b_size) + 1
            b_sum[b_id] = b_sum[b_id] + arr[i]
            route {
                  arr[i] < b_min[b_id] ==> {
                        b_min[b_id] = arr[i]
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("2. Sumario inicial dos blocos:")
      println("   Somas dos blocos:   " + b_sum)
      println("   Minimos dos blocos: " + b_min)

      #L Consulta de soma e minimo no intervalo [2..8]
      mut as int64: ql = 2
      mut as int64: qr = 8
      mut as int64: query_sum = 0
      mut as int64: query_min = 999999

      mut as int64: idx = ql
      infinite (idx <= qr) {
            #L Se estiver no inicio de um bloco inteiro contido no intervalo, salta o bloco
            route {
                  ((idx - 1) /r b_size == 0) and (idx + b_size - 1 <= qr) ==> {
                        mut as int64: blk = ((idx - 1) /i b_size) + 1
                        query_sum = query_sum + b_sum[blk]
                        route {
                              b_min[blk] < query_min ==> {
                                    query_min = b_min[blk]
                              }
                              _ ==> {
                              }
                        }
                        idx = idx + b_size
                  }
                  _ ==> {
                        query_sum = query_sum + arr[idx]
                        route {
                              arr[idx] < query_min ==> {
                                    query_min = arr[idx]
                              }
                              _ ==> {
                              }
                        }
                        idx = idx + 1
                  }
            }
      }

      println("3. Consulta [2..8] antes da atualizacao:")
      println("   Soma: " + query_sum + " (esperado: 26)")
      println("   Minimo: " + query_min + " (esperado: 1)")

      #L Atualizacao pontual: indice 5 (valor 6 -> 0)
      mut as int64: up_idx = 5
      mut as int64: new_val = 0
      mut as int64: old_val = arr[up_idx]
      arr[up_idx] = new_val

      #L Atualiza sumario do bloco
      mut as int64: u_blk = ((up_idx - 1) /i b_size) + 1
      b_sum[u_blk] = b_sum[u_blk] - old_val + new_val

      #L Recalcula o minimo do bloco modificado
      b_min[u_blk] = 999999
      mut as int64: s_idx = (u_blk - 1) * b_size + 1
      mut as int64: e_idx = s_idx + b_size - 1
      infinite (s_idx <= e_idx) {
            route {
                  arr[s_idx] < b_min[u_blk] ==> {
                        b_min[u_blk] = arr[s_idx]
                  }
                  _ ==> {
                  }
            }
            s_idx = s_idx + 1
      }

      println("4. Atualizacao pontual realizada no indice " + up_idx + ": " + old_val + " -> " + new_val)

      #L Repete a consulta [2..8]
      query_sum = 0
      query_min = 999999
      idx = ql
      infinite (idx <= qr) {
            route {
                  ((idx - 1) /r b_size == 0) and (idx + b_size - 1 <= qr) ==> {
                        mut as int64: blk2 = ((idx - 1) /i b_size) + 1
                        query_sum = query_sum + b_sum[blk2]
                        route {
                              b_min[blk2] < query_min ==> {
                                    query_min = b_min[blk2]
                              }
                              _ ==> {
                              }
                        }
                        idx = idx + b_size
                  }
                  _ ==> {
                        query_sum = query_sum + arr[idx]
                        route {
                              arr[idx] < query_min ==> {
                                    query_min = arr[idx]
                              }
                              _ ==> {
                              }
                        }
                        idx = idx + 1
                  }
            }
      }

      println("5. Consulta [2..8] apos a atualizacao:")
      println("   Nova Soma: " + query_sum + " (esperado: 20)")
      println("   Novo Minimo: " + query_min + " (esperado: 0)")
}
