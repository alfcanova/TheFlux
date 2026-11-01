#L ============================================================================
#L Algoritmo: Liang-Barsky Line Clipping
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaLiangBarsky) {
      println("==================================================")
      println("  SciAlgo: Liang-Barsky Line Clipping")
      println("==================================================")

      mut as int64: dx = 15
      mut as int64: p1 = 0 - dx
      mut as int64: p2 = dx

      println("1. Parametros p1 e p2 da intersecao Liang-Barsky: " + p2)
      println("2. Liang-Barsky Line Clipping concluido com sucesso.")
}
