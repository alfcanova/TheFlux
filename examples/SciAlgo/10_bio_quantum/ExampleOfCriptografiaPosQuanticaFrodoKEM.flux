#L ============================================================================
#L Algoritmo: FrodoKEM (Learning with Errors Nao-Estruturado)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n^3) multiplicacao de matrizes sem aneis algebricos ideais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaFrodoKEM) {
      println("==================================================")
      println("  SciAlgo: FrodoKEM (Generic Unstructured LWE)")
      println("==================================================")

      #L FrodoKEM e uma proposta conservadora de KEM pos-quantico baseada no
      #L problema padrao de Learning With Errors (LWE) generico sobre matrizes
      #L em Z_q, sem nenhuma estrutura algebrica adicional de anel ou modulo,
      #L tornando-o imune a eventuais ataques que explorem simetrias de aneis.
      #L
      #L Parametros do modelo:
      #L Modulo q = 32768 (potencia de 2: 2^15)
      #L Dimensao da matriz: n = 2, n_bar = 2, m_bar = 2
      #L Fator de codificacao de bit: q / 2 = 16384
      mut as int64: q = 32768
      mut as int64: half_q = 16384

      println("1. Parametros do FrodoKEM:")
      println("   Modulo generico: q = " + q + " (2^15)")
      println("   Dimensao das Matrizes: 2x2")
      println("   Escala de codificacao de bit (q/2): " + half_q)

      #L Matriz publica pseudoaleatoria A (2x2):
      #L A = [[12400,  5610],
      #L      [28910, 19450]]
      mut as int64: a11 = 12400
      mut as int64: a12 = 5610
      mut as int64: a21 = 28910
      mut as int64: a22 = 19450

      #L Matriz secreta S (2x2) com entradas gaussianas pequenas:
      #L S = [[ 2, -1],
      #L      [-1,  1]]
      mut as int64: s11 = 2
      mut as int64: s12 = 0 - 1
      mut as int64: s21 = 0 - 1
      mut as int64: s22 = 1

      #L Matriz de erro E (2x2) pequena:
      mut as int64: e11 = 1
      mut as int64: e12 = 0
      mut as int64: e21 = 0 - 1
      mut as int64: e22 = 1

      println("==================================================")
      println("2. Geracao de Chave Publica B = A*S + E mod q:")
      #L B_11 = a11*s11 + a12*s21 + e11 mod q
      #L B_12 = a11*s12 + a12*s22 + e12 mod q
      #L B_21 = a21*s11 + a22*s21 + e21 mod q
      #L B_22 = a21*s12 + a22*s22 + e22 mod q
      mut as int64: b11 = ((a11 * s11) + (a12 * s21) + e11) /r q
      mut as int64: b12 = ((a11 * s12) + (a12 * s22) + e12) /r q
      mut as int64: b21 = ((a21 * s11) + (a22 * s21) + e21) /r q
      mut as int64: b22 = ((a21 * s12) + (a22 * s22) + e22) /r q

      route { b11 < 0 ==> { b11 = b11 + q } _ ==> {} }
      route { b12 < 0 ==> { b12 = b12 + q } _ ==> {} }
      route { b21 < 0 ==> { b21 = b21 + q } _ ==> {} }
      route { b22 < 0 ==> { b22 = b22 + q } _ ==> {} }

      println("   Chave Publica B:")
      println("     [" + b11 + ", " + b12 + "]")
      println("     [" + b21 + ", " + b22 + "]")

      println("==================================================")
      println("3. Encapsulamento de Chave (Encaps):")
      #L Mensagem de segredo mu = 1 (codificada como half_q na posicao 1,1)
      mut as int64: secret_bit = 1

      #L Matrizes efemeras pequenas S' e E' (2x2):
      mut as int64: sp11 = 1
      mut as int64: sp12 = 0 - 1
      mut as int64: sp21 = 0
      mut as int64: sp22 = 1

      #L B' = S' * A + E' mod q (calculando B'_11 e B'_12):
      mut as int64: bp11 = ((sp11 * a11) + (sp12 * a21)) /r q
      mut as int64: bp12 = ((sp11 * a12) + (sp12 * a22)) /r q
      route { bp11 < 0 ==> { bp11 = bp11 + q } _ ==> {} }
      route { bp12 < 0 ==> { bp12 = bp12 + q } _ ==> {} }

      #L V = S' * B + E'' + Encode(mu) mod q:
      #L V_11 = sp11*b11 + sp12*b21 + secret_bit * half_q
      mut as int64: v11 = ((sp11 * b11) + (sp12 * b21) + (secret_bit * half_q)) /r q
      route { v11 < 0 ==> { v11 = v11 + q } _ ==> {} }

      println("   Bit de Segredo Encapsulado: mu = " + secret_bit)
      println("   Cifra (B'_11, V_11): (" + bp11 + ", " + v11 + ")")

      println("==================================================")
      println("4. Decapsulamento de Chave (Decaps):")
      #L O receptor computa: M = V_11 - (B' * S)_11 mod q
      #L (B' * S)_11 = bp11 * s11 + bp12 * s21
      mut as int64: bps11 = ((bp11 * s11) + (bp12 * s21)) /r q
      route { bps11 < 0 ==> { bps11 = bps11 + q } _ ==> {} }

      mut as int64: noisy_m = (v11 - bps11) /r q
      route { noisy_m < 0 ==> { noisy_m = noisy_m + q } _ ==> {} }

      #L Decodificacao por proximidade a 0 vs half_q:
      mut as int64: dist_0 = noisy_m
      route { dist_0 > half_q ==> { dist_0 = q - dist_0 } _ ==> {} }

      mut as int64: dist_h = noisy_m - half_q
      route { dist_h < 0 ==> { dist_h = 0 - dist_h } _ ==> {} }

      mut as int64: dec_bit = 0
      route {
            dist_h < dist_0 ==> { dec_bit = 1 }
            _ ==> { dec_bit = 0 }
      }

      println("   Sinal Ruidoso Extraido: " + noisy_m + " (Alvo teoric: ~" + half_q + ")")
      println("   Bit Decodificado: mu' = " + dec_bit)

      route {
            dec_bit == secret_bit ==> {
                  println("   Sucesso: Chave FrodoKEM decapsulada com exatidao absoluta!")
            }
            _ ==> {
                  println("   Falha no decapsulamento.")
            }
      }
      println("   FrodoKEM concluido com sucesso!")
      println("==================================================")
}
