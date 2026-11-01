use SymbolicStdLib

program (ExampleOfUseSymbolicStdLib_SymbolicCalculusContract) {
      println("==================================================")
      println("  Exemplo: SymbolicCalculusContract (Fase 2)")
      println("==================================================")

      mut as string: f = "t ^e 3 - 6 * t ^e 2 + 9 * t"
      println("1. symbolicDifferentiate('t ^e 3 - 6 * t ^e 2 + 9 * t', 't'): " + SymbolicStdLib.symbolicDifferentiate(f, "t"))
      println("2. symbolicDifferentiate('4 * x ^e 3 + 2 * x + 1', 'x'): " + SymbolicStdLib.symbolicDifferentiate("4 * x ^e 3 + 2 * x + 1", "x"))
      println("3. symbolicDiffN('t ^e 3 - 6 * t ^e 2 + 9 * t', 't', 2): " + SymbolicStdLib.symbolicDiffN(f, "t", 2))
      println("4. symbolicDiffN('t ^e 3 - 6 * t ^e 2 + 9 * t', 't', 3): " + SymbolicStdLib.symbolicDiffN(f, "t", 3))
      println("5. symbolicIntegrate('6 * t - 12', 't'): " + SymbolicStdLib.symbolicIntegrate("6 * t - 12", "t"))
      println("6. symbolicIntegrate('2 * x', 'x'): " + SymbolicStdLib.symbolicIntegrate("2 * x", "x"))
      println("7. symbolicDefiniteIntegrate('3 * x ^e 2', 'x', 0.0, 2.0): " + SymbolicStdLib.symbolicDefiniteIntegrate("3 * x ^e 2", "x", 0.0, 2.0))
      println("8. symbolicTaylorSeries('x ^e 3 + 2 * x ^e 2 + x + 1', 'x', 0.0, 2): " + SymbolicStdLib.symbolicTaylorSeries("x ^e 3 + 2 * x ^e 2 + x + 1", "x", 0.0, 2))
      println("9. symbolicLimit('(x ^e 2 - 1) / (x - 1)', 'x', 1.0, 'both'): " + SymbolicStdLib.symbolicLimit("(x ^e 2 - 1) / (x - 1)", "x", 1.0, "both"))
}
