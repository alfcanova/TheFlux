#L ============================================================================
#L Algoritmo: Canonical LR(1) Parser (Itens LR Completos e 10 Estados)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresCanonicalLR) {
      println("==================================================")
      println("  SciAlgo: Canonical LR(1) Parser (Full LR(1) Items)")
      println("==================================================")

      #L Gramatica Canonical LR(1):
      #L 1: S -> C C  (len 2, LHS S = 10)
      #L 2: C -> c C  (len 2, LHS C = 11)
      #L 3: C -> d    (len 1, LHS C = 11)

      #L Terminais: 1: c, 2: d, 3: $
      #L Nao-Terminais: 10: S, 11: C

      #L Sentenca de entrada: "c d d $"
      mut as list of int64: inputTokens = [1, 2, 2, 3]
      mut as int64: numTokens = 4
      mut as int64: ip = 1

      #L Pilha de estados canônicos (1 a 10 estados)
      mut as list of int64: stateStack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1
      stateStack[1] = 0 #L Estado 0 inicial

      mut as int64: stepCount = 0
      mut as int64: shifts = 0
      mut as int64: reduces = 0
      mut as int64: accepted = 0
      mut as int64: running = 1

      println("1. Executando Maquina Canonical LR(1):")

      infinite (stepCount < 30 and running == 1) {
            stepCount = stepCount + 1
            mut as int64: st = stateStack[top]
            mut as int64: tok = inputTokens[ip]

            mut as int64: action = 0

            route {
                  st == 0 ==> {
                        route {
                              tok == 1 ==> { action = 3 }
                              tok == 2 ==> { action = 4 }
                              _ ==> {}
                        }
                  }
                  st == 1 ==> {
                        route {
                              tok == 3 ==> { action = 999 }
                              _ ==> {}
                        }
                  }
                  st == 2 ==> {
                        route {
                              tok == 1 ==> { action = 6 }
                              tok == 2 ==> { action = 7 }
                              _ ==> {}
                        }
                  }
                  st == 3 ==> {
                        route {
                              tok == 1 ==> { action = 3 }
                              tok == 2 ==> { action = 4 }
                              _ ==> {}
                        }
                  }
                  st == 4 ==> {
                        #L C -> d . com lookahead c ou d
                        route {
                              tok == 1 or tok == 2 ==> { action = 0 - 3 }
                              _ ==> {}
                        }
                  }
                  st == 5 ==> {
                        #L S -> C C . com lookahead $
                        route {
                              tok == 3 ==> { action = 0 - 1 }
                              _ ==> {}
                        }
                  }
                  st == 6 ==> {
                        route {
                              tok == 1 ==> { action = 6 }
                              tok == 2 ==> { action = 7 }
                              _ ==> {}
                        }
                  }
                  st == 7 ==> {
                        #L C -> d . com lookahead $
                        route {
                              tok == 3 ==> { action = 0 - 3 }
                              _ ==> {}
                        }
                  }
                  st == 8 ==> {
                        #L C -> c C . com lookahead c ou d
                        route {
                              tok == 1 or tok == 2 ==> { action = 0 - 2 }
                              _ ==> {}
                        }
                  }
                  st == 9 ==> {
                        #L C -> c C . com lookahead $
                        route {
                              tok == 3 ==> { action = 0 - 2 }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            route {
                  action == 999 ==> {
                        accepted = 1
                        running = 0
                  }
                  action > 0 ==> {
                        shifts = shifts + 1
                        top = top + 1
                        stateStack[top] = action
                        ip = ip + 1
                  }
                  action < 0 ==> {
                        reduces = reduces + 1
                        mut as int64: ruleId = 0 - action
                        mut as int64: rhsLen = 0
                        mut as int64: lhsNt = 0

                        route {
                              ruleId == 1 ==> {
                                    rhsLen = 2
                                    lhsNt = 10
                              }
                              ruleId == 2 ==> {
                                    rhsLen = 2
                                    lhsNt = 11
                              }
                              ruleId == 3 ==> {
                                    rhsLen = 1
                                    lhsNt = 11
                              }
                              _ ==> {}
                        }

                        top = top - rhsLen
                        mut as int64: gotoBase = stateStack[top]
                        mut as int64: nextState = 0

                        route {
                              gotoBase == 0 ==> {
                                    route {
                                          lhsNt == 10 ==> { nextState = 1 }
                                          lhsNt == 11 ==> { nextState = 2 }
                                          _ ==> {}
                                    }
                              }
                              gotoBase == 2 ==> {
                                    route {
                                          lhsNt == 11 ==> { nextState = 5 }
                                          _ ==> {}
                                    }
                              }
                              gotoBase == 3 ==> {
                                    route {
                                          lhsNt == 11 ==> { nextState = 8 }
                                          _ ==> {}
                                    }
                              }
                              gotoBase == 6 ==> {
                                    route {
                                          lhsNt == 11 ==> { nextState = 9 }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        top = top + 1
                        stateStack[top] = nextState
                  }
                  _ ==> {
                        running = 0
                  }
            }
      }

      println("==================================================")
      println("2. Resultados do Parser Canonical LR(1):")
      println("   Passos executados: " + stepCount)
      println("   Shifts: " + shifts)
      println("   Reducoes: " + reduces)
      println("   Status de aceitacao: " + accepted)

      route {
            accepted == 1 ==> {
                  println("   SUCESSO: Sentenca aceita pelo Canonical LR(1)!")
            }
            _ ==> {
                  println("   FALHA: Rejeitada pelo Canonical LR(1).")
            }
      }
}
