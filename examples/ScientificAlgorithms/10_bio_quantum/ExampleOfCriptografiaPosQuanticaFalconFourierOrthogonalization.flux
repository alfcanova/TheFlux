#L ============================================================================
#L Algoritmo: Falcon Fast Fourier Orthogonalization (FN-DSA PQC)
#L Dominio: 10_bio_quantum / Categoria: Criptografia Pos-Quantica (PQC)
#L Descricao: Ortogonalizacao de Gram-Schmidt no dominio de Fourier para amostragem gaussiana
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaFalconFourierOrthogonalization) {
      println("=== Algoritmo: Falcon Fast Fourier Orthogonalization ===")

      #L Base de reticulado no anel Q[X] / (X^n + 1):
      #L Vetor b1 = [f, g]
      #L Vetor b2 = [F, G]
      #L Polinomios pequenos de chave privada:
      #L f = 3, g = 2
      #L F = 1, G = 1
      #L Norma quadrada do primeiro vetor b1: ||b1||^2 = f^2 + g^2 = 9 + 4 = 13
      mut as int64: f = 3
      mut as int64: g = 2
      mut as int64: big_f = 1
      mut as int64: big_g = 1

      mut as int64: norm_b1_sq = f * f + g * g
      println("Norma ao quadrado do vetor de reticulado b1: " + norm_b1_sq)

      #L Produto interno <b2, b1> = F*f + G*g = 1*3 + 1*2 = 5
      mut as int64: inner_prod = big_f * f + big_g * g
      println("Produto interno <b2, b1>: " + inner_prod)

      #L Coeficiente de projecao de Gram-Schmidt mu = <b2, b1> / ||b1||^2
      #L mu = 5 / 13 ~ 0.3846 (escala x1000: 5000 / 13 = 384)
      mut as int64: mu_x1000 = (inner_prod * 1000) /i norm_b1_sq
      mut as int64: mu_int = mu_x1000 /i 1000
      mut as int64: mu_dec = mu_x1000 /r 1000
      println("Coeficiente de Gram-Schmidt mu: " + mu_int + "." + mu_dec)

      #L Vetor ortogonalizado b2_tilde = b2 - mu * b1:
      #L Norma quadrada de Gram-Schmidt ||b2_tilde||^2 = ||b2||^2 - mu^2 * ||b1||^2
      #L ||b2||^2 = F^2 + G^2 = 1 + 1 = 2 (em escala x1000: 2000)
      #L Reducao = (inner_prod^2 * 1000) / ||b1||^2 = (25 * 1000) / 13 = 25000 / 13 = 1923
      #L ||b2_tilde||^2 x1000 = 2000 - 1923 = 77 (0.077)
      mut as int64: norm_b2_sq_x1000 = (big_f * big_f + big_g * big_g) * 1000
      mut as int64: reduction = (inner_prod * inner_prod * 1000) /i norm_b1_sq
      mut as int64: norm_b2_tilde_sq = norm_b2_sq_x1000 - reduction

      println("Norma ortogonalizada de Gram-Schmidt ||b2_tilde||^2 (x1000): " + norm_b2_tilde_sq)

      route {
            norm_b2_tilde_sq > 0 ==> {
                  println("Ortogonalizacao estavel: Base apta para amostragem de Falcon Fast Fourier Trapdoor!")
            }
            _ ==> {
                  println("Instabilidade numerica na base")
            }
      }

      println("Falcon Fast Fourier Orthogonalization concluido com sucesso.")
}
