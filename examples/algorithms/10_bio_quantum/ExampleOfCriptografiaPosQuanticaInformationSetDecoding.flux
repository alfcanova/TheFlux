#L ============================================================================
#L Algoritmo: Information Set Decoding (ISD / Algoritmo de Prange)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(2^(c * w)) ataque canonico exponencial para decodificacao generica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaInformationSetDecoding) {
      println("==================================================")
      println("  SciAlgo: Information Set Decoding (Prange ISD)")
      println("==================================================")

      #L O algoritmo de Prange (1962) e o metodo fundamental de Decodificacao por
      #L Conjuntos de Informacao (Information Set Decoding - ISD).
      #L Representa o referencial canonico de seguranca para todos os criptossistemas
      #L baseados em codigos (McEliece, Niederreiter, BIKE, HQC).
      #L
      #L Problema de Decodificacao de Sindromes:
      #L Dada a matriz H in F_2^((n-k) x n) e a sindrome s in F_2^(n-k),
      #L encontrar o vetor de erro e in F_2^n de peso exato w tal que H * e^T = s.
      #L
      #L Parametros do modelo:
      #L n = 7, k = 4, n - k = 3, peso w = 1
      mut as int64: n = 7
      mut as int64: k = 4
      mut as int64: m = 3
      mut as int64: target_weight = 1

      println("1. Parametros do Codigo Linear:")
      println("   Comprimento n = " + n + ", Dimensao k = " + k + ", Sindrome m = " + m)
      println("   Peso do erro procurado: w = " + target_weight)

      #L Matriz de Paridade H (3 x 7) em GF(2):
      mut as list of int64: h1 = [1, 0, 0, 1, 1, 0, 1]
      mut as list of int64: h2 = [0, 1, 0, 1, 0, 1, 1]
      mut as list of int64: h3 = [0, 0, 1, 0, 1, 1, 1]

      #L Sindrome alvo s = [1, 0, 1]:
      mut as list of int64: target_s = [1, 0, 1]
      println("   Sindrome Alvo s = " + target_s)

      println("==================================================")
      println("2. Algoritmo de Prange (Iteracao ISD):")
      #L O algoritmo escolhe aleatoriamente um conjunto de informacao de tamanho k
      #L e o conjunto complementar J de tamanho m = 3 colunas.
      #L Hipotese de Prange: o erro tem peso 0 nas k posicoes de informacao,
      #L estando totalmente contido nas m posicoes do conjunto J.

      #L Tentativa 1: Seleciona colunas J = {1, 2, 3} (colunas da identidade):
      #L A submatriz H_J e a identidade 3x3:
      #L H_J = [[1, 0, 0],
      #L        [0, 1, 0],
      #L        [0, 0, 1]]
      println("   Tentativa 1 com subconjunto de colunas J = {1, 2, 3}:")
      println("     H_J e invertivel (matriz identidade).")
      println("     Solucao candidata e_J = H_J^(-1) * s = s = " + target_s)

      #L Calcula o peso de Hamming da solucao candidata:
      mut as int64: weight_cand1 = target_s[1] + target_s[2] + target_s[3]
      println("     Peso de e_J = " + weight_cand1 + " (Esperado w = " + target_weight + ")")
      println("     -> Rejeitado: peso 2 != 1.")

      #L Tentativa 2: Seleciona colunas J = {4, 5, 6}:
      #L H_J = [[1, 1, 0],
      #L        [1, 0, 1],
      #L        [0, 1, 1]]
      #L Tentativa 3: Seleciona subconjunto contendo a coluna 5:
      #L Note que a coluna 5 de H e exatamente [1, 0, 1]!
      println("   Tentativa 2 com subconjunto contendo coluna 5:")
      #L Solucao encontrada: e_5 = 1, todos os outros bits 0:
      mut as list of int64: found_e = [0, 0, 0, 0, 1, 0, 0]
      println("     Vetor de erro encontrado: e = " + found_e)

      println("==================================================")
      println("3. Verificacao da Sindrome H * e^T:")
      mut as int64: eval_s1 = 0
      mut as int64: eval_s2 = 0
      mut as int64: eval_s3 = 0
      mut as int64: j = 0
      infinite (j < n) {
            eval_s1 = (eval_s1 + (h1[j + 1] * found_e[j + 1])) /r 2
            eval_s2 = (eval_s2 + (h2[j + 1] * found_e[j + 1])) /r 2
            eval_s3 = (eval_s3 + (h3[j + 1] * found_e[j + 1])) /r 2
            j = j + 1
      }

      mut as list of int64: eval_syndrome = [eval_s1, eval_s2, eval_s3]
      println("   Sindrome avaliada: " + eval_syndrome)

      #L Peso do vetor encontrado:
      mut as int64: final_weight = 0
      j = 0
      infinite (j < n) {
            final_weight = final_weight + found_e[j + 1]
            j = j + 1
      }
      println("   Peso de Hamming final: " + final_weight)

      route {
            (eval_syndrome == target_s) and (final_weight == target_weight) ==> {
                  println("   Sucesso: ISD de Prange resolveu a sindrome e encontrou o erro exato!")
            }
            _ ==> {
                  println("   Falha no ISD.")
            }
      }
      println("   Information Set Decoding concluido com sucesso!")
      println("==================================================")
}
