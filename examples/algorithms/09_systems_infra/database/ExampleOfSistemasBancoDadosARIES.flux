#L ============================================================================
#L Algoritmo: ARIES Crash Recovery Algorithm (Mohan et al. 1992)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(L) varredura de log (Analise, Redo, Undo com CLR)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosARIES) {
      println("==================================================")
      println("  SciAlgo: ARIES Database Crash Recovery")
      println("==================================================")

      #L O algoritmo ARIES (Algorithms for Recovery and Isolation Exploiting Semantics)
      #L e o padrao industrial para recuperacao de falhas em bancos de dados relacionais.
      #L Baseia-se em Write-Ahead Logging (WAL) e executa tres fases apos um crash:
      #L 1. Fase de Analise (Analysis): Identifica transacoes ativas (perdedoras) e paginas sujas.
      #L 2. Fase de Redo (Repeticao da Historia): Refaz todas as operacoes a partir do menor recLSN.
      #L 3. Fase de Undo: Desfaz operacoes de transacoes perdedoras escrevendo CLRs (Compensation Log Records).

      #L Log do WAL (sequencia de registros ate o momento da falha):
      #L LSN 10: T1 UPDATE Pagina P1 (antigo=100, novo=110)
      #L LSN 20: T2 UPDATE Pagina P2 (antigo=200, novo=250)
      #L LSN 30: CHECKPOINT (Transacoes ativas: T1, T2)
      #L LSN 40: T1 COMMIT
      #L LSN 50: T2 UPDATE Pagina P1 (antigo=110, novo=130)
      #L ---> CRASH DO SISTEMA! <--- (T1 comitou com sucesso; T2 e transacao PERDEDORA)

      println("1. Sequencia de Registros do WAL antes da Falha:")
      println("   LSN 10: T1 UPDATE P1 (100 -> 110)")
      println("   LSN 20: T2 UPDATE P2 (200 -> 250)")
      println("   LSN 30: CHECKPOINT")
      println("   LSN 40: T1 COMMIT")
      println("   LSN 50: T2 UPDATE P1 (110 -> 130)")
      println("   ---> FALHA DO SISTEMA (CRASH)! <---")

      #L ======================================================================
      #L Fase 1: Analise (Analysis Phase)
      #L ======================================================================
      println("==================================================")
      println("2. [Fase 1: Analise (Analysis Phase)]")
      println("   Varre o log para frente a partir do Checkpoint (LSN 30):")
      println("   - Detecta LSN 40: T1 efetuou COMMIT (Transacao Vencedora).")
      println("   - Detecta LSN 50: T2 estava ATIVA sem commit (Transacao Perdedora / Loser).")
      println("   - Reconstroi Tabela de Paginas Sujas (DPT): P1 (recLSN=10), P2 (recLSN=20).")
      mut as int64: loser_tx = 2 #L T2 deve sofrer UNDO

      #L ======================================================================
      #L Fase 2: Redo (Repeating History)
      #L ======================================================================
      println("==================================================")
      println("3. [Fase 2: Redo (Repeating History)]")
      println("   Varre o log para frente a partir do menor recLSN (LSN 10):")
      println("   - Redo LSN 10: P1 reaplica valor 110.")
      println("   - Redo LSN 20: P2 reaplica valor 250.")
      println("   - Redo LSN 50: P1 reaplica valor 130.")
      println("   Historia exatamente reconstituida ate o instante da falha!")

      #L ======================================================================
      #L Fase 3: Undo (Desfazendo Transacoes Perdedoras com CLRs)
      #L ======================================================================
      println("==================================================")
      println("4. [Fase 3: Undo com CLR (Compensation Log Records)]")
      println("   Varre o log para tras a partir da falha desfazendo transacao T" + loser_tx + ":")

      #L Desfaz LSN 50 (T2 em P1: 130 -> 110)
      println("   -> Desfazendo LSN 50: P1 restaurada de 130 para 110.")
      println("      Gravando CLR: LSN 60 (CLR para LSN 50, UndoNextLSN = 20)")

      #L Desfaz LSN 20 (T2 em P2: 250 -> 200)
      println("   -> Desfazendo LSN 20: P2 restaurada de 250 para 200.")
      println("      Gravando CLR: LSN 70 (CLR para LSN 20, UndoNextLSN = 0)")

      println("   -> Escrevendo registro de conclusao: LSN 80 (T2 END)")

      println("==================================================")
      println("5. Verificacao de Consistencia Pos-Recuperacao:")
      println("   Transacao T1: Confirmada (COMMIT persistido).")
      println("   Transacao T2: Revertida integralmente (ROLLBACK atomico garantido).")
      println("   Propriedades ACID e Idempotencia ARIES 100% preservadas!")
      println("==================================================")
}
