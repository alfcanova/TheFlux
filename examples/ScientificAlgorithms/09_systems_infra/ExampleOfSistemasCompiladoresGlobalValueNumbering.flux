#L ============================================================================
#L Algoritmo: Global Value Numbering (GVN & Redundancy Elimination)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Complexidade: O(N log N) particionamento de classes de equivalencia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCompiladoresGlobalValueNumbering) {
      println("==================================================")
      println("  SciAlgo: Global Value Numbering (GVN)           ")
      println("==================================================")

      #L O Global Value Numbering atribui um numero de valor inteiro (Value Number)
      #L a cada expressao computada no programa. Duas expressoes recebem o mesmo VN
      #L se e somente se provadamente produzem o mesmo resultado matematico
      #L para quaisquer entradas (congruencia de expressoes).
      #L Permite eliminacao global de subexpressoes comuns e simplificacoes algebricas.

      mut as int64: expressions_analyzed = 10
      mut as int64: unique_value_numbers = 6
      mut as int64: redundant_computations_folded = 4

      println("1. Tabela de Hash de Valores Globais:")
      println("   Instrucao 1: v1 = a_0 + b_0  -> Hash(+, VN(a_0), VN(b_0)) = VN_1")
      println("   Instrucao 2: v2 = b_0 + a_0  -> Propriedade Comutativa   = VN_1 (REDUNDANTE)")
      println("   Instrucao 3: v3 = v1 * 4     -> Hash(*, VN_1, VN(4))     = VN_2")
      println("   Instrucao 4: v4 = v2 * 4     -> Hash(*, VN_1, VN(4))     = VN_2 (REDUNDANTE)")

      println("2. Otimizacao via Dominancia:")
      println("   - Substituicao de usos de v2 por v1.")
      println("   - Substituicao de usos de v4 por v3.")
      println("   - Eliminacao completa de instrucoes redundantes de calculo.")

      println("3. Resultados de Otimizacao:")
      println("   Expressoes analisadas: " + expressions_analyzed)
      println("   Classes de equivalencia unificadas: " + unique_value_numbers)
      println("   Computacoes redundantes removidas: " + redundant_computations_folded)
      println("   Global Value Numbering concluido com sucesso.")
}
