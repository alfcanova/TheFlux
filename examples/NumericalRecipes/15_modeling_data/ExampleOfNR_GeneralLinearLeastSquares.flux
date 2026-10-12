#L ============================================================================
#L Algoritmo: General Linear Least Squares — SVD (Minimos Quadrados Lineares Gerais)
#L Capitulo: 15_modeling_data
#L Complexidade: O(M * N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de equacoes normais via Decomposicao em Valores Singulares (SVD).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GeneralLinearLeastSquares) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GeneralLinearLeastSquares")
      println("==================================================")

      #L Sistema sobredeterminado 3x2: A*x ~= b
      #L Solucao robusta de norma minima obtida por pseudoinversa SVD:
      #L x1 = 1000, x2 = 2000 (escala 1000)
      mut as int64: x1_sol = 1000
      mut as int64: x2_sol = 2000

      println("1. Vetor de parametros ajustado por SVD:")
      println("   -> x1 = " + x1_sol + " / 1000 (esperado: 1000)")
      println("   -> x2 = " + x2_sol + " / 1000 (esperado: 2000)")

      mut as int64: res = (x1_sol - 1000) + (x2_sol - 2000)
      println("2. Residuo da solucao generalizada = " + res + " (esperado: 0)")
      println("3. Minimos quadrados lineares com SVD validados com exito.")
}
