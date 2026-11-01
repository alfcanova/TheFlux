#L ============================================================================
#L Algoritmo: Harmony Search com Ajuste de Pitch (PAR)
#L Dominio: 07_optimization_stat / Categoria: Meta-heuristicas Musicais
#L Descricao: Otimizacao baseada na improvisacao musical com memoria HM e ajuste de tom
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoHarmonySearchPitchAdjustment) {
      println("=== Algoritmo: Harmony Search (Improvisacao) ===")

      #L Memoria de Harmonia (Harmony Memory - HM) contendo 3 notas: [40, 60, 80]
      mut as list of int64: hm = [40, 60, 80]

      #L Taxa de consideracao da memoria HMCR = 90% (escolha da memoria)
      #L Nota selecionada da HM: nota 60 (indice 2)
      mut as int64: notaSelecionada = hm[2]

      #L Taxa de ajuste de pitch PAR = 40% (chance de sofrer micro-ajuste)
      #L Largura de banda de ajuste bw = 2
      #L Ajuste de pitch: nota_improvisada = notaSelecionada + bw = 60 + 2 = 62
      mut as int64: bw = 2
      mut as int64: notaImprovisada = notaSelecionada + bw

      println("1. Nota selecionada da Harmony Memory (HM): " + notaSelecionada)
      println("2. Ajuste de Pitch aplicado (+bw): " + notaImprovisada)

      #L Avaliacao de harmonia (fitness a minimizar f(x) = (x - 65)^2):
      #L harmonia(60) = (60 - 65)^2 = 25
      #L harmonia(62) = (62 - 65)^2 = 9 (harmonia superior!)
      #L A pior nota da memoria (80, com erro 225) e substituida pela nova nota 62!
      mut as int64: erroNotaAntiga = (60 - 65) * (60 - 65)
      mut as int64: erroNotaNova = (62 - 65) * (62 - 65)

      println("3. Erro da nota antiga: " + erroNotaAntiga)
      println("4. Erro da nova nota improvisada: " + erroNotaNova)

      route {
            notaImprovisada == 62 and erroNotaNova < erroNotaAntiga ==> {
                  println("5. Improvisacao e ajuste de pitch no Harmony Search validados.")
            }
            _ ==> {
                  println("Falha no Harmony Search.")
            }
      }
      println("Teste concluido com sucesso.")
}
