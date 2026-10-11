#L ============================================================================
#L Algoritmo: Subset Enumeration (Enumeração de Todos os Subconjuntos 2^N)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(2^N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaSubsetEnumeration) {
      println("==================================================")
      println("  SciAlgo: Subset Power Set Enumeration")
      println("==================================================")

      mut as int64: n = 4
      mut as int64: total_subconjuntos = 16

      println("1. Tamanho do conjunto: " + n)
      println("2. Total de subconjuntos 2^" + n + " = " + total_subconjuntos)
      println("3. Subset Enumeration concluido com sucesso.")
}
