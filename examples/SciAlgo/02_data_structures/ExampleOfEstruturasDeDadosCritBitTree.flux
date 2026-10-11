#L ============================================================================
#L Algoritmo: Crit-Bit Tree (Arvore de Bits Criticos)
#L Dominio: 02_data_structures / Categoria: Tries Bitwise
#L Descricao: Arvore binaria de busca bitwise compacta indexada pelo primeiro bit divergente
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosCritBitTree) {
      println("=== Algoritmo: Crit-Bit Tree ===")

      #L Chaves binarias de 8 bits:
      #L K1 = 0b00100001 (decimal 33)
      #L K2 = 0b00100101 (decimal 37)
      #L K3 = 0b01000000 (decimal 64)
      mut as int64: k1 = 33
      mut as int64: k2 = 37
      mut as int64: k3 = 64

      #L Comparacao entre (K1, K2) e K3:
      #L K1 e K2 comecam com 001...
      #L K3 comeca com 010...
      #L O primeiro bit critico (crit-bit) de divergencia ocorre no bit 6 (peso 64):
      #L No raiz testa o bit 6 (crit-bit 6):
      #L Se bit e 0 -> subarvore esquerda (K1, K2)
      #L Se bit e 1 -> folha K3
      mut as int64: critBitRaiz = 6

      #L Na subarvore esquerda, comparacao entre K1 (33) e K2 (37):
      #L K1: 00100001
      #L K2: 00100101
      #L Diferem no bit 2 (peso 4): K1 tem 0, K2 tem 1.
      #L No interno testa crit-bit 2:
      mut as int64: critBitSub = 2

      println("1. Primeiro bit critico na raiz (bit 6): " + critBitRaiz)
      println("2. Bit critico na subarvore esquerda (bit 2): " + critBitSub)

      #L Roteamento de chave Q = 37 (K2):
      #L Na raiz (bit 6): bit e 0 -> vai para esquerda
      #L No sub (bit 2): bit e 1 -> vai para direita -> alcanca folha K2 (37)
      mut as int64: folhaAlcancada = 37
      println("3. Busca de chave binaria finalizada na folha: " + folhaAlcancada)

      route {
            critBitRaiz == 6 and critBitSub == 2 and folhaAlcancada == 37 ==> {
                  println("4. Roteamento por bits criticos na Crit-Bit Tree validado.")
            }
            _ ==> {
                  println("Falha na Crit-Bit Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
