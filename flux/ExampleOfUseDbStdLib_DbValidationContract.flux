use DbStdLib

program (ExampleOfUseDbStdLib_DbValidationContract) {
      println("==================================================")
      println("  Exemplo: DbValidationContract (Validacao & Sanitizacao)")
      println("==================================================")

      mut as string: san = dbSanitizeIdentifier("tabela; DROP TABLE--")
      println("1. sanitizeIdentifier: " + san)

      mut as string: esc = dbEscapeString("Sant'Anna")
      println("2. escapeString: " + esc)

      mut as bool: val_ok = dbIsValidRecord({ .id: 1, .nome: "Alice" }, { .id: "int64", .nome: "string" })
      println("3. isValidRecord valido: " + val_ok)

      mut as bool: val_bad = dbIsValidRecord({ .id: "abc", .nome: "Alice" }, { .id: "int64", .nome: "string" })
      println("4. isValidRecord invalido: " + val_bad)

      #L Aliases
      println("5. Alias sanitizeIdentifier: " + sanitizeIdentifier("tabela; DROP TABLE--"))
      println("6. Alias escapeString: " + escapeString("Sant'Anna"))
      println("7. Alias isValidRecord: " + isValidRecord({ .id: 1, .nome: "Alice" }, { .id: "int64", .nome: "string" }))
}
