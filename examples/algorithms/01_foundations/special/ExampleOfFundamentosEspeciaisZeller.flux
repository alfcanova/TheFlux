#L ============================================================================
#L Algoritmo: Zeller's Congruence (Congruencia de Zeller)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(1) tempo analitico | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisZeller) {
      println("==================================================")
      println("  SciAlgo: Zeller's Congruence")
      println("==================================================")

      #L Data: 04 de Outubro de 2026
      mut as int64: q = 4
      mut as int64: m = 10
      mut as int64: year = 2026

      println("1. Data de entrada: " + q + "/" + m + "/" + year)

      #L Ajuste de Zeller: Janeiro (1) e Fevereiro (2) contam como meses 13 e 14 do ano anterior
      mut as int64: adj_m = m
      mut as int64: adj_year = year
      route {
            m < 3 ==> {
                  adj_m = m + 12
                  adj_year = year - 1
            }
      }

      mut as int64: k = adj_year /r 100
      mut as int64: j = adj_year /i 100

      #L Formula de Zeller: h = (q + [13*(m+1)/5] + K + [K/4] + [J/4] - 2*J) % 7
      mut as int64: term_m = (13 * (adj_m + 1)) /i 5
      mut as int64: term_k = k /i 4
      mut as int64: term_j = j /i 4

      mut as int64: raw_h = (q + term_m + k + term_k + term_j - 2 * j) /r 7
      route {
            raw_h < 0 ==> {
                  raw_h = raw_h + 7
            }
      }

      #L Na congruencia de Zeller: 0 = Sabado, 1 = Domingo, 2 = Segunda, ..., 6 = Sexta
      println("2. Termos: [13*(m+1)/5]=" + term_m + ", K=" + k + ", J=" + j)
      println("3. Indice de Zeller h (1 = Domingo): " + raw_h)
      println("4. Validacao: " + (raw_h == 1))
      println("==================================================")
}
