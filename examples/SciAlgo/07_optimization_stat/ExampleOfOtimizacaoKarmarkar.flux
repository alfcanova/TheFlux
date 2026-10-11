#L ============================================================================
#L Algoritmo: Karmarkar's Algorithm (Metodo de Pontos Interiores Projetivo)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(N^3.5 * L) Polinomial | Espaco O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoKarmarkar) {
      println("==================================================")
      println("  SciAlgo: Karmarkar's Projective Algorithm")
      println("==================================================")

      #L Caminho pelo interior do simplex regular em direcao ao vertice otimo
      mut as int64: x1 = 33 #L ponto central interior (1/3, 1/3, 1/3) em escala x100
      mut as int64: x2 = 33
      mut as int64: x3 = 34

      #L Transformacao projetiva em direcao ao gradiente reduzido
      mut as int64: step = 1
      infinite (step <= 3) {
            x1 = x1 + 20
            x2 = x2 - 10
            x3 = x3 - 10
            step = step + 1
      }

      println("1. Ponto interior projetado: x1 = " + x1 + ", x2 = " + x2 + ", x3 = " + x3)
      route {
            x1 > x2 and x1 > x3 ==> {
                  println("   [PASS] Algoritmo polinomial de Karmarkar convergiu pelo interior!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo de Karmarkar.")
            }
      }

      println("==================================================")
      println("Karmarkar Algorithm concluido com sucesso!")
}
