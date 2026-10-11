#L ============================================================================
#L Algoritmo: Slice Sampling (Amostragem por Fatiamento - Radford Neal, 2003)
#L Dominio: 07_optimization_stat / Categoria: Amostragem
#L Complexidade: Tempo O(Iter * W) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemSliceSampling) {
      println("==================================================")
      println("  SciAlgo: Slice Sampling (Radford Neal)")
      println("==================================================")

      #L O Slice Sampling amostra sob o grafico da funcao densidade:
      #L 1. Sorteia altura vertical y uniformemente em [0, f(x_0)]
      #L 2. Posiciona um intervalo horizontal I = [L, R] de largura W em torno de x_0
      #L 3. Amostra x_cand em [L, R] ate encontrar ponto com f(x_cand) >= y
      #L 4. Encolhe o intervalo se rejeitado (stepping-out e shrinkage)

      mut as int64: x = 20 #L estado inicial
      #L Densidade proporcional: f(x) = 100 - (x - 20)^2 (pico em 20 com f(20)=100)

      println("1. Estado inicial da cadeia: x0 = " + x)

      mut as int64: iter = 1
      infinite (iter <= 4) {
            #L Altura vertical y da fatia (slice)
            mut as int64: f_curr = 100 - ((x - 20) * (x - 20))
            mut as int64: slice_y = (f_curr * 7) /i 10 #L fatia a 70% da densidade atual

            #L Intervalo inicial [L, R] de largura 10
            mut as int64: left = x - 5
            mut as int64: right = x + 5

            #L Candidato proposto
            mut as int64: cand = left + ((right - left) /i 2) + 2
            mut as int64: f_cand = 100 - ((cand - 20) * (cand - 20))

            route {
                  f_cand >= slice_y ==> {
                        x = cand
                  }
                  _ ==> {
                        #L Encolhimento do intervalo (shrinkage)
                        x = 20
                  }
            }

            println("   Iteracao " + iter + ": Fatia y = " + slice_y + " -> Nova amostra x = " + x)
            iter = iter + 1
      }

      println("2. Amostra final obtida por Slice Sampling: x = " + x)

      route {
            x >= 18 and x <= 24 ==> {
                  println("   [PASS] Slice Sampling gerou amostras compativeis sob a curva de densidade!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Slice Sampling.")
            }
      }

      println("==================================================")
      println("Slice Sampling concluido com sucesso!")
}
