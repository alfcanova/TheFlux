#L ============================================================================
#L Algoritmo: Dijkstra-Scholten Termination Detection Algorithm (1980)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(M) mensagens de controle onde M e o numero de mensagens basicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoDijkstraScholten) {
      println("==================================================")
      println("  SciAlgo: Dijkstra-Scholten Termination Detection")
      println("==================================================")

      #L O algoritmo de Dijkstra-Scholten detecta o termino de computacoes
      #L difusoras (diffusing computations) atraves de uma arvore de controle dinamica.
      #L Cada nó mantem um contador de deficit (mensagens enviadas sem ACK)
      #L e um ponteiro para o nó pai que o ativou.
      #L Um nó so envia ACK ao pai quando estiver PASSIVO e com deficit = 0.

      mut as int64: num_nodes = 4 #L No 1 (Raiz/Ambiente), No 2, No 3, No 4

      #L Estados: 1 = ATIVO, 0 = PASSIVO
      mut as list of int64: states = [1, 0, 0, 0]
      mut as list of int64: parent = [0, 0, 0, 0]
      mut as list of int64: deficit = [0, 0, 0, 0]

      println("1. Estado Inicial:")
      println("   No 1 (Raiz) e o iniciador ativo da computacao difusora.")

      #L ======================================================================
      #L Fase de Difusao: No 1 envia mensagens basicas para No 2 e No 3
      #L ======================================================================
      println("2. [Difusao de Tarefas]:")

      #L No 1 -> No 2
      deficit[1] = deficit[1] + 1
      states[2] = 1
      parent[2] = 1
      println("   -> No 1 envia tarefa para No 2 (Deficit No 1 = " + deficit[1] + ", Pai No 2 = No 1)")

      #L No 1 -> No 3
      deficit[1] = deficit[1] + 1
      states[3] = 1
      parent[3] = 1
      println("   -> No 1 envia tarefa para No 3 (Deficit No 1 = " + deficit[1] + ", Pai No 3 = No 1)")

      #L No 2 difunde subtarefa para No 4
      deficit[2] = deficit[2] + 1
      states[4] = 1
      parent[4] = 2
      println("   -> No 2 envia subtarefa para No 4 (Deficit No 2 = " + deficit[2] + ", Pai No 4 = No 2)")

      #L ======================================================================
      #L Fase de Conclusao e Retorno de ACKs
      #L ======================================================================
      println("--------------------------------------------------")
      println("3. [Conclusao e Envio de Acks]:")

      #L No 4 conclui trabalho local
      states[4] = 0 #L Passivo
      println("   -> No 4 conclui seu trabalho local (status = PASSIVO).")
      println("   -> Como Deficit de No 4 e 0, envia ACK ao pai (No 2) e desfaz aresta.")
      deficit[2] = deficit[2] - 1
      parent[4] = 0

      #L No 2 conclui trabalho local
      states[2] = 0 #L Passivo
      println("   -> No 2 conclui seu trabalho local (status = PASSIVO).")
      println("   -> Deficit de No 2 atingiu 0! Envia ACK ao pai (No 1) e desfaz aresta.")
      deficit[1] = deficit[1] - 1
      parent[2] = 0

      #L No 3 conclui trabalho local
      states[3] = 0 #L Passivo
      println("   -> No 3 conclui seu trabalho local (status = PASSIVO).")
      println("   -> Deficit de No 3 e 0! Envia ACK ao pai (No 1) e desfaz aresta.")
      deficit[1] = deficit[1] - 1
      parent[3] = 0

      #L No 1 conclui seu trabalho de raiz
      states[1] = 0
      println("   -> No 1 (Raiz) conclui trabalho proprio (status = PASSIVO).")

      #L ======================================================================
      #L Deteccao de Termino Global
      #L ======================================================================
      println("==================================================")
      println("4. [Verificacao de Termino Global]")
      println("   Status da Raiz: PASSIVO")
      println("   Deficit da Raiz: " + deficit[1])

      route {
            deficit[1] == 0 ==> {
                  println("   ARVORE DE COMPUTACAO COMPLETAMENTE DISSOLVIDA!")
                  println("   Termino Global Detectado com Sucesso pela Raiz!")
            }
            _ ==> {
                  println("   Computacao ainda em andamento.")
            }
      }
      println("==================================================")
}
