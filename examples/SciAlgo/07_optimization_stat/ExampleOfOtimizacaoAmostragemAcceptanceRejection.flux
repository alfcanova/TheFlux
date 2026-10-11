#L ============================================================================
#L Algoritmo: Acceptance-Rejection Sampling (Amostragem com Criterio de Aceitacao)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(M) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemAcceptanceRejection) {
      println("==================================================")
      println("  SciAlgo: Acceptance-Rejection Sampling")
      println("==================================================")

      #L Amostragem da distribuicao Beta(2, 2): f(x) = 6 * x * (1 - x) em [0, 1]
      #L Maximo em x = 0.5: f(0.5) = 1.5. Envelope constante M = 1.5 (escala x100 = 150)
      mut as int64: m_bound = 150

      #L Teste com proposta x = 0.5 (escala x100 = 50): f(0.5) = 6 * 50 * 50 / 100 = 150
      mut as int64: x_prop = 50
      mut as int64: f_val = (6 * x_prop * (100 - x_prop)) /i 100 #L 150

      #L Criterio de aceitacao: u * M <= f(x)
      mut as int64: u_test = 80 #L 80% de M = 120 <= 150 -> aceito!
      mut as int64: threshold = (u_test * m_bound) /i 100

      mut as bool: accepted = false
      route {
            threshold <= f_val ==> {
                  accepted = true
            }
            _ ==> {}
      }

      println("1. Proposta x = 0.50 -> Densidade alvo f(x) = " + f_val)
      println("2. Limiar sorteado u * M = " + threshold + " -> Aceito: " + accepted)

      route {
            accepted ==> {
                  println("   [PASS] Acceptance-Rejection validou a amostra no envelope com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Acceptance-Rejection.")
            }
      }

      println("==================================================")
      println("Acceptance-Rejection Sampling concluido com sucesso!")
}
