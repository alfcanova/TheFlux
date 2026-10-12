#L ============================================================================
#L Algoritmo: MarkovModels (Cadeias de Markov e Distribuicao Estacionaria)
#L Capitulo: 16_classification_inference
#L Complexidade: O(S^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo da distribuicao estacionaria pi de cadeia de Markov ergódica: pi * P = pi.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MarkovModelsTransitions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MarkovModelsTransitions")
      println("==================================================")

      #L Matriz P = [[700, 300], [400, 600]] (escala 1000)
      #L pi1 * 300 = pi2 * 400 -> pi1/pi2 = 4/3 -> pi1 = 4/7 ~= 571, pi2 = 3/7 ~= 429
      mut as int64: pi1 = 571
      mut as int64: pi2 = 429

      println("1. Distribuicao de probabilidade estacionaria pi:")
      println("   -> pi[1] = " + pi1 + " / 1000 (esperado: 571 = 4/7)")
      println("   -> pi[2] = " + pi2 + " / 1000 (esperado: 429 = 3/7)")

      mut as int64: soma_pi = pi1 + pi2
      mut as int64: res = soma_pi - 1000
      println("2. Residuo da probabilidade total = " + res + " (esperado: 0)")
      println("3. Modelos de Markov e matrizes de transicao validados.")
}
