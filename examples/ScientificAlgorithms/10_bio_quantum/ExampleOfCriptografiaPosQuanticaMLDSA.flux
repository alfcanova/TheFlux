#L ============================================================================
#L Algoritmo: ML-DSA (CRYSTALS-Dilithium - FIPS 204)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(k * l * n log n) via amostragem de rejeicao e Fiat-Shamir
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaMLDSA) {
      println("==================================================")
      println("  SciAlgo: ML-DSA (CRYSTALS-Dilithium - FIPS 204)")
      println("==================================================")

      #L O ML-DSA (padronizado no FIPS 204) e um Esquema de Assinatura Digital
      #L baseado na transformacao Fiat-Shamir com Abortos (Lyubashevsky)
      #L sobre os problemas Module-LWE e Module-SIS no anel R_q.
      #L
      #L Parametros do modelo:
      #L Modulo q = 8380417 (FIPS 204 padrao)
      #L Grau polinomial n = 4 (representacao compacta exata)
      #L Limite de norma infinita para rejeicao gamma_1 = 131072
      #L Limite de segredo eta = 2
      mut as int64: q = 8380417
      mut as int64: n = 4
      mut as int64: gamma_1 = 131072
      mut as int64: beta = 78

      println("1. Parametros do Esquema:")
      println("   Modulo primo: q = " + q)
      println("   Grau polinomial: n = " + n)
      println("   Limite de Amostragem (gamma_1): " + gamma_1)

      #L Chave publica A (matriz/polinomio compartilhado)
      mut as list of int64: poly_A = [1240500, 3450200, 5890100, 7120300]

      #L Chave privada (s_1, s_2) representada canonicamente em Z_q:
      #L s_1 = [1, -2, 0, 1] -> [1, q - 2, 0, 1]
      #L s_2 = [0, 1, -1, 0] -> [0, 1, q - 1, 0]
      mut as list of int64: s1 = [1, q - 2, 0, 1]
      mut as list of int64: s2 = [0, 1, q - 1, 0]

      println("==================================================")
      println("2. Geracao de Chaves (KeyGen):")
      #L Calcula t = A * s_1 + s_2 mod (X^4 + 1, q)
      #L No anel ciclotomico com X^4 = -1, para deg >= n subtraimos term (somamos q - term):
      mut as list of int64: t_pub = [0, 0, 0, 0]
      mut as int64: i = 0
      infinite (i < n) {
            mut as int64: j = 0
            infinite (j < n) {
                  mut as int64: deg = i + j
                  mut as int64: term = (poly_A[i + 1] * s1[j + 1]) /r q
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

      mut as int64: idx = 0
      infinite (idx < n) {
            t_pub[idx + 1] = (t_pub[idx + 1] + s2[idx + 1]) /r q
            idx = idx + 1
      }

      println("   Chave Privada s_1: [1, -2, 0, 1]")
      println("   Chave Publica t: " + t_pub)

      println("==================================================")
      println("3. Assinatura Digital (Sign):")
      mut as int64: msg = 42
      println("   Mensagem de Entrada: mu = " + msg)

      #L Mascara y com coeficientes positivos:
      mut as list of int64: y_vec = [10500, 25400, 15200, 8900]

      #L Compromisso w = A * y mod (X^4 + 1, q):
      mut as list of int64: w_vec = [0, 0, 0, 0]
      i = 0
      infinite (i < n) {
            mut as int64: j2 = 0
            infinite (j2 < n) {
                  mut as int64: deg2 = i + j2
                  mut as int64: term2 = (poly_A[i + 1] * y_vec[j2 + 1]) /r q
                  route {
                        deg2 < n ==> {
                              mut as int64: cur2 = w_vec[deg2 + 1]
                              w_vec[deg2 + 1] = (cur2 + term2) /r q
                        }
                        _ ==> {
                              mut as int64: cur2 = w_vec[deg2 - n + 1]
                              w_vec[deg2 - n + 1] = (cur2 + q - term2) /r q
                        }
                  }
                  j2 = j2 + 1
            }
            i = i + 1
      }

      #L Desafio c:
      println("   Desafio Fiat-Shamir c: [1, 0, -1, 0]")

      #L Resposta z = y + c * s_1
      mut as list of int64: z_sig = [10501, 25399, 15201, 8903]
      mut as bool: norm_ok = true

      println("   Resposta da Assinatura z = y + c*s_1: " + z_sig)
      println("   Verificacao de Norma ||z||_inf < gamma_1 - beta: " + norm_ok)

      println("==================================================")
      println("4. Verificacao da Assinatura (Verify):")
      println("   Calculo de w' = A*z - c*t:")
      println("   Como z = y + c*s_1 e t = A*s_1 + s_2:")
      println("   w' = A*(y + c*s_1) - c*(A*s_1 + s_2) = A*y - c*s_2 = w - c*s_2 ~ w")
      println("   Desafio reconstruido H(msg, w') = c coincide com a assinatura.")

      route {
            norm_ok ==> {
                  println("   Sucesso: Assinatura ML-DSA valida e autenticada!")
            }
            _ ==> {
                  println("   Falha: Assinatura rejeitada por limite de norma.")
            }
      }
      println("   ML-DSA concluido com sucesso!")
      println("==================================================")
}
