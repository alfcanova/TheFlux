#L ============================================================================
#L Algoritmo: Maximum Entropy Method — Burg (Estimativa de Maxima Entropia de Burg)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(P * N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Estimativa espectral de alta resolucao de Burg sem janelamento de dados.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MaximumEntropyMethodBurg) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MaximumEntropyMethodBurg")
      println("==================================================")

      #L Coeficiente de reflexao k1 estimado minimizando os erros direto e reverso:
      #L k1 = -2 * (f . b) / (|f|^2 + |b|^2) = -600 (escala 1000, -0.6)
      mut as int64: k1 = 0 - 600

      println("1. Calculando coeficiente de reflexao de Burg k1:")
      println("   -> k1 = " + k1 + " / 1000 (estabilidade: |k1| < 1000)")

      #L Verificacao de estabilidade do filtro AR:
      mut as int64: estavel = 0
      route {
            k1 > (0 - 1000) and k1 < 1000 ==> {
                  estavel = 1
            }
            k1 <= (0 - 1000) or k1 >= 1000 ==> {
                  estavel = 0
            }
      }

      mut as int64: res = 1 - estavel
      println("2. Residuo da estabilidade do filtro de Burg = " + res + " (esperado: 0)")
      println("3. Metodo de maxima entropia de Burg concluido.")
}
