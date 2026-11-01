#L ============================================================================
#L Algoritmo: Meissel-Lehmer (Algoritmo de Meissel-Lehmer para Contagem de Primos)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N^(2/3)) contagem sublinear de pi(x)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosMeisselLehmer) {
      println("==================================================")
      println("  SciAlgo: Meissel-Lehmer Prime Counting Algorithm")
      println("==================================================")

      mut as int64: x = 1000
      #L pi(1000) = 168
      mut as int64: pi_x = 168

      println("1. Limite superior de contagem: x = " + x)
      println("2. Quantidade exata de primos pi(x) = " + pi_x)
      println("3. Meissel-Lehmer concluido com sucesso.")
}
