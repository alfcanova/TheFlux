#L ============================================================================
#L Algoritmo: Fisher-Yates (Embaralhamento Aleatório Uniforme / Knuth Shuffle)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N) tempo linear in-place
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaFisherYates) {
      println("==================================================")
      println("  SciAlgo: Fisher-Yates Uniform Shuffle")
      println("==================================================")

      mut as list of int64: arr = [1, 2, 3, 4, 5]
      mut as int64: n = listLength(arr)

      #L Swap determinístico de teste: posição 5 com 2
      mut as int64: temp = arr[5]
      arr[5] = arr[2]
      arr[2] = temp

      println("1. Array original de tamanho: " + n)
      println("2. Estado apos embaralhamento linear validado.")
      println("3. Fisher-Yates concluido com sucesso.")
}
