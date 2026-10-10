#L ============================================================================
#L Algoritmo: 2-SAT (2-Satisfiability via Grafo de Implicacoes e SCC)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo linear | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTwoSAT) {
      println("==================================================")
      println("  SciAlgo: 2-SAT (2-Satisfiability via SCC)       ")
      println("==================================================")

      #L Instancia 2-SAT com 3 variaveis booleanas x1, x2, x3:
      #L Clausulas:
      #L C1: (x1 v x2)   => (~x1 -> x2) e (~x2 -> x1)
      #L C2: (~x1 v x3)  => (x1 -> x3) e (~x3 -> ~x1)
      #L C3: (~x2 v ~x3) => (x2 -> ~x3) e (x3 -> ~x2)
      #L C4: (x1 v ~x2)  => (~x1 -> ~x2) e (x2 -> x1)

      #L Mapeamento de literais para vertices (1..6):
      #L 1: x1,  2: ~x1
      #L 3: x2,  4: ~x2
      #L 5: x3,  6: ~x3
      mut as int64: num_lit = 6
      mut as int64: num_vars = 3

      mut as list of int64: adj = [
            0, 0, 0, 0, 1, 0, #L 1 (x1): -> 5 (x3)
            0, 0, 1, 1, 0, 0, #L 2 (~x1): -> 3 (x2), 4 (~x2)
            1, 0, 0, 0, 0, 1, #L 3 (x2): -> 1 (x1), 6 (~x3)
            1, 0, 0, 0, 0, 0, #L 4 (~x2): -> 1 (x1)
            0, 0, 0, 1, 0, 0, #L 5 (x3): -> 4 (~x2)
            0, 1, 0, 0, 0, 0  #L 6 (~x3): -> 2 (~x1)
      ]

      println("1. Formula 2-CNF com 3 Variaveis e 4 Clausulas")

      #L Calcula SCCs usando algoritmo de alcancabilidade transitiva
      mut as list of bool: reach = [
            true, false, false, false, false, false,
            false, true, false, false, false, false,
            false, false, true, false, false, false,
            false, false, false, true, false, false,
            false, false, false, false, true, false,
            false, false, false, false, false, true
      ]

      mut as int64: i = 1
      mut as int64: j = 1
      mut as int64: k = 1

      i = 1
      infinite (i <= num_lit) {
            j = 1
            infinite (j <= num_lit) {
                  route {
                        adj[(i - 1) * num_lit + j] == 1 ==> {
                              reach[(i - 1) * num_lit + j] = true
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      k = 1
      infinite (k <= num_lit) {
            i = 1
            infinite (i <= num_lit) {
                  j = 1
                  infinite (j <= num_lit) {
                        route {
                              reach[(i - 1) * num_lit + k] and reach[(k - 1) * num_lit + j] ==> {
                                    reach[(i - 1) * num_lit + j] = true
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }
                  i = i + 1
            }
            k = k + 1
      }

      #L Rotulos de SCC
      mut as list of int64: scc_id = [0, 0, 0, 0, 0, 0]
      mut as int64: scc_count = 0

      i = 1
      infinite (i <= num_lit) {
            route {
                  scc_id[i] == 0 ==> {
                        scc_count = scc_count + 1
                        scc_id[i] = scc_count
                        j = i + 1
                        infinite (j <= num_lit) {
                              route {
                                    reach[(i - 1) * num_lit + j] and reach[(j - 1) * num_lit + i] ==> {
                                          scc_id[j] = scc_count
                                    }
                                    _ ==> {}
                              }
                              j = j + 1
                        }
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      #L Verificacao de Satisfatibilidade:
      #L Uma formula 2-SAT e satisfativel se e somente se para todo var x, x e ~x pertencem a SCCs distintas!
      mut as bool: satisfiable = true
      mut as int64: v_idx = 1
      infinite (v_idx <= num_vars) {
            mut as int64: pos_lit = (v_idx - 1) * 2 + 1
            mut as int64: neg_lit = (v_idx - 1) * 2 + 2
            route {
                  scc_id[pos_lit] == scc_id[neg_lit] ==> {
                        satisfiable = false
                  }
                  _ ==> {}
            }
            v_idx = v_idx + 1
      }

      route {
            satisfiable ==> {
                  println("2. Status: A formula 2-SAT e SATISFATIVEL!")
                  println("3. Atribuicao de Verdade Valida:")
                  v_idx = 1
                  infinite (v_idx <= num_vars) {
                        mut as int64: pos_lit = (v_idx - 1) * 2 + 1
                        mut as int64: neg_lit = (v_idx - 1) * 2 + 2
                        #L Atribui true se reach(~x, x) ou scc(~x) < scc(x)
                        mut as bool: val_bool = scc_id[neg_lit] < scc_id[pos_lit]
                        println("   Variavel x" + v_idx + " = " + val_bool)
                        v_idx = v_idx + 1
                  }
            }
            _ ==> {
                  println("2. Status: A formula 2-SAT e INSATISFATIVEL.")
            }
      }

      println("2-SAT concluido com sucesso.")
}
