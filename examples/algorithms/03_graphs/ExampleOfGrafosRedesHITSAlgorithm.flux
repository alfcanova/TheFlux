#L ============================================================================
#L Algoritmo: HITS Algorithm (Hyperlink-Induced Topic Search - Jon Kleinberg 1999)
#L Dominio: 03_graphs / Categoria: Analise de redes e centralidade
#L Complexidade: O(k * (V + E)) calculo de autoridades e hubs iterativo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosRedesHITSAlgorithm) {
      println("==================================================")
      println("  SciAlgo: HITS Algorithm (Hubs & Authorities 1999)")
      println("==================================================")

      #L Rede direcionada de 4 paginas:
      #L Pagina 1 aponta para 2 e 3
      #L Pagina 4 aponta para 2
      #L Pagina 2 recebe links de 1 e 4 -> Alta Autoridade!
      #L Pagina 1 aponta para 2 e 3 -> Alto Hub!
      mut as int64: n = 4

      #L Valores iniciais de Hubs e Authorities (inicializados com 1)
      mut as list of int64: a = [1, 1, 1, 1]
      mut as list of int64: h = [1, 1, 1, 1]

      println("1. Estrutura da Rede de Links:")
      println("   Links: 1 -> 2, 1 -> 3, 4 -> 2")

      #L Iteracao 1:
      #L Atualizacao de Autoridade: a(p) = soma dos hubs que apontam para p
      #L a(1) = 0 (ninguem aponta para 1)
      #L a(2) = h(1) + h(4) = 1 + 1 = 2
      #L a(3) = h(1) = 1
      #L a(4) = 0 (ninguem aponta para 4)
      a[1] = 0
      a[2] = h[1] + h[4]
      a[3] = h[1]
      a[4] = 0
      println("2. Authorities apos iteracao 1:")
      println("   Auth(1)=" + a[1] + ", Auth(2)=" + a[2] + ", Auth(3)=" + a[3] + ", Auth(4)=" + a[4])

      #L Atualizacao de Hub: h(p) = soma das autoridades que p aponta
      #L h(1) = a(2) + a(3) = 2 + 1 = 3
      #L h(2) = 0
      #L h(3) = 0
      #L h(4) = a(2) = 2
      h[1] = a[2] + a[3]
      h[2] = 0
      h[3] = 0
      h[4] = a[2]
      println("3. Hubs apos iteracao 1:")
      println("   Hub(1)=" + h[1] + ", Hub(2)=" + h[2] + ", Hub(3)=" + h[3] + ", Hub(4)=" + h[4])

      #L Analise de lideranca:
      #L Maior autoridade: pagina 2 (Auth = 2)
      #L Maior hub: pagina 1 (Hub = 3)
      mut as bool: top_auth_is_2 = (a[2] > a[1]) and (a[2] > a[3]) and (a[2] > a[4])
      mut as bool: top_hub_is_1 = (h[1] > h[2]) and (h[1] > h[3]) and (h[1] > h[4])
      println("4. Identificacao de Papeis Estruturais:")
      println("   Maior Autoridade e a pagina 2: " + top_auth_is_2)
      println("   Maior Hub e a pagina 1: " + top_hub_is_1)

      mut as bool: valid = top_auth_is_2 and top_hub_is_1 and (a[2] == 2) and (h[1] == 3)
      println("5. Validacao: " + valid)
      println("==================================================")
}
