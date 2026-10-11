#L ============================================================================
#L Algoritmo: Burnside's Lemma (Contagem de Órbitas sob Ação de Grupos)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(|G|) sobre o grupo G
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaBurnsidesLemma) {
      println("==================================================")
      println("  SciAlgo: Burnside's Lemma Orbit Counting")
      println("==================================================")

      #L Coloração de 4 vértices com 2 cores sob rotações (C4: rotacoes 0, 90, 180, 270)
      mut as int64: fix_0 = 16
      mut as int64: fix_90 = 2
      mut as int64: fix_180 = 4
      mut as int64: fix_270 = 2
      mut as int64: tamanho_grupo = 4

      mut as int64: orbitas = (fix_0 + fix_90 + fix_180 + fix_270) /i tamanho_grupo

      println("1. Ordem do grupo ciclico C4: " + tamanho_grupo)
      println("2. Orbitas distintas de coloracao (colares): " + orbitas)
      println("3. Burnside's Lemma concluido com sucesso.")
}
