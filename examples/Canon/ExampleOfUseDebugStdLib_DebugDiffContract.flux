use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugDiffContract) {
      println("==================================================")
      println("  Exemplo: DebugDiffContract (Comparacao e Diffs)")
      println("==================================================")

      #L 1. Diff de Strings
      println("1. Diff Strings Iguais:      " + debugDiffString("Flux123", "Flux123"))
      println("2. Diff Strings Divergentes: " + debugDiffString("FluxA23", "FluxB23"))
      println("3. Diff Strings Tamanhos:    " + debugDiffString("Flux", "FluxLang"))

      #L 2. Diff de Listas
      mut as list of data: lista1 = [10, 20, 30]
      mut as list of data: lista2 = [10, 20, 30]
      mut as list of data: lista3 = [10, 99, 30]
      mut as list of data: lista4 = [10, 20]

      println("4. Diff Listas Iguais:       " + debugDiffList(lista1, lista2))
      println("5. Diff Listas Divergentes:  " + debugDiffList(lista1, lista3))
      println("6. Diff Listas Tamanhos:     " + debugDiffList(lista1, lista4))

      #L 3. Contagem de Divergencias
      println("7. Contagem Mismatches (0):  " + debugDiffCount(lista1, lista2))
      println("   Contagem Mismatches (1):  " + debugDiffCount(lista1, lista3))
}
