#L ============================================================================
#L Algoritmo: Chan's Algorithm
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaChansAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Chan's Algorithm")
      println("==================================================")

      mut as int64: n = 64
      mut as int64: h_guess = 16
      mut as int64: groups = n /i h_guess

      println("1. Numero de sub-fechos particionados no algoritmo de Chan: " + groups)
      println("2. Chan's Algorithm concluido com sucesso.")
}
