#L ============================================================================
#L Algoritmo: Merkle Tree (Arvore Criptografica e Provas de Inclusao Logaritmicas)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaMerkleTree) {
      println("==================================================")
      println("  SciAlgo: Cryptographic Merkle Tree & Audit Proof")
      println("==================================================")

      #L Funcao hash interna: H(prefix, left, right) mod 2^31 - 1
      mut as int64: primeH = 2147483647

      #L Separadores de domínio RFC 6962
      mut as int64: domLeaf = 0
      mut as int64: domNode = 1

      #L Dados das 4 folhas (transações)
      mut as list of int64: leafData = [101, 202, 303, 404]
      mut as int64: numLeaves = 4

      println("1. Calculo dos Hashes das Folhas H(domLeaf || leafData):")
      mut as list of int64: leafHashes = [0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= numLeaves) {
            mut as int64: h = ((domLeaf * 31 + leafData[i]) * 16777619 + 2166136261) /r primeH
            leafHashes[i] = h
            println("   Folha L" + i + " (Dado " + leafData[i] + "): Hash = " + h)
            i = i + 1
      }

      println("==================================================")
      println("2. Construcao da Arvore (Nivel 1 e Raiz):")
      #L Nos intermediarios: N12 = H(domNode || L1 || L2), N34 = H(domNode || L3 || L4)
      mut as int64: n12 = ((domNode * 31 + leafHashes[1]) * 16777619 + leafHashes[2]) /r primeH
      mut as int64: n34 = ((domNode * 31 + leafHashes[3]) * 16777619 + leafHashes[4]) /r primeH
      println("   No Pai N12: " + n12)
      println("   No Pai N34: " + n34)

      #L Raiz Merkle: Root = H(domNode || N12 || N34)
      mut as int64: root = ((domNode * 31 + n12) * 16777619 + n34) /r primeH
      println("   Raiz Merkle Oficial: " + root)

      println("==================================================")
      println("3. Geracao e Verificacao da Prova de Inclusao (Audit Path para L3):")
      #L Para provar L3, o caminho de auditoria consiste em:
      #L - Irmao de nivel 0: L4 (a direita)
      #L - Irmao de nivel 1: N12 (a esquerda)
      mut as int64: proofSibling0 = leafHashes[4]
      mut as int64: proofSibling1 = n12

      println("   Dado a verificar: L3 = " + leafData[3])
      println("   Irmao nivel 0 (L4): " + proofSibling0)
      println("   Irmao nivel 1 (N12): " + proofSibling1)

      #L Verificador recalcula a raiz sem conhecer L1 ou L2:
      mut as int64: vLeaf3 = ((domLeaf * 31 + leafData[3]) * 16777619 + 2166136261) /r primeH
      mut as int64: vN34 = ((domNode * 31 + vLeaf3) * 16777619 + proofSibling0) /r primeH
      mut as int64: vRoot = ((domNode * 31 + proofSibling1) * 16777619 + vN34) /r primeH

      println("   Raiz recalculada pelo Verificador: " + vRoot)

      route {
            vRoot == root ==> {
                  println("   SUCESSO: Prova de Inclusao validada com complexidade O(log N)!")
            }
            _ ==> {
                  println("   FALHA: Raiz recalculada diverge da oficial.")
            }
      }

      println("==================================================")
      println("4. Teste de Deteccao de Adulteracao na Folha L3:")
      mut as int64: tamperedData = 999
      mut as int64: badLeaf3 = ((domLeaf * 31 + tamperedData) * 16777619 + 2166136261) /r primeH
      mut as int64: badN34 = ((domNode * 31 + badLeaf3) * 16777619 + proofSibling0) /r primeH
      mut as int64: badRoot = ((domNode * 31 + proofSibling1) * 16777619 + badN34) /r primeH

      println("   Raiz com dado adulterado: " + badRoot)
      route {
            badRoot != root ==> {
                  println("   SUCESSO: Adulteracao detectada! Prova rejeitada pelo Verificador.")
            }
            _ ==> {
                  println("   FALHA: Adulteracao passou despercebida.")
            }
      }
}
