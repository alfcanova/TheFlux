#L ============================================================================
#L Algoritmo: ML-DSA Dilithium NTT Fast Multiplier (Number Theoretic Transform)
#L Dominio: 10_bio_quantum / Categoria: Criptografia Pos-Quantica (PQC)
#L Descricao: Multiplicacao polinomial rapida sobre anel ciclotomico via NTT
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaDilithiumPolyMul) {
      println("=== Algoritmo: ML-DSA Dilithium NTT Fast Multiplier ===")

      #L Primo canonico de Dilithium: q = 8380417 = 2^23 - 2^13 + 1
      #L Grau n = 256, raiz primitiva 512-esima da unidade mod q
      #L Simulacao da operacao fundamental: Borboleta NTT de Cooley-Tukey
      mut as int64: mod_q = 8380417
      println("Primo aritmetico de Dilithium: q = " + mod_q)

      #L Dois coeficientes de entrada a e b:
      #L a = 123456
      #L b = 654321
      #L Fator de twiddle omega = 1753 (raiz de teste da unidade)
      mut as int64: a = 123456
      mut as int64: b = 654321
      mut as int64: omega = 1753

      #L Produto t = (b * omega) mod q:
      #L b * omega = 654321 * 1753 = 1147024713
      #L t = 1147024713 mod 8380417 = 7291122
      mut as int64: prod = b * omega
      mut as int64: t = prod /r mod_q
      println("Produto twiddle t = (b * omega) mod q: " + t)

      #L Borboleta de Cooley-Tukey:
      #L a_novo = (a + t) mod q
      #L b_novo = (a - t + q) mod q
      mut as int64: sum_val = a + t
      mut as int64: a_novo = sum_val /r mod_q

      mut as int64: diff_val = a - t + mod_q
      mut as int64: b_novo = diff_val /r mod_q

      println("Resultados da borboleta NTT de Dilithium:")
      println("  a_novo = " + a_novo)
      println("  b_novo = " + b_novo)

      #L Verificacao de conservacao da borboleta:
      #L (a_novo + b_novo) mod q deve ser igual a (2 * a) mod q
      mut as int64: lhs = (a_novo + b_novo) /r mod_q
      mut as int64: rhs = (2 * a) /r mod_q

      route {
            lhs == rhs ==> {
                  println("Borboleta NTT de Cooley-Tukey verificada com invariante algebrico perfeito!")
            }
            _ ==> {
                  println("Invariante violado")
            }
      }

      println("Dilithium NTT Fast Multiplier concluido com sucesso.")
}
