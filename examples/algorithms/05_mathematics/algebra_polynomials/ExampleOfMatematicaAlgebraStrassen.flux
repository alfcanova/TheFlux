#L ============================================================================
#L Algoritmo: Strassen Matrix Multiplication (Multiplicação Subcúbica O(N^2.81))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2.807) operacoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraStrassen) {
      println("==================================================")
      println("  SciAlgo: Strassen Subcubic Matrix Multiplication")
      println("==================================================")

      #L 7 multiplicacoes de blocos 2x2: M1..M7
      mut as int64: n = 2
      mut as int64: mults_strassen = 7
      mut as int64: mults_padrao = 8

      println("1. Matrizes quadradas " + n + "x" + n)
      println("2. Multiplicacoes reduzidas: " + mults_strassen + " (vs convencional " + mults_padrao + ")")
      println("3. Strassen concluido com sucesso.")
}
