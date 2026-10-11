#L ============================================================================
#L Algoritmo: Inclusion-Exclusion (Princípio da Inclusão-Exclusão)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(2^N) operacoes de uniao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaInclusionExclusion) {
      println("==================================================")
      println("  SciAlgo: Principle of Inclusion-Exclusion")
      println("==================================================")

      mut as int64: a = 50
      mut as int64: b = 40
      mut as int64: c = 30
      mut as int64: ab = 15
      mut as int64: ac = 10
      mut as int64: bc = 8
      mut as int64: abc = 5

      mut as int64: uniao = a + b + c - ab - ac - bc + abc

      println("1. Tamanho dos tres conjuntos: " + a + ", " + b + ", " + c)
      println("2. Uniao total calculada via PIE: " + uniao)
      println("3. Inclusion-Exclusion concluido com sucesso.")
}
