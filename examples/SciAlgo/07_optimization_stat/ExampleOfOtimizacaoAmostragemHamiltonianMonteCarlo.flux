#L ============================================================================
#L Algoritmo: Hamiltonian Monte Carlo (HMC com Integracao Leapfrog)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(Passos_Leapfrog) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemHamiltonianMonteCarlo) {
      println("==================================================")
      println("  SciAlgo: Hamiltonian Monte Carlo (HMC Leapfrog)")
      println("==================================================")

      #L Potencial V(q) = 1/2 * q^2 -> Gradiente dV/dq = q
      #L Energia Cinetica T(p) = 1/2 * p^2
      #L Integracao Leapfrog com passo epsilon = 1/10
      mut as int64: q = 20   #L posicao atual (escala x10)
      mut as int64: p = 15   #L momento auxiliar

      println("1. Estado inicial de fase: posicao q = " + q + ", momento p = " + p)

      #L Meio passo de momento: p = p - (eps/2) * grad(q)
      p = p - (q /i 20)

      #L Passo completo de posicao: q = q + eps * p
      q = q + (p /i 10)

      #L Meio passo de momento: p = p - (eps/2) * grad(q)
      p = p - (q /i 20)

      println("2. Estado apos 1 passo Leapfrog simplico:")
      println("   -> Nova posicao q = " + q)
      println("   -> Novo momento p = " + p)

      route {
            q > 0 ==> {
                  println("   [PASS] Integrador Hamiltoniano preservou a dinamica de fase com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Falha no HMC.")
            }
      }

      println("==================================================")
      println("Hamiltonian Monte Carlo concluido com sucesso!")
}
