#L ============================================================================
#L Algoritmo: Lowest Common Ancestor (Menor Ancestral Comum via Alinhamento de Profundidade)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) por consulta | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeLowestCommonAncestor) {
      println("==================================================")
      println("  SciAlgo: Lowest Common Ancestor (Depth Align)   ")
      println("==================================================")

      mut as int64: num_v = 7
      mut as list of int64: parent = [0, 1, 1, 2, 2, 3, 3]
      mut as list of int64: depth = [0, 1, 1, 2, 2, 2, 2]

      mut as list of int64: q_u = [4, 4, 6, 2]
      mut as list of int64: q_v = [5, 6, 7, 5]
      mut as int64: num_q = 4

      println("Consultas de LCA:")
      mut as int64: qi = 1
      infinite (qi <= num_q) {
            mut as int64: u = q_u[qi]
            mut as int64: v = q_v[qi]

            #L Alinha a profundidade do no mais profundo
            infinite (depth[u] > depth[v]) {
                  u = parent[u]
            }
            infinite (depth[v] > depth[u]) {
                  v = parent[v]
            }

            #L Sobe ambos simultaneamente ate convergirem
            infinite (u != v) {
                  u = parent[u]
                  v = parent[v]
            }

            println("   LCA(" + q_u[qi] + ", " + q_v[qi] + ") = " + u)
            qi = qi + 1
      }
}
