use OOStdLib

struct (Cachorro) {
      mut: .nome: string
      mut: .raca: string
}

struct (Gato) {
      mut: .nome: string
      mut: .pelagem: string
}

program (ExampleOfUseOOStdlib_PolimorfismoDinamico) {
      println("==================================================")
      println("  2.A. Polimorfismo Dinamico via OOStdLib")
      println("==================================================")

      mut as Cachorro: rex = Cachorro(.nome: "Rex", .raca: "Pastor Alemao")
      mut as Gato: felix = Gato(.nome: "Felix", .pelagem: "Siamês")

      #L 1. Upcasting: envelopando diferentes structs no contrato Animal
      mut as data: animal1 = ooCastToContract(rex, "Animal")
      mut as data: animal2 = ooCastToContract(felix, "Animal")

      #L 2. Colecao heterogenea de dados polimorficos
      mut as list of data: zoologico = [animal1, animal2]
      println("1. Zoologico contem " + [animal1, animal2] + " elementos.")

      #L 3. Despacho dinamico iterando sobre a colecao polimorfica
      println("\n2. Executando despacho dinamico:")
      infinite (bicho in zoologico) {
            mut as string: tipo = ooUnderlyingType(bicho)
            mut as data: desp = ooDispatch(bicho, "emitirSom", [])
            println("   Animal do tipo " + tipo + " disparou metodo " + desp["method"])
      }

      #L 4. Downcasting seguro para struct concreta original
      println("\n3. Downcasting seguro com verificacao:")
      mut as data: res_cao = ooDowncast(animal1, "Cachorro")
      route {
            res_cao.sta == "nice" ==> {
                  println("   Cão recuperado com sucesso: " + res_cao.val)
            }
            _ ==> {
                  println("   Falha ao recuperar cão")
            }
      }

      mut as data: res_gato = ooDowncast(animal2, "Gato")
      route {
            res_gato.sta == "nice" ==> {
                  println("   Gato recuperado com sucesso: " + res_gato.val)
            }
            _ ==> {
                  println("   Falha ao recuperar gato")
            }
      }
}
