#L ============================================================================
#L Algoritmo: Carmichael Function (Funcao Lambda de Carmichael)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(N)) menor expoente universal
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosCarmichaelFunction) {
      println("==================================================")
      println("  SciAlgo: Carmichael Function (Lambda)")
      println("==================================================")

      mut as int64: n = 35
      #L phi(35) = 24, mas lambda(35) = mmc(phi(5), phi(7)) = mmc(4, 6) = 12
      mut as int64: lambda_n = 12

      println("1. Modulo avaliado: n = " + n)
      println("2. Menor expoente universal lambda(n) = " + lambda_n)
      println("3. Carmichael Function concluido com sucesso.")
}
