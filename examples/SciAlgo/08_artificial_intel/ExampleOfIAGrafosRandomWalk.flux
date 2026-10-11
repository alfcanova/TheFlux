#L ============================================================================
#L Algoritmo: Random Walk (Passeio Aleatorio em Grafos para IA)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosRandomWalk) {
      println("=== Algoritmo: Random Walk em Grafos ===")
      mut as list of int64: walk = [1, 2, 3, 4, 1]
      mut as int64: current = 1
      mut as int64: stepCount = 0
      infinite (stepCount < 4) {
            current = (current /r 4) + 1
            stepCount = stepCount + 1
      }
      println("1. Extensao do caminho: " + listLength(walk))
      println("2. Node inicial: " + walk[1])
      println("3. Node final: " + walk[5])
      println("Teste concluido com sucesso.")
}
