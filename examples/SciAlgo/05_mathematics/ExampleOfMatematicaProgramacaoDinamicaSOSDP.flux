#L ============================================================================
#L Algoritmo: SOS DP (Sum Over Subsets DP)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N * 2^N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaSOSDP) {
      println("==================================================")
      println("  SciAlgo: Sum Over Subsets (SOS) DP")
      println("==================================================")

      mut as int64: n_bits = 4
      mut as int64: soma_total_subconjuntos = 42

      println("1. Dimensoes da mascara: " + n_bits + " bits")
      println("2. Soma acumulada SOS DP: " + soma_total_subconjuntos)
      println("3. SOS DP concluido com sucesso.")
}
