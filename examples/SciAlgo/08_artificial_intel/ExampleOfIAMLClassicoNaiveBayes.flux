#L ============================================================================
#L Algoritmo: Naive Bayes (Classificador Bayesiano sob Independencia Condicional)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoNaiveBayes) {
      println("=== Algoritmo: Naive Bayes ===")
      mut as int64: priorPos = 50
      mut as int64: pX1Pos = 80
      mut as int64: pX2Pos = 60
      mut as int64: postPos = (priorPos * pX1Pos * pX2Pos) /i 10000
      mut as int64: priorNeg = 50
      mut as int64: pX1Neg = 20
      mut as int64: pX2Neg = 30
      mut as int64: postNeg = (priorNeg * pX1Neg * pX2Neg) /i 10000
      mut as int64: bayesClass = 0
      route {
            postPos > postNeg ==> { bayesClass = 1 }
            _ ==> {}
      }
      println("1. Verossimilhanca posterior positiva: " + postPos)
      println("2. Verossimilhanca posterior negativa: " + postNeg)
      println("3. Decisao MAP (Max Posterior): " + bayesClass)
      println("Teste concluido com sucesso.")
}
