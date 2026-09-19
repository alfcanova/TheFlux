#L Exemplo de Uso: LowLevelBlockMemoryContract (Operacoes em Blocos de Memoria)
use LowLevelStdLib as Low

program (ExampleOfUseLowLevelStdLib_LowLevelBlockMemoryContract) {
      println("==================================================")
      println("  Exemplo: LowLevelBlockMemoryContract            ")
      println("==================================================")

      mut as map: mem = lowMemoryInit(512)

      #L 1. Inicializacao e Preenchimento em Bloco (memset)
      mem = lowMemorySet(mem, 10, 171, 4) #L 0xAB = 171 em 4 bytes
      println("1. lowMemoryDump(10, 4): " + lowMemoryDump(mem, 10, 4))

      #L 2. Copia em Bloco (memcpy)
      mem = lowMemoryCopy(mem, 10, 20, 4)
      println("2. Copia para endereco 20: " + lowMemoryDump(mem, 20, 4))

      #L 3. Comparacao de Blocos (memcmp)
      println("3. Comparacao addr 10 vs addr 20: " + lowMemoryCompare(mem, 10, 20, 4))
      mem = lowMemoryPokeByte(mem, 23, 172)
      println("   Comparacao apos alterar byte: " + lowMemoryCompare(mem, 10, 20, 4))

      #L 4. Limpeza de Memoria (memclear)
      mem = lowMemoryClear(mem, 10, 4)
      println("4. Apos clear addr 10: " + lowMemoryDump(mem, 10, 4))
}
