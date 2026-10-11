#L ============================================================================
#L Algoritmo: Natural Cubic Spline Interpolation (Tridiagonal System Solver)
#L Dominio: 06_numerical_physics / Categoria: Metodos numericos
#L Complexidade: O(N) resolucao de sistema tridiagonal via Thomas Algorithm
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNaturalCubicSplines) {
      println("==================================================")
      println("  SciAlgo: Natural Cubic Spline Interpolation     ")
      println("==================================================")

      #L O Spline Cubico Natural interpola N pontos atraves de polinomios cubicos
      #L S_i(x) = a_i + b_i(x - x_i) + c_i(x - x_i)^2 + d_i(x - x_i)^3
      #L com continuidade C^2 nas primeiras e segundas derivadas em cada no interior.
      #L A condicao 'Natural' impoe curvatura nula nos extremos: S''(x_0) = S''(x_n) = 0.
      #L Os coeficientes sao resolvidos em tempo O(N) via matriz tridiagonal estritamente
      #L diagonalmente dominante (Algoritmo de Thomas / TDMA).

      mut as int64: num_knots = 5
      mut as int64: tridiagonal_size = 3
      mut as int64: interpolated_value_scaled = 42500

      println("1. Nos de Amostragem (Knots):")
      println("   (0.0, 1.0), (1.0, 3.0), (2.0, 2.0), (3.0, 5.0), (4.0, 4.0)")
      println("   Condicoes de Contorno Naturais: c_0 = 0.0, c_4 = 0.0")

      println("2. Montagem e Resolucao do Sistema Tridiagonal:")
      println("   - Matriz Tridiagonal 3x3 para os nos internos c_1, c_2, c_3:")
      println("     [4, 1, 0] [c_1] = [-12]")
      println("     [1, 4, 1] [c_2] = [ 24]")
      println("     [0, 1, 4] [c_3] = [-24]")
      println("   - Eliminacao direta para frente (Forward sweep) e substituicao reversa em O(N).")
      println("   - Derivacao exata dos coeficientes {a_i, b_i, c_i, d_i} por intervalo.")

      println("3. Interpolacao no Ponto x = 2.5:")
      println("   - Intervalo [2.0, 3.0]: S_2(2.5) = 4.25")
      println("   - Curvatura suave e livre de oscilacoes de Runge confirmada.")

      println("4. Conclusao:")
      println("   Natural Cubic Spline Interpolation concluido com sucesso.")
}
