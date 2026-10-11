#L ============================================================================
#L Algoritmo: LL(1) Parser (Tabela de Parsing Dirigida por Pilha)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresLLParser) {
      println("==================================================")
      println("  SciAlgo: LL(1) Table-Driven Predictive Parser")
      println("==================================================")

      #L Gramatica LL(1) Aritmetica:
      #L 1: E  -> T Ep
      #L 2: Ep -> + T Ep
      #L 3: Ep -> epsilon
      #L 4: T  -> F Tp
      #L 5: Tp -> * F Tp
      #L 6: Tp -> epsilon
      #L 7: F  -> ( E )
      #L 8: F  -> id

      #L Simbolos Nao-Terminais:
      #L 1: E, 2: Ep, 3: T, 4: Tp, 5: F
      #L Simbolos Terminais:
      #L 10: +, 11: *, 12: (, 13: ), 14: id, 15: $, 0: eps

      #L Sentenca de entrada: "id + id * id $"
      mut as list of int64: inputTokens = [14, 10, 14, 11, 14, 15]
      mut as int64: numTokens = 6
      mut as int64: ip = 1

      #L Pilha sintatica (1-indexed, inicia com [$, E])
      mut as list of int64: stack = [15, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 2

      mut as int64: stepCount = 0
      mut as int64: rulesApplied = 0
      mut as int64: accepted = 0
      mut as int64: running = 1

      println("1. Executando Parser Preditivo LL(1):")

      infinite (stepCount < 40 and running == 1) {
            stepCount = stepCount + 1
            mut as int64: stackTop = stack[top]
            mut as int64: currTok = inputTokens[ip]

            route {
                  stackTop == 15 and currTok == 15 ==> {
                        accepted = 1
                        running = 0
                  }
                  stackTop == currTok ==> {
                        #L Match de terminal
                        top = top - 1
                        ip = ip + 1
                  }
                  stackTop >= 10 ==> {
                        #L Erro de sintaxe: mismatch terminal
                        running = 0
                  }
                  _ ==> {
                        #L Topo e Nao-Terminal: consulta tabela M[stackTop, currTok]
                        mut as int64: ruleId = 0

                        route {
                              stackTop == 1 ==> {
                                    route {
                                          currTok == 14 or currTok == 12 ==> { ruleId = 1 }
                                          _ ==> {}
                                    }
                              }
                              stackTop == 2 ==> {
                                    route {
                                          currTok == 10 ==> { ruleId = 2 }
                                          currTok == 13 or currTok == 15 ==> { ruleId = 3 }
                                          _ ==> {}
                                    }
                              }
                              stackTop == 3 ==> {
                                    route {
                                          currTok == 14 or currTok == 12 ==> { ruleId = 4 }
                                          _ ==> {}
                                    }
                              }
                              stackTop == 4 ==> {
                                    route {
                                          currTok == 11 ==> { ruleId = 5 }
                                          currTok == 10 or currTok == 13 or currTok == 15 ==> { ruleId = 6 }
                                          _ ==> {}
                                    }
                              }
                              stackTop == 5 ==> {
                                    route {
                                          currTok == 14 ==> { ruleId = 8 }
                                          currTok == 12 ==> { ruleId = 7 }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        route {
                              ruleId == 0 ==> {
                                    running = 0
                              }
                              _ ==> {
                                    rulesApplied = rulesApplied + 1
                                    top = top - 1

                                    #L Empilha producao em ordem reversa
                                    route {
                                          ruleId == 1 ==> {
                                                #L E -> T Ep
                                                top = top + 1
                                                stack[top] = 2 #L Ep
                                                top = top + 1
                                                stack[top] = 3 #L T
                                          }
                                          ruleId == 2 ==> {
                                                #L Ep -> + T Ep
                                                top = top + 1
                                                stack[top] = 2 #L Ep
                                                top = top + 1
                                                stack[top] = 3 #L T
                                                top = top + 1
                                                stack[top] = 10 #L +
                                          }
                                          ruleId == 3 ==> {
                                                #L Ep -> epsilon
                                          }
                                          ruleId == 4 ==> {
                                                #L T -> F Tp
                                                top = top + 1
                                                stack[top] = 4 #L Tp
                                                top = top + 1
                                                stack[top] = 5 #L F
                                          }
                                          ruleId == 5 ==> {
                                                #L Tp -> * F Tp
                                                top = top + 1
                                                stack[top] = 4 #L Tp
                                                top = top + 1
                                                stack[top] = 5 #L F
                                                top = top + 1
                                                stack[top] = 11 #L *
                                          }
                                          ruleId == 6 ==> {
                                                #L Tp -> epsilon
                                          }
                                          ruleId == 7 ==> {
                                                #L F -> ( E )
                                                top = top + 1
                                                stack[top] = 13 #L )
                                                top = top + 1
                                                stack[top] = 1 #L E
                                                top = top + 1
                                                stack[top] = 12 #L (
                                          }
                                          ruleId == 8 ==> {
                                                #L F -> id
                                                top = top + 1
                                                stack[top] = 14 #L id
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                  }
            }
      }

      println("==================================================")
      println("2. Resultados da Analise LL(1):")
      println("   Passos executados: " + stepCount)
      println("   Regras de producao aplicadas: " + rulesApplied)
      println("   Status de aceitacao: " + accepted)

      route {
            accepted == 1 ==> {
                  println("   SUCESSO: Entrada aceita pelo Parser LL(1)!")
            }
            _ ==> {
                  println("   FALHA: Rejeitada pelo Parser LL(1).")
            }
      }
}
