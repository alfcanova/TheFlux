#L ============================================================================
#L Algoritmo: Boyer-Moore DNA K-mer Alignment
#L Dominio: 10_bio_quantum / Categoria: Genomica e Strings Biologicas
#L Descricao: Alinhamento exato de k-mers de DNA com saltos de caractere ruim
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaBoyerMooreDNAAlignment) {
      println("=== Algoritmo: Boyer-Moore DNA K-mer Alignment ===")

      #L Padrao K-mer a alinhar P = "GCAG" (comprimento m = 4)
      #L Alfabeto: DNA {A, C, G, T}
      #L Tabela de Caractere Ruim (ultima posicao em P de cada nucleotideo, 0-indexado):
      #L 'A': posicao 2
      #L 'C': posicao 1
      #L 'G': posicao 3 (final)
      #L 'T': nao ocorre -> -1
      mut as int64: m = 4
      println("Tamanho do k-mer a alinhar (m): " + m)

      #L Fita de DNA T = "ACAGCAGT" (comprimento n = 8)
      #L Alinhamento inicial no indice shift = 0:
      #L Comparacao da direita para a esquerda:
      #L P[3] ('G') compara com T[0 + 3] = T[3] ('G') -> Match
      #L P[2] ('A') compara com T[0 + 2] = T[2] ('A') -> Match
      #L P[1] ('C') compara com T[0 + 1] = T[1] ('C') -> Match
      #L P[0] ('G') compara com T[0 + 0] = T[0] ('A') -> Mismatch!
      #L Caractere ruim em T eh 'A'.
      #L Ultima ocorrencia de 'A' em P eh na posicao 2.
      #L Salto calculado: max(1, 0 - 2) = 1

      mut as int64: shift_1 = 1
      println("Shift 1 apos mismatch em 'A': avanco de " + shift_1 + " posicao")

      #L Segundo alinhamento em shift = 1:
      #L Comparacao da direita para a esquerda:
      #L P[3] ('G') compara com T[1 + 3] = T[4] ('C') -> Mismatch imediato!
      #L Caractere ruim em T eh 'C'.
      #L Ultima ocorrencia de 'C' em P eh na posicao 1.
      #L Salto calculado: max(1, 3 - 1) = 2 posicoes!
      mut as int64: shift_2 = 2
      println("Shift 2 apos mismatch em 'C': salto rapido de " + shift_2 + " posicoes")

      #L Terceiro alinhamento em shift = 1 + 2 = 3:
      #L Comparacao da direita para a esquerda:
      #L P[3] ('G') compara com T[3 + 3] = T[6] ('G') -> Match
      #L P[2] ('A') compara com T[3 + 2] = T[5] ('A') -> Match
      #L P[1] ('C') compara com T[3 + 1] = T[4] ('C') -> Match
      #L P[0] ('G') compara com T[3 + 0] = T[3] ('G') -> Match!
      #L Todos os caracteres casaram perfeitamente!
      mut as int64: match_pos = 3
      println("Alinhamento exato localizado na fita de DNA na coordenada: " + match_pos)

      route {
            match_pos == 3 ==> {
                  println("K-mer alinhado com sucesso saltando comparacoes redundantes")
            }
            _ ==> {
                  println("K-mer nao encontrado")
            }
      }

      println("Boyer-Moore DNA K-mer Alignment concluido com sucesso.")
}
