#L ============================================================================
#L Algoritmo: Sethi-Ullman (Alocacao Otima de Registradores em AST)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresSethiUllman) {
      println("==================================================")
      println("  SciAlgo: Sethi-Ullman Register Allocation")
      println("==================================================")

      #L AST da expressao: (a + b) * (c - (d + e))
      #L Nos:
      #L 1: folha 'a'
      #L 2: folha 'b'
      #L 3: '+' (filhos 1, 2)
      #L 4: folha 'c'
      #L 5: folha 'd'
      #L 6: folha 'e'
      #L 7: '+' (filhos 5, 6)
      #L 8: '-' (filhos 4, 7)
      #L 9: '*' (filhos 3, 8) - Raiz da expressao

      mut as int64: numNodes = 9
      mut as list of int64: leftChild  = [0, 0, 1, 0, 0, 0, 5, 4, 3]
      mut as list of int64: rightChild = [0, 0, 2, 0, 0, 0, 6, 7, 8]
      mut as list of int64: isLeaf     = [1, 1, 0, 1, 1, 1, 0, 0, 0]

      #L Vetor para armazenar o numero de Sethi-Ullman (registradores minimos necessarios)
      mut as list of int64: suNumber   = [0, 0, 0, 0, 0, 0, 0, 0, 0]

      println("1. Calculo Bottom-Up dos Numeros de Sethi-Ullman:")

      mut as int64: i = 1
      infinite (i <= numNodes) {
            route {
                  isLeaf[i] == 1 ==> {
                        #L Folha requer 1 registrador para carregar operando
                        suNumber[i] = 1
                  }
                  _ ==> {
                        mut as int64: l = leftChild[i]
                        mut as int64: r = rightChild[i]
                        mut as int64: lCost = suNumber[l]
                        mut as int64: rCost = suNumber[r]

                        route {
                              lCost == rCost ==> {
                                    suNumber[i] = lCost + 1
                              }
                              lCost > rCost ==> {
                                    suNumber[i] = lCost
                              }
                              _ ==> {
                                    suNumber[i] = rCost
                              }
                        }
                  }
            }

            println("   No " + i + " -> Registradores necessarios: " + suNumber[i])
            i = i + 1
      }

      println("==================================================")
      println("2. Verificacao de Custo Minimo na Raiz:")
      mut as int64: rootCost = suNumber[9]
      println("   Custo de registradores da raiz (No 9): " + rootCost)

      #L Ordem otima de avaliacao baseada nos custos:
      #L No 8: filho esquerdo (c) custa 1, filho direito (7) custa 2 -> avaliar filho direito primeiro!
      mut as int64: node8EvalRightFirst = 0
      route {
            suNumber[rightChild[8]] > suNumber[leftChild[8]] ==> {
                  node8EvalRightFirst = 1
            }
            _ ==> {}
      }

      route {
            rootCost == 3 and node8EvalRightFirst == 1 ==> {
                  println("   SUCESSO: Numeracao Sethi-Ullman valida e ordem otima confirmada!")
            }
            _ ==> {
                  println("   FALHA: Calculo Sethi-Ullman divergente.")
            }
      }
}
