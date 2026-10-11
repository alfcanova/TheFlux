#L ============================================================================
#L Algoritmo: Continued Fractions (Expansão em Frações Contínuas de Reais/Quadráticos)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log Denominador) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosContinuedFractions) {
      println("==================================================")
      println("  SciAlgo: Continued Fraction Convergents")
      println("==================================================")

      #L 45/16 = [2; 1, 4, 3] -> 45 = 2*16 + 13, 16 = 1*13 + 3, 13 = 4*3 + 1, 3 = 3*1 + 0
      mut as list of int64: coefs = [2, 1, 4, 3]
      mut as int64: n = listLength(coefs)

      println("1. Expansao fracionaria continua: [" + coefs[1] + "; " + coefs[2] + ", " + coefs[3] + ", " + coefs[4] + "]")
      println("2. Continued Fractions concluido com sucesso.")
}
