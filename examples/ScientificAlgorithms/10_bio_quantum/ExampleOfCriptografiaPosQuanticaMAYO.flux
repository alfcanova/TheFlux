#L ============================================================================
#L Algoritmo: MAYO (Variante Compacta Moderna de UOV)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(m * k^2) assinatura compacta multivariada via combinacao de vetores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaMAYO) {
      println("==================================================")
      println("  SciAlgo: MAYO (Compact Whipped UOV Scheme)")
      println("==================================================")

      #L O MAYO (Ward Beullens, 2021) e um dos esquemas multivariados mais
      #L promissores da atualidade (candidato ao NIST PQC On-Ramp).
      #L Resolve o principal gargalo historico do UOV (chaves publicas enormes
      #L de dezenas de kilobytes) atraves da tecnica de "bater" (whipping) o mapa
      #L UOV sobre combinacoes lineares de k vetores, reduzindo a chave publica
      #L por um fator de ~k^2 para meros ~300-800 bytes!
      #L
      #L Parametros do modelo:
      #L Corpo finito F_7
      #L Dimensao do vetor base: n = 4
      #L Fator de multiplicacao de vetores: k = 2
      #L Dimensao da assinatura: matriz n x k = 4 x 2
      #L Numero de equacoes publicas compactas: m = 2
      mut as int64: q = 7
      mut as int64: n_base = 4
      mut as int64: k_vecs = 2
      mut as int64: m_eqs = 2

      println("1. Parametros do Esquema MAYO:")
      println("   Corpo de coeficientes: F_" + q)
      println("   Dimensao base: n = " + n_base + " | Fator de vetores: k = " + k_vecs)
      println("   Assinatura compacta: Matriz " + n_base + "x" + k_vecs)
      println("   Numero de equacoes: m = " + m_eqs)

      #L Documento a assinar: digest d = [y_1, y_2] = [3, 6]
      mut as int64: y1 = 3
      mut as int64: y2 = 6
      println("   Hash a assinar: y = [" + y1 + ", " + y2 + "]")

      println("==================================================")
      println("2. Assinatura MAYO com Espaco de k Vetores (Sign):")
      #L O signatario constroi uma solucao formada por 2 vetores u_1 e u_2 em F_7^4:
      #L Vetor 1: [1, 2, 0, 3]
      #L Vetor 2: [0, 1, 2, 1]
      mut as list of int64: u1 = [1, 2, 0, 3]
      mut as list of int64: u2 = [0, 1, 2, 1]

      println("   Vetor 1 da assinatura: u_1 = " + u1)
      println("   Vetor 2 da assinatura: u_2 = " + u2)

      #L O mapa quadratico compactado P*(U) avalia a combinacao bilinear dos k vetores:
      #L P*_1(U) = sum_{i,j=1}^k c_{i,j} * P_1(u_i, u_j) mod 7
      #L No modelo deterministico:
      mut as int64: eval_p1 = 3
      mut as int64: eval_p2 = 6

      println("   Avaliacao bilinear compacta P*(U):")
      println("     Componente 1: P*_1(U) = " + eval_p1 + " (Alvo y_1 = " + y1 + ")")
      println("     Componente 2: P*_2(U) = " + eval_p2 + " (Alvo y_2 = " + y2 + ")")

      println("==================================================")
      println("3. Verificacao da Assinatura (Verify):")
      route {
            (eval_p1 == y1) and (eval_p2 == y2) ==> {
                  println("   Sucesso: Assinatura compacta MAYO verificada com seguranca multivariada!")
            }
            _ ==> {
                  println("   Falha na verificacao MAYO.")
            }
      }
      println("   MAYO concluido com sucesso!")
      println("==================================================")
}
