#L ============================================================================
#L Algoritmo: FastPFOR Integer Codec (Patched Frame-of-Reference)
#L Dominio: 04_strings / Subdominio: codecs
#L Complexidade: O(N) tempo linear com descompactacao vetorizada de blocos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsFastPFOR) {
      println("==================================================")
      println("  SciAlgo: FastPFOR Integer Compression Codec")
      println("==================================================")

      #L Bloco de 8 inteiros para indice invertido textual (d-gaps):
      #L [3, 5, 2, 6, 250, 4, 1, 310] (dois outliers que excedem 3 bits)
      mut as list of int64: bloco = [3, 5, 2, 6, 250, 4, 1, 310]
      mut as int64: n = listLength(bloco)

      mut as int64: b_bits = 3 #L Largura em bits comum para os dados normais (< 8)
      mut as int64: num_excecoes = 0
      mut as list of int64: pos_excecoes = [0, 0]
      mut as list of int64: val_excecoes = [0, 0]

      mut as int64: max_regular = 7 #L 2^3 - 1

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: v = bloco[i]
            route {
                  v > max_regular ==> {
                        num_excecoes = num_excecoes + 1
                        pos_excecoes[num_excecoes] = i
                        val_excecoes[num_excecoes] = v
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      #L Calculo de bits consumidos: n * b_bits + excecoes (32 bits cada)
      mut as int64: bits_total = (n * b_bits) + (num_excecoes * 32)
      mut as int64: bits_originais = n * 32
      mut as int64: reducao_pct = ((bits_originais - bits_total) * 100) /i bits_originais

      println("1. Tamanho do bloco de inteiros: " + n)
      println("2. Largura de bits regular b: " + b_bits + " bits")
      println("3. Excecoes detectadas para patching: " + num_excecoes)
      println("4. Bits consumidos: " + bits_total + " vs " + bits_originais + " originais (" + reducao_pct + "% de economia)")
      println("5. FastPFOR concluido com sucesso.")
}
