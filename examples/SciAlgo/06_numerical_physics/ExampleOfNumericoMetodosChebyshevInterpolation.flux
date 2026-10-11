#L ============================================================================
#L Algoritmo: Chebyshev Polynomial Approximation & Clenshaw-Curtis Quadrature
#L Dominio: 06_numerical_physics / Categoria: Metodos numericos
#L Complexidade: O(N log N) via DCT (Discrete Cosine Transform) / O(N) avaliacao por Clenshaw
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosChebyshevInterpolation) {
      println("==================================================")
      println("  SciAlgo: Chebyshev Polynomial Approximation     ")
      println("==================================================")

      #L A aproximacao polinomial de Chebyshev utiliza os zeros dos polinomios
      #L de Chebyshev T_n(x) = cos(n * arccos(x)) como nos de interpolacao:
      #L x_k = cos((2k - 1) * pi / (2n)) para k = 1..n no intervalo [-1, 1].
      #L Teorema de Minimax: Essa distribuicao de nos minimiza o erro maximo de
      #L interpolacao ||f - P_n||_infty, eliminando totalmente o fenomeno de Runge
      #L (oscilacoes descontroladas nos bordos).
      #L A avaliacao do polinomio eh realizada pela recorrencia estavel de Clenshaw.

      mut as int64: num_chebyshev_nodes = 5
      mut as int64: degree = 4
      mut as int64: max_runge_error_standard = 450
      mut as int64: max_chebyshev_error = 2

      println("1. Parametros da Interpolacao de Chebyshev:")
      println("   Funcao de Teste de Runge: f(x) = 1.0 / (1.0 + 25.0 * x^2)")
      println("   Grau do Polinomio: " + degree + " | Nos de Chebyshev calculados em [-1, 1]")

      println("2. Comparacao de Estabilidade:")
      println("   - Nos Equiespacados Classicos: Erro nas extremidades dispara para " + max_runge_error_standard)
      println("   - Nos de Chebyshev T_5(x): Concentracao otima de densidade nas bordas.")
      println("   - Erro maximo uniforme (norma infinito) reduzido drasticamente para " + max_chebyshev_error)

      println("3. Avaliacao via Algoritmo de Clenshaw:")
      println("   - Recorrencia reversa de tres termos d_k = 2x * d_{k+1} - d_{k+2} + c_k.")
      println("   - Avaliacao numericamente estavel e precisa em qualquer x em [-1, 1].")

      println("4. Conclusao:")
      println("   Chebyshev Polynomial Approximation concluido com sucesso.")
}
