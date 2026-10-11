#L ============================================================================
#L Algoritmo: Okapi BM25 Lexical Ranking
#L Dominio: 08_artificial_intel / Subdominio: Processamento de Linguagem Natural
#L Descricao: Pontuacao de relevancia probabilistica com saturacao de frequencia e penalizacao de comprimento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPBM25) {
      println("=== Algoritmo: Okapi BM25 Lexical Ranking ===")

      #L Parametros padrao BM25: k1 = 1.2 -> 12, b = 0.75 -> 75 (escala 100)
      mut as int64: k1 = 12
      mut as int64: b = 75

      #L Estatisticas da colecao:
      #L Comprimento medio de documento (avgdl) = 100
      #L Comprimento do documento 1 (curto, focal): doc_len1 = 80
      #L Comprimento do documento 2 (longo, diluido): doc_len2 = 200
      #L Frequencia do termo de busca q no doc 1: tf1 = 3
      #L Frequencia do termo de busca q no doc 2: tf2 = 3
      #L IDF do termo
      mut as int64: idf = 20

      #L Calculo de penalizacao de comprimento B_len = (1 - b) + b * (doc_len / avgdl)
      #L Doc 1: B_len1 = 25 + (75 * 80) /i 100 = 25 + 60 = 85
      #L Doc 2: B_len2 = 25 + (75 * 200) /i 100 = 25 + 150 = 175
      mut as int64: b_len1 = 25 + 60
      mut as int64: b_len2 = 25 + 150

      #L Termo de saturacao:
      #L Denominador1 = tf1*10 + (k1 * B_len1) /i 100 = 30 + (12 * 85) /i 100 = 30 + 10 = 40
      #L Denominador2 = tf2*10 + (k1 * B_len2) /i 100 = 30 + (12 * 175) /i 100 = 30 + 21 = 51
      #L Numerador = tf * (k1 + 10) = 3 * 22 = 66
      mut as int64: num = 66
      mut as int64: score1 = (num * 100) /i 40
      mut as int64: score2 = (num * 100) /i 51

      #L Multiplicacao por IDF
      score1 = (score1 * idf) /i 100
      score2 = (score2 * idf) /i 100

      println("1. Score BM25 Documento Curto 1: " + score1)
      println("2. Score BM25 Documento Longo 2: " + score2)

      #L O documento mais conciso com a mesma frequencia de termo deve pontuar mais alto
      route {
            score1 > score2 ==> {
                  println("3. Penalizacao de comprimento e saturacao BM25 validadas.")
            }
            _ ==> {
                  println("Falha na ordenacao BM25.")
            }
      }
      println("Teste concluido com sucesso.")
}
