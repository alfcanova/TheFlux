#L ============================================================================
#L Algoritmo: UOV (Unbalanced Oil and Vinegar - Assinatura Multivariada)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(m * v^2) avaliacao e resolucao linear em corpos finitos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaUOV) {
      println("==================================================")
      println("  SciAlgo: UOV (Unbalanced Oil and Vinegar)")
      println("==================================================")

      #L O esquema UOV (Kipnis, Patarin & Goubin, 1999) e o protocolo classico
      #L de assinatura multivariada mais robusto. Divide as variaveis em vinagre
      #L (V) e oleo (O), onde v > o (desbalanceado) para prevenir o ataque
      #L de Kipnis-Shamir. Como o oleo nao interage quadraticamente com oleo,
      #L a fixacao aleatoria das variaveis de vinagre lineariza o sistema inteiro!
      #L
      #L Parametros do modelo:
      #L Corpo finito F_11 (modulo primo q = 11)
      #L Variaveis vinagre: v = 3 (x_1, x_2, x_3)
      #L Variaveis oleo:    o = 2 (x_4, x_5)
      #L Total de variaveis: n = v + o = 5
      #L Numero de equacoes de paridade: m = o = 2
      mut as int64: q = 11
      mut as int64: n_vars = 5
      mut as int64: v_count = 3
      mut as int64: o_count = 2

      println("1. Parametros do Esquema UOV:")
      println("   Corpo de coeficientes: F_" + q)
      println("   Variaveis de Vinagre: v = " + v_count + " | Variaveis de Oleo: o = " + o_count)
      println("   Total de variaveis: n = " + n_vars + " | Equacoes quadraticas: m = " + o_count)

      #L Mapa central F = (f_1, f_2):
      #L Cada f_k possui termos (Vinagre x Vinagre) e (Vinagre x Oleo), mas NENHUM (Oleo x Oleo).
      #L f_1: x_1*x_2 + 2*x_1*x_4 + x_3*x_5 + 4 (mod 11)
      #L f_2: x_2*x_3 + x_2*x_4 + 3*x_1*x_5 + 1 (mod 11)

      #L Documento a assinar: digest d = [y_1, y_2] = [8, 5]
      mut as int64: y1 = 8
      mut as int64: y2 = 5
      println("   Hash a assinar: y = [" + y1 + ", " + y2 + "]")

      println("==================================================")
      println("2. Assinatura UOV via Linearizacao:")
      #L Passo 1: Escolhe aleatoriamente as variaveis vinagre (x_1, x_2, x_3):
      mut as int64: x1 = 2
      mut as int64: x2 = 1
      mut as int64: x3 = 3
      println("   1. Vinagres amostrados: x_1 = " + x1 + ", x_2 = " + x2 + ", x_3 = " + x3)

      #L Passo 2: Substituindo os vinagres no sistema, obtemos um sistema linear 2x2 para (x_4, x_5):
      #L f_1: (2*1) + 2*(2)*x_4 + (3)*x_5 + 4 = 2 + 4*x_4 + 3*x_5 + 4 = 4*x_4 + 3*x_5 + 6 = 8 mod 11
      #L      4*x_4 + 3*x_5 = 8 - 6 = 2 mod 11
      #L
      #L f_2: (1*3) + (1)*x_4 + 3*(2)*x_5 + 1 = 3 + 1*x_4 + 6*x_5 + 1 = 1*x_4 + 6*x_5 + 4 = 5 mod 11
      #L      1*x_4 + 6*x_5 = 5 - 4 = 1 mod 11
      println("   2. Sistema Linear 2x2 resultante para variaveis de oleo:")
      println("      Eq 1: 4*x_4 + 3*x_5 = 2 (mod 11)")
      println("      Eq 2: 1*x_4 + 6*x_5 = 1 (mod 11)")

      #L Resolucao por eliminacao gaussiana em F_11:
      #L Multiplica Eq 2 por 4: 4*x_4 + 24*x_5 = 4 mod 11 -> 4*x_4 + 2*x_5 = 4 mod 11
      #L Subtrai da Eq 1: (4*x_4 + 3*x_5) - (4*x_4 + 2*x_5) = 2 - 4 mod 11
      #L 1*x_5 = -2 = 9 mod 11 -> x_5 = 9
      mut as int64: x5 = 9
      #L De Eq 2: x_4 = 1 - 6*x_5 = 1 - 6*(9) = 1 - 54 = 1 - 10 = -9 = 2 mod 11 -> x_4 = 2
      mut as int64: x4 = 2

      println("   3. Oleos resolvidos com sucesso: x_4 = " + x4 + ", x_5 = " + x5)

      mut as list of int64: signature_uov = [x1, x2, x3, x4, x5]
      println("   Vetor de Assinatura UOV: " + signature_uov)

      println("==================================================")
      println("3. Verificacao da Assinatura (Verify):")
      #L O verificador avalia os polinomios quadraticos publicos em x:
      mut as int64: eval_f1 = ((x1 * x2) + (2 * x1 * x4) + (x3 * x5) + 4) /r q
      mut as int64: eval_f2 = ((x2 * x3) + (x2 * x4) + (3 * x1 * x5) + 1) /r q

      println("   f_1(x) = " + eval_f1 + " | Esperado y_1 = " + y1)
      println("   f_2(x) = " + eval_f2 + " | Esperado y_2 = " + y2)

      route {
            (eval_f1 == y1) and (eval_f2 == y2) ==> {
                  println("   Sucesso: Assinatura UOV autenticada com eliminacao gaussiana perfeita!")
            }
            _ ==> {
                  println("   Falha na verificacao UOV.")
            }
      }
      println("   UOV concluido com sucesso!")
      println("==================================================")
}
