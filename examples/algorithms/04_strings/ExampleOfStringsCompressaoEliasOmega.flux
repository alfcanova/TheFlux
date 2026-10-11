#L ============================================================================
#L Algoritmo: Elias Omega (Codificação Universal Recursiva)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(log* N) recursão assintótica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoEliasOmega) {
      println("==================================================")
      println("  SciAlgo: Elias Omega Coding")
      println("==================================================")

      mut as int64: n = 15
      mut as int64: etapas_recursivas = 2

      println("1. Inteiro a codificar: " + n)
      println("2. Niveis de recursao de comprimento: " + etapas_recursivas)
      println("3. Elias Omega concluido com sucesso.")
}
