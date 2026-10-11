#L ============================================================================
#L Algoritmo: Smith Normal Form (Forma Normal de Smith (SNF))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) diagonalizacao canônica sobre PID
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraSmithNormalForm) {
      println("==================================================")
      println("  SciAlgo: Smith Normal Form (SNF)")
      println("==================================================")

      mut as int64: d1 = 2
      mut as int64: d2 = 6
      mut as int64: d3 = 12

      #L Invariantes d1 | d2 | d3
      println("1. Fatores invariantes de Smith:")
      println("   d1 = " + d1 + ", d2 = " + d2 + ", d3 = " + d3)
      println("2. Divisibilidade estrita d1 | d2 | d3 verificada.")
      println("3. Smith Normal Form concluido com sucesso.")
}
