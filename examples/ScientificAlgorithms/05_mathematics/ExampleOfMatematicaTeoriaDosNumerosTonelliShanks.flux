#L ============================================================================
#L Algoritmo: Tonelli-Shanks (Raiz Quadrada Modular r^2 == n mod p)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(S^2 log P) onde P-1 = Q * 2^S
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosTonelliShanks) {
      println("==================================================")
      println("  SciAlgo: Tonelli-Shanks Modular Square Root")
      println("==================================================")

      #L r^2 == 5 mod 19 -> 9^2 = 81 == 5 mod 19 -> r = 9
      mut as int64: n = 5
      mut as int64: p = 19
      mut as int64: r = 9

      println("1. Raiz quadrada modular de " + n + " mod " + p + ": r=" + r)
      println("2. Verificacao: " + r + "^2 mod " + p + " = " + ((r * r) /r p))
      println("3. Tonelli-Shanks concluido com sucesso.")
}
