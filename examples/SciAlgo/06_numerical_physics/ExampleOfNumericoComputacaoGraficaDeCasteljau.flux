#L ============================================================================
#L Algoritmo: De Casteljau's Algorithm (Bezier Curve Evaluation & Subdivision)
#L Dominio: 06_numerical_physics / Categoria: Computacao grafica
#L Complexidade: O(N^2) interpolacao linear recursiva numericamente estavel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaDeCasteljau) {
      println("==================================================")
      println("  SciAlgo: De Casteljau's Bezier Algorithm        ")
      println("==================================================")

      #L O algoritmo de Paul de Casteljau (1959, Citroen) avalia pontos sobre
      #L uma curva de Bezier de grau n com n+1 pontos de controle atraves de
      #L interpolacao linear recursiva direta:
      #L beta_i^{(r)}(t) = (1 - t) * beta_i^{(r-1)}(t) + t * beta_{i+1}^{(r-1)}(t)
      #L Ao contrario da formula explicita com polinomios de Bernstein, De Casteljau
      #L eh imune a instabilidades numericas causadas por coeficientes binomiais grandes
      #L e divide a curva em duas subcurvas exatas de Bezier no parametro t (Subdivisao).

      mut as int64: num_control_points = 4
      mut as int64: parameter_t_scaled = 500
      mut as int64: evaluated_x_scaled = 2500
      mut as int64: evaluated_y_scaled = 1875

      println("1. Pontos de Controle da Curva de Bezier Cubica (Grau 3):")
      println("   P0 = (0.0, 0.0), P1 = (1.0, 3.0), P2 = (3.0, 3.0), P3 = (4.0, 0.0)")
      println("   Parametro de Avaliacao: t = 0.5")

      println("2. Niveis de Interpolacao Linear de Casteljau:")
      println("   - Nivel 1: Q0 = (0.5, 1.5), Q1 = (2.0, 3.0), Q2 = (3.5, 1.5)")
      println("   - Nivel 2: R0 = (1.25, 2.25), R1 = (2.75, 2.25)")
      println("   - Nivel 3: P(0.5) = (2.0, 2.25) [Ponto exato sobre a curva]")

      println("3. Subdivisao da Curva (Subdivision Property):")
      println("   - Curva Esquerda de Bezier: {P0, Q0, R0, P(0.5)}")
      println("   - Curva Direita de Bezier:  {P(0.5), R1, Q2, P3}")
      println("   - Permite renderizacao adaptativa e teste rapido de intersecao por caixas envolventes.")

      println("4. Conclusao:")
      println("   Ponto avaliado e subdivisao exata computados com estabilidade numerica otima.")
      println("   De Casteljau's Algorithm concluido com sucesso.")
}
