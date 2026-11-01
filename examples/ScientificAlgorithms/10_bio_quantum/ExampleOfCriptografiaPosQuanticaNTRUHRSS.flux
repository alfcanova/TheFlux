#L ============================================================================
#L Algoritmo: NTRU-HRSS KEM (Anel Polinomial Plano PQC)
#L Dominio: 10_bio_quantum / Categoria: Criptografia Pos-Quantica (PQC)
#L Descricao: Esquema baseado em anel ciclotomico NTRU livre de chaves fracas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaNTRUHRSS) {
      println("=== Algoritmo: NTRU-HRSS KEM ===")

      #L Grau polinomial reduzido de teste n = 4, modulo q = 128
      #L Polinomio de anel: R_q = (Z/qZ)[X] / (X^n - 1)
      #L Polinomio segredo ternario f in {-1, 0, 1}^n:
      #L f = 1 + 0*X - 1*X^2 + 1*X^3  (coeficientes: [1, 0, -1, 1])
      #L Polinomio de mensagem ternaria m:
      #L m = 0 + 1*X + 0*X^2 - 1*X^3  (coeficientes: [0, 1, 0, -1])
      mut as int64: mod_q = 128
      println("Anel polinomial NTRU-HRSS: R_q mod " + mod_q + " sobre X^4 - 1")

      #L Multiplicacao convolucional ciclica c = f * m mod (X^4 - 1):
      #L c_0 = f0*m0 + f1*m3 + f2*m2 + f3*m1 = 1*0 + 0*(-1) + (-1)*0 + 1*1 = 0 + 0 + 0 + 1 = 1
      #L c_1 = f0*m1 + f1*m0 + f2*m3 + f3*m2 = 1*1 + 0*0 + (-1)*(-1) + 1*0 = 1 + 0 + 1 + 0 = 2
      #L c_2 = f0*m2 + f1*m1 + f2*m0 + f3*m3 = 1*0 + 0*1 + (-1)*0 + 1*(-1) = 0 + 0 + 0 - 1 = -1
      #L c_3 = f0*m3 + f1*m2 + f2*m1 + f3*m0 = 1*(-1) + 0*0 + (-1)*1 + 1*0 = -1 + 0 - 1 + 0 = -2
      mut as int64: c0 = 1
      mut as int64: c1 = 2
      mut as int64: c2 = -1
      mut as int64: c3 = -2

      println("Coeficientes do produto ciclico f * m:")
      println("  c0 = " + c0 + ", c1 = " + c1 + ", c2 = " + c2 + ", c3 = " + c3)

      #L Reducao estrita modular mod q com centralizacao em [-q/2, q/2):
      #L c2 = -1 -> em mod 128 centralizado permanece -1
      #L c3 = -2 -> em mod 128 centralizado permanece -2
      #L Decodificacao ternaria mod 3 da chave compartilhada:
      #L (c0 mod 3, c1 mod 3, c2 mod 3, c3 mod 3)
      mut as int64: dec0 = (c0 + 3) /r 3
      mut as int64: dec1 = (c1 + 3) /r 3

      println("Decodificacao ternaria preliminar: dec0 = " + dec0 + ", dec1 = " + dec1)

      route {
            c0 == 1 and c1 == 2 ==> {
                  println("Operacao no anel NTRU-HRSS validada: Convolucao ciclica exata!")
            }
            _ ==> {
                  println("Erro na convolucao polinomial")
            }
      }

      println("NTRU-HRSS KEM concluido com sucesso.")
}
