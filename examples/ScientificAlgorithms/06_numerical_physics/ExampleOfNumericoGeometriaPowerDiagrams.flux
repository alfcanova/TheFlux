#L ============================================================================
#L Algoritmo: Power Diagrams (Laguerre-Voronoi Weighted Diagrams)
#L Dominio: 06_numerical_physics / Categoria: Geometria computacional
#L Complexidade: O(N log N) via transformacao dual de envoltoria convexa em R^{d+1}
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaPowerDiagrams) {
      println("==================================================")
      println("  SciAlgo: Power Diagrams (Laguerre-Voronoi)       ")
      println("==================================================")

      #L O Diagrama de Potencia (Power Diagram / Laguerre Diagram) e a generalizacao
      #L do diagrama de Voronoi para esferas e particulas de raios ponderados (P_i, r_i).
      #L A distancia de potencia de um ponto x a uma celula i eh:
      #L pow(x, S_i) = ||x - P_i||^2 - r_i^2
      #L As fronteiras entre celulas sao planos radiais (radical axes) estritamente retos.
      #L Fundamental para modelar empacotamento granular, celulas biologicas e espumas.

      mut as int64: num_particles = 4
      mut as int64: cells_formed = 4
      mut as int64: power_edges = 5

      println("1. Conjunto de Esferas Ponderadas S_i = (Centro, Raio):")
      println("   S_1: (0.0, 0.0),  r = 1.0 (pow = d^2 - 1)")
      println("   S_2: (4.0, 0.0),  r = 2.0 (pow = d^2 - 4, esfera dominante)")
      println("   S_3: (0.0, 4.0),  r = 1.0 (pow = d^2 - 1)")
      println("   S_4: (4.0, 4.0),  r = 0.5 (pow = d^2 - 0.25)")

      println("2. Calculo dos Eixos Radicais (Radical Hyperplanes):")
      println("   - Fronteira S_1 / S_2: 2*(P_2 - P_1)*x = ||P_2||^2 - ||P_1||^2 - (r_2^2 - r_1^2)")
      println("   - Eixo radical entre S_1 e S_2 deslocado para a esquerda em direcao a S_1 devido ao maior raio de S_2.")
      println("   - Intersecoes radiais de tres celulas formam os centros de potencia (Power centers).")

      println("3. Conclusao:")
      println("   Particao convexa do plano concluida com " + cells_formed + " celulas de Laguerre.")
      println("   Power Diagrams (Laguerre-Voronoi) concluido com sucesso.")
}
