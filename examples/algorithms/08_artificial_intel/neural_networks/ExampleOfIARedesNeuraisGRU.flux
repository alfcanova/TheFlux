#L ============================================================================
#L Algoritmo: GRU (Gated Recurrent Unit com Portas de Atualizacao e Reinicio)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisGRU) {
      println("=== Algoritmo: Gated Recurrent Unit ===")
      mut as int64: hPrev = 40
      mut as int64: zUpdate = 70
      mut as int64: hCand = 60
      mut as int64: hNew = ((100 - zUpdate) * hPrev + zUpdate * hCand) /i 100
      println("1. Novo estado oculto interpolado GRU: " + hNew)
      println("Teste concluido com sucesso.")
}
