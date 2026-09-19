use FsmStdLib

program (ExampleOfUseFsmStdLib_FsmDefinitionContract) {
      println("==================================================")
      println("  Exemplo: FsmDefinitionContract (Definicao de FSM)")
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

      #L 1. Criacao da FSM
      mut as map: fsm = fsmCreate(config)
      println("1. FSM criada com sucesso!")

      #L 2. Validacao Estrutural
      mut as bool: valida = fsmValidate(fsm)
      println("2. FSM eh valida: " + valida)

      #L 3. Estado Inicial
      mut as string: init_st = fsmInitialState(fsm)
      println("3. Estado Inicial: " + init_st)

      #L 4. Estados Finais
      mut as list of data: finals = fsmFinalStates(fsm)
      println("4. Estados Finais: " + finals)

      #L 5. Lista de Estados
      mut as list of data: sts = fsmStates(fsm)
      println("5. Todos os Estados: " + sts)

      #L 6. Lista de Eventos Unicos
      mut as list of data: evs = fsmEvents(fsm)
      println("6. Eventos Unicos: " + evs)
}
