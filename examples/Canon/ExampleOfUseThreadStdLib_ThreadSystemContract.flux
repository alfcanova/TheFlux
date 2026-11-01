use ThreadStdLib

program (ExampleOfUseThreadStdLib_ThreadSystemContract) {
      println("==================================================")
      println("  Exemplo: ThreadSystemContract (System & Hardware)")
      println("==================================================")

      #L 1. Operacoes canonicas
      mut as int64: cores = threadHardwareConcurrency()
      println("1. Hardware Concurrency (> 0): " + (cores > 0))

      mut as bool: s1 = threadSleep(5)
      println("2. Thread Sleep (5ms): " + s1)

      mut as bool: s2 = threadSleepMs(5)
      println("3. Thread SleepMs (5ms): " + s2)

      mut as bool: y1 = threadYield()
      println("4. Thread Yield: " + y1)

      #L 2. Aliases universais
      mut as int64: cores_alias = hardwareConcurrency()
      println("5. Alias hardwareConcurrency (> 0): " + (cores_alias > 0))
      println("6. Cores coincidem com alias: " + (cores == cores_alias))

      mut as bool: s3 = sleepMs(2)
      println("7. Alias sleepMs (2ms): " + s3)

      mut as bool: y2 = yield()
      println("8. Alias yield: " + y2)
}
