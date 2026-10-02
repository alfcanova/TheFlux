use DbStdLib

program (ExampleOfUseDbStdLib_DbGraphContract) {
      println("==================================================")
      println("  Exemplo: DbGraphContract (Grafos Cypher KuzuDB)")
      println("==================================================")

      mut as data: c = dbGraphOpen("scratch/flux_graph.kuzu")
      println("1. graphOpen (> 0): " + (c != 0))

      mut as bool: ok_node = dbGraphExecute(c, "CREATE (p:Pessoa {nome: 'Maria'})")
      println("2. graphExecute CREATE node: " + ok_node)

      mut as int64: n_cnt = dbGraphNodeCount(c, "Pessoa")
      println("3. graphNodeCount: " + n_cnt)

      mut as int64: r_cnt = dbGraphRelCount(c, "AMIGO")
      println("4. graphRelCount: " + r_cnt)

      #L Aliases
      println("5. Alias graphNodeCount: " + graphNodeCount(c, "Pessoa"))

      mut as bool: ok_close = dbGraphClose(c)
      println("6. graphClose: " + ok_close)

      mut as data: c2 = graphOpen("scratch/flux_graph.kuzu")
      println("7. Alias graphClose: " + graphClose(c2))
}
