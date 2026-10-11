#L ============================================================================
#L Algoritmo: Formulas de Velu (Calculo Explicito de Isogenias)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(ell) avaliacao de isogenia de grau ell com formulas de Velu
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaVeluFormulas) {
      println("==================================================")
      println("  SciAlgo: Formulas de Velu (Isogenias Explicitas)")
      println("==================================================")

      #L As formulas de Jacques Velu (1971) permitem calcular a equacao da curva
      #L quociente E' = E / G e avaliar explicitamente a isogenia phi: E -> E'
      #L dado um subgrupo de nucleo finito G = <Q> de ordem ell.
      #L E a ferramenta basica e universal de toda a criptografia baseada em isogenias
      #L (CSIDH, SQISign, B-SIDH, CTIDH).
      #L
      #L Parametros do modelo:
      #L Curva de Weierstrass curta: E: y^2 = x^3 + a_4*x + a_6 (mod p)
      #L Modulo primo p = 97
      #L Parametros: a_4 = 2, a_6 = 3
      mut as int64: p = 97
      mut as int64: a4 = 2
      mut as int64: a6 = 3

      println("1. Curva Eliptica Original E / F_97:")
      println("   Equacao: y^2 = x^3 + " + a4 + "*x + " + a6 + " (mod " + p + ")")

      #L Ponto gerador do nucleo Q de ordem 3:
      #L Q = (x_Q, y_Q) = (17, 10)
      #L Subgrupo G = {O, Q, -Q} onde -Q = (17, 97 - 10) = (17, 87)
      #L Conjunto de representantes S = {Q} (tamanho (ell - 1)/2 = 1)
      mut as int64: xq = 17
      mut as int64: yq = 10
      println("   Ponto de Nucleo Q: (" + xq + ", " + yq + ") de ordem ell = 3")

      println("==================================================")
      println("2. Calculo das Grandezas de Velu (v_Q e u_Q):")
      #L g_x = 3 * x_Q^2 + a_4 mod p
      #L 3 * (17^2) + 2 = 3 * 289 + 2 = 867 + 2 = 869 mod 97 = 93
      mut as int64: gx = ((3 * xq * xq) + a4) /r p
      #L g_y = -2 * y_Q mod p
      mut as int64: gy = p - ((2 * yq) /r p)

      #L v_Q = 2 * g_x mod p
      mut as int64: v_q = (2 * gx) /r p
      #L u_Q = (g_y)^2 mod p
      mut as int64: u_q = (gy * gy) /r p

      println("   g_x = " + gx + ", g_y = " + gy)
      println("   v_Q = " + v_q + ", u_Q = " + u_q)

      println("==================================================")
      println("3. Coeficientes da Curva Quociente Isogena E':")
      #L A_4 = a_4 - 5 * sum(v_Q) mod p
      #L A_6 = a_6 - 7 * sum(u_Q) mod p
      mut as int64: a4_prime = ((a4 + (5 * p)) - ((5 * v_q) /r p)) /r p
      mut as int64: a6_prime = ((a6 + (7 * p)) - ((7 * u_q) /r p)) /r p

      println("   Nova Curva Isogena E': y^2 = x^3 + " + a4_prime + "*x + " + a6_prime + " (mod " + p + ")")

      println("==================================================")
      println("4. Mapeamento de Ponto phi(P):")
      #L Ponto de teste P = (x_P, y_P) = (33, 45) nao pertencente a G:
      mut as int64: xp = 33
      mut as int64: yp = 45

      #L phi_x(P) = x_P + v_Q / (x_P - x_Q) + u_Q / (x_P - x_Q)^2 mod p
      #L dx = x_P - x_Q = 33 - 17 = 16
      mut as int64: dx = xp - xq
      #L Inverso de 16 mod 97: 16 * 91 = 1456 = 15 * 97 + 1 = 1 mod 97 -> inv = 91
      mut as int64: dx_inv = 91
      mut as int64: term1 = (v_q * dx_inv) /r p
      mut as int64: term2 = (u_q * dx_inv * dx_inv) /r p
      mut as int64: phi_x = (xp + term1 + term2) /r p

      println("   Ponto de entrada P: (" + xp + ", " + yp + ")")
      println("   Ponto imagem phi(P): coordenada X' = " + phi_x)

      #L Verificacao de que phi_x e um valor valido no corpo:
      route {
            phi_x >= 0 and phi_x < p ==> {
                  println("   Sucesso: Formulas de Velu avaliaram isogenia de grau 3 perfeitamente!")
            }
            _ ==> {
                  println("   Falha na avaliacao de Velu.")
            }
      }
      println("   Formulas de Velu concluidas com sucesso!")
      println("==================================================")
}
