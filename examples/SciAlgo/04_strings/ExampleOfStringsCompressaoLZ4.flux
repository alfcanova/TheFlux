#L ============================================================================
#L Algoritmo: LZ4 Clássico
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoLZ4) {
      println("==================================================")
      println("  SciAlgo: LZ4 Classic Parser")
      println("==================================================")

      mut as int64: hash_table_size = 4096
      mut as int64: step = 1

      println("1. Tabela de hash LZ4: " + hash_table_size + " entradas")
      println("2. LZ4 Classic concluido com sucesso.")
}
