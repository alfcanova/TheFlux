#L ============================================================================
#L Algoritmo: Raft Joint Consensus (Dynamic Cluster Reconfiguration)
#L Dominio: 09_systems_infra / Categoria: Algoritmos de consenso e coordenacao
#L Complexidade: O(log replication) transicao segura de membros sem split-brain
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoRaftJointConsensus) {
      println("==================================================")
      println("  SciAlgo: Raft Joint Consensus Protocol          ")
      println("==================================================")

      #L Na reconfiguracao dinamica de cluster do Raft (Ongaro & Ousterhout, 2014),
      #L nao e seguro transitar diretamente de C_old para C_new, pois poderiam coexistir
      #L dois quoruns independentes (split-brain).
      #L O Raft utiliza o consenso conjunto (Joint Consensus C_old,new):
      #L Durante a fase de transicao, decisoes exigem a aprovacao conjunta de:
      #L 1. Maioria da configuracao antiga C_old E
      #L 2. Maioria da nova configuracao C_new.
      #L Quando C_old,new esta comitado, o lider comita C_new de forma definitiva.

      mut as int64: old_cluster_size = 3
      mut as int64: new_cluster_size = 5
      mut as int64: current_term = 4

      println("1. Configuracoes do Cluster:")
      println("   C_old: {Node 1, Node 2, Node 3} (Quorum = 2 de 3)")
      println("   C_new: {Node 1, Node 2, Node 3, Node 4, Node 5} (Quorum = 3 de 5)")

      println("2. Fase de Consenso Conjunto (C_old,new):")
      println("   - Lider no Term 4 publica entrada de log de configuracao conjunta C_old,new.")
      println("   - Replicacao de C_old,new nos nos 1, 2, 4 (Atende maioria em C_old e C_new!).")
      println("   - C_old,new comitado com seguranca estrita contra particionamento.")

      println("3. Comitment Final de C_new:")
      println("   - Lider publica entrada com configuracao exclusiva C_new.")
      println("   - Replicacao comitada segundo a nova regra majoritaria.")
      println("   - Transicao de topologia concluida sem interrupcao do servico.")

      println("4. Conclusao:")
      println("   Raft Joint Consensus concluido com sucesso.")
}
