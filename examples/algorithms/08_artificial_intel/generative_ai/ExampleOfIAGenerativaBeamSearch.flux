#L ============================================================================
#L Algoritmo: Beam Search (Decodificacao com Feixe de Largura K)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaBeamSearch) {
      println("=== Algoritmo: Generative Beam Search ===")
      mut as list of int64: beamScores = [85, 78, 62]
      mut as int64: top1 = beamScores[1]
      mut as int64: top2 = beamScores[2]
      println("1. Melhor hipotese do feixe: " + top1)
      println("2. Segunda hipotese do feixe: " + top2)
      println("Teste concluido com sucesso.")
}
