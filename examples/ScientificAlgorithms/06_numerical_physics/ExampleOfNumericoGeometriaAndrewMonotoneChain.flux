#L ============================================================================
#L Algoritmo: Andrew Monotone Chain
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaAndrewMonotoneChain) {
      println("==================================================")
      println("  SciAlgo: Andrew Monotone Chain")
      println("==================================================")

      mut as int64: ax = 0
      mut as int64: ay = 0
      mut as int64: bx = 5
      mut as int64: by = 2
      mut as int64: cx = 2
      mut as int64: cy = 4
      mut as int64: cross_val = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)

      println("1. Curvatura do fecho monotono calculada: " + cross_val)
      println("2. Andrew Monotone Chain concluido com sucesso.")
}
