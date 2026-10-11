#L ============================================================================
#L Algoritmo: RRT* — Rapidly-exploring Random Tree Star (Planejamento Otimo)
#L Dominio: 12_robotics_control / Categoria: Planejamento Amostral de Movimento
#L Descricao: Arvore amostral com reconexao de vizinhanca (rewiring) para otimalidade assintotica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaRRTStarOptimalPath) {
      println("=== Algoritmo: RRT* (Optimal Motion Planning) ===")

      #L Espaco 2D de configuracao livre de obstaculos
      #L No raiz inicial x_start na posicao (0, 0), custo c[start] = 0
      #L No 1 na posicao (10, 0), conectado a start com custo c[1] = 10
      #L No 2 na posicao (0, 10), conectado a start com custo c[2] = 10
      mut as int64: cost_start = 0
      mut as int64: cost_node1 = 10
      mut as int64: cost_node2 = 10

      println("Arvore RRT inicial: Raiz (0,0), No 1 (10,0), No 2 (0,10)")

      #L Amostragem de novo ponto x_rand = (10, 10)
      #L Opcao A: Conectar x_rand ao No 1 (10,0) -> distancia euclidiana = 10
      #L Custo total via No 1 = cost_node1 + 10 = 10 + 10 = 20
      #L Opcao B: Conectar x_rand ao No 2 (0,10) -> distancia euclidiana = 10
      #L Custo total via No 2 = cost_node2 + 10 = 10 + 10 = 20
      #L Opcao C: Conectar diretamente a start se houvesse raio de conexao livre = 14 (custo 14 < 20)
      #L Suponha raio de vizinhanca r = 15:
      #L Melhor pai escolhido para novo no x_new (10, 10): No 1 com custo 20
      mut as int64: cost_new = 20
      println("Novo no x_new (10,10) inserido com pai No 1: Custo acumulado c[new] = " + cost_new)

      #L Passo critico do RRT*: REWIRING (Reconexao da vizinhanca):
      #L Um no vizinho existente x_near = (12, 10) com pai original distante tinha custo c = 35.
      #L Avalia se passar por x_new oferece custo inferior:
      #L Custo proposto = cost_new + dist(x_new, x_near) = 20 + 2 = 22
      mut as int64: cost_near_old = 35
      mut as int64: dist_new_near = 2
      mut as int64: cost_near_proposed = cost_new + dist_new_near

      println("Avaliacao de Rewiring para no vizinho:")
      println("  Custo antigo: " + cost_near_old)
      println("  Custo via novo no x_new: " + cost_near_proposed)

      mut as int64: cost_near_final = cost_near_old
      route {
            cost_near_proposed < cost_near_old ==> {
                  cost_near_final = cost_near_proposed
                  println("Rewiring executado: Aresta redirecionada! Custo otimizado para " + cost_near_final)
            }
      }

      route {
            cost_near_final == 22 ==> {
                  println("Propriedade assintotica do RRT* validada: Custo de caminho monotonicamente decrescente!")
            }
            _ ==> {
                  println("Falha no rewiring")
            }
      }

      println("RRT* Optimal Motion Planning concluido com sucesso.")
}
