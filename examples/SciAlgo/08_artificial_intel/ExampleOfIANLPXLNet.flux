#L ============================================================================
#L Algoritmo: XLNet (Permutation Language Modeling com Transformer-XL)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPXLNet) {
      println("=== Algoritmo: XLNet Permutation LM ===")
      mut as list of int64: permOrder = [3, 1, 4, 2]
      mut as int64: firstFactor = permOrder[1]
      println("1. Ordem de permutacao fatorial de tokens: [3, 1, 4, 2]")
      println("2. Primeiro token condicionado: " + firstFactor)
      println("Teste concluido com sucesso.")
}
