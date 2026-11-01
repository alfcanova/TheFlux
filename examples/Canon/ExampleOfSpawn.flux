async function processaTarefa (as string: tarefa, as int64: peso) as int64 {
      mut as int64: resultado = peso * 10
      emit(nice, resultado, "ok")
}

function reporta (as int64: total) as int64 {
      mut as int64: duplicado = total * 2
      emit(nice, duplicado, "ok")
}

program (ExampleOfSpawn) {
      print("=== spawn: despachando e aguardando Future ===")
      mut as int64: a = spawn processaTarefa("load", 3)
      mut as int64: b = spawn processaTarefa("index", 4)
      print(await a)
      print(await b)

      print("=== spawn: com expressao no argumento ===")
      mut as int64: c = spawn processaTarefa("merge", 1 + 1)
      print(await c)

      print("=== spawn: de chamada de funcao comum ===")
      mut as int64: d = spawn reporta(5)
      print(await d)

      print("=== spawn: desagendando e aguardando em sequencia ===")
      mut as int64: x = spawn processaTarefa("a", 1)
      mut as int64: y = spawn processaTarefa("b", 2)
      print(await x)
      print(await y)
}
