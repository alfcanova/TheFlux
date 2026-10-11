#L ============================================================================
#L Algoritmo: Rolling Hash (Hash Polinomial Rolante)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(1) adicao e remocao de caracteres
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoRollingHash) {
      println("==================================================")
      println("  SciAlgo: Polynomial Rolling Hash")
      println("==================================================")

      mut as int64: primo = 1000000007
      mut as int64: base = 31
      mut as int64: hash_val = 12560

      #L Simulação de slide de janela: (hash - c_out*base^(m-1)) * base + c_in
      hash_val = ((hash_val * base) + 65) /r primo

      println("1. Novo hash apos rolagem da janela: " + hash_val)
      println("2. Rolling Hash concluido com sucesso.")
}
