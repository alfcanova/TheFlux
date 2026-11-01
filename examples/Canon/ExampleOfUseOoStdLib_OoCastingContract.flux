use OoStdLib

struct (Sensor) {
      mut: .modelo: string
      mut: .leitura: float64
}

program (ExampleOfUseOoStdLib_OOCastingContract) {
      println("==================================================")
      println("  Exemplo: OOCastingContract (Upcast e Downcast)")
      println("==================================================")

      mut as Sensor: s = Sensor(.modelo: "DHT22", .leitura: 24.8)

      #L 1. Upcasting para Contrato (ooCastToContract)
      mut as data: obj_contrato = ooCastToContract(s, "Leitor")
      println("1. Upcast realizado para o contrato: " + ooContractName(obj_contrato))
      println("   Tipo subjacente preservado: " + ooUnderlyingType(obj_contrato))

      #L 2. Checagem prévia de compatibilidade de downcast (ooCanDowncast)
      mut as bool: pode_sensor = ooCanDowncast(obj_contrato, "Sensor")
      mut as bool: pode_atuador = ooCanDowncast(obj_contrato, "Atuador")
      println("2. Pode fazer downcast para Sensor: " + pode_sensor)
      println("   Pode fazer downcast para Atuador: " + pode_atuador)

      #L 3. Downcasting Seguro Bem-Sucedido (ooDowncast)
      mut as data: res_downcast = ooDowncast(obj_contrato, "Sensor")
      println("3. Status do downcast correto: " + res_downcast.sta)
      println("   Dado recuperado: " + res_downcast.val)

      #L 4. Desempacotamento direto sem checagem de tipo (ooUnwrap)
      mut as data: res_unwrap = ooUnwrap(obj_contrato)
      println("4. Status do unwrap direto: " + res_unwrap.sta)
      println("   Dado extraido via unwrap: " + res_unwrap.val)

      #L 5. Downcasting Seguro para Tipo Incompativel (Protecao contra falha)
      mut as data: res_invalido = ooDowncast(obj_contrato, "Atuador")
      println("5. Status de tentativa para tipo incorreto: " + res_invalido.sta)
      println("   Mensagem explicativa: " + res_invalido.msg)
}
