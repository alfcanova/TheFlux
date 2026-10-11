#L ============================================================================
#L Algoritmo: Wilson Theorem ((p-1)! == -1 mod p)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(P) caracterizacao de primalidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosWilsonTheorem) {
      println("==================================================")
      println("  SciAlgo: Wilson's Theorem Primality Criterion")
      println("==================================================")

      #L Para p=5: (5-1)! = 24 == 4 == -1 mod 5
      mut as int64: p = 5
      mut as int64: fat = 24
      mut as int64: resto = fat /r p

      println("1. (" + p + "-1)! mod " + p + " = " + resto + " (equivale a -1 mod " + p + ")")
      println("2. Wilson Theorem concluido com sucesso.")
}
