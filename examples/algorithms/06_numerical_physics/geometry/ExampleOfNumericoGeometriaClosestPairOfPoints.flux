#L ============================================================================
#L Algoritmo: Closest Pair of Points
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaClosestPairOfPoints) {
      println("==================================================")
      println("  SciAlgo: Closest Pair of Points")
      println("==================================================")

      mut as int64: x1 = 2
      mut as int64: y1 = 3
      mut as int64: x2 = 5
      mut as int64: y2 = 7
      mut as int64: dx = x2 - x1
      mut as int64: dy = y2 - y1
      mut as int64: min_d_sq = dx * dx + dy * dy

      println("1. Distancia quadratica minima do par mais proximo: " + min_d_sq)
      println("2. Closest Pair of Points concluido com sucesso.")
}
