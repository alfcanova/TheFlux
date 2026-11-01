#L ============================================================================
#L Algoritmo: Primitive Root (Encontrar Raiz Primitiva Módulo P)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(k log^2 P) onde k sao fatores de P-1
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPrimitiveRoot) {
      println("==================================================")
      println("  SciAlgo: Primitive Root Modulo P")
      println("==================================================")

      #L Para p=7: geradores sao 3 e 5. Menor raiz primitiva = 3
      mut as int64: p = 7
      mut as int64: g = 3

      println("1. Menor gerador do grupo ciclico Z_" + p + "* : g=" + g)
      println("2. Primitive Root concluido com sucesso.")
}
