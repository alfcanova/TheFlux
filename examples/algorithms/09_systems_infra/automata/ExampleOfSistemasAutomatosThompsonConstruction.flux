#L ============================================================================
#L Algoritmo: Thompson Construction (Regex para Epsilon-NFA)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(|Regex|) estados e transicoes lineares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosThompsonConstruction) {
      println("==================================================")
      println("  SciAlgo: Thompson Construction (Regex -> NFA)   ")
      println("==================================================")

      #L Construcao de Ken Thompson (1968) para expressao: (a | b) . c
      #L Simbolos: 0 = epsilon, 1 = 'a', 2 = 'b', 3 = 'c'
      #L Estados gerados: 1 a 8
      #L Gadgets de Thompson:
      #L - Literal 'a': 1 --a--> 2
      #L - Literal 'b': 3 --b--> 4
      #L - Uniao (a | b): novo inicio 5 --eps--> 1, 5 --eps--> 3; 2 --eps--> 6, 4 --eps--> 6
      #L - Literal 'c': 7 --c--> 8
      #L - Concatenacao: 6 --eps--> 7
      #L Estado Inicial Global: 5
      #L Estado Final Global: 8

      mut as int64: num_states = 8
      mut as int64: max_trans = 10

      #L Armazenamos transicoes como triplas (origem, simbolo, destino)
      mut as list of int64: edge_u = [1, 3, 5, 5, 2, 4, 7, 6, 0, 0]
      mut as list of int64: edge_sym = [1, 2, 0, 0, 0, 0, 3, 0, 0, 0]
      mut as list of int64: edge_v = [2, 4, 1, 3, 6, 6, 8, 7, 0, 0]
      mut as int64: total_edges = 8

      println("1. Regex Alvo: (a | b) . c")
      println("   Total de Estados NFA: " + num_states)
      println("   Estado Inicial: 5 | Estado Aceitacao: 8")
      println("   Transicoes do NFA de Thompson (0 = epsilon):")

      mut as int64: e = 1
      infinite (e <= total_edges) {
            mut as int64: u = edge_u[e]
            mut as int64: sym = edge_sym[e]
            mut as int64: v = edge_v[e]
            mut as string: sym_str = "eps"
            route {
                  sym == 1 ==> { sym_str = "'a'" }
                  sym == 2 ==> { sym_str = "'b'" }
                  sym == 3 ==> { sym_str = "'c'" }
                  _ ==> {}
            }
            println("   Transição " + e + ": Estado " + u + " -- " + sym_str + " --> Estado " + v)
            e = e + 1
      }

      #L Funcao/Rotina de Epsilon-Closure via alcance transitivo em matriz
      #L reach_eps[u, v] = true se existe caminho epsilon de u para v
      mut as list of bool: reach_eps = [
            true, false, false, false, false, false, false, false,
            false, true, false, false, false, false, false, false,
            false, false, true, false, false, false, false, false,
            false, false, false, true, false, false, false, false,
            false, false, false, false, true, false, false, false,
            false, false, false, false, false, true, false, false,
            false, false, false, false, false, false, true, false,
            false, false, false, false, false, false, false, true
      ]

      #L Adiciona arestas epsilon diretas
      e = 1
      infinite (e <= total_edges) {
            route {
                  edge_sym[e] == 0 ==> {
                        mut as int64: eu = edge_u[e]
                        mut as int64: ev = edge_v[e]
                        reach_eps[(eu - 1) * 8 + ev] = true
                  }
                  _ ==> {}
            }
            e = e + 1
      }

      #L Fecho transitivo de Warshall para epsilon
      mut as int64: k = 1
      infinite (k <= 8) {
            mut as int64: i = 1
            infinite (i <= 8) {
                  mut as int64: j = 1
                  infinite (j <= 8) {
                        route {
                              reach_eps[(i - 1) * 8 + k] and reach_eps[(k - 1) * 8 + j] ==> {
                                    reach_eps[(i - 1) * 8 + j] = true
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }
                  i = i + 1
            }
            k = k + 1
      }

      println("2. Fecho Epsilon do Estado Inicial 5:")
      mut as string: eps_init = ""
      mut as int64: st = 1
      infinite (st <= 8) {
            route {
                  reach_eps[(5 - 1) * 8 + st] ==> {
                        eps_init = eps_init + st + " "
                  }
                  _ ==> {}
            }
            st = st + 1
      }
      println("   eps-closure(5) = { " + eps_init + "}")

      println("3. Simulando NFA de Thompson:")

      #L Teste 1: "ac" (simbolos 1, 3)
      #L Conjunto ativo inicial = eps-closure(5)
      mut as list of bool: active1 = [false, false, false, false, false, false, false, false]
      st = 1
      infinite (st <= 8) {
            active1[st] = reach_eps[(5 - 1) * 8 + st]
            st = st + 1
      }

      #L Consome 'a' (1)
      mut as list of bool: next1 = [false, false, false, false, false, false, false, false]
      e = 1
      infinite (e <= total_edges) {
            route {
                  edge_sym[e] == 1 and active1[edge_u[e]] ==> {
                        #L Adiciona eps-closure do destino
                        mut as int64: dst = edge_v[e]
                        mut as int64: w = 1
                        infinite (w <= 8) {
                              route { reach_eps[(dst - 1) * 8 + w] ==> { next1[w] = true } _ ==> {} }
                              w = w + 1
                        }
                  }
                  _ ==> {}
            }
            e = e + 1
      }
      active1 = next1

      #L Consome 'c' (3)
      mut as list of bool: final_set1 = [false, false, false, false, false, false, false, false]
      e = 1
      infinite (e <= total_edges) {
            route {
                  edge_sym[e] == 3 and active1[edge_u[e]] ==> {
                        mut as int64: dst = edge_v[e]
                        mut as int64: w = 1
                        infinite (w <= 8) {
                              route { reach_eps[(dst - 1) * 8 + w] ==> { final_set1[w] = true } _ ==> {} }
                              w = w + 1
                        }
                  }
                  _ ==> {}
            }
            e = e + 1
      }
      mut as bool: acc_ac = final_set1[8]
      println("   Cadeia 'ac': Aceita = " + acc_ac)

      #L Teste 2: "bc" (deve aceitar)
      #L Passo 'b' (2)
      mut as list of bool: active2 = [false, false, false, false, false, false, false, false]
      st = 1
      infinite (st <= 8) {
            active2[st] = reach_eps[(5 - 1) * 8 + st]
            st = st + 1
      }
      mut as list of bool: next2 = [false, false, false, false, false, false, false, false]
      e = 1
      infinite (e <= total_edges) {
            route {
                  edge_sym[e] == 2 and active2[edge_u[e]] ==> {
                        mut as int64: dst = edge_v[e]
                        mut as int64: w = 1
                        infinite (w <= 8) {
                              route { reach_eps[(dst - 1) * 8 + w] ==> { next2[w] = true } _ ==> {} }
                              w = w + 1
                        }
                  }
                  _ ==> {}
            }
            e = e + 1
      }
      active2 = next2

      #L Passo 'c' (3)
      mut as list of bool: final_set2 = [false, false, false, false, false, false, false, false]
      e = 1
      infinite (e <= total_edges) {
            route {
                  edge_sym[e] == 3 and active2[edge_u[e]] ==> {
                        mut as int64: dst = edge_v[e]
                        mut as int64: w = 1
                        infinite (w <= 8) {
                              route { reach_eps[(dst - 1) * 8 + w] ==> { final_set2[w] = true } _ ==> {} }
                              w = w + 1
                        }
                  }
                  _ ==> {}
            }
            e = e + 1
      }
      mut as bool: acc_bc = final_set2[8]
      println("   Cadeia 'bc': Aceita = " + acc_bc)

      #L Teste 3: "c" (deve rejeitar)
      mut as list of bool: active3 = [false, false, false, false, false, false, false, false]
      st = 1
      infinite (st <= 8) {
            active3[st] = reach_eps[(5 - 1) * 8 + st]
            st = st + 1
      }
      mut as list of bool: final_set3 = [false, false, false, false, false, false, false, false]
      e = 1
      infinite (e <= total_edges) {
            route {
                  edge_sym[e] == 3 and active3[edge_u[e]] ==> {
                        mut as int64: dst = edge_v[e]
                        mut as int64: w = 1
                        infinite (w <= 8) {
                              route { reach_eps[(dst - 1) * 8 + w] ==> { final_set3[w] = true } _ ==> {} }
                              w = w + 1
                        }
                  }
                  _ ==> {}
            }
            e = e + 1
      }
      mut as bool: acc_c = final_set3[8]
      println("   Cadeia 'c': Aceita = " + acc_c)

      println("Thompson Construction concluido com sucesso.")
}
