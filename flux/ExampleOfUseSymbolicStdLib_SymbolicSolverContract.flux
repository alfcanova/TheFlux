use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicSolverContract) {
      println("==================================================")
      println("  Exemplo: SymbolicSolverContract (Fase 1)")
      println("==================================================")

      #L 1. Resolucao de equacao linear
      mut as string: eq1 = "2 * x + 4 = 0"
      mut as float64: root1 = symbolicSolveLinear(eq1, "x")
      println("1. symbolicSolveLinear('2 * x + 4 = 0', 'x'): " + root1)

      #L 2. Resolucao de equacao linear com termos em ambos os lados
      mut as string: eq2 = "5 * x - 3 = 2 * x + 6"
      mut as float64: root2 = symbolicSolveLinear(eq2, "x")
      println("2. symbolicSolveLinear('5 * x - 3 = 2 * x + 6', 'x'): " + root2)

      #L 3. Resolucao de equacao quadratica com duas raizes reais
      mut as string: q1 = "x ^e 2 - 9 = 0"
      mut as list of data: roots_q1 = symbolicSolveQuadratic(q1, "x")
      println("3. symbolicSolveQuadratic('x ^e 2 - 9 = 0', 'x'): " + roots_q1[1] + ", " + roots_q1[2])

      #L 4. Resolucao de equacao quadratica com raiz dupla
      mut as string: q2 = "x ^e 2 + 2 * x + 1 = 0"
      mut as list of data: roots_q2 = symbolicSolveQuadratic(q2, "x")
      println("4. symbolicSolveQuadratic('x ^e 2 + 2 * x + 1 = 0', 'x'): " + roots_q2[1])

      #L 5. Dispatch generico com symbolicSolve (linear)
      mut as string: g1 = "3 * x - 12 = 0"
      mut as list of data: r_g1 = symbolicSolve(g1, "x")
      println("5. symbolicSolve('3 * x - 12 = 0', 'x'): " + r_g1[1])

      #L 6. Dispatch generico com symbolicSolve (quadratica)
      mut as string: g2 = "x ^e 2 - 4 = 0"
      mut as list of data: r_g2 = symbolicSolve(g2, "x")
      println("6. symbolicSolve('x ^e 2 - 4 = 0', 'x'): " + r_g2[1] + ", " + r_g2[2])

      #L 7. Sistema linear 2x2 analitico
      mut as list of data: eqs = ["x + y = 10", "x - y = 2"]
      mut as list of data: vars = ["x", "y"]
      mut as map: sol = symbolicSolveSystem(eqs, vars)
      println("7. symbolicSolveSystem(['x + y = 10', 'x - y = 2'], ['x', 'y']):")
      println("   x = " + sol["x"])
      println("   y = " + sol["y"])
}
