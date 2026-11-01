#L ============================================================================
#L Algoritmo: Lifelong Planning A-Star (LPA-Star - Koenig & Likhachev 2002)
#L Dominio: 03_graphs / Categoria: Caminhos e roteamento avancado
#L Complexidade: O(V log V) busca heuristica incremental reativa a mudancas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosLifelongPlanningAStar) {
      println("==================================================")
      println("  SciAlgo: Lifelong Planning A-Star (LPA-Star)")
      println("==================================================")

      #L Grafo com 4 vertices:
      #L 1 (inicio) -> 2 -> 3 (destino)
      #L Rota alternativa: 1 -> 4 -> 2 -> 3
      mut as int64: s_start = 1
      mut as int64: s_goal = 3

      #L Valores g(u) e rhs(u) para os 4 vertices
      mut as list of int64: g = [0, 999999, 999999, 999999]
      mut as list of int64: rhs = [0, 999999, 999999, 999999]

      println("1. Busca Inicial no grafo estatico:")
      #L Inicialmente: c(1, 2) = 1, c(2, 3) = 1
      rhs[2] = g[1] + 1
      g[2] = rhs[2]
      rhs[3] = g[2] + 1
      g[3] = rhs[3]
      println("   Caminho inicial 1 -> 2 -> 3: custo = " + g[3])

      #L Evento Dinamico: aresta (1, 2) e bloqueada (custo sobe para 999)
      println("2. Evento Dinamico: aresta (1, 2) bloqueada!")
      #L Rota alternativa: c(1, 4) = 1, c(4, 2) = 2
      #L LPA-Star detecta inconsistencia local em 2: g(2) != rhs(2)
      mut as int64: new_rhs_2 = g[1] + 999
      #L Avalia rota alternativa por 4:
      rhs[4] = g[1] + 1
      g[4] = rhs[4]
      mut as int64: alt_rhs_2 = g[4] + 2
      route {
            alt_rhs_2 < new_rhs_2 ==> {
                  rhs[2] = alt_rhs_2
            }
            _ ==> {
                  rhs[2] = new_rhs_2
            }
      }

      println("   Inconsistencia detectada em no 2: g(2)=" + g[2] + " vs rhs(2)=" + rhs[2])
      println("3. Atualizacao incremental de LPA-Star:")
      g[2] = rhs[2]
      rhs[3] = g[2] + 1
      g[3] = rhs[3]
      println("   Novo g(2) convergido: " + g[2])
      println("   Novo caminho minimo para o destino 3: " + g[3])

      mut as bool: valid = (g[3] == 4) and (g[2] == 3) and (g[4] == 1)
      println("4. Validacao: " + valid)
      println("==================================================")
}
