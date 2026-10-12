#L ============================================================================
#L Algoritmo: Arithmetic Coding (Codificacao Aritmetica de Dados)
#L Capitulo: 22_less_numerical
#L Complexidade: O(N_simbolos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Codificacao de fluxo de simbolos em sub-intervalos reais sucessivos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ArithmeticCoding) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ArithmeticCoding")
      println("==================================================")

      #L Alfabeto binario com probabilidades p(A) = 0.6 (600), p(B) = 0.4 (400)
      #L Intervalo inicial: [low=0, high=1000]
      #L Sequencia a codificar: [A, B]
      mut as int64: low = 0
      mut as int64: high = 1000

      println("1. Intervalo inicial: [" + low + ", " + high + "]")

      #L Passo 1: Simbolo 'A' (faixa 0% a 60% do intervalo):
      #L range = high - low = 1000
      #L high = low + (1000 * 600)/1000 = 600
      high = low + (((high - low) * 600) /i 1000)
      println("   -> Apos simbolo 'A': [" + low + ", " + high + "]")

      #L Passo 2: Simbolo 'B' (faixa 60% a 100% do novo intervalo):
      #L range = 600 - 0 = 600
      #L low = 0 + (600 * 600)/1000 = 360
      #L high = 0 + (600 * 1000)/1000 = 600
      mut as int64: rng = high - low
      low = low + ((rng * 600) /i 1000)
      println("   -> Apos simbolo 'B': [" + low + ", " + high + "]")

      #L Valor do codigo transmitido (ponto medio do intervalo final):
      #L code_tag = (360 + 600) / 2 = 480 (0.480)
      mut as int64: code_tag = (low + high) /i 2
      println("2. Tag numerica aritmetica final transmitida = " + code_tag + " / 1000")

      #L Decodificacao do primeiro simbolo a partir de code_tag = 480:
      #L Como 480 < 600, o primeiro simbolo decodificado e 'A'!
      mut as int64: sym1_decodificado = 0
      route {
            code_tag < 600 ==> { sym1_decodificado = 1 } #L 1 representa 'A'
            code_tag >= 600 ==> { sym1_decodificado = 2 }
      }

      mut as int64: residuo = 1 - sym1_decodificado
      println("3. Residuo da decodificacao exata = " + residuo + " (esperado: 0)")
      println("4. Codificacao aritmetica concluida com exito.")
}
