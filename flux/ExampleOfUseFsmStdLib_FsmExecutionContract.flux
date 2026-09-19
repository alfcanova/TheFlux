use FsmStdLib

program (ExampleOfUseFsmStdLib_FsmExecutionContract) {
      println("==================================================")
      println("  Exemplo: FsmExecutionContract (Execucao de FSM)")
      println("==================================================")

      mut as map: config = map{
            "initial": "Rascunho",
            "states": ["Rascunho", "EmAnalise", "Aprovado", "Rejeitado"],
            "finals": ["Aprovado", "Rejeitado"],
            "transitions": map{
                  "Rascunho": map{
                        "enviar": "EmAnalise",
                        "cancelar": "Rejeitado"
                  },
                  "EmAnalise": map{
                        "aprovar": "Aprovado",
                        "rejeitar": "Rejeitado"
                  }
            }
      }
      mut as map: fsm = fsmCreate(config)

      #L 1. Transicao Estrita Valida
      mut as string: st1 = fsmTransition(fsm, "Rascunho", "enviar")
      println("1. Transicao 1 ('Rascunho' + 'enviar'): " + st1)

      mut as string: st2 = fsmTransition(fsm, st1, "aprovar")
      println("2. Transicao 2 ('EmAnalise' + 'aprovar'): " + st2)
      println("   Chegou ao estado final: " + fsmIsFinal(fsm, st2))

      #L 2. Transicao Segura com fsmTryTransition (Branching sem emit fail)
      mut as list of data: try_ok = fsmTryTransition(fsm, "Rascunho", "enviar")
      println("3. Tentativa valida de transicao: " + try_ok)
      println("   Sucesso: " + try_ok[1] + " | Novo Estado: " + try_ok[2])

      mut as list of data: try_invalida = fsmTryTransition(fsm, "Rascunho", "aprovar")
      println("4. Tentativa invalida de transicao: " + try_invalida)
      println("   Sucesso: " + try_invalida[1] + " | Estado Mantido: " + try_invalida[2])
}
