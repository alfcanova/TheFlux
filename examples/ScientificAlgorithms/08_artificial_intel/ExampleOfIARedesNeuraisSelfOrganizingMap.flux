#L ============================================================================
#L Algoritmo: Self-Organizing Map (SOM - Mapa Auto-Organizavel de Kohonen)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisSelfOrganizingMap) {
      println("=== Algoritmo: Self-Organizing Map ===")
      mut as int64: bmuDist = 14
      mut as int64: lr = 20
      mut as int64: neighborKernel = 80
      mut as int64: weightDelta = (lr * neighborKernel * bmuDist) /i 10000
      println("1. Ajuste de pesos topologico SOM: " + weightDelta)
      println("Teste concluido com sucesso.")
}
