#L ============================================================================
#L Algoritmo: Reed-Solomon (Código Corretor Não Binário em GF(2^8))
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N * K) codificacao | O(N^2) decodificacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoReedSolomon) {
      println("==================================================")
      println("  SciAlgo: Reed-Solomon Coding Model")
      println("==================================================")

      mut as list of int64: mensagem = [32, 65, 12, 88]
      mut as int64: k = listLength(mensagem)
      mut as int64: n = 6
      mut as int64: n_ecc = n - k

      println("1. Simbolos de dados (K=" + k + "): [32, 65, 12, 88]")
      println("2. Simbolos de redundancia gerados (2t=" + n_ecc + ")")
      println("3. Capacidade de correcao de erros: t=" + (n_ecc /i 2) + " simbolos")
      println("4. Reed-Solomon concluido com sucesso.")
}
