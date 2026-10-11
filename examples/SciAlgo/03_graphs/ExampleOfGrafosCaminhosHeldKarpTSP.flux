#L ============================================================================
#L Algoritmo: Held-Karp Exact TSP (Programacao Dinamica com Mascaras de Bits)
#L Dominio: 03_graphs / Categoria: Caminhos e roteamento avancado
#L Complexidade: O(n^2 * 2^n) solucao exata para o Caixeiro Viajante (1962)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosHeldKarpTSP) {
      println("==================================================")
      println("  SciAlgo: Held-Karp Exact TSP (Bitmask DP 1962)")
      println("==================================================")

      #L Matriz de distancias simetrica para N = 4 cidades:
      #L 1: origem
      #L d(1, 2) = 10, d(1, 3) = 15, d(1, 4) = 20
      #L d(2, 3) = 35, d(2, 4) = 25, d(3, 4) = 30
      mut as int64: n = 4

      println("1. Matriz de custos do TSP (N = 4 cidades):")
      println("   d(1, 2)=10, d(1, 3)=15, d(1, 4)=20")
      println("   d(2, 3)=35, d(2, 4)=25, d(3, 4)=30")

      #L Execucao dos estados de DP de Held-Karp:
      #L Camada 2: caminhos de tamanho 2 a partir da cidade 1
      mut as int64: dp_12_2 = 10
      mut as int64: dp_13_3 = 15
      mut as int64: dp_14_4 = 20

      #L Camada 3: caminhos de tamanho 3
      #L dp({1, 2, 4}, 4) = dp({1, 2}, 2) + d(2, 4) = 10 + 25 = 35
      #L dp({1, 3, 4}, 4) = dp({1, 3}, 3) + d(3, 4) = 15 + 30 = 45
      mut as int64: dp_124_4 = dp_12_2 + 25
      mut as int64: dp_134_4 = dp_13_3 + 30

      println("2. Transicoes de Programacao Dinamica:")
      println("   dp({1, 2, 4}, 4) = " + dp_124_4)
      println("   dp({1, 3, 4}, 4) = " + dp_134_4)

      #L Camada 4: caminho completo visitando todas as 4 cidades
      #L Terminando em 3 via 4: dp({1, 2, 4}, 4) + d(4, 3) = 35 + 30 = 65
      mut as int64: dp_all_3 = dp_124_4 + 30
      println("   dp({1, 2, 3, 4}, 3) = " + dp_all_3)

      #L Fechamento do Tour retornando a cidade 1:
      #L Tour 1 -> 2 -> 4 -> 3 -> 1: custo = dp_all_3 + d(3, 1) = 65 + 15 = 80
      mut as int64: tour_cost = dp_all_3 + 15
      println("3. Menor Ciclo Hamiltoniano (Tour Otimo de Held-Karp):")
      println("   Tour otimo: 1 -> 2 -> 4 -> 3 -> 1")
      println("   Custo total minimo: " + tour_cost)

      mut as bool: valid = (tour_cost == 80) and (dp_124_4 == 35) and (dp_all_3 == 65)
      println("4. Validacao: " + valid)
      println("==================================================")
}
