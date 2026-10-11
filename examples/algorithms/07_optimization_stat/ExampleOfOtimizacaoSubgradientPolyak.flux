#L ============================================================================
#L Algoritmo: Metodo do Subgradiente com Passo de Polyak
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSubgradientPolyak) {
      println("==================================================")
      println("  SciAlgo: Subgradient Method (Polyak Step Size)")
      println("==================================================")

      #L Minimiza funcao convexa nao-diferenciavel f(x) = |x - 25| + |x - 35|
      #L O valor minimo f* = 10 e alcancado no intervalo [25, 35]
      #L Passo de Polyak: alpha_k = (f(x_k) - f*) / ||g_k||^2
      #L Subgradiente g_k em d/dx (|x-25| + |x-35|):
      #L se x < 25 -> g = -2, ||g||^2 = 4
      #L se x > 35 -> g = +2, ||g||^2 = 4
      #L se 25 <= x <= 35 -> g = 0 (otimo)

      mut as int64: x = 5 #L ponto inicial distante
      mut as int64: f_star = 10 #L estimativa do valor otimo

      println("1. Ponto de partida: x0 = " + x)
      println("   Valor otimo teorico f* = " + f_star)

      mut as int64: iter = 1
      infinite (iter <= 6) {
            #L Calcula f(x)
            mut as int64: term1 = x - 25
            route {
                  term1 < 0 ==> { term1 = 0 - term1 }
                  _ ==> {}
            }
            mut as int64: term2 = x - 35
            route {
                  term2 < 0 ==> { term2 = 0 - term2 }
                  _ ==> {}
            }
            mut as int64: f_val = term1 + term2

            #L Subgradiente g
            mut as int64: g = 0
            route {
                  x < 25 ==> { g = -2 }
                  x > 35 ==> { g = 2 }
                  _ ==> { g = 0 }
            }

            println("   Iter " + iter + ": x = " + x + " | f(x) = " + f_val + " | subgrad = " + g)

            route {
                  g == 0 ==> {
                        #L Ja estamos no conjunto otimo
                        iter = 999
                  }
                  _ ==> {
                        #L Passo de Polyak: alpha = (f_val - f_star) / 4
                        mut as int64: alpha = (f_val - f_star) /i 4
                        x = x - (alpha * g)
                        iter = iter + 1
                  }
            }
      }

      println("2. Ponto final alcancado: x = " + x)

      route {
            x >= 25 and x <= 35 ==> {
                  println("   [PASS] Metodo do Subgradiente de Polyak atingiu a regiao de minimos!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Subgradiente de Polyak.")
            }
      }

      println("==================================================")
      println("Subgradient Polyak concluido com sucesso!")
}
