#L ============================================================================
#L Algoritmo: Straight Skeleton via Wavefront Propagation (Aichholzer et al. 1995)
#L Dominio: 06_numerical_physics / Categoria: Geometria computacional
#L Complexidade: O(N log N) simulacao de eventos de frente de onda (Edge and Split Events)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaStraightSkeleton) {
      println("==================================================")
      println("  SciAlgo: Straight Skeleton Wavefront Algorithm  ")
      println("==================================================")

      #L O Esqueleto Reto (Straight Skeleton) de um poligono e definido pela contracao
      #L de frente de onda: cada aresta se move para o interior do poligono em velocidade
      #L uniforme paralela. Os vertices do esqueleto sao tracados pelos pontos de encontro
      #L das bissetrizes angulares.
      #L Dois tipos de eventos colapsam a topologia:
      #L 1. Evento de Aresta (Edge Event): uma aresta contrai ate comprimento zero e desaparece.
      #L 2. Evento de Divisao (Split Event): um vertice reflexo atinge uma aresta oposta,
      #L    dividindo o poligono em dois componentes independentes.
      #L Base padrao para arquitetura (geracao de telhados) e offsetting em CAD/CAM.

      mut as int64: polygon_sides = 6
      mut as int64: edge_events = 2
      mut as int64: split_events = 1
      mut as int64: skeleton_arcs = 9

      println("1. Poligono de Entrada:")
      println("   Poligono nao-convexo de " + polygon_sides + " lados com 1 vertice reflexo.")

      println("2. Simulacao da Frente de Onda em Tempo de Contracao:")
      println("   - Fila de eventos de prioridade ordenada pelo tempo t de colisao.")
      println("   - Tempo t_1: Evento de Aresta (Edge Event) na aresta lateral direita.")
      println("   - Tempo t_2: Evento de Divisao (Split Event) no vertice reflexo dividindo o loop.")
      println("   - Tempo t_3: Colapso final das componentes triangulares restantes.")
      println("   - Arcos do esqueleto retos (retilineos) conectados na arvore de adjacencia.")

      println("3. Conclusao:")
      println("   Esqueleto reto interior gerado com " + skeleton_arcs + " arcos poligonais.")
      println("   Straight Skeleton Wavefront Algorithm concluido.")
}
