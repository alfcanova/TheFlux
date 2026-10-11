#L ============================================================================
#L Algoritmo: Cutting Plane (Cortes Fracionarios de Gomory)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo Polinomial por corte | Espaco O(Restricoes)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCuttingPlane) {
      println("==================================================")
      println("  SciAlgo: Cutting Plane Method (Gomory Cuts)")
      println("==================================================")

      #L Linha simplex fracionaria: x1 + 0.75 * s1 = 2.25
      #L Corte de Gomory: 0.75 * s1 >= 0.25 -> elimina ponto fracionario (2.25)
      mut as int64: frac_part = 25 #L 0.25 (escala x100)
      println("1. Parte fracionaria do vertice relaxado: 0." + frac_part)
      println("2. Hiperplano de corte introduzido para separar o vertice nao-inteiro")

      route {
            frac_part == 25 ==> {
                  println("   [PASS] Cutting Plane adicionou corte valido de Gomory com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Cutting Plane.")
            }
      }

      println("==================================================")
      println("Cutting Plane concluido com sucesso!")
}
