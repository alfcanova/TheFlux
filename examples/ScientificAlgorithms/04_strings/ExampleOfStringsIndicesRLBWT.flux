#L ============================================================================
#L Algoritmo: Run-Length Burrows-Wheeler Transform (RLBWT) Index
#L Dominio: 04_strings / Subdominio: indices
#L Complexidade: O(r) espaco onde r eh o numero de runs do BWT
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsIndicesRLBWT) {
      println("==================================================")
      println("  SciAlgo: Run-Length BWT (r-index Foundation)")
      println("==================================================")

      #L BWT original descompactado: "AAABBBCCCCDDA" (tam 13)
      #L Decomposicao em runs (caractere, comprimento):
      #L Codificacao: A=1, B=2, C=3, D=4
      mut as list of int64: run_char = [1, 2, 3, 4, 1]
      mut as list of int64: run_len  = [3, 3, 4, 2, 1]
      mut as int64: r = listLength(run_char) #L r = 5 runs

      #L Vetor de prefixos acumulados de posicoes dos runs (amostragem para r-index)
      mut as list of int64: run_offset = [0, 0, 0, 0, 0]
      mut as int64: acum = 0
      mut as int64: i = 1
      infinite (i <= r) {
            run_offset[i] = acum
            acum = acum + run_len[i]
            i = i + 1
      }

      #L LF-Mapping com contagem de frequencia acumulada por caractere C[c]
      #L Frequencias totais: A:4, B:3, C:4, D:2
      #L C[1]=0, C[2]=4, C[3]=7, C[4]=11
      mut as list of int64: c_table = [0, 4, 7, 11]

      #L Consulta de proxima posicao LF para o 2o elemento do run 3 (caractere C=3)
      mut as int64: char_alvo = run_char[3]
      mut as int64: offset_base = c_table[char_alvo]
      mut as int64: rank_no_run = 2
      mut as int64: lf_pos = offset_base + rank_no_run

      println("1. Tamanho do texto descomprimido: " + acum)
      println("2. Quantidade de runs r: " + r)
      println("3. Fator de compressao de espaco (n / r): " + (acum /i r))
      println("4. Mapeamento LF-Step na amostragem de run: posicao " + lf_pos)
      println("5. RLBWT concluido com sucesso.")
}
