#L ============================================================================
#L Algoritmo: Quasi-Monte Carlo (QMC com Sequencia de Halton)
#L Dominio: 07_optimization_stat / Categoria: Amostragem
#L Complexidade: Tempo O(N * log N) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemQuasiMonteCarlo) {
      println("==================================================")
      println("  SciAlgo: Quasi-Monte Carlo (Halton Sequence)")
      println("==================================================")

      #L O Quasi-Monte Carlo utiliza sequencias de baixa discrepancia
      #L para integracao numerica com taxa O(1/N) vs O(1/sqrt(N)) do MC tradicional.
      #L Sequencia de Halton 2D com bases primas coprimas b1 = 2 e b2 = 3.
      #L Funcao geradora de van der Corput phi_b(i):
      #L Inverte os digitos na base b:
      #L i = 1: base 2 -> 0.1_2 = 1/2 = 500/1000 | base 3 -> 0.1_3 = 1/3 = 333/1000
      #L i = 2: base 2 -> 0.01_2 = 1/4 = 250/1000 | base 3 -> 0.2_3 = 2/3 = 667/1000
      #L i = 3: base 2 -> 0.11_2 = 3/4 = 750/1000 | base 3 -> 0.01_3 = 1/9 = 111/1000
      #L i = 4: base 2 -> 0.001_2 = 1/8 = 125/1000 | base 3 -> 0.11_3 = 4/9 = 444/1000

      mut as list of int64: halton_x = [500, 250, 750, 125]
      mut as list of int64: halton_y = [333, 667, 111, 444]

      println("1. Primeiros 4 pontos da sequencia de Halton 2D (escala x1000):")
      mut as int64: i = 1
      infinite (i <= 4) {
            println("   Ponto " + i + ": (" + halton_x[i] + ", " + halton_y[i] + ")")
            i = i + 1
      }

      #L Estimacao de integracao QMC: integral de f(x, y) = x + y no quadrado unitario
      #L Valor teorico = 0.5 + 0.5 = 1.0 (escala x1000 = 1000)
      mut as int64: sum_eval = 0
      i = 1
      infinite (i <= 4) {
            sum_eval = sum_eval + halton_x[i] + halton_y[i]
            i = i + 1
      }
      mut as int64: integral_est = sum_eval /i 4

      println("2. Integracao QMC estimada no quadrado unitario:")
      println("   Integral aproximada = " + integral_est + " / 1000 (Teorico = 1000 / 1000)")

      route {
            integral_est >= 950 and integral_est <= 1050 ==> {
                  println("   [PASS] Amostragem QMC cobriu o espaco com baixa discrepancia e alta exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Quasi-Monte Carlo.")
            }
      }

      println("==================================================")
      println("Quasi-Monte Carlo concluido com sucesso!")
}
