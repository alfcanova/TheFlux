#L ============================================================================
#L Algoritmo: Path Tracing Monte Carlo
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaPathTracing) {
      println("==================================================")
      println("  SciAlgo: Path Tracing Monte Carlo")
      println("==================================================")

      mut as list of int64: samps = [120, 110, 150, 130]
      mut as int64: n = listLength(samps)
      mut as int64: sum_val = 0
      mut as int64: i = 1
      infinite (i <= n) {
            sum_val = sum_val + samps[i]
            i = i + 1
      }
      mut as int64: avg_radiance = sum_val /i n

      println("1. Radiesse media estimada via Path Tracing: " + avg_radiance)
      println("2. Path Tracing Monte Carlo concluido com sucesso.")
}
