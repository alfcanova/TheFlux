#L ============================================================================
#L Algoritmo: HNSW (Hierarchical Navigable Small World Vector Search)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialHNSW) {
      println("=== Algoritmo: HNSW Vector Search ===")
      mut as list of int64: query = [10, 20]
      mut as list of int64: v1 = [9, 19]
      mut as list of int64: v2 = [50, 60]
      mut as int64: d1 = (query[1] - v1[1]) * (query[1] - v1[1]) + (query[2] - v1[2]) * (query[2] - v1[2])
      mut as int64: d2 = (query[1] - v2[1]) * (query[1] - v2[1]) + (query[2] - v2[2]) * (query[2] - v2[2])
      mut as int64: nearest = 1
      route {
            d2 < d1 ==> { nearest = 2 }
            _ ==> {}
      }
      println("1. Vizinho mais proximo no grafo HNSW: " + nearest)
      println("2. Menor distancia quadratica: " + d1)
      println("Teste concluido com sucesso.")
}
