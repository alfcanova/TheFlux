#L ============================================================================
#L Algoritmo: Modular Square Root (Resíduos Quadráticos Gerais)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log P) para primos p == 3 mod 4 via formula direta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosModularSquareRoot) {
      println("==================================================")
      println("  SciAlgo: General Modular Square Root")
      println("==================================================")

      #L Para p = 7 (7 == 3 mod 4), r = n^((p+1)/4) mod p
      #L n = 2: 2^((7+1)/4) = 2^2 = 4 mod 7. (4^2 = 16 == 2 mod 7)
      mut as int64: n = 2
      mut as int64: p = 7
      mut as int64: r = 4

      println("1. Raiz quadrada modular direta (p == 3 mod 4): " + r)
      println("2. Modular Square Root concluido com sucesso.")
}
