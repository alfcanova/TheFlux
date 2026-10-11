#L ============================================================================
#L Algoritmo: Alocacao de Registradores de Chaitin (Coloracao de Grafo)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresChaitinRegisterAllocation) {
      println("==================================================")
      println("  SciAlgo: Chaitin's Graph Coloring Register Allocation")
      println("==================================================")

      #L Grafo de interferencia entre variaveis virtuais: 1 a 6
      #L K = 3 registradores fisicos disponiveis (R1, R2, R3)
      mut as int64: numVars = 6
      mut as int64: kRegs   = 3

      #L Matriz de adjacencia de interferencia (1-indexed, 6x6 compactada em lista de 36)
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            1, 0, 1, 1, 0, 0,
            1, 1, 0, 1, 0, 0,
            0, 1, 1, 0, 1, 1,
            0, 0, 0, 1, 0, 1,
            0, 0, 0, 1, 1, 0
      ]

      #L Graus atuais dos nos
      mut as list of int64: deg = [2, 3, 3, 4, 2, 2]
      mut as list of int64: removed = [0, 0, 0, 0, 0, 0]

      #L Pilha de simplificacao
      mut as list of int64: simplifyStack = [0, 0, 0, 0, 0, 0]
      mut as int64: stackTop = 0

      println("1. Fase de Simplificacao (Kempe Heuristic, grau < K):")

      mut as int64: step = 1
      infinite (step <= numVars) {
            #L Encontra no com removed == 0 e deg < K
            mut as int64: cand = 0
            mut as int64: v = 1
            infinite (v <= numVars) {
                  route {
                        removed[v] == 0 and deg[v] < kRegs ==> {
                              cand = v
                              break
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }

            route {
                  cand > 0 ==> {
                        #L Empilha e remove cand
                        stackTop = stackTop + 1
                        simplifyStack[stackTop] = cand
                        removed[cand] = 1
                        println("   Simplificando variavel " + cand + " (Grau atual: " + deg[cand] + ")")

                        #L Atualiza grau dos vizinhos
                        mut as int64: u = 1
                        infinite (u <= numVars) {
                              mut as int64: edgeIdx = (cand - 1) * 6 + u
                              route {
                                    adj[edgeIdx] == 1 and removed[u] == 0 ==> {
                                          deg[u] = deg[u] - 1
                                    }
                                    _ ==> {}
                              }
                              u = u + 1
                        }
                  }
                  _ ==> {
                        #L Caso houvesse spill potencial (nao necessario neste grafo)
                        break
                  }
            }

            step = step + 1
      }

      println("==================================================")
      println("2. Fase de Selecao e Atribuicao de Cores:")

      #L Cores atribuidas (1 a K)
      mut as list of int64: assignedColor = [0, 0, 0, 0, 0, 0]

      infinite (stackTop > 0) {
            mut as int64: nodeToColor = simplifyStack[stackTop]
            stackTop = stackTop - 1

            #L Determina menor cor valida (1..K) nao utilizada pelos vizinhos ja coloridos
            mut as list of int64: colorUsed = [0, 0, 0, 0] #L cores 1, 2, 3
            mut as int64: w = 1
            infinite (w <= numVars) {
                  mut as int64: eIdx = (nodeToColor - 1) * 6 + w
                  route {
                        adj[eIdx] == 1 ==> {
                              mut as int64: neighborColor = assignedColor[w]
                              route {
                                    neighborColor > 0 ==> {
                                          colorUsed[neighborColor] = 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  w = w + 1
            }

            #L Escolhe menor cor livre
            mut as int64: chosenColor = 0
            mut as int64: c = 1
            infinite (c <= kRegs) {
                  route {
                        colorUsed[c] == 0 ==> {
                              chosenColor = c
                              break
                        }
                        _ ==> {}
                  }
                  c = c + 1
            }

            assignedColor[nodeToColor] = chosenColor
            println("   Variavel " + nodeToColor + " alocada ao Registrador R" + chosenColor)
      }

      #L Validacao de corretude: nenhum par de vizinhos tem a mesma cor
      mut as int64: validColoring = 1
      mut as int64: p = 1
      infinite (p <= numVars) {
            mut as int64: q = 1
            infinite (q <= numVars) {
                  mut as int64: idx = (p - 1) * 6 + q
                  route {
                        adj[idx] == 1 ==> {
                              route {
                                    assignedColor[p] == assignedColor[q] ==> {
                                          validColoring = 0
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  q = q + 1
            }
            p = p + 1
      }

      route {
            validColoring == 1 ==> {
                  println("   SUCESSO: Grafo colorivel com K=3 registradores sem spills!")
            }
            _ ==> {
                  println("   FALHA: Conflito detectado na alocacao de registradores.")
            }
      }
}
