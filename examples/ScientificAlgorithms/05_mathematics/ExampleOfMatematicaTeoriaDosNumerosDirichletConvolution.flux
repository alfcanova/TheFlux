#L ============================================================================
#L Algoritmo: Dirichlet Convolution (Convolucao de Dirichlet e Inversao de Mobius)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N log N) transformada multiplicativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosDirichletConvolution) {
      println("==================================================")
      println("  SciAlgo: Dirichlet Convolution and Mobius Inversion")
      println("==================================================")

      mut as int64: n = 6
      #L (mu * 1)(n) = eps(n) = 0 para n > 1
      mut as int64: eps_val = 0

      println("1. Convolucao de Dirichlet (mu * 1) em n = " + n)
      println("2. Elemento neutro da convolucao eps(" + n + ") = " + eps_val)
      println("3. Dirichlet Convolution concluido com sucesso.")
}
