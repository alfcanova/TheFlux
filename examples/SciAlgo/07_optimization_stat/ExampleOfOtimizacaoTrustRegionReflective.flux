#L ============================================================================
#L Algoritmo: Trust Region Reflective (TRF)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao com Restricoes de Caixa
#L Descricao: Minimizacao com reflexao em fronteiras de limites inferiores e superiores [L, U]
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoTrustRegionReflective) {
      println("=== Algoritmo: Trust Region Reflective (TRF) ===")

      #L Limites da caixa: [L = 0, U = 100]
      #L Posicao atual x = 85
      #L Passo calculado da regiao de confianca: step = +30
      #L Posicao desimpedida alcancaria 85 + 30 = 115 (ultrapassa limite superior U=100!)
      mut as int64: bound_lower = 0
      mut as int64: bound_upper = 100
      mut as int64: x_current = 85
      mut as int64: step = 30

      mut as int64: x_tentative = x_current + step

      #L Calculo de colisao com a fronteira U:
      #L Distancia ate a borda: d_borda = 100 - 85 = 15
      #L Excesso alem da borda: excesso = step - d_borda = 30 - 15 = 15
      #L Reflexao: x_refletido = U - excesso = 100 - 15 = 85
      mut as int64: d_borda = bound_upper - x_current
      mut as int64: excesso = step - d_borda
      mut as int64: x_refletido = bound_upper - excesso

      println("1. Posicao atual: " + x_current)
      println("2. Passo tentativo (ultrapassa fronteira U=100): " + x_tentative)
      println("3. Excesso de deslocamento refletido pela borda: " + excesso)
      println("4. Nova posicao viavel refletida para o interior da regiao: " + x_refletido)

      #L Verificacao de que o ponto resultante esta estritamente dentro da caixa viavel
      mut as int64: viavel = 0
      route {
            x_refletido >= bound_lower and x_refletido <= bound_upper ==> {
                  viavel = 1
            }
            _ ==> {}
      }

      route {
            x_refletido == 85 and viavel == 1 ==> {
                  println("5. Reflexao de fronteira da Trust Region validada com sucesso.")
            }
            _ ==> {
                  println("Falha no TRF.")
            }
      }
      println("Teste concluido com sucesso.")
}
