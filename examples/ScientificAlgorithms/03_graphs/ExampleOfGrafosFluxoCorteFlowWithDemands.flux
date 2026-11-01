#L ============================================================================
#L Algoritmo: Flow with Demands (Circulacao com Demandas e Limites Inferiores)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V * E^2) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteFlowWithDemands) {
      println("==================================================")
      println("  SciAlgo: Flow with Demands (Circulacao Viavel) ")
      println("==================================================")

      #L Grafo original com 4 vertices e 5 arestas com limites [lower, upper]
      #L Arestas:
      #L (1->2): [2, 5]
      #L (2->3): [1, 4]
      #L (3->4): [1, 3]
      #L (4->1): [2, 4]
      #L (2->4): [0, 2]
      mut as int64: num_orig = 4

      #L Criamos rede auxiliar com Super-Fonte (5) e Super-Sumidouro (6)
      mut as int64: total_v = 6
      mut as int64: super_src = 5
      mut as int64: super_sink = 6

      #L Matriz residual de capacidades 6x6
      mut as list of int64: capacity = [
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0
      ]

      #L Vetor de demandas liquidas balanco D(v) = sum(lower_out) - sum(lower_in)
      #L No 1: out (1->2: 2), in (4->1: 2) -> balanco 0
      #L No 2: out (2->3: 1, 2->4: 0), in (1->2: 2) -> balanco 1 - 2 = -1 (deficit 1 -> vai para T)
      #L No 3: out (3->4: 1), in (2->3: 1) -> balanco 0
      #L No 4: out (4->1: 2), in (3->4: 1, 2->4: 0) -> balanco 2 - 1 = +1 (excesso 1 -> vem de S)

      #L Adiciona capacidades residuais c - l:
      #L 1->2: 5 - 2 = 3
      capacity[(1 - 1) * total_v + 2] = 3
      #L 2->3: 4 - 1 = 3
      capacity[(2 - 1) * total_v + 3] = 3
      #L 3->4: 3 - 1 = 2
      capacity[(3 - 1) * total_v + 4] = 2
      #L 4->1: 4 - 2 = 2
      capacity[(4 - 1) * total_v + 1] = 2
      #L 2->4: 2 - 0 = 2
      capacity[(2 - 1) * total_v + 4] = 2

      #L Arestas da super-fonte e para super-sumidouro
      #L Super-fonte (5) -> No 4 com cap 1
      capacity[(super_src - 1) * total_v + 4] = 1
      #L No 2 -> Super-sumidouro (6) com cap 1
      capacity[(2 - 1) * total_v + super_sink] = 1

      mut as int64: required_flow = 1

      println("1. Rede com limites inferiores transformada em rede de fluxo standard:")
      println("   Vertices originais: 4 | Super-fonte: 5, Super-sumidouro: 6")
      println("   Fluxo necessario para saturar super-fonte: " + required_flow)

      #L Calcula fluxo maximo de super_src (5) para super_sink (6) via Edmonds-Karp
      mut as int64: max_flow = 0
      mut as bool: has_path = true

      infinite (has_path) {
            mut as list of int64: parent = [0, 0, 0, 0, 0, 0]
            mut as list of bool: visited = [false, false, false, false, false, false]
            mut as list of int64: queue = [0, 0, 0, 0, 0, 0]
            mut as int64: q_head = 1
            mut as int64: q_tail = 1

            queue[q_tail] = super_src
            q_tail = q_tail + 1
            visited[super_src] = true

            infinite (q_head < q_tail and not visited[super_sink]) {
                  mut as int64: curr = queue[q_head]
                  q_head = q_head + 1

                  mut as int64: nxt = 1
                  infinite (nxt <= total_v) {
                        mut as int64: c_idx = (curr - 1) * total_v + nxt
                        route {
                              (not visited[nxt]) and (capacity[c_idx] > 0) ==> {
                                    visited[nxt] = true
                                    parent[nxt] = curr
                                    queue[q_tail] = nxt
                                    q_tail = q_tail + 1
                              }
                              _ ==> {}
                        }
                        nxt = nxt + 1
                  }
            }

            route {
                  not visited[super_sink] ==> {
                        has_path = false
                  }
                  _ ==> {
                        #L Encontra gargalo
                        mut as int64: bottleneck = 999999
                        mut as int64: curr = super_sink
                        infinite (curr != super_src) {
                              mut as int64: p = parent[curr]
                              mut as int64: c_res = capacity[(p - 1) * total_v + curr]
                              route {
                                    c_res < bottleneck ==> {
                                          bottleneck = c_res
                                    }
                                    _ ==> {}
                              }
                              curr = p
                        }

                        #L Atualiza residual
                        curr = super_sink
                        infinite (curr != super_src) {
                              mut as int64: p = parent[curr]
                              mut as int64: fwd = (p - 1) * total_v + curr
                              mut as int64: rev = (curr - 1) * total_v + p
                              capacity[fwd] = capacity[fwd] - bottleneck
                              capacity[rev] = capacity[rev] + bottleneck
                              curr = p
                        }

                        max_flow = max_flow + bottleneck
                  }
            }
      }

      println("2. Fluxo maximo na rede auxiliar: " + max_flow)
      route {
            max_flow == required_flow ==> {
                  println("3. Circulacao viavel encontrada com sucesso!")
                  #L Fluxo real = lower + fluxo adicional
                  #L Na aresta 1->2: lower=2, adicional = 3 - capacity[1->2]
                  mut as int64: f_12 = 2 + (3 - capacity[(1 - 1) * total_v + 2])
                  mut as int64: f_23 = 1 + (3 - capacity[(2 - 1) * total_v + 3])
                  mut as int64: f_34 = 1 + (2 - capacity[(3 - 1) * total_v + 4])
                  mut as int64: f_41 = 2 + (2 - capacity[(4 - 1) * total_v + 1])
                  mut as int64: f_24 = 0 + (2 - capacity[(2 - 1) * total_v + 4])
                  println("   Fluxos finais nas arestas:")
                  println("   f(1->2) = " + f_12 + ", f(2->3) = " + f_23 + ", f(3->4) = " + f_34 + ", f(4->1) = " + f_41 + ", f(2->4) = " + f_24)
            }
            _ ==> {
                  println("3. Nao existe circulacao viavel que satisfaca as demandas.")
            }
      }

      println("Flow with Demands concluido com sucesso.")
}
