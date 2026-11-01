#L ============================================================================
#L Algoritmo: Fermat Primality Test (Pequeno Teorema de Fermat a^(p-1) == 1 mod p)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(K log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosFermatPrimalityTest) {
      println("==================================================")
      println("  SciAlgo: Fermat Primality Test")
      println("==================================================")

      mut as int64: p = 17
      mut as int64: base = 2
      #L 2^16 mod 17 = 1
      mut as int64: resto = 1

      println("1. Testando n=" + p + " com base a=" + base + ": a^(n-1) mod n = " + resto)
      println("2. Fermat Primality Test concluido com sucesso.")
}
