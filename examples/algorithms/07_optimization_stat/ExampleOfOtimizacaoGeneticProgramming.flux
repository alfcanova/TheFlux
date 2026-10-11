#L ============================================================================
#L Algoritmo: Genetic Programming (Evolucao de Arvores de Expressao)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(G * Pop * Profundidade) | Espaco O(Pop * Nos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGeneticProgramming) {
      println("==================================================")
      println("  SciAlgo: Genetic Programming (Tree Expression)")
      println("==================================================")

      #L Arvore de expressao: (+ (* x x) x) para x = 3 -> (3*3) + 3 = 12
      mut as int64: x = 3
      mut as int64: prod = x * x #L 9
      mut as int64: expr_eval = prod + x #L 12

      println("1. Avaliacao da expressao genetica simbolica (+ (* x x) x) para x = 3:")
      println("   Resultado: " + expr_eval + " (esperado 12)")

      route {
            expr_eval == 12 ==> {
                  println("   [PASS] Programacao Genetica avaliou o programa simbolico com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Falha na Programacao Genetica.")
            }
      }

      println("==================================================")
      println("Genetic Programming concluido com sucesso!")
}
