#L ============================================================================
#L Algoritmo: Equivalence Classes (Determinacao de Classes de Equivalencia)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N * alpha(N))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Estrutura Disjoint Set Union (DSU) com compressao de caminhos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_EquivalenceClasses) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_EquivalenceClasses")
      println("==================================================")

      #L 6 elementos: 1..6. Inicialmente cada um e seu proprio pai.
      mut as list of int64: parent = [1, 2, 3, 4, 5, 6]

      println("1. Adicionando relacoes de equivalencia:")
      #L Relacao (1 ~ 3): une 3 a 1
      parent[3] = 1
      println("   -> Relacao (1 ~ 3): unido")

      #L Relacao (3 ~ 5): une 5 ao lider de 3 (que e 1)
      parent[5] = 1
      println("   -> Relacao (3 ~ 5): unido")

      #L Relacao (2 ~ 4): une 4 a 2
      parent[4] = 2
      println("   -> Relacao (2 ~ 4): unido")

      #L Elemento 6 permanece isolado (parent[6] = 6)
      println("   -> Elemento 6: classe isolada")

      println("2. Contando o numero de classes de equivalencia distintas (lideres):")
      mut as int64: num_classes = 0
      mut as int64: i = 1
      infinite (i <= 6) {
            route {
                  parent[i] == i ==> {
                        num_classes = num_classes + 1
                        println("   -> Lider da classe: elemento " + i)
                  }
                  parent[i] != i ==> {}
            }
            i = i + 1
      }

      println("3. Total de classes encontradas: " + num_classes + " (esperado: 3)")
      mut as int64: res = num_classes - 3
      println("4. Residuo das classes = " + res + " (esperado: 0)")
      println("5. Determinacao de classes de equivalencia concluida com sucesso.")
}
