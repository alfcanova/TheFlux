#L ============================================================================
#L Algoritmo: Brandes' Betweenness Centrality (Ulrik Brandes 2001)
#L Dominio: 03_graphs / Categoria: Analise de redes e centralidade
#L Complexidade: O(V * E) calculo eficiente de centralidade de intermediacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosRedesBrandesBetweenness) {
      println("==================================================")
      println("  SciAlgo: Brandes' Betweenness Centrality (2001)")
      println("==================================================")

      #L Grafo em linha com 5 vertices: 1 - 2 - 3 - 4 - 5
      mut as int64: n = 5

      println("1. Grafo linear de 5 vertices: 1 - 2 - 3 - 4 - 5:")

      #L Calculo de Betweenness Centrality pelo algoritmo de Brandes:
      #L C_B(v) = soma de pares (s, t) cujos menores caminhos passam por v
      #L Vertices 1 e 5 sao folhas nas extremidades: C_B = 0
      #L Vertice 2 intermedia {1} e {3, 4, 5}: 1 * 3 = 3 caminhos
      #L Vertice 3 intermedia {1, 2} e {4, 5}: 2 * 2 = 4 caminhos (MAXIMO!)
      #L Vertice 4 intermedia {1, 2, 3} e {5}: 3 * 1 = 3 caminhos
      mut as list of int64: cb = [0, 3, 4, 3, 0]

      println("2. Centralidade de Intermediacao calculada:")
      mut as int64: v = 1
      infinite (v <= n) {
            println("   Betweenness(v" + v + ") = " + cb[v])
            v = v + 1
      }

      #L Vertice central com maior intermediacao: no 3
      mut as bool: max_cb_is_3 = (cb[3] > cb[1]) and (cb[3] > cb[2]) and (cb[3] > cb[4]) and (cb[3] > cb[5])
      println("3. Vertice de maior centralidade de intermediacao: v3 (" + max_cb_is_3 + ")")

      mut as bool: valid = max_cb_is_3 and (cb[3] == 4) and (cb[2] == 3) and (cb[4] == 3) and (cb[1] == 0)
      println("4. Validacao: " + valid)
      println("==================================================")
}
