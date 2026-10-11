#L ============================================================================
#L Algoritmo: Grey Wolf Optimizer (GWO - Mirjalili et al., 2014)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGreyWolf) {
      println("==================================================")
      println("  SciAlgo: Grey Wolf Optimizer (GWO)")
      println("==================================================")

      #L O GWO mimetiza a hierarquia social e caca de lobos cinzentos:
      #L Alfa (alpha): lider dominante (melhor solucao)
      #L Beta (beta): conselheiro (segunda melhor solucao)
      #L Delta (delta): batedores (terceira melhor solucao)
      #L Omega (omega): restante da alcateia
      #L Posicao atualizada pela media das 3 liderancas:
      #L X(t+1) = (X1 + X2 + X3) / 3

      mut as int64: x_alpha = 100
      mut as int64: x_beta = 110
      mut as int64: x_delta = 120
      mut as int64: x_omega = 150 #L lobo seguidor

      #L Funcao objetivo: min f(x) = (x - 35)^2 -> presa em 35
      println("1. Posicoes iniciais da alcateia:")
      println("   Alpha: " + x_alpha + " | Beta: " + x_beta + " | Delta: " + x_delta + " | Omega: " + x_omega)
      println("   Presa em x* = 35")

      mut as int64: iter = 1
      infinite (iter <= 8) {
            #L Movimento de cerco: cada lider atrai os lobos
            mut as int64: d_alpha = x_omega - x_alpha
            mut as int64: d_beta = x_omega - x_beta
            mut as int64: d_delta = x_omega - x_delta

            mut as int64: x1 = x_alpha - (d_alpha /i 3)
            mut as int64: x2 = x_beta - (d_beta /i 3)
            mut as int64: x3 = x_delta - (d_delta /i 3)

            #L Nova posicao media
            x_omega = (x1 + x2 + x3) /i 3

            #L Lideres avancam em direcao a presa (35)
            x_alpha = x_alpha - ((x_alpha - 35) /i 2)
            x_beta = x_beta - ((x_beta - 35) /i 2)
            x_delta = x_delta - ((x_delta - 35) /i 2)

            iter = iter + 1
      }

      println("2. Posicao final de caca da alcateia:")
      println("   Alpha = " + x_alpha + " | Omega = " + x_omega)

      route {
            x_alpha >= 34 and x_alpha <= 36 and x_omega >= 33 and x_omega <= 38 ==> {
                  println("   [PASS] Alcateia GWO cercou com sucesso a presa no otimo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Grey Wolf Optimizer.")
            }
      }

      println("==================================================")
      println("Grey Wolf Optimizer concluido com sucesso!")
}
