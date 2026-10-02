use DbStdLib

program (ExampleOfUseDbStdLib_DbKvContract) {
      println("==================================================")
      println("  Exemplo: DbKvContract (Chave-Valor UnQLite/LevelDB)")
      println("==================================================")

      mut as data: c = dbKvOpen("unqlite", "scratch/flux_kv.kv")
      println("1. kvOpen (> 0): " + (c != 0))

      mut as bool: ex_before = dbKvExists(c, "sessao:101")
      println("2. kvExists antes: " + ex_before)

      mut as bool: ok_put = dbKvPut(c, "sessao:101", "token_abc")
      println("3. kvPut: " + ok_put)

      mut as bool: ex_after = dbKvExists(c, "sessao:101")
      println("4. kvExists depois: " + ex_after)

      mut as string: val = dbKvGet(c, "sessao:101")
      println("5. kvGet: " + val)

      mut as bool: ok_del = dbKvDelete(c, "sessao:101")
      println("6. kvDelete: " + ok_del)

      mut as bool: ex_final = dbKvExists(c, "sessao:101")
      println("7. kvExists final: " + ex_final)

      mut as bool: ok_close = dbKvClose(c)
      println("8. kvClose: " + ok_close)

      #L Aliases
      mut as data: c2 = kvOpen("unqlite", "scratch/flux_kv.kv")
      println("9. Alias kvExists: " + kvExists(c2, "sessao:101"))
      println("10. Alias kvClose: " + kvClose(c2))
}
