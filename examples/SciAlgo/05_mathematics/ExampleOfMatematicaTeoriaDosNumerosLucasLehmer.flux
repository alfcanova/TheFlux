#L ============================================================================
#L Algoritmo: Lucas-Lehmer (Teste de Primalidade para Primos de Mersenne M_p)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(p * M(p)) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLucasLehmer) {
      println("==================================================")
      println("  SciAlgo: Lucas-Lehmer Mersenne Primality Test")
      println("==================================================")

      #L M_5 = 2^5 - 1 = 31. Sequencia: s_0 = 4, s_{i} = (s_{i-1}^2 - 2) mod M_p
      mut as int64: m = 31
      mut as int64: s = 4
      mut as int64: i = 1
      infinite (i <= 3) {
            s = ((s * s) - 2) /r m
            i = i + 1
      }

      mut as int64: e_primo_mersenne = 0
      route {
            s == 0 ==> { e_primo_mersenne = 1 }
            _ ==> {}
      }

      println("1. Testando M_5 = " + m + ": residuo s_3 = " + s)
      println("2. Mersenne primo confirmado: " + e_primo_mersenne)
      println("3. Lucas-Lehmer concluido com sucesso.")
}
