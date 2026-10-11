#L ============================================================================
#L Algoritmo: Move-to-Front — MTF
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N * A) tempo para alfabeto A
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoMoveToFront) {
      println("==================================================")
      println("  SciAlgo: Move-To-Front (MTF) Transform")
      println("==================================================")

      mut as list of int64: alfabeto = [1, 2, 3, 4]
      mut as int64: simbolo_acessado = 3
      mut as int64: rank = 3

      #L Mover símbolo para a primeira posição
      alfabeto[3] = alfabeto[2]
      alfabeto[2] = alfabeto[1]
      alfabeto[1] = simbolo_acessado

      println("1. Rank retornado: " + rank)
      println("2. Alfabeto reorganizado: [" + alfabeto[1] + ", " + alfabeto[2] + ", " + alfabeto[3] + ", " + alfabeto[4] + "]")
      println("3. Move-To-Front concluido com sucesso.")
}
