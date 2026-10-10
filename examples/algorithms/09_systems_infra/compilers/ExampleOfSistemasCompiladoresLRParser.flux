#L ============================================================================
#L Algoritmo: LR(0) Parser (Parser Ascendente com Pilha de Estados)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresLRParser) {
      println("==================================================")
      println("  SciAlgo: LR(0) Shift-Reduce Parser")
      println("==================================================")

      #L Gramatica LR(0):
      #L 1: E -> E + T (tamanho 3, LHS = E)
      #L 2: E -> T     (tamanho 1, LHS = E)
      #L 3: T -> id    (tamanho 1, LHS = T)

      #L Terminais: 1: id, 2: +, 3: $
      #L Nao-Terminais: 10: E, 11: T

      #L Sentenca de entrada: "id + id $"
      mut as list of int64: inputTokens = [1, 2, 1, 3]
      mut as int64: numTokens = 4
      mut as int64: ip = 1

      #L Pilha de estados (1-indexed)
      mut as list of int64: stateStack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1
      stateStack[1] = 0 #L Estado inicial 0

      mut as int64: stepCount = 0
      mut as int64: shifts = 0
      mut as int64: reduces = 0
      mut as int64: accepted = 0
      mut as int64: running = 1

      println("1. Executando Maquina LR(0):")

      infinite (stepCount < 30 and running == 1) {
            stepCount = stepCount + 1
            mut as int64: currentState = stateStack[top]
            mut as int64: currTok = inputTokens[ip]

            #L Acao: > 0 Shift, < 0 Reduce (-regra), 999 Accept, 0 Erro
            mut as int64: action = 0

            route {
                  currentState == 0 ==> {
                        route {
                              currTok == 1 ==> { action = 3 } #L Shift 3 em id
                              _ ==> {}
                        }
                  }
                  currentState == 1 ==> {
                        route {
                              currTok == 2 ==> { action = 4 }   #L Shift 4 em +
                              currTok == 3 ==> { action = 999 } #L Accept em $
                              _ ==> {}
                        }
                  }
                  currentState == 2 ==> {
                        #L Reduce por regra 2 (E -> T)
                        action = 0 - 2
                  }
                  currentState == 3 ==> {
                        #L Reduce por regra 3 (T -> id)
                        action = 0 - 3
                  }
                  currentState == 4 ==> {
                        route {
                              currTok == 1 ==> { action = 3 } #L Shift 3 em id
                              _ ==> {}
                        }
                  }
                  currentState == 5 ==> {
                        #L Reduce por regra 1 (E -> E + T)
                        action = 0 - 1
                  }
                  _ ==> {}
            }

            route {
                  action == 999 ==> {
                        accepted = 1
                        running = 0
                  }
                  action > 0 ==> {
                        #L Shift
                        shifts = shifts + 1
                        top = top + 1
                        stateStack[top] = action
                        ip = ip + 1
                  }
                  action < 0 ==> {
                        #L Reduce
                        reduces = reduces + 1
                        mut as int64: ruleId = 0 - action
                        mut as int64: rhsLen = 0
                        mut as int64: lhsNt = 0

                        route {
                              ruleId == 1 ==> {
                                    rhsLen = 3
                                    lhsNt = 10 #L E
                              }
                              ruleId == 2 ==> {
                                    rhsLen = 1
                                    lhsNt = 10 #L E
                              }
                              ruleId == 3 ==> {
                                    rhsLen = 1
                                    lhsNt = 11 #L T
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
                              gotoBase == 4 ==> {
                                    route {
                                          lhsNt == 11 ==> { nextState = 5 }
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
      println("2. Resultados do Parser LR(0):")
      println("   Passos executados: " + stepCount)
      println("   Shifts: " + shifts)
      println("   Reduces: " + reduces)
      println("   Status de aceitacao: " + accepted)

      route {
            accepted == 1 ==> {
                  println("   SUCESSO: Entrada aceita pelo Parser LR(0)!")
            }
            _ ==> {
                  println("   FALHA: Rejeitada pelo Parser LR(0).")
            }
      }
}
