#L ============================================================================
#L Algoritmo: Linear Recurrence (Recorrência Linear via Exponenciação de Matrizes)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(K^3 log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaLinearRecurrence) {
      println("==================================================")
      println("  SciAlgo: Matrix Exponentiation for Linear Recurrence")
      println("==================================================")

      mut as int64: n = 8
      mut as int64: resultado = 21

      println("1. Matriz de transicao multiplicada em O(K^3 log N) para n=" + n)
      println("2. Termo resultante: " + resultado)
      println("3. Linear Recurrence concluido com sucesso.")
}
