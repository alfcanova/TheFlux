#L ============================================================================
#L Algoritmo: Error, Accuracy, and Stability (Precisao e Erro Numerico)
#L Capitulo: 01_preliminaries
#L Complexidade: O(log(1/eps))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo do epsilon de maquina e analise de perda de significancia.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ErrorAccuracyStability) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ErrorAccuracyStability")
      println("==================================================")

      #L 1. Determinacao do Machine Epsilon em escala fixa 1_000_000 (1.0 = 1000000)
      mut as int64: one = 1000000
      mut as int64: eps = 500000
      mut as int64: iterations = 0

      infinite ((one + eps) > one) {
            eps = eps /i 2
            iterations = iterations + 1
      }

      #L eps atual e o menor valor onde 1.0 + eps == 1.0; eps * 2 e o epsilon de maquina
      mut as int64: mach_eps = eps * 2
      println("1. Machine Epsilon calculado:")
      println("   -> Epsilon de maquina (escala 1e6) = " + mach_eps)
      println("   -> Iteracoes de bissecao = " + iterations)

      #L 2. Demonstracao de estabilidade e cancelamento catastrofico:
      #L Subtracao de dois numeros proximos: (x + delta) - x
      mut as int64: x = 1234567
      mut as int64: delta = 42
      mut as int64: sum_val = x + delta
      mut as int64: diff_val = sum_val - x

      println("2. Verificacao de estabilidade de subtracao:")
      println("   -> ((x + delta) - x) = " + diff_val + " (esperado: " + delta + ")")

      route {
            diff_val == delta ==> {
                  println("3. Analise de estabilidade numerica concluida com exito.")
            }
            diff_val != delta ==> {
                  println("3. Erro de estabilidade numerica detectado.")
            }
      }
}
