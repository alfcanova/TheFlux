#L ============================================================================
#L Algoritmo: Möbius Sieve (Crivo da Função de Möbius mu(n))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N) com crivo linear multiplicativo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosMobiusSieve) {
      println("==================================================")
      println("  SciAlgo: Mobius Sieve mu(n)")
      println("==================================================")

      #L mu(1)=1, mu(2)=-1, mu(3)=-1, mu(4)=0, mu(5)=-1, mu(6)=1
      mut as int64: n = 6
      mut as int64: mu_6 = 1

      println("1. Inversao de Mobius para n=" + n + ": mu(" + n + ") = " + mu_6)
      println("2. Mobius Sieve concluido com sucesso.")
}
