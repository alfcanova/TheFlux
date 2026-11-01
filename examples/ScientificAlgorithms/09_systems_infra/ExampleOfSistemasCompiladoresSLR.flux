#L ============================================================================
#L Algoritmo: SLR(1) Parser (Simple LR com Resolucao via FOLLOW)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresSLR) {
      println("==================================================")
      println("  SciAlgo: SLR(1) Parser (Simple LR with FOLLOW)")
      println("==================================================")

      #L Gramatica SLR(1):
      #L 1: E -> E + T (len 3, LHS E = 10)
      #L 2: E -> T     (len 1, LHS E = 10)
      #L 3: T -> T * F (len 3, LHS T = 11)
      #L 4: T -> F     (len 1, LHS T = 11)
      #L 5: F -> ( E ) (len 3, LHS F = 12)
      #L 6: F -> id    (len 1, LHS F = 12)

      #L Terminais: 1: id, 2: +, 3: *, 4: (, 5: ), 6: $
      #L Nao-Terminais: 10: E, 11: T, 12: F

      #L Sentenca de entrada: "id * id + id $"
      mut as list of int64: inputTokens = [1, 3, 1, 2, 1, 6]
      mut as int64: numTokens = 6
      mut as int64: ip = 1

      #L Pilha de estados SLR(1) (1-indexed)
      mut as list of int64: stateStack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1
      stateStack[1] = 0 #L Estado 0 inicial

      mut as int64: stepCount = 0
      mut as int64: shifts = 0
      mut as int64: reduces = 0
      mut as int64: accepted = 0
      mut as int64: running = 1

      println("1. Executando Automato SLR(1):")

      infinite (stepCount < 40 and running == 1) {
            stepCount = stepCount + 1
            mut as int64: st = stateStack[top]
            mut as int64: tok = inputTokens[ip]

            #L Acao: > 0 shift, < 0 reduce (-regra), 999 accept, 0 erro
            mut as int64: action = 0

            route {
                  st == 0 ==> {
                        route {
                              tok == 1 ==> { action = 5 }
                              tok == 4 ==> { action = 4 }
                              _ ==> {}
                        }
                  }
                  st == 1 ==> {
                        route {
                              tok == 2 ==> { action = 6 }
                              tok == 6 ==> { action = 999 }
                              _ ==> {}
                        }
                  }
                  st == 2 ==> {
                        #L Conflito resolvido: shift em * (3), reduce por r2 em FOLLOW(E) = {+, ), $}
                        route {
                              tok == 3 ==> { action = 7 }
                              tok == 2 or tok == 5 or tok == 6 ==> { action = 0 - 2 }
                              _ ==> {}
                        }
                  }
                  st == 3 ==> {
                        #L T -> F . FOLLOW(T) = {+, *, ), $}
                        route {
                              tok == 2 or tok == 3 or tok == 5 or tok == 6 ==> { action = 0 - 4 }
                              _ ==> {}
                        }
                  }
                  st == 4 ==> {
                        route {
                              tok == 1 ==> { action = 5 }
                              tok == 4 ==> { action = 4 }
                              _ ==> {}
                        }
                  }
                  st == 5 ==> {
                        #L F -> id . FOLLOW(F) = {+, *, ), $}
                        route {
                              tok == 2 or tok == 3 or tok == 5 or tok == 6 ==> { action = 0 - 6 }
                              _ ==> {}
                        }
                  }
                  st == 6 ==> {
                        route {
                              tok == 1 ==> { action = 5 }
                              tok == 4 ==> { action = 4 }
                              _ ==> {}
                        }
                  }
                  st == 7 ==> {
                        route {
                              tok == 1 ==> { action = 5 }
                              tok == 4 ==> { action = 4 }
                              _ ==> {}
                        }
                  }
                  st == 8 ==> {
                        route {
                              tok == 2 ==> { action = 6 }
                              tok == 5 ==> { action = 11 }
                              _ ==> {}
                        }
                  }
                  st == 9 ==> {
                        #L E -> E + T . FOLLOW(E)
                        route {
                              tok == 3 ==> { action = 7 }
                              tok == 2 or tok == 5 or tok == 6 ==> { action = 0 - 1 }
                              _ ==> {}
                        }
                  }
                  st == 10 ==> {
                        #L T -> T * F . FOLLOW(T)
                        route {
                              tok == 2 or tok == 3 or tok == 5 or tok == 6 ==> { action = 0 - 3 }
                              _ ==> {}
                        }
                  }
                  st == 11 ==> {
                        #L F -> ( E ) . FOLLOW(F)
                        route {
                              tok == 2 or tok == 3 or tok == 5 or tok == 6 ==> { action = 0 - 5 }
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
                                    rhsLen = 3
                                    lhsNt = 10
                              }
                              ruleId == 2 ==> {
                                    rhsLen = 1
                                    lhsNt = 10
                              }
                              ruleId == 3 ==> {
                                    rhsLen = 3
                                    lhsNt = 11
                              }
                              ruleId == 4 ==> {
                                    rhsLen = 1
                                    lhsNt = 11
                              }
                              ruleId == 5 ==> {
                                    rhsLen = 3
                                    lhsNt = 12
                              }
                              ruleId == 6 ==> {
                                    rhsLen = 1
                                    lhsNt = 12
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
                                          lhsNt == 12 ==> { nextState = 3 }
                                          _ ==> {}
                                    }
                              }
                              gotoBase == 4 ==> {
                                    route {
                                          lhsNt == 10 ==> { nextState = 8 }
                                          lhsNt == 11 ==> { nextState = 2 }
                                          lhsNt == 12 ==> { nextState = 3 }
                                          _ ==> {}
                                    }
                              }
                              gotoBase == 6 ==> {
                                    route {
                                          lhsNt == 11 ==> { nextState = 9 }
                                          lhsNt == 12 ==> { nextState = 3 }
                                          _ ==> {}
                                    }
                              }
                              gotoBase == 7 ==> {
                                    route {
                                          lhsNt == 12 ==> { nextState = 10 }
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
      println("2. Resultados do Parser SLR(1):")
      println("   Passos executados: " + stepCount)
      println("   Shifts: " + shifts)
      println("   Reducoes: " + reduces)
      println("   Status de aceitacao: " + accepted)

      route {
            accepted == 1 ==> {
                  println("   SUCESSO: Expressao aceita pelo Parser SLR(1)!")
            }
            _ ==> {
                  println("   FALHA: Rejeitada pelo Parser SLR(1).")
            }
      }
}
