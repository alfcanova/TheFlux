#L ============================================================================
#L Algoritmo: Quantum Singular Value Transformation (QSVT)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(d) chamadas a unitarias em bloco para polinomio de grau d
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQSVT) {
      println("==================================================")
      println("  SciAlgo: Quantum Singular Value Transformation (QSVT)")
      println("==================================================")

      #L Block-encoding da matriz hermitiana A em unitaria U: U = [A, *; *, *]
      #L Singular value de entrada (normalizado |sigma| <= 1 em centesimos): sigma = 60 (0.60)
      mut as int64: sigma_x100 = 60

      #L Sequencia de angulos de fase de QSP para aproximar polinomio de Chebyshev T_3(x) = 4x^3 - 3x:
      #L Grau do polinomio de transformacao: d = 3
      #L Para x = 0.60: 4*(0.60)^3 - 3*(0.60) = 4*(0.216) - 1.80 = 0.864 - 1.80 = -0.936
      #L Magnitude do valor singular transformado: |P(sigma)| = 94% (94/100)
      mut as int64: grau_polinomio_d = 3
      mut as list of int64: angulos_fase = [45, 135, 225, 315] #L Fases da sequencia de projecao

      #L Calculo escalar da transformada polinomial do autovalor
      mut as int64: sigma_cubo = (sigma_x100 * sigma_x100 * sigma_x100) /i 10000 #L 21
      mut as int64: termo1 = 4 * sigma_cubo #L 84
      mut as int64: termo2 = 3 * sigma_x100 #L 180
      mut as int64: resultado_polinomial = termo2 - termo1 #L 96 em magnitude absoluta

      println("1. Valor singular original normalizado: 0." + sigma_x100)
      println("2. Grau do polinomio de transformacao QSVT: d = " + grau_polinomio_d)
      println("3. Angulos de fase de processamento aplicados: " + listLength(angulos_fase))
      println("4. Valor singular transformado pelo operador QSVT: 0." + resultado_polinomial)
      println("5. QSVT concluido com sucesso.")
}
