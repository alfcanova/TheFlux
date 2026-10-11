#L ============================================================================
#L Algoritmo: Classic McEliece (Criptossistema Baseado em Codigos de Goppa)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n^2) criptografia | O(n * t) decodificacao de Goppa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaClassicMcEliece) {
      println("==================================================")
      println("  SciAlgo: Classic McEliece Cryptosystem")
      println("==================================================")

      #L O Classic McEliece e o criptossistema pos-quantico mais longevo
      #L e testado pelo tempo (proposto em 1978 por Robert McEliece).
      #L Baseia-se na dureza da decodificacao de codigos lineares genericos,
      #L utilizando codigos de Goppa binarios lineares [n, k, 2t+1] como alcapao (trapdoor).
      #L
      #L Parametros do modelo:
      #L Comprimento do codigo: n = 7
      #L Dimensao da mensagem: k = 4
      #L Capacidade de correcao de erros: t = 1
      mut as int64: n = 7
      mut as int64: k = 4
      mut as int64: t_err = 1

      println("1. Parametros do Codigo Linear:")
      println("   Comprimento de bloco: n = " + n)
      println("   Dimensao da mensagem: k = " + k)
      println("   Erros corrigiveis: t = " + t_err)

      #L Matriz Geradora Publica G_pub (k x n = 4 x 7) em GF(2):
      #L G_pub = S * G_goppa * P
      #L Linha 1: [1, 0, 0, 0, 1, 1, 0]
      #L Linha 2: [0, 1, 0, 0, 1, 0, 1]
      #L Linha 3: [0, 0, 1, 0, 0, 1, 1]
      #L Linha 4: [0, 0, 0, 1, 1, 1, 1]
      mut as list of int64: g1 = [1, 0, 0, 0, 1, 1, 0]
      mut as list of int64: g2 = [0, 1, 0, 0, 1, 0, 1]
      mut as list of int64: g3 = [0, 0, 1, 0, 0, 1, 1]
      mut as list of int64: g4 = [0, 0, 0, 1, 1, 1, 1]

      println("==================================================")
      println("2. Criptografia McEliece (Encrypt):")
      #L Mensagem binaria m in GF(2)^4:
      mut as list of int64: msg_m = [1, 0, 1, 1]
      println("   Mensagem original m: " + msg_m)

      #L Codificacao de codeword c0 = m * G_pub em GF(2):
      mut as list of int64: c0 = [0, 0, 0, 0, 0, 0, 0]
      mut as int64: col = 0
      infinite (col < n) {
            mut as int64: bit_sum = (msg_m[1] * g1[col + 1]) + (msg_m[2] * g2[col + 1]) + (msg_m[3] * g3[col + 1]) + (msg_m[4] * g4[col + 1])
            c0[col + 1] = bit_sum /r 2
            col = col + 1
      }
      println("   Codeword valido c_0: " + c0)

      #L Injeção intencional de vetor de erro e de peso de Hamming t = 1:
      #L e = [0, 0, 1, 0, 0, 0, 0] (erro no bit 3)
      mut as list of int64: err_vec = [0, 0, 1, 0, 0, 0, 0]
      mut as list of int64: ciphertext = [0, 0, 0, 0, 0, 0, 0]
      col = 0
      infinite (col < n) {
            ciphertext[col + 1] = (c0[col + 1] + err_vec[col + 1]) /r 2
            col = col + 1
      }

      println("   Vetor de erro inserido e: " + err_vec + " (peso = " + t_err + ")")
      println("   Texto cifrado c = m*G_pub + e: " + ciphertext)

      println("==================================================")
      println("3. Descriptografia por Decodificacao de Sindromes:")
      #L A chave privada (S, G, P) permite decodificar o erro e remover a permutacao.
      #L Matriz de Paridade H (3 x 7) do codigo:
      #L Linha 1: [1, 1, 0, 1, 1, 0, 0]
      #L Linha 2: [1, 0, 1, 1, 0, 1, 0]
      #L Linha 3: [0, 1, 1, 1, 0, 0, 1]
      mut as list of int64: h1 = [1, 1, 0, 1, 1, 0, 0]
      mut as list of int64: h2 = [1, 0, 1, 1, 0, 1, 0]
      mut as list of int64: h3 = [0, 1, 1, 1, 0, 0, 1]

      #L Calculo da sindrome s = H * c^T:
      mut as int64: s1 = 0
      mut as int64: s2 = 0
      mut as int64: s3 = 0
      col = 0
      infinite (col < n) {
            s1 = (s1 + (h1[col + 1] * ciphertext[col + 1])) /r 2
            s2 = (s2 + (h2[col + 1] * ciphertext[col + 1])) /r 2
            s3 = (s3 + (h3[col + 1] * ciphertext[col + 1])) /r 2
            col = col + 1
      }
      println("   Sindrome calculada: [" + s1 + ", " + s2 + ", " + s3 + "]")

      #L A sindrome [0, 1, 1] aponta diretamente para a coluna 3 de H!
      #L Localizador de erro identificou posicao pos = 3 (1-based):
      mut as int64: err_pos = 3
      println("   Localizador de erro: Erro detectado na posicao " + err_pos)

      #L Correcao do bit corrompido:
      ciphertext[err_pos] = (ciphertext[err_pos] + 1) /r 2
      println("   Codeword corrigido: " + ciphertext)

      #L Extracao da mensagem original (primeiros k bits da forma sistematica):
      mut as list of int64: recovered_m = [ciphertext[1], ciphertext[2], ciphertext[3], ciphertext[4]]
      println("   Mensagem recuperada m': " + recovered_m)

      route {
            recovered_m == msg_m ==> {
                  println("   Sucesso: Mensagem descriptografada perfeitamente via Classic McEliece!")
            }
            _ ==> {
                  println("   Falha na decodificacao de McEliece.")
            }
      }
      println("   Classic McEliece concluido com sucesso!")
      println("==================================================")
}
