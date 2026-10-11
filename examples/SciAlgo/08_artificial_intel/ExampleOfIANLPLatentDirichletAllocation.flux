#L ============================================================================
#L Algoritmo: Latent Dirichlet Allocation (LDA Topic Modeling via Gibbs Sampling)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPLatentDirichletAllocation) {
      println("=== Algoritmo: LDA Gibbs Sampling ===")
      mut as int64: docTopicCount = 5
      mut as int64: alphaPrior = 1
      mut as int64: topicWordCount = 8
      mut as int64: betaPrior = 1
      mut as int64: condProbTopic = (docTopicCount + alphaPrior) * (topicWordCount + betaPrior)
      println("1. Numerador de probabilidade condicional de topico: " + condProbTopic)
      println("Teste concluido com sucesso.")
}
