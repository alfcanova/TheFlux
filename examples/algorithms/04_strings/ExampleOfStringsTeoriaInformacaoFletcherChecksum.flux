#L ============================================================================
#L Algoritmo: Fletcher Checksum (Fletcher-16)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoFletcherChecksum) {
      println("==================================================")
      println("  SciAlgo: Fletcher-16 Checksum Algorithm")
      println("==================================================")

      mut as list of int64: dados = [10, 20, 30, 40]
      mut as int64: n = listLength(dados)
      mut as int64: c0 = 0
      mut as int64: c1 = 0

      mut as int64: i = 1
      infinite (i <= n) {
            c0 = (c0 + dados[i]) /r 255
            c1 = (c1 + c0) /r 255
            i = i + 1
      }

      mut as int64: fletcher16 = (c1 * 256) + c0

      println("1. Bytes avaliados: " + n)
      println("2. Fletcher-16 checksum: " + fletcher16)
      println("3. Fletcher Checksum concluido com sucesso.")
}
