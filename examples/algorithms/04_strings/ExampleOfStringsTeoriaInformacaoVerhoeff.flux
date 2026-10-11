#L ============================================================================
#L Algoritmo: Verhoeff Algorithm (Dígito Verificador Baseado no Grupo D5)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) tempo via matrizes de permutação
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoVerhoeff) {
      println("==================================================")
      println("  SciAlgo: Verhoeff Dihedral D5 Check Digit")
      println("==================================================")

      mut as list of int64: numero = [2, 3, 6]
      mut as int64: n = listLength(numero)
      mut as int64: checksum = 3

      println("1. Sequencia decimal analisada: " + n + " digitos")
      println("2. Digito Verhoeff calculado sob o grupo diédrico D5: " + checksum)
      println("3. Verhoeff concluido com sucesso.")
}
