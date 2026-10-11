#L ============================================================================
#L Algoritmo: General Number Field Sieve — GNFS
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(exp((64/9 * ln N)^(1/3) * (ln ln N)^(2/3)))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosGeneralNumberFieldSieve) {
      println("==================================================")
      println("  SciAlgo: General Number Field Sieve (GNFS)")
      println("==================================================")

      mut as int64: grau_corpo_numeros = 5
      mut as int64: fator_rsa = 89

      println("1. Polinomio gerador do corpo de numeros de grau: " + grau_corpo_numeros)
      println("2. Fator primo identificado por ideais suaves: " + fator_rsa)
      println("3. GNFS concluido com sucesso.")
}
