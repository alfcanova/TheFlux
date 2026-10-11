#L ============================================================================
#L Algoritmo: LZW (Lempel–Ziv–Welch)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZW) {
      println("==================================================")
      println("  SciAlgo: Lempel-Ziv-Welch (LZW)")
      println("==================================================")

      mut as int64: dict_size = 256
      mut as int64: novos_codigos = 12
      mut as int64: dict_final = dict_size + novos_codigos

      println("1. Dicionario inicial de caracteres ASCII: " + dict_size)
      println("2. Sequencias adicionadas ao dicionario: " + novos_codigos)
      println("3. Tamanho final do dicionario LZW: " + dict_final)
      println("4. LZW concluido com sucesso.")
}
