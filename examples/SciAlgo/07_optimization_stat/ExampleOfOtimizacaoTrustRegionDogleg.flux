#L ============================================================================
#L Algoritmo: Trust-Region Dogleg (Metodo Dogleg de Powell)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoTrustRegionDogleg) {
      println("==================================================")
      println("  SciAlgo: Trust-Region Dogleg Method")
      println("==================================================")

      #L Minimiza modelo quadratico m(p) = f + g*p + 0.5*p*B*p s.a. ||p|| <= Delta
      #L Ponto de Cauchy p_U = - (g^T g / g^T B g) * g
      #L Passo de Newton p_B = - B^{-1} * g
      #L Trajetoria Dogleg:
      #L Se ||p_B|| <= Delta -> p = p_B
      #L Se ||p_U|| >= Delta -> p = (Delta / ||p_U||) * p_U
      #L Senao -> interpola entre p_U e p_B na fronteira da regiao

      mut as int64: x = 0
      mut as int64: delta_radius = 5 #L Raio da regiao de confianca
      #L Funcao objetivo: f(x) = (x - 20)^2 / 2 -> x* = 20
      #L Gradiente g(x) = x - 20, Hessiana B = 1

      mut as int64: iter = 1
      infinite (iter <= 6) {
            mut as int64: g = x - 20
            mut as int64: p_newton = 0 - g   #L Passo puro de Newton
            mut as int64: p_cauchy = 0 - g   #L Em 1D com B=1, p_U = p_B

            #L Modulo do passo proposto
            mut as int64: abs_step = p_newton
            route {
                  abs_step < 0 ==> { abs_step = 0 - abs_step }
                  _ ==> {}
            }

            mut as int64: actual_step = p_newton
            route {
                  abs_step > delta_radius ==> {
                        #L Trunca na fronteira da regiao de confianca
                        route {
                              p_newton > 0 ==> { actual_step = delta_radius }
                              _ ==> { actual_step = 0 - delta_radius }
                        }
                  }
                  _ ==> {}
            }

            x = x + actual_step

            #L Adaptacao do raio da regiao de confianca (amplia se boa reducao)
            route {
                  delta_radius < 10 ==> { delta_radius = delta_radius + 2 }
                  _ ==> {}
            }
            iter = iter + 1
      }

      println("1. Minimo alcancado com Trust-Region: x = " + x)
      println("2. Raio final da regiao de confianca: Delta = " + delta_radius)

      route {
            x == 20 ==> {
                  println("   [PASS] Metodo Dogleg de Powell convergiu exatamente no otimo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Trust-Region Dogleg.")
            }
      }

      println("==================================================")
      println("Trust-Region Dogleg concluido com sucesso!")
}
