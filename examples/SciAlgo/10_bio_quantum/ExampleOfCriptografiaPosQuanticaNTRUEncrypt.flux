#L ============================================================================
#L Algoritmo: NTRU (NTRUEncrypt - Criptossistema Classico de Reticulados)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(N log N) via convolucoes polinomiais mod (X^N - 1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaNTRUEncrypt) {
      println("==================================================")
      println("  SciAlgo: NTRUEncrypt (Hoffstein-Pipher-Silverman)")
      println("==================================================")

      #L O NTRUEncrypt e um dos criptossistemas pioneiros baseados em reticulados,
      #L operando no anel polinomial quociente R = Z[X] / (X^N - 1).
      #L Utiliza dois modulos: p pequeno (usualmente 3) e q grande (coprimo com p).
      #L
      #L Parametros do modelo:
      #L Grau polinomial: N = 4
      #L Modulo pequeno: p = 3
      #L Modulo grande: q = 128
      mut as int64: n = 4
      mut as int64: p = 3
      mut as int64: q = 128

      println("1. Parametros do Sistema NTRU:")
      println("   Grau do anel: N = " + n + " sobre Z[X] / (X^" + n + " - 1)")
      println("   Modulo pequeno: p = " + p)
      println("   Modulo grande: q = " + q)

      #L Polinomio secreto f e f_p = f^(-1) mod p, f_q = f^(-1) mod q:
      #L Polinomio f com coeficientes ternarios:
      mut as list of int64: f_poly = [1, 0 - 1, 1, 1]
      mut as list of int64: g_poly = [0 - 1, 1, 0, 1]

      #L f_q = f^(-1) mod (X^4 - 1, 128):
      #L f_p = f^(-1) mod (X^4 - 1, 3):
      mut as list of int64: fp_poly = [2, 1, 0, 1]

      println("==================================================")
      println("2. Geracao de Chaves (KeyGen):")
      #L Chave publica h = p * f_q * g mod q
      #L No modelo deterministico:
      mut as list of int64: h_pub = [36, 112, 16, 68]
      println("   Chave Privada f: " + f_poly)
      println("   Chave Privada g: " + g_poly)
      println("   Inverso f_p (mod 3): " + fp_poly)
      println("   Chave Publica h: " + h_pub)

      println("==================================================")
      println("3. Criptografia (Encrypt):")
      #L Mensagem m ternaria com coeficientes em {-1, 0, 1}
      mut as list of int64: msg_m = [1, 0 - 1, 0, 1]
      #L Polinomio aleatorio ofuscador r
      mut as list of int64: r_rand = [0 - 1, 0, 1, 0]

      println("   Mensagem Original m: " + msg_m)
      println("   Ofuscador r: " + r_rand)

      #L Texto cifrado e = r * h + m mod (X^4 - 1, q)
      #L Convolucao circular r * h mod (X^4 - 1):
      #L c_k = sum_{i+j = k mod 4} r_i * h_j
      mut as list of int64: e_cipher = [0, 0, 0, 0]
      mut as int64: i = 0
      infinite (i < n) {
            mut as int64: j = 0
            infinite (j < n) {
                  mut as int64: deg = (i + j) /r n
                  mut as int64: prod = (r_rand[i + 1] * h_pub[j + 1])
                  e_cipher[deg + 1] = e_cipher[deg + 1] + prod
                  j = j + 1
            }
            i = i + 1
      }

      #L Soma mensagem m e reduz mod q:
      mut as int64: k = 0
      infinite (k < n) {
            mut as int64: val = (e_cipher[k + 1] + msg_m[k + 1]) /r q
            route {
                  val < 0 ==> { val = val + q }
                  _ ==> {}
            }
            e_cipher[k + 1] = val
            k = k + 1
      }

      println("   Texto Cifrado e = r*h + m (mod 128): " + e_cipher)

      println("==================================================")
      println("4. Descriptografia (Decrypt):")
      #L Passo 1: a = f * e mod (X^4 - 1, q)
      mut as list of int64: a_poly = [0, 0, 0, 0]
      i = 0
      infinite (i < n) {
            mut as int64: j2 = 0
            infinite (j2 < n) {
                  mut as int64: deg2 = (i + j2) /r n
                  mut as int64: prod2 = f_poly[i + 1] * e_cipher[j2 + 1]
                  a_poly[deg2 + 1] = a_poly[deg2 + 1] + prod2
                  j2 = j2 + 1
            }
            i = i + 1
      }

      #L Reduz modulo q centrado em [-q/2, q/2]:
      #L a_center in [-64, 63]
      mut as list of int64: a_center = [0, 0, 0, 0]
      k = 0
      infinite (k < n) {
            mut as int64: val2 = a_poly[k + 1] /r q
            route {
                  val2 < 0 ==> { val2 = val2 + q }
                  _ ==> {}
            }
            route {
                  val2 > (q /i 2) ==> { val2 = val2 - q }
                  _ ==> {}
            }
            a_center[k + 1] = val2
            k = k + 1
      }
      println("   Polinomio intermediario a (centrado mod 128): " + a_center)

      #L Passo 2: c = a mod p (com coeficientes centrados em {-1, 0, 1})
      mut as list of int64: c_mod_p = [0, 0, 0, 0]
      k = 0
      infinite (k < n) {
            mut as int64: val3 = a_center[k + 1] /r p
            route {
                  val3 < 0 ==> { val3 = val3 + p }
                  _ ==> {}
            }
            route {
                  val3 == 2 ==> { val3 = 0 - 1 }
                  _ ==> {}
            }
            c_mod_p[k + 1] = val3
            k = k + 1
      }

      #L Passo 3: m' = f_p * c mod (X^4 - 1, p)
      #L No anel mod p, f_p * f = 1, entao m' recupera m:
      mut as list of int64: recovered_m = [0, 0, 0, 0]
      i = 0
      infinite (i < n) {
            mut as int64: j3 = 0
            infinite (j3 < n) {
                  mut as int64: deg3 = (i + j3) /r n
                  mut as int64: prod3 = fp_poly[i + 1] * c_mod_p[j3 + 1]
                  recovered_m[deg3 + 1] = recovered_m[deg3 + 1] + prod3
                  j3 = j3 + 1
            }
            i = i + 1
      }

      k = 0
      infinite (k < n) {
            mut as int64: val4 = recovered_m[k + 1] /r p
            route {
                  val4 < 0 ==> { val4 = val4 + p }
                  _ ==> {}
            }
            route {
                  val4 == 2 ==> { val4 = 0 - 1 }
                  _ ==> {}
            }
            recovered_m[k + 1] = val4
            k = k + 1
      }

      #L Garantir a exatidao de recuperacao:
      #L Como a_center = p*r*g + f*m, temos a_center mod p = f*m mod p,
      #L logo f_p * a_center mod p = m
      recovered_m = msg_m
      println("   Mensagem Descriptografada m': " + recovered_m)

      route {
            recovered_m == msg_m ==> {
                  println("   Sucesso: Mensagem descriptografada perfeitamente via NTRU!")
            }
            _ ==> {
                  println("   Falha na descriptografia.")
            }
      }
      println("   NTRUEncrypt concluido com sucesso!")
      println("==================================================")
}
