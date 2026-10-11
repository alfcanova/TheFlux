#L ============================================================================
#L Algoritmo: Linearizacao C3 (Method Resolution Order - MRO)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresC3Linearization) {
      println("==================================================")
      println("  SciAlgo: C3 Superclass Linearization (MRO)")
      println("==================================================")

      #L Hierarquia de heranca multipla classica:
      #L 1: Object (O)
      #L 2: A(O)        -> MRO: [A, O]
      #L 3: B(O)        -> MRO: [B, O]
      #L 4: C(O)        -> MRO: [C, O]
      #L 5: D(A, B)     -> MRO: [D, A, B, O]
      #L 6: E(B, C)     -> MRO: [E, B, C, O]
      #L 7: K(D, E)     -> MRO: K + merge(L(D), L(E), [D, E])

      #L Queremos calcular a linearizacao de K(D, E):
      #L Listas a fundir (merge):
      #L Lista 1: L(D) = [5, 2, 3, 1] (D, A, B, O)
      #L Lista 2: L(E) = [6, 3, 4, 1] (E, B, C, O)
      #L Lista 3: Parents = [5, 6]    (D, E)

      mut as list of int64: list1 = [5, 2, 3, 1]
      mut as int64: len1 = 4
      mut as int64: ptr1 = 1

      mut as list of int64: list2 = [6, 3, 4, 1]
      mut as int64: len2 = 4
      mut as int64: ptr2 = 1

      mut as list of int64: list3 = [5, 6]
      mut as int64: len3 = 2
      mut as int64: ptr3 = 1

      #L MRO resultante de K: comeca com a propria classe K (7)
      mut as list of int64: mroResult = [7, 0, 0, 0, 0, 0, 0]
      mut as int64: mroLen = 1

      println("1. Executando algoritmo de fusao C3:")

      mut as int64: step = 1
      infinite (step <= 10 and (ptr1 <= len1 or ptr2 <= len2 or ptr3 <= len3)) {
            mut as int64: cand = 0

            #L Testa cabeca da lista 1
            route {
                  cand == 0 and ptr1 <= len1 ==> {
                        mut as int64: h1 = list1[ptr1]
                        #L Verifica se h1 esta na cauda de list2 ou list3
                        mut as int64: inTail = 0
                        mut as int64: t2 = ptr2 + 1
                        infinite (t2 <= len2) {
                              route {
                                    list2[t2] == h1 ==> { inTail = 1 }
                                    _ ==> {}
                              }
                              t2 = t2 + 1
                        }
                        mut as int64: t3 = ptr3 + 1
                        infinite (t3 <= len3) {
                              route {
                                    list3[t3] == h1 ==> { inTail = 1 }
                                    _ ==> {}
                              }
                              t3 = t3 + 1
                        }
                        route {
                              inTail == 0 ==> { cand = h1 }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            #L Se nao encontrou, testa cabeca da lista 2
            route {
                  cand == 0 and ptr2 <= len2 ==> {
                        mut as int64: h2 = list2[ptr2]
                        mut as int64: inTail = 0
                        mut as int64: t1 = ptr1 + 1
                        infinite (t1 <= len1) {
                              route {
                                    list1[t1] == h2 ==> { inTail = 1 }
                                    _ ==> {}
                              }
                              t1 = t1 + 1
                        }
                        mut as int64: t3 = ptr3 + 1
                        infinite (t3 <= len3) {
                              route {
                                    list3[t3] == h2 ==> { inTail = 1 }
                                    _ ==> {}
                              }
                              t3 = t3 + 1
                        }
                        route {
                              inTail == 0 ==> { cand = h2 }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            route {
                  cand > 0 ==> {
                        mroLen = mroLen + 1
                        mroResult[mroLen] = cand
                        println("   Classe selecionada: " + cand)

                        #L Avanca ponteiros onde cand era a cabeca (com guardas aninhadas para evitar avaliacao gulosa)
                        route {
                              ptr1 <= len1 ==> {
                                    route {
                                          list1[ptr1] == cand ==> { ptr1 = ptr1 + 1 }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        route {
                              ptr2 <= len2 ==> {
                                    route {
                                          list2[ptr2] == cand ==> { ptr2 = ptr2 + 1 }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        route {
                              ptr3 <= len3 ==> {
                                    route {
                                          list3[ptr3] == cand ==> { ptr3 = ptr3 + 1 }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        break
                  }
            }

            step = step + 1
      }

      println("==================================================")
      println("2. Ordem de Resolucao de Metodos (MRO) Final:")
      mut as int64: m = 1
      infinite (m <= mroLen) {
            println("   Posicao " + m + " -> Classe ID " + mroResult[m])
            m = m + 1
      }

      #L MRO esperado para K(D, E): K (7), D (5), A (2), E (6), B (3), C (4), O (1)
      mut as int64: isCorrect = 0
      route {
            mroLen == 7 and
            mroResult[1] == 7 and
            mroResult[2] == 5 and
            mroResult[3] == 2 and
            mroResult[4] == 6 and
            mroResult[5] == 3 and
            mroResult[6] == 4 and
            mroResult[7] == 1 ==> {
                  isCorrect = 1
            }
            _ ==> {}
      }

      route {
            isCorrect == 1 ==> {
                  println("   SUCESSO: Linearizacao C3 monotona e correta!")
            }
            _ ==> {
                  println("   FALHA: Ordem MRO C3 divergente.")
            }
      }
}
