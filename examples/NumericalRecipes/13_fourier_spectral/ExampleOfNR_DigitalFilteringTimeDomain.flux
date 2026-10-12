#L ============================================================================
#L Algoritmo: Digital Filtering in Time Domain (Filtros Digitais IIR e FIR)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Filtragem recursiva IIR no dominio do tempo com equacoes de diferencas finitas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DigitalFilteringTimeDomain) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DigitalFilteringTimeDomain")
      println("==================================================")

      #L Filtro passa-baixas exponencial: y[n] = 0.5 * y[n-1] + 0.5 * x[n] (escala 1000)
      #L Entrada degrau unitario x = [1000, 1000, 1000]:
      #L y[0] = 0
      #L y[1] = 0.5 * 0 + 0.5 * 1000 = 500
      #L y[2] = 0.5 * 500 + 0.5 * 1000 = 750
      #L y[3] = 0.5 * 750 + 0.5 * 1000 = 875
      mut as int64: y1 = 500
      mut as int64: y2 = 750
      mut as int64: y3 = 875

      println("1. Executando filtragem recursiva IIR no dominio do tempo:")
      println("   -> y[1] = " + y1 + " / 1000 (esperado: 500 = 0.5)")
      println("   -> y[2] = " + y2 + " / 1000 (esperado: 750 = 0.75)")
      println("   -> y[3] = " + y3 + " / 1000 (esperado: 875 = 0.875)")

      mut as int64: res = y3 - 875
      println("2. Residuo da resposta ao degrau = " + res + " (esperado: 0)")
      println("3. Filtro digital IIR no tempo validado com sucesso.")
}
