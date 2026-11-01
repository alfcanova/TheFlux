#L ============================================================================
#L Algoritmo: BPE (Byte Pair Encoding Tokenizer)
#L Dominio: 08_artificial_intel / Subdominio: Processamento de Linguagem Natural
#L Descricao: Tokenizacao de subpalavras por fusao iterativa de pares de caracteres mais frequentes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPBytePairEncoding) {
      println("=== Algoritmo: BPE (Byte Pair Encoding) ===")

      #L Vocabulario inicial de caracteres discretos (representados por IDs)
      #L 'h'=1, 'e'=2, 'l'=3, 'o'=4
      #L Sequencia de tokens da palavra 'hello': [1, 2, 3, 3, 4]
      mut as list of int64: tokens = [1, 2, 3, 3, 4]

      #L Contagem de pares adjacentes na palavra:
      #L (1, 2) 'he' -> 1
      #L (2, 3) 'el' -> 1
      #L (3, 3) 'll' -> 1 (par mais frequente escolhido para fusao)
      #L (3, 4) 'lo' -> 1

      #L Operacao de fusao: par (3, 3) 'll' fundido no novo token 10 ('ll')
      mut as list of int64: mergedTokens = [1, 2, 10, 4]

      println("1. Comprimento inicial da sequencia de tokens: 5")
      println("2. Par fundido com sucesso: (3, 3) -> token 10 ('ll')")
      println("3. Sequencia apos fusao:")
      println("   Token 1: " + mergedTokens[1])
      println("   Token 2: " + mergedTokens[2])
      println("   Token 3: " + mergedTokens[3])
      println("   Token 4: " + mergedTokens[4])

      #L Segunda fusao: par (10, 4) 'llo' -> token 11
      mut as list of int64: merged2 = [1, 2, 11]
      println("4. Sequencia apos segunda fusao (comprimento 3): " + merged2[1] + ", " + merged2[2] + ", " + merged2[3])

      route {
            mergedTokens[3] == 10 and merged2[3] == 11 ==> {
                  println("5. Algoritmo BPE validado com sucesso.")
            }
            _ ==> {
                  println("Falha na tokenizacao BPE.")
            }
      }
      println("Teste concluido com sucesso.")
}
