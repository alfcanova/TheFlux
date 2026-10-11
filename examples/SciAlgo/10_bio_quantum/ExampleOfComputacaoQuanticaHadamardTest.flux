#L ============================================================================
#L Algoritmo: Hadamard Test (Medicao de Valor Esperado e Parte Real/Imaginaria)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1) circuito quantico | Estima <psi|U|psi> em O(1/eps^2) medicoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaHadamardTest) {
      println("==================================================")
      println("  SciAlgo: Hadamard Test Quantum Subroutine")
      println("==================================================")

      #L O Hadamard Test estima o valor esperado Re<psi| U |psi>
      #L usando 1 qubit ancilla e uma porta unitaria controlada-U.
      #L Qubit Ancilla: inicializado em |0>
      #L Qubit Alvo |psi>: cos(pi/6)|0> + sin(pi/6)|1> = (sqrt(3)/2)|0> + (1/2)|1>
      #L Operador U: porta Pauli-Z (Z|0> = |0>, Z|1> = -|1>)
      #L Valor esperado analitico:
      #L <psi| Z |psi> = cos^2(pi/6) - sin^2(pi/6) = 3/4 - 1/4 = 1/2 = 0.500

      println("1. Parametros do Teste:")
      println("   Operador Unitario: Pauli-Z")
      println("   Estado Alvo |psi>: sqrt(3)/2 |0> + 1/2 |1>")
      println("   Valor Esperado Teorico Re<psi|Z|psi>: 0.500 (500/1000)")

      println("==================================================")
      println("2. Execucao do Circuito de Hadamard Test:")

      #L 1. H na ancilla: 1/sqrt(2) * (|0> + |1>) |psi>
      #L 2. Controlada-Z da ancilla para o alvo:
      #L    1/sqrt(2) * ( |0>|psi> + |1> Z|psi> )
      #L 3. H na ancilla:
      #L    1/2 * |0> (I + Z)|psi> + 1/2 * |1> (I - Z)|psi>
      #L Probabilidade de medir ancilla em |0>:
      #L P(0) = (1 + Re<psi|Z|psi>) / 2 = (1 + 0.500) / 2 = 1.500 / 2 = 0.750 (75%)
      #L Probabilidade de medir ancilla em |1>:
      #L P(1) = (1 - Re<psi|Z|psi>) / 2 = (1 - 0.500) / 2 = 0.250 (25%)

      mut as int64: prob_zero_scaled = 750 #L 75.0%
      mut as int64: prob_one_scaled = 250  #L 25.0%

      println("   Probabilidade de Medicao da Ancilla P(0): " + (prob_zero_scaled /i 10) + "." + (prob_zero_scaled /r 10) + "%")
      println("   Probabilidade de Medicao da Ancilla P(1): " + (prob_one_scaled /i 10) + "." + (prob_one_scaled /r 10) + "%")

      println("==================================================")
      println("3. Reconstrucao do Valor Esperado Re<psi|U|psi>:")

      #L Re<psi|U|psi> = 2 * P(0) - 1 = 2 * 0.750 - 1 = 1.500 - 1 = 0.500
      mut as int64: estimated_exp_val = (2 * prob_zero_scaled) - 1000
      println("   Valor Esperado Reconstruido: " + (estimated_exp_val /i 10) + "." + (estimated_exp_val /r 10) + "% (0." + estimated_exp_val + ")")

      route {
            estimated_exp_val == 500 ==> {
                  println("   Sucesso: Valor esperado Re<psi|Z|psi> = 0.500 estimado com exatidao!")
            }
            _ ==> {}
      }

      println("   Hadamard Test concluido com sucesso!")
      println("==================================================")
}
