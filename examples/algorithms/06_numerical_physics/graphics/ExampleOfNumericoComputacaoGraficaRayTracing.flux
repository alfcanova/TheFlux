#L ============================================================================
#L Algoritmo: Ray Tracing
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaRayTracing) {
      println("==================================================")
      println("  SciAlgo: Ray Tracing")
      println("==================================================")

      mut as int64: light = 100
      mut as int64: total_light = 0
      mut as int64: bounce = 0
      infinite (bounce < 3) {
            total_light = total_light + light
            light = (light * 75) /i 100
            bounce = bounce + 1
      }

      println("1. Luz acumulada atraves de reflexoes recursivas: " + total_light)
      println("2. Ray Tracing concluido com sucesso.")
}
