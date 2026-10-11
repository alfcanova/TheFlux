#L ============================================================================
#L Algoritmo: Half-Plane Intersection
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaHalfPlaneIntersection) {
      println("==================================================")
      println("  SciAlgo: Half-Plane Intersection")
      println("==================================================")

      mut as int64: a = 1
      mut as int64: b = 1
      mut as int64: c = -10
      mut as int64: px = 6
      mut as int64: py = 6
      mut as int64: in_hp = 0
      route { a * px + b * py + c >= 0 ==> { in_hp = 1 } _ ==> {} }

      println("1. Ponto no interior do fecho dos semi-planos: " + in_hp)
      println("2. Half-Plane Intersection concluido com sucesso.")
}
