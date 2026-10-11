#L ============================================================================
#L Algoritmo: Persistent DSU com Rollback
#L Dominio: 02_data_structures / Categoria: Estruturas Disjuntas Persistentes
#L Descricao: Disjoint Set Union com historico de modificacoes e suporte a rollback temporal
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosPersistentDSU) {
      println("=== Algoritmo: Persistent DSU com Rollback ===")

      #L Inicializacao de 4 elementos independentes: pais apontam para si mesmos
      mut as list of int64: parent = [1, 2, 3, 4]
      mut as list of int64: rank = [1, 1, 1, 1]

      #L Pilha de rollback registrando mudancas: guarda (no_modificado, pai_antigo)
      mut as int64: historicoNo = 0
      mut as int64: historicoPaiAntigo = 0

      #L Operacao Union(1, 2): no 2 passa a ter pai 1
      historicoNo = 2
      historicoPaiAntigo = parent[2]
      parent[2] = 1

      println("1. Apos Union(1, 2): Pai do no 2 e " + parent[2])

      #L Verificacao de conectividade: Find(1) == Find(2)
      mut as int64: conectado12 = 0
      route {
            parent[2] == parent[1] ==> {
                  conectado12 = 1
            }
            _ ==> {}
      }
      println("2. Elementos 1 e 2 no mesmo conjunto: " + conectado12)

      #L Operacao Rollback: desfaz a ultima uniao restaurando o estado anterior
      parent[historicoNo] = historicoPaiAntigo
      println("3. Rollback executado: Pai do no 2 restaurado para " + parent[2])

      #L Verificacao pos-rollback: 1 e 2 nao estao mais conectados
      mut as int64: desconectadoAposRollback = 0
      route {
            parent[2] == 2 and parent[1] == 1 ==> {
                  desconectadoAposRollback = 1
            }
            _ ==> {}
      }
      println("4. Elementos 1 e 2 desconectados com sucesso: " + desconectadoAposRollback)

      route {
            conectado12 == 1 and desconectadoAposRollback == 1 ==> {
                  println("5. DSU com persistencia parcial e rollback validado com exatidao.")
            }
            _ ==> {
                  println("Falha no rollback DSU.")
            }
      }
      println("Teste concluido com sucesso.")
}
