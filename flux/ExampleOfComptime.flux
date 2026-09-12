#L Exemplo Unificado de Metaprogramacao em Tempo de Compilacao (comptime) na linguagem TheFlux

#D
- Programa: ExampleOfComptime
- Descricao: Demonstracao completa de avaliacao estatica em tempo de compilacao (comptime)
- Autor: TheFlux
- Versao: 0.5
D#
program (ExampleOfComptime) {
      #L 1. Avaliacao pura de expressao matematica em tempo de compilacao
      mut as int64: x = comptime (10 * 4) + 2
      print(x)

      #L 2. Calculo de escala aritmetica em tempo de compilacao
      mut as int64: escala = comptime 2 * 3 + 1
      print(escala)

      #L 3. Bloco comptime com variaveis e operacoes locais
      mut as int64: y = comptime {
            mut as int64: temp = 10
            temp = temp * 10
            temp
      }
      print(y)

      #L 4. Bloco comptime construindo payload de dados
      mut as data: payload = comptime {
            mut as int64: base = 4
            base =* 2
            [base, "sensor"]
      }
      print(payload)
      print(payload[1])
      print(payload[2])
}
