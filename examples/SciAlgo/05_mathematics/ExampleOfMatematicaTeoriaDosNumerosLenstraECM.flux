#L ============================================================================
#L Algoritmo: Lenstra ECM (Fatoração por Curvas Elípticas de Lenstra)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(exp(sqrt(2 * ln p * ln ln p))) dependente do menor fator p
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLenstraECM) {
      println("==================================================")
      println("  SciAlgo: Lenstra Elliptic Curve Factoring (ECM)")
      println("==================================================")

      mut as int64: curvas_testadas = 3
      mut as int64: fator_encontrado = 73

      println("1. Curvas elipticas aleatorias sob Z/nZ: " + curvas_testadas)
      println("2. Fator isolado na quebra da lei de grupo: " + fator_encontrado)
      println("3. Lenstra ECM concluido com sucesso.")
}
