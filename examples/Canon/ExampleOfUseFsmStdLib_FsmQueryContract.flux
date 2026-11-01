use FsmStdLib

program (ExampleOfUseFsmStdLib_FsmQueryContract) {
      println("==================================================")
      println("  Exemplo: FsmQueryContract (Consultas em FSM)")
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

      #L 1. Pertencimento de Estado
      println("1. Possui estado 'Rascunho': " + fsmHasState(fsm, "Rascunho"))
      println("   Possui estado 'Inexistente': " + fsmHasState(fsm, "Inexistente"))

      #L 2. Pertencimento de Evento
      println("2. Possui evento 'aprovar': " + fsmHasEvent(fsm, "aprovar"))
      println("   Possui evento 'voar': " + fsmHasEvent(fsm, "voar"))

      #L 3. Verificacao de Estado Inicial e Final
      println("3. 'Rascunho' eh inicial: " + fsmIsInitial(fsm, "Rascunho"))
      println("   'Aprovado' eh inicial: " + fsmIsInitial(fsm, "Aprovado"))
      println("   'Aprovado' eh final: " + fsmIsFinal(fsm, "Aprovado"))
      println("   'Rascunho' eh final: " + fsmIsFinal(fsm, "Rascunho"))

      #L 4. Viabilidade de Transicao (Uso de Ouro em Contratos)
      mut as bool: pode_enviar = fsmCanTransition(fsm, "Rascunho", "enviar")
      mut as bool: pode_aprovar = fsmCanTransition(fsm, "Rascunho", "aprovar")
      println("4. Pode transicionar 'Rascunho' via 'enviar': " + pode_enviar)
      println("   Pode transicionar 'Rascunho' via 'aprovar': " + pode_aprovar)

      #L 5. Proximo Estado Seguro (Lookahead)
      mut as string: prox_ok = fsmNextState(fsm, "Rascunho", "enviar")
      mut as string: prox_invalido = fsmNextState(fsm, "Rascunho", "aprovar")
      println("5. Proximo estado de 'Rascunho' + 'enviar': " + prox_ok)
      println("   Proximo estado de 'Rascunho' + 'aprovar': '" + prox_invalido + "'")

      #L 6. Eventos e Estados Permitidos
      mut as list of data: evs_disp = fsmAllowedEvents(fsm, "Rascunho")
      mut as list of data: prox_disp = fsmNextStates(fsm, "Rascunho")
      println("6. Eventos permitidos a partir de 'Rascunho': " + evs_disp)
      println("   Estados alcancaveis em 1 passo: " + prox_disp)

      #L 7. Alcancabilidade Orientada (Grafo de Transicoes)
      mut as bool: alcanca_aprovado = fsmIsReachable(fsm, "Rascunho", "Aprovado")
      mut as bool: alcanca_reverso = fsmIsReachable(fsm, "Rejeitado", "Aprovado")
      println("7. De 'Rascunho' alcanca 'Aprovado': " + alcanca_aprovado)
      println("   De 'Rejeitado' alcanca 'Aprovado': " + alcanca_reverso)
}
