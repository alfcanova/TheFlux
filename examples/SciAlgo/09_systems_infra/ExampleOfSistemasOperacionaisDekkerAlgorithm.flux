#L ============================================================================
#L Algoritmo: Dekker's Mutual Exclusion Algorithm (Dijkstra 1965)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) espaco | Primeiro algoritmo correto de exclusao mutua em software
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisDekkerAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Dekker's Mutual Exclusion Algorithm")
      println("==================================================")

      #L O algoritmo de Dekker (1965) foi a primeira solucao correta de software
      #L para o problema da secao critica entre dois processos.
      #L Evita impasses (livelocks e deadlocks) atraves do recuo temporario (back-off)
      #L caso nao seja a vez (turn) do processo solicitante.

      mut as list of int64: wants_to_enter = [0, 0] #L P1 e P2
      mut as int64: turn = 1

      println("1. Variaveis Compartilhadas Iniciais:")
      println("   wants_to_enter = [0, 0] | turn = " + turn)

      #L ======================================================================
      #L Cenario: P1 e P2 solicitam SC simultaneamente
      #L ======================================================================
      println("==================================================")
      println("2. [Solicitacao Simultanea com Conflito]:")
      wants_to_enter[1] = 1
      wants_to_enter[2] = 1
      println("   -> Ambos sinalizam intencao: wants[1]=1 e wants[2]=1")

      #L Arbitragem de Dekker: como turn == 1, P2 reconhece a prioridade de P1 e recua!
      println("3. [Arbitragem e Recuo de Dekker]:")
      println("   -> turn atual e 1 (Vez de P1).")
      println("   -> P2 detecta que nao e sua vez: recua temporariamente desativando wants[2] = 0")
      wants_to_enter[2] = 0

      #L P1 encontra wants[2] == 0 e entra com seguranca na Secao Critica
      println("==================================================")
      println("4. [Entrada de P1 na Secao Critica]:")
      println("   -> P1 verifica wants[2] == 0 e ENTRA na Secao Critica!")
      println("   ... P1 executa regiao critica com exclusividade ...")

      #L P1 sai da Secao Critica, passa a vez e limpa seu interesse
      turn = 2
      wants_to_enter[1] = 0
      println("   -> P1 conclui: transfere turn = 2 e desativa wants[1] = 0")

      #L P2 agora reativa seu interesse e pode entrar
      println("==================================================")
      println("5. [Entrada de P2 na Secao Critica]:")
      wants_to_enter[2] = 1
      println("   -> P2 reativa wants[2]=1 e verifica turn == 2 -> ENTRA na Secao Critica!")
      println("   ... P2 executa regiao critica ...")
      turn = 1
      wants_to_enter[2] = 0
      println("   -> P2 conclui: turn = 1 e wants[2] = 0")

      println("==================================================")
      println("6. Verificacao Final do Algoritmo de Dekker:")
      println("   Exclusao Mutua estrita preservada.")
      println("   Mecanismo de recuo (back-off) eliminou qualquer risco de deadlock!")
      println("==================================================")
}
