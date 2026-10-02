use DbStdLib

program (ExampleOfUseDbStdLib_DbSqlContract) {
      println("==================================================")
      println("  Exemplo: DbSqlContract (SQLite 3.53.4)")
      println("==================================================")

      mut as data: c = dbSqlOpen("scratch/flux_relacional.db")
      println("1. sqlOpen (> 0): " + (c != 0))

      mut as bool: ex_before = dbSqlTableExists(c, "usuarios")
      println("2. tableExists antes: " + ex_before)

      mut as bool: ok_create = dbSqlExecute(c, "CREATE TABLE usuarios (id INTEGER PRIMARY KEY, nome TEXT)", [])
      println("3. execute CREATE TABLE: " + ok_create)

      mut as bool: ex_after = dbSqlTableExists(c, "usuarios")
      println("4. tableExists depois: " + ex_after)

      mut as bool: ok_tx = dbSqlBegin(c)
      println("5. begin transacao: " + ok_tx)

      mut as bool: ok_ins = dbSqlExecute(c, "INSERT INTO usuarios (nome) VALUES (?)", ["Alice"])
      println("6. insert registro: " + ok_ins)

      mut as bool: ok_cm = dbSqlCommit(c)
      println("7. commit transacao: " + ok_cm)

      mut as int64: last_id = dbSqlLastInsertId(c)
      println("8. lastInsertId: " + last_id)

      mut as int64: chg = dbSqlChanges(c)
      println("9. changes: " + chg)

      #L Aliases
      println("10. Alias sqlTableExists: " + sqlTableExists(c, "usuarios"))

      mut as bool: ok_close = dbSqlClose(c)
      println("11. close: " + ok_close)

      mut as data: c2 = sqlOpen("scratch/flux_relacional.db")
      println("12. Alias sqlClose: " + sqlClose(c2))
}
