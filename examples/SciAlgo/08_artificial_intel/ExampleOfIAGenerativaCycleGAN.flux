#L ============================================================================
#L Algoritmo: CycleGAN (Traducao Nao-Pareada com Perda de Consistencia de Ciclo)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaCycleGAN) {
      println("=== Algoritmo: CycleGAN ===")
      mut as int64: origX = 50
      mut as int64: cycleX = 48
      mut as int64: cycleDiff = origX - cycleX
      mut as int64: cycleConsistencyLoss = cycleDiff * cycleDiff
      println("1. Perda de consistencia de ciclo: " + cycleConsistencyLoss)
      println("Teste concluido com sucesso.")
}
