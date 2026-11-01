#L ============================================================================
#L Algoritmo: Rerooting (Programacao Dinamica em Arvore com Mudanca de Raiz)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeRerooting) {
      println("==================================================")
      println("  SciAlgo: Rerooting DP (All-Roots Distance Sum)  ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Arvore caminho: 1-2-3-4-5
      #L Passo 1: Enraizada no vertice 1
      #L Subarvores: sz = [5, 4, 3, 2, 1]
      mut as list of int64: sz = [5, 4, 3, 2, 1]
      mut as list of int64: parent = [0, 1, 2, 3, 4]

      #L Soma de distancias para a raiz 1:
      #L d(1,1)=0, d(1,2)=1, d(1,3)=2, d(1,4)=3, d(1,5)=4 -> soma = 10
      mut as list of int64: ans = [10, 0, 0, 0, 0]

      #L Passo 2: Propagacao de rerooting O(N)
      #L ans[v] = ans[u] - sz[v] + (num_v - sz[v])
      mut as int64: v = 2
      infinite (v <= num_v) {
            mut as int64: u = parent[v]
            mut as int64: sub_sz = sz[v]
            ans[v] = ans[u] - sub_sz + (num_v - sub_sz)
            v = v + 1
      }

      println("Soma das distancias a partir de cada vertice para todos os outros:")
      mut as int64: node = 1
      infinite (node <= num_v) {
            println("   Vertice " + node + ": soma das distancias = " + ans[node])
            node = node + 1
      }
}
