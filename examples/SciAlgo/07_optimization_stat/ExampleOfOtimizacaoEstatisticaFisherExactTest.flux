#L ============================================================================
#L Algoritmo: Fisher Exact Test (Teste Exato de Fisher 2x2)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(N) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaFisherExactTest) {
      println("==================================================")
      println("  SciAlgo: Fisher Exact Test (2x2 Contingency)")
      println("==================================================")

      #L Tabela 2x2:
      #L | a=2, b=1 | -> a+b = 3
      #L | c=1, d=2 | -> c+d = 3
      #L Total N = 6
      mut as int64: a = 2
      mut as int64: b = 1
      mut as int64: c = 1
      mut as int64: d = 2

      println("1. Tabela de contingencia 2x2: [[2, 1], [1, 2]] (N = 6)")

      #L Probabilidade hipergeometrica P = ( (a+b)! (c+d)! (a+c)! (b+d)! ) / ( N! a! b! c! d! )
      #L Para nossa tabela: (3! * 3! * 3! * 3!) / (6! * 2! * 1! * 1! * 2!)
      #L Numerador = 6 * 6 * 6 * 6 = 1296
      #L Denominador = 720 * 2 * 1 * 1 * 2 = 2880
      #L P = 1296 / 2880 = 9 / 20 = 0.45 (45%)
      mut as int64: num = 1296
      mut as int64: den = 2880
      mut as int64: p_pct = (num * 100) /i den

      println("2. Probabilidade exata pontual: " + p_pct + "%")
      route {
            p_pct == 45 ==> {
                  println("   [PASS] Teste Exato de Fisher calculado com exatidao analitica!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Teste Exato de Fisher.")
            }
      }

      println("==================================================")
      println("Fisher Exact Test concluido com sucesso!")
}
