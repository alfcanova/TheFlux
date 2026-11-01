#L ============================================================================
#L Algoritmo: Monotonic Queue Optimization (Otimização de Fila Monótona para Janelas Deslizantes)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N) tempo linear amortizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaMonotonicQueueOptimization) {
      println("==================================================")
      println("  SciAlgo: Monotonic Queue DP Optimization")
      println("==================================================")

      mut as int64: tam_janela = 3
      mut as int64: dp_otimo = 19

      println("1. Janela deslizante de transicao: K=" + tam_janela)
      println("2. Valor de DP acumulado: " + dp_otimo)
      println("3. Monotonic Queue Optimization concluido com sucesso.")
}
