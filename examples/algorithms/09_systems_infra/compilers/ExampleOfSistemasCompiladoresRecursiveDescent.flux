#L ============================================================================
#L Algoritmo: Recursive Descent Parser (Gramatica Livre de Contexto LL(1))
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresRecursiveDescent) {
      println("==================================================")
      println("  SciAlgo: Recursive Descent Parser (LL(1) Grammar)")
      println("==================================================")

      #L Gramatica de Expressoes Aritmeticas:
      #L E  -> T E'
      #L E' -> + T E' | - T E' | epsilon
      #L T  -> F T'
      #L T' -> * F T' | / F T' | epsilon
      #L F  -> NUM | ( E )

      #L Stream de Tokens da expressao: "10 + 20 * 3"
      #L Tipos: 1=NUM, 2=OP_ADD (+), 3=OP_SUB (-), 4=OP_MUL (*), 5=OP_DIV (/), 6=EOF
      mut as list of int64: tokenTypes = [1, 2, 1, 4, 1, 6]
      mut as list of int64: tokenValues = [10, 0, 20, 0, 3, 0]
      mut as int64: numTokens = 6
      mut as int64: cursor = 1

      println("1. Stream de Tokens de Entrada:")
      mut as int64: t = 1
      infinite (t <= numTokens) {
            mut as int64: ty = tokenTypes[t]
            route {
                  ty == 1 ==> { println("   Token " + t + ": NUM (" + tokenValues[t] + ")") }
                  ty == 2 ==> { println("   Token " + t + ": PLUS (+)") }
                  ty == 4 ==> { println("   Token " + t + ": STAR (*)") }
                  ty == 6 ==> { println("   Token " + t + ": EOF") }
                  _ ==> {}
            }
            t = t + 1
      }

      println("==================================================")
      println("2. Execucao do Parsing Descendente Recursivo:")

      #L Simulacao do Parse de E -> T E'
      #L Parse T:
      #L Fatorial inicial: F -> NUM
      mut as int64: currentVal = 0
      mut as int64: termVal = 0
      mut as int64: exprVal = 0

      #L Le primeiro fator de T:
      route {
            tokenTypes[cursor] == 1 ==> {
                  termVal = tokenValues[cursor]
                  println("   [Fator F]: Consumido NUM = " + termVal)
                  cursor = cursor + 1
            }
            _ ==> {}
      }

      #L Loop T': verifica * ou /
      infinite (cursor <= numTokens) {
            mut as int64: opType = tokenTypes[cursor]
            route {
                  opType == 4 ==> {
                        println("   [Termo T']: Encontrado operador STAR (*)")
                        cursor = cursor + 1
                        route {
                              tokenTypes[cursor] == 1 ==> {
                                    mut as int64: nextF = tokenValues[cursor]
                                    println("   [Fator F]: Consumido NUM = " + nextF)
                                    termVal = termVal * nextF
                                    cursor = cursor + 1
                              }
                              _ ==> {}
                        }
                  }
                  opType == 5 ==> {
                        println("   [Termo T']: Encontrado operador DIV (/)")
                        cursor = cursor + 1
                        route {
                              tokenTypes[cursor] == 1 ==> {
                                    mut as int64: nextF = tokenValues[cursor]
                                    termVal = termVal /i nextF
                                    cursor = cursor + 1
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        #L Epsilon
                        break
                  }
            }
      }
      exprVal = termVal
      println("   [Termo T Concluido]: Valor acumulado = " + exprVal)

      #L Loop E': verifica + ou -
      infinite (cursor <= numTokens) {
            mut as int64: opType = tokenTypes[cursor]
            route {
                  opType == 2 ==> {
                        println("   [Expressao E']: Encontrado operador PLUS (+)")
                        cursor = cursor + 1
                        #L Parse proximo T
                        mut as int64: nextTerm = 0
                        route {
                              tokenTypes[cursor] == 1 ==> {
                                    nextTerm = tokenValues[cursor]
                                    println("   [Fator F]: Consumido NUM = " + nextTerm)
                                    cursor = cursor + 1
                              }
                              _ ==> {}
                        }
                        #L T' para o proximo termo
                        infinite (cursor <= numTokens) {
                              mut as int64: subOp = tokenTypes[cursor]
                              route {
                                    subOp == 4 ==> {
                                          println("   [Termo T']: Encontrado operador STAR (*)")
                                          cursor = cursor + 1
                                          route {
                                                tokenTypes[cursor] == 1 ==> {
                                                      mut as int64: nextF = tokenValues[cursor]
                                                      println("   [Fator F]: Consumido NUM = " + nextF)
                                                      nextTerm = nextTerm * nextF
                                                      cursor = cursor + 1
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {
                                          break
                                    }
                              }
                        }
                        exprVal = exprVal + nextTerm
                        println("   [Adicao Concluida]: Soma parcial = " + exprVal)
                  }
                  opType == 3 ==> {
                        println("   [Expressao E']: Encontrado operador MINUS (-)")
                        cursor = cursor + 1
                        mut as int64: nextTerm = 0
                        route {
                              tokenTypes[cursor] == 1 ==> {
                                    nextTerm = tokenValues[cursor]
                                    cursor = cursor + 1
                              }
                              _ ==> {}
                        }
                        exprVal = exprVal - nextTerm
                  }
                  _ ==> {
                        break
                  }
            }
      }

      println("==================================================")
      println("3. Conclusao do Parser e Resultado Sintatico:")
      println("   Tokens consumidos ate: " + cursor + " (Tipo: " + tokenTypes[cursor] + ")")
      println("   Resultado da Avaliacao AST: " + exprVal)

      #L 10 + 20 * 3 = 10 + 60 = 70
      route {
            exprVal == 70 ==> {
                  println("   SUCESSO: Expressao '10 + 20 * 3' analisada com precedencia correta (70)!")
            }
            _ ==> {
                  println("   FALHA: Precedencia incorreta.")
            }
      }
}
