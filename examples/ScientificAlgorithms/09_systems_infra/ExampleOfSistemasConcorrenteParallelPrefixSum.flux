#L ============================================================================
#L Algoritmo: Parallel Prefix Sum / Blelloch Scan
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N) trabalho total | O(log N) profundidade paralela (span)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelPrefixSum) {
      println("==================================================")
      println("  SciAlgo: Parallel Prefix Sum (Blelloch Scan)    ")
      println("==================================================")

      #L Vetor de entrada com N = 8 elementos (potencia de 2)
      #L Blelloch Scan realiza duas fases: Up-Sweep (Reduce) e Down-Sweep.
      mut as int64: n = 8
      mut as list of int64: a = [3, 1, 7, 0, 4, 1, 6, 3]

      println("1. Vetor de Entrada Original (N = 8):")
      mut as string: in_str = ""
      mut as int64: idx = 1
      infinite (idx <= n) {
            in_str = in_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + in_str + "]")

      #L Fase 1: Up-Sweep (Arvore de Reducao Paralela)
      #L Em cada passo d = 1, 2, 4..., elementos distanciados sao somados
      println("2. Executando Up-Sweep Phase (Reduce Tree)...")
      mut as int64: stride = 1
      infinite (stride < n) {
            mut as int64: i = stride * 2
            infinite (i <= n) {
                  a[i] = a[i] + a[i - stride]
                  i = i + stride * 2
            }
            stride = stride * 2
      }

      #L A raiz contem a soma total
      mut as int64: total_sum = a[n]
      println("   Soma Total Reduzida na Raiz: " + total_sum)

      #L Fase 2: Down-Sweep Phase (Scan Exclusivo)
      #L Define a raiz como 0 e propaga descendo na arvore
      println("3. Executando Down-Sweep Phase...")
      a[n] = 0

      stride = n /i 2
      infinite (stride >= 1) {
            mut as int64: i = stride * 2
            infinite (i <= n) {
                  mut as int64: t = a[i - stride]
                  a[i - stride] = a[i]
                  a[i] = a[i] + t
                  i = i + stride * 2
            }
            stride = stride /i 2
      }

      println("4. Resultado do Exclusive Prefix Sum (Blelloch Scan):")
      mut as string: excl_str = ""
      idx = 1
      infinite (idx <= n) {
            excl_str = excl_str + a[idx] + " "
            idx = idx + 1
      }
      println("   Scan Exclusivo = [ " + excl_str + "]")

      #L Converte para Scan Inclusivo: somando com a entrada original
      #L Entrada original: [3, 1, 7, 0, 4, 1, 6, 3]
      #L Scan Inclusivo esperado: [3, 4, 11, 11, 15, 16, 22, 25]
      mut as list of int64: orig = [3, 1, 7, 0, 4, 1, 6, 3]
      mut as list of int64: incl = [0, 0, 0, 0, 0, 0, 0, 0]
      idx = 1
      infinite (idx <= n) {
            incl[idx] = a[idx] + orig[idx]
            idx = idx + 1
      }

      println("5. Scan Inclusivo Calculado:")
      mut as string: incl_str = ""
      idx = 1
      infinite (idx <= n) {
            incl_str = incl_str + incl[idx] + " "
            idx = idx + 1
      }
      println("   Scan Inclusivo = [ " + incl_str + "]")

      #L Validacao deterministica do scan inclusivo: ultimo elemento deve ser 24 (ou soma total)
      #L 3+1+7+0+4+1+6+3 = 25
      mut as bool: correct = (incl[1] == 3) and (incl[4] == 11) and (incl[8] == 25)
      println("6. Verificacao de Exatidao Paralela: " + correct)

      println("Parallel Prefix Sum concluido com sucesso.")
}
