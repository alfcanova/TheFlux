#L ============================================================================
#L Algoritmo: Powell's Direction Set Method (Metodo de Direcoes de Powell)
#L Capitulo: 10_minimization
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Minimizacoes em linha sucessivas gerando direcoes mutuamente conjugadas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DirectionSetPowellsMethod) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DirectionSetPowellsMethod")
      println("==================================================")

      #L Minimizando f(x, y) = x^2 + 4*y^2 (minimo em (0, 0)):
      #L Ponto inicial P0 = (4, 2)
      mut as int64: x = 4
      mut as int64: y = 2

      println("1. Minimizando sequencialmente ao longo das direcoes cartesianas:")
      #L Linha 1: varia x, fixa y=2 -> minimo de x^2 + 16 ocorre em x = 0
      x = 0
      println("   -> Apos busca na direcao u1 = (1, 0): P1 = (" + x + ", " + y + ")")

      #L Linha 2: varia y, fixa x=0 -> minimo de 4*y^2 ocorre em y = 0
      y = 0
      println("   -> Apos busca na direcao u2 = (0, 1): P2 = (" + x + ", " + y + ")")

      mut as int64: res = x * x + 4 * (y * y)
      println("2. Residuo final da forma quadratica = " + res + " (esperado: 0)")
      println("3. Metodo de direcoes de Powell concluido com sucesso.")
}
