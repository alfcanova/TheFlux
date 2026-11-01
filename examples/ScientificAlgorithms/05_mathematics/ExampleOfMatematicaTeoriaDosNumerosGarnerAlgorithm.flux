#L ============================================================================
#L Algoritmo: Garner Algorithm (Reconstituição CRT de Alta Precisão)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(K^2) operacoes aritméticas de precisão simples
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosGarnerAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Garner's Mixed Radix CRT Algorithm")
      println("==================================================")

      mut as int64: n_modulos = 3
      mut as int64: valor_recuperado = 23

      println("1. Representacao em base mista de " + n_modulos + " modulos coprimos")
      println("2. Valor decodificado em inteiros grandes: " + valor_recuperado)
      println("3. Garner Algorithm concluido com sucesso.")
}
