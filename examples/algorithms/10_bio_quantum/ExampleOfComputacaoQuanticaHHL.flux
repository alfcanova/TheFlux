#L ============================================================================
#L Algoritmo: HHL (Harrow-Hassidim-Lloyd - Sistemas Lineares Quanticos)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(log(N) * s^2 * kappa^2 / eps) tempo exponencialmente acelerado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaHHL) {
      println("==================================================")
      println("  SciAlgo: HHL Quantum Linear Systems Algorithm")
      println("==================================================")

      #L O algoritmo HHL resolve a equacao matricial A |x> = |b>
      #L produzindo o estado quantico |x> proporcional a A^(-1) |b>.
      #L Sistema 2x2 com matriz Hermitiana A diagonal:
      #L A = [[2, 0], [0, 4]]
      #L Autovalores de A: lambda_1 = 2, lambda_2 = 4
      #L Numero de condicao kappa = lambda_max / lambda_min = 4 / 2 = 2.0
      #L Vetor |b> = 1/sqrt(2) * (|0> + |1>) (superposicao uniforme)

      mut as int64: lambda1 = 2
      mut as int64: lambda2 = 4
      mut as int64: cond_kappa = 2

      println("1. Parametros do Sistema Linear A |x> = |b>:")
      println("   Matriz A 2x2 com autovalores: lambda_1 = " + lambda1 + ", lambda_2 = " + lambda2)
      println("   Numero de Condicao da Matriz: kappa = " + cond_kappa)
      println("   Vetor de Entrada |b>: 1/sqrt(2) * (|0> + |1>)")

      println("==================================================")
      println("2. Etapa 1: Estimacao de Fase Quantica (QPE sobre exp(i*A*t)):")
      println("   QPE decompoe o vetor |b> na base de autoestados de A:")
      println("   |b> = sum_j beta_j |u_j> -> sum_j beta_j |u_j> |lambda_j>")
      println("   Autoestado |0> codifica autovalor lambda_1 = 2")
      println("   Autoestado |1> codifica autovalor lambda_2 = 4")

      println("==================================================")
      println("3. Etapa 2: Rotacao Controlada da Ancilla por C / lambda_j:")
      println("   Rotaciona ancilla por arcsin(C / lambda_j), onde constante C = 1")
      #L Amplitudes de inversao (C / lambda):
      #L Para lambda_1 = 2: C / lambda_1 = 1/2 = 0.500 (500/1000)
      #L Para lambda_2 = 4: C / lambda_2 = 1/4 = 0.250 (250/1000)
      mut as int64: inv_amp1 = 500 #L 1/2
      mut as int64: inv_amp2 = 250 #L 1/4

      println("   Inversao para lambda_1: C / 2 = " + inv_amp1 + "/1000 (0.50)")
      println("   Inversao para lambda_2: C / 4 = " + inv_amp2 + "/1000 (0.25)")

      println("==================================================")
      println("4. Etapa 3: Descomputacao (QPE^dagger) e Pos-Selecao:")
      println("   Descomputa o registrador de fase QPE para restaurar coerencia.")
      println("   Medicao da ancilla no estado |1> projeta o vetor solucao |x>:")

      #L O estado resultante e |x> = alpha * ( (1/2)|0> + (1/4)|1> )
      #L Razao das amplitudes: x_0 / x_1 = (1/2) / (1/4) = 2.0
      #L Razao das probabilidades: (1/2)^2 / (1/4)^2 = 0.25 / 0.0625 = 4.0
      mut as int64: ratio_amps = inv_amp1 /i inv_amp2
      mut as int64: prob_ratio = (inv_amp1 * inv_amp1) /i (inv_amp2 * inv_amp2)

      println("   Vetor Solucao Normalizado |x> = A^(-1) |b>:")
      println("      Razao de Amplitudes |x_0> / |x_1>: " + ratio_amps + ".0")
      println("      Razao de Probabilidades P(0) / P(1): " + prob_ratio + ".0 (80% |0> vs 20% |1>)")

      route {
            ratio_amps == 2 ==> {
                  println("   Sucesso: Inversao exata do operador linear confirmada com sucesso!")
            }
            _ ==> {}
      }

      println("   HHL Algorithm concluido com sucesso!")
      println("==================================================")
}
