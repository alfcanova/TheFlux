use AgentOfOoStdLib_CofreSeguro

program (ExampleOfUseOoStdlib_EncapsulamentoModuloAgente) {
      println("==================================================")
      println("  3.B. Encapsulamento por Modulo e Agente")
      println("==================================================")

      mut as float64: saldo_cofre = 1000.00
      imut as int64: PIN_SECRETO = 4829

      println("1. Estado Inicial Protegido pelo Modulo:")
      println("   Saldo inicial: R$ " + saldo_cofre)

      #L 2. Operacao com passagem pelas regras do agente
      mut as data: res_dep = depositarSeguro(saldo_cofre, 500.00)
      println("\n2. Tentativa de Deposito de R$ 500.00:")
      println("   Status do agente: " + res_dep.sta)
      println("   Mensagem do agente: " + res_dep.msg)
      saldo_cofre = res_dep.val
      println("   Novo saldo atualizado: R$ " + saldo_cofre)

      #L 3. Tentativa de saque com PIN incorreto (rejeitado pelo encapsulamento)
      println("\n3. Tentativa de Saque com PIN Incorreto (9999):")
      mut as data: res_bloqueado = retirarSeguro(saldo_cofre, 200.00, 9999, PIN_SECRETO)
      println("   Status retornado: " + res_bloqueado.sta)
      println("   Mensagem de barreira de seguranca: " + res_bloqueado.msg)
      println("   Saldo permanece intacto: R$ " + saldo_cofre)

      #L 4. Saque com PIN correto (autorizado pelo encapsulamento)
      println("\n4. Saque Autenticado com PIN Correto:")
      mut as data: res_saque = retirarSeguro(saldo_cofre, 300.00, PIN_SECRETO, PIN_SECRETO)
      println("   Status retornado: " + res_saque.sta)
      println("   Mensagem: " + res_saque.msg)
      saldo_cofre = res_saque.val
      println("   Saldo final seguro no cofre: R$ " + saldo_cofre)
}
