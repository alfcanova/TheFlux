#L ============================================================================
#L Algoritmo: Content-Based Filtering (Perfil de Usuario e Atributos de Item)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoContentBasedFiltering) {
      println("=== Algoritmo: Content-Based Filtering ===")
      mut as list of int64: userPref = [80, 20]
      mut as list of int64: itemProfile = [75, 25]
      mut as int64: matchScore = (userPref[1] * itemProfile[1] + userPref[2] * itemProfile[2]) /i 100
      println("1. Aderencia do item ao perfil do usuario: " + matchScore)
      println("Teste concluido com sucesso.")
}
