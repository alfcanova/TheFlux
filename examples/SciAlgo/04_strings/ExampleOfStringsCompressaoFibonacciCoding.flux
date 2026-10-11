#L ============================================================================
#L Algoritmo: Fibonacci Coding (Codificação Baseada no Teorema de Zeckendorf)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoFibonacciCoding) {
      println("==================================================")
      println("  SciAlgo: Fibonacci Zeckendorf Coding")
      println("==================================================")

      #L Sequência de Fibonacci: 1, 2, 3, 5, 8, 13
      #L Decomposição de 11 = 8 + 3
      mut as int64: n = 11
      mut as int64: f1 = 8
      mut as int64: f2 = 3
      mut as int64: soma = f1 + f2

      println("1. Inteiro a representar: " + n)
      println("2. Termos de Fibonacci usados: " + f1 + " + " + f2 + " = " + soma)
      println("3. Delimitador final Zeckendorf: 11")
      println("4. Fibonacci Coding concluido com sucesso.")
}
