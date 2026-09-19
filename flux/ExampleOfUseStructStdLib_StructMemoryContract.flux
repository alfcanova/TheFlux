use StructStdLib

struct (Evento) {
      mut: .nome: string
      imut: .QUANDO: int64
      mut: .contador: int64
}

program (ExampleOfUseStructStdLib_StructMemoryContract) {
      println("==================================================")
      println("  Exemplo: StructMemoryContract (Layout e Memoria)")
      println("==================================================")

      #L 1. Tamanho total da struct em bytes
      mut as int64: sz_evento = structSizeOf("Evento")
      println("1. Tamanho de Evento: " + sz_evento + " bytes")
      mut as int64: sz_transacao = structSizeOf("Transacao")
      println("   Tamanho de Transacao: " + sz_transacao + " bytes")

      #L 2. Requisito de alinhamento em bytes
      mut as int64: align_evento = structAlignOf("Evento")
      println("2. Alinhamento de Evento: " + align_evento + " bytes")

      #L 3. Offsets dos campos na memoria
      mut as int64: off_nome = structFieldOffset("Evento", "nome")
      mut as int64: off_quando = structFieldOffset("Evento", "QUANDO")
      mut as int64: off_contador = structFieldOffset("Evento", "contador")
      println("3. Offset do campo 'nome': " + off_nome)
      println("   Offset do campo 'QUANDO': " + off_quando)
      println("   Offset do campo 'contador': " + off_contador)
}
