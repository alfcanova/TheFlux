#L ============================================================================
#L Algoritmo: GraphSAGE (Sample and Aggregate Graph Neural Network)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGraphSAGE) {
      println("=== Algoritmo: GraphSAGE ===")
      mut as list of int64: featV = [10, 20]
      mut as list of int64: featU1 = [15, 25]
      mut as list of int64: featU2 = [25, 35]
      mut as int64: agg1 = (featU1[1] + featU2[1]) /i 2
      mut as int64: agg2 = (featU1[2] + featU2[2]) /i 2
      mut as int64: hNew1 = (featV[1] + agg1) /i 2
      mut as int64: hNew2 = (featV[2] + agg2) /i 2
      println("1. Feature agregada vizinhanca [1]: " + agg1)
      println("2. Nova representacao do no [1]: " + hNew1)
      println("Teste concluido com sucesso.")
}
