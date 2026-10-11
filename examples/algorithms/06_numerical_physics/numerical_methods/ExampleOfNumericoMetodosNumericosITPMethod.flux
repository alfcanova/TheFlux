#L ============================================================================
#L Algoritmo: ITP Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosITPMethod) {
      println("==================================================")
      println("  SciAlgo: ITP Method")
      println("==================================================")

      mut as int64: a = 0
      mut as int64: b = 100
      mut as int64: half_pt = (a + b) /i 2
      mut as int64: delta = (b - a) /i 4
      mut as int64: projected_root = half_pt + delta

      println("1. Sub-intervalo projetado pelo metodo ITP: " + projected_root)
      println("2. ITP Method concluido com sucesso.")
}
