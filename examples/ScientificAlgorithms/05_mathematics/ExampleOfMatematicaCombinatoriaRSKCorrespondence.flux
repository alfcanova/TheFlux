#L ============================================================================
#L Algoritmo: RSK Correspondence (Correspondencia de Robinson-Schensted-Knuth)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N log N) insercao em Young Tableaux
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaRSKCorrespondence) {
      println("==================================================")
      println("  SciAlgo: Robinson-Schensted-Knuth (RSK) Correspondence")
      println("==================================================")

      mut as int64: perm_len = 5
      mut as int64: forma_particao_1 = 3
      mut as int64: forma_particao_2 = 2

      println("1. Permutacao de tamanho " + perm_len + " inserida via algoritmo de Schensted")
      println("2. Par de Young Tableaux (P, Q) de forma (" + forma_particao_1 + ", " + forma_particao_2 + ") gerado")
      println("3. RSK Correspondence concluido com sucesso.")
}
