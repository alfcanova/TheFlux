#L ============================================================================
#L Algoritmo: Viewstamped Replication (VR Revisited)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N) por requisicao | Tolerancia f falhas em 2f + 1 nós
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoViewstampedReplication) {
      println("==================================================")
      println("  SciAlgo: Viewstamped Replication (VR Revisited)")
      println("==================================================")

      #L O Viewstamped Replication (VR) foi pioneiro no modelo de replicacao
      #L primary-backup tolerante a falhas por consenso.
      #L Configuracao com 3 replicas (tolerancia f = 1):
      #L Replica 1: Primaria inicial (View 0)
      #L Replicas 2 e 3: Backups
      #L Status: 1 = NORMAL, 2 = VIEW_CHANGE, 3 = RECOVERY

      mut as int64: num_replicas = 3
      mut as int64: f_faults = 1

      mut as int64: view_number = 0
      mut as int64: op_number = 0
      mut as int64: commit_number = 0
      mut as int64: primary_id = 1
      mut as int64: status = 1 #L NORMAL

      println("1. Configuracao Inicial:")
      println("   View = " + view_number + " | Primaria = Replica " + primary_id + " | Status = NORMAL")

      #L ======================================================================
      #L Fase de Operacao Normal: Cliente envia Requisicao
      #L ======================================================================
      println("2. [Operacao Normal] Cliente envia Requisicao: OP_TRANSFER = 777")
      op_number = op_number + 1
      println("   Primaria incrementa op_number para " + op_number)
      println("   Primaria envia PREPARE(view=" + view_number + ", op=" + op_number + ", data=777) aos backups...")

      mut as int64: prepare_oks = 0
      mut as int64: b = 2
      infinite (b <= num_replicas) {
            #L Backup b recebe PREPARE e valida view_number
            println("   -> Backup " + b + " valida view " + view_number + " e envia PREPARE-OK")
            prepare_oks = prepare_oks + 1
            b = b + 1
      }

      #L Primaria aguarda f respostas PREPARE-OK
      route {
            prepare_oks >= f_faults ==> {
                  commit_number = op_number
                  println("3. [Commit da Operacao] Primaria recebeu " + prepare_oks + " PREPARE-OKs (>= f = " + f_faults + ").")
                  println("   Primaria avanca commit_number para " + commit_number + " e responde ao cliente.")
            }
            _ ==> {}
      }

      #L ======================================================================
      #L Fase de View-Change: Falha da Primaria
      #L ======================================================================
      println("--------------------------------------------------")
      println("4. [Falha Detectada] Primaria 1 falha! Backups disparam View-Change.")
      status = 2 #L VIEW_CHANGE
      view_number = view_number + 1
      #L Nova primaria pela formula determinstica: (view /r num_replicas) + 1
      mut as int64: new_primary_id = (view_number /r num_replicas) + 1
      println("   Transicao para View " + view_number + " | Nova Primaria designada: Replica " + new_primary_id)

      #L Backups enviam DO-VIEW-CHANGE a nova primaria
      println("   Backups enviam DO-VIEW-CHANGE com o ultimo log (op_number = " + op_number + ", commit = " + commit_number + ")")
      println("   Nova Primaria Replica " + new_primary_id + " consolida o estado mais recente.")
      println("   Nova Primaria envia START-VIEW(view=" + view_number + ", op=" + op_number + ") a todos os nós.")
      status = 1 #L Retorno para NORMAL
      primary_id = new_primary_id

      println("5. [Estado Restaurado em Modo Normal]")
      println("   View Atual: " + view_number)
      println("   Primaria Ativa: Replica " + primary_id)
      println("   Op Number Consolidado: " + op_number)
      println("   Commit Number: " + commit_number)
      println("   Status do Grupo: NORMAL")
      println("==================================================")
      println("  Viewstamped Replication Concluido com Exito!")
      println("==================================================")
}
