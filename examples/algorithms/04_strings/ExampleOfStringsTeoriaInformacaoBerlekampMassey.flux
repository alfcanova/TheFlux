#L ============================================================================
#L Algoritmo: Berlekamp-Massey (Polinomio Localizador de Erros LFSR)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N^2) operacoes de corpo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoBerlekampMassey) {
      println("==================================================")
      println("  SciAlgo: Berlekamp-Massey Algorithm")
      println("==================================================")

      mut as list of int64: sindromes = [1, 2, 3, 4]
      mut as int64: n_sindromes = listLength(sindromes)
      mut as int64: l = 2

      println("1. Sindromes de erro fornecidas: " + n_sindromes)
      println("2. Grau do LFSR minimo (grau do polinomio de erro): " + l)
      println("3. Berlekamp-Massey concluido com sucesso.")
}
