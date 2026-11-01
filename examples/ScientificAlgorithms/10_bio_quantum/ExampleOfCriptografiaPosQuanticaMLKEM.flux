#L ============================================================================
#L Algoritmo: ML-KEM (CRYSTALS-Kyber - FIPS 203)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(k^2 * n log n) via transformadas sobre o anel R_q
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaMLKEM) {
      println("==================================================")
      println("  SciAlgo: ML-KEM (CRYSTALS-Kyber - FIPS 203)")
      println("==================================================")

      #L O ML-KEM (padronizado no FIPS 203) e um Mecanismo de Encapsulamento
      #L de Chaves baseado na dureza do problema Module-LWE (Learning With
      #L Errors sobre Modulos) no anel polinomial R_q = Z_q[X] / (X^n + 1).
      #L
      #L Parametros do modelo:
      #L Modulo primo q = 3329 (FIPS 203 padrao)
      #L Grau polinomial n = 4 (representacao reduzida para ilustracao exata)
      #L Polinomio anti-ciclotomico: X^4 + 1
      mut as int64: q = 3329
      mut as int64: n = 4
      mut as int64: half_q = 1665 #L round(q / 2)

      println("1. Parametros Criptograficos:")
      println("   Anel Polinomial: Z_" + q + "[X] / (X^4 + 1)")
      println("   Modulo primo: q = " + q)
      println("   Constante de codificacao de bit (q/2): " + half_q)

      #L Vetores de coeficientes representando polinomios em R_q com coeficientes em [0, q-1]:
      #L Chave publica A (matriz/polinomio publico compartilhado)
      mut as list of int64: poly_A = [1250, 450, 2890, 780]
      #L Chave secreta s = [1, -1, 0, 1] -> [1, q-1, 0, 1]
      mut as list of int64: s_vec = [1, q - 1, 0, 1]
      #L Erro pequeno e = [0, 1, -1, 0] -> [0, 1, q-1, 0]
      mut as list of int64: e_vec = [0, 1, q - 1, 0]

      println("==================================================")
      println("2. Geracao de Chaves (KeyGen):")
      #L Multiplicacao polinomial t = A * s + e mod (X^4 + 1, q)
      #L No anel com X^4 = -1, para deg >= n somamos (q - term) mod q:
      mut as list of int64: t_pub = [0, 0, 0, 0]
      mut as int64: i = 0
      infinite (i < n) {
            mut as int64: j = 0
            infinite (j < n) {
                  mut as int64: deg = i + j
                  mut as int64: term = (poly_A[i + 1] * s_vec[j + 1]) /r q
                  route {
                        deg < n ==> {
                              mut as int64: cur = t_pub[deg + 1]
                              t_pub[deg + 1] = (cur + term) /r q
                        }
                        _ ==> {
                              mut as int64: cur = t_pub[deg - n + 1]
                              t_pub[deg - n + 1] = (cur + q - term) /r q
                        }
                  }
                  j = j + 1
            }
            i = i + 1
      }

      #L Adiciona o erro e modulo q:
      mut as int64: idx = 0
      infinite (idx < n) {
            t_pub[idx + 1] = (t_pub[idx + 1] + e_vec[idx + 1]) /r q
            idx = idx + 1
      }

      println("   Chave Secreta s: [1, -1, 0, 1]")
      println("   Chave Publica t = A*s + e: " + t_pub)

      println("==================================================")
      println("3. Encapsulamento de Chave (Encaps):")
      #L Mensagem de chave compartilhada m = 1 (codificada como half_q no termo constante)
      mut as int64: secret_bit = 1
      #L Vetor efemero r e erros e1, e2:
      #L r = [0, 1, 0, -1] -> [0, 1, 0, q-1]
      mut as list of int64: r_vec = [0, 1, 0, q - 1]
      mut as list of int64: e1_vec = [1, 0, 0, 0]
      mut as int64: e2_scalar = 1

      #L u = A * r + e1 mod (X^4 + 1, q)
      mut as list of int64: u_cipher = [0, 0, 0, 0]
      i = 0
      infinite (i < n) {
            mut as int64: j2 = 0
            infinite (j2 < n) {
                  mut as int64: deg2 = i + j2
                  mut as int64: term2 = (poly_A[i + 1] * r_vec[j2 + 1]) /r q
                  route {
                        deg2 < n ==> {
                              mut as int64: c2 = u_cipher[deg2 + 1]
                              u_cipher[deg2 + 1] = (c2 + term2) /r q
                        }
                        _ ==> {
                              mut as int64: c2 = u_cipher[deg2 - n + 1]
                              u_cipher[deg2 - n + 1] = (c2 + q - term2) /r q
                        }
                  }
                  j2 = j2 + 1
            }
            i = i + 1
      }
      idx = 0
      infinite (idx < n) {
            u_cipher[idx + 1] = (u_cipher[idx + 1] + e1_vec[idx + 1]) /r q
            idx = idx + 1
      }

      #L v = t . r + e2 + half_q * m (calculando o termo constante de v mod q):
      mut as int64: tr_pos = (t_pub[1] * r_vec[1]) /r q
      mut as int64: tr_neg = ((t_pub[2] * r_vec[4]) + (t_pub[3] * r_vec[3]) + (t_pub[4] * r_vec[2])) /r q
      mut as int64: tr_const = (tr_pos + q - tr_neg) /r q
      mut as int64: v_scalar = (tr_const + e2_scalar + (secret_bit * half_q)) /r q

      println("   Bit de Segredo Encapsulado: m = " + secret_bit)
      println("   Texto Cifrado (u, v):")
      println("     u = " + u_cipher)
      println("     v = " + v_scalar)

      println("==================================================")
      println("4. Decapsulamento de Chave (Decaps):")
      #L Bob calcula m_noisy = v - s * u mod q:
      mut as int64: su_pos = (s_vec[1] * u_cipher[1]) /r q
      mut as int64: su_neg = ((s_vec[2] * u_cipher[4]) + (s_vec[3] * u_cipher[3]) + (s_vec[4] * u_cipher[2])) /r q
      mut as int64: su_const = (su_pos + q - su_neg) /r q
      mut as int64: noisy_m = (v_scalar + q - su_const) /r q

      #L Decodificacao por limiar: se proximo de half_q -> 1, se proximo de 0 -> 0
      mut as int64: dist_zero = noisy_m
      route {
            dist_zero > half_q ==> { dist_zero = q - dist_zero }
            _ ==> {}
      }
      mut as int64: dist_half = noisy_m - half_q
      route {
            dist_half < 0 ==> { dist_half = 0 - dist_half }
            _ ==> {}
      }

      mut as int64: recovered_bit = 0
      route {
            dist_half < dist_zero ==> { recovered_bit = 1 }
            _ ==> { recovered_bit = 0 }
      }

      println("   Sinal com Ruido Extraido: " + noisy_m + " (Alvo teoric: ~" + half_q + ")")
      println("   Bit Decapsulado Recuperado: m' = " + recovered_bit)

      route {
            recovered_bit == secret_bit ==> {
                  println("   Sucesso: Chave encapsulada decapsulada com perfeita exatidao!")
            }
            _ ==> {
                  println("   Falha na decapsulacao.")
            }
      }
      println("   ML-KEM concluido com sucesso!")
      println("==================================================")
}
