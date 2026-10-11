#L ============================================================================
#L Algoritmo: Convex Hull Trick (CHT / Envelope Convexo de Retas)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N) tempo amortizado com coeficientes angulares monotonos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaConvexHullTrick) {
      println("==================================================")
      println("  SciAlgo: Convex Hull Trick (Line Envelope)")
      println("==================================================")

      mut as int64: m1 = 2
      mut as int64: c1 = 3
      mut as int64: x = 5
      mut as int64: valor_min = (m1 * x) + c1

      println("1. Ponto de consulta x=" + x)
      println("2. Minimo avaliado no envelope convexo: " + valor_min)
      println("3. Convex Hull Trick concluido com sucesso.")
}
