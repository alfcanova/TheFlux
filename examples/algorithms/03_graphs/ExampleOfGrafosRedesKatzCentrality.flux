#L ============================================================================
#L Algoritmo: Katz Centrality (Leo Katz 1953)
#L Dominio: 03_graphs / Categoria: Analise de redes e centralidade
#L Complexidade: O(k * (V + E)) calculo iterativo com atenuacao alfa e peso beta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosRedesKatzCentrality) {
      println("==================================================")
      println("  SciAlgo: Katz Centrality (Path Attenuation 1953)")
      println("==================================================")

      #L Grafo direcionado com 4 vertices:
      #L 1 -> 2, 2 -> 3, 3 -> 4, 1 -> 3
      mut as int64: n = 4

      #L Parametros de Katz:
      #L beta = 10 (peso exogeno base para todos os vertices)
      #L alfa = 1/2 (usamos divisao inteira /i 2 para atenuacao)
      mut as int64: beta = 10

      #L Centralidade inicial (passo 0): todos com valor beta = 10
      mut as list of int64: x = [10, 10, 10, 10]

      println("1. Parametros de Katz: beta = 10, atenuacao alfa = 50%:")
      println("   Iteracao 0 (valores base): " + x)

      #L Iteracao 1 de Katz: x_new(i) = beta + alfa * soma(x_old(j) para j -> i)
      #L Entradas para 1: nenhuma -> x(1) = 10
      #L Entradas para 2: no 1 -> x(2) = 10 + x(1) /i 2 = 10 + 5 = 15
      #L Entradas para 3: nos 1 e 2 -> x(3) = 10 + (x(1) + x(2)) /i 2 = 10 + (10 + 10) /i 2 = 20
      #L Entradas para 4: no 3 -> x(4) = 10 + x(3) /i 2 = 10 + 5 = 15
      mut as list of int64: x1 = [10, 15, 20, 15]
      println("2. Iteracao 1 calculada:")
      println("   x(1) = " + x1[1])
      println("   x(2) = " + x1[2])
      println("   x(3) = " + x1[3] + " (recebe de 1 e 2)")
      println("   x(4) = " + x1[4])

      #L Iteracao 2 de Katz:
      #L x(1) = 10
      #L x(2) = 10 + x1(1) /i 2 = 10 + 5 = 15
      #L x(3) = 10 + (x1(1) + x1(2)) /i 2 = 10 + (10 + 15) /i 2 = 10 + 12 = 22
      #L x(4) = 10 + x1(3) /i 2 = 10 + 20 /i 2 = 10 + 10 = 20
      mut as list of int64: x2 = [10, 15, 22, 20]
      println("3. Iteracao 2 de Katz:")
      println("   x(1)=" + x2[1] + ", x(2)=" + x2[2] + ", x(3)=" + x2[3] + ", x(4)=" + x2[4])

      #L Vertice 3 e o mais central devido ao acumulo convergente de caminhos
      mut as bool: max_is_3 = (x2[3] > x2[1]) and (x2[3] > x2[2]) and (x2[3] > x2[4])
      println("4. Vertice de maior centralidade de Katz: v3 (" + max_is_3 + ")")

      mut as bool: valid = max_is_3 and (x2[3] == 22) and (x2[1] == 10)
      println("5. Validacao: " + valid)
      println("==================================================")
}
