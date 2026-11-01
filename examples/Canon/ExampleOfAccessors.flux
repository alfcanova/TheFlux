#L Exemplo de Operadores de Acesso na linguagem TheFlux

#D
- Programa: ExampleOfAccessors
- Descricao: Demonstracao dos operadores de acesso ., ::, [] e .. em TheFlux
- Autor: TheFlux
- Versao: 0.5
D#

use AgentOfPrint as AP

enum (Status) {
      Ativo
      Inativo
}

struct (Ponto) {
      mut: .x: float64
      mut: .y: float64
}

program (ExampleOfAccessors) {
      print("=== Acesso a campos com ponto (.) ===")
      mut as Ponto: p = Ponto(
            .x: 10.5
            .y: 20.0
      )
      print(p.x)
      p.y = 35.0
      print(p.y)

      print("=== Resolucao de escopo com dois-pontos (::) ===")
      mut as Status: st = Status::Ativo
      print(st)
      AP::printNome()

      print("=== Indexacao e Fatiamento com colchetes e range ([] e ..) ===")
      mut as list of int64: lista = [10, 20, 30, 40, 50]
      print(lista[1])
      mut as list of int64: sub = lista[2..4]
      print(sub[1])
      print(sub[2])

      mut as tensor[2, 2] of float64: t
      t[1, 2] = 99.5
      mut as float64: elem = t[1, 2]
      print(elem)
}
