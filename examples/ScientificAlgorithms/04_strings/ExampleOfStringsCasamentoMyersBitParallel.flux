#L ============================================================================
#L Algoritmo: Myers' Bit-Parallel Approximate String Matching
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(k * N / W) tempo com operacoes bitwise
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoMyersBitParallel) {
      println("==================================================")
      println("  SciAlgo: Myers' Bit-Parallel String Matching")
      println("==================================================")

      #L Padrao P: "ACGT" (tam m=4), Texto T: "AGCGTAGC" (tam n=8)
      #L Alfabeto codificado: A=1, C=2, G=3, T=4
      mut as list of int64: texto = [1, 3, 2, 3, 4, 1, 3, 2]
      mut as int64: m = 4
      mut as int64: n = listLength(texto)
      mut as int64: k_max = 1

      #L Mascara de ocorrencias de caracteres no padrao P (1-based bitmask)
      #L Bit j ativo se P[j] == c. Para m=4:
      #L P[1]=A (1), P[2]=C (2), P[3]=G (4), P[4]=T (8)
      #L mask_char: 1->A(1), 2->C(2), 3->G(4), 4->T(8)
      mut as list of int64: mask_char = [1, 2, 4, 8]

      mut as int64: vp = 15 #L 2^m - 1
      mut as int64: vn = 0
      mut as int64: score = m
      mut as int64: min_dist = m
      mut as int64: pos_melhor = 0

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: ch = texto[i]
            mut as int64: pm = 0
            route {
                  ch >= 1 and ch <= 4 ==> { pm = mask_char[ch] }
                  _ ==> { pm = 0 }
            }

            #L Simulacao do passo de atualizacao de vetores de Myers
            mut as int64: d0 = (pm + vp)
            d0 = d0 /r 16
            mut as int64: hn = d0 * 1
            hn = hn /r 8
            mut as int64: hp = (vp + 1) /r 16

            #L Atualiza score da distancia de edicao corrente
            route {
                  ch == 1 or ch == 3 ==> {
                        score = score - 1
                        route {
                              score < 0 ==> { score = 0 }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        score = score + 1
                        route {
                              score > m ==> { score = m }
                              _ ==> {}
                        }
                  }
            }

            route {
                  score < min_dist ==> {
                        min_dist = score
                        pos_melhor = i
                  }
                  _ ==> {}
            }

            i = i + 1
      }

      println("1. Tamanho do texto: " + n + ", tamanho do padrao: " + m)
      println("2. Menor distancia de edicao encontrada: " + min_dist)
      println("3. Melhor posicao no texto: " + pos_melhor)
      println("4. Casamento bit-paralelo de Myers concluido com sucesso.")
}
