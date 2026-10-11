#L ============================================================================
#L Algoritmo: Transform and Conquer (Transformacao e Conquista)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N log N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasTransformAndConquer) {
      println("==================================================")
      println("  SciAlgo: Transform and Conquer (Transformacao)")
      println("==================================================")

      #L Caso 1: Unicidade e Duplicatas via Pre-ordenacao (Presorting Transform)
      mut as list of int64: raw_data = [64, 34, 25, 12, 22, 11, 90, 22, 12]
      mut as int64: n = listLength(raw_data)
      println("1. Vetor bruto de entrada: " + raw_data)

      #L Transformacao: Ordenacao in-place (Insertion sort simples deterministico)
      mut as list of int64: sorted_data = raw_data
      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: key = sorted_data[i]
            mut as int64: j = i - 1
            mut as bool: inserting = true
            infinite (inserting) {
                  route {
                        j >= 1 ==> {
                              route {
                                    sorted_data[j] > key ==> {
                                          sorted_data[j + 1] = sorted_data[j]
                                          j = j - 1
                                    }
                                    _ ==> {
                                          inserting = false
                                    }
                              }
                        }
                        _ ==> {
                              inserting = false
                        }
                  }
            }
            sorted_data[j + 1] = key
            i = i + 1
      }
      println("2. Espaco transformado (Pre-ordenado): " + sorted_data)

      #L Conquista: Varredura linear O(N) de adjacentes para duplicatas
      mut as list of int64: duplicates = []
      mut as int64: c = 1
      infinite (c < n) {
            route {
                  sorted_data[c] == sorted_data[c + 1] ==> {
                        duplicates = listPushBack(duplicates, sorted_data[c])
                  }
                  _ ==> {
                  }
            }
            c = c + 1
      }
      println("3. Elementos duplicados identificados em O(N): " + duplicates)

      #L Caso 2: Avaliacao de Polinomio via Transformacao de Horner
      #L P(x) = 2*x^3 - 6*x^2 + 2*x - 1 para x = 3
      #L Coeficientes da maior potencia para a menor: [2, -6, 2, -1]
      mut as list of int64: coeffs = [2, -6, 2, -1]
      mut as int64: x = 3
      println("4. Polinomio avaliado em x = " + x)

      mut as int64: horner_val = coeffs[1]
      mut as int64: k = 2
      mut as int64: deg = listLength(coeffs)
      infinite (k <= deg) {
            horner_val = (horner_val * x) + coeffs[k]
            k = k + 1
      }
      println("5. Valor de P(3) pelo metodo de Horner: " + horner_val)
      println("Concluido com Sucesso")
}
