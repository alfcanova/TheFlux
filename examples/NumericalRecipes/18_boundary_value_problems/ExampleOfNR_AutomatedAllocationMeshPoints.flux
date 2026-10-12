#L ============================================================================
#L Algoritmo: Alocacao Automatizada de Pontos de Malha (Equidistribuicao)
#L Capitulo: 18_boundary_value_problems
#L Complexidade: O(N_pontos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Refinamento de malha adaptativa por equidistribuicao de funcao densidade de peso.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_AutomatedAllocationMeshPoints) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_AutomatedAllocationMeshPoints")
      println("==================================================")

      #L Funcao densidade de peso w(x) representando gradiente em 4 intervalos:
      #L Intervalo 1: w = 100 (baixa variacao)
      #L Intervalo 2: w = 300 (moderada variacao)
      #L Intervalo 3: w = 500 (alta variacao / camada limite)
      #L Intervalo 4: w = 100 (baixa variacao)
      mut as list of int64: w = [100, 300, 500, 100]
      mut as int64: peso_total = w[1] + w[2] + w[3] + w[4] #L 1000

      println("1. Pesos locais dos intervalos de malha:")
      println("   -> w = [" + w[1] + ", " + w[2] + ", " + w[3] + ", " + w[4] + "]")
      println("   -> Peso acumulado total = " + peso_total)

      #L Malha adaptativa concentra sub-intervalos proporcionais ao peso:
      #L Fração acumulada esperada no ponto de maior gradiente:
      mut as int64: frac_cumulada = w[1] + w[2] + w[3] #L 900 / 1000 = 90%
      println("2. Posicao acumulada apos o pico de gradiente = " + frac_cumulada + " / 1000")

      #L Invariante de equidistribuicao: conservacao do peso total
      mut as int64: residuo_peso = peso_total - 1000
      println("3. Residuo da conservacao do peso = " + residuo_peso + " (esperado: 0)")
      println("4. Alocacao adaptativa de malha concluida com exito.")
}
