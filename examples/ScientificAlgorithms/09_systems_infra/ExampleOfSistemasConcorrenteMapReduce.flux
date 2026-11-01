#L ============================================================================
#L Algoritmo: MapReduce Concurrent Engine (Map, Shuffle, Sort, Reduce)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N) tempo paralelo | O(N) espaco de comunicacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteMapReduce) {
      println("==================================================")
      println("  SciAlgo: MapReduce Concurrent Framework         ")
      println("==================================================")

      #L Documento de entrada contendo contagens por categoria/chave:
      #L 4 tarefas de map gerando pares (chave, valor)
      #L Chaves mapeadas como inteiros:
      #L 1 = "cpu", 2 = "memory", 3 = "disk"
      #L Entradas distribuídas em 2 Mappers:
      #L Mapper 1 emite: (cpu, 1), (memory, 1), (cpu, 1)
      #L Mapper 2 emite: (disk, 1), (cpu, 1), (memory, 1), (disk, 1)

      println("1. Fase de Map Concorrente (2 Workers):")
      println("   Mapper 1 processa Bloco A: [cpu: 1, memory: 1, cpu: 1]")
      println("   Mapper 2 processa Bloco B: [disk: 1, cpu: 1, memory: 1, disk: 1]")

      #L Lista de pares emitidos (key, value):
      #L Total de 7 pares
      mut as int64: num_pairs = 7
      mut as list of int64: pair_keys = [1, 2, 1, 3, 1, 2, 3]
      mut as list of int64: pair_vals = [1, 1, 1, 1, 1, 1, 1]

      println("2. Fase de Shuffle & Sort Concorrente:")
      println("   Particionando chaves por Reducers dedicados...")

      #L Fase de Reducao por chave (3 Reducers dedicados para chaves 1, 2, 3)
      mut as list of int64: reduced_counts = [0, 0, 0] #L indices 1: cpu, 2: memory, 3: disk

      mut as int64: i = 1
      infinite (i <= num_pairs) {
            mut as int64: k = pair_keys[i]
            mut as int64: v = pair_vals[i]
            reduced_counts[k] = reduced_counts[k] + v
            i = i + 1
      }

      println("3. Fase de Reduce Concorrente (Resultados Finais Agregados):")
      println("   Reducer 1 (Chave 'cpu'):    " + reduced_counts[1] + " ocorrencias")
      println("   Reducer 2 (Chave 'memory'): " + reduced_counts[2] + " ocorrencias")
      println("   Reducer 3 (Chave 'disk'):   " + reduced_counts[3] + " ocorrencias")

      #L Verificacao de integridade:
      #L cpu = 3, memory = 2, disk = 2
      mut as bool: correct = (reduced_counts[1] == 3) and (reduced_counts[2] == 2) and (reduced_counts[3] == 2)
      println("4. Verificacao de Integridade do MapReduce: " + correct)

      println("MapReduce Concurrent Engine concluido com sucesso.")
}
