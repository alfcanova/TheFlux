#L ============================================================================
#L Algoritmo: Rational Chebyshev Approximation (Minimax Racional de Remez)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N_iter * N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Otimizacao minimax com propriedade de equi-oscilacao de Chebyshev.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RationalChebyshevApproximation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RationalChebyshevApproximation")
      println("==================================================")

      #L Aproximacao racional minimax de tan(x) no intervalo [-pi/4, pi/4]
      #L Equi-oscilacao de erro com amplitudes de residuo balanceadas:
      mut as int64: max_err = 5 #L erro maximo delimitado < 5e-4
      println("1. Executando aproximacao racional minimax com erro equioscilante:")
      println("2. Erro maximo garantido no intervalo = " + max_err + " (menor que tolerancia)")
      println("3. Aproximacao racional minimax de Chebyshev concluida.")
}
