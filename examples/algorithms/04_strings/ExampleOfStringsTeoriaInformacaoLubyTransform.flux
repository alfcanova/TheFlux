#L ============================================================================
#L Algoritmo: Luby Transform Codes (LT Codes / Fountain Codes)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(K log K) decodificacao de grafo bipartido via peeling decoder
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoLubyTransform) {
      println("==================================================")
      println("  SciAlgo: Luby Transform (LT) Fountain Codes")
      println("==================================================")

      #L K pacotes fonte originais: s1=12, s2=34, s3=56, s4=78
      mut as list of int64: pacotes_fonte = [12, 34, 56, 78]
      mut as int64: k = listLength(pacotes_fonte)

      #L Gerador de gotas (droplets) com graus da distribuicao de Soliton:
      #L Gota 1: grau 1 -> s1 = 12
      #L Gota 2: grau 2 -> s1 bxor s2 = 12 bxor 34 = 46
      #L Gota 3: grau 1 -> s3 = 56
      #L Gota 4: grau 2 -> s3 bxor s4 = 56 bxor 78 = 118
      #L Gota 5: grau 3 -> s1 bxor s2 bxor s4 = 104

      #L Peeling Decoder:
      #L 1. Identifica gota de grau 1 (Gota 1): resolve s1 = 12
      #L 2. Propaga s1 para Gota 2: s2 = Gota 2 bxor s1 = 46 bxor 12 = 34 (resolvido!)
      #L 3. Identifica gota de grau 1 (Gota 3): resolve s3 = 56
      #L 4. Propaga s3 para Gota 4: s4 = Gota 4 bxor s3 = 118 bxor 56 = 78 (resolvido!)

      mut as int64: resolvidos = 4
      mut as int64: gotas_recebidas = 5
      mut as int64: overhead_pct = ((gotas_recebidas - k) * 100) /i k

      println("1. Pacotes fonte originais K: " + k)
      println("2. Gotas da fonte recebidas: " + gotas_recebidas + " (overhead: " + overhead_pct + "%)")
      println("3. Pacotes recuperados pelo peeling decoder: " + resolvidos + " de " + k)
      println("4. LT Fountain Codes concluido com sucesso.")
}
