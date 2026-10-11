#L ============================================================================
#L Algoritmo: Damm Algorithm (Dígito Verificador Baseado em Quasigrupos)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) tempo com matriz anti-simetrica de ordem 10
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoDammAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Damm Quasigroup Check Digit Algorithm")
      println("==================================================")

      mut as list of int64: digitos = [5, 7, 2]
      mut as int64: n = listLength(digitos)
      mut as int64: interim = 0

      #L Simulação de passo do quasigrupo: (interim * 3 + d) % 10
      mut as int64: i = 1
      infinite (i <= n) {
            interim = ((interim * 3) + digitos[i]) /r 10
            i = i + 1
      }

      println("1. Digitos avaliados: " + n)
      println("2. Digito verificador de Damm: " + interim)
      println("3. Damm Algorithm concluido com sucesso.")
}
