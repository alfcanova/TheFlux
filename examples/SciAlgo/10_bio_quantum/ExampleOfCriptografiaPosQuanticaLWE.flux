#L ============================================================================
#L Algoritmo: Learning With Errors (LWE / Ring-LWE)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(m * n) geracao e verificacao de amostras LWE
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaLWE) {
      println("==================================================")
      println("  SciAlgo: Learning With Errors (LWE / Ring-LWE)")
      println("==================================================")

      #L O problema Learning With Errors (LWE, introduzido por Oded Regev) e
      #L a pedra fundamental da criptografia pos-quantica moderna baseada em reticulados.
      #L Dadas amostras (a_i, b_i = <a_i, s> + e_i mod q), o problema consiste em
      #L recuperar o vetor secreto s (Search-LWE) ou distinguir tais pares de
      #L uma distribuicao uniforme (Decision-LWE).
      #L
      #L Parametros do modelo:
      #L Dimensao do segredo: n = 3
      #L Modulo primo: q = 97
      #L Numero de amostras publicas: m = 4
      #L Desvio do erro gaussiano discreto: sigma pequeno (e in {-1, 0, 1})
      mut as int64: n = 3
      mut as int64: q = 97
      mut as int64: m = 4

      println("1. Parametros do Problema LWE:")
      println("   Dimensao do segredo s: n = " + n)
      println("   Modulo primo: q = " + q)
      println("   Numero de amostras publicas: m = " + m)

      #L Vetor secreto s in Z_q^n:
      mut as list of int64: s_secret = [5, 12, 23]
      println("   Vetor Secreto s: " + s_secret)

      #L Matriz A de amostras publicas (m x n) e erros e:
      #L Linha 1: a_1 = [14,  7, 42], e_1 =  1
      #L Linha 2: a_2 = [29, 81, 15], e_2 = -1
      #L Linha 3: a_3 = [55, 33,  8], e_3 =  0
      #L Linha 4: a_4 = [ 3, 64, 70], e_4 =  1
      mut as list of int64: a1 = [14, 7, 42]
      mut as list of int64: a2 = [29, 81, 15]
      mut as list of int64: a3 = [55, 33, 8]
      mut as list of int64: a4 = [3, 64, 70]
      mut as list of int64: err = [1, 96, 0, 1]

      println("==================================================")
      println("2. Geracao de Amostras LWE b_i = <a_i, s> + e_i (mod q):")

      #L Amostra 1:
      mut as int64: dot1 = (a1[1]*s_secret[1]) + (a1[2]*s_secret[2]) + (a1[3]*s_secret[3])
      mut as int64: b1_val = (dot1 + err[1]) /r q

      #L Amostra 2:
      mut as int64: dot2 = (a2[1]*s_secret[1]) + (a2[2]*s_secret[2]) + (a2[3]*s_secret[3])
      mut as int64: b2_val = (dot2 + err[2]) /r q

      #L Amostra 3:
      mut as int64: dot3 = (a3[1]*s_secret[1]) + (a3[2]*s_secret[2]) + (a3[3]*s_secret[3])
      mut as int64: b3_val = (dot3 + err[3]) /r q

      #L Amostra 4:
      mut as int64: dot4 = (a4[1]*s_secret[1]) + (a4[2]*s_secret[2]) + (a4[3]*s_secret[3])
      mut as int64: b4_val = (dot4 + err[4]) /r q

      println("   Amostra 1: a_1 = " + a1 + " | b_1 = " + b1_val + " (Erro: 1)")
      println("   Amostra 2: a_2 = " + a2 + " | b_2 = " + b2_val + " (Erro: -1)")
      println("   Amostra 3: a_3 = " + a3 + " | b_3 = " + b3_val + " (Erro: 0)")
      println("   Amostra 4: a_4 = " + a4 + " | b_4 = " + b4_val + " (Erro: " + err[4] + ")")

      println("==================================================")
      println("3. Criptosistema Regev baseado em LWE:")
      #L Criptografa bit m_bit = 1 codificado como floor(q/2) = 48:
      mut as int64: m_bit = 1
      mut as int64: half_q = q /i 2

      #L Cifrador combina subconjunto de amostras (ex: amostras 1 e 3):
      #L c_1 = a_1 + a_3 mod q
      #L c_2 = b_1 + b_3 + m_bit * floor(q/2) mod q
      mut as list of int64: c1_vec = [(a1[1] + a3[1]) /r q, (a1[2] + a3[2]) /r q, (a1[3] + a3[3]) /r q]
      mut as int64: c2_scalar = (b1_val + b3_val + (m_bit * half_q)) /r q
      route { c2_scalar < 0 ==> { c2_scalar = c2_scalar + q } _ ==> {} }

      println("   Bit a Cifrar: " + m_bit)
      println("   Texto Cifrado (c_1, c_2):")
      println("     c_1 = " + c1_vec)
      println("     c_2 = " + c2_scalar)

      println("==================================================")
      println("4. Descriptografia por Produto Interno:")
      #L Calcula dec = c_2 - <c_1, s> mod q
      mut as int64: dot_c1s = (c1_vec[1]*s_secret[1]) + (c1_vec[2]*s_secret[2]) + (c1_vec[3]*s_secret[3])
      mut as int64: noisy = ((c2_scalar + q) - (dot_c1s /r q)) /r q

      #L Decodifica: se proximo de half_q -> 1, se proximo de 0 -> 0:
      mut as int64: dist_0 = noisy
      route { dist_0 > half_q ==> { dist_0 = q - dist_0 } _ ==> {} }
      mut as int64: dist_h = noisy - half_q
      route { dist_h < 0 ==> { dist_h = 0 - dist_h } _ ==> {} }

      mut as int64: rec_bit = 0
      route {
            dist_h < dist_0 ==> { rec_bit = 1 }
            _ ==> { rec_bit = 0 }
      }

      println("   Sinal Decodificado ruidoso: " + noisy + " (Referencia q/2 = " + half_q + ")")
      println("   Bit Recuperado: m' = " + rec_bit)

      route {
            rec_bit == m_bit ==> {
                  println("   Sucesso: Cifra LWE decodificada perfeitamente!")
            }
            _ ==> {
                  println("   Falha na decodificacao LWE.")
            }
      }
      println("   Learning With Errors (LWE) concluido com sucesso!")
      println("==================================================")
}
