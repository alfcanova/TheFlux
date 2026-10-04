#L ============================================================================
#L Algoritmo: Zobrist Hashing (Albert Zobrist 1970)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(1) atualizacao incremental de hash via XOR
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsZobrist) {
      println("==================================================")
      println("  SciAlgo: Zobrist Hashing")
      println("==================================================")

      #L Mini-tabuleiro de 9 casas (1 a 9) com 2 tipos de pecas (1 = Branco, 2 = Preto)
      #L Tabela Zobrist pre-gerada (valores 64-bit para cada peca em cada casa)
      mut as list of list of int64: zobrist_table = [
            [1234567, 2345678, 3456789, 4567890, 5678901, 6789012, 7890123, 8901234, 9012345],
            [9876543, 8765432, 7654321, 6543210, 5432109, 4321098, 3210987, 2109876, 1098765]
      ]

      #L Estado inicial: Peca 1 (Branco) na casa 1, Peca 2 (Preto) na casa 9
      mut as int64: h_initial = zobrist_table[1][1] ^ zobrist_table[2][9]
      println("1. Hash inicial do tabuleiro (Peca 1 em pos 1, Peca 2 em pos 9): " + h_initial)

      #L Lance: Peca 1 move-se da casa 1 para a casa 5
      #L Atualizacao O(1): XOR para remover de pos 1, XOR para adicionar em pos 5
      mut as int64: h_after_move = h_initial ^ zobrist_table[1][1] ^ zobrist_table[1][5]
      println("2. Hash apos mover Peca 1 de 1 -> 5: " + h_after_move)

      #L Lance de captura: Peca 1 move-se de 5 para 9, capturando a Peca 2
      #L XOR remove Peca 1 de 5, XOR adiciona Peca 1 em 9, XOR remove Peca 2 de 9
      mut as int64: h_after_capture = h_after_move ^ zobrist_table[1][5] ^ zobrist_table[1][9] ^ zobrist_table[2][9]
      println("3. Hash apos captura em pos 9: " + h_after_capture)

      #L Desfaz o lance de captura (Undo move): exatamente o mesmo XOR!
      mut as int64: h_undone_capture = h_after_capture ^ zobrist_table[1][5] ^ zobrist_table[1][9] ^ zobrist_table[2][9]
      #L Desfaz o primeiro lance (5 -> 1):
      mut as int64: h_restored = h_undone_capture ^ zobrist_table[1][1] ^ zobrist_table[1][5]
      println("4. Hash restaurado apos desfazer os lances (Undo): " + h_restored)

      println("5. Validacao: " + (h_restored == h_initial and h_after_move != h_initial))
      println("==================================================")
}
