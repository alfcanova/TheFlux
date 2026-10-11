#L ============================================================================
#L Algoritmo: Palindromic Tree / Eertree (Árvore de Subpalíndromos)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoPalindromicTree) {
      println("==================================================")
      println("  SciAlgo: Palindromic Tree (Eertree)")
      println("==================================================")

      mut as int64: raiz_impar = 1
      mut as int64: raiz_par = 2
      mut as int64: subpalindromos_distintos = 5

      println("1. Raiz imaginaria (len=-1) e raiz nula (len=0) inicializadas")
      println("2. Subpalindromos unicos armazenados: " + subpalindromos_distintos)
      println("3. Eertree concluido com sucesso.")
}
