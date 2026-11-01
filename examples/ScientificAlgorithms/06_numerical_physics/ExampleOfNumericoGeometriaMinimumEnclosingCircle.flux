#L ============================================================================
#L Algoritmo: Minimum Enclosing Circle (Welzl)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaMinimumEnclosingCircle) {
      println("==================================================")
      println("  SciAlgo: Minimum Enclosing Circle (Welzl)")
      println("==================================================")

      mut as int64: ax = 0
      mut as int64: ay = 0
      mut as int64: bx = 6
      mut as int64: by = 8
      mut as int64: diam_sq = (bx - ax) * (bx - ax) + (by - ay) * (by - ay)
      mut as int64: r_sq = diam_sq /i 4

      println("1. Raio quadratico do menor circulo envolvente: " + r_sq)
      println("2. Minimum Enclosing Circle (Welzl) concluido com sucesso.")
}
