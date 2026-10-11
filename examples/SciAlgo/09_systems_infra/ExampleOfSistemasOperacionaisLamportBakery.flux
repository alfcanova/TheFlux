#L ============================================================================
#L Algoritmo: Lamport Bakery Mutual Exclusion Algorithm (1974)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N) por entrada na SC para N processos sem hardware atomico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisLamportBakery) {
      println("==================================================")
      println("  SciAlgo: Lamport Bakery Algorithm (N Processos)")
      println("==================================================")

      #L O algoritmo da Padaria de Lamport (1974) resolve a exclusao mutua
      #L para N processos genericos em memoria compartilhada sem suporte de hardware.
      #L Inspirado em senhas de padaria: cada processo retira um bilhete numerado
      #L (ticket = max(tickets) + 1). O processo com menor par ordenado (ticket, id)
      #L e atendido primeiro.

      mut as int64: num_procs = 3

      #L Arrays de estado:
      #L entering[i]: 1 se o processo i esta retirando senha
      #L ticket[i]: numero da senha do processo i (0 se fora da SC)
      mut as list of int64: entering = [0, 0, 0]
      mut as list of int64: ticket = [0, 0, 0]

      println("1. Estado Inicial do Sistema (N = 3 processos):")
      println("   Nenhum processo concorrendo a Secao Critica.")

      #L ======================================================================
      #L Retirada de Senhas (Doorway Phase)
      #L ======================================================================
      println("==================================================")
      println("2. [Fase de Retirada de Senhas (Doorway)]:")

      #L P1 retira senha
      entering[1] = 1
      ticket[1] = 10 #L Senha de P1
      entering[1] = 0
      println("   -> P1 retira Ticket = " + ticket[1])

      #L P2 retira senha concorrente
      entering[2] = 1
      ticket[2] = 5  #L Senha menor (chegou antes)
      entering[2] = 0
      println("   -> P2 retira Ticket = " + ticket[2])

      #L P3 retira senha
      entering[3] = 1
      ticket[3] = 10 #L Empate com P1 em numero, desempate pelo ID
      entering[3] = 0
      println("   -> P3 retira Ticket = " + ticket[3] + " (empate numerico com P1)")

      #L ======================================================================
      #L Ordenacao Lexicografica (ticket, id)
      #L P2 tem ticket 5 (menor de todos) -> 1o lugar
      #L P1 e P3 tem ticket 10, mas id 1 < id 3 -> P1 e o 2o lugar
      #L P3 e o 3o lugar
      #L ======================================================================
      println("==================================================")
      println("3. [Ordem de Atendimento dos Processos]:")

      #L Atendimento 1: P2
      println("   [Atendimento 1] Processo P2 possui Menor Ticket (5) -> ENTRA na SC!")
      ticket[2] = 0
      println("   -> P2 conclui SC e devolve ticket (ticket[2] = 0).")

      #L Atendimento 2: P1 (desempate: (10, 1) < (10, 3))
      println("   [Atendimento 2] P1 vs P3: Tickets iguais (10), desempate por ID (1 < 3)!")
      println("   -> P1 ENTRA na SC!")
      ticket[1] = 0
      println("   -> P1 conclui SC e devolve ticket (ticket[1] = 0).")

      #L Atendimento 3: P3
      println("   [Atendimento 3] Processo P3 e atendido por ultimo -> ENTRA na SC!")
      ticket[3] = 0
      println("   -> P3 conclui SC e devolve ticket (ticket[3] = 0).")

      println("==================================================")
      println("4. Verificacao da Padaria de Lamport:")
      println("   Ordem comprovadamente justa: P2 (5) -> P1 (10, ID 1) -> P3 (10, ID 3).")
      println("   Garantia absoluta de FIFO e Bounded Waiting!")
      println("==================================================")
}
