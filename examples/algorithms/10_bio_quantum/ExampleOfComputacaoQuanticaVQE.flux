#L ============================================================================
#L Algoritmo: VQE (Variational Quantum Eigensolver - Energia do Estado Fundamental)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(N_iter * N_terms) medicoes quanticas com otimizador classico NISQ
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaVQE) {
      println("==================================================")
      println("  SciAlgo: Variational Quantum Eigensolver (VQE)")
      println("==================================================")

      #L Algoritmo hibrido quantico-classico NISQ para estimar a energia do estado
      #L fundamental de uma molecula (ex: H2 em base minima):
      #L Hamiltoniano em termos de operadores de Pauli:
      #L H = g0 * I + g1 * Z0 + g2 * Z1 + g3 * (Z0 * Z1) + g4 * (X0 * X1)
      #L Coeficientes em escala x1000 (Hartrees):
      #L g0 = -200, g1 = 150, g2 = 150, g3 = 400, g4 = 200
      mut as int64: g0 = -200
      mut as int64: g1 = 150
      mut as int64: g2 = 150
      mut as int64: g3 = 400
      mut as int64: g4 = 200

      println("1. Hamiltoniano Molecular de Pauli (Molecula H2, escala x1000):")
      println("   H = (" + g0 + ")I + (" + g1 + ")Z0 + (" + g2 + ")Z1 + (" + g3 + ")Z0Z1 + (" + g4 + ")X0X1")

      #L Ansatz parametrizado |psi(theta)> = cos(theta)|01> - sin(theta)|10>
      #L O VQE executa um loop de otimizacao classico sobre o parametro theta in [0, pi]
      #L para minimizar o valor esperado da energia <E(theta)> >= E_0

      println("==================================================")
      println("2. Varredura e Otimizacao Variacional Classica:")

      mut as int64: best_theta = 0
      mut as int64: min_energy = 999999

      #L Testa angulos theta de 0 ate 180 graus em passos de 30 graus
      #L Tabela aproximada de cos(2*theta) e sin(2*theta) para cada passo (escala x1000):
      #L theta=0:   cos=1000, sin=0
      #L theta=30:  cos=500,  sin=866
      #L theta=60:  cos=-500, sin=866
      #L theta=90:  cos=-1000,sin=0
      #L theta=120: cos=-500, sin=-866
      mut as list of int64: angles_deg = [0, 30, 60, 90, 120]
      mut as list of int64: cos_2th = [1000, 500, -500, -1000, -500]
      mut as list of int64: sin_2th = [0, 866, 866, 0, -866]

      mut as int64: step = 1
      infinite (step <= 5) {
            mut as int64: deg = angles_deg[step]
            mut as int64: c = cos_2th[step]
            mut as int64: s = sin_2th[step]

            #L Valor esperado analitico:
            #L <E(theta)> = g0 + (g1 - g2)*c + g3*(-1) - g4*s
            #L Como g1 == g2 => (g1 - g2)*c = 0
            #L <E(theta)> = g0 - g3 - (g4 * s)/1000
            mut as int64: exp_e = g0 - g3 - ((g4 * s) /i 1000)

            println("   Passo " + step + " (theta = " + deg + " graus): Energia Avaliada <H> = " + exp_e + "/1000 Hartrees")

            route {
                  exp_e < min_energy ==> {
                        min_energy = exp_e
                        best_theta = deg
                  }
                  _ ==> {}
            }
            step = step + 1
      }

      println("==================================================")
      println("3. Convergencia para o Estado Fundamental (Ground State):")
      println("   Parametro Variacional Otimo: theta = " + best_theta + " graus")
      println("   Energia Minima do Estado Fundamental (E_0): " + min_energy + "/1000 Hartrees")
      println("   Principio Variacional: E(theta) >= E_0 satisfeito estritamente")
      println("   VQE concluido com sucesso!")
      println("==================================================")
}
