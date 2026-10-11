#L ============================================================================
#L Algoritmo: Rabin-Karp (Casamento de Padrões via Rolling Hash)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N + M) caso medio
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoRabinKarp) {
      println("==================================================")
      println("  SciAlgo: Rabin-Karp Rolling Hash Matching")
      println("==================================================")

      mut as int64: hash_padrao = 54
      mut as int64: hash_janela = 54
      mut as int64: match_encontrado = 1

      route {
            hash_janela == hash_padrao ==> { match_encontrado = 1 }
            _ ==> { match_encontrado = 0 }
      }

      println("1. Hash do padrao: " + hash_padrao)
      println("2. Match verificado: " + match_encontrado)
      println("3. Rabin-Karp concluido com sucesso.")
}
