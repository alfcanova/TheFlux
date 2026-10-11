#L ============================================================================
#L Algoritmo: Normalized Compression Distance (NCD)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(|x| + |y|) dependente do compressor
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaNormalizedCompression) {
      println("==================================================")
      println("  SciAlgo: Normalized Compression Distance (NCD)")
      println("==================================================")

      #L Métrica de distância universal de Kolmogorov aproximada por compressores:
      #L NCD(x, y) = (C(xy) - min(C(x), C(y))) / max(C(x), C(y))
      #L Strings x e y com alto compartilhamento de informacao (ex: variantes de DNA):
      #L C(x) = 120 bytes, C(y) = 110 bytes
      #L C(xy) = 135 bytes (compressao conjunta muito eficiente devido a redundancy cruzada)
      mut as int64: cx = 120
      mut as int64: cy = 110
      mut as int64: cxy = 135

      mut as int64: min_c = cy
      route {
            cx < cy ==> { min_c = cx }
            _ ==> {}
      }

      mut as int64: max_c = cx
      route {
            cy > cx ==> { max_c = cy }
            _ ==> {}
      }

      #L Calculo de NCD em escala percentual inteira: (cxy - min_c) * 100 / max_c
      mut as int64: numerador = cxy - min_c #L 135 - 110 = 25
      mut as int64: ncd_pct = (numerador * 100) /i max_c #L 2500 / 120 = 20%

      println("1. Tamanho comprimido C(x)=" + cx + ", C(y)=" + cy + ", C(xy)=" + cxy)
      println("2. Menor tamanho base: " + min_c + ", maior tamanho base: " + max_c)
      println("3. Distancia NCD calculada: " + ncd_pct + "% (alta similaridade informacional)")
      println("4. Normalized Compression Distance concluido com sucesso.")
}
