#L ============================================================================
#L Algoritmo: Árvore Criptográfica de Merkle (Merkle Tree & Audit Proof)
#L Domínio: 09_systems_infra / Categoria: Criptografia, Blockchains e Integridade
#L Complexidade: O(N) construção da árvore; O(log N) prova de auditoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use HashStdLib

program (ExampleOfSistemasConsensoMerkleTree) {
      println("==================================================")
      println("  SciAlgo: Arvore Criptografica de Merkle (SHA-256)")
      println("==================================================")

      #L 4 blocos de dados de entrada (transacoes)
      mut as string: b1 = "tx_alice_to_bob_100"
      mut as string: b2 = "tx_bob_to_charlie_50"
      mut as string: b3 = "tx_charlie_to_dave_25"
      mut as string: b4 = "tx_dave_to_eve_10"

      #L Camada 0: Folhas da Arvore (Hashes SHA-256)
      mut as string: h1 = hashSha256(b1)
      mut as string: h2 = hashSha256(b2)
      mut as string: h3 = hashSha256(b3)
      mut as string: h4 = hashSha256(b4)

      println("1. Folhas (Level 0):")
      println("   H1: " + h1)
      println("   H2: " + h2)
      println("   H3: " + h3)
      println("   H4: " + h4)

      #L Camada 1: Combinacao aos pares dos nos filhos
      mut as string: concat12 = h1 + h2
      mut as string: concat34 = h3 + h4
      mut as string: h12 = hashSha256(concat12)
      mut as string: h34 = hashSha256(concat34)

      println("2. Sub-raizes (Level 1):")
      println("   H12: " + h12)
      println("   H34: " + h34)

      #L Camada 2: Raiz de Merkle (Merkle Root)
      mut as string: concat_root = h12 + h34
      mut as string: merkle_root = hashSha256(concat_root)

      println("3. Merkle Root (Level 2): " + merkle_root)

      #L ----------------------------------------------------
      #L Prova de Inclusao / Auditoria de Merkle para o Bloco 2
      #L Caminho de auditoria O(log N): irmao H1 (a esquerda) e irmao H34 (a direita)
      #L ----------------------------------------------------
      mut as string: verify_leaf = hashSha256(b2)
      mut as string: verify_parent = hashSha256(h1 + verify_leaf)
      mut as string: calculated_root = hashSha256(verify_parent + h34)

      mut as bool: prova_valida = (calculated_root == merkle_root)
      println("4. Verificacao de Prova de Auditoria do Bloco 2: " + prova_valida)

      #L ----------------------------------------------------
      #L Teste de Deteccao de Adulteracao (Tamper Resistance)
      #L Invasor tenta adulterar o valor da transacao no Bloco 2
      #L ----------------------------------------------------
      mut as string: b2_adulterado = "tx_bob_to_charlie_50000"
      mut as string: tampered_leaf = hashSha256(b2_adulterado)
      mut as string: tampered_parent = hashSha256(h1 + tampered_leaf)
      mut as string: tampered_root = hashSha256(tampered_parent + h34)

      mut as bool: fraude_detectada = (tampered_root != merkle_root)
      println("5. Deteccao imediata de fraude ao alterar bloco: " + fraude_detectada)

      mut as bool: integridade_merkle = prova_valida and fraude_detectada
      println("6. Verificacao completa da Arvore de Merkle: " + integridade_merkle)
      println("==================================================")
}
