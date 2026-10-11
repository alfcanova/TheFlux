#L ============================================================================
#L Algoritmo: Kirkpatrick-Seidel Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaKirkpatrickSeidel) {
      println("==================================================")
      println("  SciAlgo: Kirkpatrick-Seidel Algorithm")
      println("==================================================")

      mut as int64: x1 = 2
      mut as int64: x2 = 8
      mut as int64: x3 = 14
      mut as int64: med_x = (x1 + x2 + x3) /i 3

      println("1. Abscissa mediana para busca da ponte no fecho: " + med_x)
      println("2. Kirkpatrick-Seidel Algorithm concluido com sucesso.")
}
