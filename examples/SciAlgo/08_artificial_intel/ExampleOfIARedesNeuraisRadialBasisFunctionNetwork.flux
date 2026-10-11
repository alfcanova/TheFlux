#L ============================================================================
#L Algoritmo: Radial Basis Function Network (RBF Network)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisRadialBasisFunctionNetwork) {
      println("=== Algoritmo: Radial Basis Function Network ===")
      mut as int64: xIn = 12
      mut as int64: centerC = 10
      mut as int64: distSq = (xIn - centerC) * (xIn - centerC)
      mut as int64: phiVal = 100 - distSq * 5
      mut as int64: weight = 3
      mut as int64: netOut = phiVal * weight
      println("1. Ativacao radial do centroide: " + phiVal)
      println("2. Saida linear ponderada RBF: " + netOut)
      println("Teste concluido com sucesso.")
}
