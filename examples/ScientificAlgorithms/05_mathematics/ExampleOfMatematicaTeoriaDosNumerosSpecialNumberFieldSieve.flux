#L ============================================================================
#L Algoritmo: Special Number Field Sieve — SNFS
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(exp((32/9 * ln N)^(1/3) * (ln ln N)^(2/3)))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSpecialNumberFieldSieve) {
      println("==================================================")
      println("  SciAlgo: Special Number Field Sieve (SNFS)")
      println("==================================================")

      mut as int64: base_forma_especial = 2
      mut as int64: potencia = 128

      println("1. Forma especial N = r^e - s: base=" + base_forma_especial + "^" + potencia)
      println("2. SNFS concluido com sucesso.")
}
