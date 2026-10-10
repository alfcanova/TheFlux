#L ============================================================================
#L Algoritmo: Persistent Data Structures (Pilha e Array Persistente com Versoes)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: O(1) tempo e espaco por versao | Zero mutacao destrutiva
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasPersistentDataStructures) {
      println("==================================================")
      println("  SciAlgo: Persistent Data Structures (Versoes)")
      println("==================================================")

      #L 1. Pilha Totalmente Persistente (Fully Persistent Stack)
      #L Pool de nos imutaveis (1-based, 0 = NULL)
      mut as list of int64: node_val = [0]
      mut as list of int64: node_prev = [0]

      #L Tabela de raizes por versao: version_root[v]
      #L Versao 0: Pilha vazia (root = 0)
      mut as list of int64: v_roots = [0]

      #L Versao 1: push(V0, 10)
      node_val = listPushBack(node_val, 10)
      node_prev = listPushBack(node_prev, 0)
      v_roots = listPushBack(v_roots, 1)

      #L Versao 2: push(V1, 20)
      node_val = listPushBack(node_val, 20)
      node_prev = listPushBack(node_prev, 1)
      v_roots = listPushBack(v_roots, 2)

      #L Versao 3: push(V2, 30)
      node_val = listPushBack(node_val, 30)
      node_prev = listPushBack(node_prev, 2)
      v_roots = listPushBack(v_roots, 3)

      #L Versao 4: pop(V3) -> aponta para o prev de V3 (no 2)
      v_roots = listPushBack(v_roots, node_prev[3])

      #L Versao 5: bifurcacao a partir de V2: push(V2, 99)
      node_val = listPushBack(node_val, 99)
      node_prev = listPushBack(node_prev, 2)
      v_roots = listPushBack(v_roots, 4)

      println("1. Arvore de versoes da Pilha Persistente criada:")

      #L Reconstroi conteudo de cada versao navegando pelos ponteiros prev
      mut as int64: v = 1
      infinite (v <= 5) {
            #L Versao v esta no indice v + 1 do vetor v_roots
            mut as int64: cur_node = v_roots[v + 1]
            mut as list of int64: stack_elems = []
            infinite (cur_node != 0) {
                  stack_elems = listPushBack(stack_elems, node_val[cur_node])
                  cur_node = node_prev[cur_node]
            }
            println("   Versao " + v + " (Topo = " + node_val[v_roots[v + 1]] + "): " + stack_elems)
            v = v + 1
      }

      #L 2. Vetor Persistente por Copia-em-Escrita (Persistent Array)
      mut as list of int64: arr_v0 = [100, 200, 300, 400]
      mut as list of int64: arr_v1 = listClone(arr_v0)
      arr_v1[2] = 250

      mut as list of int64: arr_v2 = listClone(arr_v1)
      arr_v2[4] = 999

      println("2. Vetor Persistente com bifurcacao de estados:")
      println("   Array V0 original (imutavel): " + arr_v0)
      println("   Array V1 (modificou pos 2):   " + arr_v1)
      println("   Array V2 (modificou pos 4):   " + arr_v2)

      mut as bool: ok_p = (arr_v0[2] == 200) and (arr_v1[2] == 250) and (arr_v2[4] == 999)
      println("3. Verificacao de integridade das versoes: " + ok_p)
      println("Concluido com Sucesso")
}

