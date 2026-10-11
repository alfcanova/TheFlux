#L ============================================================================
#L Algoritmo: LINE (Large-scale Information Network Embedding)
#L Dominio: 08_artificial_intel / Subdominio: Grafos para IA
#L Descricao: Preservacao de proximidade de 1a e 2a ordem em grafos de larga escala
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (dotProduct3D) (as list of int64: v1, as list of int64: v2) as int64 {
      mut as int64: sum = (v1[1] * v2[1]) + (v1[2] * v2[2]) + (v1[3] * v2[3])
      emit(nice, sum, "ok")
}

program (ExampleOfIAGrafosLINE) {
      println("=== Algoritmo: LINE (Graph Network Embedding) ===")

      #L Grafo com 4 vertices e arestas ponderadas
      #L Embeddings de dimensao 3 para os vertices
      mut as list of int64: emb1 = [10, 5, 2]
      mut as list of int64: emb2 = [9, 6, 1]
      mut as list of int64: emb3 = [1, 2, 8]
      mut as list of int64: emb4 = [2, 1, 9]

      #L Proximidade de 1a ordem: similaridade entre vizinhos diretos (1-2) e (3-4)
      mut as int64: sim12 = dotProduct3D(emb1, emb2)
      mut as int64: sim34 = dotProduct3D(emb3, emb4)
      mut as int64: sim13 = dotProduct3D(emb1, emb3)

      println("1. Proximidade de 1a ordem (V1, V2): " + sim12)
      println("2. Proximidade de 1a ordem (V3, V4): " + sim34)
      println("3. Proximidade cruzada (V1, V3): " + sim13)

      #L Validacao da preservacao de comunidade
      route {
            sim12 > sim13 and sim34 > sim13 ==> {
                  println("4. Preservacao de proximidade LINE verificada com sucesso.")
            }
            _ ==> {
                  println("Falha na preservacao estrutural.")
            }
      }
      println("Teste concluido com sucesso.")
}
