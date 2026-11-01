#L ============================================================================
#L Algoritmo: PRM* — Probabilistic Roadmap Star (Otimizacao Multi-Consulta)
#L Dominio: 12_robotics_control / Categoria: Planejamento Amostral de Movimento
#L Descricao: Grafo de visibilidade com raio de conexao dependente de log(n)/n
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaProbabilisticRoadmapStar) {
      println("=== Algoritmo: PRM* (Probabilistic Roadmap Star) ===")

      #L Numero de amostras geradas no espaco de configuracao n = 100
      #L Dimensao do espaco d = 2
      #L Formula do raio assintotico PRM*: r_n = gamma * (log(n) / n)^(1/d)
      #L Para n = 100, raio normalizado r_n = 25 (unidades de distancia)
      mut as int64: n_samples = 100
      mut as int64: r_connect = 25

      println("Configuracao PRM*: n = " + n_samples + " amostras, raio de conexao r_n = " + r_connect)

      #L Amostra candidata q_rand na posicao (50, 50)
      #L Vizinhos potenciais no espaco:
      #L No A na posicao (40, 50): distancia = 10 <= 25 -> Conexao valida (Aresta criada)
      #L No B na posicao (50, 70): distancia = 20 <= 25 -> Conexao valida (Aresta criada)
      #L No C na posicao (50, 85): distancia = 35 > 25  -> Fora do raio assintotico (Sem aresta)
      mut as int64: dist_a = 10
      mut as int64: dist_b = 20
      mut as int64: dist_c = 35

      mut as int64: edges_formed = 0
      route {
            dist_a <= r_connect ==> { edges_formed = edges_formed + 1 }
      }
      route {
            dist_b <= r_connect ==> { edges_formed = edges_formed + 1 }
      }
      route {
            dist_c <= r_connect ==> { edges_formed = edges_formed + 1 }
      }

      println("Conexoes avaliadas para q_rand:")
      println("  No A (dist=" + dist_a + "): Conectado")
      println("  No B (dist=" + dist_b + "): Conectado")
      println("  No C (dist=" + dist_c + "): Rejeitado (fora do raio)")
      println("Arestas bidirecionais adicionadas ao Roadmap: " + edges_formed)

      #L Busca de caminho no roadmap construido (Dijkstra ou A*):
      #L Caminho start -> No A -> q_rand -> No B -> goal
      mut as int64: path_cost = 15 + dist_a + dist_b + 12
      println("Custo do caminho de menor extensao encontrado: " + path_cost)

      route {
            edges_formed == 2 and path_cost == 57 ==> {
                  println("Grafo PRM* com conectividade otima construído com sucesso!")
            }
            _ ==> {
                  println("Falha na topologia do PRM*")
            }
      }

      println("PRM* Probabilistic Roadmap Star concluido com sucesso.")
}
