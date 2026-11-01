#L ============================================================================
#L Algoritmo: Multilayer Perceptron (MLP com Camada Oculta)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisMultilayerPerceptron) {
      println("=== Algoritmo: Multilayer Perceptron ===")
      mut as int64: inX = 10
      mut as int64: wHidden = 2
      mut as int64: hOut = inX * wHidden
      mut as int64: wOut = 3
      mut as int64: yPred = hOut * wOut
      println("1. Ativacao oculta: " + hOut)
      println("2. Saida da rede MLP: " + yPred)
      println("Teste concluido com sucesso.")
}
