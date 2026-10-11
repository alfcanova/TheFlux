#L ============================================================================
#L Algoritmo: Knowledge Distillation (Destilacao Professor-Aluno)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialKnowledgeDistillation) {
      println("=== Algoritmo: Knowledge Distillation ===")
      mut as int64: teacherLogit = 80
      mut as int64: studentLogit = 65
      mut as int64: temp = 4
      mut as int64: softLoss = (teacherLogit - studentLogit) * (teacherLogit - studentLogit) /i (temp * temp)
      println("1. Temperatura de destilacao T: " + temp)
      println("2. Perda de destilacao suave: " + softLoss)
      println("Teste concluido com sucesso.")
}
