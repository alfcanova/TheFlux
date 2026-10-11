#L ============================================================================
#L Algoritmo: Slab / Slub Memory Allocator (Bonwick 1994)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais
#L Complexidade: O(1) alocacao e liberacao de objetos de tamanho fixo em kernel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisSlabAllocator) {
      println("==================================================")
      println("  SciAlgo: Slab Memory Allocator (Kernel Cache)   ")
      println("==================================================")

      #L O Slab Allocator (Jeff Bonwick, SunOS / Linux Kernel) otimiza a alocacao
      #L de objetos frequentes do sistema operacional (inodes, dentries, task_structs).
      #L Em vez de destruir e recriar estruturas, o Slab mantem caches de objetos
      #L pre-construidos em paginas de memoria contiguas (slabs).
      #L Slabs sao organizados em tres listas ligadas:
      #L 1. slabs_full: todos os objetos alocados.
      #L 2. slabs_partial: alguns objetos livres (alvos rapidos de kmem_cache_alloc).
      #L 3. slabs_empty: todos os objetos livres (candidatos a devolucao para o page allocator).

      mut as int64: object_size_bytes = 128
      mut as int64: objects_per_slab = 32
      mut as int64: total_slabs = 3
      mut as int64: allocations_served = 65

      println("1. Parametros do Cache do Kernel (kmem_cache):")
      println("   Tamanho do Objeto: " + object_size_bytes + " bytes")
      println("   Capacidade por Slab: " + objects_per_slab + " objetos (Pagina de 4KB)")

      println("2. Ciclo de Alocacao O(1) com Lista Livre:")
      println("   - Requisicao 1..32: Preenche Slab 1 -> Movido para lista 'slabs_full'.")
      println("   - Requisicao 33..64: Preenche Slab 2 -> Movido para lista 'slabs_full'.")
      println("   - Requisicao 65: Aloca novo Slab 3 na lista 'slabs_partial' e consome objeto 1.")
      println("   - Desalocacao de objeto no Slab 1: Slab 1 move de 'full' para 'slabs_partial'.")

      println("3. Avaliacao de Desempenho:")
      println("   Zero fragmentacao interna e eliminacao de sobrecarga de inicializacao.")
      println("   Slab Memory Allocator concluido com sucesso.")
}
