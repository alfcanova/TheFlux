struct (ContaBancaria) {
      imut: .NUMERO_CONTA: int64
      imut: .TITULAR: string
      mut: .saldo: float64
      mut: .bloqueada: bool
}

program (ExampleOfUseOoStdlib_EncapsulamentoImutabilidadeCampos) {
      println("==================================================")
      println("  3.A. Encapsulamento: Imutabilidade (imut vs mut)")
      println("==================================================")

      #L Criacao da conta bancaria com campos protegidos a nivel de memoria
      mut as ContaBancaria: conta = ContaBancaria(
            .NUMERO_CONTA: 10029384
            .TITULAR: "Alice Ferreira"
            .saldo: 5000.00
            .bloqueada: false
      )

      #L 1. Acesso aos campos imutaveis (imut) - Garantia de Integridade
      println("1. Campos Imutaveis Blindados:")
      println("   Numero da Conta (imut): " + conta.NUMERO_CONTA)
      println("   Titular (imut): " + conta.TITULAR)

      #L 2. Acesso e alteracao aos campos mutaveis permitidos (mut)
      println("\n2. Saldo Inicial (mut): R$ " + conta.saldo)
      conta.saldo = 5750.50
      println("   Saldo Apos Deposito: R$ " + conta.saldo)

      conta.bloqueada = true
      println("   Status de Bloqueio Alterado: " + conta.bloqueada)

      #L Nota de Arquitetura:
      #L Se o programador tentasse compilar 'conta.NUMERO_CONTA = 9999', o compilador
      #L TheFlux bloquearia imediatamente com erro semantico [SEM002: Mutability violation].
      println("\n3. Encapsulamento a nivel de compilador:")
      println("   Campos 'imut' sao gravados em segmentos de memoria somente-leitura.")
}
