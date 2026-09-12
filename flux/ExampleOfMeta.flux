#L Exemplo de Metaprogramacao com meta, lift e lower na linguagem TheFlux

#D
- Programa: ExampleOfMeta
- Descricao: Demonstracao da sintaxe canonica de metaprogramacao com meta, lift e lower (incluindo macros de 1 e 3 parametros)
- Autor: TheFlux
- Versao: 0.5
D#
meta dobraNumero(num) {
      lift {
            mut as int64: res = lower(num) * 2
      }
}

meta areaTrapezio(bmaior, bmenor, altura) {
      lift {
            mut as float64: area = ((lower(bmaior) + lower(bmenor)) * lower(altura)) /f 2
      }
}

program (ExampleOfMeta) {
      print("=== Metaprogramacao em TheFlux ===")
      mut as int64: dobrado = dobraNumero(21)
      print(dobrado)

      print("=== Area do Trapezio ===")
      mut as float64: a = areaTrapezio(15, 6, 3)
      print(a)
}
