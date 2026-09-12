use HashStdLib

program (ExampleOfUseHashStdLib_HashDistributedContract) {
      println("==================================================")
      println("  Exemplo: HashDistributedContract (Sistemas Distribuidos)")
      println("==================================================")

      #L 1. Jump Consistent Hash (Google Lamping & Veach - 1-index)
      println("1. hashJumpConsistent(Chave=12345, Buckets=10) -> Servidor: " + hashJumpConsistent(12345, 10))
      println("   hashJumpConsistent(Chave=67890, Buckets=10) -> Servidor: " + hashJumpConsistent(67890, 10))
      println("   hashJumpConsistent(Chave=99999, Buckets=100) -> Servidor: " + hashJumpConsistent(99999, 100))

      #L 2. Bloom Filter Indices (Kirsch-Mitzenmacher - 1-index)
      mut as list of data: bloom_pos = hashBloomIndices("flux_elemento", 4, 1000)
      println("2. hashBloomIndices('flux_elemento', 4 hashes, tamanho 1000): " + bloom_pos)

      #L 3. SimHash 64-bit Fingerprint (Deteccao de similaridade de texto)
      mut as string: sh1 = hashSimHash("The Flux Programming Language")
      mut as string: sh2 = hashSimHash("The Flux Programming Language!")
      println("3. SimHash #1: " + sh1)
      println("   SimHash #2: " + sh2)

      #L 4. MinHash Signatures
      mut as list of data: minhash_sig = hashMinHash("The Flux Programming Language", 4)
      println("4. hashMinHash(4 assinaturas): " + minhash_sig)
}
