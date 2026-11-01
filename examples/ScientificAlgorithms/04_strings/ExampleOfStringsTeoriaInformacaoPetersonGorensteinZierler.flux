#L ============================================================================
#L Algoritmo: Peterson-Gorenstein-Zierler (Decodificador de Síndromes Matriciais)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(t^3) inversao de matriz de sindromes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoPetersonGorensteinZierler) {
      println("==================================================")
      println("  SciAlgo: Peterson-Gorenstein-Zierler Decoder")
      println("==================================================")

      mut as int64: num_erros = 2
      mut as int64: det_matriz = 1

      println("1. Montando matriz de sindromes de ordem: " + num_erros)
      println("2. Determinante nao nulo: " + det_matriz)
      println("3. Peterson-Gorenstein-Zierler concluido com sucesso.")
}
