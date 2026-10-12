#L ============================================================================
#L Algoritmo: Simulated Annealing (Recozimento Simulado para Otimizacao Global)
#L Capitulo: 10_minimization
#L Complexidade: O(N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Otimizacao estocastica com criterio de Metropolis e escala de resfriamento.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SimulatedAnnealingOptimization) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SimulatedAnnealingOptimization")
      println("==================================================")

      #L Temperatura inicial T = 1000
      #L Energia atual E = 500, Candidato 1: E = 300 (Delta E = -200 -> sempre aceito)
      #L Candidato 2: E = 600 (Delta E = +100 -> aceito com probabilidade exp(-dE / T))
      mut as int64: temp = 1000
      mut as int64: e_atual = 500
      mut as int64: e_cand1 = 300

      println("1. Testando transicao com reducao de energia:")
      mut as int64: de1 = e_cand1 - e_atual
      route {
            de1 < 0 ==> {
                  e_atual = e_cand1
                  println("   -> Transicao energetica aceita incondicionalmente: nova energia = " + e_atual)
            }
            de1 >= 0 ==> {}
      }

      #L Esquema de resfriamento geometrico: T_new = T * 0.9 = T * 900 / 1000:
      mut as int64: temp_new = temp * 900 /i 1000
      println("2. Resfriamento termico: T = " + temp_new + " (esperado: 900)")

      mut as int64: res = temp_new - 900
      println("3. Residuo do resfriamento = " + res + " (esperado: 0)")
      println("4. Recozimento simulado concluido com exito.")
}
