use DateTimeStdLib

program (ExampleOfUseDateTimeStdLib_DateTimeCompareContract) {
      println("==================================================")
      println("  Exemplo: DateTimeCompareContract (Comparacao e Intervalos)")
      println("==================================================")

      mut as int64: d1 = parseIso("2023-01-15T00:00:00.000000000Z")
      mut as int64: d2 = parseIso("2025-06-20T12:30:00.000000000Z")
      mut as int64: d1_clone = parseIso("2023-01-15T00:00:00.000000000Z")

      println("1. dateTimeSameInstant(d1, d1_clone): " + dateTimeSameInstant(d1, d1_clone))
      println("2. dateTimeSameInstant(d1, d2): " + dateTimeSameInstant(d1, d2))
      println("3. dateTimeIsBefore(d1, d2): " + dateTimeIsBefore(d1, d2))
      println("4. dateTimeIsBefore(d2, d1): " + dateTimeIsBefore(d2, d1))
      println("5. dateTimeIsAfter(d2, d1): " + dateTimeIsAfter(d2, d1))
      println("6. dateTimeIsAfter(d1, d2): " + dateTimeIsAfter(d1, d2))
      println("7. dateTimeCompare(d1, d2): " + dateTimeCompare(d1, d2))
      println("8. dateTimeCompare(d2, d1): " + dateTimeCompare(d2, d1))
      println("9. dateTimeCompare(d1, d1): " + dateTimeCompare(d1, d1))

      println("10. yearsBetween(d1, d2): " + yearsBetween(d1, d2))
      println("11. monthsBetween(d1, d2): " + monthsBetween(d1, d2))
      println("12. daysBetween(d1, d2): " + daysBetween(d1, d2))
      println("13. hoursBetween(d1, d2): " + hoursBetween(d1, d2))
      println("14. minutesBetween(d1, d2): " + minutesBetween(d1, d2))
      println("15. secondsBetween(d1, d2): " + secondsBetween(d1, d2))

      mut as int64: t1 = createTimeFull(10, 0, 0, 100, 200, 300)
      mut as int64: t2 = createTimeFull(10, 0, 1, 200, 400, 600)
      println("16. millisecondsBetween: " + millisecondsBetween(t1, t2))
      println("17. microsecondsBetween: " + microsecondsBetween(t1, t2))
      println("18. nanosecondsBetween: " + nanosecondsBetween(t1, t2))

      println("19. sameInstant alias: " + sameInstant(d1, d1_clone))
      println("20. isEarlier alias: " + isEarlier(d1, d2))
      println("21. isLater alias: " + isLater(d2, d1))
      println("22. compareTo alias: " + compareTo(d1, d2))
      println("23. diffYears alias: " + diffYears(d1, d2))
      println("24. diffMonths alias: " + diffMonths(d1, d2))
      println("25. diffDays alias: " + diffDays(d1, d2))
}
