#L ============================================================================
#L Algoritmo: D* Lite (Koenig & Likhachev 2002)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(V log V) inicial | O(k log k) atualizacao incremental (LPA*)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchDStarLite) {
      println("==================================================")
      println("  SciAlgo: D* Lite (Koenig & Likhachev 2002)")
      println("==================================================")

      #L Grafo com 4 vertices
      #L 1 -> 2 (peso 1), 2 -> 4 (peso 1) [Caminho 1-2-4, custo 2]
      #L 1 -> 3 (peso 3), 3 -> 4 (peso 1) [Caminho 1-3-4, custo 4]
      mut as list of list of int64: cost = [
            [0, 1, 3, 0],
            [0, 0, 0, 1],
            [0, 0, 0, 1],
            [0, 0, 0, 0]
      ]

      mut as int64: start = 1
      mut as int64: goal = 4

      #L Vetores g(s) e rhs(s) do D* Lite (valores 9999 = infinito)
      mut as list of int64: g_val = [9999, 9999, 9999, 0]
      mut as list of int64: rhs_val = [9999, 9999, 9999, 0]

      #L Inicializacao: no objetivo tem rhs(goal) = 0
      #L Calcula rhs inicial para os predecessores
      #L rhs(2) = cost(2,4) + g(4) = 1 + 0 = 1
      #L rhs(3) = cost(3,4) + g(4) = 1 + 0 = 1
      rhs_val[2] = 1
      g_val[2] = 1
      rhs_val[3] = 1
      g_val[3] = 1

      #L rhs(1) = min(cost(1,2) + g(2), cost(1,3) + g(3)) = min(1+1, 3+1) = 2
      rhs_val[1] = 2
      g_val[1] = 2

      println("1. Estado consistente inicial g(start): " + g_val[start])

      #L Evento de mudanca ambiental: aresta (1, 2) passa de custo 1 para 10 (obstrucao)
      println("2. Evento dinâmico: custo da aresta (1, 2) aumentado de 1 para 10!")
      cost[1][2] = 10

      #L D* Lite detecta inconsistencia local: rhs(1) precisa ser atualizado
      #L novo rhs(1) = min(10 + g(2), 3 + g(3)) = min(10+1, 3+1) = 4
      mut as int64: opt1 = cost[1][2] + g_val[2]
      mut as int64: opt2 = cost[1][3] + g_val[3]
      mut as int64: new_rhs = opt1
      route {
            opt2 < opt1 ==> {
                  new_rhs = opt2
            }
      }
      rhs_val[1] = new_rhs

      #L Processa no inconsistente (g != rhs)
      mut as bool: inconsistent = (g_val[1] != rhs_val[1])
      println("3. No 1 inconsistente localmente detectado: " + inconsistent)

      #L Atualiza no para alcancar consistencia local
      g_val[1] = rhs_val[1]

      println("4. Novo custo de navegacao atualizado: " + g_val[start])
      println("5. Validacao: " + (inconsistent and g_val[start] == 4))
      println("==================================================")
}
