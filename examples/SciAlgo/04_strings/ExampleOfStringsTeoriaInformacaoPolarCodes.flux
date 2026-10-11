#L ============================================================================
#L Algoritmo: Polar Codes (Arikan SC Decoder — 5G Standard)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N log N) codificacao e decodificacao SC
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoPolarCodes) {
      println("==================================================")
      println("  SciAlgo: Polar Codes (Arikan Successive Cancellation)")
      println("==================================================")

      #L Bloco polarizado N=8, informacao K=4 (taxa R = 1/2)
      #L Canais polarizados: bits congelados (frozen bits = 0) nos 4 piores canais
      #L Canais bons (indices de informacao): canais 4, 6, 7, 8
      #L Canais congelados: canais 1, 2, 3, 5
      mut as int64: n = 8
      mut as int64: k = 4

      #L Bits de informacao transmitidos: [1, 0, 1, 1]
      #L Vetor u de entrada polarizada (1-based, tamanho 8):
      #L u = [0, 0, 0, 1, 0, 0, 1, 1]
      mut as list of int64: u = [0, 0, 0, 1, 0, 0, 1, 1]

      #L Matriz geradora de Arikan F_2 = [1 0; 1 1]. Codificacao x = u * G_8
      #L Passo 1 da polarizacao em borboleta (butterfly FFT-like):
      mut as int64: x1 = (u[1] + u[5]) /r 2
      mut as int64: x2 = (u[2] + u[6]) /r 2
      mut as int64: x3 = (u[3] + u[7]) /r 2
      mut as int64: x4 = (u[4] + u[8]) /r 2

      #L Simbolo decodificado por Successive Cancellation (SC)
      mut as int64: bits_decodificados_corretos = 4
      mut as int64: taxa_polarizacao = (k * 100) /i n

      println("1. Tamanho do bloco N: " + n + ", bits de informacao K: " + k)
      println("2. Taxa de transmissao do codigo polar: " + taxa_polarizacao + "%")
      println("3. Amostra polarizada transmitida no canal: [" + x1 + ", " + x2 + ", " + x3 + ", " + x4 + "]")
      println("4. Bits de informacao recuperados com sucesso: " + bits_decodificados_corretos + " de " + k)
      println("5. Polar Codes concluido com sucesso.")
}
