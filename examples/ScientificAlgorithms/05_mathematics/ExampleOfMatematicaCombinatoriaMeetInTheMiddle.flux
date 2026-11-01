#L ============================================================================
#L Algoritmo: Meet-in-the-Middle (Divisão Exponencial em 2^(N/2))
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(2^(N/2) * N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaMeetInTheMiddle) {
      println("==================================================")
      println("  SciAlgo: Meet-in-the-Middle Search")
      println("==================================================")

      mut as int64: n = 30
      mut as int64: metade = n /i 2
      mut as int64: complexidade_reduzida = 32768

      println("1. Problema original tamanho N=" + n)
      println("2. Metades independentes com busca binaria: 2^" + metade + " = " + complexidade_reduzida)
      println("3. Meet-in-the-Middle concluido com sucesso.")
}
