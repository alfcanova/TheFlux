#L Exemplo de Uso: CombinatoricsContract (Analise Combinatoria Completa)
use MathStdLib as M

program (ExampleOfUseMathStdLib_CombinatoricsContract) {
      print("==================================================")
      print("  Exemplo: CombinatoricsContract (64, 32, 16)     ")
      print("==================================================")
      print("--- Fatorial ---")
      print("factorial64(5): " + ((factorial64(5)).val as string))
      print("factorial32(5): " + ((factorial32(5 as int32)).val as string))
      print("factorial16(5): " + ((factorial16(5 as int16)).val as string))

      print("--- Arranjos Simples ---")
      print("arrangements64(5, 3) [A(5,3) = 60]: " + ((arrangements64(5, 3)).val as string))
      print("arrangements32(5, 3): " + ((arrangements32(5 as int32, 3 as int32)).val as string))
      print("arrangements16(5, 3): " + ((arrangements16(5 as int16, 3 as int16)).val as string))

      print("--- Arranjos com Repeticao ---")
      print("arrangementsWithRepetition64(5, 3) [AR(5,3) = 5^3 = 125]: " + ((arrangementsWithRepetition64(5, 3)).val as string))
      print("arrangementsWithRepetition32(5, 3): " + ((arrangementsWithRepetition32(5 as int32, 3 as int32)).val as string))
      print("arrangementsWithRepetition16(5, 3): " + ((arrangementsWithRepetition16(5 as int16, 3 as int16)).val as string))

      print("--- Combinacoes Simples ---")
      print("combinations64(5, 3) [C(5,3) = 10]: " + ((combinations64(5, 3)).val as string))
      print("combinations32(5, 3): " + ((combinations32(5 as int32, 3 as int32)).val as string))
      print("combinations16(5, 3): " + ((combinations16(5 as int16, 3 as int16)).val as string))

      print("--- Combinacoes com Repeticao ---")
      print("combinationsWithRepetition64(5, 3) [CR(5,3) = C(7,3) = 35]: " + ((combinationsWithRepetition64(5, 3)).val as string))
      print("combinationsWithRepetition32(5, 3): " + ((combinationsWithRepetition32(5 as int32, 3 as int32)).val as string))
      print("combinationsWithRepetition16(5, 3): " + ((combinationsWithRepetition16(5 as int16, 3 as int16)).val as string))

      print("--- Permutacoes Simples ---")
      print("permutations64(5, 3) [P(5,3) = A(5,3) = 60]: " + ((permutations64(5, 3)).val as string))
      print("permutations32(5, 3): " + ((permutations32(5 as int32, 3 as int32)).val as string))
      print("permutations16(5, 3): " + ((permutations16(5 as int16, 3 as int16)).val as string))

      print("--- Permutacoes com Repeticao ---")
      print("permutationsWithRepetition64(5, 3) [PR(5,3) = C(5,3) = 10]: " + ((permutationsWithRepetition64(5, 3)).val as string))
      print("permutationsWithRepetition32(5, 3): " + ((permutationsWithRepetition32(5 as int32, 3 as int32)).val as string))
      print("permutationsWithRepetition16(5, 3): " + ((permutationsWithRepetition16(5 as int16, 3 as int16)).val as string))

      print("--- GCD (MDC) & LCM (MMC) ---")
      print("greatestCommonDivisor64(54, 24): " + ((greatestCommonDivisor64(54, 24)).val as string))
      print("greatestCommonDivisor32(54, 24): " + ((greatestCommonDivisor32(54 as int32, 24 as int32)).val as string))
      print("greatestCommonDivisor16(54, 24): " + ((greatestCommonDivisor16(54 as int16, 24 as int16)).val as string))
      print("leastCommonMultiple64(54, 24): " + ((leastCommonMultiple64(54, 24)).val as string))
      print("leastCommonMultiple32(54, 24): " + ((leastCommonMultiple32(54 as int32, 24 as int32)).val as string))
      print("leastCommonMultiple16(54, 24): " + ((leastCommonMultiple16(54 as int16, 24 as int16)).val as string))
      print("==================================================")
}
