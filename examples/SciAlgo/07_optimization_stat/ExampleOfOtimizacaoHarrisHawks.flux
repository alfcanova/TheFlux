#L ============================================================================
#L Algoritmo: Harris Hawks Optimization (HHO - Heidari et al., 2019)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoHarrisHawks) {
      println("==================================================")
      println("  SciAlgo: Harris Hawks Optimization (HHO)")
      println("==================================================")

      #L O HHO modela a caca cooperativa do gaviao-asa-de-telha:
      #L Energia de fuga da presa: E = 2 * E0 * (1 - t / T)
      #L Se |E| >= 1: fase de exploracao (busca global aleatoria)
      #L Se |E| < 1: fase de exploracao local (ataques surpresa):
      #L   - Cerco suave (|E| >= 0.5)
      #L   - Cerco duro (|E| < 0.5) com mergulho rapido

      mut as int64: x_rabbit = 50 #L presa (coelho) na posicao otima
      mut as int64: x_hawk = 180   #L gaviao em voo

      println("1. Posicao inicial:")
      println("   Gaviao = " + x_hawk + " | Coelho = " + x_rabbit)

      mut as int64: t = 1
      mut as int64: max_t = 6
      infinite (t <= max_t) {
            #L Energia decrescente escalonada (de 100 para 0)
            mut as int64: energy = (100 * (max_t - t + 1)) /i max_t

            #L Diferenca ate a presa
            mut as int64: delta_x = x_hawk - x_rabbit

            route {
                  energy >= 50 ==> {
                        #L Cerco suave: aproxima com passo amortecido
                        x_hawk = x_rabbit + (delta_x /i 3)
                  }
                  _ ==> {
                        #L Cerco duro: mergulho direto de alta velocidade
                        x_hawk = x_rabbit + (delta_x /i 6)
                  }
            }

            println("   Passo " + t + ": Energia E = " + energy + " | Posicao Gaviao = " + x_hawk)
            t = t + 1
      }

      println("2. Posicao final alcancada pelo gaviao: " + x_hawk)

      route {
            x_hawk >= 49 and x_hawk <= 53 ==> {
                  println("   [PASS] Gaviao HHO realizou o cerco final cooperativo na presa!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Harris Hawks Optimization.")
            }
      }

      println("==================================================")
      println("Harris Hawks Optimization concluido com sucesso!")
}
