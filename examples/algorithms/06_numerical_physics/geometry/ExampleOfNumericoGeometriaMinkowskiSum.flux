#L ============================================================================
#L Algoritmo: Minkowski Sum
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaMinkowskiSum) {
      println("==================================================")
      println("  SciAlgo: Minkowski Sum")
      println("==================================================")

      mut as int64: ax = 3
      mut as int64: ay = 4
      mut as int64: bx = 1
      mut as int64: by = 2
      mut as int64: sum_x = ax + bx
      mut as int64: sum_y = ay + by
      mut as int64: sum_total = sum_x + sum_y

      println("1. Ponto resultante da soma de Minkowski A + B: " + sum_total)
      println("2. Minkowski Sum concluido com sucesso.")
}
