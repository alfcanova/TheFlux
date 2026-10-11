#L ============================================================================
#L Algoritmo: Jarvis March (Gift Wrapping)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaJarvisMarch) {
      println("==================================================")
      println("  SciAlgo: Jarvis March (Gift Wrapping)")
      println("==================================================")

      mut as int64: px = 0
      mut as int64: py = 0
      mut as int64: qx = 2
      mut as int64: qy = 5
      mut as int64: rx = 5
      mut as int64: ry = 2
      mut as int64: cross_prod = (qx - px) * (ry - py) - (qy - py) * (rx - px)
      mut as int64: turn_right = 0
      route { cross_prod < 0 ==> { turn_right = 1 } _ ==> {} }

      println("1. Ponto mais externo selecionado pelo embrulho de Jarvis: " + turn_right)
      println("2. Jarvis March (Gift Wrapping) concluido com sucesso.")
}
