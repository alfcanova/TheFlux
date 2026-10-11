#L ============================================================================
#L Algoritmo: MPNN (Message Passing Neural Networks)
#L Dominio: 08_artificial_intel / Subdominio: Grafos para IA
#L Descricao: Paradigma unificado de message passing: Message, Aggregate e Update
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosMessagePassing) {
      println("=== Algoritmo: MPNN (Message Passing Neural Network) ===")

      #L Grafo: No 1 conectado aos vizinhos 2 e 3
      #L Features iniciais (escalares inteiros)
      mut as int64: h1 = 10
      mut as int64: h2 = 25
      mut as int64: h3 = 15

      #L Fase 1: Mensagens dos vizinhos (M_v = W * h_v, com W = 2)
      mut as int64: m2 = h2 * 2
      mut as int64: m3 = h3 * 2

      #L Fase 2: Agregacao (Soma das mensagens dos vizinhos)
      mut as int64: agg = m2 + m3

      #L Fase 3: Atualizacao do estado do no 1: h1_novo = h1 + agg / 2
      mut as int64: halfAgg = agg /i 2
      mut as int64: h1_novo = h1 + halfAgg

      println("1. Estado inicial do no 1: " + h1)
      println("2. Mensagem gerada pelo no 2: " + m2)
      println("3. Mensagem gerada pelo no 3: " + m3)
      println("4. Agregacao de mensagens recebidas: " + agg)
      println("5. Novo estado computado h1_novo: " + h1_novo)

      route {
            h1_novo == 50 ==> {
                  println("6. Propagacao MPNN validada com sucesso.")
            }
            _ ==> {
                  println("Falha na computacao MPNN.")
            }
      }
      println("Teste concluido com sucesso.")
}
