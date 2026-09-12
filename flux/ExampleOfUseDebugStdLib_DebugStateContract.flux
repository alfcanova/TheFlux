use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugStateContract) {
      println("==================================================")
      println("  Exemplo: DebugStateContract (Maquinas de Estado)")
      println("==================================================")

      #L 1. Transicoes de Estado (FSM)
      println("1. " + debugStateTransition("Pedido", "Criado", "Processando", "ConfirmarPagamento"))
      println("2. " + debugStateTransition("Pedido", "Processando", "Entregue", "DespacharEnvio"))

      #L 2. Auditoria de Estados Permitidos
      mut as list of data: estados_validos = ["Criado", "Processando", "Entregue", "Cancelado"]
      println("3. Estado 'Processando' eh valido? " + debugStateAudit("Processando", estados_validos))
      println("4. Estado 'Invalido' eh valido?    " + debugStateAudit("Invalido", estados_validos))

      #L 3. Rastro Historico (Breadcrumbs)
      mut as string: trilha = ""
      trilha = debugBreadcrumb(trilha, "InicioRequisicao")
      trilha = debugBreadcrumb(trilha, "AutenticarUsuario")
      trilha = debugBreadcrumb(trilha, "ProcessarPedido")
      trilha = debugBreadcrumb(trilha, "Finalizar")
      println("5. Trilha de Execucao: " + trilha)
}
