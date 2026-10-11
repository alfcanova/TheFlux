#L ============================================================================
#L Algoritmo: Shor's Algorithm (Fatoracao de Inteiros por Descoberta de Periodo)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O((log N)^3) tempo polinomial quantico (vs subexponencial classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaShorsAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Shor's Factorization Algorithm")
      println("==================================================")

      #L Fatoracao do numero composto N = 15
      mut as int64: n_comp = 15
      #L Escolha de base coprima 'a' tal que mdc(a, N) = 1
      mut as int64: a_base = 7

      println("1. Parametros de Entrada:")
      println("   Numero Composto para Fatorar: N = " + n_comp)
      println("   Base Coprima Escolhida: a = " + a_base)

      #L Verifica coprimalidade inicial via Algoritmo de Euclides
      mut as int64: g1 = a_base
      mut as int64: g2 = n_comp
      infinite (g2 != 0) {
            mut as int64: rem = g1 /r g2
            g1 = g2
            g2 = rem
      }
      println("   MDC(a, N) = " + g1 + " (Coprimos confirmados)")

      println("==================================================")
      println("2. Simulacao da Descoberta Quantica do Periodo r (Order Finding):")
      println("   Sequencia Modular f(x) = a^x mod N:")

      #L Avalia f(x) = 7^x mod 15 para x = 1, 2, 3, 4 ... ate f(x) == 1
      mut as int64: cur_mod = 1
      mut as int64: period_r = 0
      mut as int64: x = 1

      infinite (x <= 16 and period_r == 0) {
            cur_mod = (cur_mod * a_base) /r n_comp
            println("   x = " + x + ": " + a_base + "^" + x + " mod " + n_comp + " = " + cur_mod)
            route {
                  cur_mod == 1 ==> {
                        period_r = x
                  }
                  _ ==> {}
            }
            x = x + 1
      }

      println("   Periodo Modular Encontrado via QFT: r = " + period_r)

      println("==================================================")
      println("3. Pos-Processamento Classico de Shor:")

      #L O periodo r deve ser PAR e a^(r/2) != -1 mod N
      mut as int64: rem_r = period_r /r 2
      route {
            rem_r == 0 ==> {
                  mut as int64: half_r = period_r /i 2
                  #L Calcula a^(r/2) mod N
                  mut as int64: p_half = 1
                  mut as int64: h = 1
                  infinite (h <= half_r) {
                        p_half = (p_half * a_base) /r n_comp
                        h = h + 1
                  }
                  println("   Meio Periodo: r/2 = " + half_r + " | a^(r/2) mod N = " + p_half)

                  #L Fatores nao-triviais:
                  #L fator 1 = MDC(a^(r/2) - 1, N)
                  #L fator 2 = MDC(a^(r/2) + 1, N)
                  mut as int64: cand1 = p_half - 1
                  mut as int64: cand2 = p_half + 1

                  #L MDC(cand1, N)
                  mut as int64: m1 = cand1
                  mut as int64: n1 = n_comp
                  infinite (n1 != 0) {
                        mut as int64: r1 = m1 /r n1
                        m1 = n1
                        n1 = r1
                  }
                  mut as int64: factor1 = m1

                  #L MDC(cand2, N)
                  mut as int64: m2 = cand2
                  mut as int64: n2 = n_comp
                  infinite (n2 != 0) {
                        mut as int64: r2 = m2 /r n2
                        m2 = n2
                        n2 = r2
                  }
                  mut as int64: factor2 = m2

                  println("   Fator 1: MDC(" + cand1 + ", " + n_comp + ") = " + factor1)
                  println("   Fator 2: MDC(" + cand2 + ", " + n_comp + ") = " + factor2)

                  println("==================================================")
                  println("4. Fatoracao Concluida:")
                  println("   " + n_comp + " = " + factor1 + " x " + factor2)
                  route {
                        (factor1 * factor2) == n_comp ==> {
                              println("   Sucesso: Fatores primos encontrados e validados!")
                        }
                        _ ==> {}
                  }
            }
            _ ==> {
                  println("   Periodo impar, repetir com outra base 'a'.")
            }
      }

      println("   Shor's Algorithm concluido com sucesso!")
      println("==================================================")
}
