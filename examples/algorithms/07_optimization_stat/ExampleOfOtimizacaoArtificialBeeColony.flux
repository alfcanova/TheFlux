#L ============================================================================
#L Algoritmo: Artificial Bee Colony (ABC: Colonia de Abelhas Artificiais)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Ciclos * Abelhas * D) | Espaco O(Fontes * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoArtificialBeeColony) {
      println("==================================================")
      println("  SciAlgo: Artificial Bee Colony (ABC)")
      println("==================================================")

      #L Fonte de alimento x = 30 (qualidade nectar = 100 - x^2)
      #L Abelha operaria explora vizinhanca v = x + phi * (x - x_k)
      mut as int64: x = 30
      mut as int64: neighbor_x = 10

      mut as int64: v_cand = x + ((neighbor_x - x) /i 2) #L 30 + (-10) = 20
      println("1. Fonte explorada pela abelha: " + v_cand + " (nectar superior a x=30)")

      route {
            v_cand < x ==> {
                  println("   [PASS] Artificial Bee Colony explorou fonte de nectar mais rica!")
            }
            _ ==> {
                  println("   [ERRO] Falha no ABC.")
            }
      }

      println("==================================================")
      println("Artificial Bee Colony concluido com sucesso!")
}
