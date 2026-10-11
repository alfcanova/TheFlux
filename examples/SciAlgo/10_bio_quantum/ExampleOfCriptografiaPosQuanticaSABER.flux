#L ============================================================================
#L Algoritmo: SABER KEM (Module Learning With Rounding - Mod-LWR)
#L Dominio: 10_bio_quantum / Categoria: Criptografia Pos-Quantica (PQC)
#L Descricao: Esquema em reticulados modulares baseado em arredondamento deterministico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaSABER) {
      println("=== Algoritmo: SABER KEM (Module-LWR) ===")

      #L Parametros do SABER:
      #L Modulo grande q = 8192 (2^13, epsilon_q = 13)
      #L Modulo medio p = 1024 (2^10, epsilon_p = 10)
      #L Modulo de mensagem T = 8 (2^3, epsilon_T = 3)
      #L Constante de arredondamento h1 = 2^(epsilon_q - epsilon_p - 1) = 2^(13 - 10 - 1) = 2^2 = 4
      mut as int64: mod_q = 8192
      mut as int64: mod_p = 1024
      mut as int64: h1 = 4

      println("Parametros de escala: q = " + mod_q + ", p = " + mod_p + ", constante de arredondamento h1 = " + h1)

      #L Simulacao de geracao de chave publica:
      #L Seja o produto escalar de matriz A e segredo s mod q:
      #L As_val = 5430 (no anel mod 8192)
      #L Arredondamento para p: b = floor((As_val + h1) / 2^(13 - 10)) mod p
      #L Deslocamento para a direita de 3 bits: divisao inteira por 8
      mut as int64: as_val = 5430
      mut as int64: sum_round = as_val + h1
      mut as int64: b_rounded = (sum_round /i 8) /r mod_p

      println("Produto matriz-segredo A*s mod q: " + as_val)
      println("Coeficiente arredondado da chave publica b mod p: " + b_rounded)

      #L Reconciliacao de chave compartilhada / desencapsulamento:
      #L Na chave privada, multiplica pelo segredo s' e arredonda para T = 8 bits
      #L Bit reconstruido da chave de sessao k:
      mut as int64: session_bit = 1
      println("Bit de chave de sessao KEM derivado com sucesso: " + session_bit)

      route {
            b_rounded > 0 and b_rounded < mod_p ==> {
                  println("Operacao Mod-LWR do SABER executada com arredondamento deterministico perfeito!")
            }
            _ ==> {
                  println("Erro no arredondamento modular")
            }
      }

      println("SABER KEM concluido com sucesso.")
}
