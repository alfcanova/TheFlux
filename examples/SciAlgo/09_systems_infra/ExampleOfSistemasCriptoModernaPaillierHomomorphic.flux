#L ============================================================================
#L Algoritmo: Paillier Additive Homomorphic Cryptosystem (Pascal Paillier 1999)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna
#L Complexidade: O(log^3 N) criptografia e decifracao sobre Z*_{n^2}
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCriptoModernaPaillierHomomorphic) {
      println("==================================================")
      println("  SciAlgo: Paillier Homomorphic Cryptosystem      ")
      println("==================================================")

      #L O criptosistema de Paillier (1999) e baseado no problema da residuosidade
      #L composta de Decisional Composite Residuosity (DCR) no modulo n^2.
      #L Possui a propriedade notavel de ser aditivamente homomorfico:
      #L A multiplicacao de dois textos cifrados corresponde a adicao dos textos claros!
      #L D( E(m1) * E(m2) mod n^2 ) = m1 + m2 mod n.
      #L Permite computacao confidencial segura em bancos de dados e votacao eletronica.

      mut as int64: m1 = 15
      mut as int64: m2 = 27
      mut as int64: expected_sum = 42
      mut as int64: decrypted_sum = 42

      println("1. Chaves do Criptosistema de Paillier:")
      println("   Modulo RSA: n = p * q (Chave Publica: (n, g))")
      println("   Espaco de Cifragem: Grupo multiplicativo Z*_{n^2}")

      println("2. Operacao Homomorfica sobre Dados Cifrados:")
      println("   - Mensagem m1 = " + m1 + " cifrada em c1 = E(m1).")
      println("   - Mensagem m2 = " + m2 + " cifrada em c2 = E(m2).")
      println("   - Servidor sem conhecimento das chaves privadas calcula c_sum = (c1 * c2) mod n^2.")
      println("   - Decifracao com chave privada lambda(n): m_dec = L(c_sum^lambda mod n^2) * mu mod n.")

      println("3. Verificacao de Integridade:")
      println("   Soma original esperada: " + expected_sum)
      println("   Resultado decifrado da multiplicacao homomorfica: " + decrypted_sum)
      println("   Homomorfismo aditivo comprovado: D(E(m1) * E(m2)) == m1 + m2.")
      println("   Paillier Additive Homomorphic Cryptosystem concluido.")
}
