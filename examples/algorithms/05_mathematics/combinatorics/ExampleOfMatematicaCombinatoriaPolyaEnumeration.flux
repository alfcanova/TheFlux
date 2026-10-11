#L ============================================================================
#L Algoritmo: Pólya Enumeration Theorem (Contagem com Índices de Ciclos)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(|G|) avaliacao do polinomio de ciclos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaPolyaEnumeration) {
      println("==================================================")
      println("  SciAlgo: Polya Enumeration Theorem")
      println("==================================================")

      mut as int64: cores = 2
      #L Indice de ciclo para triangulo D3 (6 simetrias): (x1^3 + 3*x1*x2 + 2*x3) / 6
      mut as int64: soma_ciclos = (cores * cores * cores) + (3 * cores * cores) + (2 * cores)
      mut as int64: configuracoes = soma_ciclos /i 6

      println("1. Cores disponiveis: " + cores)
      println("2. Padroes unicos enumerados via Polya: " + configuracoes)
      println("3. Polya Enumeration concluido com sucesso.")
}
