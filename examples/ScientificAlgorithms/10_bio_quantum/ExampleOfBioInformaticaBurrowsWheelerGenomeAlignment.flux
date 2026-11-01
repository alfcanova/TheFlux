#L ============================================================================
#L Algoritmo: Burrows-Wheeler Genome Alignment (BWA / FM-Index Read Alignment)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(m) tempo de busca para padrao de tamanho m | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaBurrowsWheelerGenomeAlignment) {
      println("==================================================")
      println("  SciAlgo: Burrows-Wheeler Genome Alignment (BWA)")
      println("==================================================")

      #L Mapeamento de Simbolos: 0='$' (Sentinela menor que todos), 1='A', 2='C', 3='G', 4='T'
      #L Genoma de Referencia: "ACAACGT$" (Comprimento n = 8)
      #L T = [1, 2, 1, 1, 2, 3, 4, 0]
      mut as int64: n = 8

      #L Suffix Array (SA) ordenado lexicograficamente:
      #L S1: $          -> pos 8
      #L S2: AACGT$     -> pos 3
      #L S3: ACAACGT$   -> pos 1
      #L S4: ACGT$      -> pos 4
      #L S5: CAACGT$    -> pos 2
      #L S6: CGT$       -> pos 5
      #L S7: GT$        -> pos 6
      #L S8: T$         -> pos 7
      mut as list of int64: sa = [8, 3, 1, 4, 2, 5, 6, 7]

      #L Vetor BWT L[i] = T[SA[i] - 1] (com wrap-around para pos 8 se SA[i]=1)
      #L SA[1]=8 -> T[7] = 4 ('T')
      #L SA[2]=3 -> T[2] = 2 ('C')
      #L SA[3]=1 -> T[8] = 0 ('$')
      #L SA[4]=4 -> T[3] = 1 ('A')
      #L SA[5]=2 -> T[1] = 1 ('A')
      #L SA[6]=5 -> T[4] = 1 ('A')
      #L SA[7]=6 -> T[5] = 2 ('C')
      #L SA[8]=7 -> T[6] = 3 ('G')
      mut as list of int64: bwt = [4, 2, 0, 1, 1, 1, 2, 3]

      println("1. Indice BWT / FM-Index do Genoma de Referencia:")
      println("   Genoma T: A C A A C G T $ (Tamanho n=" + n + ")")
      println("   Suffix Array SA: " + sa)
      println("   Transformada BWT L: " + bwt)

      #L Tabela C[c]: contagem acumulada de caracteres estritamente menores que c
      #L Simbolos 0..4:
      #L count(0)=$: 1
      #L count(1)=A: 3
      #L count(2)=C: 2
      #L count(3)=G: 1
      #L count(4)=T: 1
      #L C[0]=0, C[1]=1, C[2]=1+3=4, C[3]=4+2=6, C[4]=6+1=7
      mut as list of int64: c_table = [0, 1, 4, 6, 7]

      println("==================================================")
      println("2. Tabela de Contagem Acumulada C (Offsets dos Caracteres):")
      println("   C['$'] = 0 | C['A'] = 1 | C['C'] = 4 | C['G'] = 6 | C['T'] = 7")

      #L Read / Padrao a ser alinhado: "AAC" -> [1, 1, 2] (tam m=3)
      mut as list of int64: pattern = [1, 1, 2] #L 'A', 'A', 'C'
      mut as int64: m_len = 3

      println("==================================================")
      println("3. Busca Reversa por LF-Mapping (Backward Search):")
      println("   Alinhando Padrao (Read): A A C (m=" + m_len + ")")

      mut as int64: sp = 1
      mut as int64: ep = n
      mut as int64: step = m_len
      mut as bool: match_found = true

      infinite (step >= 1 and match_found) {
            mut as int64: char_sym = pattern[step]

            #L Calcula Occ(char_sym, sp - 1) e Occ(char_sym, ep) na BWT
            mut as int64: occ_sp = 0
            mut as int64: occ_ep = 0

            mut as int64: k = 1
            infinite (k <= ep) {
                  route {
                        bwt[k] == char_sym ==> {
                              route {
                                    k < sp ==> { occ_sp = occ_sp + 1 }
                                    _ ==> {}
                              }
                              occ_ep = occ_ep + 1
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            #L Atualiza intervalo FM-index
            #L sp = C[char_sym] + Occ(char_sym, sp - 1) + 1
            #L ep = C[char_sym] + Occ(char_sym, ep)
            #L c_table tem indice 1-based: char_sym in 0..4 -> indice = char_sym + 1
            mut as int64: c_offset = c_table[char_sym + 1]
            sp = c_offset + occ_sp + 1
            ep = c_offset + occ_ep

            println("   Passo " + (m_len - step + 1) + " (Simbolo " + char_sym + "): Intervalo SA [" + sp + " .. " + ep + "]")

            route {
                  sp > ep ==> {
                        match_found = false
                        println("      Padrao nao encontrado na referencia!")
                  }
                  _ ==> {}
            }
            step = step - 1
      }

      println("==================================================")
      println("4. Localizacao das Ocorrencias no Genoma:")

      route {
            match_found ==> {
                  mut as int64: total_hits = ep - sp + 1
                  println("   Total de Ocorrencias Exatas Encontradas: " + total_hits)

                  mut as int64: h = sp
                  infinite (h <= ep) {
                        mut as int64: genome_pos = sa[h]
                        println("   => Read alinhado no Genoma na Posicao: " + genome_pos)
                        h = h + 1
                  }
            }
            _ ==> {
                  println("   Nenhuma ocorrencia encontrada.")
            }
      }

      println("   Burrows-Wheeler Genome Alignment concluido com sucesso!")
      println("==================================================")
}
