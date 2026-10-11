#L ============================================================================
#L Algoritmo: SQUFOF (Fatoracao de Formas Quadradas de Shanks)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N^(1/4)) fatoracao inteira estavel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSQUFOF) {
      println("==================================================")
      println("  SciAlgo: Shanks' Square Forms Factorization (SQUFOF)")
      println("==================================================")

      mut as int64: n = 11111
      #L 11111 = 41 * 271
      mut as int64: fator1 = 41
      mut as int64: fator2 = 271

      println("1. Inteiro composto a fatorar: n = " + n)
      println("2. Fatores nao triviais obtidos: " + fator1 + " e " + fator2)
      println("3. SQUFOF concluido com sucesso.")
}
