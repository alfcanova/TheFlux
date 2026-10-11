#L ============================================================================
#L Algoritmo: ML-KEM Kyber Coefficient Compress/Decompress
#L Dominio: 10_bio_quantum / Categoria: Criptografia Pos-Quantica (PQC)
#L Descricao: Compressao e descompressao de coeficientes modulares para reducao de cifra
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaKyberCompressDecompress) {
      println("=== Algoritmo: ML-KEM Kyber Compress/Decompress ===")

      #L Parametros NIST FIPS 203 (ML-KEM):
      #L Primo modular q = 3329
      #L Dimensao de compressao de texto cifrado d = 4 bits (2^4 = 16)
      mut as int64: mod_q = 3329
      mut as int64: d_bits = 4
      mut as int64: two_pow_d = 16

      println("Modulo primo de Kyber: q = " + mod_q + ", d = " + d_bits + " bits (escala 2^d = " + two_pow_d + ")")

      #L Coeficiente de teste x mod q:
      #L x = 1200
      mut as int64: x = 1200
      println("Coeficiente polinomial original x: " + x)

      #L Compress_d(x) = round((2^d / q) * x) mod 2^d
      #L Em aritmetica inteira: ((x * 2^d + q / 2) / q) mod 2^d
      #L x * 16 = 1200 * 16 = 19200
      #L q / 2 = 3329 / 2 = 1664
      #L (19200 + 1664) / 3329 = 20864 / 3329 = 6
      mut as int64: num_compress = x * two_pow_d + (mod_q /i 2)
      mut as int64: c = (num_compress /i mod_q) /r two_pow_d
      println("Valor comprimido (4 bits) c = Compress_4(x): " + c)

      #L Decompress_d(c) = round((q / 2^d) * c)
      #L Em aritmetica inteira: (c * q + 2^(d-1)) / 2^d
      #L c * 3329 = 6 * 3329 = 19974
      #L 2^(d-1) = 8
      #L (19974 + 8) / 16 = 19982 / 16 = 1248
      mut as int64: num_decompress = c * mod_q + 8
      mut as int64: x_reconst = num_decompress /i two_pow_d
      println("Valor descomprimido x' = Decompress_4(c): " + x_reconst)

      #L Erro maximo de quantizacao: |x - x'|
      mut as int64: err = x - x_reconst
      route {
            err < 0 ==> { err = 0 - err }
      }
      println("Erro absoluto de quantizacao residual: " + err)

      #L Limite teorico do erro para d=4: round(q / 2^(d+1)) = round(3329 / 32) = 104
      mut as int64: max_allowed_err = 105
      route {
            err <= max_allowed_err ==> {
                  println("Erro dentro do limite matematico teorico garantido pelo NIST FIPS 203!")
            }
            _ ==> {
                  println("Erro excedeu limite teorico")
            }
      }

      println("Kyber Compress/Decompress concluido com sucesso.")
}
