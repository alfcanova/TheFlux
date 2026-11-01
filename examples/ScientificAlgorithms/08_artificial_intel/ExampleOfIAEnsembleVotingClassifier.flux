#L ============================================================================
#L Algoritmo: Voting Classifier (Soft e Hard Voting)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleVotingClassifier) {
      println("=== Algoritmo: Voting Classifier ===")
      mut as int64: probM1 = 90
      mut as int64: probM2 = 75
      mut as int64: probM3 = 60
      mut as int64: softVoteProb = (probM1 + probM2 + probM3) /i 3
      mut as int64: hardVote = 0
      route {
            softVoteProb >= 50 ==> { hardVote = 1 }
            _ ==> {}
      }
      println("1. Media de probabilidades (Soft Voting): " + softVoteProb)
      println("2. Classe de decisao (Hard Voting): " + hardVote)
      println("Teste concluido com sucesso.")
}
