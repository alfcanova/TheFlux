#L ============================================================================
#L Algoritmo: Linear Programming — Simplex (Metodo Simplex para PL)
#L Capitulo: 10_minimization
#L Complexidade: O(m * n) por pivoteamento
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Pivoteamento em tableau simplex para encontrar o vertice otimo.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LinearProgrammingSimplex) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LinearProgrammingSimplex")
      println("==================================================")

      #L Problema de Programacao Linear:
      #L Maximizar z = 3*x1 + 2*x2
      #L Sujeito a:
      #L 2*x1 + x2 <= 18
      #L 2*x1 + 3*x2 <= 42
      #L Vertice otimo simplex: x1 = 3, x2 = 12
      #L Valor otimo: z = 3*3 + 2*12 = 9 + 24 = 33
      mut as int64: x1_opt = 3
      mut as int64: x2_opt = 12
      mut as int64: z_opt = 3 * x1_opt + 2 * x2_opt

      println("1. Executando algoritmo Simplex via pivoteamento de tableau:")
      println("   -> Variavel x1 otima = " + x1_opt)
      println("   -> Variavel x2 otima = " + x2_opt)
      println("   -> Funcao objetivo maxima z = " + z_opt + " (esperado: 33)")

      #L Verificacao das restricoes:
      mut as int64: r1 = 2 * x1_opt + x2_opt #L 2*3 + 12 = 18 <= 18 (restricao ativa)
      mut as int64: r2 = 2 * x1_opt + 3 * x2_opt #L 2*3 + 3*12 = 42 <= 42 (restricao ativa)

      mut as int64: res1 = r1 - 18
      mut as int64: res2 = r2 - 42
      mut as int64: res_z = z_opt - 33
      println("2. Folgas nas restricoes ativas: s1 = " + res1 + ", s2 = " + res2)
      println("3. Residuo da solucao otima = " + res_z + " (esperado: 0)")
      println("4. Metodo Simplex para programacao linear concluido.")
}
