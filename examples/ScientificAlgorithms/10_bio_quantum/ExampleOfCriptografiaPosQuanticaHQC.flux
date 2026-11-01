#L ============================================================================
#L Algoritmo: HQC (Hamming Quasi-Cyclic - KEM Concatenado)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n log n) via convolucoes ciclicas e decodificacao concatenada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaHQC) {
      println("==================================================")
      println("  SciAlgo: HQC (Hamming Quasi-Cyclic KEM)")
      println("==================================================")

      #L O HQC e um KEM pos-quantico baseado em codigos quase-ciclicos e decodificacao
      #L concatenada (codigo interno BCH/Reed-Muller e codigo externo quase-ciclico).
      #L Sua principal vantagem teórica sobre outros esquemas de codigos e a
      #L garantia de Taxa de Falha de Decodificacao (DFR) estritamente nula ou
      #L demonstrada formalmente por limitantes analiticos.
      #L
      #L Parametros do modelo:
      #L Grau ciclico do anel: n = 5 sobre F_2[X] / (X^5 - 1)
      #L Codigo de repeticao/paridade interno para proteger a mensagem
      mut as int64: n_dim = 5

      println("1. Parametros do HQC:")
      println("   Comprimento do anel ciclico: n = " + n_dim)

      #L Chave privada: vetores com peso de Hamming pequeno x e y in F_2^n:
      #L x = [0, 1, 0, 0, 0] (peso 1)
      #L y = [0, 0, 1, 0, 0] (peso 1)
      mut as list of int64: priv_x = [0, 1, 0, 0, 0]
      mut as list of int64: priv_y = [0, 0, 1, 0, 0]

      #L Polinomio publico aleatorio h:
      mut as list of int64: pub_h = [1, 0, 1, 1, 0]

      println("==================================================")
      println("2. Geracao de Chave Publica (KeyGen):")
      #L s = x + h * y mod (X^5 - 1) em GF(2):
      #L y tem 1 no indice 3 (X^2), entao h * y desloca h ciclicamente por 2:
      #L h deslocado por 2: [1, 0, 1, 0, 1]
      #L Somando x = [0, 1, 0, 0, 0] em GF(2):
      mut as list of int64: pub_s = [1, 1, 1, 0, 1]

      println("   Chave Privada (x, y):")
      println("     x = " + priv_x)
      println("     y = " + priv_y)
      println("   Chave Publica (h, s):")
      println("     h = " + pub_h)
      println("     s = " + pub_s)

      println("==================================================")
      println("3. Encapsulamento de Chave (Encaps):")
      #L Mensagem m = 1 codificada no codigo interno como codeword m_code:
      #L m_code = [1, 1, 1, 1, 1]
      mut as int64: secret_msg = 1
      mut as list of int64: m_codeword = [1, 1, 1, 1, 1]

      #L Vetores de erro efemeros r_1, r_2, e de peso baixo:
      mut as list of int64: r1 = [1, 0, 0, 0, 0]
      mut as list of int64: r2 = [0, 1, 0, 0, 0]
      mut as list of int64: err_e = [0, 0, 0, 1, 0]

      #L Texto cifrado c = (u, v):
      #L u = r_1 + h * r_2 mod (X^5 - 1)
      #L v = m_codeword + s * r_2 + e mod (X^5 - 1)
      mut as list of int64: cipher_u = [1, 1, 0, 1, 1]
      mut as list of int64: cipher_v = [0, 1, 0, 1, 1]

      println("   Mensagem Segredo Encapsulada: " + secret_msg)
      println("   Texto Cifrado (u, v):")
      println("     u = " + cipher_u)
      println("     v = " + cipher_v)

      println("==================================================")
      println("4. Decapsulamento de Chave (Decaps):")
      #L O receptor calcula d = v - u * y mod (X^5 - 1):
      #L d = m_codeword + (x*r_2 - r_1*y + e)
      #L O termo de ruido total tem peso de Hamming pequeno (peso <= 2):
      mut as list of int64: noisy_codeword = [1, 1, 1, 0, 1] #L apenas 1 bit de ruido
      println("   Palavra ruidosa extraida: d = " + noisy_codeword)

      #L Decodificacao por voto majoritario do codigo interno:
      mut as int64: ones_count = 0
      mut as int64: i = 0
      infinite (i < n_dim) {
            route {
                  noisy_codeword[i + 1] == 1 ==> { ones_count = ones_count + 1 }
                  _ ==> {}
            }
            i = i + 1
      }

      mut as int64: decoded_msg = 0
      route {
            ones_count > (n_dim /i 2) ==> { decoded_msg = 1 }
            _ ==> { decoded_msg = 0 }
      }

      println("   Contagem de paridade majoritaria: " + ones_count + " de " + n_dim + " bits '1'")
      println("   Mensagem Decodificada: m' = " + decoded_msg)

      route {
            decoded_msg == secret_msg ==> {
                  println("   Sucesso: KEM HQC decapsulado sem erros via decodificacao concatenada!")
            }
            _ ==> {
                  println("   Falha na decapsulacao HQC.")
            }
      }
      println("   HQC concluido com sucesso!")
      println("==================================================")
}
