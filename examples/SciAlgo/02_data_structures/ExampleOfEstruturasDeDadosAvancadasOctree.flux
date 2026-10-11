#L ============================================================================
#L Algoritmo: Octree (Particionamento Espacial 3D em 8 Octantes)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(log N) medio | Range Query 3D O(K + log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasOctree) {
      println("==================================================")
      println("  SciAlgo: Point Octree 3D (8 Octants Partitioning)")
      println("==================================================")

      #L Representacao dos nos da Octree (1-based, 0 = NULL)
      mut as list of int64: pt_x = [0]
      mut as list of int64: pt_y = [0]
      mut as list of int64: pt_z = [0]

      #L 8 filhos para cada octante (1..8)
      #L c1: (---), c2: (+--), c3: (-+-), c4: (++-)
      #L c5: (--+), c6: (+-+), c7: (-++), c8: (+++)
      mut as list of int64: c1 = [0]
      mut as list of int64: c2 = [0]
      mut as list of int64: c3 = [0]
      mut as list of int64: c4 = [0]
      mut as list of int64: c5 = [0]
      mut as list of int64: c6 = [0]
      mut as list of int64: c7 = [0]
      mut as list of int64: c8 = [0]
      mut as int64: root = 0

      #L Conjunto de 10 pontos 3D a inserir:
      mut as list of int64: in_x = [50, 20, 80, 20, 80, 20, 80, 20, 80, 85]
      mut as list of int64: in_y = [50, 20, 20, 80, 80, 20, 20, 80, 80, 85]
      mut as list of int64: in_z = [50, 20, 20, 20, 20, 80, 80, 80, 80, 85]
      mut as int64: total_pts = listLength(in_x)

      println("1. Inserindo " + total_pts + " pontos tridimensionais na Octree...")

      mut as int64: pi = 1
      infinite (pi <= total_pts) {
            mut as int64: px = in_x[pi]
            mut as int64: py = in_y[pi]
            mut as int64: pz = in_z[pi]

            #L Aloca novo no
            pt_x = listPushBack(pt_x, px)
            pt_y = listPushBack(pt_y, py)
            pt_z = listPushBack(pt_z, pz)
            c1 = listPushBack(c1, 0)
            c2 = listPushBack(c2, 0)
            c3 = listPushBack(c3, 0)
            c4 = listPushBack(c4, 0)
            c5 = listPushBack(c5, 0)
            c6 = listPushBack(c6, 0)
            c7 = listPushBack(c7, 0)
            c8 = listPushBack(c8, 0)
            mut as int64: new_node = listLength(pt_x)

            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        mut as int64: curr = root
                        infinite (true) {
                              mut as int64: cx = pt_x[curr]
                              mut as int64: cy = pt_y[curr]
                              mut as int64: cz = pt_z[curr]

                              #L Determina o octante 1..8
                              mut as int64: bit_x = 0
                              route { px >= cx ==> { bit_x = 1 } }
                              mut as int64: bit_y = 0
                              route { py >= cy ==> { bit_y = 2 } }
                              mut as int64: bit_z = 0
                              route { pz >= cz ==> { bit_z = 4 } }
                              mut as int64: oct = bit_x + bit_y + bit_z + 1

                              #L Vincula ao filho correspondente
                              route {
                                    oct == 1 ==> {
                                          route { c1[curr] == 0 ==> { c1[curr] = new_node break } _ ==> { curr = c1[curr] } }
                                    }
                                    oct == 2 ==> {
                                          route { c2[curr] == 0 ==> { c2[curr] = new_node break } _ ==> { curr = c2[curr] } }
                                    }
                                    oct == 3 ==> {
                                          route { c3[curr] == 0 ==> { c3[curr] = new_node break } _ ==> { curr = c3[curr] } }
                                    }
                                    oct == 4 ==> {
                                          route { c4[curr] == 0 ==> { c4[curr] = new_node break } _ ==> { curr = c4[curr] } }
                                    }
                                    oct == 5 ==> {
                                          route { c5[curr] == 0 ==> { c5[curr] = new_node break } _ ==> { curr = c5[curr] } }
                                    }
                                    oct == 6 ==> {
                                          route { c6[curr] == 0 ==> { c6[curr] = new_node break } _ ==> { curr = c6[curr] } }
                                    }
                                    oct == 7 ==> {
                                          route { c7[curr] == 0 ==> { c7[curr] = new_node break } _ ==> { curr = c7[curr] } }
                                    }
                                    _ ==> {
                                          route { c8[curr] == 0 ==> { c8[curr] = new_node break } _ ==> { curr = c8[curr] } }
                                    }
                              }
                        }
                  }
            }

            println("   Ponto (" + px + ", " + py + ", " + pz + ") inserido como no " + new_node)
            pi = pi + 1
      }

      #L 2. Consultas Espaciais 3D em Caixa Delimitadora (Bounding Box Range Query)
      println("2. Executando consultas espaciais 3D na Octree:")

      #L Consulta 1: Espaco completo [0, 0, 0] ate [100, 100, 100] -> todos os 10 pontos
      mut as list of int64: stack = [root]
      mut as int64: top = 1
      mut as int64: cnt1 = 0

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: ux = pt_x[u]
            mut as int64: uy = pt_y[u]
            mut as int64: uz = pt_z[u]

            route {
                  (ux >= 0) and (ux <= 100) and (uy >= 0) and (uy <= 100) and (uz >= 0) and (uz <= 100) ==> {
                        cnt1 = cnt1 + 1
                  }
            }

            #L Empilha filhos nao nulos
            route { c1[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c1[u]) } _ ==> { stack[top] = c1[u] } } } }
            route { c2[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c2[u]) } _ ==> { stack[top] = c2[u] } } } }
            route { c3[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c3[u]) } _ ==> { stack[top] = c3[u] } } } }
            route { c4[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c4[u]) } _ ==> { stack[top] = c4[u] } } } }
            route { c5[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c5[u]) } _ ==> { stack[top] = c5[u] } } } }
            route { c6[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c6[u]) } _ ==> { stack[top] = c6[u] } } } }
            route { c7[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c7[u]) } _ ==> { stack[top] = c7[u] } } } }
            route { c8[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c8[u]) } _ ==> { stack[top] = c8[u] } } } }
      }
      println("   Query 1: Box global [0..100, 0..100, 0..100] (esperado 10): " + cnt1)

      #L Consulta 2: Hemisferio superior Z [0..100, 0..100, 50..100] -> 6 pontos
      stack[1] = root
      top = 1
      mut as int64: cnt2 = 0

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: ux = pt_x[u]
            mut as int64: uy = pt_y[u]
            mut as int64: uz = pt_z[u]

            route {
                  (ux >= 0) and (ux <= 100) and (uy >= 0) and (uy <= 100) and (uz >= 50) and (uz <= 100) ==> {
                        cnt2 = cnt2 + 1
                  }
            }

            route { c1[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c1[u]) } _ ==> { stack[top] = c1[u] } } } }
            route { c2[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c2[u]) } _ ==> { stack[top] = c2[u] } } } }
            route { c3[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c3[u]) } _ ==> { stack[top] = c3[u] } } } }
            route { c4[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c4[u]) } _ ==> { stack[top] = c4[u] } } } }
            route { c5[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c5[u]) } _ ==> { stack[top] = c5[u] } } } }
            route { c6[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c6[u]) } _ ==> { stack[top] = c6[u] } } } }
            route { c7[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c7[u]) } _ ==> { stack[top] = c7[u] } } } }
            route { c8[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c8[u]) } _ ==> { stack[top] = c8[u] } } } }
      }
      println("   Query 2: Hemisferio Z superior [0..100, 0..100, 50..100] (esperado 6): " + cnt2)

      #L Consulta 3: Canto superior apertado [75..100, 75..100, 75..100] -> pontos (80, 80, 80) e (85, 85, 85) = 2
      stack[1] = root
      top = 1
      mut as int64: cnt3 = 0

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: ux = pt_x[u]
            mut as int64: uy = pt_y[u]
            mut as int64: uz = pt_z[u]

            route {
                  (ux >= 75) and (ux <= 100) and (uy >= 75) and (uy <= 100) and (uz >= 75) and (uz <= 100) ==> {
                        cnt3 = cnt3 + 1
                  }
            }

            route { c1[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c1[u]) } _ ==> { stack[top] = c1[u] } } } }
            route { c2[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c2[u]) } _ ==> { stack[top] = c2[u] } } } }
            route { c3[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c3[u]) } _ ==> { stack[top] = c3[u] } } } }
            route { c4[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c4[u]) } _ ==> { stack[top] = c4[u] } } } }
            route { c5[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c5[u]) } _ ==> { stack[top] = c5[u] } } } }
            route { c6[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c6[u]) } _ ==> { stack[top] = c6[u] } } } }
            route { c7[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c7[u]) } _ ==> { stack[top] = c7[u] } } } }
            route { c8[u] != 0 ==> { top = top + 1 route { top > listLength(stack) ==> { stack = listPushBack(stack, c8[u]) } _ ==> { stack[top] = c8[u] } } } }
      }
      println("   Query 3: Canto superior [75..100, 75..100, 75..100] (esperado 2): " + cnt3)

      mut as bool: ok = (cnt1 == 10) and (cnt2 == 6) and (cnt3 == 2)
      println("3. Verificacao geral da Octree 3D: " + ok)
      println("Concluido com Sucesso")
}
