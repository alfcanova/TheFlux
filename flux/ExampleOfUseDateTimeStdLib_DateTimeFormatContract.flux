use DateTimeStdLib

program (ExampleOfUseDateTimeStdLib_DateTimeFormatContract) {
      println("==================================================")
      println("  Exemplo: DateTimeFormatContract (Formatacao e Parsing)")
      println("==================================================")

      mut as string: isoInput = "2025-06-15T10:30:05.123456789Z"
      mut as int64: dt = dateTimeParseIso(isoInput)
      println("1. dateTimeParseIso / dateTimeToIso: " + dateTimeToIso(dt))
      println("2. dateTimeToString: " + dateTimeToString(dt))

      println("3. dateTimeFormat (%Y-%m-%d %H:%M:%S): " + dateTimeFormat(dt, "%Y-%m-%d %H:%M:%S"))
      println("4. dateTimeFormat (%d/%m/%Y): " + dateTimeFormat(dt, "%d/%m/%Y"))
      println("5. dateTimeFormat customizado: " + dateTimeFormat(dt, "Data: %d/%m/%Y - Hora: %H:%M:%S"))

      println("6. dateTimeFormatDuration(0): " + dateTimeFormatDuration(0))
      println("7. dateTimeFormatDuration(500ms): " + dateTimeFormatDuration(500000000))
      println("8. dateTimeFormatDuration(1.5s): " + dateTimeFormatDuration(1500000000))
      println("9. dateTimeFormatDuration(65s): " + dateTimeFormatDuration(65000000000))
      println("10. dateTimeFormatDuration(1h 1m 5s): " + dateTimeFormatDuration(3665000000000))
      println("11. dateTimeFormatDuration(1d 1h 1m 5s): " + dateTimeFormatDuration(90065000000000))
      println("12. dateTimeFormatDuration(-5s): " + dateTimeFormatDuration(-5000000000))

      mut as int64: ep = dateTimeEpoch()
      println("13. dateTimeEpoch: " + dateTimeToIso(ep))
      println("14. dateTimeNow > epoch: " + (dateTimeNow() > ep))
      println("15. dateTimeToday > epoch: " + (dateTimeToday() > ep))
      println("16. dateTimeTime >= 0: " + (dateTimeTime() >= 0))
      println("17. dateTimeNowFormatted != empty: " + (dateTimeNowFormatted() != ""))

      println("18. fromIso alias: " + toIso(fromIso("2024-02-29T00:00:00.000000000Z")))
      println("19. toISOString alias: " + toISOString(dt))
      println("20. formatPattern alias: " + formatPattern(dt, "%Y/%m/%d"))
      println("21. durationToString alias: " + durationToString(1000000000))
}
