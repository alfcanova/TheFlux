#L ============================================================================
#L Algoritmo: Packrat Parser (Linear-Time PEG Parsing with Memoization)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresPackratParser) {
      println("==================================================")
      println("  SciAlgo: Packrat Parser (Memoized PEG Grammar)")
      println("==================================================")

      #L Gramatica PEG com escolha ordenada (Prioritized Choice):
      #L S <- A B / A C
      #L A <- 'a' 'a'
      #L B <- 'b'
      #L C <- 'c'
      #L Entrada: "a a c" -> Codificada como [1, 1, 3]
      #L Onde 1='a', 2='b', 3='c'

      mut as list of int64: inputTokens = [1, 1, 3]
      mut as int64: inputLen = 3

      println("1. Entrada de Teste: ['a', 'a', 'c']")
      println("   Gramatica PEG: S <- (A B) / (A C)")

      #L Tabela de Memoizacao Packrat (Matriz 4 regras x 4 posicoes):
      #L Regras: 1=S, 2=A, 3=B, 4=C
      #L Posicoes: 1, 2, 3, 4
      #L Estado: 0 = Nao calculado, 1 = Sucesso, -1 = Falha
      #L Proxima posicao apos sucesso armazenada em nextPosTable
      mut as list of int64: memoStatus = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]
      mut as list of int64: memoNextPos = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]

      mut as int64: computeCountRuleA = 0

      println("==================================================")
      println("2. Tentativa 1: Ramo (A B) na Posicao 1:")

      #L Parse da Regra A na posicao 1: requer 'a' em pos 1 e 'a' em pos 2
      mut as int64: aSuccess = 0
      mut as int64: aNextPos = 1
      computeCountRuleA = computeCountRuleA + 1
      route {
            inputTokens[1] == 1 ==> {
                  route {
                        inputTokens[2] == 1 ==> {
                              aSuccess = 1
                              aNextPos = 3 #L Consumiu pos 1 e 2, proxima e 3
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      #L Memoiza resultado da Regra A na posicao 1
      #L Indice = (Regra - 1) * 4 + Pos = (2 - 1) * 4 + 1 = 5
      memoStatus[5] = aSuccess
      memoNextPos[5] = aNextPos
      println("   [Execucao Real]: Regra A analisada na pos 1 -> Sucesso=" + aSuccess + ", ProximaPos=" + aNextPos)

      #L Agora tenta casar B na posicao 3
      mut as int64: bSuccess = 0
      route {
            inputTokens[aNextPos] == 2 ==> { #L Procura 'b'
                  bSuccess = 1
            }
            _ ==> {
                  println("   [Falha no Ramo 1]: Esperado 'b' na pos 3, encontrado 'c' (Token " + inputTokens[aNextPos] + ")")
            }
      }

      println("==================================================")
      println("3. Tentativa 2: Ramo (A C) com Memoizacao Packrat:")
      #L O parser retrocede para a posicao 1 e tenta a segunda alternativa: (A C)
      #L Consulta a tabela Packrat para a Regra A na posicao 1:
      mut as int64: cachedStatusA = memoStatus[5]
      mut as int64: cachedNextPosA = memoNextPos[5]

      route {
            cachedStatusA != 0 ==> {
                  println("   [Packrat Cache HIT]: Reutilizando resultado memoizado de A na pos 1 em O(1)!")
                  println("   Nao foi necessario reexecutar o parse da regra A.")
            }
            _ ==> {
                  computeCountRuleA = computeCountRuleA + 1
            }
      }

      #L Agora tenta casar C na posicao cachedNextPosA (posicao 3)
      mut as int64: cSuccess = 0
      mut as int64: cNextPos = cachedNextPosA
      route {
            inputTokens[cachedNextPosA] == 3 ==> { #L Procura 'c'
                  cSuccess = 1
                  cNextPos = cachedNextPosA + 1 #L Pos 4 (EOF)
                  println("   [Sucesso no Ramo 2]: Regra C casou com sucesso com 'c' na pos 3!")
            }
            _ ==> {}
      }

      mut as int64: parseTreeSuccess = cachedStatusA & cSuccess
      println("==================================================")
      println("4. Conclusao do Parser Packrat:")
      println("   Total de vezes que a Regra A foi computada: " + computeCountRuleA + " (Sem memoizacao seria 2)")
      println("   Posicao final alcancada: " + cNextPos + " (Fim da entrada)")

      route {
            parseTreeSuccess == 1 ==> {
                  println("   SUCESSO: Expressao aceita pelo Packrat Parser em tempo linear O(N)!")
            }
            _ ==> {
                  println("   FALHA: Expressao rejeitada.")
            }
      }
}
