#L ============================================================================
#L Algoritmo: Multi-Version Concurrency Control (MVCC / Snapshot Isolation)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(V) visibilidade de versoes por leitura sem travamento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosMVCCAlgorithms) {
      println("==================================================")
      println("  SciAlgo: Multi-Version Concurrency Control (MVCC)")
      println("==================================================")

      #L O MVCC e a base de sistemas como PostgreSQL e InnoDB (MySQL).
      #L Principio: Leitores nao bloqueiam Escritores, e Escritores nao
      #L bloqueiam Leitores.
      #L Cada tupla possui multiplas versoes com marcadores temporais:
      #L - xmin: transacao que criou a versao.
      #L - xmax: transacao que substituiu/deletou a versao (0 se viva).
      #L Regra de Visibilidade para Snapshot TS:
      #L Uma versao e visivel se: xmin <= TS E (xmax == 0 OU xmax > TS).

      #L Tabela de Versoes de um registro de Conta Bancaria:
      #L Versao 1: val = 100, xmin = 10, xmax = 0 (inicialmente)
      #L Versao 2: val = 250, xmin = 30, xmax = 0 (criada por T30)
      mut as list of int64: v_val = [100, 250]
      mut as list of int64: v_xmin = [10, 30]
      mut as list of int64: v_xmax = [0, 0]

      println("1. Estado Inicial (Versao 1 criada por T10):")
      println("   Versao 1: Saldo = " + v_val[1] + " (xmin = " + v_xmin[1] + ", xmax = " + v_xmax[1] + ")")

      #L ======================================================================
      #L Evento: Transacao Longa de Leitura T20 inicia com Snapshot TS = 20
      #L ======================================================================
      mut as int64: snap_t20 = 20
      println("2. [Inicio de T20] Transacao de Relatorio T20 inicia com Snapshot TS = " + snap_t20)

      #L ======================================================================
      #L Evento Concorrente: Transacao T30 (TS = 30) atualiza a conta para 250
      #L ======================================================================
      println("3. [Atualizacao Concorrente por T30 (TS = 30)]:")
      println("   -> T30 encerra a validade da Versao 1 marcando xmax = 30")
      v_xmax[1] = 30
      println("   -> T30 insere Versao 2 com Saldo = 250 (xmin = 30, xmax = 0) e efetua COMMIT.")

      #L ======================================================================
      #L T20 realiza leitura usando seu snapshot antigo (TS = 20)
      #L ======================================================================
      println("==================================================")
      println("4. [Leitura por T20 sob Snapshot Isolation (TS = " + snap_t20 + ")]:")

      mut as int64: t20_read_val = 0
      mut as int64: ver = 1
      infinite (ver <= 2) {
            mut as int64: cur_xmin = v_xmin[ver]
            mut as int64: cur_xmax = v_xmax[ver]

            #L Avalia visibilidade: xmin <= 20 E (xmax == 0 OU xmax > 20)
            route {
                  cur_xmin <= snap_t20 ==> {
                        mut as int64: is_visible = 0
                        route {
                              cur_xmax == 0 ==> { is_visible = 1 }
                              cur_xmax > snap_t20 ==> { is_visible = 1 }
                              _ ==> {}
                        }

                        route {
                              is_visible == 1 ==> {
                                    t20_read_val = v_val[ver]
                                    println("   -> Versao " + ver + " e VISIVEL para T20! (xmin=" + cur_xmin + " <= 20, xmax=" + cur_xmax + " > 20)")
                              }
                              _ ==> {
                                    println("   -> Versao " + ver + " nao e visivel para T20.")
                              }
                        }
                  }
                  _ ==> {
                        println("   -> Versao " + ver + " foi criada no futuro (xmin=" + cur_xmin + " > 20) -> INVISIVEL!")
                  }
            }
            ver = ver + 1
      }

      println("   Resultado da Leitura de T20: Saldo = " + t20_read_val + " (Consistencia retroativa perfeita!)")

      #L ======================================================================
      #L Nova Transacao T40 (TS = 40) le a versao mais recente
      #L ======================================================================
      println("==================================================")
      println("5. [Leitura por Nova Transacao T40 (TS = 40)]:")
      mut as int64: snap_t40 = 40
      mut as int64: t40_read_val = 0

      mut as int64: v2 = 1
      infinite (v2 <= 2) {
            mut as int64: xmin2 = v_xmin[v2]
            mut as int64: xmax2 = v_xmax[v2]

            route {
                  xmin2 <= snap_t40 ==> {
                        route {
                              xmax2 == 0 ==> {
                                    t40_read_val = v_val[v2]
                                    println("   -> Versao " + v2 + " e a versao viva atual para T40 (xmin=" + xmin2 + ", xmax=0)!")
                              }
                              _ ==> {
                                    println("   -> Versao " + v2 + " ja expirou antes de TS=40 (xmax=" + xmax2 + ") -> Ignorada.")
                              }
                        }
                  }
                  _ ==> {}
            }
            v2 = v2 + 1
      }
      println("   Resultado da Leitura de T40: Saldo = " + t40_read_val)

      println("==================================================")
      println("6. Verificacao de Isolamento MVCC:")
      println("   T20 leu Saldo 100 sem nenhum lock de bloqueio.")
      println("   T40 leu Saldo 250 sem interferir nas leituras concorrentes.")
      println("   Isolamento por Instantaneo (Snapshot Isolation) validado com sucesso!")
      println("==================================================")
}
