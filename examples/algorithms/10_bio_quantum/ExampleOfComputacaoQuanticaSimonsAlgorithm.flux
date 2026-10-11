#L ============================================================================
#L Algoritmo: Simon's Algorithm (Aceleracao Quantica Exponencial - Periodo XOR)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(n) consultas quanticas (vs O(2^(n/2)) consultas classicas)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaSimonsAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Simon's Quantum Algorithm")
      println("==================================================")

      #L Simon's Problem:
      #L Funcao 2-para-1 f(x) = f(y) se e somente se x ^ y = s (onde s e o periodo oculto).
      #L Qubits de entrada: n = 3
      #L Periodo secreto s = [1, 1, 0] (decimal s = 6)
      mut as int64: n = 3
      mut as int64: secret_s = 6 #L '110' em binario

      println("1. Parametros do Problema de Simon:")
      println("   Dimensoes: n = " + n + " qubits de entrada e n = " + n + " qubits de saida")
      println("   Periodo Secreto Oculto: s = 6 (binario '110')")

      #L Mapeamento da funcao f(x) tal que f(x ^ 6) = f(x):
      #L f(0)=f(6)=0, f(1)=f(7)=1, f(2)=f(4)=2, f(3)=f(5)=3
      #L x in 0..7
      mut as list of int64: f_map = [0, 1, 2, 3, 2, 3, 0, 1]

      println("==================================================")
      println("2. Propriedade do Circuito Quantico de Simon:")
      println("   Cada medicao quantica amostra uniformemente um vetor y tal que (y . s) mod 2 = 0")

      #L Encontra todos os vetores y in {0,1}^3 ortogonais a s='110':
      #L (y0*1 ^ y1*1 ^ y2*0) = 0 => y0 ^ y1 = 0 => y0 = y1.
      #L Os 4 vetores ortogonais possiveis sao:
      #L 000 (0), 001 (1), 110 (6), 111 (7)
      mut as list of int64: orth_vectors = []
      mut as int64: y = 0
      infinite (y < 8) {
            mut as int64: y0 = y /i 4
            mut as int64: y1 = (y /r 4) /i 2
            mut as int64: y2 = y /r 2

            mut as int64: s0 = secret_s /i 4
            mut as int64: s1 = (secret_s /r 4) /i 2
            mut as int64: s2 = secret_s /r 2

            mut as int64: dot = ((y0 * s0) + (y1 * s1) + (y2 * s2)) /r 2
            route {
                  dot == 0 ==> {
                        orth_vectors = listPushBack(orth_vectors, y)
                        println("   Vetor ortogonal valido encontrado: |" + y0 + y1 + y2 + "> (dec " + y + ")")
                  }
                  _ ==> {}
            }
            y = y + 1
      }

      println("==================================================")
      println("3. Resolucao do Sistema Linear Homogeneo em GF(2):")

      #L Selecionamos dois vetores linearmente independentes nao-nulos:
      #L y^(1) = 001 (1) e y^(2) = 110 (6)
      #L Sistema:
      #L Equacao 1: 0*s0 + 0*s1 + 1*s2 = 0 => s2 = 0
      #L Equacao 2: 1*s0 + 1*s1 + 0*s2 = 0 => s0 = s1
      #L Como s != 000, temos s0=1, s1=1, s2=0 => s = 110_2 = 6!

      mut as int64: found_s = 0
      mut as int64: cand = 1
      infinite (cand < 8) {
            mut as int64: c0 = cand /i 4
            mut as int64: c1 = (cand /r 4) /i 2
            mut as int64: c2 = cand /r 2

            #L Testa ortogonalidade com os vetores amostrados 1 ('001') e 7 ('111')
            mut as int64: dot1 = (c2) /r 2
            mut as int64: dot2 = (c0 + c1 + c2) /r 2

            route {
                  dot1 == 0 and dot2 == 0 ==> {
                        found_s = cand
                        println("   Candidato nao-trivial satisfazendo todas as restricoes GF(2): s = " + found_s + " ('" + c0 + c1 + c2 + "')")
                  }
                  _ ==> {}
            }
            cand = cand + 1
      }

      println("==================================================")
      println("4. Conclusao de Simon's Algorithm:")
      println("   Periodo Secreto Identificado: s = " + found_s)
      route {
            found_s == secret_s ==> {
                  println("   Sucesso: Periodo secreto verificado com exatidao!")
            }
            _ ==> {}
      }
      println("   Simon's Algorithm concluido com sucesso!")
      println("==================================================")
}
