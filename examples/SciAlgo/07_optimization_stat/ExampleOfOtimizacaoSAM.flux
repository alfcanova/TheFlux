#L ============================================================================
#L Algoritmo: SAM (Sharpness-Aware Minimization - Foret et al., ICLR 2021)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSAM) {
      println("==================================================")
      println("  SciAlgo: SAM (Sharpness-Aware Minimization)")
      println("==================================================")

      #L O SAM busca minimos planos favorecendo generalizacao:
      #L min_w max_{||eps|| <= rho} L(w + eps)
      #L 1. Perturbacao adversaria no raio rho: eps(w) = rho * grad(w) / ||grad(w)||
      #L 2. Gradiente no ponto perturbado: g_SAM = grad(w + eps(w))
      #L 3. Atualizacao dos pesos: w = w - lr * g_SAM

      mut as int64: w = 60
      mut as int64: rho_radius = 2 #L raio de nitidez (sharpness)

      #L Perda L(w) = (w - 20)^2 / 2 -> grad(w) = w - 20
      println("1. Ponto de partida w0 = " + w + " | Alvo do minimo plano = 20")

      mut as int64: iter = 1
      infinite (iter <= 6) {
            #L Passo 1: calcula gradiente na posicao atual
            mut as int64: g1 = w - 20

            #L Perturbacao eps(w) na direcao do gradiente
            mut as int64: eps = 0
            route {
                  g1 > 0 ==> { eps = rho_radius }
                  g1 < 0 ==> { eps = 0 - rho_radius }
                  _ ==> { eps = 0 }
            }

            #L Passo 2: avalia gradiente na vizinhanca adversaria (w + eps)
            mut as int64: w_perturbed = w + eps
            mut as int64: g_sam = w_perturbed - 20

            #L Passo 3: atualizacao em direcao ao minimo plano
            w = w - (g_sam /i 2)

            println("   Iter " + iter + ": w = " + w + " (eps = " + eps + ", g_sam = " + g_sam + ")")
            iter = iter + 1
      }

      println("2. Posicao final alcancada por SAM: w = " + w)

      route {
            w >= 19 and w <= 22 ==> {
                  println("   [PASS] SAM convergiu para o minimo plano de alta generalizacao!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo SAM.")
            }
      }

      println("==================================================")
      println("SAM concluido com sucesso!")
}
