use RandomStdLib

program (ExampleOfUseRandomStdLib_RandomDistributionContract) {
      println("==================================================")
      println("  Exemplo: RandomDistributionContract (8 Operacoes)")
      println("==================================================")

      mut as int64: state = randomLcgNew(100)

      #L 1. Inteiro bruto
      mut as list of data: p_int = randomNextInt(state)
      state = p_int[1] as int64
      println("1. randomNextInt: " + p_int[2])

      #L 2. Inteiro em intervalo inclusivo [min, max]
      mut as list of data: p_range = randomNextIntRange(state, 1, 6)
      state = p_range[1] as int64
      println("2. randomNextIntRange(1, 6): " + p_range[2])

      #L 3. Float uniformemente distribuido [0.0, 1.0)
      mut as list of data: p_float = randomNextFloat(state)
      state = p_float[1] as int64
      println("3. randomNextFloat: " + p_float[2])

      #L 4. Float em intervalo continuo [min, max)
      mut as list of data: p_frange = randomNextFloatRange(state, 10.0, 25.0)
      state = p_frange[1] as int64
      println("4. randomNextFloatRange(10.0, 25.0): " + p_frange[2])

      #L 5. Booleano aleatorio 50/50
      mut as list of data: p_bool = randomNextBool(state)
      state = p_bool[1] as int64
      println("5. randomNextBool: " + p_bool[2])

      #L 6. Bernoulli (booleano com probabilidade customizada p=0.8)
      mut as list of data: p_bern = randomNextBernoulli(state, 0.8)
      state = p_bern[1] as int64
      println("6. randomNextBernoulli(p=0.8): " + p_bern[2])

      #L 7. Gaussiana / Normal (mean=100.0, std_dev=15.0)
      mut as list of data: p_gauss = randomNextGaussian(state, 100.0, 15.0)
      state = p_gauss[1] as int64
      println("7. randomNextGaussian(mean=100, std=15): " + p_gauss[2])

      #L 8. Rolagem de Dados (3d6: 3 dados de 6 lados)
      mut as list of data: p_dice = randomNextDice(state, 3, 6)
      state = p_dice[1] as int64
      mut as list of data: dinfo = p_dice[2] as list of data
      println("8. randomNextDice(3d6): Total=" + dinfo[1] + ", Dados individuais=" + dinfo[2])
}

