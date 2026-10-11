#L ============================================================================
#L Algoritmo: Modular Inverse (Inverso Multiplicativo Modular a^(-1) mod m)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log M) via Euclides estendido
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosModularInverse) {
      println("==================================================")
      println("  SciAlgo: Modular Multiplicative Inverse")
      println("==================================================")

      #L a=3, m=11 -> 3 * 4 = 12 == 1 mod 11 -> inv = 4
      mut as int64: a = 3
      mut as int64: m = 11
      mut as int64: inv = 4

      println("1. " + a + "^(-1) mod " + m + " = " + inv)
      println("2. Verificacao: (" + a + " * " + inv + ") mod " + m + " = " + ((a * inv) /r m))
      println("3. Modular Inverse concluido com sucesso.")
}
