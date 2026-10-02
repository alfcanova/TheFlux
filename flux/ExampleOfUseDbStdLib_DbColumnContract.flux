use DbStdLib

program (ExampleOfUseDbStdLib_DbColumnContract) {
      println("==================================================")
      println("  Exemplo: DbColumnContract (Colunar DuckDB 1.5.6)")
      println("==================================================")

      mut as data: c = dbColumnOpen("scratch/flux_columnar.duckdb")
      println("1. columnOpen (> 0): " + (c != 0))

      mut as bool: ok_create = dbColumnExecute(c, "CREATE TABLE metricas (id INT, valor DOUBLE)")
      println("2. columnExecute CREATE TABLE: " + ok_create)

      mut as int64: rows_before = dbColumnRowCount(c, "metricas")
      println("3. columnRowCount antes: " + rows_before)

      mut as bool: ok_ins = dbColumnExecute(c, "INSERT INTO metricas VALUES (1, 99.5)")
      println("4. columnExecute INSERT: " + ok_ins)

      mut as int64: rows_after = dbColumnRowCount(c, "metricas")
      println("5. columnRowCount depois: " + rows_after)

      mut as data: sc = dbColumnScalar(c, "SELECT 1")
      println("6. columnScalar: " + sc)

      #L Aliases
      println("7. Alias columnRowCount: " + columnRowCount(c, "metricas"))

      mut as bool: ok_close = dbColumnClose(c)
      println("8. columnClose: " + ok_close)

      mut as data: c2 = columnOpen("scratch/flux_columnar.duckdb")
      println("9. Alias columnClose: " + columnClose(c2))
}
