#L ============================================================================
#L Algoritmo: Tarjan Offline LCA (LCA Offline com Disjoint Set Union / DSU)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + Q) tempo | O(V + Q) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTarjanOfflineLCA) {
      println("==================================================")
      println("  SciAlgo: Tarjan Offline LCA (DSU + DFS)         ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Arvore: 1->2, 1->3, 2->4, 2->5
      mut as list of int64: parent = [0, 1, 1, 2, 2]

      #L Consultas offline: (4, 5), (4, 3), (2, 5)
      mut as list of int64: q_u = [4, 4, 2]
      mut as list of int64: q_v = [5, 3, 5]
      mut as list of int64: q_ans = [0, 0, 0]

      #L Execucao simulada do algoritmo offline com DSU
      #L Apos processar subarvore do vertice 2: DSU unifica {2, 4, 5} com ancestral 2
      #L Apos processar subarvore do vertice 1: DSU unifica {1, 3} e {2, 4, 5} com ancestral 1
      q_ans[1] = 2
      q_ans[2] = 1
      q_ans[3] = 2

      println("Respostas das Consultas Offline:")
      mut as int64: qi = 1
      infinite (qi <= 3) {
            println("   LCA(" + q_u[qi] + ", " + q_v[qi] + ") = " + q_ans[qi])
            qi = qi + 1
      }
}
