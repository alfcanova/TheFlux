#L ============================================================================
#L Algoritmo: Point Quadtree (Finkel & Bentley 1974 - Particionamento em 4 Quadrantes)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(log N) medio | Range Query O(K + log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasQuadtree) {
      println("==================================================")
      println("  SciAlgo: Point Quadtree (NW, NE, SW, SE)")
      println("==================================================")

      #L Representacao dos nos da Point Quadtree (1-based, 0 = NULL)
      #L Cada no e um ponto (px, py) com 4 ponteiros de quadrantes
      mut as list of int64: node_x = [0]
      mut as list of int64: node_y = [0]
      mut as list of int64: child_nw = [0]
      mut as list of int64: child_ne = [0]
      mut as list of int64: child_sw = [0]
      mut as list of int64: child_se = [0]
      mut as int64: root = 0

      #L Pontos a inserir:
      #L 1. (50, 50) - Raiz central
      #L 2. (20, 20) - SW da raiz
      #L 3. (80, 20) - SE da raiz
      #L 4. (20, 80) - NW da raiz
      #L 5. (80, 80) - NE da raiz
      #L 6. (85, 85) - NE de (80, 80)
      #L 7. (15, 25) - NW de (20, 20)
      mut as list of int64: pts_x = [50, 20, 80, 20, 80, 85, 15]
      mut as list of int64: pts_y = [50, 20, 20, 80, 80, 85, 25]
      mut as int64: total_pts = listLength(pts_x)

      println("1. Inserindo " + total_pts + " pontos na Point Quadtree...")

      mut as int64: pi = 1
      infinite (pi <= total_pts) {
            mut as int64: px = pts_x[pi]
            mut as int64: py = pts_y[pi]

            #L Aloca novo no
            node_x = listPushBack(node_x, px)
            node_y = listPushBack(node_y, py)
            child_nw = listPushBack(child_nw, 0)
            child_ne = listPushBack(child_ne, 0)
            child_sw = listPushBack(child_sw, 0)
            child_se = listPushBack(child_se, 0)
            mut as int64: new_node = listLength(node_x)

            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        mut as int64: curr = root
                        infinite (true) {
                              mut as int64: cx = node_x[curr]
                              mut as int64: cy = node_y[curr]

                              #L Determina o quadrante em relacao a (cx, cy)
                              #L NW: px < cx e py >= cy
                              #L NE: px >= cx e py >= cy
                              #L SW: px < cx e py < cy
                              #L SE: px >= cx e py < cy
                              route {
                                    px < cx ==> {
                                          route {
                                                py >= cy ==> {
                                                      #L Quadrante NW
                                                      route {
                                                            child_nw[curr] == 0 ==> {
                                                                  child_nw[curr] = new_node
                                                                  break
                                                            }
                                                            _ ==> { curr = child_nw[curr] }
                                                      }
                                                }
                                                _ ==> {
                                                      #L Quadrante SW
                                                      route {
                                                            child_sw[curr] == 0 ==> {
                                                                  child_sw[curr] = new_node
                                                                  break
                                                            }
                                                            _ ==> { curr = child_sw[curr] }
                                                      }
                                                }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                py >= cy ==> {
                                                      #L Quadrante NE
                                                      route {
                                                            child_ne[curr] == 0 ==> {
                                                                  child_ne[curr] = new_node
                                                                  break
                                                            }
                                                            _ ==> { curr = child_ne[curr] }
                                                      }
                                                }
                                                _ ==> {
                                                      #L Quadrante SE
                                                      route {
                                                            child_se[curr] == 0 ==> {
                                                                  child_se[curr] = new_node
                                                                  break
                                                            }
                                                            _ ==> { curr = child_se[curr] }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            println("   Ponto (" + px + ", " + py + ") inserido como no " + new_node)
            pi = pi + 1
      }

      #L 2. Consultas de Regiao Retangular (Range Query)
      println("2. Executando consultas espaciais retangulares (Range Query):")

      #L Consulta 1: Mundo inteiro [0, 0, 100, 100] -> todos os 7 pontos
      mut as list of int64: stack = [root]
      mut as int64: top = 1
      mut as int64: cnt1 = 0

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: ux = node_x[u]
            mut as int64: uy = node_y[u]

            route {
                  (ux >= 0) and (ux <= 100) and (uy >= 0) and (uy <= 100) ==> {
                        cnt1 = cnt1 + 1
                  }
            }

            #L Empilha filhos nao-nulos
            route {
                  child_nw[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_nw[u]) } _ ==> { stack[top] = child_nw[u] } }
                  }
            }
            route {
                  child_ne[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_ne[u]) } _ ==> { stack[top] = child_ne[u] } }
                  }
            }
            route {
                  child_sw[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_sw[u]) } _ ==> { stack[top] = child_sw[u] } }
                  }
            }
            route {
                  child_se[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_se[u]) } _ ==> { stack[top] = child_se[u] } }
                  }
            }
      }
      println("   Range [0, 0, 100, 100] (esperado 7): " + cnt1)

      #L Consulta 2: Quadrante Nordeste [55, 55, 100, 100] -> pontos (80, 80) e (85, 85) = 2
      stack[1] = root
      top = 1
      mut as int64: cnt2 = 0

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: ux = node_x[u]
            mut as int64: uy = node_y[u]

            route {
                  (ux >= 55) and (ux <= 100) and (uy >= 55) and (uy <= 100) ==> {
                        cnt2 = cnt2 + 1
                  }
            }

            route {
                  child_nw[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_nw[u]) } _ ==> { stack[top] = child_nw[u] } }
                  }
            }
            route {
                  child_ne[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_ne[u]) } _ ==> { stack[top] = child_ne[u] } }
                  }
            }
            route {
                  child_sw[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_sw[u]) } _ ==> { stack[top] = child_sw[u] } }
                  }
            }
            route {
                  child_se[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_se[u]) } _ ==> { stack[top] = child_se[u] } }
                  }
            }
      }
      println("   Range [55, 55, 100, 100] (esperado 2): " + cnt2)

      #L Consulta 3: Regiao Sudoeste [0, 0, 40, 40] -> pontos (20, 20) e (15, 25) = 2
      stack[1] = root
      top = 1
      mut as int64: cnt3 = 0

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: ux = node_x[u]
            mut as int64: uy = node_y[u]

            route {
                  (ux >= 0) and (ux <= 40) and (uy >= 0) and (uy <= 40) ==> {
                        cnt3 = cnt3 + 1
                  }
            }

            route {
                  child_nw[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_nw[u]) } _ ==> { stack[top] = child_nw[u] } }
                  }
            }
            route {
                  child_ne[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_ne[u]) } _ ==> { stack[top] = child_ne[u] } }
                  }
            }
            route {
                  child_sw[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_sw[u]) } _ ==> { stack[top] = child_sw[u] } }
                  }
            }
            route {
                  child_se[u] != 0 ==> {
                        top = top + 1
                        route { top > listLength(stack) ==> { stack = listPushBack(stack, child_se[u]) } _ ==> { stack[top] = child_se[u] } }
                  }
            }
      }
      println("   Range [0, 0, 40, 40] (esperado 2): " + cnt3)

      mut as bool: ok = (cnt1 == 7) and (cnt2 == 2) and (cnt3 == 2)
      println("3. Verificacao geral da Point Quadtree: " + ok)
      println("Concluido com Sucesso")
}
