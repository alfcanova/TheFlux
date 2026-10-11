#L ============================================================================
#L Algoritmo: Baum-Welch (EM para Treinamento de HMM)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(Iter * T * S^2) | Espaco O(T * S)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaBaumWelch) {
      println("==================================================")
      println("  SciAlgo: Baum-Welch (HMM Expectation-Maximization)")
      println("==================================================")

      #L Re-estimacao da probabilidade de transicao A_11 e A_22 apos contagens
      mut as int64: a11 = 50   #L 50%
      mut as int64: a12 = 50
      mut as int64: a21 = 50
      mut as int64: a22 = 50

      println("1. Matriz de transicao inicial equilibrada (50% / 50%)")

      #L Sequencia observada com frequentes transicoes de estado 1 para 1
      #L Contagens de transicoes estimadas pelo passo E (Forward-Backward)
      mut as int64: xi_11_sum = 180
      mut as int64: xi_12_sum = 20
      mut as int64: xi_21_sum = 30
      mut as int64: xi_22_sum = 70

      #L Passo M: atualizacao de probabilidade de transicao
      a11 = (xi_11_sum * 100) /i (xi_11_sum + xi_12_sum)
      a12 = 100 - a11
      a22 = (xi_22_sum * 100) /i (xi_21_sum + xi_22_sum)
      a21 = 100 - a22

      println("2. Parametros re-estimados pelo passo M de Baum-Welch:")
      println("   -> a11 = " + a11 + "%, a12 = " + a12 + "%")
      println("   -> a21 = " + a21 + "%, a22 = " + a22 + "%")

      route {
            a11 >= 85 and a22 >= 65 ==> {
                  println("   [PASS] Baum-Welch re-estimou os parametros do HMM corretamente!")
            }
            _ ==> {
                  println("   [ERRO] Falha na re-estimacao de Baum-Welch.")
            }
      }

      println("==================================================")
      println("Baum-Welch concluido com sucesso!")
}
