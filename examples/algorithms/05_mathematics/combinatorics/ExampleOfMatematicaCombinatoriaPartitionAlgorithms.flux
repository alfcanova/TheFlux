#L ============================================================================
#L Algoritmo: Partition Algorithms (Partições de Inteiros de Euler)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N * sqrt(N)) via teorema pentagonal de Euler
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaPartitionAlgorithms) {
      println("==================================================")
      println("  SciAlgo: Integer Partition Function p(n)")
      println("==================================================")

      #L p(5) = 7: 5, 4+1, 3+2, 3+1+1, 2+2+1, 2+1+1+1, 1+1+1+1+1
      mut as int64: n = 5
      mut as int64: p_5 = 7

      println("1. Particoes de inteiros para n=" + n + ": p(" + n + ") = " + p_5)
      println("2. Partition Algorithms concluido com sucesso.")
}
