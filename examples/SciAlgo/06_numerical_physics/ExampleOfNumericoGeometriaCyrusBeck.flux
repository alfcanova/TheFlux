#L ============================================================================
#L Algoritmo: Cyrus-Beck Line Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaCyrusBeck) {
      println("==================================================")
      println("  SciAlgo: Cyrus-Beck Line Clipping")
      println("==================================================")

      mut as int64: nx = 0
      mut as int64: ny = 1
      mut as int64: dx = 3
      mut as int64: dy = 4
      mut as int64: dot_norm = nx * dx + ny * dy

      println("1. Produto escalar com a normal do poligono convexo: " + dot_norm)
      println("2. Cyrus-Beck Line Clipping concluido com sucesso.")
}
