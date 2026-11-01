use DbStdLib

program (ExampleOfUseDbStdLib_DbDocContract) {
      println("==================================================")
      println("  Exemplo: DbDocContract (Documentos NoSQL JSON)")
      println("==================================================")

      mut as data: c = dbDocOpen("scratch/flux_docs.unqlite")
      println("1. docOpen (> 0): " + (c != 0))

      mut as int64: cnt_before = dbDocCount(c, "clientes")
      println("2. docCount antes: " + cnt_before)

      mut as string: doc_id = dbDocStore(c, "clientes", { .nome: "Carlos", .tipo: "vip" })
      println("3. docStore id gerado: " + (doc_id != ""))

      mut as int64: cnt_after = dbDocCount(c, "clientes")
      println("4. docCount depois: " + cnt_after)

      mut as bool: ok_del = dbDocDelete(c, "clientes", doc_id)
      println("5. docDelete: " + ok_del)

      mut as int64: cnt_final = dbDocCount(c, "clientes")
      println("6. docCount final: " + cnt_final)

      #L Aliases
      println("7. Alias docCount: " + docCount(c, "clientes"))

      mut as bool: ok_close = dbDocClose(c)
      println("8. docClose: " + ok_close)

      mut as data: c2 = docOpen("scratch/flux_docs.unqlite")
      println("9. Alias docClose: " + docClose(c2))
}
