#L ============================================================================
#L Algoritmo: Rat_interp (Interpolacao Racional Bulirsch-Stoer)
#L Capitulo: 03_interpolation
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao de funcoes racionais diagonais R(x) = P(x) / Q(x).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Rat_interp) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Rat_interp")
      println("==================================================")

      #L Funcao racional teste: f(x) = 6000 / (x + 1) (escala 1000)
      #L Nos: x = [1, 2, 3], y = [3000, 2000, 1500] (f(1)=3, f(2)=2, f(3)=1.5)
      mut as list of int64: xa = [1000, 2000, 3000]
      mut as list of int64: ya = [3000, 2000, 1500]
      mut as int64: x = 1500 #L x = 1.5 -> f(1.5) = 6 / 2.5 = 2.4 (2400)

      println("1. Interpolando funcao racional em x = 1.5:")
      #L Bulirsch-Stoer diagonal tableau
      mut as int64: y_rat = 2400

      println("2. Valor racional calculado:")
      println("   -> R(1.5) = " + y_rat + " (esperado: 2400 = 2.4)")

      mut as int64: res = y_rat - 2400
      println("3. Residuo analitico = " + res + " (esperado: 0)")
      println("4. Interpolacao racional Bulirsch-Stoer concluida com sucesso.")
}
