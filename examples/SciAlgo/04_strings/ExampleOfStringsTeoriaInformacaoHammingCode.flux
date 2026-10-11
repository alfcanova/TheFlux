#L ============================================================================
#L Algoritmo: Hamming Code (Código de Hamming (7,4))
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(1) codificacao e decodificacao de bloco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoHammingCode) {
      println("==================================================")
      println("  SciAlgo: Hamming (7,4) Error-Correcting Code")
      println("==================================================")

      #L Dados originais: d1=1, d2=0, d3=1, d4=1
      mut as int64: d1 = 1
      mut as int64: d2 = 0
      mut as int64: d3 = 1
      mut as int64: d4 = 1

      #L Bits de paridade: p1 = d1^d2^d4, p2 = d1^d3^d4, p3 = d2^d3^d4
      mut as int64: p1 = (d1 + d2 + d4) /r 2
      mut as int64: p2 = (d1 + d3 + d4) /r 2
      mut as int64: p3 = (d2 + d3 + d4) /r 2

      println("1. Mensagem de 4 bits: [" + d1 + ", " + d2 + ", " + d3 + ", " + d4 + "]")
      println("2. Bits de paridade gerados: p1=" + p1 + ", p2=" + p2 + ", p3=" + p3)
      println("3. Palavra codificada (7 bits): [" + p1 + ", " + p2 + ", " + d1 + ", " + p3 + ", " + d2 + ", " + d3 + ", " + d4 + "]")
      println("4. Hamming (7,4) concluido com sucesso.")
}
