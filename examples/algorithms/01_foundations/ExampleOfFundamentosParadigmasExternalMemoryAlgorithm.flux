#L ============================================================================
#L Algoritmo: External-Memory Algorithm (Modelo I/O Eficiente de Dois Niveis)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N / B) transferencias de bloco I/O | Cache de tamanho M
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasExternalMemoryAlgorithm) {
      println("==================================================")
      println("  SciAlgo: External-Memory Algorithm (Dois Niveis)")
      println("==================================================")

      #L Disco com N = 16 elementos divididos em 4 blocos de B = 4 elementos
      #L Bloco 1: [10, 20, 30, 40]
      #L Bloco 2: [50, 60, 70, 80]
      #L Bloco 3: [90, 100, 110, 120]
      #L Bloco 4: [130, 140, 150, 160]
      mut as list of int64: disk_data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160]
      mut as int64: n = listLength(disk_data)
      mut as int64: block_b = 4
      mut as int64: num_blocks = n /i block_b

      println("1. Dados no armazenamento externo (N = " + n + ", B = " + block_b + "): " + disk_data)
      println("2. Total de blocos no disco: " + num_blocks)

      #L Cache na RAM suporta 1 bloco de cada vez (M = B)
      #L Varredura linear com leitura bloco a bloco (I/O-Aware)
      mut as int64: cached_block_id = 0
      mut as int64: io_transfers = 0
      mut as int64: cache_hits = 0
      mut as int64: total_sum = 0

      mut as int64: i = 1
      infinite (i <= n) {
            #L Calcula o bloco em disco que contem o indice i (1-based)
            mut as int64: target_block = ((i - 1) /i block_b) + 1

            route {
                  cached_block_id == target_block ==> {
                        cache_hits = cache_hits + 1
                  }
                  _ ==> {
                        #L Falha de pagina (Cache Miss): transfere bloco de tamanho B do disco para RAM
                        io_transfers = io_transfers + 1
                        cached_block_id = target_block
                  }
            }

            total_sum = total_sum + disk_data[i]
            i = i + 1
      }

      println("3. Transferencias de bloco I/O realizadas: " + io_transfers)
      println("4. Acertos em memoria RAM (Cache Hits): " + cache_hits)
      println("5. Soma total dos elementos acumulada: " + total_sum)
      println("6. Eficiencia I/O: " + io_transfers + " leituras de bloco para " + n + " elementos (= N/B)")
      println("Concluido com Sucesso")
}
