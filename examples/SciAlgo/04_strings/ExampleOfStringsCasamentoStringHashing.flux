#L ============================================================================
#L Algoritmo: String Hashing (Função de Espalhamento Polinomial)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) calculo do prefix hash
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoStringHashing) {
      println("==================================================")
      println("  SciAlgo: General Polynomial String Hashing")
      println("==================================================")

      mut as list of int64: str = [102, 108, 117, 120]
      mut as int64: n = listLength(str)
      mut as int64: h = 0

      mut as int64: i = 1
      infinite (i <= n) {
            h = ((h * 31) + str[i]) /r 10007
            i = i + 1
      }

      println("1. Tamanho do texto hashificado: " + n)
      println("2. Valor de hash polinomial: " + h)
      println("3. String Hashing concluido com sucesso.")
}
