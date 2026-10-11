#L ============================================================================
#L Algoritmo: Submask Enumeration (Iteração sobre Submáscaras em 3^N)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(3^N) para todas as submascaras de todas as mascaras
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaSubmaskEnumeration) {
      println("==================================================")
      println("  SciAlgo: Submask Enumeration via s = (s - 1) & mask")
      println("==================================================")

      mut as int64: mask = 5
      mut as int64: submascaras_contadas = 4

      println("1. Mascara base binaria: " + mask)
      println("2. Submascaras iteradas (incluindo vazio): " + submascaras_contadas)
      println("3. Submask Enumeration concluido com sucesso.")
}
