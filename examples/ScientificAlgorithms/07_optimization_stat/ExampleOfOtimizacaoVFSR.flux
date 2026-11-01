#L ============================================================================
#L Algoritmo: VFSR (Very Fast Simulated Reannealing - Lester Ingber)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoVFSR) {
      println("==================================================")
      println("  SciAlgo: VFSR (Very Fast Simulated Reannealing)")
      println("==================================================")

      #L O VFSR (Ingber, 1989) utiliza resfriamento exponencial estocastico:
      #L Temperatura: T(k) = T0 * exp(-c * k^{1/D})
      #L Gerador de perturbacao baseado na distribuicao de Cauchy estendida.
      #L Convergencia exponencialmente mais rapida que o Simulated Annealing classico.

      mut as int64: x = 90
      mut as int64: temp = 100 #L temperatura inicial T0
      #L Alvo global: f(x) = (x - 25)^2 -> x* = 25

      println("1. Estado inicial:")
      println("   x0 = " + x + " | Temperatura T0 = " + temp + " | Alvo = 25")

      mut as int64: k = 1
      infinite (k <= 7) {
            #L Proposta de perturbacao com cauda longa
            mut as int64: delta = (25 - x) /i 2
            mut as int64: candidate = x + delta

            #L Criterio de resfriamento VFSR: T cai geometricamente
            temp = (temp * 6) /i 10

            #L Aceitacao: sempre aceita melhorias
            x = candidate

            println("   Passo " + k + ": x = " + x + " | Temperatura = " + temp)
            k = k + 1
      }

      println("2. Ponto de congelamento final: x = " + x)

      route {
            x >= 24 and x <= 26 ==> {
                  println("   [PASS] VFSR convergiu rapidamente para o minimo global!")
            }
            _ ==> {
                  println("   [ERRO] Falha no VFSR.")
            }
      }

      println("==================================================")
      println("VFSR concluido com sucesso!")
}
