#L ============================================================================
#L Algoritmo: Backpropagation (Retropropagacao do Erro pela Regra da Cadeia)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisBackpropagation) {
      println("=== Algoritmo: Backpropagation ===")
      mut as int64: target = 100
      mut as int64: yPred = 80
      mut as int64: deltaOut = target - yPred
      mut as int64: inputX = 5
      mut as int64: lr = 1
      mut as int64: gradWeight = deltaOut * inputX
      mut as int64: weightUpdate = gradWeight * lr
      println("1. Gradiente retropropagado: " + gradWeight)
      println("2. Atualizacao de peso delta W: " + weightUpdate)
      println("Teste concluido com sucesso.")
}
