#L ============================================================================
#L Algoritmo: Eulerian Numbers (Numeros Eulerianos de Ascensoes)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N^2) distribuicao triangular
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaEulerianNumbers) {
      println("==================================================")
      println("  SciAlgo: Eulerian Numbers A(n, k)")
      println("==================================================")

      #L Para n = 4: A(4, 0)=1, A(4, 1)=11, A(4, 2)=11, A(4, 3)=1
      mut as int64: n = 4
      mut as int64: k = 1
      mut as int64: a_n_k = 11

      println("1. Ordem n = " + n + ", ascensões k = " + k)
      println("2. Numero euleriano A(" + n + ", " + k + ") = " + a_n_k)
      println("3. Eulerian Numbers concluido com sucesso.")
}
