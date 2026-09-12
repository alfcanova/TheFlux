use DateTimeStdLib

program (ExampleOfUseDateTimeStdLib_DateTimeDateContract) {
      println("==================================================")
      println("  Exemplo: DateTimeDateContract (Operacoes de Data)")
      println("==================================================")

      mut as int64: dt = dateTimeCreateDate(2025, 6, 15)
      println("1. Data base (2025-06-15): " + toIso(dt))
      println("2. dateTimeYear: " + dateTimeYear(dt))
      println("3. dateTimeMonth: " + dateTimeMonth(dt))
      println("4. dateTimeDay: " + dateTimeDay(dt))
      println("5. dateTimeWeekday (1=Seg..7=Dom): " + dateTimeWeekday(dt))
      println("6. dateTimeDayOfYear: " + dateTimeDayOfYear(dt))
      println("7. dateTimeDaysInMonth: " + dateTimeDaysInMonth(dt))
      println("8. dateTimeQuarter: " + dateTimeQuarter(dt))
      println("9. dateTimeIsLeapYear(2025): " + dateTimeIsLeapYear(dt))

      mut as int64: leapDt = dateTimeCreateDate(2024, 2, 29)
      println("10. dateTimeIsLeapYear(2024): " + dateTimeIsLeapYear(leapDt))
      println("11. dateTimeDaysInMonth(Fev 2024): " + dateTimeDaysInMonth(leapDt))
      println("12. dateTimeIsWeekend(2025-06-15 Dom): " + dateTimeIsWeekend(dt))

      mut as int64: segDt = dateTimeCreateDate(2025, 6, 16)
      println("13. dateTimeIsWeekend(2025-06-16 Seg): " + dateTimeIsWeekend(segDt))

      mut as int64: dtPlus10d = dateTimeAddDays(dt, 10)
      println("14. dateTimeAddDays(dt, 10): " + toIso(dtPlus10d))
      mut as int64: dtMinus5d = dateTimeSubtractDays(dt, 5)
      println("15. dateTimeSubtractDays(dt, 5): " + toIso(dtMinus5d))

      mut as int64: dtPlus2m = dateTimeAddMonths(dt, 2)
      println("16. dateTimeAddMonths(dt, 2): " + toIso(dtPlus2m))
      mut as int64: dtMinus1m = dateTimeSubtractMonths(dt, 1)
      println("17. dateTimeSubtractMonths(dt, 1): " + toIso(dtMinus1m))

      mut as int64: dtPlus1y = dateTimeAddYears(dt, 1)
      println("18. dateTimeAddYears(dt, 1): " + toIso(dtPlus1y))
      mut as int64: dtMinus1y = dateTimeSubtractYears(dt, 1)
      println("19. dateTimeSubtractYears(dt, 1): " + toIso(dtMinus1y))

      println("20. dateTimeDaysBetween: " + dateTimeDaysBetween(dt, dtPlus10d))
      println("21. dateTimeMonthsBetween: " + dateTimeMonthsBetween(dt, dtPlus2m))
      println("22. dateTimeYearsBetween: " + dateTimeYearsBetween(dt, dtPlus1y))

      mut as int64: dtClamp = addMonths(createDate(2024, 1, 31), 1)
      println("23. addMonths(2024-01-31, 1) [clamp]: " + toIso(dtClamp))

      mut as int64: ep = epoch()
      println("24. epoch: " + toIso(ep))
      println("25. today > epoch: " + isAfter(today(), ep))

      println("26. makeDate alias: " + toIso(makeDate(2030, 12, 25)))
      println("27. getYear/getMonth/getDay aliases: " + getYear(dt) + "/" + getMonth(dt) + "/" + getDay(dt))
      println("28. plusDays/minusDays aliases: " + toIso(plusDays(dt, 1)) + " / " + toIso(minusDays(dt, 1)))
      println("29. plusMonths/plusYears aliases: " + toIso(plusMonths(dt, 3)) + " / " + toIso(plusYears(dt, 5)))
}
