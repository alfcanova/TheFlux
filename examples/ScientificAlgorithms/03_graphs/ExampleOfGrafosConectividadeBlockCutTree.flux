#L ============================================================================
#L Algoritmo: Block-Cut Tree (Arvore Bloco-Corte / BCT)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeBlockCutTree) {
      println("==================================================")
      println("  SciAlgo: Block-Cut Tree (BCT)                   ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as list of int64: is_cut = [0, 0, 1, 1, 0, 0] #L Vertices de corte: 3 e 4
      mut as int64: num_blocks = 3

      #L Bloco 1: {1, 2, 3}
      #L Bloco 2: {3, 4}
      #L Bloco 3: {4, 5, 6}
      mut as list of int64: b_has = [
            1, 1, 1, 0, 0, 0,
            0, 0, 1, 1, 0, 0,
            0, 0, 0, 1, 1, 1
      ]

      println("1. Vertices de Corte Identificados: 3, 4")
      println("2. Blocos Biconexos (B-nodes): 3")

      println("3. Arestas da Arvore Bloco-Corte (BCT):")
      mut as int64: b = 1
      infinite (b <= num_blocks) {
            mut as int64: c = 1
            infinite (c <= num_v) {
                  route {
                        is_cut[c] == 1 ==> {
                              mut as int64: has_v = b_has[(b - 1) * num_v + c]
                              route {
                                    has_v == 1 ==> {
                                          println("   BCT Aresta: Bloco " + b + " <-> VerticeDeCorte " + c)
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  c = c + 1
            }
            b = b + 1
      }
}
