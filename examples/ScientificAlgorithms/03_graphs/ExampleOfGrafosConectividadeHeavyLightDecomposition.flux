#L ============================================================================
#L Algoritmo: Heavy-Light Decomposition (Decomposicao em Cadeias Pesadas e Leves)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) decomposicao | O(log^2 V) por consulta de caminho
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeHeavyLightDecomposition) {
      println("==================================================")
      println("  SciAlgo: Heavy-Light Decomposition (HLD)        ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as list of int64: parent = [0, 1, 1, 2, 2, 4]
      mut as list of int64: depth = [0, 1, 1, 2, 2, 3]
      mut as list of int64: sz = [6, 4, 1, 2, 1, 1]
      mut as list of int64: heavy = [2, 4, 0, 6, 0, 0]
      mut as list of int64: chain_head = [1, 1, 3, 1, 5, 1]

      println("1. Estrutura de Cadeias HLD:")
      mut as int64: node = 1
      infinite (node <= num_v) {
            println("   No " + node + ": tamanho=" + sz[node] + ", filhoPesado=" + heavy[node] + ", cabecaCadeia=" + chain_head[node])
            node = node + 1
      }

      println("2. Decomposicao de Caminho e Salto de Cadeias para (5, 6):")
      mut as int64: u = 5
      mut as int64: v = 6

      infinite (chain_head[u] != chain_head[v]) {
            route {
                  depth[chain_head[u]] < depth[chain_head[v]] ==> {
                        mut as int64: tmp = u
                        u = v
                        v = tmp
                  }
                  _ ==> {}
            }

            println("   Salto de cadeia a partir do no " + u + " ate o topo " + chain_head[u])
            u = parent[chain_head[u]]
      }

      route {
            depth[u] > depth[v] ==> {
                  mut as int64: tmp = u
                  u = v
                  v = tmp
            }
            _ ==> {}
      }

      println("   Segmento final na cadeia comum entre " + u + " e " + v)
      println("   LCA encontrado via HLD: " + u)
}
