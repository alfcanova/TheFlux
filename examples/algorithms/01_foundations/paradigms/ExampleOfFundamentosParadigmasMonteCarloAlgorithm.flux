#L ============================================================================
#L Algoritmo: Monte Carlo Algorithm (Algoritmo de Monte Carlo)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(K) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasMonteCarloAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Monte Carlo Algorithm (Amostragem)")
      println("==================================================")

      #L PRNG LCG deterministico para reprodutibilidade estrita
      mut as int64: seed = 123456789
      mut as int64: lcg_m = 2147483647
      mut as int64: lcg_a = 48271

      #L Caso 1: Estimativa de Pi por Integracao de Monte Carlo
      #L Quadrante unitario escalado para R = 10000
      mut as int64: r = 10000
      mut as int64: r_sq = r * r
      mut as int64: total_samples = 1000
      mut as int64: inside_circle = 0
      mut as int64: s = 1

      infinite (s <= total_samples) {
            seed = ((seed * lcg_a) + 1) /r lcg_m
            route {
                  seed < 0 ==> {
                        seed = 0 - seed
                  }
                  _ ==> {
                  }
            }
            mut as int64: x = seed /r (r + 1)

            seed = ((seed * lcg_a) + 1) /r lcg_m
            route {
                  seed < 0 ==> {
                        seed = 0 - seed
                  }
                  _ ==> {
                  }
            }
            mut as int64: y = seed /r (r + 1)

            mut as int64: dist_sq = (x * x) + (y * y)
            route {
                  dist_sq <= r_sq ==> {
                        inside_circle = inside_circle + 1
                  }
                  _ ==> {
                  }
            }
            s = s + 1
      }

      #L Pi * 1000 = (4 * inside * 1000) / total
      mut as int64: pi_times_1000 = (4 * inside_circle * 1000) /i total_samples
      println("1. Total de amostras estocasticas: " + total_samples)
      println("2. Pontos no circulo: " + inside_circle)
      println("3. Pi estimado (* 1000): " + pi_times_1000)

      #L Caso 2: Teste de Primalidade Probabilistico de Fermat
      #L Testa numero N = 1009 (primo) com 5 testemunhas aleatorias
      mut as int64: candidate = 1009
      mut as int64: tests = 5
      mut as bool: probably_prime = true
      mut as int64: ti = 1

      infinite (ti <= tests and probably_prime) {
            seed = ((seed * lcg_a) + 1) /r lcg_m
            route {
                  seed < 0 ==> {
                        seed = 0 - seed
                  }
                  _ ==> {
                  }
            }
            mut as int64: base = 2 + (seed /r (candidate - 3))

            #L Modulo exp: base^(candidate - 1) % candidate
            mut as int64: exp = candidate - 1
            mut as int64: rem = 1
            mut as int64: b_cur = base /r candidate

            infinite (exp > 0) {
                  mut as int64: bit = exp /r 2
                  route {
                        bit == 1 ==> {
                              rem = (rem * b_cur) /r candidate
                        }
                        _ ==> {
                        }
                  }
                  b_cur = (b_cur * b_cur) /r candidate
                  exp = exp /i 2
            }

            route {
                  rem != 1 ==> {
                        probably_prime = false
                  }
                  _ ==> {
                  }
            }
            ti = ti + 1
      }

      route {
            probably_prime ==> {
                  println("4. Teste de Fermat para " + candidate + ": Provavelmente Primo (OK)")
            }
            _ ==> {
                  println("4. Teste de Fermat para " + candidate + ": Composto")
            }
      }
      println("Concluido com Sucesso")
}
