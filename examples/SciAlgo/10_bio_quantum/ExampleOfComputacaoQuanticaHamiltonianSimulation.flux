#L ============================================================================
#L Algoritmo: Hamiltonian Simulation (Simulacao Quantica via Formula de Trotter)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(m * r) portas quanticas para decomposicao em r passos de Trotter
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaHamiltonianSimulation) {
      println("==================================================")
      println("  SciAlgo: Quantum Hamiltonian Simulation (Trotter)")
      println("==================================================")

      #L Simulacao da evolucao temporal quantica exp(-i * H * t)
      #L de um Hamiltoniano de 2 qubits H = H_1 + H_2:
      #L H_1 = J * (Z0 * Z1) (termo de interacao de Ising)
      #L H_2 = B * (X0 + X1) (termo de campo magnetico transversal)
      #L Coeficientes em escala x1000:
      mut as int64: j_coupling = 500 #L J = 0.5
      mut as int64: b_field = 800    #L B = 0.8

      #L Tempo total de evolucao t = 1.0 (escala x1000 = 1000)
      mut as int64: total_time = 1000
      mut as int64: trotter_steps = 4
      mut as int64: dt = total_time /i trotter_steps #L dt = 250 (0.25)

      println("1. Parametros do Sistema Fisico:")
      println("   Hamiltoniano H: " + j_coupling + "/1000 (Z0Z1) + " + b_field + "/1000 (X0 + X1)")
      println("   Tempo de Evolucao t = " + total_time + "/1000 s")
      println("   Numero de Passos de Trotter r = " + trotter_steps + " (Passo dt = " + dt + "/1000)")

      println("==================================================")
      println("2. Formula de Produto de Trotter de Primeira Ordem:")
      println("   exp(-i * H * t) ~ [ exp(-i * H_1 * dt) * exp(-i * H_2 * dt) ]^r")

      #L Para cada passo k = 1..r:
      #L Calcula os angulos de rotacao elementares:
      #L theta_zz = 2 * J * dt = 2 * 0.5 * 0.25 = 0.250 rad (250/1000)
      #L theta_x  = 2 * B * dt = 2 * 0.8 * 0.25 = 0.400 rad (400/1000)
      mut as int64: theta_zz = (2 * j_coupling * dt) /i 1000
      mut as int64: theta_x = (2 * b_field * dt) /i 1000

      mut as int64: step = 1
      infinite (step <= trotter_steps) {
            mut as int64: cur_t = step * dt
            println("   Passo Trotter #" + step + " (t = " + cur_t + "/1000):")
            println("      Porta R_ZZ(theta=" + theta_zz + "/1000) em (q0, q1)")
            println("      Porta R_X(theta=" + theta_x + "/1000) em q0 e q1")
            step = step + 1
      }

      println("==================================================")
      println("3. Analise de Erro de Discretizacao de Trotter:")

      #L Erro de comutador [H_1, H_2]:
      #L O erro de primeira ordem escala com ||[H_1, H_2]|| * t^2 / (2 * r)
      #L Norma do comutador aproximada: 2 * J * B = 2 * 0.5 * 0.8 = 0.800
      mut as int64: comm_norm = (2 * j_coupling * b_field) /i 1000
      mut as int64: trotter_error = (comm_norm * 1000) /i (2 * trotter_steps)

      println("   Norma do Comutador ||[H_1, H_2]||: " + comm_norm + "/1000")
      println("   Limite Superior do Erro de Trotter: ~" + trotter_error + "/1000 (0.100)")
      println("   Fidelidade da Simulacao: > 90% (Convergente com r -> infinito)")
      println("   Hamiltonian Simulation concluido com sucesso!")
      println("==================================================")
}
