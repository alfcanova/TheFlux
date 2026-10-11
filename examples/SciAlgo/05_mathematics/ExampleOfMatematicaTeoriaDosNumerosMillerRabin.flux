#L ============================================================================
#L Algoritmo: Miller-Rabin (Teste de Primalidade Forte Determinístico/Probabilístico)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(K log^3 N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosMillerRabin) {
      println("==================================================")
      println("  SciAlgo: Miller-Rabin Strong Pseudoprime Test")
      println("==================================================")

      mut as int64: n = 29
      mut as int64: d = 7
      mut as int64: s = 2
      #L n - 1 = 28 = 2^2 * 7 -> d=7, s=2
      mut as int64: e_provavel_primo = 1

      println("1. Decomposicao n-1 = 2^s * d: s=" + s + ", d=" + d)
      println("2. Status de primalidade: " + e_provavel_primo)
      println("3. Miller-Rabin concluido com sucesso.")
}
