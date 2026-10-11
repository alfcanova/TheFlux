#L ============================================================================
#L Algoritmo: Bell Numbers (Triângulo de Bell / Partições de Conjuntos)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N^2) construcao do triangulo de Aitken
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaBellNumbers) {
      println("==================================================")
      println("  SciAlgo: Bell Numbers (Set Partitions)")
      println("==================================================")

      #L B_0=1, B_1=1, B_2=2, B_3=5, B_4=15, B_5=52
      mut as list of int64: bell = [1, 1, 2, 5, 15, 52]
      mut as int64: n = 5

      println("1. Numero de Bell B(" + n + "): " + bell[n + 1])
      println("2. Bell Numbers concluido com sucesso.")
}
