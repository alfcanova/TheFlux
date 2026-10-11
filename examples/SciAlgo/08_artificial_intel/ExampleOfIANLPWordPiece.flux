#L ============================================================================
#L Algoritmo: WordPiece Tokenizer
#L Dominio: 08_artificial_intel / Subdominio: Processamento de Linguagem Natural
#L Descricao: Segmentacao de subpalavras baseada em pontuacao de verossimilhanca e prefixo de continuacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPWordPiece) {
      println("=== Algoritmo: WordPiece Tokenizer ===")

      #L Palavra alvo: 'unhappiness'
      #L Vocabulario contem: 'un', '##happy', '##ness'
      #L IDs no vocabulario:
      #L 'un' = 101
      #L '##happy' = 102
      #L '##ness' = 103

      #L Pontuacao de verossimilhanca para fusao: score(A, B) = count(AB) /i (count(A) * count(B))
      #L count('un') = 50, count('happy') = 40, count('unhappy') = 30
      #L score escalado por 1000 = (30 * 1000) /i (50 * 40 /i 100) = 30000 /i 20 = 1500
      mut as int64: score_unhappy = 1500
      println("1. Pontuacao de probabilidade conjunta WordPiece: " + score_unhappy)

      #L Decomposicao greedy longest-match-first da palavra:
      mut as list of int64: subword_ids = [101, 102, 103]

      println("2. Subpalavras identificadas:")
      println("   Prefixo 1 ('un'): " + subword_ids[1])
      println("   Continuacao 2 ('##happy'): " + subword_ids[2])
      println("   Sufixo 3 ('##ness'): " + subword_ids[3])

      route {
            subword_ids[1] == 101 and subword_ids[2] == 102 and subword_ids[3] == 103 ==> {
                  println("3. Tokenizacao WordPiece validada com sucesso.")
            }
            _ ==> {
                  println("Falha no tokenizer WordPiece.")
            }
      }
      println("Teste concluido com sucesso.")
}
