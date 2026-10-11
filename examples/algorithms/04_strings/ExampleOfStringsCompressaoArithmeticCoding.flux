#L ============================================================================
#L Algoritmo: Arithmetic Coding (Codificação Aritmética de Subintervalos)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoArithmeticCoding) {
      println("==================================================")
      println("  SciAlgo: Arithmetic Coding Model")
      println("==================================================")

      mut as int64: low = 0
      mut as int64: high = 1000
      mut as int64: range_val = high - low

      #L Subdivisão de intervalo proporcional às probabilidades
      mut as int64: sym_low = 200
      mut as int64: sym_high = 600

      low = low + ((range_val * sym_low) /i 1000)
      high = low + ((range_val * (sym_high - sym_low)) /i 1000)

      println("1. Subintervalo refinado: [" + low + ", " + high + ")")
      println("2. Arithmetic Coding concluido com sucesso.")
}
