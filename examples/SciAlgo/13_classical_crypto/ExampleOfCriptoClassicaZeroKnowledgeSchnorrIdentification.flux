#L ============================================================================
#L Algoritmo: Schnorr Zero-Knowledge Proof (Protocolo Sigma / Fiat-Shamir)
#L Dominio: 13_classical_crypto / Categoria: Provas de Conhecimento Zero (ZKP)
#L Descricao: Prova nao-interativa de conhecimento de chave privada sem revelar informacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaZeroKnowledgeSchnorrIdentification) {
      println("=== Algoritmo: Schnorr Zero-Knowledge Proof (Fiat-Shamir) ===")

      #L Parametros publicos de grupo: Primo p = 23, Ordem q = 11, Gerador g = 2
      #L Segredo privado do Prover: x = 5
      #L Chave publica correspondente: y = (g^x) mod p = (2^5) mod 23 = 32 mod 23 = 9
      mut as int64: prime_p = 23
      mut as int64: gen_g = 2
      mut as int64: priv_x = 5
      mut as int64: pub_y = 9

      println("Parametros publicos: Primo p = " + prime_p + ", Gerador g = " + gen_g)
      println("Chave publica do Prover: y = (g^x mod p) = " + pub_y + " (Segredo x mantido oculto)")

      #L PASSO 1: COMPROMISSO (Commitment pelo Prover):
      #L Prover escolhe numero aleatorio efemero v = 4
      #L Calcula compromisso publico t = (g^v) mod p = (2^4) mod 23 = 16 mod 23 = 16
      mut as int64: v_eph = 4
      mut as int64: t_commit = 16
      println("Passo 1 (Commitment): Compromisso efemero gerado: t = " + t_commit)

      #L PASSO 2: DESAFIO FIAT-SHAMIR (Challenge via Hash):
      #L O desafio eh derivado deterministicamente: c = Hash(g, y, t) mod 11
      #L Simulacao de hash: c = 3
      mut as int64: chal_c = 3
      println("Passo 2 (Challenge): Desafio Fiat-Shamir derivado: c = " + chal_c)

      #L PASSO 3: RESPOSTA (Response pelo Prover):
      #L r = (v - c * x) mod 11
      #L v - c*x = 4 - 3*5 = 4 - 15 = -11 = 0 mod 11
      mut as int64: resp_r = 0
      println("Passo 3 (Response): Escalar de resposta calculado: r = " + resp_r)

      #L VERIFICACAO PELO VERIFIER:
      #L O verificador nao sabe o valor de x, mas checa a equivalencia:
      #L (g^r * y^c) mod p == t
      #L g^r = 2^0 = 1
      #L y^c = 9^3 = 729
      #L 729 mod 23: 23 * 31 = 713; 729 - 713 = 16
      #L (g^r * y^c) mod 23 = 1 * 16 = 16 == t!
      mut as int64: y_pow_c = (9 * 9 * 9) /r prime_p
      mut as int64: lhs_verif = (1 * y_pow_c) /r prime_p
      println("Verificacao do Verifier: (g^r * y^c mod p) = " + lhs_verif + " (Igual a t = " + t_commit + ")")

      route {
            lhs_verif == t_commit and pub_y == 9 ==> {
                  println("Prova de Conhecimento Zero Schnorr aceita: O Prover provou conhecer x sem revelar x!")
            }
            _ ==> {
                  println("Prova ZKP rejeitada")
            }
      }

      println("Schnorr Zero-Knowledge Proof concluido com sucesso.")
}
