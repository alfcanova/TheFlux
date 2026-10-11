#L ============================================================================
#L Algoritmo: Naive String Matching (Busca Exaustiva de Subcadeias)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O((N - M + 1) * M) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoNaiveMatching) {
      println("==================================================")
      println("  SciAlgo: Naive String Matching")
      println("==================================================")

      mut as list of int64: texto = [65, 66, 65, 66, 67, 65, 66]
      mut as list of int64: padrao = [65, 66, 67]
      mut as int64: n = listLength(texto)
      mut as int64: m = listLength(padrao)

      mut as int64: pos_encontrada = 0
      mut as int64: i = 1
      infinite (i <= n - m + 1) {
            mut as int64: igual = 1
            mut as int64: j = 1
            infinite (j <= m) {
                  route {
                        texto[i + j - 1] != padrao[j] ==> { igual = 0 }
                        _ ==> {}
                  }
                  j = j + 1
            }
            route {
                  igual == 1 ==> {
                        pos_encontrada = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Tamanho do texto: " + n + ", padrao: " + m)
      println("2. Ocorrencia encontrada no indice: " + pos_encontrada)
      println("3. Naive String Matching concluido com sucesso.")
}
