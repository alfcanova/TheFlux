use FsmStdLib

program (ExampleOfUseFsmStdLib_FsmAuditContract) {
      println("==================================================")
      println("  Exemplo: FsmAuditContract (Auditoria de FSM)")
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

      #L 1. Construcao de Trilha de Auditoria (Audit Trail)
      mut as list of data: historico = []
      historico = fsmAuditTrail(historico, "Rascunho")
      historico = fsmAuditTrail(historico, "EmAnalise")
      historico = fsmAuditTrail(historico, "Aprovado")
      println("1. Trilha de Auditoria Gerada: " + historico)

      #L 2. Metricas do Historico
      println("2. Tamanho do Historico: " + fsmHistoryLength(historico))
      println("   Ultimo Estado Atingido: " + fsmHistoryLast(historico))

      #L 3. Validacao Formal da Sequencia de Estados (Compliance)
      mut as bool: historico_valido = fsmHistoryValidate(fsm, historico)
      println("3. Sequencia cronologica eh permitida pelas regras: " + historico_valido)

      #L 4. Deteccao de Trilha Invalida (Salto proibido sem passar por EmAnalise)
      mut as list of data: historico_ilegal = ["Rascunho", "Aprovado"]
      mut as bool: fraude_detectada = not fsmHistoryValidate(fsm, historico_ilegal)
      println("4. Trilha ilegal ['Rascunho' -> 'Aprovado'] rejeitada: " + fraude_detectada)
}
