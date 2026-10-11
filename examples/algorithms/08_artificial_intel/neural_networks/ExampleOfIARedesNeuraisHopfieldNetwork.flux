#L ============================================================================
#L Algoritmo: Hopfield Network (Memoria Associativa Auto-Recorrente)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisHopfieldNetwork) {
      println("=== Algoritmo: Hopfield Network Energy ===")
      mut as int64: s1 = 1
      mut as int64: s2 = 1
      mut as int64: w12 = 2
      mut as int64: energy = 0 - (s1 * s2 * w12) /i 2
      println("1. Energia de Lyapunov da configuracao: " + energy)
      println("Teste concluido com sucesso.")
}
