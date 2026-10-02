use RuntimeStdLib

program (ExampleOfUseRuntimeStdLib_RuntimeTypeContract) {
      println("==================================================")
      println("  Exemplo: RuntimeTypeContract (Tipos e Metadados)")
      println("==================================================")

      mut as int64: n = 42
      mut as float64: pi = 3.14
      mut as bool: flag = true
      mut as string: msg = "flux"
      mut as list of data: l = [1, 2, 3]

      println("1. Tipo de inteiro: " + runtimeGetTypeName(n))
      println("2. Tipo de float: " + runtimeGetTypeName(pi))
      println("3. Tipo de bool: " + runtimeGetTypeName(flag))
      println("4. Tipo de string: " + runtimeGetTypeName(msg))
      println("5. Tipo de lista: " + runtimeGetTypeName(l))

      println("6. Inteiro e primitivo: " + runtimeIsPrimitive(n))
      println("7. Float e primitivo: " + runtimeIsPrimitive(pi))
      println("8. String e primitiva: " + runtimeIsPrimitive(msg))
      println("9. Lista e colecao: " + runtimeIsCollection(l))
      println("10. Lista nao e primitiva: " + (!runtimeIsPrimitive(l)))

      println("11. TypeId inteiro: " + runtimeGetTypeId(n))
      println("12. TypeId string: " + runtimeGetTypeId(msg))
      println("13. TypeId lista: " + runtimeGetTypeId(l))

      println("14. SizeOf inteiro (8 bytes): " + runtimeSizeOf(n))
      println("15. SizeOf float (8 bytes): " + runtimeSizeOf(pi))
      println("16. SizeOf bool (1 byte): " + runtimeSizeOf(flag))
      println("17. SizeOf string 'flux' (4 bytes): " + runtimeSizeOf(msg))

      mut as map: st_meta = runtimeGetStructMetadata("Usuario")
      println("18. Metadados struct nome: " + st_meta["name"])
      println("19. Metadados struct valido: " + st_meta["valid"])

      #L Aliases
      println("20. Alias getTypeName: " + getTypeName(n))
      println("21. Alias isPrimitive: " + isPrimitive(n))
      println("22. Alias isCollection: " + isCollection(l))
}
