use StatStdLib

program (ExampleOfUseStatStdLib_StatOrderAndQuantilesContract) {
      println("==================================================")
      println("  Exemplo: StatOrderAndQuantilesContract (6 Operacoes)")
      println("==================================================")

      mut as list of data: sample = [15.0, 20.0, 35.0, 40.0, 50.0]

      #L 1. Quantil
      mut as float64: q40 = statQuantile(sample, 0.40)
      println("1. statQuantile(p=0.40): " + q40)

      #L 2. Percentil
      mut as float64: p80 = statPercentile(sample, 80.0)
      println("2. statPercentile(80%): " + p80)

      #L 3. Quartis
      mut as list of data: qs = statQuartiles(sample)
      println("3. statQuartiles (Q1, Q2, Q3): " + qs)

      #L 4. Decis
      mut as list of data: decs = statDeciles(sample)
      println("4. statDeciles (D1..D9): " + decs)

      #L 5. Ranks com empates
      mut as list of data: rank_data = [10.0, 20.0, 20.0, 40.0, 30.0]
      mut as list of data: rks = statRanks(rank_data)
      println("5. statRanks([10, 20, 20, 40, 30]): " + rks)

      #L 6. Z-Scores
      mut as list of data: zs = statZScores(sample)
      println("6. statZScores: " + zs)
}
