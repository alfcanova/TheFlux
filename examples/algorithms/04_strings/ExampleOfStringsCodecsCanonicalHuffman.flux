#L ============================================================================
#L Algoritmo: Huffman Canonical Coding (Codificacao Canonica de Huffman)
#L Dominio: 04_strings / Subdominio: modern_codecs
#L Complexidade: O(S log S) para S simbolos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCodecsCanonicalHuffman) {
      println("==================================================")
      println("  SciAlgo: Canonical Huffman Coding")
      println("==================================================")

      #L Comprimentos de código para simbolos A, B, C, D
      mut as list of int64: comprimentos = [1, 2, 3, 3]
      mut as int64: n = listLength(comprimentos)

      #L Gerador canônico: código = (codigo_ant + 1) << delta_bits
      mut as list of int64: codigos_canonicos = [0, 0, 0, 0]
      mut as int64: codigo_atual = 0
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  i > 1 ==> {
                        mut as int64: delta = comprimentos[i] - comprimentos[i - 1]
                        codigo_atual = (codigo_atual + 1) * 2
                  }
                  _ ==> {}
            }
            codigos_canonicos[i] = codigo_atual
            println("   Simbolo " + i + " (tam=" + comprimentos[i] + "): codigo=" + codigo_atual)
            i = i + 1
      }

      println("1. Codigos canonicos gerados com sucesso.")
}
