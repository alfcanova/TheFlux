#L ============================================================================
#L Algoritmo: Ukkonen's Cutoff Dynamic Programming for Approximate Matching
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(k * N) tempo com poda de celulas irrelevantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoUkkonenCutoff) {
      println("==================================================")
      println("  SciAlgo: Ukkonen's Cutoff DP Matching")
      println("==================================================")

      #L S1: "PETER" (tam 5), S2: "PIETER" (tam 6)
      #L Codificacao ASCII: P=80, E=69, T=84, R=82, I=73
      mut as list of int64: s1 = [80, 69, 84, 69, 82]
      mut as list of int64: s2 = [80, 73, 69, 84, 69, 82]
      mut as int64: m = listLength(s1)
      mut as int64: n = listLength(s2)
      mut as int64: k_threshold = 2

      #L Linha DP com poda (tam m+1 = 6)
      mut as list of int64: dp_col = [0, 1, 2, 3, 4, 5]
      mut as list of int64: prox_col = [0, 0, 0, 0, 0, 0]

      mut as int64: limite_linha = k_threshold + 1
      route {
            limite_linha > m ==> { limite_linha = m }
            _ ==> {}
      }

      mut as int64: j = 1
      infinite (j <= n) {
            prox_col[1] = 0 #L Sem penalidade de prefixo livre para busca semi-global
            mut as int64: ch2 = s2[j]

            mut as int64: i = 1
            infinite (i <= limite_linha) {
                  mut as int64: ch1 = s1[i]
                  mut as int64: custo_sub = 1
                  route {
                        ch1 == ch2 ==> { custo_sub = 0 }
                        _ ==> {}
                  }

                  mut as int64: diag = dp_col[i] + custo_sub
                  mut as int64: insercao = prox_col[i] + 1
                  mut as int64: remocao = dp_col[i + 1] + 1

                  mut as int64: menor = diag
                  route {
                        insercao < menor ==> { menor = insercao }
                        _ ==> {}
                  }
                  route {
                        remocao < menor ==> { menor = remocao }
                        _ ==> {}
                  }

                  prox_col[i + 1] = menor
                  i = i + 1
            }

            #L Atualiza limite da proxima coluna com a regra de Ukkonen
            route {
                  limite_linha < m ==> { limite_linha = limite_linha + 1 }
                  _ ==> {}
            }

            #L Copia prox_col para dp_col
            mut as int64: c = 1
            infinite (c <= m + 1) {
                  dp_col[c] = prox_col[c]
                  c = c + 1
            }

            j = j + 1
      }

      mut as int64: dist_final = dp_col[m + 1]
      println("1. Tamanho do padrao: " + m + ", tamanho do texto: " + n)
      println("2. Limiar de erro k: " + k_threshold)
      println("3. Distancia com corte diagonal calculada: " + dist_final)
      println("4. Algoritmo de Ukkonen concluido com sucesso.")
}
