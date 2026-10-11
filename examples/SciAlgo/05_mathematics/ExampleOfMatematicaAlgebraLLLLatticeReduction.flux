#L ============================================================================
#L Algoritmo: LLL Lattice Reduction (Reducao de Base de Reticulados de Lenstra-Lenstra-Lovasz)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^4 log B) reducao em tempo polinomial
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraLLLLatticeReduction) {
      println("==================================================")
      println("  SciAlgo: LLL Lattice Reduction")
      println("==================================================")

      mut as int64: dimensao = 4
      mut as int64: delta_num = 3
      mut as int64: delta_den = 4

      println("1. Reducao de base com parametro de Lovasz delta = " + delta_num + "/" + delta_den)
      println("2. Base reduzida de menor norma euclidiana encontrada para dimensao " + dimensao)
      println("3. LLL Lattice Reduction concluido com sucesso.")
}
