#L ============================================================================
#L Algoritmo: CYK (Cocke-Younger-Kasami Dynamic Programming Parser)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresCYK) {
      println("==================================================")
      println("  SciAlgo: CYK (Cocke-Younger-Kasami Parsing)")
      println("==================================================")

      #L Gramatica em Forma Normal de Chomsky (CNF):
      #L Nao-terminais: 1=S, 2=A, 3=B, 4=C
      #L Terminais: 1='a', 2='b'
      #L Regras Terminais:
      #L A -> 'a', B -> 'b', C -> 'a'
      #L Regras Binarias:
      #L S -> A B | B C
      #L A -> B A
      #L B -> C C
      #L C -> A B

      #L Palavra de entrada: "b a a b" (comprimento n=4)
      mut as list of int64: word = [2, 1, 1, 2] #L 'b', 'a', 'a', 'b'
      mut as int64: n = 4
      mut as int64: numNonTerm = 4

      println("1. Palavra de Entrada: ['b', 'a', 'a', 'b'] (Tamanho n=4)")
      println("   Gramatica CNF: S -> AB | BC, A -> BA, B -> CC, C -> AB")

      #L Tabela DP triangular P[len, start, nonterminal]
      #L Dimensoes: len in 1..4, start in 1..4, nt in 1..4
      #L Achatamento: (len - 1) * 16 + (start - 1) * 4 + nt
      mut as list of int64: tableP = [
            0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, #L len 1
            0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, #L len 2
            0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, #L len 3
            0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0  #L len 4
      ]

      println("==================================================")
      println("2. Base da DP: Subpalavras de Comprimento 1 (Terminais):")
      mut as int64: s = 1
      infinite (s <= n) {
            mut as int64: charCode = word[s]
            #L Se char == 'a' (1) -> A(2) e C(4)
            #L Se char == 'b' (2) -> B(3)
            route {
                  charCode == 1 ==> {
                        #L A (2)
                        mut as int64: idxA = (1 - 1) * 16 + (s - 1) * 4 + 2
                        tableP[idxA] = 1
                        #L C (4)
                        mut as int64: idxC = (1 - 1) * 16 + (s - 1) * 4 + 4
                        tableP[idxC] = 1
                        println("   Posicao " + s + " ('a'): Nao-terminais {A, C}")
                  }
                  charCode == 2 ==> {
                        #L B (3)
                        mut as int64: idxB = (1 - 1) * 16 + (s - 1) * 4 + 3
                        tableP[idxB] = 1
                        println("   Posicao " + s + " ('b'): Nao-terminal {B}")
                  }
                  _ ==> {}
            }
            s = s + 1
      }

      println("==================================================")
      println("3. Passo Indutivo da DP: Subpalavras de Comprimento 2 ate n:")
      mut as int64: l = 2
      infinite (l <= n) {
            s = 1
            infinite (s <= n - l + 1) {
                  #L Divide a subpalavra de comprimento l em dois pedacos k e (l - k)
                  mut as int64: k = 1
                  infinite (k < l) {
                        #L Verifica combinacoes:
                        #L 1. S -> A B
                        mut as int64: idxLeftA = (k - 1) * 16 + (s - 1) * 4 + 2
                        mut as int64: idxRightB = (l - k - 1) * 16 + (s + k - 1) * 4 + 3
                        route {
                              tableP[idxLeftA] == 1 ==> {
                                    route {
                                          tableP[idxRightB] == 1 ==> {
                                                mut as int64: idxS = (l - 1) * 16 + (s - 1) * 4 + 1
                                                tableP[idxS] = 1
                                                #L C -> A B tambem e derivavel
                                                mut as int64: idxC = (l - 1) * 16 + (s - 1) * 4 + 4
                                                tableP[idxC] = 1
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        #L 2. S -> B C
                        mut as int64: idxLeftB = (k - 1) * 16 + (s - 1) * 4 + 3
                        mut as int64: idxRightC = (l - k - 1) * 16 + (s + k - 1) * 4 + 4
                        route {
                              tableP[idxLeftB] == 1 ==> {
                                    route {
                                          tableP[idxRightC] == 1 ==> {
                                                mut as int64: idxS = (l - 1) * 16 + (s - 1) * 4 + 1
                                                tableP[idxS] = 1
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        #L 3. A -> B A
                        mut as int64: idxRightA = (l - k - 1) * 16 + (s + k - 1) * 4 + 2
                        route {
                              tableP[idxLeftB] == 1 ==> {
                                    route {
                                          tableP[idxRightA] == 1 ==> {
                                                mut as int64: idxA = (l - 1) * 16 + (s - 1) * 4 + 2
                                                tableP[idxA] = 1
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }

                        #L 4. B -> C C
                        route {
                              tableP[idxLeftA] == 1 ==> { #L aproveitando slot
                                    route {
                                          tableP[idxRightC] == 1 ==> {
                                                mut as int64: idxB = (l - 1) * 16 + (s - 1) * 4 + 3
                                                tableP[idxB] = 1
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        k = k + 1
                  }
                  s = s + 1
            }
            l = l + 1
      }

      println("==================================================")
      println("4. Verificacao de Aceitacao (Simbolo Inicial S na Raiz):")
      #L Verifica se S (1) deriva a palavra inteira: len=4, start=1, nt=1
      mut as int64: rootSIdx = (4 - 1) * 16 + (1 - 1) * 4 + 1
      mut as int64: isAccepted = tableP[rootSIdx]
      println("   Simbolo S deriva a palavra 'b a a b' (len=4, pos=1): " + isAccepted)

      route {
            isAccepted == 1 ==> {
                  println("   SUCESSO: Palavra reconhecida pela gramatica com o algoritmo CYK!")
            }
            _ ==> {
                  println("   FALHA: Palavra nao pertence a linguagem.")
            }
      }
}
