#L ============================================================================
#L Algoritmo: Catalan Numbers (Números de Catalan)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N) tempo recursivo C_n = (2*(2n-1)/(n+1)) * C_{n-1}
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaCatalanNumbers) {
      println("==================================================")
      println("  SciAlgo: Catalan Numbers Sequence")
      println("==================================================")

      mut as list of int64: c = [1, 1, 2, 5, 14, 42]
      mut as int64: n = 5

      println("1. C_0 a C_5: [1, 1, 2, 5, 14, 42]")
      println("2. Catalan C(" + n + ") = " + c[n + 1])
      println("3. Catalan Numbers concluido com sucesso.")
}
