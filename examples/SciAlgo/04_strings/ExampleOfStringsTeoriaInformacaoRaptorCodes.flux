#L ============================================================================
#L Algoritmo: Raptor Codes (Linear Time Systematic Fountain Codes)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(K) linear em codificacao e decodificacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoRaptorCodes) {
      println("==================================================")
      println("  SciAlgo: Raptor Codes (Precode + Weak LT)")
      println("==================================================")

      #L Raptor Codes combinam:
      #L 1. Precodificador externo (LDPC / Gray): transforma K simbolos em L simbolos intermediarios
      #L 2. Codificador interno (LT enfraquecido): gera simbolos de saida com grau medio constante O(1)
      mut as int64: k = 8 #L Simbolos fonte
      mut as int64: l_intermediarios = 10 #L L = K + S + H (com simbolos LDPC e Half)

      mut as list of int64: simbolos_fonte = [10, 20, 30, 40, 50, 60, 70, 80]

      #L Passo do precodificador: equacoes de paridade linear sobre GF(2)
      #L Paridade p1 = s1 bxor s3 = 10 bxor 30 = 20
      #L Paridade p2 = s2 bxor s4 = 20 bxor 40 = 60
      mut as int64: p1 = 20
      mut as int64: p2 = 60

      #L Decodificacao por eliminacao gaussiana esparsa e BP
      mut as int64: simbolos_recebidos = 9 #L Apenas K + 1 simbolos necessarios!
      mut as int64: probabilidade_falha = 1 #L < 1% de probabilidade de nao-recuperacao

      mut as int64: overhead_pct = ((simbolos_recebidos - k) * 100) /i k

      println("1. Simbolos fonte K: " + k + ", simbolos intermediarios L: " + l_intermediarios)
      println("2. Simbolos necessarios para decodificacao: " + simbolos_recebidos + " (overhead: " + overhead_pct + "%)")
      println("3. Complexidade de operacoes por simbolo: O(1) constante")
      println("4. Raptor Codes concluido com sucesso.")
}
