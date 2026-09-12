use DateTimeStdLib

program (ExampleOfUseDateTimeStdLib_DateTimeTimeZoneContract) {
      println("==================================================")
      println("  Exemplo: DateTimeTimeZoneContract (Fuso Horario)")
      println("==================================================")

      mut as int64: utcDt = parseIso("2025-06-15T15:00:00.000000000Z")
      println("1. UTC base: " + toIso(utcDt))

      mut as string: spStr = dateTimeToTimeZone(utcDt, "America/Sao_Paulo")
      println("2. dateTimeToTimeZone(America/Sao_Paulo): " + spStr)

      mut as string: locStr = dateTimeToLocal(utcDt)
      println("3. dateTimeToLocal: " + locStr)

      mut as int64: utcBack = dateTimeToUtc(utcDt)
      println("4. dateTimeToUtc nanos iguais: " + (utcBack == utcDt))

      println("5. dateTimeUtcOffset(America/Sao_Paulo): " + dateTimeUtcOffset(utcDt, "America/Sao_Paulo"))
      println("6. dateTimeUtcOffset(UTC): " + dateTimeUtcOffset(utcDt, "UTC"))
      println("7. dateTimeLocalTimeZone: " + dateTimeLocalTimeZone())
      println("8. dateTimeIsDaylightSavingTime: " + dateTimeIsDaylightSavingTime(utcDt, "America/Sao_Paulo"))
      println("9. dateTimeDstOffset: " + dateTimeDstOffset(utcDt, "America/Sao_Paulo"))

      println("10. inTimeZone alias: " + inTimeZone(utcDt, "BRT"))
      println("11. getUtcOffset alias: " + getUtcOffset(utcDt, "America/Sao_Paulo"))
      println("12. getLocalTimeZone alias: " + getLocalTimeZone())
      println("13. inDaylightTime alias: " + inDaylightTime(utcDt, "America/Sao_Paulo"))
}
