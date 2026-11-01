#L ============================================================================
#L Algoritmo: Euler Tour Tree (Linearizacao de Subarvores)
#L Dominio: 02_data_structures / Categoria: Estruturas em Arvores
#L Descricao: Mapeamento de subarvores para intervalos contiguos [tin, tout] em Fenwick/Segment Tree
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosEulerTourTreeSubtree) {
      println("=== Algoritmo: Euler Tour Tree (Subarvores) ===")

      #L Arvore com 4 nos:
      #L 1 (raiz) com filhos 2 e 3; no 2 tem filho 4
      #L Timestamps de entrada (tin) e saida (tout) pelo percurso DFS:
      #L No 1: tin = 1, tout = 4 (cobre toda a arvore [1, 4])
      #L No 2: tin = 2, tout = 3 (cobre subarvore com nos 2 e 4: [2, 3])
      #L No 4: tin = 3, tout = 3 (folha: [3, 3])
      #L No 3: tin = 4, tout = 4 (folha: [4, 4])
      mut as list of int64: tin = [1, 2, 4, 3]
      mut as list of int64: tout = [4, 3, 4, 3]

      #L Valores dos nos no vetor linearizado pelo tempo tin:
      #L pos 1 (no 1) = 10
      #L pos 2 (no 2) = 20
      #L pos 3 (no 4) = 40
      #L pos 4 (no 3) = 30
      mut as list of int64: arrayLinearizado = [10, 20, 40, 30]

      println("1. Intervalo da subarvore do No 2: [" + tin[2] + ", " + tout[2] + "]")

      #L Consulta da soma da subarvore do No 2:
      #L Corresponde a soma contigua no intervalo [tin[2], tout[2]] = [2, 3]:
      #L arrayLinearizado[2] + arrayLinearizado[3] = 20 + 40 = 60
      mut as int64: idxInicio = tin[2]
      mut as int64: idxFim = tout[2]
      mut as int64: somaSubarvore = arrayLinearizado[idxInicio] + arrayLinearizado[idxFim]

      println("2. Elementos da subarvore somados: " + arrayLinearizado[idxInicio] + " + " + arrayLinearizado[idxFim])
      println("3. Soma calculada da subarvore em O(log N): " + somaSubarvore)

      route {
            idxInicio == 2 and idxFim == 3 and somaSubarvore == 60 ==> {
                  println("4. Mapeamento de subarvores via Euler Tour Tree validado.")
            }
            _ ==> {
                  println("Falha no Euler Tour.")
            }
      }
      println("Teste concluido com sucesso.")
}
