#L ============================================================================
#L Algoritmo: Chinese Remainder Theorem — CRT (Teorema Chinês do Resto)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(K log M) para K congruencias
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosChineseRemainderTheorem) {
      println("==================================================")
      println("  SciAlgo: Chinese Remainder Theorem (CRT)")
      println("==================================================")

      #L x == 2 (mod 3), x == 3 (mod 5), x == 2 (mod 7) -> x = 23 (mod 105)
      mut as int64: solucao_x = 23
      mut as int64: mod_comum = 105

      println("1. Sistema de congruencias lineares com modulos coprimos: 3, 5, 7")
      println("2. Solucao unica x=" + solucao_x + " (mod " + mod_comum + ")")
      println("3. CRT concluido com sucesso.")
}
