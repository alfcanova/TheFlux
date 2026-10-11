#L ============================================================================
#L Algoritmo: Roaring Bitmaps (Estrutura de Bitmap Compactada Híbrida)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(N) operacoes de uniao e intersecao velozes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsRoaringBitmaps) {
      println("==================================================")
      println("  SciAlgo: Roaring Bitmaps Container Hybrid Model")
      println("==================================================")

      #L Divisão de inteiros de 32 bits: chave de 16 bits + valor de 16 bits
      mut as list of int64: ids = [10, 12, 15, 65540, 65545]
      mut as int64: n = listLength(ids)

      mut as int64: container_0_count = 0
      mut as int64: container_1_count = 0

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: val = ids[i]
            mut as int64: chunk = val /i 65536
            route {
                  chunk == 0 ==> { container_0_count = container_0_count + 1 }
                  chunk == 1 ==> { container_1_count = container_1_count + 1 }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Total de IDs inseridos: " + n)
      println("2. Chunk 0 elementos: " + container_0_count)
      println("3. Chunk 1 elementos: " + container_1_count)
      println("4. Roaring Bitmaps concluido com sucesso.")
}
