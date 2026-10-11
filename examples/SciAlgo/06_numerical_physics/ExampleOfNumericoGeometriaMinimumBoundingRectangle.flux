#L ============================================================================
#L Algoritmo: Minimum Bounding Rectangle
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaMinimumBoundingRectangle) {
      println("==================================================")
      println("  SciAlgo: Minimum Bounding Rectangle")
      println("==================================================")

      mut as int64: min_x = 2
      mut as int64: max_x = 8
      mut as int64: min_y = 3
      mut as int64: max_y = 7
      mut as int64: aabb_area = (max_x - min_x) * (max_y - min_y)

      println("1. Area do retangulo envolvente minimo (AABB): " + aabb_area)
      println("2. Minimum Bounding Rectangle concluido com sucesso.")
}
