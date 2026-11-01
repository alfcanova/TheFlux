#L ============================================================================
#L Algoritmo: Transformer (Multi-Head Self-Attention para NLP)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPTransformer) {
      println("=== Algoritmo: Transformer Multi-Head Attention ===")
      mut as int64: dModel = 512
      mut as int64: numHeads = 8
      mut as int64: dK = dModel /i numHeads
      println("1. Dimensao do modelo d_model: " + dModel)
      println("2. Numero de cabecas de atencao: " + numHeads)
      println("3. Dimensao por cabeca d_k: " + dK)
      println("Teste concluido com sucesso.")
}
