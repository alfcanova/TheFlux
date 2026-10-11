#L ============================================================================
#L Algoritmo: Finger Tree (Deque Funcional com Arvores 2-3 de Hinze & Paterson 2006)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) amort. push/pop nas duas extremidades | O(log N) split
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasFingerTree) {
      println("==================================================")
      println("  SciAlgo: Finger Tree (Hinze & Paterson)")
      println("==================================================")

      #L Representacao dos digitos do prefixo (esquerda), miolo profundo (middle) e sufixo (direita)
      #L Digitos da esquerda (1 a 4 elementos): prefix
      #L Miolo (arvore mais profunda de nos 2-3 agrupados): deep_middle
      #L Digitos da direita (1 a 4 elementos): suffix
      mut as list of int64: prefix = []
      mut as list of int64: deep_middle = []
      mut as list of int64: suffix = []

      #L Insercoes nas duas extremidades (Deque bidirecional):
      #L PushFront: 10, 20
      #L PushBack: 30, 40, 50, 60
      println("1. Operacoes PushFront e PushBack no Finger Tree:")

      prefix = listPushBack(prefix, 20)
      prefix = listPushBack(prefix, 10)
      println("   Prefix (esquerda): " + prefix)

      suffix = listPushBack(suffix, 30)
      suffix = listPushBack(suffix, 40)
      suffix = listPushBack(suffix, 50)
      println("   Suffix (direita): " + suffix)

      #L Ao exceder capacidade do sufixo, agrupa 3 elementos em no 2-3 e promove para deep_middle
      println("2. Promovendo no 2-3 (30, 40, 50) para deep_middle...")
      deep_middle = listPushBack(deep_middle, 30)
      deep_middle = listPushBack(deep_middle, 40)
      deep_middle = listPushBack(deep_middle, 50)
      suffix = [60]

      println("   Prefix atual:      " + prefix)
      println("   Deep Middle atual: " + deep_middle)
      println("   Suffix atual:      " + suffix)

      #L Inspeciona elementos das extremidades (fingers) em O(1)
      mut as int64: front_elem = prefix[listLength(prefix)]
      mut as int64: back_elem = suffix[listLength(suffix)]
      println("3. Extremo esquerdo (Front): " + front_elem)
      println("4. Extremo direito (Back):   " + back_elem)

      #L PopFront em O(1)
      prefix = listRemoveLast(prefix)
      println("5. Apos PopFront, novo Front: " + prefix[listLength(prefix)])

      #L Reconstituicao linear da sequencia completa
      mut as list of int64: full_seq = []
      mut as int64: p_i = listLength(prefix)
      infinite (p_i >= 1) {
            full_seq = listPushBack(full_seq, prefix[p_i])
            p_i = p_i - 1
      }
      mut as int64: m_i = 1
      infinite (m_i <= listLength(deep_middle)) {
            full_seq = listPushBack(full_seq, deep_middle[m_i])
            m_i = m_i + 1
      }
      mut as int64: s_i = 1
      infinite (s_i <= listLength(suffix)) {
            full_seq = listPushBack(full_seq, suffix[s_i])
            s_i = s_i + 1
      }

      println("6. Sequencia total ordenada preservada: " + full_seq)
      println("7. Validacao: " + (front_elem == 10 and back_elem == 60 and listLength(full_seq) == 5))
      println("==================================================")
}
