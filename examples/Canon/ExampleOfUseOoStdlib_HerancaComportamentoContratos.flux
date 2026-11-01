use AgentOfOoStdLib_CachorroMultiContrato

program (ExampleOfUseOoStdlib_HerancaComportamentoContratos) {
      println("==================================================")
      println("  1.B. Heranca de Comportamento: Contratos Multiplos")
      println("==================================================")

      mut as string: pet = "Thor"

      #L 1. Operacao herdada do contrato Animal
      mut as string: som = emitirSom(pet)
      println("1. Comportamento Animal: " + som)

      #L 2. Operacao herdada do contrato Domesticavel
      mut as string: passeio = passear(pet, "Parque Ibirapuera")
      println("2. Comportamento Domesticavel: " + passeio)

      #L 3. Operacao herdada do contrato Vacinavel
      mut as string: vacina = registrarVacina(pet, "Antirrabica")
      println("3. Comportamento Vacinavel: " + vacina)
}
