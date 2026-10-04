#L ============================================================================
#L Algoritmo: Mo's Algorithm with Modifications (Mo 3D com Atualizacoes)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N^(5/3)) tempo | O(N + Q + U) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysMosAlgorithmWithModifications) {
      println("==================================================")
      println("  SciAlgo: 3D Mo's Algorithm with Modifications")
      println("==================================================")

      #L Array inicial de tamanho N = 6
      mut as list of int64: arr = [1, 2, 3, 4, 5, 2]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Historico de atualizacoes pontuais:
      #L U1: atualiza indice 3 (valor antigo 3 -> novo 1)
      #L U2: atualiza indice 5 (valor antigo 5 -> novo 2)
      mut as list of int64: u_pos = [3, 5]
      mut as list of int64: u_old = [3, 5]
      mut as list of int64: u_new = [1, 2]
      mut as int64: num_u = 2

      #L Consultas no espaco tridimensional (L, R, Tempo):
      #L Q1 = [1, 4] no instante T = 0
      #L Q2 = [1, 4] no instante T = 1
      #L Q3 = [2, 6] no instante T = 2
      mut as list of int64: q_l = [1, 1, 2]
      mut as list of int64: q_r = [4, 4, 6]
      mut as list of int64: q_t = [0, 1, 2]
      mut as list of int64: q_id = [1, 2, 3]
      mut as int64: num_q = 3

      #L Bloco tridimensional B = ceil(N^(2/3)) ~ 3
      mut as int64: b = 3

      #L Frequencias de elementos (universo 1..5) e contador de distintos
      mut as list of int64: freq = [0, 0, 0, 0, 0, 0]
      mut as int64: distinct = 0

      mut as int64: cur_l = 1
      mut as int64: cur_r = 0
      mut as int64: cur_t = 0
      mut as list of int64: ans = [0, 0, 0, 0]

      mut as int64: qi = 1
      infinite (qi <= num_q) {
            mut as int64: tl = q_l[qi]
            mut as int64: tr = q_r[qi]
            mut as int64: tt = q_t[qi]

            #L Ajusta ponteiro temporal (Time travel para frente)
            infinite (cur_t < tt) {
                  cur_t = cur_t + 1
                  mut as int64: p = u_pos[cur_t]
                  mut as int64: nv = u_new[cur_t]
                  mut as int64: ov = arr[p]

                  #L Se a posicao modificada estiver dentro da janela ativa, atualiza frequencias
                  route {
                        p >= cur_l and p <= cur_r ==> {
                              freq[ov] = freq[ov] - 1
                              route {
                                    freq[ov] == 0 ==> {
                                          distinct = distinct - 1
                                    }
                                    _ ==> {
                                    }
                              }

                              route {
                                    freq[nv] == 0 ==> {
                                          distinct = distinct + 1
                                    }
                                    _ ==> {
                                    }
                              }
                              freq[nv] = freq[nv] + 1
                        }
                        _ ==> {
                        }
                  }
                  arr[p] = nv
            }

            #L Ajusta ponteiro temporal (Time travel para tras)
            infinite (cur_t > tt) {
                  mut as int64: p2 = u_pos[cur_t]
                  mut as int64: ov2 = u_old[cur_t]
                  mut as int64: nv2 = arr[p2]

                  route {
                        p2 >= cur_l and p2 <= cur_r ==> {
                              freq[nv2] = freq[nv2] - 1
                              route {
                                    freq[nv2] == 0 ==> {
                                          distinct = distinct - 1
                                    }
                                    _ ==> {
                                    }
                              }

                              route {
                                    freq[ov2] == 0 ==> {
                                          distinct = distinct + 1
                                    }
                                    _ ==> {
                                    }
                              }
                              freq[ov2] = freq[ov2] + 1
                        }
                        _ ==> {
                        }
                  }
                  arr[p2] = ov2
                  cur_t = cur_t - 1
            }

            #L Ajusta cur_r
            infinite (cur_r < tr) {
                  cur_r = cur_r + 1
                  mut as int64: v_add = arr[cur_r]
                  route {
                        freq[v_add] == 0 ==> {
                              distinct = distinct + 1
                        }
                        _ ==> {
                        }
                  }
                  freq[v_add] = freq[v_add] + 1
            }
            infinite (cur_r > tr) {
                  mut as int64: v_sub = arr[cur_r]
                  freq[v_sub] = freq[v_sub] - 1
                  route {
                        freq[v_sub] == 0 ==> {
                              distinct = distinct - 1
                        }
                        _ ==> {
                        }
                  }
                  cur_r = cur_r - 1
            }

            #L Ajusta cur_l
            infinite (cur_l > tl) {
                  cur_l = cur_l - 1
                  mut as int64: vl_add = arr[cur_l]
                  route {
                        freq[vl_add] == 0 ==> {
                              distinct = distinct + 1
                        }
                        _ ==> {
                        }
                  }
                  freq[vl_add] = freq[vl_add] + 1
            }
            infinite (cur_l < tl) {
                  mut as int64: vl_sub = arr[cur_l]
                  freq[vl_sub] = freq[vl_sub] - 1
                  route {
                        freq[vl_sub] == 0 ==> {
                              distinct = distinct - 1
                        }
                        _ ==> {
                        }
                  }
                  cur_l = cur_l + 1
            }

            ans[q_id[qi]] = distinct
            qi = qi + 1
      }

      println("2. Resultados Mo 3D (distintos por janela e tempo):")
      println("   Q1 [1..4] em T=0: " + ans[1] + " distintos (esperado: 4 -> [1, 2, 3, 4])")
      println("   Q2 [1..4] em T=1: " + ans[2] + " distintos (esperado: 3 -> [1, 2, 1, 4])")
      println("   Q3 [2..6] em T=2: " + ans[3] + " distintos (esperado: 3 -> [2, 1, 4, 2, 2])")
}
