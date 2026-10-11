#L ============================================================================
#L Algoritmo: Golomb Coding (Codificação de Golomb de Divisão Geométrica)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(1) por número codificado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoGolombCoding) {
      println("==================================================")
      println("  SciAlgo: Golomb Coding")
      println("==================================================")

      mut as int64: x = 17
      mut as int64: m = 5

      mut as int64: q = x /i m
      mut as int64: r = x /r m

      println("1. Numero a codificar: " + x + " com parametro M=" + m)
      println("2. Quociente unario: " + q)
      println("3. Resto binario truncado: " + r)
      println("4. Golomb Coding concluido com sucesso.")
}
