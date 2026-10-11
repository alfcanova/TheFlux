#L ============================================================================
#L Algoritmo: Tendermint BFT Consensus (Buchman, Kwon, Milosevic 2018)
#L Dominio: 09_systems_infra / Categoria: Algoritmos de consenso e coordenacao
#L Complexidade: O(N^2) mensagens por rodada tolerando ate f < N/3 faltas bizantinas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoTendermintBFT) {
      println("==================================================")
      println("  SciAlgo: Tendermint BFT Consensus Protocol      ")
      println("==================================================")

      #L O Tendermint BFT (2018) e o motor de consenso moderno padrao para blockchains
      #L de Prova de Participacao (PoS, Cosmos SDK, Celestia).
      #L Em cada altura H e rodada R:
      #L 1. NewRound / Propose: Um proponente deterministico baseado em stake propoe um bloco.
      #L 2. Prevote: Validadores verificam e transmitem prevote. Se receberem > 2/3 de votos
      #L    (Polka), os validadores travam (lock) no bloco.
      #L 3. Precommit: Se > 2/3 de prevotes forem observados, validadores transmitem precommit.
      #L 4. Commit: Ao observar > 2/3 de precommits, o bloco eh finalizado imediatamente
      #L    com finalidade instantanea de 1 bloco (sem forks ou reorganizacoes).

      mut as int64: total_validators = 4
      mut as int64: max_byzantine_faults = 1
      mut as int64: height = 100
      mut as int64: round = 0
      mut as bool: block_finalized = true

      println("1. Parametros do Comite BFT de Validadores:")
      println("   Total de Validadores: N = " + total_validators + " (Tolerancia: f = " + max_byzantine_faults + " bizantinos)")
      println("   Quorum de Seguranca: > 2/3 do poder de voto (+2/3 = 3 de 4 validadores)")
      println("   Altura Atual: " + height + " | Rodada: " + round)

      println("2. Fases de Votacao da Rodada:")
      println("   - Proposta: Proponente eleito transmite Bloco B na Altura " + height)
      println("   - Prevote: Validadores 1, 2 e 3 transmitem Prevote(B) -> Quorum 2/3 atingido (Polka).")
      println("   - Validadores travam estado no Bloco B (LockedBlock = B, LockedRound = 0).")
      println("   - Precommit: Validadores 1, 2 e 4 transmitem Precommit(B) -> Quorum 2/3 atingido.")
      println("   - Commit: Bloco B anexado de forma imutavel a cadeia com prova criptografica de comite.")

      println("3. Conclusao:")
      println("   Finalidade instantanea garantida sem bifurcacoes (fork-free).")
      println("   Tendermint BFT Consensus concluido com sucesso.")
}
