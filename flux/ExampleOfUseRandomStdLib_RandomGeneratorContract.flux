use RandomStdLib

program (ExampleOfUseRandomStdLib_RandomGeneratorContract) {
      println("==================================================")
      println("  Exemplo: RandomGeneratorContract (PRNGs e Seeds)")
      println("==================================================")

      #L 1. Semente e Dispersor SplitMix64
      mut as int64: seed_base = 42
      mut as int64: seed_dispersa = randomSplitMix64(seed_base)
      println("1. Semente base: " + seed_base)
      println("   Semente dispersa (SplitMix64): " + seed_dispersa)

      #L 2. LCG (Linear Congruential Generator)
      mut as int64: lcg_st = randomLcgNew(seed_base)
      mut as list of data: lcg_p1 = randomLcgNext(lcg_st)
      lcg_st = lcg_p1[1] as int64
      println("2. LCG Next 1: valor = " + lcg_p1[2] + ", novo estado = " + lcg_st)
      mut as list of data: lcg_p2 = randomLcgNext(lcg_st)
      lcg_st = lcg_p2[1] as int64
      println("   LCG Next 2: valor = " + lcg_p2[2] + ", novo estado = " + lcg_st)

      #L 3. XORShift64
      mut as int64: xor_st = randomXorNew(seed_base)
      mut as list of data: xor_p = randomXorNext(xor_st)
      xor_st = xor_p[1] as int64
      println("3. XORShift64 Next: valor = " + xor_p[2] + ", novo estado = " + xor_st)

      #L 4. PCG32
      mut as int64: pcg_st = randomPcgNew(seed_base)
      mut as list of data: pcg_p = randomPcgNext(pcg_st)
      pcg_st = pcg_p[1] as int64
      println("4. PCG32 Next: valor = " + pcg_p[2] + ", novo estado = " + pcg_st)

      #L 5. Semente do Sistema (Nao Implementada)
      mut as int64: sys_seed = randomSeedSystem()
      println("5. Semente do Sistema (Default): " + sys_seed)
}

