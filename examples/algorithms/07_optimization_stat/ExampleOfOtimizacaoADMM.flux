#L ============================================================================
#L Algoritmo: ADMM (Alternating Direction Method of Multipliers)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoADMM) {
      println("==================================================")
      println("  SciAlgo: ADMM (Alternating Direction Multipliers)")
      println("==================================================")

      #L Problema composto: min f(x) + g(z) sujeito a x - z = 0
      #L f(x) = (x - 30)^2 / 2, g(z) = lambda * |z|
      #L Passo x: x = (30 + rho*(z - u)) / (1 + rho)
      #L Passo z: Soft-thresholding de (x + u) com limiar lambda / rho
      #L Passo u: u = u + x - z

      mut as int64: x = 0
      mut as int64: z = 0
      mut as int64: u = 0
      mut as int64: rho = 2
      mut as int64: lambda_val = 6

      println("1. Parametros iniciais:")
      println("   Alvo a = 30, rho = " + rho + ", lambda = " + lambda_val)

      mut as int64: iter = 1
      infinite (iter <= 15) {
            #L Atualizacao primal x
            mut as int64: num_x = 30 + (rho * (z - u))
            mut as int64: den_x = 1 + rho
            x = num_x /i den_x

            #L Atualizacao primal z via Soft-Thresholding de v = x + u
            mut as int64: v = x + u
            mut as int64: threshold = lambda_val /i rho #L 3
            route {
                  v > threshold ==> {
                        z = v - threshold
                  }
                  v < (0 - threshold) ==> {
                        z = v + threshold
                  }
                  _ ==> {
                        z = 0
                  }
            }

            #L Atualizacao dual u (multiplicador de Lagrange escalonado)
            u = u + x - z
            iter = iter + 1
      }

      println("2. Resultados da convergencia ADMM:")
      println("   x final = " + x + " | z final = " + z + " | residuo primal = " + (x - z))

      #L O valor teorico com soft-thresholding de 30 com lambda=6 e ~27
      route {
            z >= 20 and z <= 25 and (x - z) >= -1 and (x - z) <= 1 ==> {
                  println("   [PASS] ADMM convergiu para o consenso primal-dual!")
            }
            _ ==> {
                  println("   [ERRO] Falha na convergencia do ADMM.")
            }
      }

      println("==================================================")
      println("ADMM concluido com sucesso!")
}
