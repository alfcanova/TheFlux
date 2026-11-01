#L ============================================================================
#L Algoritmo: PBKDF2 Password-Based Key Derivation (RFC 2898 / PKCS #5)
#L Dominio: 13_classical_crypto / Categoria: Derivacao e Hashing de Senhas
#L Descricao: Reforco computacional de senhas contra forca bruta via repeticao de HMAC
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaPBKDF2PasswordDerivation) {
      println("=== Algoritmo: PBKDF2 Password-Based KDF (RFC 2898) ===")

      #L Senha do usuario: password = 1234
      #L Sal criptografico aleatorio (Salt): salt = 88
      #L Fator de iteracao de trabalho: c = 4 iteracoes (em producao c >= 100000)
      mut as int64: password = 1234
      mut as int64: salt = 88
      mut as int64: iter_count = 4

      println("Entradas: Senha = " + password + ", Sal = " + salt + ", Iteracoes c = " + iter_count)

      #L Iteracao 1: U_1 = PRF(Password, Salt || 1)
      #L Simulacao PRF: (password * 41 + salt * 17 + 1) mod 10000
      #L U_1 = (1234 * 41 + 88 * 17 + 1) mod 10000 = (50594 + 1496 + 1) mod 10000 = 52091 mod 10000 = 2091
      mut as int64: u1 = (password * 41 + salt * 17 + 1) /r 10000
      println("Iteracao 1: U_1 = " + u1)

      #L Acumulador XOR inicial: T = U_1
      mut as int64: t_acc = u1

      #L Iteracao 2: U_2 = PRF(Password, U_1)
      #L U_2 = (password * 41 + u1 * 17) mod 10000
      #L (50594 + 2091 * 17) = (50594 + 35547) = 86141 mod 10000 = 6141
      mut as int64: u2 = (password * 41 + u1 * 17) /r 10000
      t_acc = t_acc ^ u2
      println("Iteracao 2: U_2 = " + u2 + " -> Acumulador T = " + t_acc)

      #L Iteracao 3: U_3 = PRF(Password, U_2)
      mut as int64: u3 = (password * 41 + u2 * 17) /r 10000
      t_acc = t_acc ^ u3
      println("Iteracao 3: U_3 = " + u3 + " -> Acumulador T = " + t_acc)

      #L Iteracao 4: U_4 = PRF(Password, U_3)
      mut as int64: u4 = (password * 41 + u3 * 17) /r 10000
      t_acc = t_acc ^ u4
      println("Iteracao 4: U_4 = " + u4 + " -> Chave mestre derivada T = " + t_acc)

      route {
            u1 == 2091 and u2 == 6141 ==> {
                  println("Derivacao PBKDF2 concluida com reforco iterativo contra rainbow tables!")
            }
            _ ==> {
                  println("Erro no PBKDF2")
            }
      }

      println("PBKDF2 Password Derivation concluido com sucesso.")
}
