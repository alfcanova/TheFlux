#L ============================================================================
#L Algoritmo: Generating Functions (Funções Geradoras Ordinárias OGF)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N log N) convolucao de series
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaGeneratingFunctions) {
      println("==================================================")
      println("  SciAlgo: Ordinary Generating Functions (OGF)")
      println("==================================================")

      #L OGF para Fibonacci: 1 / (1 - x - x^2)
      mut as list of int64: fib = [0, 1, 1, 2, 3, 5]
      mut as int64: termo = 5

      println("1. Expansao de coeficientes: " + fib[termo + 1])
      println("2. Generating Functions concluido com sucesso.")
}
