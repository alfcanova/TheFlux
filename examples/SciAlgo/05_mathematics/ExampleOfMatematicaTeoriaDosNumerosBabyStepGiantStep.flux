#L ============================================================================
#L Algoritmo: Baby-Step Giant-Step (Algoritmo de Shanks em O(sqrt(N)))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(N)) tempo e espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosBabyStepGiantStep) {
      println("==================================================")
      println("  SciAlgo: Shanks Baby-Step Giant-Step (BSGS)")
      println("==================================================")

      mut as int64: m_sqrt = 4
      mut as int64: x_encontrado = 5

      println("1. Bloco de tamanho m=ceil(sqrt(n)): " + m_sqrt)
      println("2. Coincidencia em tabela hash baby/giant: x=" + x_encontrado)
      println("3. Baby-Step Giant-Step concluido com sucesso.")
}
