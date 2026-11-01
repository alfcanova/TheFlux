#L ============================================================================
#L Algoritmo: Shamir's Secret Sharing (Esquema de Limiar k-de-n — Adi Shamir)
#L Dominio: 13_classical_crypto / Categoria: Compartilhamento de Segredos
#L Descricao: Divisao de segredo com seguranca perfeita via interpolacao de Lagrange em corpo primo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaShamirSecretSharing) {
      println("=== Algoritmo: Shamir's Secret Sharing (k-of-n Threshold) ===")

      #L Esquema de limiar (k = 2 de n = 3 partes):
      #L Quaisquer 2 partes reconstroem o segredo; 1 parte nao revela informacao alguma
      #L Segredo original secreto S = 42
      #L Corpo primo finito: p = 101 (primo maior que o segredo e numero de partes)
      mut as int64: secret_s = 42
      mut as int64: prime_p = 101
      println("Segredo original a proteger: S = " + secret_s + " em GF(" + prime_p + ")")

      #L Polinomio de grau k - 1 = 1: P(x) = S + a1 * x mod p
      #L Coeficiente aleatorio secreto a1 = 15
      #L P(x) = (42 + 15 * x) mod 101
      mut as int64: a1 = 15

      #L Geracao das n = 3 partes publicas (x_i, y_i):
      #L Parte 1 (x=1): y1 = (42 + 15*1) mod 101 = 57
      #L Parte 2 (x=2): y2 = (42 + 15*2) mod 101 = 72
      #L Parte 3 (x=3): y3 = (42 + 15*3) mod 101 = 87
      mut as int64: x1 = 1
      mut as int64: y1 = 57
      mut as int64: x2 = 2
      mut as int64: y2 = 72
      mut as int64: x3 = 3
      mut as int64: y3 = 87

      println("Partes distribuidas aos guardioes:")
      println("  Guardião 1: (x=1, y=57)")
      println("  Guardião 2: (x=2, y=72)")
      println("  Guardião 3: (x=3, y=87)")

      #L RECONSTRUCAO DO SEGREDO USANDO APENAS 2 PARTES (Parte 1 e Parte 2):
      #L Formula de Interpolacao de Lagrange para x = 0:
      #L S = P(0) = y1 * [ (0 - x2) / (x1 - x2) ] + y2 * [ (0 - x1) / (x2 - x1) ]
      #L Termo 1: l1(0) = -x2 / (x1 - x2) = -2 / (1 - 2) = -2 / -1 = 2
      #L Termo 2: l2(0) = -x1 / (x2 - x1) = -1 / (2 - 1) = -1 / 1 = -1
      mut as int64: l1_zero = 2
      mut as int64: l2_zero = -1

      #L S = y1 * l1(0) + y2 * l2(0)
      #L S = 57 * 2 + 72 * (-1) = 114 - 72 = 42
      mut as int64: s_reconstructed = y1 * l1_zero + y2 * l2_zero
      println("Segredo matematicamente reconstruido por Lagrange: S' = " + s_reconstructed)

      route {
            s_reconstructed == secret_s ==> {
                  println("Reconstrucao do segredo de Shamir validada com seguranca incondicional de Shannon!")
            }
            _ ==> {
                  println("Falha na reconstrucao do segredo")
            }
      }

      println("Shamir's Secret Sharing concluido com sucesso.")
}
