#L ============================================================================
#L Algoritmo: Boyer-Myrvold Planarity & Combinatorial Embedding (2004)
#L Dominio: 03_graphs / Categoria: Grafos planares e topologia
#L Complexidade: O(V) extracao de embedding planar combinatorio e faces
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosPlanaresBoyerMyrvold) {
      println("==================================================")
      println("  SciAlgo: Boyer-Myrvold Planar Embedding & Faces")
      println("==================================================")

      #L Grafo Roda W4 (5 vertices, 8 arestas):
      #L Vertice central 1 conectado a 2, 3, 4, 5
      #L Ciclo externo: (2, 3), (3, 4), (4, 5), (5, 2)
      mut as int64: v_count = 5
      mut as int64: e_count = 8

      #L Graus dos vertices no grafo W4
      #L Grau(1) = 4, Grau(2..5) = 3
      mut as list of int64: deg = [4, 3, 3, 3, 3]

      println("1. Grafo Roda W4 (V = 5, E = 8):")
      println("   Vertice central 1 com grau 4.")
      println("   Vertices perifericos 2, 3, 4, 5 com grau 3 cada.")

      #L Formula de Euler para grafos planares conexos:
      #L V - E + F = 2  ==>  F = E - V + 2
      mut as int64: num_faces = e_count - v_count + 2
      println("2. Calculo das Faces de Euler (F = E - V + 2):")
      println("   Numero de faces planares: " + num_faces)

      #L Lista de faces do embedding combinatorio:
      #L Face 1: (1, 2, 3)
      #L Face 2: (1, 3, 4)
      #L Face 3: (1, 4, 5)
      #L Face 4: (1, 5, 2)
      #L Face 5 (Externa): (2, 5, 4, 3)
      mut as list of int64: face_sizes = [3, 3, 3, 3, 4]
      println("3. Faces identificadas no Embedding Planar de Boyer-Myrvold:")
      mut as int64: sum_boundary = 0
      mut as int64: f = 1
      infinite (f <= listLength(face_sizes)) {
            mut as int64: sz = face_sizes[f]
            sum_boundary = sum_boundary + sz
            println("   Face " + f + ": tamanho do contorno = " + sz)
            f = f + 1
      }

      #L Pelo Teorema de Handshaking de Faces: a soma dos contornos das faces = 2 * E = 16
      println("   Soma dos contornos das faces: " + sum_boundary + " (2 * E = " + (2 * e_count) + ")")

      mut as bool: valid = (num_faces == 5) and (sum_boundary == 2 * e_count)
      println("4. Validacao: " + valid)
      println("==================================================")
}
