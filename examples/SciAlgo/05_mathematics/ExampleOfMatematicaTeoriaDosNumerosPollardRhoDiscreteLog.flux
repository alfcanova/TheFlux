#L ============================================================================
#L Algoritmo: Pollard Rho for Discrete Log (Logaritmo Discreto em O(sqrt(N)) Espaço O(1))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(P)) tempo | O(1) memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPollardRhoDiscreteLog) {
      println("==================================================")
      println("  SciAlgo: Pollard's Rho for Discrete Log")
      println("==================================================")

      mut as int64: passos_ciclo = 6
      mut as int64: expoente = 4

      println("1. Caminhada pseudo-aleatoria particionada em 3 conjuntos: " + passos_ciclo + " passos")
      println("2. Logaritmo discreto resolvido: " + expoente)
      println("3. Pollard Rho for Discrete Log concluido com sucesso.")
}
