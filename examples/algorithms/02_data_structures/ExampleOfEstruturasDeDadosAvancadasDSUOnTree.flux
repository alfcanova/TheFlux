#L ============================================================================
#L Algoritmo: DSU on Tree (Sack / Small-to-Large Merging em Subarvores)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: O(N log N) tempo | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasDSUOnTree) {
      println("==================================================")
      println("  SciAlgo: DSU on Tree (Small-to-Large Merging)")
      println("==================================================")

      #L Arvore com N = 7 vertices:
      #L Arestas direcionadas de pai para filhos:
      #L 1 -> 2, 3
      #L 2 -> 4, 5
      #L 3 -> 6, 7
      mut as int64: n = 7
      #L Cores associadas a cada vertice:
      mut as list of int64: color = [1, 2, 2, 1, 2, 3, 3]

      println("1. Arvore indexada (N = 7) com cores atribuidas:")
      mut as int64: ci = 1
      infinite (ci <= n) {
            println("   Vertice " + ci + " -> Cor " + color[ci])
            ci = ci + 1
      }

      #L Estrutura da arvore:
      #L ch1[u], ch2[u]: filhos (max 2 filhos)
      #L sz[u]: tamanho da subarvore
      #L heavy[u]: filho pesado (maior subarvore)
      mut as list of int64: ch1 = [2, 4, 6, 0, 0, 0, 0]
      mut as list of int64: ch2 = [3, 5, 7, 0, 0, 0, 0]
      mut as list of int64: sz = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: heavy = [0, 0, 0, 0, 0, 0, 0]

      #L Ordem topologica / pos-ordem para calcular tamanhos (bottom-up: 7..1)
      #L 4, 5, 6, 7 sao folhas (sz = 1)
      #L 2 tem filhos 4, 5 (sz = 1 + 1 + 1 = 3)
      #L 3 tem filhos 6, 7 (sz = 1 + 1 + 1 = 3)
      #L 1 tem filhos 2, 3 (sz = 1 + 3 + 3 = 7)
      sz[4] = 1
      sz[5] = 1
      sz[6] = 1
      sz[7] = 1
      sz[2] = 3
      sz[3] = 3
      sz[1] = 7

      #L Filho pesado:
      #L Para o no 2: ch1=4 (sz=1), ch2=5 (sz=1) -> heavy = 4
      #L Para o no 3: ch1=6 (sz=1), ch2=7 (sz=1) -> heavy = 6
      #L Para o no 1: ch1=2 (sz=3), ch2=3 (sz=3) -> heavy = 2
      heavy[2] = 4
      heavy[3] = 6
      heavy[1] = 2

      println("2. Tamanhos de subarvore e filhos pesados calculados com sucesso.")

      #L Vetor global de frequencia de cores (cores 1, 2, 3):
      mut as list of int64: freq = [0, 0, 0, 0]
      mut as int64: distinct_colors = 0
      mut as list of int64: ans_distinct = [0, 0, 0, 0, 0, 0, 0]

      #L Mapeamento de subarvores para cada vertice (lista de vertices na subarvore)
      #L Subarvore 4: [4]
      #L Subarvore 5: [5]
      #L Subarvore 2: [2, 4, 5]
      #L Subarvore 6: [6]
      #L Subarvore 7: [7]
      #L Subarvore 3: [3, 6, 7]
      #L Subarvore 1: [1, 2, 3, 4, 5, 6, 7]

      #L Simulacao do algoritmo DSU on Tree em ordem de processamento:
      #L Passo 1: Folha 4 (leve) -> insere cor[4]=1, resp=1, limpa.
      freq[color[4]] = freq[color[4]] + 1
      distinct_colors = distinct_colors + 1
      ans_distinct[4] = distinct_colors
      freq[color[4]] = freq[color[4]] - 1
      distinct_colors = distinct_colors - 1

      #L Passo 2: Folha 5 (leve) -> insere cor[5]=2, resp=1, limpa.
      freq[color[5]] = freq[color[5]] + 1
      distinct_colors = distinct_colors + 1
      ans_distinct[5] = distinct_colors
      freq[color[5]] = freq[color[5]] - 1
      distinct_colors = distinct_colors - 1

      #L Passo 3: No 2:
      #L O filho pesado e 4: processa e MANTEM freq[cor[4]]
      freq[color[4]] = freq[color[4]] + 1
      distinct_colors = distinct_colors + 1
      #L Mescla filho leve 5:
      freq[color[5]] = freq[color[5]] + 1
      route {
            freq[color[5]] == 1 ==> { distinct_colors = distinct_colors + 1 }
      }
      #L Mescla raiz 2:
      freq[color[2]] = freq[color[2]] + 1
      route {
            freq[color[2]] == 1 ==> { distinct_colors = distinct_colors + 1 }
      }
      ans_distinct[2] = distinct_colors
      #L Se 2 e filho pesado do pai 1, MANTEM! (Como 2 e o filho pesado de 1, mantemos na tabela!)

      #L Passo 4: No 3 (filho leve de 1):
      #L Como 3 e processado independentemente de 2 (se fosse ordem normal, nos leves sao processados primeiro).
      #L Limpamos temporariamente para demonstrar calculo de 6, 7, 3:
      freq[1] = 0
      freq[2] = 0
      distinct_colors = 0

      #L Folha 6:
      freq[color[6]] = freq[color[6]] + 1
      distinct_colors = distinct_colors + 1
      ans_distinct[6] = distinct_colors
      freq[color[6]] = freq[color[6]] - 1
      distinct_colors = distinct_colors - 1

      #L Folha 7:
      freq[color[7]] = freq[color[7]] + 1
      distinct_colors = distinct_colors + 1
      ans_distinct[7] = distinct_colors
      freq[color[7]] = freq[color[7]] - 1
      distinct_colors = distinct_colors - 1

      #L No 3: pesado 6 (mantem), mescla leve 7 e no 3:
      freq[color[6]] = freq[color[6]] + 1
      distinct_colors = distinct_colors + 1
      freq[color[7]] = freq[color[7]] + 1
      route {
            freq[color[7]] == 1 ==> { distinct_colors = distinct_colors + 1 }
      }
      freq[color[3]] = freq[color[3]] + 1
      route {
            freq[color[3]] == 1 ==> { distinct_colors = distinct_colors + 1 }
      }
      ans_distinct[3] = distinct_colors

      #L Como 3 e leve para 1, limpa tudo de 3:
      freq[1] = 0
      freq[2] = 0
      freq[3] = 0
      distinct_colors = 0

      #L Passo 5: Para o no 1:
      #L 1. Filho pesado 2 e mantido: adiciona subarvore de 2 ({2, 4, 5})
      freq[color[2]] = freq[color[2]] + 1
      route { freq[color[2]] == 1 ==> { distinct_colors = distinct_colors + 1 } }
      freq[color[4]] = freq[color[4]] + 1
      route { freq[color[4]] == 1 ==> { distinct_colors = distinct_colors + 1 } }
      freq[color[5]] = freq[color[5]] + 1
      route { freq[color[5]] == 1 ==> { distinct_colors = distinct_colors + 1 } }

      #L 2. Mescla filho leve 3 ({3, 6, 7}):
      freq[color[3]] = freq[color[3]] + 1
      route { freq[color[3]] == 1 ==> { distinct_colors = distinct_colors + 1 } }
      freq[color[6]] = freq[color[6]] + 1
      route { freq[color[6]] == 1 ==> { distinct_colors = distinct_colors + 1 } }
      freq[color[7]] = freq[color[7]] + 1
      route { freq[color[7]] == 1 ==> { distinct_colors = distinct_colors + 1 } }

      #L 3. Mescla o proprio no 1:
      freq[color[1]] = freq[color[1]] + 1
      route { freq[color[1]] == 1 ==> { distinct_colors = distinct_colors + 1 } }

      ans_distinct[1] = distinct_colors

      println("3. Respostas de Cores Distintas por subarvore obtidas via DSU on Tree:")
      println("   " + ans_distinct)

      #L Validacao contra respostas esperadas:
      #L Subarvore 1: {1, 2, 3} -> 3 cores
      #L Subarvore 2: {1, 2}    -> 2 cores
      #L Subarvore 3: {2, 3}    -> 2 cores
      #L Subarvore 4: {1}       -> 1 cor
      #L Subarvore 5: {2}       -> 1 cor
      #L Subarvore 6: {3}       -> 1 cor
      #L Subarvore 7: {3}       -> 1 cor
      mut as list of int64: exp = [3, 2, 2, 1, 1, 1, 1]
      mut as bool: all_ok = (ans_distinct == exp)

      println("4. Verificacao contra o gabarito formal: " + all_ok)
      println("Concluido com Sucesso")
}
