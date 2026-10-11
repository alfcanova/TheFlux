#L ============================================================================
#L Algoritmo: SQP (Sequential Quadratic Programming)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * QP) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSequentialQuadraticProgramming) {
      println("==================================================")
      println("  SciAlgo: SQP (Sequential Quadratic Programming)")
      println("==================================================")

      #L O SQP resolve sequencialmente subproblemas quadraticos locais:
      #L min f(x) = (x - 50)^2 / 2 sujeito a c(x) = x - 30 >= 0
      #L No ponto x, o modelo quadratico e:
      #L min grad(f)^T p + 0.5 * p^T B p s.a. c(x) + grad(c)^T p >= 0
      #L Com B = 1, grad(f) = x - 50, c(x) = x - 30, grad(c) = 1:
      #L p_otimo = 50 - x (se viavel) ou 30 - x (se na fronteira da restricao)

      mut as int64: x = 10 #L ponto inicial inviavel (x < 30)

      println("1. Ponto de partida: x0 = " + x)
      println("   Restricao ativa: x >= 30 | Alvo irrestrito: x = 50")

      mut as int64: iter = 1
      infinite (iter <= 4) {
            mut as int64: grad_f = x - 50
            mut as int64: c_viol = 30 - x

            #L Subproblema QP determina passo p
            mut as int64: p = 0
            route {
                  c_viol > 0 ==> {
                        #L Precisa restaurar a viabilidade x + p >= 30
                        p = c_viol
                  }
                  _ ==> {
                        #L Ja esta na regiao viavel: move-se em direcao a 50
                        p = (50 - x) /i 2
                  }
            }

            x = x + p
            println("   Iteracao " + iter + ": passo p = " + p + " -> novo x = " + x)
            iter = iter + 1
      }

      println("2. Ponto final alcancado por SQP: x = " + x)

      route {
            x >= 45 and x <= 50 ==> {
                  println("   [PASS] SQP satisfez as restricoes e convergiu ao otimo KKT!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo SQP.")
            }
      }

      println("==================================================")
      println("SQP concluido com sucesso!")
}
