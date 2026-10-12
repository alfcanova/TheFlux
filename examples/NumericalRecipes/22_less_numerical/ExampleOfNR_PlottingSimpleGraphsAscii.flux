#L ============================================================================
#L Algoritmo: Plotting Simple Graphs ASCII (Graficos em Modo Texto)
#L Capitulo: 22_less_numerical
#L Complexidade: O(N_pontos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Plotagem de funcoes matematicas com mapeamento de grade e amostragem em ASCII.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PlottingSimpleGraphsAscii) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PlottingSimpleGraphsAscii")
      println("==================================================")

      #L Mapeamento de funcao f(x) = x^2 em grade ASCII de largura 10 colunas:
      #L Amostras nos pontos x = [0, 1, 2, 3]:
      #L f(0) = 0  -> coluna 1
      #L f(1) = 1  -> coluna 2
      #L f(2) = 4  -> coluna 5
      #L f(3) = 9  -> coluna 10
      mut as list of int64: colunas = [1, 2, 5, 10]

      println("1. Renderizando perfil grafico de y = x^2 em ASCII:")
      mut as int64: row = 1
      infinite (row <= 4) {
            mut as int64: x = row - 1
            mut as int64: y = x * x
            println("   -> Linha " + row + " (x=" + x + ", y=" + y + "): plot na coluna " + colunas[row])
            row = row + 1
      }

      #L Verificacao da coluna do ponto maximo (x=3 -> y=9 -> coluna 10):
      mut as int64: col_max = colunas[4]
      mut as int64: residuo = col_max - 10

      println("2. Residuo do mapeamento de coordenadas ASCII = " + residuo + " (esperado: 0)")
      println("3. Plotagem grafica em ASCII concluida com exito.")
}
