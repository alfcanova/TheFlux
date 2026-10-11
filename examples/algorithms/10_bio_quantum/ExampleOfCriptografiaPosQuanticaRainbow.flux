#L ============================================================================
#L Algoritmo: Rainbow (Assinatura Multivariada por Camadas de Oil-and-Vinegar)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(m * v^2) assinatura via resolucao linear em camadas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaRainbow) {
      println("==================================================")
      println("  SciAlgo: Rainbow (Layered Multivariate Signature)")
      println("==================================================")

      #L O Rainbow e um esquema de assinatura digital pos-quantico baseado em
      #L equacoes quadraticas multivariadas (MQ) sobre corpos finitos F_q.
      #L Utiliza uma estrutura de camadas invertiveis de Oil e Vinegar (UOV em cascata),
      #L onde as variaveis Oil aparecem apenas linearmente em cada camada,
      #L permitindo inversao eficiente via eliminacao gaussiana.
      #L
      #L Parametros do modelo:
      #L Corpo finito F_7 (modulo primo q = 7)
      #L Camada 1: v_1 = 2 (vinagre), o_1 = 1 (oleo) -> 3 variaveis
      #L Camada 2: v_2 = 3 (vinagre), o_2 = 1 (oleo) -> 4 variaveis no total
      #L Equacoes centrais: m = o_1 + o_2 = 2
      mut as int64: q = 7
      mut as int64: n_vars = 4
      mut as int64: m_eqs = 2

      println("1. Parametros do Rainbow:")
      println("   Corpo de coeficientes: F_" + q)
      println("   Variaveis totais: n = " + n_vars + " (Camada 1: v_1=2, o_1=1; Camada 2: o_2=1)")
      println("   Numero de equacoes: m = " + m_eqs)

      #L Mapa central F = (f_1, f_2):
      #L f_1 (Camada 1): variaveis x_1, x_2 (vinagre 1) e x_3 (oleo 1):
      #L f_1 = x_1*x_2 + 2*x_1*x_3 + x_2*x_3 + 3 (mod 7)
      #L Note que x_3*x_3 e 0 (oleo nao multiplica oleo!)
      #L
      #L f_2 (Camada 2): variaveis x_1, x_2, x_3 (vinagre 2) e x_4 (oleo 2):
      #L f_2 = x_1*x_3 + 3*x_2*x_4 + x_3*x_4 + 1 (mod 7)

      #L Documento a assinar: digest d = [y_1, y_2] = [4, 2]
      mut as int64: y1 = 4
      mut as int64: y2 = 2
      println("   Digest a assinar: y = [" + y1 + ", " + y2 + "]")

      println("==================================================")
      println("2. Inversao do Mapa Central (Sign):")

      #L Passo 1: Escolhe aleatoriamente as variaveis vinagre iniciais (x_1, x_2):
      mut as int64: x1 = 1
      mut as int64: x2 = 2
      println("   1. Atribuicao do Vinagre 1: x_1 = " + x1 + ", x_2 = " + x2)

      #L Passo 2: Resolve para a variavel oleo 1 (x_3) na Camada 1:
      #L f_1 = (1 * 2) + 2*(1)*x_3 + (2)*x_3 + 3 = 2 + 2*x_3 + 2*x_3 + 3 = 4*x_3 + 5 = y_1 = 4 mod 7
      #L 4 * x_3 = 4 - 5 = -1 = 6 mod 7
      #L Inverso de 4 mod 7 e 2 (4 * 2 = 8 = 1):
      #L x_3 = 6 * 2 = 12 = 5 mod 7
      mut as int64: x3 = 5
      println("   2. Resolucao Linear da Camada 1: x_3 = " + x3)

      #L Passo 3: Resolve para a variavel oleo 2 (x_4) na Camada 2:
      #L f_2 = (1 * 5) + 3*(2)*x_4 + (5)*x_4 + 1 = 5 + 6*x_4 + 5*x_4 + 1 = 11*x_4 + 6 = 4*x_4 + 6 = y_2 = 2 mod 7
      #L 4 * x_4 = 2 - 6 = -4 = 3 mod 7
      #L x_4 = 3 * 2 = 6 mod 7
      mut as int64: x4 = 6
      println("   3. Resolucao Linear da Camada 2: x_4 = " + x4)

      mut as list of int64: signature_x = [x1, x2, x3, x4]
      println("   Assinatura Rainbow gerada: x = " + signature_x)

      println("==================================================")
      println("3. Verificacao da Assinatura (Verify):")
      #L Avaliacao direta dos polinomios quadraticos publicos em x:
      #L eval_1 = (x_1*x_2 + 2*x_1*x_3 + x_2*x_3 + 3) mod 7
      #L eval_2 = (x_1*x_3 + 3*x_2*x_4 + x_3*x_4 + 1) mod 7
      mut as int64: eval_1 = ((x1 * x2) + (2 * x1 * x3) + (x2 * x3) + 3) /r q
      mut as int64: eval_2 = ((x1 * x3) + (3 * x2 * x4) + (x3 * x4) + 1) /r q

      println("   Avaliacao f_1(x) = " + eval_1 + " | Esperado y_1 = " + y1)
      println("   Avaliacao f_2(x) = " + eval_2 + " | Esperado y_2 = " + y2)

      route {
            (eval_1 == y1) and (eval_2 == y2) ==> {
                  println("   Sucesso: Assinatura Rainbow validada por resolucao quadratica em camadas!")
            }
            _ ==> {
                  println("   Falha na verificacao Rainbow.")
            }
      }
      println("   Rainbow concluido com sucesso!")
      println("==================================================")
}
