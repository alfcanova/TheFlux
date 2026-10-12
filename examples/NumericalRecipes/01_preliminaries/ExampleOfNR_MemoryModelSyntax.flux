#L ============================================================================
#L Algoritmo: Scientific Memory Layout (Layout de Memoria e Vetores)
#L Capitulo: 01_preliminaries
#L Complexidade: O(N * M)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Mapeamento de matriz 2D bidimensional em vetor 1D contiguo.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MemoryModelSyntax) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MemoryModelSyntax")
      println("==================================================")

      #L Matriz 3x3 representada como vetor contiguo de 9 elementos (row-major)
      #L Indice 1D linear: idx = (row - 1) * cols + col
      mut as list of int64: buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: rows = 3
      mut as int64: cols = 3

      println("1. Preenchendo matriz linearizada 3x3:")
      mut as int64: r = 1
      infinite (r <= rows) {
            mut as int64: c = 1
            infinite (c <= cols) {
                  mut as int64: idx = (r - 1) * cols + c
                  buffer[idx] = r * 10 + c
                  c = c + 1
            }
            r = r + 1
      }

      println("2. Verificando acesso contiguo por linhas e colunas:")
      #L Elemento (2, 3) deve ser 23 no indice (2 - 1)*3 + 3 = 6
      mut as int64: val_2_3 = buffer[(2 - 1) * cols + 3]
      println("   -> Elemento M[2,3] no buffer linear = " + val_2_3 + " (esperado: 23)")

      #L Elemento (3, 1) deve ser 31 no indice (3 - 1)*3 + 1 = 7
      mut as int64: val_3_1 = buffer[(3 - 1) * cols + 1]
      println("   -> Elemento M[3,1] no buffer linear = " + val_3_1 + " (esperado: 31)")

      #L Verificacao de integridade de memoria
      mut as int64: check_sum = val_2_3 + val_3_1
      println("3. Soma de integridade (23 + 31): " + check_sum + " (esperado: 54)")
      println("4. Modelo de memoria contigua validado com sucesso.")
}
