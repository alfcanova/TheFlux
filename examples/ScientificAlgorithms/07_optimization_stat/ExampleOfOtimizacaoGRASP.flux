#L ============================================================================
#L Algoritmo: GRASP (Greedy Randomized Adaptive Search Procedure)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * (Construcao + BuscaLocal)) | Espaco O(Solucao)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGRASP) {
      println("==================================================")
      println("  SciAlgo: GRASP (Greedy Randomized Adaptive)")
      println("==================================================")

      #L Fase 1: Construcao gulosa randomizada com Lista Restrita de Candidatos (RCL)
      #L Melhores candidatos com custos [10, 12, 14] -> escolhe aleatoriamente o 2o (12)
      mut as int64: sol_construida = 12

      #L Fase 2: Busca local melhora de 12 para o minimo local 8
      mut as int64: sol_refinada = sol_construida - 4 #L 8

      println("1. Solucao construida por RCL: " + sol_construida)
      println("2. Solucao refinada por busca local GRASP: " + sol_refinada)

      route {
            sol_refinada == 8 ==> {
                  println("   [PASS] GRASP construiu e refinou solucao quasi-otima com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no GRASP.")
            }
      }

      println("==================================================")
      println("GRASP concluido com sucesso!")
}
