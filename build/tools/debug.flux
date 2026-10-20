use AgentOfPrint as AP
enum (Status) { Ativo }
struct (Ponto) { mut: .x: float64 }
program (ExampleOfAccessors) {
      mut as Ponto: p = Ponto(.x: 10.5, .y: 20.0)
      print(p.x)
      p.y = 35.0
      print(p.y)
      mut as Status: st = Status::Ativo
      print(st)
      AP::printNome()
      mut as list of int64: lista = [10, 20, 30, 40, 50]
      print(lista[1])
      mut as list of int64: sub = lista[2..4]
      print(sub[1])
}