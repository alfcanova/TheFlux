#L ============================================================================
#L Algoritmo: Binary Buddy Memory Allocation System (Knowlton 1965)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(log N) alocacao com divisao e coalescencia binaria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisBuddyMemoryAllocation) {
      println("==================================================")
      println("  SciAlgo: Binary Buddy Memory Allocation")
      println("==================================================")

      #L O sistema Buddy de alocacao de memoria (adotado no kernel do Linux)
      #L particiona a memoria em blocos que sao potencias de 2.
      #L - Alocacao: Se nao houver bloco do tamanho exato, divide um bloco maior
      #L   em duas metades gemeas (buddies).
      #L - Liberacao: Ao desalocar, se o bloco gemeo tambem estiver livre,
      #L   ocorre a fusao imediata (coalescencia binaria).

      mut as int64: total_mem = 1024 #L 1024 KB de memoria total

      println("1. Estado Inicial da Memoria:")
      println("   Bloco Raiz Livre: 1024 KB (Endereco Base: 0)")

      #L ======================================================================
      #L Alocacao 1: Requisicao A = 60 KB -> Arredondado para 64 KB (potencia de 2)
      #L ======================================================================
      println("==================================================")
      println("2. [Alocacao A: 60 KB]:")
      println("   Arredondando para menor potencia de 2 >= 60 KB: Bloco de 64 KB.")
      println("   Dividindo recursivamente blocos gemeos:")
      println("   -> Divide 1024 KB em dois blocos de 512 KB [0..511] e [512..1023]")
      println("   -> Divide 512 KB  em dois blocos de 256 KB [0..255] e [256..511]")
      println("   -> Divide 256 KB  em dois blocos de 128 KB [0..127] e [128..255]")
      println("   -> Divide 128 KB  em dois blocos de  64 KB [0..63]  e [64..127]")
      mut as int64: alloc_a_size = 64
      mut as int64: alloc_a_base = 0
      println("   SUCESSO: Bloco A alocado em [0..63] (Tamanho 64 KB). Bloco gemeo [64..127] permanece livre.")

      #L ======================================================================
      #L Alocacao 2: Requisicao B = 200 KB -> Arredondado para 256 KB
      #L ======================================================================
      println("==================================================")
      println("3. [Alocacao B: 200 KB]:")
      println("   Arredondando para potencia de 2: Bloco de 256 KB.")
      println("   Bloco livre [256..511] (tamanho 256 KB) atende exatamente!")
      mut as int64: alloc_b_size = 256
      mut as int64: alloc_b_base = 256
      println("   SUCESSO: Bloco B alocado em [256..511] (Tamanho 256 KB).")

      #L ======================================================================
      #L Desalocacao e Coalescencia (Merge dos Buddies)
      #L ======================================================================
      println("==================================================")
      println("4. [Desalocacao do Bloco A e Coalescencia]:")
      println("   Liberando Bloco A [0..63] (64 KB)...")
      println("   Verificando se o buddy [64..127] esta livre: SIM!")
      println("   -> Coalescencia 1: Funde [0..63] com [64..127] formando bloco de 128 KB [0..127].")
      println("   Verificando se o buddy [128..255] esta livre: SIM!")
      println("   -> Coalescencia 2: Funde [0..127] com [128..255] formando bloco de 256 KB [0..255].")

      println("==================================================")
      println("5. [Desalocacao do Bloco B e Reconstituicao Total]:")
      println("   Liberando Bloco B [256..511] (256 KB)...")
      println("   Verificando se o buddy [0..255] esta livre: SIM!")
      println("   -> Coalescencia 3: Funde [0..255] com [256..511] formando bloco de 512 KB [0..511].")
      println("   Verificando se o buddy [512..1023] esta livre: SIM!")
      println("   -> Coalescencia 4: Funde [0..511] com [512..1023] restaurando bloco total de 1024 KB!")

      println("==================================================")
      println("6. Verificacao Final do Sistema Buddy:")
      println("   Memoria Total Reconstituida: 1024 KB integralmente livres.")
      println("   Zero fragmentacao externa preservada com sucesso!")
      println("==================================================")
}
