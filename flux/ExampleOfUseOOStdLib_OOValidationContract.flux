use OoStdLib

struct (Dispositivo) {
      mut: .id: string
      mut: .ativo: bool
}

program (ExampleOfUseOoStdLib_OOValidationContract) {
      println("==================================================")
      println("  Exemplo: OOValidationContract (Validacoes OO)")
      println("==================================================")

      mut as Dispositivo: d1 = Dispositivo(.id: "DSP-001", .ativo: true)
      mut as Dispositivo: d2 = Dispositivo(.id: "DSP-001", .ativo: true)
      mut as Dispositivo: d3 = Dispositivo(.id: "DSP-002", .ativo: false)

      #L 1. Checagem de implementacao de contrato
      mut as bool: imp_conectavel = ooImplements(d1, "Conectavel")
      println("1. Dispositivo implementa Conectavel: " + imp_conectavel)

      #L 2. Checagem em lote de multiplos contratos
      mut as list of data: contratos_necessarios = ["Conectavel", "Monitoravel"]
      mut as bool: imp_todos = ooImplementsAll(d1, contratos_necessarios)
      println("2. Dispositivo implementa todos os contratos: " + imp_todos)

      #L 3. Checagem de existencia de metodo
      mut as bool: tem_conectar = ooHasMethod(d1, "conectar")
      println("3. Dispositivo possui metodo conectar: " + tem_conectar)

      #L 4. Checagem de tipo concreto (ooIsInstance)
      mut as bool: eh_dispositivo = ooIsInstance(d1, "Dispositivo")
      println("4. Objeto eh instancia de Dispositivo: " + eh_dispositivo)
      mut as bool: eh_servidor = ooIsInstance(d1, "Servidor")
      println("   Objeto eh instancia de Servidor: " + eh_servidor)

      #L 5. Criacao de objeto polimorfico e validacao de invariantes
      mut as data: obj1 = ooCastToContract(d1, "Conectavel")
      mut as data: obj2 = ooCastToContract(d2, "Conectavel")
      mut as data: obj3 = ooCastToContract(d3, "Conectavel")

      println("5. Objeto polimorfico 1 eh valido: " + ooIsValid(obj1))
      println("   Validacao de contrato 1: " + ooValidateContract(obj1))

      #L 6. Guarda de tipo de objeto polimorfico (ooIsObject)
      println("6. obj1 eh envelope polimorfico: " + ooIsObject(obj1))
      println("   d1 puro eh envelope polimorfico: " + ooIsObject(d1))

      #L 7. Comparacao de igualdade polimorfica entre dois objetos
      println("7. Objeto 1 eh igual ao Objeto 2: " + ooEquals(obj1, obj2))
      println("   Objeto 1 eh igual ao Objeto 3: " + ooEquals(obj1, obj3))
}
