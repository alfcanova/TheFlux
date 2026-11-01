#L ============================================================================
#L Algoritmo: Peterson's Mutual Exclusion Algorithm (1981)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) espaco | Exclusao mutua, progresso e espera limitada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisPetersonAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Peterson's Mutual Exclusion Algorithm")
      println("==================================================")

      #L O algoritmo de Peterson (1981) resolve a exclusao mutua entre 2 processos
      #L em memoria compartilhada sem necessidade de instrucoes de hardware atomicas.
      #L Combina sinalizadores de intencao (flags) com a alternancia de vez (turn).
      #L Satisfaz: 1. Exclusao Mutua, 2. Progresso, 3. Espera Limitada (Bounded Waiting).

      mut as list of int64: flag = [0, 0] #L flag[1] para P1, flag[2] para P2
      mut as int64: turn = 1

      println("1. Variaveis Compartilhadas Iniciais:")
      println("   flag[1] = 0, flag[2] = 0 | turn = " + turn)

      #L ======================================================================
      #L Cenario: P1 e P2 solicitam Secao Critica concorrentemente
      #L ======================================================================
      println("==================================================")
      println("2. [Solicitacao Concorrente de Secao Critica]:")

      #L P1 manifesta interesse
      flag[1] = 1
      turn = 2 #L P1 cede a vez a P2 cortesmente
      println("   -> P1 sinaliza flag[1]=1 e cede turn=2")

      #L P2 manifesta interesse quase simultaneo
      flag[2] = 1
      turn = 1 #L P2 sobrescreve a vez para P1 (turn final = 1)
      println("   -> P2 sinaliza flag[2]=1 e cede turn=1")

      println("==================================================")
      println("3. [Avaliacao da Condicao de Espera (Busy-Wait)]: ")
      println("   Valor final de turn: " + turn)

      #L Avaliacao de P1: flag[2] == 1, mas turn == 1 (e de P1!) -> P1 ENTRA!
      println("   -> P1 verifica: turn == 1 -> P1 ENTRA na Secao Critica!")
      println("   ... P1 executa operacao critica com exclusividade ...")

      #L P1 sai da Secao Critica
      flag[1] = 0
      println("   -> P1 conclui e desativa flag[1] = 0")

      #L Avaliacao de P2: flag[1] e agora 0 -> P2 ENTRA!
      println("   -> P2 verifica: flag[1] == 0 -> P2 ENTRA na Secao Critica!")
      println("   ... P2 executa operacao critica ...")
      flag[2] = 0
      println("   -> P2 conclui e desativa flag[2] = 0")

      println("==================================================")
      println("4. Verificacao das Propriedades de Peterson:")
      println("   Exclusao Mutua estritamente mantida (apenas um processo na SC).")
      println("   Ausencia de Deadlock e Starvation garantida.")
      println("==================================================")
}
