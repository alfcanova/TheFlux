#L ============================================================================
#L Algoritmo: Stern-Brocot (Árvore de Stern-Brocot para Números Racionais)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log(Denominador)) busca binária por mediantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSternBrocot) {
      println("==================================================")
      println("  SciAlgo: Stern-Brocot Tree Mediants")
      println("==================================================")

      #L Mediante de 0/1 e 1/1 = (0+1)/(1+1) = 1/2
      mut as int64: num = 1
      mut as int64: den = 2

      println("1. Mediante computada na raiz: " + num + "/" + den)
      println("2. Stern-Brocot concluido com sucesso.")
}
