#L ============================================================================
#L Algoritmo: Run-Length Encoding — RLE (Compressão de Carreiras)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N) linear tempo e espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoRunLengthEncoding) {
      println("==================================================")
      println("  SciAlgo: Run-Length Encoding (RLE)")
      println("==================================================")

      mut as list of int64: dados = [1, 1, 1, 1, 2, 2, 3, 3, 3]
      mut as int64: n = listLength(dados)

      mut as int64: runs_contados = 1
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  dados[i] != dados[i - 1] ==> {
                        runs_contados = runs_contados + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Elementos originais: " + n)
      println("2. Total de sequencias continuas (runs): " + runs_contados)
      println("3. RLE concluido com sucesso.")
}
