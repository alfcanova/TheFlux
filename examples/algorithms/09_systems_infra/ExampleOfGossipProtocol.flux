#L ============================================================================
#L Algoritmo: Protocolo de Fofoca (Gossip Protocol / Anti-Entropy Epidemic)
#L Domínio: 09_systems_infra / Categoria: Comunicação P2P e Consistência Eventual
#L Complexidade: O(log N) rodadas para disseminação completa em N nós
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGossipProtocol) {
      println("==================================================")
      println("  SciAlgo: Protocolo de Fofoca (Anti-Entropy P2P)")
      println("==================================================")

      mut as int64: n = 5
      #L Matrizes achatadas de estado: 5 nós x 5 chaves = 25 células
      mut as list of int64: values = []
      mut as list of int64: versions = []
      mut as int64: c_idx = 1
      infinite (c_idx <= 25) {
            values = listPushBack(values, 0)
            versions = listPushBack(versions, 0)
            c_idx = c_idx + 1
      }

      #L Evento Inicial (Rodada 0):
      #L No 1 define chave 1 com valor 999 e versao 1
      values[(1 - 1) * n + 1] = 999
      versions[(1 - 1) * n + 1] = 1

      #L No 3 define chave 3 com valor 777 e versao 1
      values[(3 - 1) * n + 3] = 777
      versions[(3 - 1) * n + 3] = 1

      println("1. Estado inicial dos nós configurado (No 1 tem k1=999, No 3 tem k3=777)")

      #L ----------------------------------------------------
      #L Rodadas de Fofoca Epidêmica (Troca Push-Pull)
      #L ----------------------------------------------------
      #L Rodada 1: pares (1, 2), (3, 4), (5, 1)
      mut as list of int64: r1_u = [1, 3, 5]
      mut as list of int64: r1_v = [2, 4, 1]

      #L Rodada 2: pares (2, 3), (4, 5), (1, 3)
      mut as list of int64: r2_u = [2, 4, 1]
      mut as list of int64: r2_v = [3, 5, 3]

      #L Rodada 3: pares (1, 4), (2, 5), (3, 5)
      mut as list of int64: r3_u = [1, 2, 3]
      mut as list of int64: r3_v = [4, 5, 5]

      mut as int64: round = 1
      infinite (round <= 3) {
            mut as list of int64: p_u = r1_u
            mut as list of int64: p_v = r1_v
            route {
                  round == 2 ==> {
                        p_u = r2_u
                        p_v = r2_v
                  }
                  round == 3 ==> {
                        p_u = r3_u
                        p_v = r3_v
                  }
            }

            mut as int64: num_pairs = listLength(p_u)
            mut as int64: pi = 1
            infinite (pi <= num_pairs) {
                  mut as int64: u = p_u[pi]
                  mut as int64: v = p_v[pi]

                  #L Troca anti-entropia completa entre u e v para todas as chaves
                  mut as int64: k = 1
                  infinite (k <= n) {
                        mut as int64: idx_u = (u - 1) * n + k
                        mut as int64: idx_v = (v - 1) * n + k
                        mut as int64: ver_u = versions[idx_u]
                        mut as int64: ver_v = versions[idx_v]

                        route {
                              ver_u > ver_v ==> {
                                    versions[idx_v] = ver_u
                                    values[idx_v] = values[idx_u]
                              }
                              ver_v > ver_u ==> {
                                    versions[idx_u] = ver_v
                                    values[idx_u] = values[idx_v]
                              }
                        }
                        k = k + 1
                  }
                  pi = pi + 1
            }
            round = round + 1
      }

      #L ----------------------------------------------------
      #L Verificação de Convergência Global
      #L ----------------------------------------------------
      mut as bool: todos_convergem = true
      mut as int64: nid = 1
      infinite (nid <= n) {
            mut as int64: val_k1 = values[(nid - 1) * n + 1]
            mut as int64: ver_k1 = versions[(nid - 1) * n + 1]
            mut as int64: val_k3 = values[(nid - 1) * n + 3]
            mut as int64: ver_k3 = versions[(nid - 1) * n + 3]

            route {
                  (val_k1 != 999) or (ver_k1 != 1) ==> {
                        todos_convergem = false
                  }
                  (val_k3 != 777) or (ver_k3 != 1) ==> {
                        todos_convergem = false
                  }
            }
            nid = nid + 1
      }

      println("2. Todos os 5 nos convergiram para k1=999 e k3=777: " + todos_convergem)

      #L ----------------------------------------------------
      #L Atualizacao Dinamica com Sobrescrita de Versao Mais Recente
      #L ----------------------------------------------------
      #L No 2 atualiza k1 para valor 1000 com versao 2 (substituindo 999)
      values[(2 - 1) * n + 1] = 1000
      versions[(2 - 1) * n + 1] = 2

      #L No 5 atualiza k5 para valor 555 com versao 1
      values[(5 - 1) * n + 5] = 555
      versions[(5 - 1) * n + 5] = 1

      #L Mais 2 rodadas de fofoca para propagar a nova versao
      round = 1
      infinite (round <= 2) {
            mut as list of int64: p_u = r1_u
            mut as list of int64: p_v = r1_v
            route {
                  round == 2 ==> {
                        p_u = r2_u
                        p_v = r2_v
                  }
            }
            mut as int64: num_pairs = listLength(p_u)
            mut as int64: pi = 1
            infinite (pi <= num_pairs) {
                  mut as int64: u = p_u[pi]
                  mut as int64: v = p_v[pi]

                  mut as int64: k = 1
                  infinite (k <= n) {
                        mut as int64: idx_u = (u - 1) * n + k
                        mut as int64: idx_v = (v - 1) * n + k
                        mut as int64: ver_u = versions[idx_u]
                        mut as int64: ver_v = versions[idx_v]

                        route {
                              ver_u > ver_v ==> {
                                    versions[idx_v] = ver_u
                                    values[idx_v] = values[idx_u]
                              }
                              ver_v > ver_u ==> {
                                    versions[idx_u] = ver_v
                                    values[idx_u] = values[idx_v]
                              }
                        }
                        k = k + 1
                  }
                  pi = pi + 1
            }
            round = round + 1
      }

      #L Verifica se todos aprenderam a versao mais recente (k1=1000, ver 2)
      mut as bool: nova_versao_convergiu = true
      nid = 1
      infinite (nid <= n) {
            mut as int64: val_k1 = values[(nid - 1) * n + 1]
            mut as int64: ver_k1 = versions[(nid - 1) * n + 1]
            mut as int64: val_k5 = values[(nid - 1) * n + 5]
            mut as int64: ver_k5 = versions[(nid - 1) * n + 5]

            route {
                  (val_k1 != 1000) or (ver_k1 != 2) ==> {
                        nova_versao_convergiu = false
                  }
                  (val_k5 != 555) or (ver_k5 != 1) ==> {
                        nova_versao_convergiu = false
                  }
            }
            nid = nid + 1
      }

      println("3. Nova versao (k1=1000 v2 e k5=555 v1) propagou globalmente: " + nova_versao_convergiu)
      println("4. Verificacao de corretude do Gossip Protocol: " + (todos_convergem and nova_versao_convergiu))
      println("==================================================")
}
