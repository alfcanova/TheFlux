#L ============================================================================
#L Algoritmo: Delta Encoding (Diferenciação Sucessiva de Sinais)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) tempo e espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoDeltaEncoding) {
      println("==================================================")
      println("  SciAlgo: Delta Encoding")
      println("==================================================")

      mut as list of int64: valores = [100, 102, 105, 104, 108]
      mut as int64: n = listLength(valores)
      mut as list of int64: deltas = [100, 0, 0, 0, 0]

      mut as int64: i = 2
      infinite (i <= n) {
            deltas[i] = valores[i] - valores[i - 1]
            i = i + 1
      }

      println("1. Dados originais de tamanho: " + n)
      println("2. Deltas: [" + deltas[1] + ", " + deltas[2] + ", " + deltas[3] + ", " + deltas[4] + ", " + deltas[5] + "]")
      println("3. Delta Encoding concluido com sucesso.")
}
