use FormatStdLib

program (ExampleOfUseFormatStdLib_FormatCsvContract) {
      println("==================================================")
      println("  Exemplo: FormatCsvContract (CSV RFC 4180)")
      println("==================================================")

      mut as string: csv_data = "id,nome,cidade\n1,Alice,Sao Paulo\n2,Bob,Rio de Janeiro"
      mut as list of data: rows = formatParseCsvRows(csv_data, ",")
      println("1. Parse CSV Rows: " + rows)
      mut as list of data: table = formatParseCsvTable(csv_data, ",")
      println("2. Parse CSV Table: " + table)

      mut as string: out_csv = formatStringifyCsvRows(rows, ",")
      println("3. Stringify Rows: " + out_csv)
      println("4. Valido (csv_data): " + formatIsValidCsv(csv_data, ","))
      println("5. Invalido: " + formatIsValidCsv("a,b,c\n1,2", ","))
}
