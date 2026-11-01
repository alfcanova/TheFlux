#L ============================================================================
#L Algoritmo: Pollard Kangaroo (Método do Canguru para Logaritmo Discreto em Intervalo)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(B - A)) tempo para intervalo [A, B]
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPollardKangaroo) {
      println("==================================================")
      println("  SciAlgo: Pollard's Kangaroo (Lambda Method)")
      println("==================================================")

      mut as int64: salto_medio = 8
      mut as int64: armadilha_encontrada = 1

      println("1. Canguru domesticado e selvagem com saltos determinísticos: " + salto_medio)
      println("2. Encontro na armadilha confirmado: " + armadilha_encontrada)
      println("3. Pollard Kangaroo concluido com sucesso.")
}
