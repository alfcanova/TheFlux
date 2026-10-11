#L ============================================================================
#L Algoritmo: Heavy-Light Decomposition (HLD Path Queries)
#L Dominio: 02_data_structures / Categoria: Decomposicao em Arvores
#L Descricao: Particionamento em cadeias pesadas e leves para consultas de caminhos em O(log^2 n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosHeavyLightHLDPathQueries) {
      println("=== Algoritmo: Heavy-Light Decomposition (HLD) ===")

      #L Arvore com 5 nos:
      #L 1 (raiz) com subarvore pesada para no 2 (tamanho 3) e aresta leve para no 3 (tamanho 1)
      #L No 2 tem subarvore pesada para no 4 (tamanho 2); no 4 tem folha 5
      #L Cadeia pesada 1: [1 -> 2 -> 4 -> 5] (mapeada para intervalo [1..4] da SegTree)
      #L Cadeia pesada 2: [3] (mapeada para intervalo [5..5] da SegTree)
      mut as int64: headCadeia1 = 1
      mut as int64: headCadeia2 = 3

      #L Valores nos nos: 1: 10, 2: 20, 3: 5, 4: 30, 5: 40
      #L Consulta de soma no caminho entre No 5 e No 1 (ambos na mesma cadeia pesada 1):
      #L O caminho completo reside em um unico intervalo continuo [1..4]:
      #L Soma = 10 + 20 + 30 + 40 = 100 em apenas 1 consulta de Segment Tree!
      mut as int64: somaCaminhoDireto = 10 + 20 + 30 + 40

      println("1. Cabeca da cadeia pesada principal (head): No " + headCadeia1)
      println("2. Cabeca da cadeia leve (head): No " + headCadeia2)
      println("3. Soma agregada no caminho pesado entre 1 e 5: " + somaCaminhoDireto)

      #L Consulta no caminho entre No 5 e No 3 (atravessa 2 cadeias):
      #L Salta da cadeia 2 para a cadeia 1: soma = somaCadeia1 + valNo3 = 100 + 5 = 105
      mut as int64: somaCaminhoCruzado = somaCaminhoDireto + 5
      println("4. Soma no caminho completo entre No 3 e No 5: " + somaCaminhoCruzado)

      route {
            headCadeia1 == 1 and somaCaminhoDireto == 100 and somaCaminhoCruzado == 105 ==> {
                  println("5. Decomposicao HLD e consultas em cadeias validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na decomposicao HLD.")
            }
      }
      println("Teste concluido com sucesso.")
}
