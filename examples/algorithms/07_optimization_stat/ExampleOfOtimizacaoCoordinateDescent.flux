#L ============================================================================
#L Algoritmo: Coordinate Descent (Descida Coordenada Alternada)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * D) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCoordinateDescent) {
      println("==================================================")
      println("  SciAlgo: Coordinate Descent (Axis-Aligned Min)")
      println("==================================================")

      #L Minimiza f(x, y) = (x - 10)^2 + (y - 20)^2 separadamente por eixo
      mut as int64: x = 0
      mut as int64: y = 0

      mut as int64: iter = 1
      infinite (iter <= 5) {
            #L Otimiza eixo x mantendo y fixo
            x = x + ((10 - x) /i 2)
            #L Otimiza eixo y mantendo x fixo
            y = y + ((20 - y) /i 2)
            iter = iter + 1
      }
      println("1. Ponto convergido: (" + x + ", " + y + ") (alvo: 10, 20)")

      route {
            x >= 9 and y >= 19 ==> {
                  println("   [PASS] Coordinate Descent convergiu por eixos coordenados!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Coordinate Descent.")
            }
      }

      println("==================================================")
      println("Coordinate Descent concluido com sucesso!")
}
