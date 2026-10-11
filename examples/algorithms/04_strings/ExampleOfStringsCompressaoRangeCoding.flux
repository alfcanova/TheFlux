#L ============================================================================
#L Algoritmo: Range Coding (Codificador de Faixa de Base Byte)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoRangeCoding) {
      println("==================================================")
      println("  SciAlgo: Range Coder")
      println("==================================================")

      mut as int64: low = 0
      mut as int64: range_val = 65536
      mut as int64: freq = 10
      mut as int64: total = 100

      range_val = range_val /i total
      mut as int64: novo_range = range_val * freq

      println("1. Faixa recalculada do codificador: " + novo_range)
      println("2. Range Coding concluido com sucesso.")
}
