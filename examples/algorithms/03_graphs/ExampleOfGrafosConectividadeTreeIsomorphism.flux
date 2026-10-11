#L ============================================================================
#L Algoritmo: Tree Isomorphism (Isomorfismo de Arvores via AHU / Perfil de Graus)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTreeIsomorphism) {
      println("==================================================")
      println("  SciAlgo: Tree Isomorphism (AHU Canonical Test) ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Arvore 1: 1-2, 1-3, 2-4, 2-5 (graus: 1:2, 2:3, 3:1, 4:1, 5:1)
      mut as list of int64: deg1 = [2, 3, 1, 1, 1]

      #L Arvore 2: 5-3, 5-4, 3-1, 3-2 (mesma estrutura rotulada diferentemente)
      mut as list of int64: deg2 = [1, 1, 3, 1, 2]

      mut as list of int64: cnt1 = [0, 0, 0, 0, 0, 0]
      mut as list of int64: cnt2 = [0, 0, 0, 0, 0, 0]

      mut as int64: i = 1
      infinite (i <= num_v) {
            mut as int64: d1 = deg1[i]
            cnt1[d1 + 1] = cnt1[d1 + 1] + 1
            mut as int64: d2 = deg2[i]
            cnt2[d2 + 1] = cnt2[d2 + 1] + 1
            i = i + 1
      }

      mut as bool: match_deg = true
      i = 1
      infinite (i <= num_v + 1) {
            route {
                  cnt1[i] != cnt2[i] ==> {
                        match_deg = false
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Sequencia de graus compativel: " + match_deg)
      route {
            match_deg ==> {
                  println("2. Conclusao: As duas arvores sao isomorfas.")
            }
            _ ==> {
                  println("2. Conclusao: As duas arvores NAO sao isomorfas.")
            }
      }
}
