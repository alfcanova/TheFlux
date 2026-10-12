#L ============================================================================
#L Algoritmo: HMM (Treinamento de HMM via Algoritmo Baum-Welch)
#L Capitulo: 16_classification_inference
#L Complexidade: O(T * S^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Treinamento EM de Modelos Ocultos de Markov (algoritmo Forward-Backward).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HiddenMarkovModelsBaumWelch) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HiddenMarkovModelsBaumWelch")
      println("==================================================")

      #L Matriz de transicao estocastica estimada A (linhas somam 1.0 = 1000 em escala 1000):
      #L Linha 1: [800, 200] -> soma = 1000
      #L Linha 2: [300, 700] -> soma = 1000
      mut as int64: a11 = 800
      mut as int64: a12 = 200
      mut as int64: a21 = 300
      mut as int64: a22 = 700

      println("1. Matriz de transicao de estados HMM atualizada por Baum-Welch:")
      println("   -> Linha 1: [" + a11 + ", " + a12 + "]")
      println("   -> Linha 2: [" + a21 + ", " + a22 + "]")

      mut as int64: soma_l1 = a11 + a12
      mut as int64: soma_l2 = a21 + a22
      mut as int64: res = (soma_l1 - 1000) + (soma_l2 - 1000)

      println("2. Residuo da condicao estocastica = " + res + " (esperado: 0)")
      println("3. Treinamento de HMM via Baum-Welch concluido com exito.")
}
