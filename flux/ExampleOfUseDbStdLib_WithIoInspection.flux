use DbStdLib
use IoStdLib

program (ExampleOfUseDbStdLib_WithIoInspection) {
      println("==================================================")
      println("  Exemplo: DbStdLib integrada com IoStdLib")
      println("==================================================")

      mut as string: db_path = "scratch/flux_demo_io.db"

      mut as bool: ex_before = fileExists(db_path)
      println("1. fileExists antes: " + ex_before)

      mut as data: c = dbSqlOpen(db_path)
      println("2. sqlOpen (> 0): " + (c != 0))

      mut as bool: ok_tbl = dbSqlExecute(c, "CREATE TABLE produtos (id INTEGER PRIMARY KEY, nome TEXT)", [])
      println("3. execute CREATE TABLE: " + ok_tbl)

      mut as bool: ok_ins = dbSqlExecute(c, "INSERT INTO produtos (nome) VALUES (?)", ["Laptop"])
      println("4. insert registro: " + ok_ins)

      mut as bool: ok_close = dbSqlClose(c)
      println("5. sqlClose: " + ok_close)

      mut as bool: ex_after = fileExists(db_path)
      println("6. fileExists depois: " + ex_after)

      mut as int64: sz = fileSize(db_path)
      println("7. fileSize (> 0): " + (sz > 0))

      mut as bool: ok_del = deleteFile(db_path)
      println("8. deleteFile: " + ok_del)

      mut as bool: ex_final = fileExists(db_path)
      println("9. fileExists final: " + ex_final)
}
