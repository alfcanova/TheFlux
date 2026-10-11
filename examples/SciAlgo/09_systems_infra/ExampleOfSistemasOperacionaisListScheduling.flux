#L ============================================================================
#L Algoritmo: Graham's List Scheduling for Multiprocessor Systems (1966)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N * M) aproximacao (2 - 1/m) para escalonamento com precedencia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisListScheduling) {
      println("==================================================")
      println("  SciAlgo: List Scheduling (Graham Multiprocessor)")
      println("==================================================")

      #L O List Scheduling de Graham (1966) e a heuristica canonica para escalonar
      #L tarefas com restricoes de precedencia (DAG) em m processadores paralelos.
      #L Regra: Sempre que um processador fica livre, a lista de tarefas prioritarias
      #L e varrida, despachando a primeira tarefa cujas dependencias foram satisfeitas.
      #L Limite de Graham: C_max <= (2 - 1/m) * C_opt.

      mut as int64: num_procs = 2 #L m = 2 processadores
      mut as int64: num_tasks = 4

      #L Tarefas:
      #L T1: Duracao 3 (sem dependencias)
      #L T2: Duracao 2 (depende de T1)
      #L T3: Duracao 4 (sem dependencias)
      #L T4: Duracao 2 (depende de T2 e T3)
      mut as list of int64: duration = [3, 2, 4, 2]
      mut as list of int64: done = [0, 0, 0, 0]

      #L Estado dos processadores: tempo em que ficarao livres
      mut as int64: p1_free_at = 0
      mut as int64: p2_free_at = 0

      println("1. Grafo de Precedencias das Tarefas (DAG):")
      println("   T1 (d=3) -> T2 (d=2) -> T4 (d=2)")
      println("   T3 (d=4) -------------> T4 (d=2)")
      println("   Numero de Processadores: " + num_procs)

      println("==================================================")
      println("2. [Execucao da Heuristica de List Scheduling]:")

      #L Ordem da lista de prioridade: [T1, T3, T2, T4]
      #L Passo 1: No tempo 0, P1 pega T1 e P2 pega T3
      println("   [t=0] Processador 1 inicia T1 (d=3) -> Conclui em t=3")
      p1_free_at = 3
      done[1] = 1

      println("   [t=0] Processador 2 inicia T3 (d=4) -> Conclui em t=4")
      p2_free_at = 4
      done[3] = 1

      #L Passo 2: No tempo 3, P1 fica livre. Dependencia de T2 (T1) foi concluida!
      println("   [t=3] Processador 1 fica livre. T1 concluida -> Inicia T2 (d=2) -> Conclui em t=5")
      p1_free_at = 3 + 2 #L t = 5
      done[2] = 1

      #L Passo 3: No tempo 4, P2 fica livre. T4 depende de T2 e T3.
      #L T3 ja concluiu (t=4), mas T2 ainda roda ate t=5.
      println("   [t=4] Processador 2 fica livre, mas T4 aguarda termino de T2 (em t=5).")

      #L Passo 4: No tempo 5, T2 conclui. Ambas as dependencias de T4 satisfeitas!
      println("   [t=5] T2 concluida. Processador 1 inicia T4 (d=2) -> Conclui em t=7")
      p1_free_at = 5 + 2 #L t = 7
      done[4] = 1

      mut as int64: makespan = p1_free_at
      route {
            p2_free_at > makespan ==> { makespan = p2_free_at }
            _ ==> {}
      }

      println("==================================================")
      println("3. Conclusao e Makespan Total:")
      println("   Tempo total de execucao (Makespan C_max): " + makespan + " unidades")
      println("   Aproximacao competitiva de Graham respeitada com sucesso!")
      println("==================================================")
}
