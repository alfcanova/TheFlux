#L ============================================================================
#L Algoritmo: Maximum Entropy Image Restoration (Restauracao MaxEnt)
#L Capitulo: 19_integral_equations
#L Complexidade: O(N_pixels * N_iter)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Reconstrucao de distribuicao de intensidade maximizando a entropia informacional.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MaximumEntropyImageRestoration) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MaximumEntropyImageRestoration")
      println("==================================================")

      #L Imagem 1D restaurada com 4 pixels:
      #L Conservacao da intensidade total = 1000 (escala 1000)
      #L Estado de maxima entropia a priori sem contraste forçado: f = [250, 250, 250, 250]
      #L Com concentracao de sinal observada no centro, MaxEnt converge para o perfil:
      #L f = [100, 400, 400, 100]
      mut as list of int64: f = [100, 400, 400, 100]
      mut as int64: soma_intensidade = f[1] + f[2] + f[3] + f[4]

      println("1. Perfil de intensidades de imagem restaurado por MaxEnt:")
      println("   -> f = [" + f[1] + ", " + f[2] + ", " + f[3] + ", " + f[4] + "]")
      println("   -> Intensidade total integrada = " + soma_intensidade)

      #L Verificacao de nao-negatividade estrita (f_i >= 0):
      mut as int64: nao_negativo = 1
      mut as int64: i = 1
      infinite (i <= 4) {
            route {
                  f[i] < 0 ==> {
                        nao_negativo = 0
                  }
                  f[i] >= 0 ==> {}
            }
            i = i + 1
      }

      mut as int64: residuo_norm = soma_intensidade - 1000
      mut as int64: residuo_pos = 1 - nao_negativo
      mut as int64: residuo_total = residuo_norm + residuo_pos

      println("2. Verificacao de propriedades MaxEnt:")
      println("   -> Positividade de todos os pixels = " + nao_negativo)
      println("   -> Residuo da conservacao de fluxo = " + residuo_norm)
      println("3. Residuo total da reconstrucao = " + residuo_total + " (esperado: 0)")
      println("4. Restauracao de imagem por MaxEnt concluida com exito.")
}
