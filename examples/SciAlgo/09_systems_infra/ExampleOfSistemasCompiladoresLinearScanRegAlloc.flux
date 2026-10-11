#L ============================================================================
#L Algoritmo: Linear Scan Register Allocation (Poletto & Sarkar 1999)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Complexidade: O(V log V) alocacao rapida em passagem linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCompiladoresLinearScanRegAlloc) {
      println("==================================================")
      println("  SciAlgo: Linear Scan Register Allocation        ")
      println("==================================================")

      #L O algoritmo de Linear Scan (Poletto & Sarkar, 1999) aloca registradores
      #L fisicos para variaveis temporarias ordenando os intervalos de vida (live intervals)
      #L pelo seu ponto de inicio. Ao contrario da coloracao de grafos (Chaitin, O(V^2)),
      #L o Linear Scan roda em tempo linear/quase-linear, ideal para compiladores JIT.
      #L Mantem uma lista ativa de intervalos e realiza spill do intervalo com maior
      #L ponto de termino quando o numero de registradores fisicos K eh excedido.

      mut as int64: physical_registers = 3
      mut as int64: live_intervals_count = 6
      mut as int64: spilled_intervals = 1
      mut as int64: allocated_intervals = 5

      println("1. Intervalos de Vida Ordenados:")
      println("   v1: [1, 6]  | v2: [2, 8]  | v3: [3, 5]")
      println("   v4: [4, 12] | v5: [7, 10] | v6: [9, 14]")
      println("   Total de Registradores Fisicos Disponiveis: " + physical_registers + " (R1, R2, R3)")

      println("2. Varredura Linear:")
      println("   - Ponto 1: Ativa v1 -> Alocado em R1")
      println("   - Ponto 2: Ativa v2 -> Alocado em R2")
      println("   - Ponto 3: Ativa v3 -> Alocado em R3")
      println("   - Ponto 4: Ativa v4 -> Registradores cheios! Intervalo com maior termino (v4) sofre SPILL na pilha.")
      println("   - Ponto 5: v3 expira -> R3 liberado")
      println("   - Ponto 7: Ativa v5 -> Alocado em R3")

      println("3. Resumo da Alocacao:")
      println("   Intervalos em registradores: " + allocated_intervals)
      println("   Intervalos com spill em memoria: " + spilled_intervals)
      println("   Linear Scan Register Allocation concluido.")
}
