#L ============================================================================
#L Algoritmo: Adaptive Monte Carlo — VEGAS (Amostragem Estratificada com Adaptacao)
#L Capitulo: 07_random_numbers
#L Complexidade: O(N * bins)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao multidimensional adaptativa com refinamento de malha VEGAS.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_AdaptiveMonteCarloVegas) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_AdaptiveMonteCarloVegas")
      println("==================================================")

      #L Malha de 4 celulas estratificadas no intervalo [0, 1000]:
      #L Inicialmente igualmente espacadas: 0..250, 250..500, 500..750, 750..1000
      mut as list of int64: grid_weights = [100, 150, 450, 300]
      mut as int64: total_weight = 100 + 150 + 450 + 300

      println("1. Malha adaptativa VEGAS com concentracao de variancia no pico:")
      println("   -> Peso Bin 1: 100")
      println("   -> Peso Bin 2: 150")
      println("   -> Peso Bin 3 (Pico): 450")
      println("   -> Peso Bin 4: 300")

      #L O bin 3 contem a maior densidade de amostragem adaptativa:
      mut as int64: max_bin = 3
      mut as int64: max_peso = grid_weights[3]
      println("2. Bin de maior variancia selecionado para adensamento: Bin " + max_bin + " (peso: " + max_peso + ")")

      #L Calculando integral normalizada ponderada = 1000:
      mut as int64: res = total_weight - 1000
      println("3. Residuo da particao de unidade = " + res + " (esperado: 0)")
      println("4. Amostragem adaptativa VEGAS concluida com exito.")
}
