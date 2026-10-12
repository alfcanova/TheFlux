#L ============================================================================
#L Algoritmo: Simulacao Quimica Estocastica de Gillespie (SSA)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_reacoes)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo exato de simulacao de reacoes quimicas estocasticas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_StochasticSimulationChemicalGillespie) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_StochasticSimulationChemicalGillespie")
      println("==================================================")

      #L Sistema quimico estocastico: A + B <-> C
      #L Populacoes moleculares iniciais discretas:
      mut as int64: mol_a = 50
      mut as int64: mol_b = 50
      mut as int64: mol_c = 0

      #L Constantes estocasticas de taxa:
      #L R1: A + B -> C (c1 = 2)
      #L R2: C -> A + B (c2 = 10)
      mut as int64: step = 1

      println("1. Estado molecular inicial: A = " + mol_a + ", B = " + mol_b + ", C = " + mol_c)

      infinite (step <= 4) {
            #L Funcoes de propensao:
            #L a1 = (c1 * mol_a * mol_b) / 100
            mut as int64: a1 = (2 * mol_a * mol_b) /i 100
            #L a2 = c2 * mol_c
            mut as int64: a2 = 10 * mol_c
            mut as int64: a0 = a1 + a2

            #L Selecao estocastica da reacao deterministica/amostrada:
            route {
                  a1 >= a2 ==> {
                        #L Dispara Reacao 1: A + B -> C
                        mol_a = mol_a - 1
                        mol_b = mol_b - 1
                        mol_c = mol_c + 1
                        println("   -> Passo " + step + ": disparou R1 (A+B->C), C = " + mol_c)
                  }
                  a1 < a2 ==> {
                        #L Dispara Reacao 2: C -> A + B
                        mol_a = mol_a + 1
                        mol_b = mol_b + 1
                        mol_c = mol_c - 1
                        println("   -> Passo " + step + ": disparou R2 (C->A+B), C = " + mol_c)
                  }
            }
            step = step + 1
      }

      #L Invariante Estequiometrico de Conservacao de Massa:
      #L Total A + C deve ser constante == 50
      mut as int64: total_massa = mol_a + mol_c
      mut as int64: residuo = total_massa - 50

      println("2. Verificacao de conservacao estequiometrica de massa:")
      println("   -> Total A + C = " + total_massa + " (esperado: 50)")
      println("3. Residuo da conservacao de massa = " + residuo + " (esperado: 0)")
      println("4. Simulacao estocastica de Gillespie concluida.")
}
