use DateTimeStdLib

program (ExampleOfUseDateTimeStdLib_DateTimeTimeContract) {
      println("==================================================")
      println("  Exemplo: DateTimeTimeContract (Operacoes de Horario)")
      println("==================================================")

      mut as int64: t = dateTimeCreateTime(14, 25, 30)
      println("1. dateTimeCreateTime(14, 25, 30): hour=" + dateTimeHour(t) + " min=" + dateTimeMinute(t) + " sec=" + dateTimeSecond(t))

      mut as int64: tf = dateTimeCreateTimeFull(10, 30, 45, 123, 456, 789)
      println("2. dateTimeCreateTimeFull:")
      println("   hour: " + dateTimeHour(tf))
      println("   minute: " + dateTimeMinute(tf))
      println("   second: " + dateTimeSecond(tf))
      println("   millisecond: " + dateTimeMillisecond(tf))
      println("   microsecond: " + dateTimeMicrosecond(tf))
      println("   nanosecond: " + dateTimeNanosecond(tf))

      mut as int64: tPlusH = dateTimeAddHours(t, 2)
      mut as int64: tMinusH = dateTimeSubtractHours(t, 2)
      println("3. dateTimeAddHours(+2)/Subtract(-2): " + dateTimeHour(tPlusH) + " / " + dateTimeHour(tMinusH))

      mut as int64: tPlusM = dateTimeAddMinutes(t, 15)
      mut as int64: tMinusM = dateTimeSubtractMinutes(t, 15)
      println("4. dateTimeAddMinutes(+15)/Subtract(-15): " + dateTimeMinute(tPlusM) + " / " + dateTimeMinute(tMinusM))

      mut as int64: tPlusS = dateTimeAddSeconds(t, 20)
      mut as int64: tMinusS = dateTimeSubtractSeconds(t, 20)
      println("5. dateTimeAddSeconds(+20)/Subtract(-20): " + dateTimeSecond(tPlusS) + " / " + dateTimeSecond(tMinusS))

      mut as int64: tPlusMs = dateTimeAddMilliseconds(tf, 50)
      mut as int64: tMinusMs = dateTimeSubtractMilliseconds(tf, 23)
      println("6. dateTimeAddMilliseconds(+50)/Subtract(-23): " + dateTimeMillisecond(tPlusMs) + " / " + dateTimeMillisecond(tMinusMs))

      mut as int64: tPlusUs = dateTimeAddMicroseconds(tf, 100)
      mut as int64: tMinusUs = dateTimeSubtractMicroseconds(tf, 56)
      println("7. dateTimeAddMicroseconds(+100)/Subtract(-56): " + dateTimeMicrosecond(tPlusUs) + " / " + dateTimeMicrosecond(tMinusUs))

      mut as int64: tPlusNs = dateTimeAddNanoseconds(tf, 200)
      mut as int64: tMinusNs = dateTimeSubtractNanoseconds(tf, 89)
      println("8. dateTimeAddNanoseconds(+200)/Subtract(-89): " + dateTimeNanosecond(tPlusNs) + " / " + dateTimeNanosecond(tMinusNs))

      println("9. dateTimeHoursBetween: " + dateTimeHoursBetween(t, tPlusH))
      println("10. dateTimeMinutesBetween: " + dateTimeMinutesBetween(t, tPlusM))
      println("11. dateTimeSecondsBetween: " + dateTimeSecondsBetween(t, tPlusS))
      println("12. dateTimeMillisecondsBetween: " + dateTimeMillisecondsBetween(tf, tPlusMs))
      println("13. dateTimeMicrosecondsBetween: " + dateTimeMicrosecondsBetween(tf, tPlusUs))
      println("14. dateTimeNanosecondsBetween: " + dateTimeNanosecondsBetween(tf, tPlusNs))

      mut as int64: curr = now()
      mut as int64: ep = epoch()
      println("15. now > epoch: " + isAfter(curr, ep))

      mut as int64: tOnly = time()
      println("16. time >= 0: " + (tOnly >= 0))

      println("17. makeTime alias: hour=" + getHour(makeTime(8, 0, 0)))
      println("18. plusHours/minusHours aliases: " + getHour(plusHours(t, 1)) + " / " + getHour(minusHours(t, 1)))
      println("19. plusMinutes/minusMinutes aliases: " + getMinute(plusMinutes(t, 5)) + " / " + getMinute(minusMinutes(t, 5)))
      println("20. plusSeconds/minusSeconds aliases: " + getSecond(plusSeconds(t, 10)) + " / " + getSecond(minusSeconds(t, 10)))
}
