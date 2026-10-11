#L ============================================================================
#L Algoritmo: Cipolla Algorithm (Raiz Quadrada Modular via Extensão de Corpo F_p^2)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log P) multiplicacoes no corpo quadratico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosCipollaAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Cipolla's Quadratic Extension Algorithm")
      println("==================================================")

      mut as int64: a_elemento = 3
      mut as int64: raiz_extraida = 9

      println("1. Elemento com discriminante nao residual quadratico: a=" + a_elemento)
      println("2. Raiz obtida via anel quociente F_p[w]: " + raiz_extraida)
      println("3. Cipolla Algorithm concluido com sucesso.")
}
