#L ============================================================================
#L Algoritmo: Huang Termination Detection Algorithm (Weight-Throwing, 1989)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(M) mensagens | Invariante de Conservacao de Peso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoHuangTerminationDetection) {
      println("==================================================")
      println("  SciAlgo: Huang Termination Detection (Weight-Throwing)")
      println("==================================================")

      #L O algoritmo de Huang (1989) detecta o encerramento de computacoes
      #L distribuidas atraves da conservacao de peso (weight-throwing).
      #L O iniciador (P0) comeca com o peso total W_TOTAL = 1.000.000 (ponto fixo).
      #L Sempre que um nó envia uma mensagem, ele divide seu peso pela metade
      #L e envia a outra metade anexada a mensagem.
      #L Ao ficar ocioso, qualquer nó devolve seu peso restante para P0.
      #L O termino global ocorre exatamente quando P0 recupera W_TOTAL!

      mut as int64: total_weight = 1000000
      mut as int64: num_nodes = 3 #L P0 (iniciador), P1 (worker 1), P2 (worker 2)

      mut as list of int64: weights = [1000000, 0, 0]
      mut as list of int64: active  = [1, 0, 0]

      println("1. Estado Inicial:")
      println("   Iniciador P1 possui Peso Total: " + weights[1] + " (100% do peso)")
      println("   Trabalhadores P2 e P3 estao ociosos (peso = 0).")

      #L ======================================================================
      #L Passo 1: P1 delega trabalho para P2 dividindo seu peso
      #L ======================================================================
      println("2. [Divisao e Envio de Peso P1 -> P2]")
      mut as int64: w_sent_1_2 = weights[1] /i 2 #L 500.000
      weights[1] = weights[1] - w_sent_1_2
      weights[2] = weights[2] + w_sent_1_2
      active[2] = 1
      println("   -> P1 retem " + weights[1] + " e envia " + w_sent_1_2 + " para P2.")
      println("   -> P2 torna-se ATIVO com peso " + weights[2])

      #L ======================================================================
      #L Passo 2: P2 delega subtarefa para P3 dividindo seu peso
      #L ======================================================================
      println("3. [Divisao e Envio de Peso P2 -> P3]")
      mut as int64: w_sent_2_3 = weights[2] /i 2 #L 250.000
      weights[2] = weights[2] - w_sent_2_3
      weights[3] = weights[3] + w_sent_2_3
      active[3] = 1
      println("   -> P2 retem " + weights[2] + " e envia " + w_sent_2_3 + " para P3.")
      println("   -> P3 torna-se ATIVO com peso " + weights[3])

      #L ======================================================================
      #L Invariante do Sistema
      #L ======================================================================
      mut as int64: current_sum = weights[1] + weights[2] + weights[3]
      println("4. [Verificacao do Invariante]: Peso Total = " + current_sum + " (Conserva 100%)")

      #L ======================================================================
      #L Retorno de Pesos conforme nós terminam o processamento
      #L ======================================================================
      println("--------------------------------------------------")
      println("5. [Conclusao e Devolucao de Peso para P1]:")

      #L P3 conclui e devolve seu peso para P1
      println("   -> P3 conclui processamento e devolve " + weights[3] + " para P1.")
      weights[1] = weights[1] + weights[3]
      weights[3] = 0
      active[3] = 0
      println("      Peso acumulado em P1: " + weights[1])

      #L P2 conclui e devolve seu peso para P1
      println("   -> P2 conclui processamento e devolve " + weights[2] + " para P1.")
      weights[1] = weights[1] + weights[2]
      weights[2] = 0
      active[2] = 0
      println("      Peso acumulado em P1: " + weights[1])

      #L P1 conclui seu trabalho local
      active[1] = 0
      println("   -> P1 conclui tarefas locais (status = OCIOSO).")

      #L ======================================================================
      #L Verificacao de Termino Global
      #L ======================================================================
      println("==================================================")
      println("6. [Deteccao Final de Termino]")
      println("   Peso Recuperado pelo Iniciador P1: " + weights[1] + " / " + total_weight)

      route {
            weights[1] == total_weight ==> {
                  println("   CONDICAO SATISFEITA: 100% do peso recuperado!")
                  println("   TERMINO GLOBAL DETECTADO COM SUCESSO!")
            }
            _ ==> {
                  println("   Sistema ainda possui tarefas pendentes.")
            }
      }
      println("==================================================")
}
