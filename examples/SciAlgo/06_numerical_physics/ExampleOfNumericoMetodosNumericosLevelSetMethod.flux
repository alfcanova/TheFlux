#L ============================================================================
#L Algoritmo: Level Set Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosLevelSetMethod) {
      println("==================================================")
      println("  SciAlgo: Level Set Method")
      println("==================================================")

      mut as int64: phi_val = -5
      mut as int64: region = 0
      route {
            phi_val < 0 ==> { region = -1 }
            phi_val > 0 ==> { region = 1 }
            _ ==> { region = 0 }
      }

      println("1. Regiao classificada pela funcao de distancia Level Set: " + region)
      println("2. Level Set Method concluido com sucesso.")
}
