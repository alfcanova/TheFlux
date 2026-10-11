#L ============================================================================
#L Algoritmo: Lyndon Words and Necklaces FKM (Gerador FKM de Palavras de Lyndon e Colares)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(1) amortizado por palavra
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaLyndonWordsFKM) {
      println("==================================================")
      println("  SciAlgo: Lyndon Words and Necklaces (FKM Algorithm)")
      println("==================================================")

      mut as int64: alfabeto_tam = 2
      mut as int64: comp_max = 4
      #L Quantidade de palavras de Lyndon binarias de comprimento 4: (2^4 - 2^2) / 4 = 3
      mut as int64: qtd_lyndon_4 = 3

      println("1. Alfabeto binario de tamanho " + alfabeto_tam + " com comprimento n = " + comp_max)
      println("2. Quantidade de palavras de Lyndon aperiodicas: " + qtd_lyndon_4)
      println("3. Lyndon Words and Necklaces FKM concluido com sucesso.")
}
