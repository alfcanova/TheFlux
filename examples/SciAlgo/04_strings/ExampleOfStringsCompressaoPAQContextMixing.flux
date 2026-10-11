#L ============================================================================
#L Algoritmo: PAQ Context Mixing Compression
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(M * N) onde M eh a quantidade de modelos de contexto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoPAQContextMixing) {
      println("==================================================")
      println("  SciAlgo: PAQ Multi-Context Mixing Compression")
      println("==================================================")

      #L Modelos independentes de contexto predizendo probabilidade do proximo bit ser 1:
      #L Modelo 1: Ordem-0 (frequencia global de bits)
      #L Modelo 2: Ordem-1 (condicionado ao bit anterior)
      #L Modelo 3: Modelo de palavras/bytes
      #L Predicoes em escala logit inteira [-2048 .. +2048]:
      mut as list of int64: predicoes = [150, 420, 680]
      mut as list of int64: pesos     = [256, 512, 1024] #L Pesos adaptativos da rede neural linear

      mut as int64: num_modelos = listLength(predicoes)
      mut as int64: soma_ponderada = 0
      mut as int64: soma_pesos = 0

      mut as int64: i = 1
      infinite (i <= num_modelos) {
            soma_ponderada = soma_ponderada + (predicoes[i] * pesos[i])
            soma_pesos = soma_pesos + pesos[i]
            i = i + 1
      }

      #L Mistura de logit combinada: logit_misto = soma_ponderada / soma_pesos
      mut as int64: logit_misto = soma_ponderada /i soma_pesos

      #L Mapeamento logit para probabilidade percentual aproximada: p(1) = 50 + (logit / 40)
      mut as int64: p_final = 50 + (logit_misto /i 40)
      route {
            p_final > 99 ==> { p_final = 99 }
            p_final < 1 ==> { p_final = 1 }
            _ ==> {}
      }

      println("1. Modelos de contexto integrados: " + num_modelos)
      println("2. Logit ponderado combinado pela rede: " + logit_misto)
      println("3. Probabilidade preditiva final do bit 1: " + p_final + "%")
      println("4. PAQ Context Mixing concluido com sucesso.")
}
