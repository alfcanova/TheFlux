#L ============================================================================
#L Algoritmo: Locality-Sensitive Hashing (LSH com Hiperplanos Aleatorios)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoLocalitySensitiveHashing) {
      println("=== Algoritmo: Locality-Sensitive Hashing ===")
      mut as int64: dotH1 = 12
      mut as int64: dotH2 = 0 - 8
      mut as int64: bit1 = 0
      mut as int64: bit2 = 0
      route {
            dotH1 >= 0 ==> { bit1 = 1 }
            _ ==> {}
      }
      route {
            dotH2 >= 0 ==> { bit2 = 1 }
            _ ==> {}
      }
      mut as int64: hashBucket = bit1 * 2 + bit2
      println("1. Bits do hash LSH: [" + bit1 + ", " + bit2 + "]")
      println("2. Bucket de colisao semantica: " + hashBucket)
      println("Teste concluido com sucesso.")
}
