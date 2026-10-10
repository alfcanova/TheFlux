#L ============================================================================
#L Algoritmo: Chase Algorithm (Lossless Join Decomposition Test)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(F * R^2) aplicacao de regras de dependencia funcional
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosChaseAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Chase Algorithm (Lossless Join Test)")
      println("==================================================")

      #L O algoritmo Chase e a ferramenta classica da teoria de dependencias
      #L em bancos de dados relacionais para testar se uma decomposicao de esquema
      #L e sem perda de informacao (Lossless-Join Decomposition).
      #L
      #L Esquema Universal: R(A, B, C)
      #L Decomposicao D: R1(A, B) e R2(B, C)
      #L Dependencia Funcional (FD): B -> C
      #L
      #L Convencao do Tableau:
      #L Simbolos distintos:   a1 = 1, a2 = 2, a3 = 3
      #L Simbolos indistintos: b13 = 13, b21 = 21

      #L Tableau Inicial:
      #L Linha 1 (R1): [a1, a2, b13] -> [1, 2, 13]
      #L Linha 2 (R2): [b21, a2, a3] -> [21, 2, 3]
      mut as list of int64: tab_row1 = [1, 2, 13]
      mut as list of int64: tab_row2 = [21, 2, 3]

      println("1. Tableau Inicial para R(A, B, C):")
      println("   Linha 1 (R1 = {A, B}): [A: a1, B: a2, C: b13]")
      println("   Linha 2 (R2 = {B, C}): [A: b21, B: a2, C: a3]")
      println("   Dependencia Funcional avaliada: B -> C")

      #L ======================================================================
      #L Aplicacao da Regra de Chase para a FD: B -> C
      #L ======================================================================
      println("==================================================")
      println("2. [Aplicacao da Regra de Equivalencia do Chase]:")
      println("   Verificando atributo determinante B (coluna 2):")
      println("   - Linha 1 possui B = " + tab_row1[2] + " (a2)")
      println("   - Linha 2 possui B = " + tab_row2[2] + " (a2)")
      println("   Como ambas as linhas coincidem em B, devem coincidir em C (coluna 3)!")

      #L No atributo C: Linha 1 tem b13 (13) e Linha 2 tem a3 (3).
      #L O simbolo distinto a3 tem precedencia sobre o indistinto b13.
      route {
            tab_row1[2] == tab_row2[2] ==> {
                  println("   Substituindo b13 em Linha 1 pelo simbolo distinto a3:")
                  tab_row1[3] = tab_row2[3] #L tab_row1[3] passa a ser 3 (a3)
            }
            _ ==> {}
      }

      println("==================================================")
      println("3. Tableau Atualizado Apos o Chase:")
      println("   Linha 1: [A: " + tab_row1[1] + " (a1), B: " + tab_row1[2] + " (a2), C: " + tab_row1[3] + " (a3)]")
      println("   Linha 2: [A: " + tab_row2[1] + " (b21), B: " + tab_row2[2] + " (a2), C: " + tab_row2[3] + " (a3)]")

      #L ======================================================================
      #L Verificacao de Linha de Simbolos Distintos
      #L ======================================================================
      println("==================================================")
      println("4. [Condicao de Juncao Sem Perda (Lossless)]: ")

      mut as int64: is_lossless = 0
      route {
            tab_row1[1] == 1 ==> {
                  route {
                        tab_row1[2] == 2 ==> {
                              route {
                                    tab_row1[3] == 3 ==> {
                                          is_lossless = 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      route {
            is_lossless == 1 ==> {
                  println("   LINHA COMPLETA DE SIMBOLOS 'a' OBTIDA: Linha 1 = [a1, a2, a3]!")
                  println("   TEOREMA PROVADO: A decomposicao {R1(A,B), R2(B,C)} e LOSSLESS sob B -> C!")
            }
            _ ==> {
                  println("   Decomposicao com perda de informacao.")
            }
      }
      println("==================================================")
}
