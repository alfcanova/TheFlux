use DateTimeStdLib
program (ExampleOfUseDateTimeStdLib_DateTimeMonotonicContract) {
      println("==================================================")
      println("  Exemplo: DateTimeMonotonicContract (Relogio Monotonico)")
      println("==================================================")

      mut as int64: t1 = dateTimeMonotonicNow()
      mut as int64: t2 = dateTimeMonotonicNow()

      println("1. Monotonicidade garantida (t2 >= t1): " + (t2 >= t1))
      println("2. Valor positivo (> 0): " + (t1 > 0))

      mut as int64: el = dateTimeMonotonicElapsed(t1)
      println("3. dateTimeMonotonicElapsed >= 0: " + (el >= 0))

      mut as int64: m1 = monotonicNow()
      mut as int64: m2 = monotonic()
      println("4. Aliases monotonicNow e monotonic: " + (m2 >= m1))

      mut as int64: mNs = monotonicNs()
      println("5. Alias monotonicNs > 0: " + (mNs > 0))

      mut as int64: elAlias = elapsed(t1)
      println("6. Alias elapsed >= 0: " + (elAlias >= 0))

      mut as int64: mElAlias = monotonicElapsed(t1)
      println("7. Alias monotonicElapsed >= 0: " + (mElAlias >= 0))
}
