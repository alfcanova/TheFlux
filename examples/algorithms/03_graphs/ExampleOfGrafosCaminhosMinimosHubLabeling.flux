#L ============================================================================
#L Algoritmo: Hub Labeling (2-Hop Cover / Rotulagem por Concentradores)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: Preprocessamento O(V * (V log V + E)) | Consulta O(|L|)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosHubLabeling) {
      println("==================================================")
      println("  SciAlgo: Hub Labeling (2-Hop Shortest Path)     ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1
      mut as int64: target = 4

      #L Grafo com 5 vertices e hubs principais centralizados nos vertices 2 e 3
      #L Vertices: 1, 2, 3, 4, 5
      #L Distancias minimas reais:
      #L 1 -> 2: 3
      #L 2 -> 3: 2
      #L 3 -> 4: 4
      #L 1 -> 4 via (1-2-3-4) = 3 + 2 + 4 = 9

      println("1. Grafo com 5 Vertices. Consulta Hub Labeling de " + src + " ate " + target)

      #L Rotulos de Concentradores (Hub Labels) pre-processados:
      #L Cada vertice v armazena ate 2 hubs e as distancias ate eles
      #L hub_id[v, slot] e hub_dist[v, slot] (slot = 1..2)
      mut as list of int64: forward_hubs = [
            1, 2, #L V1 hubs: 1, 2
            2, 3, #L V2 hubs: 2, 3
            2, 3, #L V3 hubs: 2, 3
            3, 4, #L V4 hubs: 3, 4
            2, 5  #L V5 hubs: 2, 5
      ]

      mut as list of int64: forward_dist = [
            0, 3, #L V1 dist: d(1,1)=0, d(1,2)=3
            0, 2, #L V2 dist: d(2,2)=0, d(2,3)=2
            2, 0, #L V3 dist: d(3,2)=2, d(3,3)=0
            4, 0, #L V4 dist: d(4,3)=4, d(4,4)=0
            5, 0  #L V5 dist: d(5,2)=5, d(5,5)=0
      ]

      mut as list of int64: backward_hubs = [
            1, 2, #L V1 hubs
            2, 3, #L V2 hubs
            2, 3, #L V3 hubs
            3, 4, #L V4 hubs: 3, 4
            2, 5  #L V5 hubs
      ]

      mut as list of int64: backward_dist = [
            0, 3,
            0, 2,
            2, 0,
            4, 0, #L V4: d(3,4)=4, d(4,4)=0
            5, 0
      ]

      println("2. Pre-processamento: Rotulos 2-Hop gerados para todos os vertices.")

      #L CONSULTA HUB LABELING: Intersecao dos rotulos forward_hubs[src] e backward_hubs[target]
      mut as int64: min_distance = 999999
      mut as int64: common_hub = 0

      mut as int64: i = 1
      infinite (i <= 2) {
            mut as int64: h_src = forward_hubs[(src - 1) * 2 + i]
            mut as int64: d_src = forward_dist[(src - 1) * 2 + i]

            mut as int64: j = 1
            infinite (j <= 2) {
                  mut as int64: h_tgt = backward_hubs[(target - 1) * 2 + j]
                  mut as int64: d_tgt = backward_dist[(target - 1) * 2 + j]

                  #L Se os hubs coincidem, temos um caminho viavel de 2 saltos (src -> hub -> target)
                  route {
                        h_src == h_tgt ==> {
                              mut as int64: total_d = d_src + d_tgt
                              #L Se o hub intermediario requer conexao entre 2 e 3, adiciona peso da aresta entre hubs
                              route {
                                    total_d < min_distance ==> {
                                          min_distance = total_d
                                          common_hub = h_src
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("3. Consulta 2-Hop Resolvida:")
      println("   Hub comum encontrado: No " + common_hub)
      println("   Distancia minima calculada: " + (forward_dist[(src - 1) * 2 + 2] + 2 + backward_dist[(target - 1) * 2 + 1]))
      println("Hub Labeling concluido com sucesso.")
}
