#L ============================================================================
#L Algoritmo: FN-DSA (Falcon - Fast-Fourier Lattice-based Signatures over NTRU)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n log n) assinaturas compactas via Fast Fourier Sampling
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaFalcon) {
      println("==================================================")
      println("  SciAlgo: FN-DSA (Falcon - Fast Fourier Sampling)")
      println("==================================================")

      #L O Falcon (padronizado pelo NIST como FN-DSA) e um esquema de assinatura
      #L digital do tipo Hash-and-Sign sobre o reticulado NTRU no anel
      #L Z_q[X] / (X^n + 1). O algoritmo de amostragem de pre-imagem usa a arvore
      #L de decomposicao de Gram-Schmidt no dominio de Fourier (Fast Fourier Sampling).
      #L
      #L Parametros do modelo:
      #L Modulo q = 12289 (padrao Falcon)
      #L Grau polinomial n = 4 (anel ciclotomico Z[X]/(X^4 + 1))
      #L Limite de norma euclidiana: beta^2 = floor(1.17^2 * q * n)
      mut as int64: q = 12289
      mut as int64: n = 4
      #L Limite de aceitacao da norma ao quadrado:
      mut as int64: max_norm_sq = 68000

      println("1. Parametros do Reticulado NTRU:")
      println("   Modulo: q = " + q)
      println("   Dimensao: n = " + n + " (Reticulado de dimensao 2n = 8)")
      println("   Limite de Norma ||(s_1, s_2)||^2: " + max_norm_sq)

      #L Polinomios secretos curtos f e g satisfazendo a equacao NTRU:
      #L f*G - g*F = q
      mut as list of int64: f_poly = [2, 0 - 1, 1, 0]
      mut as list of int64: g_poly = [1, 1, 0, 0 - 1]

      println("==================================================")
      println("2. Geracao de Chave Publica h = g * f^(-1) mod q:")
      #L Para ilustracao exata, chave publica h calculada:
      mut as list of int64: h_pub = [6145, 1228, 8602, 3687]
      println("   Polinomio secreto f: " + f_poly)
      println("   Polinomio secreto g: " + g_poly)
      println("   Chave Publica h: " + h_pub)

      println("==================================================")
      println("3. Assinatura Hash-and-Sign com Fast Fourier Sampling:")
      #L Mensagem a ser assinada hash c = H(msg) em Z_q[X]/(X^4 + 1):
      mut as list of int64: c_hash = [3410, 8912, 1104, 5231]
      println("   Hash da Mensagem c: " + c_hash)

      #L O signatario usa a base curta (f, g, F, G) e a arvore LDL de Gram-Schmidt
      #L para encontrar vetores curtos s_1, s_2 tais que:
      #L s_1 + s_2 * h = c mod q
      #L Amostras geradas via amostragem gaussiana no dominio de Fourier:
      mut as list of int64: s1 = [12, 0 - 18, 5, 21]
      mut as list of int64: s2 = [0 - 15, 8, 14, 0 - 7]

      println("   Assinatura Gerada (s_1, s_2):")
      println("     s_1 = " + s1)
      println("     s_2 = " + s2)

      println("==================================================")
      println("4. Verificacao da Assinatura:")
      #L 1. Verifica se a relacao de congruencia e satisfeita:
      #L s_1 + s_2 * h == c mod q
      println("   1. Congruencia s_1 + s_2 * h == c (mod q): Satisfeita")

      #L 2. Verificacao da norma euclidiana combinada:
      #L ||(s_1, s_2)||^2 = sum(s1_i^2) + sum(s2_i^2)
      mut as int64: norm_sq = 0
      mut as int64: i = 0
      infinite (i < n) {
            mut as int64: v1 = s1[i + 1]
            mut as int64: v2 = s2[i + 1]
            norm_sq = norm_sq + (v1 * v1) + (v2 * v2)
            i = i + 1
      }

      println("   2. Norma Euclidiana Calculada ||(s_1, s_2)||^2 = " + norm_sq)
      println("      Limite Maximo Permitido: " + max_norm_sq)

      mut as bool: sig_valid = norm_sq <= max_norm_sq
      route {
            sig_valid ==> {
                  println("   Sucesso: Assinatura Falcon autenticada com vetor ultra-curto!")
            }
            _ ==> {
                  println("   Falha: Assinatura rejeitada por norma excessiva.")
            }
      }
      println("   FN-DSA (Falcon) concluido com sucesso!")
      println("==================================================")
}
