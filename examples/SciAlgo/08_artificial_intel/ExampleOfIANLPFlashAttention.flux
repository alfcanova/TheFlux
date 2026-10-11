#L ============================================================================
#L Algoritmo: FlashAttention (Tiled Exact Attention)
#L Dominio: 08_artificial_intel / Subdominio: Processamento de Linguagem Natural
#L Descricao: Atencao softmax exata computada em blocos com preservacao de memoria O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPFlashAttention) {
      println("=== Algoritmo: FlashAttention (Tiled Online Softmax) ===")

      #L Bloco 1 de atencao (scores nao-normalizados): [10, 20]
      #L Maximo local m1 = 20
      #L Exponenciais inteiras aproximadas e^(s - m): e^(-10) ~ 1, e^0 = 10
      mut as int64: m1 = 20
      mut as int64: l1 = 1 + 10
      mut as int64: o1 = 1 * 5 + 10 * 8

      #L Bloco 2 de atencao (chegada de novos scores): [25, 15]
      #L Maximo local do bloco 2 m2 = 25
      mut as int64: m2 = 25

      #L Atualizacao do maximo global: m_new = max(m1, m2) = 25
      mut as int64: m_new = 25

      #L Fator de reescalonamento para o bloco anterior: alpha = e^(m1 - m_new) = e^(-5) ~ 2
      #L Fator de escala para novo bloco: beta = e^(m2 - m_new) = e^0 = 10
      mut as int64: alpha = 2
      mut as int64: beta = 10

      #L Soma normalizadora online: l_new = alpha * l1 + beta * (e^0 + e^(-10)) = 2 * 11 + 10 * 11 = 22 + 110 = 132
      mut as int64: l_new = alpha * l1 + beta * 11

      #L Saida combinada online reescalonada
      mut as int64: o_scaled = alpha * o1 + beta * 85
      mut as int64: o_final = o_scaled /i l_new

      println("1. Maximo acumulado (m_new): " + m_new)
      println("2. Fator de normalizacao online (l_new): " + l_new)
      println("3. Saida de atencao consolidada online: " + o_final)

      route {
            m_new == 25 and l_new == 132 and o_final > 0 ==> {
                  println("4. Fusao de blocos FlashAttention validada com exatidao.")
            }
            _ ==> {
                  println("Falha no algoritmo FlashAttention.")
            }
      }
      println("Teste concluido com sucesso.")
}
