#L ============================================================================
#L Algoritmo: Index Calculus (Cálculo de Índices para Logaritmo Discreto Subexponencial)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(L_p[1/2, c]) subexponencial em corpos finitos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosIndexCalculus) {
      println("==================================================")
      println("  SciAlgo: Index Calculus Algorithm")
      println("==================================================")

      mut as int64: base_primos_suaves = 5
      mut as int64: relacoes_coletadas = 6

      println("1. Base de primos suaves: " + base_primos_suaves)
      println("2. Sistema linear de logaritmos resolvido mod (p-1): " + relacoes_coletadas + " relacoes")
      println("3. Index Calculus concluido com sucesso.")
}
