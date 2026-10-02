use DbStdLib

program (ExampleOfUseDbStdLib_DbVectorContract) {
      println("==================================================")
      println("  Exemplo: DbVectorContract (Vetores ObjectBox 5.3.2)")
      println("==================================================")

      mut as data: c = dbVectorOpen("scratch/flux_vectors.obx", 4, "euclidean")
      println("1. vectorOpen (> 0): " + (c != 0))

      mut as int64: cnt_before = dbVectorCount(c)
      println("2. vectorCount antes: " + cnt_before)

      mut as bool: ok_ins = dbVectorInsert(c, 1, [0.1, 0.2, 0.3, 0.4], "doc_ref_1")
      println("3. vectorInsert: " + ok_ins)

      mut as int64: cnt_after = dbVectorCount(c)
      println("4. vectorCount depois: " + cnt_after)

      mut as bool: ok_del = dbVectorDelete(c, 1)
      println("5. vectorDelete: " + ok_del)

      mut as int64: cnt_final = dbVectorCount(c)
      println("6. vectorCount final: " + cnt_final)

      #L Aliases
      println("7. Alias vectorCount: " + vectorCount(c))

      mut as bool: ok_close = dbVectorClose(c)
      println("8. vectorClose: " + ok_close)

      mut as data: c2 = vectorOpen("scratch/flux_vectors.obx", 4, "euclidean")
      println("9. Alias vectorClose: " + vectorClose(c2))
}
