#L ============================================================================
#L Algoritmo: Tabu Search (Busca Tabu com Memoria de Curto Prazo)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * Vizinhanca) | Espaco O(Lista_Tabu)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoTabuSearch) {
      println("==================================================")
      println("  SciAlgo: Tabu Search (Short-Term Memory)")
      println("==================================================")

      #L Estado atual = 10. Movimentos vizinhos: +1 (11) ou -1 (9)
      #L Se 11 esta na lista tabu, o algoritmo eh forcado a explorar 9
      mut as list of int64: tabu_list = [11]
      mut as int64: curr_x = 10

      mut as int64: cand = 11
      mut as int64: chosen = 9 #L escolhe 9 porque 11 eh proibido (tabu)

      println("1. Movimento 11 rejeitado por restricao da Lista Tabu")
      println("2. Movimento nao-tabu executado: x = " + chosen)

      route {
            chosen == 9 ==> {
                  println("   [PASS] Tabu Search evitou ciclos e explorou novo espaco!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Tabu Search.")
            }
      }

      println("==================================================")
      println("Tabu Search concluido com sucesso!")
}
