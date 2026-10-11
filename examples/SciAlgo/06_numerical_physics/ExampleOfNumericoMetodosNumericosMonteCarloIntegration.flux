#L ============================================================================
#L Algoritmo: Monte Carlo Integration
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosMonteCarloIntegration) {
      println("==================================================")
      println("  SciAlgo: Monte Carlo Integration")
      println("==================================================")

      mut as list of int64: samps = [10, 20, 30, 40]
      mut as int64: vol = 5
      mut as int64: n = listLength(samps)
      mut as int64: sum_val = 0
      mut as int64: i = 1
      infinite (i <= n) {
            sum_val = sum_val + samps[i]
            i = i + 1
      }
      mut as int64: mc_res = (sum_val * vol) /i n

      println("1. Integral estimada via Monte Carlo: " + mc_res)
      println("2. Monte Carlo Integration concluido com sucesso.")
}
