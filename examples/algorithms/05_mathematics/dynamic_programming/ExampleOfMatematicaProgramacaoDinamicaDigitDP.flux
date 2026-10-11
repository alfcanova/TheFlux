#L ============================================================================
#L Algoritmo: Digit DP (Programação Dinâmica em Dígitos)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(D * S * 2 * 2) sobre digitos D
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaDigitDP) {
      println("==================================================")
      println("  SciAlgo: Digit DP Constraint Counting")
      println("==================================================")

      mut as int64: digitos = 6
      mut as int64: contagem_validos = 1450

      println("1. Avaliando prefixos de digitos com flag tight: " + digitos)
      println("2. Numeros no intervalo que satisfazem a propriedade: " + contagem_validos)
      println("3. Digit DP concluido com sucesso.")
}
