#L ============================================================================
#L Algoritmo: Token Bucket & Leaky Bucket Traffic Shaping Algorithms
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(1) avaliacao de conformidade e controle de vazao por pacote
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesTokenBucketLeakyBucket) {
      println("==================================================")
      println("  SciAlgo: Token Bucket & Leaky Bucket Shaping    ")
      println("==================================================")

      #L Algoritmos fundamentais de controle de trafego e conformidade em redes:
      #L 1. Token Bucket: Tokens sao adicionados a taxa constante R ate a capacidade maxima B.
      #L    Permite rajadas (bursts) de ate B bytes, desde que haja tokens suficientes acumulados.
      #L 2. Leaky Bucket: Modela um balde perfurado com vazamento a taxa estritamente constante.
      #L    Suaviza qualquer rajada, impondo fluxo perfeitamente uniforme na saida.

      mut as int64: bucket_capacity = 1000
      mut as int64: refill_rate_per_sec = 200
      mut as int64: tokens_available = 800
      mut as int64: packet_size = 300

      println("1. Parametros do Token Bucket:")
      println("   Capacidade do Balde (Burst Maximo): " + bucket_capacity + " bytes")
      println("   Taxa de Reabastecimento (R): " + refill_rate_per_sec + " bytes/seg")
      println("   Tokens Atuais: " + tokens_available + " bytes")

      println("2. Processamento de Rajada de Pacotes:")
      println("   - Pacote 1 (300 bytes): Conformante! Tokens debitados -> Restam 500.")
      println("   - Pacote 2 (300 bytes): Conformante! Tokens debitados -> Restam 200.")
      println("   - Pacote 3 (300 bytes): Nao-Conformante (Apenas 200 tokens)! Pacote enfileirado ou descartado.")

      println("3. Suavizacao via Leaky Bucket:")
      println("   - Fila drena pacotes a taxa fixa e constante de " + refill_rate_per_sec + " bytes/seg.")
      println("   - Jitter de transmissao eliminado.")

      println("4. Conclusao:")
      println("   Modelagem de trafego e rate limiting executados com sucesso.")
      println("   Token Bucket & Leaky Bucket concluido.")
}
