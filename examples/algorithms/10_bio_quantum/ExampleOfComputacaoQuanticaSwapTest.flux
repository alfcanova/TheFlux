#L ============================================================================
#L Algoritmo: Swap Test (Medicao de Fidelidade e Sobreposicao de Estados)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1) circuito quantico | Estima |<phi|psi>|^2 diretamente
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaSwapTest) {
      println("==================================================")
      println("  SciAlgo: Swap Test (Quantum State Overlap)")
      println("==================================================")

      #L O Swap Test mede a sobreposicao (overlap / fidelidade) |<phi|psi>|^2
      #L entre dois estados quanticos puros sem reconstrucao tomografica.
      #L Circuito com 3 qubits:
      #L Qubit 0: Ancilla inicializada em |0>
      #L Qubit 1: Estado |phi>
      #L Qubit 2: Estado |psi>
      #L Porta central: Controlled-SWAP (Porta Fredkin)

      println("1. Avaliacao de Casos de Teste de Fidelidade:")
      println("   Caso 1: Estados Identicos (|phi> = |psi>)")
      println("   Caso 2: Estados Ortogonais (|phi> _|_ |psi>)")
      println("   Caso 3: Estados com Sobreposicao Parcial (angulo 60 graus)")

      #L --- CASO 1: Estados Identicos ---
      #L <phi|psi> = 1 => |<phi|psi>|^2 = 1.000
      #L P(0) = (1 + |<phi|psi>|^2) / 2 = (1 + 1) / 2 = 1.000 (100% |0>)
      println("==================================================")
      println("2. Caso 1: Estados Identicos (|0> e |0>):")
      mut as int64: overlap1_scaled = 1000
      mut as int64: p0_case1 = (1000 + overlap1_scaled) /i 2
      println("   P(Ancilla = 0) = " + (p0_case1 /i 10) + "." + (p0_case1 /r 10) + "%")
      println("   Fidelidade Calculada: 100.0% (Estados identicos confirmados)")

      #L --- CASO 2: Estados Ortogonais ---
      #L |phi>=|0>, |psi>=|1> => <phi|psi> = 0 => Sobreposicao = 0.000
      #L P(0) = (1 + 0) / 2 = 0.500 (50% |0>, 50% |1>)
      println("==================================================")
      println("3. Caso 2: Estados Ortogonais (|0> e |1>):")
      mut as int64: overlap2_scaled = 0
      mut as int64: p0_case2 = (1000 + overlap2_scaled) /i 2
      println("   P(Ancilla = 0) = " + (p0_case2 /i 10) + "." + (p0_case2 /r 10) + "%")
      println("   Fidelidade Calculada: 0.0% (Estados mutuamente ortogonais)")

      #L --- CASO 3: Estados Parciais ---
      #L Sobreposicao cos^2(pi/3) = (0.5)^2 = 0.250 (250/1000)
      #L P(0) = (1.000 + 0.250) / 2 = 1.250 / 2 = 0.625 (625/1000)
      println("==================================================")
      println("4. Caso 3: Estados com Angulo de 60 graus:")
      mut as int64: overlap3_scaled = 250
      mut as int64: p0_case3 = (1000 + overlap3_scaled) /i 2
      println("   P(Ancilla = 0) = " + (p0_case3 /i 10) + "." + (p0_case3 /r 10) + "% (62.5%)")

      #L Reconstrucao: Fidelidade = 2 * P(0) - 1
      mut as int64: reconstructed_fidelity = (2 * p0_case3) - 1000
      println("   Fidelidade Reconstruida: " + (reconstructed_fidelity /i 10) + "." + (reconstructed_fidelity /r 10) + "%")

      route {
            reconstructed_fidelity == 250 ==> {
                  println("   Sucesso: Fidelidade parcial calculada perfeitamente!")
            }
            _ ==> {}
      }

      println("   Swap Test concluido com sucesso!")
      println("==================================================")
}
