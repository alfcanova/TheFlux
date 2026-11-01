#L ============================================================================
#L Algoritmo: SimCLR (Simple Framework for Contrastive Learning of Visual Representations)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaSimCLR) {
      println("=== Algoritmo: SimCLR ===")
      mut as list of int64: projZ1 = [30, 40]
      mut as list of int64: projZ2 = [28, 42]
      mut as int64: cosineSim = (projZ1[1] * projZ2[1] + projZ1[2] * projZ2[2]) /i 100
      println("1. Similaridade latente entre aumentacoes de dados: " + cosineSim)
      println("Teste concluido com sucesso.")
}
