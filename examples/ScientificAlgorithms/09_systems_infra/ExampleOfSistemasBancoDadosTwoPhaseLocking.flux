#L ============================================================================
#L Algoritmo: Two-Phase Locking Concurrency Control (2PL)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(1) verificacao de conflito de travas por operacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosTwoPhaseLocking) {
      println("==================================================")
      println("  SciAlgo: Two-Phase Locking (Strict 2PL)")
      println("==================================================")

      #L O protocolo de Bloqueio em Duas Fases (2PL) garante serializabilidade
      #L de conflito em transacoes concorrentes de banco de dados.
      #L Fases:
      #L 1. Fase de Crescimento (Growing): Adquire travas (S ou X), sem liberar nenhuma.
      #L 2. Lock Point: Ponto maximo de travas adquiridas.
      #L 3. Fase de Encolhimento (Shrinking / Strict): Libera travas apenas no Commit.
      #L
      #L Matriz de Compatibilidade:
      #L          Shared(S)   Exclusive(X)
      #L Shared       OK        BLOQUEADO
      #L Exclusive BLOQUEADO    BLOQUEADO

      #L Itens de dados: 1 = Item_A, 2 = Item_B
      #L Estado das travas: 0 = LIVRE, 1 = SHARED(S), 2 = EXCLUSIVE(X)
      mut as list of int64: lock_mode = [0, 0]
      mut as list of int64: lock_holder = [0, 0]

      println("1. Estado Inicial dos Recursos:")
      println("   Item A: Livre | Item B: Livre")

      #L ======================================================================
      #L Transacao T1 entra na Fase de Crescimento
      #L ======================================================================
      println("==================================================")
      println("2. [Fase de Crescimento de T1]:")

      #L T1 adquire trava exclusiva X em Item A
      lock_mode[1] = 2 #L Exclusive
      lock_holder[1] = 1 #L T1
      println("   -> T1 solicita e adquire trava EXCLUSIVE(X) em Item A.")

      #L T1 adquire trava exclusiva X em Item B
      lock_mode[2] = 2 #L Exclusive
      lock_holder[2] = 1 #L T1
      println("   -> T1 solicita e adquire trava EXCLUSIVE(X) em Item B.")
      println("   [Lock Point alcancado por T1]: Todas as travas retidas!")

      #L ======================================================================
      #L Transacao T2 tenta acessar Item A concorrentemente
      #L ======================================================================
      println("==================================================")
      println("3. [Concorrencia e Conflito de Travas]:")
      println("   T2 solicita trava SHARED(S) em Item A...")

      route {
            lock_mode[1] == 2 ==> {
                  println("   -> CONFLITO DETECTADO: Item A esta retido em modo EXCLUSIVE por T" + lock_holder[1] + "!")
                  println("   -> T2 e BLOQUEADA e colocada em fila de espera (Wait-for-Lock).")
            }
            _ ==> {}
      }

      #L ======================================================================
      #L T1 conclui operacoes e efetua COMMIT (Strict 2PL)
      #L ======================================================================
      println("==================================================")
      println("4. [Commit de T1 e Fase de Liberacao das Travas]:")
      println("   T1 conclui suas operacoes e executa COMMIT.")
      lock_mode[1] = 0
      lock_holder[1] = 0
      lock_mode[2] = 0
      lock_holder[2] = 0
      println("   -> Travas de Item A e Item B liberadas integralmente.")

      #L ======================================================================
      #L T2 e desbloqueada e executa com seguranca
      #L ======================================================================
      println("==================================================")
      println("5. [Desbloqueio e Execucao de T2]:")
      println("   Item A esta agora LIVRE.")
      lock_mode[1] = 1 #L Shared
      lock_holder[1] = 2 #L T2
      println("   -> T2 adquire trava SHARED(S) em Item A.")
      println("   -> T2 realiza leitura consistente de Item A e comita com sucesso!")
      lock_mode[1] = 0
      lock_holder[1] = 0

      println("==================================================")
      println("6. Verificacao de Serializabilidade:")
      println("   Ordem Serial Equivalente: T1 -> T2.")
      println("   Strict 2PL preveniu leitura suja e leitura fantasma.")
      println("==================================================")
}
