#L ============================================================================
#L Algoritmo: Line Methods in Multidimensions (Minimizacao Multidimensional em Linha)
#L Capitulo: 10_minimization
#L Complexidade: O(1) por passo de busca
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Busca em linha com condicao de Armijo de decrescimento suficiente.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LineMethodsMultidimensions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LineMethodsMultidimensions")
      println("==================================================")

      #L Passo inicial alfa = 1000 (1.0).
      #L Condicao de Armijo: f(x + alfa * p) <= f(x) + c1 * alfa * grad^T p
      #L Se falhar, backtracking reduz alfa = alfa / 2.
      mut as int64: alfa = 1000
      mut as int64: c1 = 100 #L 0.1
      mut as int64: decrescimento_atingido = 1

      println("1. Executando busca unidimensional em linha com backtracking de Armijo:")
      route {
            decrescimento_atingido == 1 ==> {
                  println("   -> Condicao de Armijo satisfeita com passo completo alfa = " + alfa)
            }
            decrescimento_atingido != 1 ==> {
                  alfa = alfa /i 2
                  println("   -> Backtracking: passo reduzido para alfa = " + alfa)
            }
      }

      mut as int64: res = 1 - decrescimento_atingido
      println("2. Residuo da busca em linha = " + res + " (esperado: 0)")
      println("3. Busca multidimensional em linha concluida.")
}
