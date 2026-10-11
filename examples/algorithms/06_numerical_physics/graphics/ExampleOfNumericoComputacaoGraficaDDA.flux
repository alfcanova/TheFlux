#L ============================================================================
#L Algoritmo: Digital Differential Analyzer (DDA)
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaDDA) {
      println("==================================================")
      println("  SciAlgo: Digital Differential Analyzer (DDA)")
      println("==================================================")

      mut as int64: x0 = 2
      mut as int64: y0 = 3
      mut as int64: x1 = 12
      mut as int64: y1 = 8
      mut as int64: dx = x1 - x0
      mut as int64: dy = y1 - y0
      mut as int64: steps_dda = dx
      route { dy > dx ==> { steps_dda = dy } _ ==> {} }
      mut as int64: total_pts = steps_dda + 1

      println("1. Pontos interpolados DDA: " + total_pts)
      println("2. Digital Differential Analyzer (DDA) concluido com sucesso.")
}
