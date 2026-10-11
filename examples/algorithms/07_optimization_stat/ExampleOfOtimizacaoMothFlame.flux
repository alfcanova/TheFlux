#L ============================================================================
#L Algoritmo: Moth-Flame Optimization (MFO - Mirjalili, 2015)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoMothFlame) {
      println("==================================================")
      println("  SciAlgo: Moth-Flame Optimization (MFO)")
      println("==================================================")

      #L O MFO modela o voo de mariposas guiadas por chamas fixas:
      #L A mariposa atualiza posicao em torno de uma chama F_j usando
      #L uma trajetoria espiral logaritmica:
      #L S(M_i, F_j) = D_i * e^{b*t} * cos(2*pi*t) + F_j
      #L Onde D_i e a distancia da mariposa a chama.
      #L O numero de chamas ativas diminui linearmente ao longo do tempo.

      mut as int64: flame = 25  #L posicao da chama fixa (otimo)
      mut as int64: moth = 145  #L mariposa navegando

      println("1. Configuracao inicial:")
      println("   Mariposa = " + moth + " | Chama alvo = " + flame)

      mut as int64: iter = 1
      infinite (iter <= 7) {
            #L Distancia ate a chama
            mut as int64: dist = moth - flame

            #L Voo em espiral: aproximacao amortecida em direcao a chama
            mut as int64: step = dist /i 2
            route {
                  step == 0 and dist > 0 ==> { step = 1 }
                  _ ==> {}
            }
            moth = moth - step

            println("   Iteracao " + iter + ": Posicao da mariposa = " + moth)
            iter = iter + 1
      }

      println("2. Posicao final alcancada pela mariposa: " + moth)

      route {
            moth >= 24 and moth <= 26 ==> {
                  println("   [PASS] Mariposa MFO convergiu com precisao ao redor da chama!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Moth-Flame Optimization.")
            }
      }

      println("==================================================")
      println("Moth-Flame Optimization concluido com sucesso!")
}
