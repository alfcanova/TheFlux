use HashStdLib

program (ExampleOfUseHashStdLib_HashIntegerContract) {
      println("==================================================")
      println("  Exemplo: HashIntegerContract (Hashes para Inteiros)")
      println("==================================================")

      #L 1. Thomas Wang 32-bit Integer Hash
      println("1. hashInt32(42): " + hashInt32(42))
      println("   hashInt32(1000000): " + hashInt32(1000000))

      #L 2. SplitMix64 64-bit Transform
      println("2. hashInt64(42): " + hashInt64(42))
      println("   hashInt64(1000000): " + hashInt64(1000000))

      #L 3. Fibonacci Hashing (Constante Aurea)
      println("3. hashFibonacci(42, 8 bits) [1..256]: " + hashFibonacci(42, 8))
      println("   hashFibonacci(100, 8 bits) [1..256]: " + hashFibonacci(100, 8))
      println("   hashFibonacci(42, 10 bits) [1..1024]: " + hashFibonacci(42, 10))

      #L 4. Bob Jenkins 32-bit Hash
      println("4. hashJenkins32(42): " + hashJenkins32(42))

      #L 5. Zobrist Hash para Jogos de Tabuleiro
      println("5. hashZobrist(Peao=1, Casa=15): " + hashZobrist(1, 15))
      println("   hashZobrist(Rei=6, Casa=64): " + hashZobrist(6, 64))
}
