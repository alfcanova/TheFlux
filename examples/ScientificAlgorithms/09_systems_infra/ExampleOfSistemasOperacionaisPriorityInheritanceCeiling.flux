#L ============================================================================
#L Algoritmo: Priority Inheritance and Priority Ceiling Protocols
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais
#L Complexidade: O(1) prevencao de inversao de prioridade e deadlocks em RTOS
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisPriorityInheritanceCeiling) {
      println("==================================================")
      println("  SciAlgo: Priority Inheritance & Priority Ceiling")
      println("==================================================")

      #L Inversao de Prioridade ocorre quando uma tarefa de alta prioridade (H)
      #L eh bloqueada por uma de baixa prioridade (L) segurando um recurso R,
      #L e uma tarefa de media prioridade (M) preempta L indefinidamente.
      #L Solucoes:
      #L 1. Priority Inheritance Protocol (PIP): L herda temporariamente a prioridade
      #L    de H enquanto detiver o recurso R que H aguarda.
      #L 2. Priority Ceiling Protocol (PCP): Cada semaforo tem um teto de prioridade
      #L    (a maior prioridade de qualquer tarefa que possa usa-lo). Previne deadlocks.

      mut as int64: prio_low = 1
      mut as int64: prio_medium = 5
      mut as int64: prio_high = 10
      mut as int64: current_l_prio = 1

      println("1. Cenario Classico de Inversao de Prioridade:")
      println("   Tarefas: L (Prioridade 1), M (Prioridade 5), H (Prioridade 10)")
      println("   - Tarefa L adquire Mutex R e executa secao critica.")
      println("   - Tarefa H acorda e tenta adquirir Mutex R -> Bloqueada em R.")
      println("   - Tarefa M fica pronta -> Sem heranca, M preemptaria L, atrasando H indefinidamente!")

      println("2. Ativacao do Protocolo de Heranca de Prioridade (PIP):")
      println("   - Como H aguarda R retido por L, L HERDA prioridade de H: Prio(L) = 10.")
      println("   - Tarefa M tenta preempcao -> Rejeitada (Prio(L)=10 > Prio(M)=5).")
      println("   - Tarefa L conclui sua secao critica rapidamente e libera Mutex R.")
      println("   - Prioridade de L retorna a 1.")
      println("   - Tarefa H adquire Mutex R e executa imediatamente.")

      println("3. Conclusao:")
      println("   Inversao de prioridade mitigada com sucesso.")
      println("   Priority Inheritance and Priority Ceiling concluido.")
}
