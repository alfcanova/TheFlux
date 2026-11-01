#L ============================================================================
#L Algoritmo: Feature Space Ensemble (Diversidade em Espaco de Caracteristicas)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleFeatureSpaceEnsemble) {
      println("=== Algoritmo: Feature Space Ensemble ===")
      mut as int64: proj1 = 45
      mut as int64: proj2 = 72
      mut as int64: jointRep = (proj1 + proj2) /i 2
      println("1. Representacao conjunta no espaco de projecoes: " + jointRep)
      println("Teste concluido com sucesso.")
}
