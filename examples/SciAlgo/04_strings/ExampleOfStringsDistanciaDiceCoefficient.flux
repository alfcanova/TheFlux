#L ============================================================================
#L Algoritmo: Dice Coefficient (Sørensen–Dice Coefficient)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(|A| + |B|) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaDiceCoefficient) {
      println("==================================================")
      println("  SciAlgo: Sørensen–Dice Coefficient")
      println("==================================================")

      mut as int64: tam_a = 6
      mut as int64: tam_b = 6
      mut as int64: intersecao = 4

      #L Dice = (2 * |A ∩ B|) / (|A| + |B|)
      mut as int64: dice_pct = (2 * intersecao * 100) /i (tam_a + tam_b)

      println("1. Tamanho A: " + tam_a + ", Tamanho B: " + tam_b)
      println("2. Elementos comuns: " + intersecao)
      println("3. Coeficiente de Dice: " + dice_pct + "%")
      println("4. Dice Coefficient concluido com sucesso.")
}
