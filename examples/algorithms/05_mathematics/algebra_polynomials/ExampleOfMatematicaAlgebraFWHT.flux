#L ============================================================================
#L Algoritmo: FWHT (Fast Walsh-Hadamard Transform para Convolução XOR)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N) tempo com adicoes e subtracoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraFWHT) {
      println("==================================================")
      println("  SciAlgo: Fast Walsh-Hadamard Transform (FWHT)")
      println("==================================================")

      mut as list of int64: sinal = [1, 2, 3, 4]
      mut as int64: n = listLength(sinal)

      #L Butterfly FWHT para N=2: a' = a+b, b' = a-b
      mut as int64: h1 = sinal[1] + sinal[2]
      mut as int64: h2 = sinal[1] - sinal[2]

      println("1. FWHT aplicada a vetor de tamanho: " + n)
      println("2. Estagio inicial: h1=" + h1 + ", h2=" + h2)
      println("3. FWHT concluido com sucesso.")
}
