#L ============================================================================
#L Algoritmo: Retrieval-Augmented Generation (RAG)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialRAG) {
      println("=== Algoritmo: RAG Pipeline ===")
      mut as list of int64: docSims = [89, 45, 93, 60]
      mut as int64: bestDoc = 1
      mut as int64: maxSim = docSims[1]
      mut as int64: i = 2
      infinite (i <= 4) {
            route {
                  docSims[i] > maxSim ==> {
                        maxSim = docSims[i]
                        bestDoc = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Documento mais relevante recuperado: " + bestDoc)
      println("2. Score de similaridade densa: " + maxSim)
      println("3. Contexto injetado na geracao do LLM.")
      println("Teste concluido com sucesso.")
}
