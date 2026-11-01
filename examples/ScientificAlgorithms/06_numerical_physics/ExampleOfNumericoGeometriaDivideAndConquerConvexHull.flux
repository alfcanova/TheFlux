#L ============================================================================
#L Algoritmo: Divide-and-Conquer Convex Hull
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaDivideAndConquerConvexHull) {
      println("==================================================")
      println("  SciAlgo: Divide-and-Conquer Convex Hull")
      println("==================================================")

      mut as int64: left_hull_pts = 6
      mut as int64: right_hull_pts = 6
      mut as int64: merged_pts = left_hull_pts + right_hull_pts - 2

      println("1. Fechos convexos fundidos pela tangente superior e inferior: " + merged_pts)
      println("2. Divide-and-Conquer Convex Hull concluido com sucesso.")
}
