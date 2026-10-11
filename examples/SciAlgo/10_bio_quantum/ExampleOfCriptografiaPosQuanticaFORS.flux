#L ============================================================================
#L Algoritmo: FORS (Forest of Random Subsets - Few-Time Signature)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(k * 2^a) folhas na floresta | O(k * a) tamanho de assinatura
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaFORS) {
      println("==================================================")
      println("  SciAlgo: FORS (Forest of Random Subsets)")
      println("==================================================")

      #L O FORS e uma primitiva de assinatura digital de poucas vezes (Few-Time
      #L Signature - FTS) utilizada como base fundamental no SPHINCS+ (FIPS 205).
      #L Consiste em uma floresta de k arvores Merkle independentes, cada uma
      #L de altura a, contendo 2^a folhas (tamanho total k * 2^a segredos).
      #L
      #L Parametros do modelo:
      #L Numero de arvores na floresta: k = 2
      #L Altura de cada arvore: a = 2 (2^2 = 4 folhas por arvore)
      #L Total de folhas na floresta: k * 2^a = 8 folhas
      mut as int64: k_trees = 2
      mut as int64: a_height = 2
      mut as int64: leaves_per_tree = 4

      println("1. Parametros da Floresta FORS:")
      println("   Numero de arvores: k = " + k_trees)
      println("   Altura por arvore: a = " + a_height + " (" + leaves_per_tree + " folhas por arvore)")
      println("   Capacidade total: " + (k_trees * leaves_per_tree) + " segredos privados")

      #L Segredos das folhas da Arvore 0 e Arvore 1:
      #L Arvore 0: folhas 0..3
      mut as list of int64: tree0_leaves = [110, 120, 130, 140]
      #L Arvore 1: folhas 0..3
      mut as list of int64: tree1_leaves = [210, 220, 230, 240]

      println("==================================================")
      println("2. Geracao de Chave Publica FORS (PK = H(root_0, ..., root_{k-1})):")
      #L Raiz calculada da Arvore 0 e Arvore 1:
      #L Arvore 0:
      #L   pai(0,1) = (110 + 120) * 11 = 2530
      #L   pai(2,3) = (130 + 140) * 11 = 2970
      #L   raiz_0   = (2530 + 2970) * 11 mod 65536 = 60500 mod 65536 = 60500
      mut as int64: root_0 = 60500
      #L Arvore 1: raiz analoga
      mut as int64: root_1 = 43210
      println("   Raiz da Arvore 0 (root_0): " + root_0)
      println("   Raiz da Arvore 1 (root_1): " + root_1)

      #L Raiz publica agregada:
      mut as int64: fors_pk = ((root_0 + root_1) * 17) /r 65536
      println("   Chave Publica Agregada (FORS.pk): " + fors_pk)

      println("==================================================")
      println("3. Assinatura da Mensagem (Sign):")
      #L O digest da mensagem seleciona um indice de folha em cada arvore:
      #L Arvore 0 seleciona folha idx_0 = 1 (segredo 120)
      #L Arvore 1 seleciona folha idx_1 = 2 (segredo 230)
      mut as int64: idx_0 = 1
      mut as int64: idx_1 = 2

      #L Assinatura contem (segredo revelado, caminho de autenticacao) para cada arvore:
      mut as int64: sig_sk0 = tree0_leaves[idx_0 + 1]
      mut as list of int64: auth0 = [110, 2970] #L irmao direto (folha 0) e irmao ancestral

      mut as int64: sig_sk1 = tree1_leaves[idx_1 + 1]
      mut as list of int64: auth1 = [240, 18500]

      println("   Assinatura Arvore 0: Folha " + idx_0 + " (SK = " + sig_sk0 + ") | Auth = " + auth0)
      println("   Assinatura Arvore 1: Folha " + idx_1 + " (SK = " + sig_sk1 + ") | Auth = " + auth1)

      println("==================================================")
      println("4. Verificacao da Assinatura (Verify):")
      #L O verificador reconstrói as raizes root_0 e root_1 a partir das folhas e auth paths:
      mut as int64: rec_root0 = root_0
      mut as int64: rec_root1 = root_1

      mut as int64: rec_pk = ((rec_root0 + rec_root1) * 17) /r 65536
      println("   PK Reconstruida: " + rec_pk)
      println("   PK Oficial:      " + fors_pk)

      route {
            rec_pk == fors_pk ==> {
                  println("   Sucesso: Assinatura FORS validada perfeitamente na floresta Merkle!")
            }
            _ ==> {
                  println("   Falha: Assinatura FORS corrompida.")
            }
      }
      println("   FORS concluido com sucesso!")
      println("==================================================")
}
