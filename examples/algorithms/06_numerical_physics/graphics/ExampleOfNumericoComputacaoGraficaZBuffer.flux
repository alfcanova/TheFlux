#L ============================================================================
#L Algoritmo: Z-Buffer Depth Buffer
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaZBuffer) {
      println("==================================================")
      println("  SciAlgo: Z-Buffer Depth Buffer")
      println("==================================================")

      mut as list of int64: new_z = [15, 80, 25, 40]
      mut as list of int64: cur_z = [50, 50, 50, 50]
      mut as int64: n = listLength(new_z)
      mut as int64: updated = 0
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  new_z[i] < cur_z[i] ==> { updated = updated + 1 }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Pixels com teste de profundidade aceito no Z-Buffer: " + updated)
      println("2. Z-Buffer Depth Buffer concluido com sucesso.")
}
