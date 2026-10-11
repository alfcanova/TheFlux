#L ============================================================================
#L Algoritmo: Gilbert-Johnson-Keerthi (GJK)
#L Dominio: 06_numerical_physics / Subdominio: geometry
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoGeometriaGilbertJohnsonKeerthi) {
      println("==================================================")
      println("  SciAlgo: Gilbert-Johnson-Keerthi (GJK)")
      println("==================================================")

      mut as int64: dot_dir = 45
      mut as int64: support_sign = -1
      route { dot_dir > 0 ==> { support_sign = 1 } _ ==> {} }

      println("1. Vetor suporte do simplex no algoritmo GJK: " + support_sign)
      println("2. Gilbert-Johnson-Keerthi (GJK) concluido com sucesso.")
}
