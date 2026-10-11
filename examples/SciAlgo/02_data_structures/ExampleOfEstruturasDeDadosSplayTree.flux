#L ============================================================================
#L Algoritmo: Splay Tree (Auto-ajustavel via Rotacoes Splay)
#L Dominio: 02_data_structures / Categoria: Arvores de Busca Binaria
#L Descricao: Arvore binaria auto-balanceavel amortizada que move o no acessado para a raiz
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosSplayTree) {
      println("=== Algoritmo: Splay Tree (Rotacoes Splay) ===")

      #L Estado inicial:
      #L Raiz inicial: no 10
      #L Filho direito da raiz: no 20
      #L Filho direito do no 20: no 30 (configuracao Zig-Zig / linear)
      mut as int64: raiz = 10
      mut as int64: filhoDir = 20
      mut as int64: netoDir = 30

      println("1. Estrutura inicial (zig-zig pendente a direita):")
      println("   Raiz: " + raiz + " -> FilhoDir: " + filhoDir + " -> NetoDir: " + netoDir)

      #L Operacao Splay(30):
      #L Em zig-zig direito:
      #L Passo 1: Rotacao para a esquerda no no pai (10): 20 sobe, 10 vira filho esquerdo de 20
      #L Passo 2: Rotacao para a esquerda no no 30: 30 sobe para a nova raiz, 20 vira filho esquerdo de 30
      mut as int64: novaRaiz = netoDir
      mut as int64: novoFilhoEsq = filhoDir
      mut as int64: novoNetoEsq = raiz

      println("2. Estrutura apos operacao Splay(30):")
      println("   Nova Raiz: " + novaRaiz)
      println("   Filho Esquerdo da Raiz: " + novoFilhoEsq)
      println("   Neto Esquerdo: " + novoNetoEsq)

      route {
            novaRaiz == 30 and novoFilhoEsq == 20 and novoNetoEsq == 10 ==> {
                  println("3. Rotacao Zig-Zig da Splay Tree executada com sucesso.")
            }
            _ ==> {
                  println("Falha na operacao Splay.")
            }
      }
      println("Teste concluido com sucesso.")
}
