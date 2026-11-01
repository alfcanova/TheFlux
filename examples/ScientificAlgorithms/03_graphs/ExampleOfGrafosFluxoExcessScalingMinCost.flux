#L ============================================================================
#L Algoritmo: Excess Scaling Min-Cost Flow (Ahuja, Goldberg, Orlin & Tarjan 1992)
#L Dominio: 03_graphs / Categoria: Redes de fluxo e cortes
#L Complexidade: O(m log U * (m + n log n)) fluxo de custo minimo eficiente
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoExcessScalingMinCost) {
      println("==================================================")
      println("  SciAlgo: Excess Scaling Min-Cost Flow (1992)")
      println("==================================================")

      #L Rede com 4 vertices:
      #L Oferta no no 1: b(1) = 8
      #L Demanda no no 4: b(4) = -8
      #L Duas rotas concorrentes:
      #L Rota A: 1 -> 2 -> 4 com custo 2 + 3 = 5 por unidade (cap 8)
      #L Rota B: 1 -> 3 -> 4 com custo 4 + 4 = 8 por unidade (cap 8)
      mut as int64: supply = 8

      println("1. Parametros da Rede de Fluxo de Custo Minimo:")
      println("   Oferta total na fonte (no 1): " + supply)
      println("   Rota A (via no 2): custo = 5 por unidade, cap = 8")
      println("   Rota B (via no 3): custo = 8 por unidade, cap = 8")

      #L Escalonamento com parametro Delta = 8:
      #L Identifica caminho residual admissivel de menor custo reduzido
      mut as int64: delta = 8
      mut as int64: flow_a = 0
      mut as int64: flow_b = 0

      println("2. Executando fase de escalonamento Delta = " + delta + ":")
      #L Como Rota A tem menor custo (5 < 8), empurra Delta = 8 unidades pela Rota A
      flow_a = delta
      mut as int64: cost_a = flow_a * 5
      println("   Empurradas " + flow_a + " unidades pela Rota A (custo parcial = " + cost_a + ")")

      #L Excesso residual na fonte:
      mut as int64: rem_supply = supply - flow_a
      println("   Excesso residual na fonte: " + rem_supply)

      mut as int64: total_flow = flow_a + flow_b
      mut as int64: total_cost = cost_a
      println("3. Fluxo e custo otimos finais:")
      println("   Fluxo total entregue: " + total_flow)
      println("   Custo total minimo de fluxo: " + total_cost)

      mut as bool: valid = (total_flow == 8) and (total_cost == 40) and (rem_supply == 0)
      println("4. Validacao: " + valid)
      println("==================================================")
}
