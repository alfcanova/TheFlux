#L ============================================================================
#L Algoritmo: Operator-Precedence Parsing de Floyd
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresOperatorPrecedence) {
      println("==================================================")
      println("  SciAlgo: Floyd Operator-Precedence Parser")
      println("==================================================")

      #L Operadores Terminais:
      #L 1: +, 2: *, 3: id, 4: $
      #L 99: N (Simbolo nao-terminal resultante de reducao)

      #L Relacoes de precedencia de operadores:
      #L 1: <. (cede precedencia / Shift)
      #L 2: =. (mesma precedencia)
      #L 3: .> (toma precedencia / Reduce)
      #L 999: Aceitacao ($ com $)

      #L Sentenca de entrada: "id + id * id $"
      mut as list of int64: inputTokens = [3, 1, 3, 2, 3, 4]
      mut as int64: numTokens = 6
      mut as int64: ip = 1

      #L Pilha de simbolos (1-indexed, base e $)
      mut as list of int64: stack = [4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1

      mut as int64: stepCount = 0
      mut as int64: shifts = 0
      mut as int64: reduces = 0
      mut as int64: accepted = 0
      mut as int64: running = 1

      println("1. Executando Parsing de Precedencia de Floyd:")

      infinite (stepCount < 40 and running == 1) {
            stepCount = stepCount + 1

            #L Localiza o terminal mais proximo do topo ignorando nao-terminais N (99)
            mut as int64: topOpIdx = top
            infinite (topOpIdx > 1 and stack[topOpIdx] == 99) {
                  topOpIdx = topOpIdx - 1
            }
            mut as int64: topOp = stack[topOpIdx]
            mut as int64: currTok = inputTokens[ip]

            #L Determina relacao entre topOp e currTok
            mut as int64: relation = 0

            route {
                  topOp == 4 ==> { #L $
                        route {
                              currTok == 4 ==> { relation = 999 } #L $ com $ -> Aceita
                              currTok >= 1 and currTok <= 3 ==> { relation = 1 } #L $ <. op
                              _ ==> {}
                        }
                  }
                  topOp == 1 ==> { #L +
                        route {
                              currTok == 4 ==> { relation = 3 } #L + .> $
                              currTok == 1 ==> { relation = 3 } #L + .> +
                              currTok == 2 ==> { relation = 1 } #L + <. *
                              currTok == 3 ==> { relation = 1 } #L + <. id
                              _ ==> {}
                        }
                  }
                  topOp == 2 ==> { #L *
                        route {
                              currTok == 4 ==> { relation = 3 } #L * .> $
                              currTok == 1 ==> { relation = 3 } #L * .> +
                              currTok == 2 ==> { relation = 3 } #L * .> *
                              currTok == 3 ==> { relation = 1 } #L * <. id
                              _ ==> {}
                        }
                  }
                  topOp == 3 ==> { #L id
                        route {
                              currTok == 4 ==> { relation = 3 } #L id .> $
                              currTok == 1 ==> { relation = 3 } #L id .> +
                              currTok == 2 ==> { relation = 3 } #L id .> *
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            route {
                  relation == 999 ==> {
                        accepted = 1
                        running = 0
                  }
                  relation == 1 or relation == 2 ==> {
                        #L Shift
                        shifts = shifts + 1
                        top = top + 1
                        stack[top] = currTok
                        ip = ip + 1
                  }
                  relation == 3 ==> {
                        #L Reduce
                        reduces = reduces + 1

                        route {
                              stack[top] == 3 ==> {
                                    #L Reducao de id -> N
                                    stack[top] = 99
                              }
                              top >= 3 and stack[top] == 99 and (stack[top - 1] == 1 or stack[top - 1] == 2) and stack[top - 2] == 99 ==> {
                                    #L Reducao de N op N -> N
                                    top = top - 2
                                    stack[top] = 99
                              }
                              _ ==> {
                                    running = 0
                              }
                        }
                  }
                  _ ==> {
                        running = 0
                  }
            }
      }

      println("==================================================")
      println("2. Resultados do Parser de Precedencia:")
      println("   Passos executados: " + stepCount)
      println("   Shifts: " + shifts)
      println("   Reducoes: " + reduces)
      println("   Status de aceitacao: " + accepted)

      route {
            accepted == 1 ==> {
                  println("   SUCESSO: Entrada aceita pela matriz de precedencia!")
            }
            _ ==> {
                  println("   FALHA: Rejeitada pelo parser.")
            }
      }
}
