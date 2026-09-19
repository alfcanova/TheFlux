use StructStdLib

struct (Evento) {
      mut: .nome: string
      imut: .QUANDO: int64
      mut: .contador: int64
}

program (ExampleOfUseStructStdLib_StructIntrospectionContract) {
      println("==================================================")
      println("  Exemplo: StructIntrospectionContract")
      println("==================================================")

      mut as Evento: ev = Evento(
            .nome: "Conferencia"
            .QUANDO: 1726600000
            .contador: 42
      )

      #L 1. Verificacao de existencia do tipo struct
      println("1. ev e struct: " + structIsStruct(ev))
      println("   Texto e struct: " + structIsStruct("apenas um texto"))

      #L 2. Verificacao se valor e instancia de struct
      println("2. ev e instancia de Evento: " + structIsInstance(ev, "Evento"))
      println("   ev e instancia de Transacao: " + structIsInstance(ev, "Transacao"))

      #L 3. Verificacao de campo existente na instancia
      println("3. ev possui campo 'nome': " + structHasField(ev, "nome"))
      println("   ev possui campo 'inexistente': " + structHasField(ev, "inexistente"))

      #L 4. Lista de campos e contagem
      mut as list of data: campos = structFields("Evento")
      println("4. Campos de Evento: " + campos)
      println("   Total de campos: " + structFieldCount("Evento"))

      #L 5. Inferencia de tipo de campo
      println("5. Tipo do campo 'nome': " + structFieldType("Evento", "nome"))
      println("   Tipo do campo 'QUANDO': " + structFieldType("Evento", "QUANDO"))

      #L 6. Inspecao de mutabilidade de campos
      println("6. Campo 'nome' e mutavel: " + structIsFieldMutable("Evento", "nome"))
      println("   Campo 'QUANDO' e mutavel: " + structIsFieldMutable("Evento", "QUANDO"))

      #L 7. Particionamento entre campos mutaveis e imutaveis
      mut as list of data: mutaveis = structMutableFields("Evento")
      mut as list of data: imutaveis = structImmutableFields("Evento")
      println("7. Campos mutaveis: " + mutaveis)
      println("   Campos imutaveis: " + imutaveis)
}
