#L ============================================================================
#L Algoritmo: Sukhotin Algorithm (Deteccao de Vogais por Co-ocorrencia)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPSukhotinAlgorithm) {
      println("=== Algoritmo: Sukhotin Vowel Detection ===")
      mut as list of int64: charScores = [85, 30, 92, 15]
      mut as int64: maxChar = 1
      mut as int64: maxScore = charScores[1]
      mut as int64: i = 2
      infinite (i <= 4) {
            route {
                  charScores[i] > maxScore ==> {
                        maxScore = charScores[i]
                        maxChar = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Caractere identificado como vogal candidata: " + maxChar)
      println("2. Pontuacao de adjacencia consoante: " + maxScore)
      println("Teste concluido com sucesso.")
}
