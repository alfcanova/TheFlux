#L ============================================================================
#L Algoritmo: Pipeline Distribuído MapReduce (Map, Shuffle/Partition, Reduce)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(N) no Map, O(N log N) no Shuffle/Sort, O(N) no Reduce
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoMapReduce) {
      println("==================================================")
      println("  SciAlgo: Pipeline Distribuído MapReduce")
      println("==================================================")

      #L Documentos de entrada particionados em 3 splits
      #L Dicionário de tokens:
      #L 1: flux, 2: cluster, 3: map, 4: reduce, 5: node, 6: task
      mut as list of int64: split1 = [1, 2, 3, 4]
      mut as list of int64: split2 = [1, 5, 6, 3]
      mut as list of int64: split3 = [2, 6, 1, 4]

      #L ------------------------------------------------------------------------
      #L Fase 1: MAP
      #L Três nós mappers processam seus splits e geram pares intermediários (k, 1)
      #L ------------------------------------------------------------------------
      println("1. [Fase Map] Mappers processam splits de dados:")
      println("   -> Mapper 1 processa Split 1 (tamanho 4)")
      println("   -> Mapper 2 processa Split 2 (tamanho 4)")
      println("   -> Mapper 3 processa Split 3 (tamanho 4)")

      #L Vetor plano de pares intermediarios: lista de chaves emitidas
      mut as list of int64: map_keys = []
      mut as int64: i = 1
      infinite (i <= 4) {
            map_keys = listPushBack(map_keys, split1[i])
            i = i + 1
      }
      i = 1
      infinite (i <= 4) {
            map_keys = listPushBack(map_keys, split2[i])
            i = i + 1
      }
      i = 1
      infinite (i <= 4) {
            map_keys = listPushBack(map_keys, split3[i])
            i = i + 1
      }

      mut as int64: total_emitted = listLength(map_keys)
      println("   Total de pares intermediarios emitidos: " + total_emitted)

      #L ------------------------------------------------------------------------
      #L Fase 2: SHUFFLE & PARTITION
      #L Particiona entre 2 Reducers: Chaves impares -> Reducer 1, Pares -> Reducer 2
      #L ------------------------------------------------------------------------
      println("2. [Fase Shuffle & Partition] Roteando para 2 Reducers (hash(k) mod 2):")

      mut as list of int64: r1_keys = []
      mut as list of int64: r2_keys = []

      i = 1
      infinite (i <= total_emitted) {
            mut as int64: k = map_keys[i]
            mut as int64: part = k /r 2
            route {
                  part == 1 ==> {
                        r1_keys = listPushBack(r1_keys, k)
                  }
                  _ ==> {
                        r2_keys = listPushBack(r2_keys, k)
                  }
            }
            i = i + 1
      }

      println("   -> Reducer 1 recebeu " + listLength(r1_keys) + " chaves (partição ímpar: 1, 3, 5)")
      println("   -> Reducer 2 recebeu " + listLength(r2_keys) + " chaves (partição par: 2, 4, 6)")

      #L ------------------------------------------------------------------------
      #L Fase 3: REDUCE (Agregação / Contagem de Frequência)
      #L ------------------------------------------------------------------------
      println("3. [Fase Reduce] Agrupamento e agregacao de contagens por chave:")

      #L Contadores para as chaves 1..6
      mut as list of int64: counts = [0, 0, 0, 0, 0, 0]

      #L Reducer 1 agrega
      mut as int64: len_r1 = listLength(r1_keys)
      i = 1
      infinite (i <= len_r1) {
            mut as int64: k1 = r1_keys[i]
            counts[k1] = counts[k1] + 1
            i = i + 1
      }

      #L Reducer 2 agrega
      mut as int64: len_r2 = listLength(r2_keys)
      i = 1
      infinite (i <= len_r2) {
            mut as int64: k2 = r2_keys[i]
            counts[k2] = counts[k2] + 1
            i = i + 1
      }

      #L Emissão dos resultados consolidados
      println("4. Saída consolidada do MapReduce (Word Count):")
      mut as list of string: token_names = ["flux", "cluster", "map", "reduce", "node", "task"]
      mut as int64: tid = 1
      infinite (tid <= 6) {
            println("   Chave " + tid + " ('" + token_names[tid] + "'): total = " + counts[tid])
            tid = tid + 1
      }

      println("5. Pipeline MapReduce concluído com consistência determinística.")
}
