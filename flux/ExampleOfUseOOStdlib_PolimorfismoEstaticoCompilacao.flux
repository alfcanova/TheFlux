use AgentOfOOStdLib_PolimorfismoEstatico

struct (Cachorro) {
      mut: .nome: string
      mut: .raca: string
}

struct (Gato) {
      mut: .nome: string
      mut: .pelagem: string
}

program (ExampleOfUseOOStdlib_PolimorfismoEstaticoCompilacao) {
      println("==================================================")
      println("  2.B. Polimorfismo Estatico (Zero-Cost / Compilacao)")
      println("==================================================")

      mut as Cachorro: cao = Cachorro(.nome: "Bob", .raca: "Beagle")
      mut as Gato: gato = Gato(.nome: "Mimi", .pelagem: "Persa")

      #L 1. Chamadas diretas monomorfizadas pelo compilador (Zero VTable overhead)
      #L O backend LLVM / VM resolve o endereco diretamente em tempo de compilacao
      mut as string: info_cao = formatarCachorro(cao.nome, cao.raca)
      println("1. Chamada estatica inlinavel para Cao: " + info_cao)

      mut as string: info_gato = formatarGato(gato.nome, gato.pelagem)
      println("2. Chamada estatica inlinavel para Gato: " + info_gato)

      #L 2. Polimorfismo Estrutural via Pattern Matching Estatico
      #L O compilador gera saltos diretos (Jump Table) na AST
      println("\n3. Despacho por Pattern Matching resolvido estaticamente:")
      match (cao) {
            Cachorro(.nome: n, .raca: r) ==> {
                  println("   Match exato de Cachorro no compilador: " + n)
            }
      }

      match (gato) {
            Gato(.nome: n, .pelagem: p) ==> {
                  println("   Match exato de Gato no compilador: " + n)
            }
      }
}
