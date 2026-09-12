async function calculaJuros (as int64: valor, as int64: taxa) as int64 {
      mut as int64: juros = valor * taxa / 100
      emit(nice, juros, "ok")
}

async function aplicaDesconto (as int64: valor, as int64: pct) as int64 {
      mut as int64: desconto = valor * pct / 100
      mut as int64: final = valor - desconto
      emit(nice, final, "ok")
}

program (ExampleOfAsync) {
      mut as int64: bruto = 1000

      print("=== async: chamada aguardada ===")
      print(await calculaJuros(bruto, 5))
      print(await aplicaDesconto(bruto, 10))

      print("=== async: aguardando Future de spawn ===")
      mut as int64: agendado = spawn calculaJuros(bruto, 8)
      print(await agendado)

      print("=== async: combinando resultados ===")
      mut as int64: j = await calculaJuros(bruto, 5)
      mut as int64: d = await aplicaDesconto(bruto, 10)
      mut as int64: liquido = bruto - j - d
      print(liquido)
}
