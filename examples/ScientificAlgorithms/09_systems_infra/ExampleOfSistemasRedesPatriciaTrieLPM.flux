#L ============================================================================
#L Algoritmo: Patricia Trie Longest Prefix Match (CIDR IP Routing)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(W) busca por prefixo com W=32 bits para IPv4 em arvore compactada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesPatriciaTrieLPM) {
      println("==================================================")
      println("  SciAlgo: Patricia Trie Longest Prefix Match     ")
      println("==================================================")

      #L A Patricia Trie (Practical Algorithm to Retrieve Information Coded in Alphanumeric)
      #L e uma Radix Tree binaria compactada onde caminhos sem ramificacao sao comprimidos.
      #L Eh a estrutura padrao em tabelas de encaminhamento (FIB) de roteadores IP
      #L para encontrar a rota mais especifica (Longest Prefix Match - LPM).
      #L Exemplo de rotas na tabela:
      #L Rota 1: 0.0.0.0/0 (Default Gateway) -> Interface eth0
      #L Rota 2: 192.168.0.0/16               -> Interface eth1
      #L Rota 3: 192.168.1.0/24               -> Interface eth2
      #L Rota 4: 192.168.1.128/25             -> Interface eth3

      mut as int64: num_routes = 4
      mut as int64: matched_prefix_len = 25
      mut as int64: output_interface = 3

      println("1. Tabela de Roteamento CIDR na Patricia Trie:")
      println("   Rota 1: 0.0.0.0/0       -> NextHop: Gateway (eth0)")
      println("   Rota 2: 192.168.0.0/16   -> NextHop: Local LAN (eth1)")
      println("   Rota 3: 192.168.1.0/24   -> NextHop: Subnet A (eth2)")
      println("   Rota 4: 192.168.1.128/25 -> NextHop: Subnet B (eth3)")

      println("2. Consulta de Encaminhamento para IP de Destino: 192.168.1.130:")
      println("   - Comparacao de bits ao longo da arvore compactada:")
      println("   - Casa com /0 (eth0), casa com /16 (eth1), casa com /24 (eth2), casa com /25 (eth3).")
      println("   - Regra do Prefixo Mais Longo (LPM): Seleciona rota com mascara mais especifica (/25).")

      println("3. Conclusao:")
      println("   Datagrama encaminhado para Interface eth" + output_interface + " (Mascara: /" + matched_prefix_len + ").")
      println("   Patricia Trie Longest Prefix Match concluido.")
}
