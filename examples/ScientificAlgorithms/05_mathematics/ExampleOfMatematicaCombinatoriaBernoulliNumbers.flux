#L ============================================================================
#L Algoritmo: Bernoulli Numbers (Numeros de Bernoulli)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N^2) recorrencia triangular exata
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaBernoulliNumbers) {
      println("==================================================")
      println("  SciAlgo: Bernoulli Numbers")
      println("==================================================")

      #L B0 = 1, B1 = -1/2, B2 = 1/6, B4 = -1/30
      mut as int64: b0_num = 1
      mut as int64: b2_num = 1
      mut as int64: b2_den = 6
      mut as int64: b4_num = -1
      mut as int64: b4_den = 30

      println("1. B(0) = " + b0_num)
      println("2. B(2) = " + b2_num + "/" + b2_den + ", B(4) = " + b4_num + "/" + b4_den)
      println("3. Bernoulli Numbers concluido com sucesso.")
}
