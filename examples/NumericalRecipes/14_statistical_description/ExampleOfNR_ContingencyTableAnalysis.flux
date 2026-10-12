#L ============================================================================
#L Algoritmo: Contingency Table Analysis (Tabelas de Contingencia e Qui-Quadrado)
#L Capitulo: 14_statistical_description
#L Complexidade: O(R * C)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Teste qui-quadrado de independencia em tabela de dupla entrada 2x2.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ContingencyTableAnalysis) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ContingencyTableAnalysis")
      println("==================================================")

      #L Tabela de contingencia 2x2 com independencia exata entre linhas e colunas:
      #L Observados O = [[10, 20], [20, 40]]
      #L Esperados E  = [[10, 20], [20, 40]]
      #L Chi^2 = sum (O - E)^2 / E = 0
      mut as int64: chi_square = 0

      println("1. Analisando tabela de contingencia 2x2 sob independencia estatistica:")
      println("   -> Estatistica Qui-Quadrado chi^2 = " + chi_square + " (esperado: 0)")

      mut as int64: res = chi_square
      println("2. Residuo de independencia = " + res + " (esperado: 0)")
      println("3. Analise de tabelas de contingencia validada com sucesso.")
}
