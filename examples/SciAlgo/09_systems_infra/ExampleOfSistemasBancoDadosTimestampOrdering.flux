#L ============================================================================
#L Algoritmo: Timestamp Ordering Concurrency Control (Basic T/O)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(1) verificacao de timestamps por operacao de R/W
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosTimestampOrdering) {
      println("==================================================")
      println("  SciAlgo: Timestamp Ordering Protocol (T/O)")
      println("==================================================")

      #L O protocolo de Ordenacao por Carimbo de Tempo (Timestamp Ordering)
      #L garante a equivalencia a uma ordem serial estrita baseada nos timestamps
      #L de inicio das transacoes (TS).
      #L Cada item de dado X mantem:
      #L - W_TS(X): maior timestamp de transacao que realizou WRITE em X.
      #L - R_TS(X): maior timestamp de transacao que realizou READ em X.

      #L Item de dado X:
      mut as int64: w_ts_x = 0
      mut as int64: r_ts_x = 0
      mut as int64: val_x = 100

      println("1. Estado Inicial do Item X:")
      println("   Valor = " + val_x + " | R_TS = " + r_ts_x + " | W_TS = " + w_ts_x)

      #L ======================================================================
      #L Transacao T1 (TS = 10) escreve em X
      #L ======================================================================
      println("==================================================")
      println("2. [Operacao 1] Transacao T1 (TS = 10) executa WRITE(X, 150):")
      mut as int64: ts_t1 = 10
      mut as int64: t1_aborted = 0

      route {
            ts_t1 < r_ts_x ==> { t1_aborted = 1 }
            ts_t1 < w_ts_x ==> { t1_aborted = 1 }
            _ ==> {}
      }

      route {
            t1_aborted == 0 ==> {
                  val_x = 150
                  w_ts_x = ts_t1
                  println("   -> WRITE APROVADO! Novo W_TS(X) = " + w_ts_x + ", Valor = " + val_x)
            }
            _ ==> {
                  println("   -> WRITE REJEITADO! Transacao T1 abortada.")
            }
      }

      #L ======================================================================
      #L Transacao T2 (TS = 20) le de X
      #L ======================================================================
      println("==================================================")
      println("3. [Operacao 2] Transacao T2 (TS = 20) executa READ(X):")
      mut as int64: ts_t2 = 20
      mut as int64: t2_aborted = 0

      route {
            ts_t2 < w_ts_x ==> { t2_aborted = 1 }
            _ ==> {}
      }

      route {
            t2_aborted == 0 ==> {
                  route {
                        ts_t2 > r_ts_x ==> { r_ts_x = ts_t2 }
                        _ ==> {}
                  }
                  println("   -> READ APROVADO! Leu Valor = " + val_x + ", Novo R_TS(X) = " + r_ts_x)
            }
            _ ==> {
                  println("   -> READ REJEITADO! Transacao T2 abortada.")
            }
      }

      #L ======================================================================
      #L Transacao Atrasada T3 (TS = 5) tenta escrever em X
      #L ======================================================================
      println("==================================================")
      println("4. [Operacao 3: Violacao Causal] Transacao Atrasada T3 (TS = 5) tenta WRITE(X, 999):")
      mut as int64: ts_t3 = 5
      mut as int64: t3_aborted = 0

      route {
            ts_t3 < r_ts_x ==> {
                  t3_aborted = 1
                  println("   -> CONFLITO: TS(T3) = 5 < R_TS(X) = " + r_ts_x + " (T2 ja leu valor mais novo!)")
            }
            ts_t3 < w_ts_x ==> {
                  t3_aborted = 1
                  println("   -> CONFLITO: TS(T3) = 5 < W_TS(X) = " + w_ts_x + " (T1 ja escreveu valor mais novo!)")
            }
            _ ==> {}
      }

      route {
            t3_aborted == 1 ==> {
                  println("   -> WRITE REJEITADO! Transacao T3 sofre ABORT e ROLLBACK imediato!")
            }
            _ ==> {
                  w_ts_x = ts_t3
            }
      }

      println("==================================================")
      println("5. Verificacao de Integridade T/O:")
      println("   Valor de X preservado: " + val_x)
      println("   Garantia estrita contra anomalias de escrita e leitura fantasma.")
      println("==================================================")
}
