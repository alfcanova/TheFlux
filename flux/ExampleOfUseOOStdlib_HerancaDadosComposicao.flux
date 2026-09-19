struct (DadosAnimal) {
      mut: .especie: string
      mut: .peso: float64
      mut: .idade: int64
}

struct (Cachorro) {
      mut: .base: DadosAnimal
      mut: .raca: string
      mut: .dono: string
}

program (ExampleOfUseOOStdlib_HerancaDadosComposicao) {
      println("==================================================")
      println("  1.A. Heranca de Dados: Composicao de Structs")
      println("==================================================")

      #L Instanciando o objeto Cachorro com dados herdados de DadosAnimal via composicao
      mut as Cachorro: meu_cao = Cachorro(
            .base: DadosAnimal(
                  .especie: "Canis lupus familiaris"
                  .peso: 28.5
                  .idade: 3
            )
            .raca: "Golden Retriever"
            .dono: "Carlos Silva"
      )

      #L Acessando campos "herdados" através da composição contígua
      println("1. Especie (herdada): " + meu_cao.base.especie)
      println("   Idade (herdada): " + meu_cao.base.idade + " anos")
      println("   Peso (herdado): " + meu_cao.base.peso + " kg")
      println("   Raca (propria): " + meu_cao.raca)
      println("   Dono (proprio): " + meu_cao.dono)

      #L Modificando dados diretos da struct
      meu_cao.dono = "Maria Souza"
      println("\n2. Transferencia de propriedade do cao:")
      println("   Novo dono: " + meu_cao.dono)

      #L Atualizando a estrutura herdada por substituicao de estado
      meu_cao.base = DadosAnimal(
            .especie: "Canis lupus familiaris"
            .peso: 29.8
            .idade: 4
      )
      println("\n3. Dados da base animal atualizados:")
      println("   Nova idade: " + meu_cao.base.idade + " anos")
      println("   Novo peso: " + meu_cao.base.peso + " kg")

      #L Pattern Matching na estrutura composta
      match (meu_cao) {
            Cachorro(
                  .base: base
                  .raca: raca
                  .dono: dono
            ) ==> {
                  println("\n4. Pattern matching concluido: Cao " + raca + " de " + dono)
            }
      }
}
