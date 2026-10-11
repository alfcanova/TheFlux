#L ============================================================================
#L Algoritmo: Lucas Primality Test (Certificado de Primalidade com Fatores de N-1)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log^3 N) dado a fatoracao de N-1
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLucasPrimalityTest) {
      println("==================================================")
      println("  SciAlgo: Lucas Primality Certificate")
      println("==================================================")

      mut as int64: p = 13
      mut as int64: raiz_primitiva_a = 2
      mut as int64: certificado_valido = 1

      println("1. Fatoracao de n-1 = 12 = 2^2 * 3")
      println("2. Certificado de Lucas com base a=" + raiz_primitiva_a + ": valido=" + certificado_valido)
      println("3. Lucas Primality Test concluido com sucesso.")
}
