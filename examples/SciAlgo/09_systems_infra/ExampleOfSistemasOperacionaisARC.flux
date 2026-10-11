#L ============================================================================
#L Algoritmo: Adaptive Replacement Cache (ARC) (Megiddo & Modha 2003)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) autoajuste dinamico entre Recencia (LRU) e Frequencia (LFU)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisARC) {
      println("==================================================")
      println("  SciAlgo: Adaptive Replacement Cache (ARC)")
      println("==================================================")

      #L O ARC (IBM, Megiddo & Modha 2003) autoajusta dinamicamente o balanceamento
      #L entre Recencia (T1) e Frequencia (T2) atraves de listas fantasmas (B1 e B2).
      #L Parametro de adaptacao p:
      #L - Um hit na lista fantasma de recencia B1 aumenta p (favorece recencia).
      #L - Um hit na lista fantasma de frequencia B2 diminui p (favorece frequencia).
      #L Tamanho total da cache de dados: c = 4 entradas.

      mut as int64: c = 4
      mut as int64: p = 0 #L Alvo do tamanho de T1 (inicia em 0)

      #L Contadores de tamanho das 4 sublistas:
      #L T1: dados recentes em cache | B1: historico fantasma de recencia
      #L T2: dados frequentes em cache | B2: historico fantasma de frequencia
      mut as int64: len_t1 = 0
      mut as int64: len_b1 = 0
      mut as int64: len_t2 = 0
      mut as int64: len_b2 = 0

      #L Cache de dados simples (4 slots): guarda as paginas atualmente em memoria
      mut as list of int64: cache = [-1, -1, -1, -1]

      println("1. Parametros da Cache ARC:")
      println("   Capacidade da Cache (c): " + c + " paginas")
      println("   Parametro de adaptacao p inicial: " + p)

      println("==================================================")
      println("2. [Simulacao de Cargas Mistas e Adaptacao de p]:")

      #L Cenario 1: Insercao de carga recente (Paginas 10, 20, 30, 40)
      println("--- Fase 1: Inserindo paginas recentes 10, 20, 30, 40 ---")
      cache[1] = 10
      cache[2] = 20
      cache[3] = 30
      cache[4] = 40
      len_t1 = 4
      println("   T1 cheio com 4 paginas (p=" + p + ")")

      #L Cenario 2: Hit na pagina 20 -> Promovida para T2 (frequente)
      println("--- Fase 2: Reacesso a Pagina 20 (Frequencia) ---")
      len_t1 = len_t1 - 1
      len_t2 = len_t2 + 1
      println("   Pagina 20 promovida de T1 para T2 (T1=" + len_t1 + ", T2=" + len_t2 + ")")

      #L Cenario 3: Deslocamento para lista fantasma e adaptacao do parametro p
      println("--- Fase 3: Acesso a pagina expulsa presente em B1 (Fantasma de Recencia) ---")
      println("   [Ghost Hit em B1]: Indica que a cache esta sofrendo por falta de espaco de recencia!")
      #L Incrementa p: p = min(c, p + max(1, len_b2 / len_b1))
      p = p + 1
      println("   -> Parametro p ajustado para CIMA: novo p = " + p + " (favorecendo recencia)")

      #L Cenario 4: Acesso a pagina presente em B2 (Fantasma de Frequencia)
      println("--- Fase 4: Acesso a pagina expulsa presente em B2 (Fantasma de Frequencia) ---")
      println("   [Ghost Hit em B2]: Indica que dados frequentes estao sendo descartados precocemente!")
      route {
            p > 0 ==> { p = p - 1 }
            _ ==> {}
      }
      println("   -> Parametro p ajustado para BAIXO: novo p = " + p + " (favorecendo frequencia)")

      println("==================================================")
      println("3. Conclusao da Analise ARC:")
      println("   O ARC autoajusta sua politica em tempo real sem intervencao manual.")
      println("   Supera LRU e LFU em uma ampla variedade de cargas de trabalho!")
      println("==================================================")
}
