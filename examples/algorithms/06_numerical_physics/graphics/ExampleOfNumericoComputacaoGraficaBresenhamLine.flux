#L ============================================================================
#L Algoritmo: Bresenham Line Algorithm
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaBresenhamLine) {
      println("==================================================")
      println("  SciAlgo: Bresenham Line Algorithm")
      println("==================================================")

      mut as int64: x0 = 0
      mut as int64: y0 = 0
      mut as int64: x1 = 10
      mut as int64: y1 = 5
      mut as int64: dx = x1 - x0
      mut as int64: dy = y1 - y0
      route { dx < 0 ==> { dx = 0 - dx } _ ==> {} }
      route { dy < 0 ==> { dy = 0 - dy } _ ==> {} }
      mut as int64: steps_n = dx
      route { dy > dx ==> { steps_n = dy } _ ==> {} }

      println("1. Total de passos da rasterizacao Bresenham: " + steps_n)
      println("2. Bresenham Line Algorithm concluido com sucesso.")
}
