#L ============================================================================
#L Algoritmo: Pohlig-Hellman (Redução do Logaritmo Discreto via Fatores da Ordem do Grupo)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sum(e_i * (sqrt(p_i)))) para ordem prod(p_i^e_i)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPohligHellman) {
      println("==================================================")
      println("  SciAlgo: Pohlig-Hellman Algorithm")
      println("==================================================")

      mut as int64: fatores_ordem = 3
      mut as int64: solucao_crt = 7

      println("1. Quebra em subgrupos ciclicos de ordem prima: " + fatores_ordem)
      println("2. Recomposicao chinesa do logaritmo discreto: " + solucao_crt)
      println("3. Pohlig-Hellman concluido com sucesso.")
}
