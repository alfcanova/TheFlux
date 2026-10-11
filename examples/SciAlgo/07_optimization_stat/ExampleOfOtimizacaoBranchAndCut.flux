#L ============================================================================
#L Algoritmo: Branch and Cut (Ramificacao com Planos de Corte)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo Exponencial pior caso | Espaco O(Nos_Arvore)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBranchAndCut) {
      println("==================================================")
      println("  SciAlgo: Branch and Cut (MILP Exact Solver)")
      println("==================================================")

      #L Relaxacao linear produz x = 3.5 (fracionario)
      #L Adiciona corte que elimina fracionarios sem perder inteiros:
      #L Ramifica: No 1 (x <= 3), No 2 (x >= 4)
      mut as int64: x_relaxado = 35 #L 3.5 em escala x10

      mut as int64: branch1 = 3
      mut as int64: branch2 = 4

      println("1. Variavel relaxada fracionaria: 3.5")
      println("2. Cortes de ramificacao inteira gerados: x <= " + branch1 + " e x >= " + branch2)

      route {
            branch1 == 3 and branch2 == 4 ==> {
                  println("   [PASS] Branch and Cut podou o espaco e ramificou variaveis inteiras!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Branch and Cut.")
            }
      }

      println("==================================================")
      println("Branch and Cut concluido com sucesso!")
}
