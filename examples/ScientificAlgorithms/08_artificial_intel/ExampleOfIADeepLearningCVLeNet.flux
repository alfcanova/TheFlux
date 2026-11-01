#L ============================================================================
#L Algoritmo: LeNet-5 (Rede Convolucional Classica para Reconhecimento de Digitos)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVLeNet) {
      println("=== Algoritmo: LeNet-5 CNN ===")
      mut as int64: inDim = 32
      mut as int64: conv1 = inDim - 5 + 1
      mut as int64: pool1 = conv1 /i 2
      mut as int64: conv2 = pool1 - 5 + 1
      mut as int64: pool2 = conv2 /i 2
      println("1. Dimensao C1: " + conv1)
      println("2. Dimensao S2: " + pool1)
      println("3. Dimensao C3: " + conv2)
      println("4. Dimensao S4: " + pool2)
      println("Teste concluido com sucesso.")
}
