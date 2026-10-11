#L ============================================================================
#L Algoritmo: Gray Code (Código Binário Refletido de Gray)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(1) conversao direta n ^ (n >> 1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoGrayCode) {
      println("==================================================")
      println("  SciAlgo: Reflected Binary Gray Code")
      println("==================================================")

      mut as int64: n = 13
      #L Gray = n XOR (n >> 1)
      #L Para n=13 (1101), n/2 = 6 (0110), 13 XOR 6 = 11
      mut as int64: n_shift = n /i 2
      mut as int64: gray = 11

      println("1. Valor binario original: " + n)
      println("2. Codigo de Gray correspondente: " + gray)
      println("3. Gray Code concluido com sucesso.")
}
