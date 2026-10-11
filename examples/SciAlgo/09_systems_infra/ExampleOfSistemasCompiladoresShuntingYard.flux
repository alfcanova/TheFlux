#L ============================================================================
#L Algoritmo: Shunting-Yard de Dijkstra (Infixo para Notacao Polonesa Reversa)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresShuntingYard) {
      println("==================================================")
      println("  SciAlgo: Dijkstra's Shunting-Yard Algorithm")
      println("==================================================")

      #L Tipos de Token:
      #L 1: NUM
      #L 2: PLUS (+)   - Precedencia 2, Associativo a esquerda
      #L 3: MINUS (-)  - Precedencia 2, Associativo a esquerda
      #L 4: MUL (*)    - Precedencia 3, Associativo a esquerda
      #L 5: DIV (/)    - Precedencia 3, Associativo a esquerda
      #L 6: LPAREN (()
      #L 7: RPAREN ())

      #L Expressao infixa: ( 10 + 20 ) * 3 - 30 / 2
      #L Tokens tipo: [6, 1, 2, 1, 7, 4, 1, 3, 1, 5, 1]
      #L Tokens valor: [0, 10, 0, 20, 0, 0, 3, 0, 30, 0, 2]
      mut as list of int64: tokType = [6, 1, 2, 1, 7, 4, 1, 3, 1, 5, 1]
      mut as list of int64: tokVal  = [0, 10, 0, 20, 0, 0, 3, 0, 30, 0, 2]
      mut as int64: numToks = 11

      #L Fila de saida RPN (tipo e valor emparelhados)
      mut as list of int64: outType = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: outVal  = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: outCount = 0

      #L Pilha de operadores
      mut as list of int64: opStack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: opTop = 0

      println("1. Convertendo Infixo para Posfixo (RPN):")

      mut as int64: i = 1
      infinite (i <= numToks) {
            mut as int64: tType = tokType[i]
            mut as int64: tVal  = tokVal[i]

            route {
                  tType == 1 ==> {
                        #L Numero vai direto para a saida
                        outCount = outCount + 1
                        outType[outCount] = 1
                        outVal[outCount] = tVal
                  }
                  tType >= 2 and tType <= 5 ==> {
                        #L Operador o1
                        mut as int64: o1Prec = 0
                        route {
                              tType == 2 or tType == 3 ==> { o1Prec = 2 }
                              tType == 4 or tType == 5 ==> { o1Prec = 3 }
                              _ ==> {}
                        }

                        #L Desempilha operadores do topo com precedencia >= o1Prec
                        mut as int64: keepPopping = 1
                        infinite (opTop > 0 and keepPopping == 1) {
                              route {
                                    opStack[opTop] == 6 ==> {
                                          keepPopping = 0
                                    }
                                    _ ==> {
                                          mut as int64: topOp = opStack[opTop]
                                          mut as int64: topPrec = 0
                                          route {
                                                topOp == 2 or topOp == 3 ==> { topPrec = 2 }
                                                topOp == 4 or topOp == 5 ==> { topPrec = 3 }
                                                _ ==> {}
                                          }

                                          route {
                                                topPrec >= o1Prec ==> {
                                                      outCount = outCount + 1
                                                      outType[outCount] = topOp
                                                      outVal[outCount] = 0
                                                      opTop = opTop - 1
                                                }
                                                _ ==> {
                                                      keepPopping = 0
                                                }
                                          }
                                    }
                              }
                        }

                        opTop = opTop + 1
                        opStack[opTop] = tType
                  }
                  tType == 6 ==> {
                        #L Parentese esquerdo abre escopo
                        opTop = opTop + 1
                        opStack[opTop] = 6
                  }
                  tType == 7 ==> {
                        #L Parentese direito: desempilha ate encontrar parentese esquerdo
                        mut as int64: popScope = 1
                        infinite (opTop > 0 and popScope == 1) {
                              route {
                                    opStack[opTop] == 6 ==> {
                                          popScope = 0
                                    }
                                    _ ==> {
                                          outCount = outCount + 1
                                          outType[outCount] = opStack[opTop]
                                          outVal[outCount] = 0
                                          opTop = opTop - 1
                                    }
                              }
                        }
                        route {
                              opTop > 0 and opStack[opTop] == 6 ==> {
                                    opTop = opTop - 1
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            i = i + 1
      }

      #L Esvazia operadores restantes na pilha
      infinite (opTop > 0) {
            outCount = outCount + 1
            outType[outCount] = opStack[opTop]
            outVal[outCount] = 0
            opTop = opTop - 1
      }

      println("   Total de tokens na saida RPN: " + outCount)

      println("==================================================")
      println("2. Avaliando a Notacao Posfixa RPN via Pilha:")

      #L Pilha de avaliacao aritmetica
      mut as list of int64: evalStack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: evalTop = 0

      mut as int64: k = 1
      infinite (k <= outCount) {
            mut as int64: ty = outType[k]
            mut as int64: vl = outVal[k]

            route {
                  ty == 1 ==> {
                        evalTop = evalTop + 1
                        evalStack[evalTop] = vl
                  }
                  _ ==> {
                        mut as int64: b = evalStack[evalTop]
                        evalTop = evalTop - 1
                        mut as int64: a = evalStack[evalTop]

                        mut as int64: res = 0
                        route {
                              ty == 2 ==> { res = a + b }
                              ty == 3 ==> { res = a - b }
                              ty == 4 ==> { res = a * b }
                              ty == 5 ==> { res = a /i b }
                              _ ==> {}
                        }
                        evalStack[evalTop] = res
                  }
            }
            k = k + 1
      }

      mut as int64: finalResult = evalStack[evalTop]
      println("   Resultado calculado da expressao: " + finalResult)
      #L (10 + 20) * 3 - 30 / 2 = 30 * 3 - 15 = 90 - 15 = 75

      route {
            finalResult == 75 ==> {
                  println("   SUCESSO: Shunting-Yard e avaliacao RPN corretos (75)!")
            }
            _ ==> {
                  println("   FALHA: Resultado RPN incorreto.")
            }
      }
}
