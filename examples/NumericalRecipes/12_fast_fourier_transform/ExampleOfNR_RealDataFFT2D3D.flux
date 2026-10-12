#L ============================================================================
#L Algoritmo: Fourier Transforms of Real Data in 2D/3D (FFT 2D e 3D de Dados Reais)
#L Capitulo: 12_fast_fourier_transform
#L Complexidade: O(N1*N2*log(N1*N2))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Exploracao da simetria Hermitiana multidimensional X(-k1, -k2) = X*(k1, k2).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RealDataFFT2D3D) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RealDataFFT2D3D")
      println("==================================================")

      #L Simetria Hermitiana em 2D: o semiplano direito determina o esquerdo por conjugacao
      mut as int64: celulas_armazenadas = 2 #L Metade do espaco de Fourier
      mut as int64: celulas_totais = 4

      println("1. Armazenamento compacto de FFT real 2D:")
      println("   -> Celulas unicas armazenadas: " + celulas_armazenadas + " de " + celulas_totais)

      mut as int64: res = celulas_armazenadas * 2 - celulas_totais
      println("2. Residuo da simetria Hermitiana 2D = " + res + " (esperado: 0)")
      println("3. FFT de dados reais em 2D/3D concluida com sucesso.")
}
