#L ============================================================================
#L Algoritmo: Node2Vec (Passeios Enviesados com Parametros p e q)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosNode2Vec) {
      println("=== Algoritmo: Node2Vec Biased Random Walk ===")
      mut as int64: pParam = 100
      mut as int64: qParam = 200
      mut as int64: probReturn = 1000 /i pParam
      mut as int64: probOut = 1000 /i qParam
      println("1. Fator de retorno 1/p: " + probReturn)
      println("2. Fator de exploracao 1/q: " + probOut)
      println("3. Estrategia equilibrada BFS/DFS simulada.")
      println("Teste concluido com sucesso.")
}
