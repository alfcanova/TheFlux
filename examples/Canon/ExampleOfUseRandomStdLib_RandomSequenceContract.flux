use RandomStdLib

program (ExampleOfUseRandomStdLib_RandomSequenceContract) {
      println("==================================================")
      println("  Exemplo: RandomSequenceContract (6 Operacoes - 1-Index)")
      println("==================================================")

      mut as int64: state = randomLcgNew(42)
      mut as list of data: fruits = ["maca", "banana", "cereja", "damasco", "figo"]
      println("Lista original (5 elementos): " + fruits)

      #L 1. Sorteio de indice 1-based (1..N)
      mut as list of data: p_idx = randomPickIndex(state, fruits)
      state = p_idx[1] as int64
      println("1. randomPickIndex (1..5): " + p_idx[2])

      #L 2. Sorteio de elemento
      mut as list of data: p_pick = randomPick(state, fruits)
      state = p_pick[1] as int64
      println("2. randomPick: " + p_pick[2])

      #L 3. Embaralhamento Fisher-Yates (Knuth shuffle)
      mut as list of data: p_shuf = randomShuffle(state, fruits)
      state = p_shuf[1] as int64
      println("3. randomShuffle: " + p_shuf[2])

      #L 4. Amostragem sem repeticao (k elementos)
      mut as list of data: p_samp = randomSample(state, fruits, 3)
      state = p_samp[1] as int64
      println("4. randomSample(3 elementos sem repeticao): " + p_samp[2])

      #L 5. Amostragem com repeticao (k elementos)
      mut as list of data: p_choices = randomChoices(state, fruits, 4)
      state = p_choices[1] as int64
      println("5. randomChoices(4 elementos com repeticao): " + p_choices[2])

      #L 6. Escolha Ponderada por Pesos (Loot Drop)
      mut as list of data: loot = ["comum", "raro", "epico", "lendario"]
      mut as list of data: pesos = [70, 20, 8, 2]
      mut as list of data: p_wchoice = randomWeightedChoice(state, loot, pesos)
      state = p_wchoice[1] as int64
      println("6. randomWeightedChoice (loot drop): " + p_wchoice[2])
}

