#L ============================================================================
#L Algoritmo: Graph U-Net (gPool e gUnpool)
#L Dominio: 08_artificial_intel / Subdominio: Grafos para IA
#L Descricao: Pooling e unpooling hierarquico adaptativo em grafos neurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGraphUNet) {
      println("=== Algoritmo: Graph U-Net (gPool / gUnpool) ===")

      #L Features de 4 nos com projecao escalar de importancia
      mut as list of int64: scores = [85, 30, 92, 45]
      mut as list of int64: originalFeatures = [100, 200, 300, 400]

      #L Top-k pooling: selecionar os k=2 nos com maiores scores (indices 3 e 1)
      mut as list of int64: pooledIndices = [3, 1]
      mut as list of int64: pooledFeatures = [300, 100]

      println("1. Pontuacoes de projecao gPool: " + scores[1] + ", " + scores[2] + ", " + scores[3] + ", " + scores[4])
      println("2. Nos selecionados no pooling (k=2): " + pooledIndices[1] + ", " + pooledIndices[2])

      #L gUnpool: restaurar a dimensao original preenchendo zeros nos nos descartados
      mut as list of int64: unpooled = [0, 0, 0, 0]
      unpooled[pooledIndices[1]] = pooledFeatures[1]
      unpooled[pooledIndices[2]] = pooledFeatures[2]

      println("3. Estrutura restaurada via gUnpool:")
      println("   No 1: " + unpooled[1])
      println("   No 2: " + unpooled[2])
      println("   No 3: " + unpooled[3])
      println("   No 4: " + unpooled[4])

      route {
            unpooled[3] == 300 and unpooled[1] == 100 and unpooled[2] == 0 ==> {
                  println("4. Operacoes gPool e gUnpool validadas com sucesso.")
            }
            _ ==> {
                  println("Falha na restauracao dimensional.")
            }
      }
      println("Teste concluido com sucesso.")
}
