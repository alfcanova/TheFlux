#L ============================================================================
#L Algoritmo: SNOVA Multivariate Signature Scheme (NIST PQC Additional)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(v * o^2) avaliacao do mapa central sobre algebra nao-comutativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaSNOVASignature) {
      println("==================================================")
      println("  SciAlgo: SNOVA Multivariate Signature Scheme")
      println("==================================================")

      #L SNOVA opera sobre o anel de matrizes M_r(GF(q)) onde r e a dimensao matricial:
      #L Corpo finito primo q = 31, dimensao de matrizes r = 2 (matrizes 2x2)
      #L Variaveis Vinegar: v = 4, Variaveis Oil: o = 2, Total de variaveis: n = 6
      mut as int64: q_corpo = 31
      mut as int64: r_matriz = 2
      mut as int64: v_vinegar = 4
      mut as int64: o_oil = 2
      mut as int64: n_variaveis = v_vinegar + o_oil

      #L O mapa central P avalia termos de segunda ordem F(X, Y) = sum A_i X B_i Y C_i
      #L Matrizes 2x2 com coeficientes no corpo GF(31):
      #L Traco e determinante de bloco de assinatura ilustrativo:
      mut as list of int64: mat_sig = [12, 5, 7, 19] #L Matriz [[12, 5], [7, 19]]
      mut as int64: traco = (mat_sig[1] + mat_sig[4]) /r q_corpo #L (12 + 19) mod 31 = 31 mod 31 = 0
      mut as int64: det = ((mat_sig[1] * mat_sig[4]) - (mat_sig[2] * mat_sig[3])) /r q_corpo #L (228 - 35) = 193 mod 31 = 7

      #L Tamanho da assinatura SNOVA: extraordinariamente compacto em comparacao com UOV tradicional
      mut as int64: bytes_assinatura = (n_variaveis * (r_matriz * r_matriz)) #L 6 * 4 = 24 bytes

      println("1. Corpo base GF(" + q_corpo + ") com algebra de matrizes " + r_matriz + "x" + r_matriz)
      println("2. Variaveis Vinegar (v=" + v_vinegar + ") e Oil (o=" + o_oil + ")")
      println("3. Invariantes da assinatura projetiva: traco=" + traco + ", determinante=" + det)
      println("4. Tamanho da assinatura SNOVA ultracompacta: " + bytes_assinatura + " bytes")
      println("5. SNOVA Multivariate Signature concluido com sucesso.")
}
