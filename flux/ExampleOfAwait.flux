async function buscaUsuario (as int64: id) as string {
      mut as int64: codigo = id * 100
      mut as string: rotulo = "usuario#" + codigo
      emit(nice, rotulo, "ok")
}

async function montaPerfil (as string: nome, as string: sobrenome) as string {
      mut as string: completo = nome + " " + sobrenome
      emit(nice, completo, "ok")
}

program (ExampleOfAwait) {
      print("=== await: resultado de chamada async ===")
      print(await buscaUsuario(7))
      print(await montaPerfil("Ada", "Lovelace"))

      print("=== await: Future obtido por spawn ===")
      mut as string: futuro = spawn buscaUsuario(42)
      print(await futuro)

      print("=== await: encadeamento ===")
      mut as string: primeiro = await buscaUsuario(1)
      print(await montaPerfil(primeiro, "dev"))

      print("=== await: aninhado ===")
      print(await montaPerfil(await buscaUsuario(9), "ops"))
}
