#L ============================================================================
#L Algoritmo: Linear Search (Busca Sequencial)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: Tempo O(N) pior caso, O(1) melhor caso | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaLinearSearch) {
      println("==================================================")
      println("  SciAlgo: Linear Search (Sequential Search)")
      println("==================================================")

      #L Coleção desordenada de teste (N = 10 elementos)
      mut as list of int64: dados = [42, 17, 89, 5, 23, 67, 12, 98, 34, 56]
      mut as int64: n = listLength(dados)
      println("1. Vetor de dados (tamanho " + n + "):")
      println("   [42, 17, 89, 5, 23, 67, 12, 98, 34, 56]")

      #L ======================================================================
      #L Teste 1: Busca no início (Melhor Caso - O(1))
      #L ======================================================================
      mut as int64: target1 = 42
      println("2. Teste 1: Buscando alvo " + target1 + " (inicio do vetor):")
      mut as int64: pos1 = -1
      mut as int64: comps1 = 0
      mut as int64: i1 = 1
      infinite (i1 <= n and pos1 < 0) {
            comps1 = comps1 + 1
            route {
                  dados[i1] == target1 ==> {
                        pos1 = i1
                  }
                  _ ==> {
                        i1 = i1 + 1
                  }
            }
      }
      println("   -> Encontrado na posicao: " + pos1 + " com " + comps1 + " comparacao(oes)")

      #L ======================================================================
      #L Teste 2: Busca no meio (Caso Médio - O(N/2))
      #L ======================================================================
      mut as int64: target2 = 23
      println("3. Teste 2: Buscando alvo " + target2 + " (meio do vetor):")
      mut as int64: pos2 = -1
      mut as int64: comps2 = 0
      mut as int64: i2 = 1
      infinite (i2 <= n and pos2 < 0) {
            comps2 = comps2 + 1
            route {
                  dados[i2] == target2 ==> {
                        pos2 = i2
                  }
                  _ ==> {
                        i2 = i2 + 1
                  }
            }
      }
      println("   -> Encontrado na posicao: " + pos2 + " com " + comps2 + " comparacoes")

      #L ======================================================================
      #L Teste 3: Busca no fim (Pior Caso de Sucesso - O(N))
      #L ======================================================================
      mut as int64: target3 = 56
      println("4. Teste 3: Buscando alvo " + target3 + " (fim do vetor):")
      mut as int64: pos3 = -1
      mut as int64: comps3 = 0
      mut as int64: i3 = 1
      infinite (i3 <= n and pos3 < 0) {
            comps3 = comps3 + 1
            route {
                  dados[i3] == target3 ==> {
                        pos3 = i3
                  }
                  _ ==> {
                        i3 = i3 + 1
                  }
            }
      }
      println("   -> Encontrado na posicao: " + pos3 + " com " + comps3 + " comparacoes")

      #L ======================================================================
      #L Teste 4: Elemento ausente (Pior Caso Completo - O(N))
      #L ======================================================================
      mut as int64: target4 = 99
      println("5. Teste 4: Buscando alvo ausente " + target4 + ":")
      mut as int64: pos4 = -1
      mut as int64: comps4 = 0
      mut as int64: i4 = 1
      infinite (i4 <= n and pos4 < 0) {
            comps4 = comps4 + 1
            route {
                  dados[i4] == target4 ==> {
                        pos4 = i4
                  }
                  _ ==> {
                        i4 = i4 + 1
                  }
            }
      }
      route {
            pos4 < 0 ==> {
                  println("   -> [PASS] Alvo " + target4 + " NAO encontrado apos " + comps4 + " comparacoes")
            }
            _ ==> {
                  println("   -> [ERRO] Alvo encontrado indevidamente.")
            }
      }

      #L ======================================================================
      #L Teste 5: Busca Linear com Sentinela (Otimização de loop)
      #L ======================================================================
      println("6. Teste 5: Busca Linear com Sentinela (reducao de checks por iteracao):")
      mut as int64: target5 = 67
      mut as list of int64: dados_sentinela = [42, 17, 89, 5, 23, 67, 12, 98, 34, 56, 67] #L Sentinela no indice N+1
      mut as int64: si = 1
      infinite (dados_sentinela[si] != target5) {
            si = si + 1
      }
      route {
            si <= n ==> {
                  println("   -> [PASS] Alvo " + target5 + " localizado na posicao valida: " + si)
            }
            _ ==> {
                  println("   -> [PASS] Alvo localizado apenas na sentinela (ausente).")
            }
      }

      println("==================================================")
      println("Linear Search concluido com sucesso!")
}
