program (ExampleOfNone) {
      print("=== None: chave ausente em map ===")
      mut as map: metricas = map{.threads of string: 8, .batch of string: 32}
      print(metricas["threads"])
      print(metricas["ausente"])

      print("=== None: print como sink encerra a cadeia ===")
      42 --> print
}