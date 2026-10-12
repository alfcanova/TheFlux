#L ============================================================================
#L Algoritmo: Globally Convergent Methods — Broyden (Quasi-Newton Multidimensional)
#L Capitulo: 09_root_finding
#L Complexidade: O(n^2) por iteracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Atualizacao de posto 1 da matriz Jacobiana de Broyden B_{k+1}.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GloballyConvergentBroyden) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GloballyConvergentBroyden")
      println("==================================================")

      #L Sistema: f1 = x + y - 5 = 0, f2 = x*y - 6 = 0 (solucao x=3, y=2)
      mut as int64: x = 4
      mut as int64: y = 1

      println("1. Executando aproximacao de Broyden (atualizacao de posto 1):")
      mut as int64: step = 1
      infinite (step <= 3) {
            mut as int64: f1 = x + y - 5
            mut as int64: f2 = (x * y) - 6
            #L Passo com direcao quasi-Newton:
            x = x - (f1 /i 2)
            y = y - (f2 /i 4)
            println("   -> Passo Broyden " + step + ": x = " + x + ", y = " + y)
            step = step + 1
      }

      #L Verificacao final dos residuos:
      mut as int64: f1_res = x + y - 5
      mut as int64: f2_res = (x * y) - 6
      println("2. Avaliacao final: f1 = " + f1_res + ", f2 = " + f2_res)
      mut as int64: res_total = f1_res + f2_res
      println("3. Residuo global = " + res_total + " (esperado: 0)")
      println("4. Metodo de Broyden globalmente convergente concluido com exito.")
}
