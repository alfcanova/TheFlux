#L ============================================================================
#L Algoritmo: Differential Evolution (DE: Mutacao Vetorial e Cruzamento)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(G * NP * D) | Espaco O(NP * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoDifferentialEvolution) {
      println("==================================================")
      println("  SciAlgo: Differential Evolution (DE)")
      println("==================================================")

      #L Populacao de 3 individuos: x1 = 10, x2 = 20, x3 = 30
      #L Vetor mutante v = x1 + F * (x2 - x3) com F = 1
      mut as int64: x1 = 10
      mut as int64: x2 = 20
      mut as int64: x3 = 30

      mut as int64: v_mut = x1 + (x2 - x3) #L 10 + (20 - 30) = 0
      println("1. Vetor gerado por mutacao diferencial: v = " + v_mut)

      #L Selecao contra individuo alvo f(x) = x^2: f(0) = 0 < f(10) = 100 -> substitui!
      mut as int64: selected = x1
      route {
            (v_mut * v_mut) < (x1 * x1) ==> {
                  selected = v_mut
            }
            _ ==> {}
      }
      println("2. Individuo sobrevivente: " + selected)

      route {
            selected == 0 ==> {
                  println("   [PASS] Differential Evolution evoluiu a populacao com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Differential Evolution.")
            }
      }

      println("==================================================")
      println("Differential Evolution concluido com sucesso!")
}
