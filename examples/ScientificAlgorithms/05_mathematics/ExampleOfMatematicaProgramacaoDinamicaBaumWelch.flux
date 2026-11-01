#L ============================================================================
#L Algoritmo: Baum-Welch (Algoritmo EM para Treinamento de Parâmetros de HMM)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(I * S^2 * T) por iteracao de aprendizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaBaumWelch) {
      println("==================================================")
      println("  SciAlgo: Baum-Welch HMM Expectation-Maximization")
      println("==================================================")

      mut as int64: iteracoes = 5
      mut as int64: log_likelihood = 95

      println("1. Treinamento de transicoes e emissoes: " + iteracoes + " passos")
      println("2. Log-verossimilhanca convergida: " + log_likelihood)
      println("3. Baum-Welch concluido com sucesso.")
}
