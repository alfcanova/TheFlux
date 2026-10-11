#L ============================================================================
#L Algoritmo: Quickhull Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaQuickhull) {
      println("==================================================")
      println("  SciAlgo: Quickhull Algorithm")
      println("==================================================")

      mut as int64: x1 = 0
      mut as int64: y1 = 0
      mut as int64: x2 = 10
      mut as int64: y2 = 0
      mut as int64: px = 5
      mut as int64: py = 8
      mut as int64: dist = (y2 - y1) * px - (x2 - x1) * py + x2 * y1 - y2 * x1
      route { dist < 0 ==> { dist = 0 - dist } _ ==> {} }

      println("1. Distancia do vertice extremo a aresta base no Quickhull: " + dist)
      println("2. Quickhull Algorithm concluido com sucesso.")
}
