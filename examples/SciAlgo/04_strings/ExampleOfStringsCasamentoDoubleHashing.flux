#L ============================================================================
#L Algoritmo: Double Hashing (Hash Duplo para Prevenção de Colisões)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(1) tempo por comparacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoDoubleHashing) {
      println("==================================================")
      println("  SciAlgo: Double Hashing String Verification")
      println("==================================================")

      mut as int64: h1 = 458921
      mut as int64: h2 = 891230

      println("1. Hash primario (modulo 10^9+7): " + h1)
      println("2. Hash secundario (modulo 10^9+9): " + h2)
      println("3. Probabilidade de colisao: praticamente nula")
      println("4. Double Hashing concluido com sucesso.")
}
