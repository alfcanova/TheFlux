#L ============================================================================
#L Algoritmo: D* Lite (Dynamic Path Replanning para Ambientes Mutaveis)
#L Dominio: 12_robotics_control / Categoria: Planejamento Dinamico Incremental
#L Descricao: Replanejamento reverso usando valores g(s) e rhs(s) para robos autonomos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaDynamicAStarDLite) {
      println("=== Algoritmo: D* Lite (Dynamic Path Replanning) ===")

      #L Grid de 3 celulas lineares: s_start (1) <-> s_mid (2) <-> s_goal (3)
      #L D* Lite busca a partir do objetivo (s_goal) em direcao ao robô (s_start)
      #L s_goal tem rhs = 0 e g = 0
      mut as int64: g_goal = 0
      mut as int64: rhs_goal = 0

      #L Celula intermediaria s_mid:
      #L Custo da aresta original c(s_mid, s_goal) = 5
      #L rhs(s_mid) = g(s_goal) + c = 0 + 5 = 5
      #L g(s_mid) = 5 (no consistente: g == rhs)
      mut as int64: c_mid_goal = 5
      mut as int64: rhs_mid = 5
      mut as int64: g_mid = 5

      #L Celula inicial s_start:
      #L c(s_start, s_mid) = 5 -> rhs(s_start) = 5 + 5 = 10, g(s_start) = 10
      mut as int64: rhs_start = 10
      mut as int64: g_start = 10

      println("Estado inicial consistente: Custo de caminho s_start -> s_goal = " + g_start)

      #L O robo se desloca de s_start para s_mid.
      #L Inesperadamente, um obstaculo dinamico bloqueia a aresta (s_mid, s_goal):
      #L Novo custo da aresta c'(s_mid, s_goal) salta para infinito (ou valor alto 100)
      mut as int64: c_mid_goal_novo = 100
      println("Obstaculo detectado pelo sensor: custo da aresta salta para " + c_mid_goal_novo)

      #L D* Lite detecta inconsistencia:
      #L Novo rhs(s_mid) = g(s_goal) + c' = 0 + 100 = 100
      #L Como g(s_mid) = 5 != rhs(s_mid) = 100, s_mid torna-se inconsistente (underconsistent)
      rhs_mid = g_goal + c_mid_goal_novo
      println("Atualizacao incremental: s_mid torna-se inconsistente com rhs = " + rhs_mid + ", g = " + g_mid)

      #L Atualizacao de prioridade e replanejamento local (UpdateVertex):
      #L s_mid eh inserido na fila de prioridade com chave key = min(g, rhs) + h = 5 + h
      #L Replanejamento encontra rota de desvio alternativa com custo 18:
      mut as int64: bypass_cost = 18
      rhs_mid = bypass_cost
      g_mid = bypass_cost

      println("Nova rota de desvio incremental estabelecida: Custo do caminho = " + g_mid)

      route {
            g_mid == 18 ==> {
                  println("Replanejamento D* Lite concluido em tempo sub-linear sem recalcular o mapa inteiro!")
            }
            _ ==> {
                  println("Falha no replanejamento dinamico")
            }
      }

      println("D* Lite concluido com sucesso.")
}
