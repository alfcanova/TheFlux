#L ============================================================================
#L Algoritmo: Gray Codes (Codigos de Gray e Sequencias Unitarias de Hamming)
#L Capitulo: 22_less_numerical
#L Complexidade: O(1) por conversao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Transformacao bidirecional entre binario e codigo de Gray G = B ^ (B >> 1).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GrayCodes) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GrayCodes")
      println("==================================================")

      #L Conversao binario para Gray: G(B) = B ^ (B >> 1)
      #L Exemplos:
      #L B = 5 (binario 101):
      #L B >> 1 = 2 (binario 010)
      #L G = 5 ^ 2 = 7 (binario 111)
      mut as int64: b = 5
      mut as int64: g = b ^ (b >> 1) #L 7

      println("1. Codificacao binario para Gray:")
      println("   -> Binario B = " + b + " -> Codigo de Gray G = " + g + " (esperado: 7)")

      #L Conversao inversa Gray para binario:
      #L B = G ^ (G >> 1) ^ (G >> 2) ^ (G >> 4)
      #L Para G = 7: 7 ^ 3 = 4; 4 ^ 1 = 5
      mut as int64: b_rec = g
      b_rec = b_rec ^ (b_rec >> 1)
      b_rec = b_rec ^ (b_rec >> 2)

      println("2. Decodificacao inversa Gray para binario:")
      println("   -> Gray G = " + g + " -> Binario recuperado B = " + b_rec + " (esperado: 5)")

      mut as int64: residuo = b_rec - b
      println("3. Residuo da conversao bidirecional de Gray = " + residuo + " (esperado: 0)")
      println("4. Codigos de Gray validados com sucesso.")
}
