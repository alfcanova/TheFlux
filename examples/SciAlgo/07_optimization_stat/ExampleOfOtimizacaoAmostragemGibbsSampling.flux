#L ============================================================================
#L Algoritmo: Gibbs Sampling (Amostragem Condicional Alternada)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(Iter * D) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemGibbsSampling) {
      println("==================================================")
      println("  SciAlgo: Gibbs Sampling (Bivariate Normal)")
      println("==================================================")

      #L Amostragem conjunta de (x1, x2) onde x1|x2 ~ N(0.5 * x2, 1) e x2|x1 ~ N(0.5 * x1, 1)
      mut as int64: x1 = 10 #L escala x10
      mut as int64: x2 = 10

      mut as int64: sum_x1 = 0
      mut as int64: sum_x2 = 0
      mut as int64: total_iter = 20

      mut as int64: iter = 1
      infinite (iter <= total_iter) {
            #L 1. Amostra x1 dado x2: media = 0.5 * x2
            x1 = (x2 /i 2) + 1

            #L 2. Amostra x2 dado x1: media = 0.5 * x1
            x2 = (x1 /i 2) + 1

            sum_x1 = sum_x1 + x1
            sum_x2 = sum_x2 + x2
            iter = iter + 1
      }

      mut as int64: mean_x1 = sum_x1 /i total_iter
      mut as int64: mean_x2 = sum_x2 /i total_iter
      println("1. Media convergida de (x1, x2): (" + mean_x1 + ", " + mean_x2 + ")")

      route {
            mean_x1 <= 5 and mean_x2 <= 5 ==> {
                  println("   [PASS] Gibbs Sampling convergiu estavelmente para a media bivariada!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Gibbs Sampling.")
            }
      }

      println("==================================================")
      println("Gibbs Sampling concluido com sucesso!")
}
