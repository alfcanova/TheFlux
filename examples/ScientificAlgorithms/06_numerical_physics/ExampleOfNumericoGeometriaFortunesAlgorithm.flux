#L ============================================================================
#L Algoritmo: Fortune's Beach-Line Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaFortunesAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Fortune's Beach-Line Algorithm")
      println("==================================================")

      mut as int64: directrix_y = 0
      mut as int64: focus_x = 0
      mut as int64: focus_y = 4
      mut as int64: px = 2
      mut as int64: denom = 2 * (focus_y - directrix_y)
      mut as int64: num = (px - focus_x) * (px - focus_x) + focus_y * focus_y - directrix_y * directrix_y
      mut as int64: beach_y = num /i denom

      println("1. Arco de parabola da linha de praia de Fortune: " + beach_y)
      println("2. Fortune's Beach-Line Algorithm concluido com sucesso.")
}
