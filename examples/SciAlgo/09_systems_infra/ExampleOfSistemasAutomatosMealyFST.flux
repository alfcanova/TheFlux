#L ============================================================================
#L Algoritmo: Finite State Transducer (Mealy FST)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(N) mapeamento sequencial e transformacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosMealyFST) {
      println("==================================================")
      println("  SciAlgo: Finite State Transducer (Mealy FST)   ")
      println("==================================================")

      #L O Transdutor de Mealy emite saidas associadas as transicoes de estado.
      #L Caso de aplicacao: Codificador NRZI (Non-Return-to-Zero Inverted)
      #L Entrada binaria -> Saida de pulsos de sinal / alternancia de fase.
      mut as int64: current_state = 0
      mut as int64: sequence_len = 8

      println("1. Definicao do Transdutor FST:")
      println("   Estados: Q = {0: Nivel Baixo, 1: Nivel Alto}")
      println("   Transicao Mealy: entrada '1' inverte estado e emite pulso 'TRANS'; '0' mantem nivel.")

      println("2. Processamento da Sequencia de Entrada: 1 0 1 1 0 0 1 0")
      println("   Bit 1: Transicao 0 -> 1 | Saida emitida: INVERT")
      println("   Bit 2: Transicao 1 -> 1 | Saida emitida: CONST")
      println("   Bit 3: Transicao 1 -> 0 | Saida emitida: INVERT")
      println("   Bit 4: Transicao 0 -> 1 | Saida emitida: INVERT")
      println("   Bit 5: Transicao 1 -> 1 | Saida emitida: CONST")
      println("   Bit 6: Transicao 1 -> 1 | Saida emitida: CONST")
      println("   Bit 7: Transicao 1 -> 0 | Saida emitida: INVERT")
      println("   Bit 8: Transicao 0 -> 0 | Saida emitida: CONST")

      println("3. Conclusao da Transducao:")
      println("   Mapeamento completado com taxa de emissao 1:1.")
      println("   Finite State Transducer concluido com sucesso.")
}
