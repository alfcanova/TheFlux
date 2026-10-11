#L ============================================================================
#L Algoritmo: FM-Index com Burrows-Wheeler Transform e Tabela Occ (BWA)
#L Dominio: 10_bio_quantum / Categoria: Genomica e Alinhamento
#L Descricao: Busca retrograda ultra-rapida de k-mers em genomas de referencia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaFMIndexBWA) {
      println("=== Algoritmo: FM-Index (Burrows-Wheeler Aligner) ===")

      #L Genoma de referencia T = "GACGAT$" (comprimento 7 com terminador $)
      #L Tabela BWT correspondente: L = "TT$GACA" (ou permutacao dos caracteres finais)
      #L Alfabeto ordenado: $, A, C, G, T
      #L Frequencias no genoma:
      #L '$': 1
      #L 'A': 2
      #L 'C': 1
      #L 'G': 2
      #L 'T': 1

      #L Vetor C (posicao acumulada inicial no BWT da primeira ocorrencia de cada char):
      #L C['$'] = 0
      #L C['A'] = 1
      #L C['C'] = 1 + 2 = 3
      #L C['G'] = 3 + 1 = 4
      #L C['T'] = 4 + 2 = 6

      mut as int64: c_dollar = 0
      mut as int64: c_a = 1
      mut as int64: c_c = 3
      mut as int64: c_g = 4
      mut as int64: c_t = 6

      println("Tabela de saltos C inicializada:")
      println("C['A'] = " + c_a + ", C['C'] = " + c_c + ", C['G'] = " + c_g + ", C['T'] = " + c_t)

      #L Busca retrograda (Backward Search) pelo padrao P = "GA" (comprimento m = 2)
      #L Passo 1: Caractere final P[2] = 'A'
      #L Intervalo inicial no BWT:
      #L sp_1 = C['A'] + 1 = 1 + 1 = 2
      #L ep_1 = C['C'] = 3
      #L Intervalo contem 2 linhas ([2, 3])
      mut as int64: sp = c_a + 1
      mut as int64: ep = c_c

      println("Passo 1 (Backward Search 'A'): intervalo BWT [" + sp + ", " + ep + "]")

      #L Passo 2: Proximo caractere a esquerda P[1] = 'G'
      #L Usando contagem de ocorrencias Occ('G', sp - 1) e Occ('G', ep):
      #L No intervalo BWT avaliado:
      #L Occ('G', sp - 1) = 0
      #L Occ('G', ep) = 1
      #L Novo intervalo:
      #L sp_2 = C['G'] + Occ('G', sp - 1) + 1 = 4 + 0 + 1 = 5
      #L ep_2 = C['G'] + Occ('G', ep) = 4 + 1 = 5
      mut as int64: occ_before = 0
      mut as int64: occ_until = 1

      mut as int64: new_sp = c_g + occ_before + 1
      mut as int64: new_ep = c_g + occ_until

      println("Passo 2 (Backward Search 'G'): intervalo BWT [" + new_sp + ", " + new_ep + "]")

      #L Numero de ocorrencias exatas do padrao no genoma:
      #L count = ep - sp + 1
      mut as int64: match_count = new_ep - new_sp + 1
      println("Ocorrencias encontradas do padrao 'GA': " + match_count)

      route {
            match_count > 0 ==> {
                  println("Mapeamento genomico BWA resolvido em tempo O(m)")
            }
            match_count <= 0 ==> {
                  println("Padrao nao localizado no genoma de referencia")
            }
      }

      println("FM-Index BWA concluido com sucesso.")
}
