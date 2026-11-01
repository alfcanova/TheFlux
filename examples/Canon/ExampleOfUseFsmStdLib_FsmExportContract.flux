use FsmStdLib

program (ExampleOfUseFsmStdLib_FsmExportContract) {
      println("==================================================")
      println("  Exemplo: FsmExportContract (Exportacao Mermaid)")
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

      #L 1. Exportacao para formato Mermaid (stateDiagram-v2)
      mut as string: mermaid_code = fsmToMermaid(fsm)
      println("1. Diagrama Mermaid Gerado:\n")
      println(mermaid_code)
}
