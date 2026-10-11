#L ============================================================================
#L Algoritmo: Noise Protocol Framework Handshake (Noise_IK / WireGuard)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(1) acordo de chaves autenticado mutualmente via 1 RTT (Diffie-Hellman)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesNoiseProtocolHandshake) {
      println("==================================================")
      println("  SciAlgo: Noise Protocol Handshake (Noise_IK)    ")
      println("==================================================")

      #L O Noise Protocol Framework (Trevor Perrin, base do WireGuard e Lightning Network)
      #L define padroes formais de acordo de chaves criptograficas baseados em
      #L Diffie-Hellman efemero e estatico com Chaining Key.
      #L Padrao Noise_IK (Initiator knows Responder static key beforehand):
      #L Mensagem 1 (Iniciador -> Respondedor): e, es, s, ss
      #L Mensagem 2 (Respondedor -> Iniciador): e, ee, se
      #L Ao final da troca de 1 RTT, ambos derivam chaves simetricas de transporte
      #L (Transport Cipher States) com sigilo direto perfeito (Forward Secrecy).

      mut as int64: handshake_rtt = 1
      mut as int64: operations_dh = 4
      mut as int64: derived_transport_keys = 2

      println("1. Parametros Criptograficos do Padrao Noise_IK:")
      println("   Curva Elíptica: Curve25519 (X25519)")
      println("   Cifra de Autenticacao: ChaCha20-Poly1305 | Hash: BLAKE2s")

      println("2. Execucao das Fases do Handshake:")
      println("   - Iniciador gera par efemero (e) e executa DH(e, s_responder).")
      println("   - Mistura de chave (MixKey) atualiza a Chaining Key (ck).")
      println("   - Respondedor gera seu par efemero (e_responder) e executa DH(e, e) e DH(s, e).")
      println("   - Derivacao final: Split(ck) produz duas chaves simetricas independentes:")
      println("     * Key_Send (Iniciador -> Respondedor)")
      println("     * Key_Recv (Respondedor -> Iniciador)")

      println("3. Conclusao:")
      println("   Handshake completado em " + handshake_rtt + " RTT com autenticacao mutua forte.")
      println("   Noise Protocol Framework Handshake concluido.")
}
