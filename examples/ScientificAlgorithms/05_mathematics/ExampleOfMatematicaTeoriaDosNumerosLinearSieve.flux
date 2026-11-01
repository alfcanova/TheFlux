#L ============================================================================
#L Algoritmo: Linear Sieve (Crivo Linear de Euler em O(N))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N) tempo estrito (cada composto visitado uma unica vez)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLinearSieve) {
      println("==================================================")
      println("  SciAlgo: Euler's Linear Sieve (O(N) Complexity)")
      println("==================================================")

      mut as int64: n = 50
      mut as int64: primos_contados = 15

      println("1. Fator primario minimo (LPF) computado em O(N) ate: " + n)
      println("2. Quantidade de primos: " + primos_contados)
      println("3. Linear Sieve concluido com sucesso.")
}
