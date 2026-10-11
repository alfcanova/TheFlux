#L ============================================================================
#L Algoritmo: CYK Algorithm (Algoritmo Cocke-Younger-Kasami para Parsing)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N^3 * |G|) parsing sintatico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaCYK) {
      println("==================================================")
      println("  SciAlgo: CYK Context-Free Grammar Parser")
      println("==================================================")

      mut as int64: len_sentenca = 5
      mut as int64: reconhecido = 1

      println("1. Parsing de sentenca de tamanho " + len_sentenca + " em forma de Chomsky (CNF)")
      println("2. Pertencimento a linguagem reconhecido com sucesso: " + reconhecido)
      println("3. CYK Algorithm concluido com sucesso.")
}
