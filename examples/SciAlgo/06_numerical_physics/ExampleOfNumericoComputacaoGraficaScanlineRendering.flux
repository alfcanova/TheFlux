#L ============================================================================
#L Algoritmo: Scanline Rendering
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaScanlineRendering) {
      println("==================================================")
      println("  SciAlgo: Scanline Rendering")
      println("==================================================")

      mut as int64: y_min = 0
      mut as int64: y_max = 10
      mut as int64: filled_pixels = 0
      mut as int64: scan_y = y_min
      infinite (scan_y <= y_max) {
            mut as int64: span_w = (scan_y - y_min + 1) * 2
            filled_pixels = filled_pixels + span_w
            scan_y = scan_y + 1
      }

      println("1. Area de pixels rasterizados via Scanline: " + filled_pixels)
      println("2. Scanline Rendering concluido com sucesso.")
}
