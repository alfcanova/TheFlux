#L ============================================================================
#L Algoritmo: Fork-Join Concurrency Model (Cilk / ForkJoinPool Framework)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N) trabalho | O(log N) profundidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteForkJoin) {
      println("==================================================")
      println("  SciAlgo: Fork-Join Concurrency Model (Divide/Join)")
      println("==================================================")

      #L O modelo Fork-Join divide uma tarefa recursivamente ate que o tamanho
      #L atinja um limiar sequencial (threshold), disparando (fork) as subtarefas
      #L concorrentemente e combinando (join) os resultados parciais.
      #L
      #L Vetor de entrada com N = 8 elementos:
      #L Soma recursiva paralela em 3 niveis de profundidade.
      mut as int64: n = 8
      mut as list of int64: a = [10, 20, 30, 40, 50, 60, 70, 80]

      println("1. Vetor de Entrada (N = 8):")
      mut as string: in_str = ""
      mut as int64: idx = 1
      infinite (idx <= n) {
            in_str = in_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + in_str + "]")

      println("2. Executando Arvore Fork-Join de 3 Niveis:")

      #L Nivel 1: Fork Inicial (divide 1..8 em 1..4 e 5..8)
      println("   [FORK Nivel 1] Dividindo Tarefa Raiz em Ramos (1..4) e (5..8)")

      #L Nivel 2: Sub-forks
      println("   [FORK Nivel 2] Subtarefa A dividida em (1..2) e (3..4)")
      println("   [FORK Nivel 2] Subtarefa B dividida em (5..6) e (7..8)")

      #L Nivel 3 (Folhas / Sequencial base, tamanho = 2):
      #L Tarefa 1: a[1] + a[2] = 10 + 20 = 30
      #L Tarefa 2: a[3] + a[4] = 30 + 40 = 70
      #L Tarefa 3: a[5] + a[6] = 50 + 60 = 110
      #L Tarefa 4: a[7] + a[8] = 70 + 80 = 150
      mut as int64: leaf_res1 = a[1] + a[2]
      mut as int64: leaf_res2 = a[3] + a[4]
      mut as int64: leaf_res3 = a[5] + a[6]
      mut as int64: leaf_res4 = a[7] + a[8]

      println("3. Executando Fases de Join (Sincronizacao Concorrente):")
      #L Join Nivel 2:
      mut as int64: join_sub_a = leaf_res1 + leaf_res2 #L 30 + 70 = 100
      mut as int64: join_sub_b = leaf_res3 + leaf_res4 #L 110 + 150 = 260
      println("   [JOIN Nivel 2] Subtarefa A reuniu resultado: " + join_sub_a)
      println("   [JOIN Nivel 2] Subtarefa B reuniu resultado: " + join_sub_b)

      #L Join Nivel 1 (Raiz):
      mut as int64: total_joined = join_sub_a + join_sub_b #L 100 + 260 = 360
      println("   [JOIN Nivel 1] Raiz reuniu resultado final: " + total_joined)

      println("4. Verificacao de Integridade Fork-Join:")
      #L Soma esperada: 10+20+30+40+50+60+70+80 = 360
      mut as bool: correct = total_joined == 360
      println("   Resultado Exato: " + correct)

      println("Fork-Join Concurrency Model concluido com sucesso.")
}
