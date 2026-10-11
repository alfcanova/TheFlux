#L ============================================================================
#L Algoritmo: Crochemore's Maximal Suffix & Periodicity
#L Dominio: 04_strings / Subdominio: parsing
#L Complexidade: O(N) tempo e O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsParsingCrochemoreMaximalSuffix) {
      println("==================================================")
      println("  SciAlgo: Crochemore's Maximal Suffix Factorization")
      println("==================================================")

      #L String modelo T: "ABRACADABRA" (tam 11)
      #L Codificacao: A=65, B=66, C=67, D=68, R=82
      mut as list of int64: texto = [65, 66, 82, 65, 67, 65, 68, 65, 66, 82, 65]
      mut as int64: n = listLength(texto)

      #L Algoritmo de Duval / Crochemore para sufixo maximal
      mut as int64: i = 1
      mut as int64: j = 2
      mut as int64: k = 0

      infinite (j + k <= n) {
            mut as int64: c1 = texto[i + k]
            mut as int64: c2 = texto[j + k]

            route {
                  c1 == c2 ==> {
                        k = k + 1
                  }
                  c1 < c2 ==> {
                        #L Avanca ponteiro i para a nova posicao
                        i = i + k + 1
                        route {
                              i >= j ==> { j = i + 1 }
                              _ ==> {}
                        }
                        k = 0
                  }
                  _ ==> {
                        #L Caractere c1 > c2: avanca j
                        j = j + k + 1
                        k = 0
                  }
            }
      }

      mut as int64: sufixo_maximal_pos = i
      #L Calculo do periodo local da repeticao
      mut as int64: periodo_critico = j - i

      println("1. Tamanho do texto: " + n)
      println("2. Indice de inicio do sufixo maximal: " + sufixo_maximal_pos)
      println("3. Periodo critico estimado: " + periodo_critico)
      println("4. Fatoracao de Crochemore concluida com sucesso.")
}
