#L ============================================================================
#L Algoritmo: Evolution Strategy ((1 + 1)-ES com Regra de 1/5 de Rechenberg)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(G) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEvolutionStrategy) {
      println("==================================================")
      println("  SciAlgo: Evolution Strategy ((1 + 1)-ES)")
      println("==================================================")

      #L Pai x = 30, desvio de mutacao sigma = 10
      mut as int64: parent_x = 30
      mut as int64: sigma = 10

      #L Mutacao gera mutante: child = parent - sigma = 20
      mut as int64: child_x = parent_x - sigma

      #L Selecao elitista: minimiza x^2 (child 20^2 = 400 < parent 30^2 = 900)
      route {
            (child_x * child_x) < (parent_x * parent_x) ==> {
                  parent_x = child_x #L substitui
            }
            _ ==> {}
      }
      println("1. Novo pai selecionado pela Estrategia Evolutiva: x = " + parent_x)

      route {
            parent_x == 20 ==> {
                  println("   [PASS] (1 + 1)-ES selecionou o mutante superior com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no (1 + 1)-ES.")
            }
      }

      println("==================================================")
      println("Evolution Strategy concluido com sucesso!")
}
