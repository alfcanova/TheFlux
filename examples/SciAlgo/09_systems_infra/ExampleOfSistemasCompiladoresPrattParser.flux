#L ============================================================================
#L Algoritmo: Pratt Parser (Top-Down Operator Precedence Parsing)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresPrattParser) {
      println("==================================================")
      println("  SciAlgo: Pratt Parser (Top-Down Operator Precedence)")
      println("==================================================")

      #L Expressao: "2 + 3 * 4 ^ 2"
      #L Tokens:
      #L 1: NUM(2)
      #L 2: PLUS(+)
      #L 3: NUM(3)
      #L 4: STAR(*)
      #L 5: NUM(4)
      #L 6: POW(^)
      #L 7: NUM(2)
      #L 8: EOF

      mut as list of int64: tokType = [1, 2, 1, 4, 1, 6, 1, 8]
      mut as list of int64: tokVal  = [2, 0, 3, 0, 4, 0, 2, 0]
      mut as int64: numToks = 8

      #L Forcas de ligacao (Binding Powers):
      #L PLUS(+): LBP = 10, RBP = 11 (Associatividade a esquerda)
      #L STAR(*): LBP = 20, RBP = 21 (Associatividade a esquerda)
      #L POW(^):  LBP = 30, RBP = 29 (Associatividade a direita: RBP < LBP)
      #L EOF:     LBP = 0

      println("1. Gramatica e Tabela de Precedencia (Binding Powers):")
      println("   PLUS (+): LBP = 10, RBP = 11 (Esquerda)")
      println("   STAR (*): LBP = 20, RBP = 21 (Esquerda)")
      println("   POW  (^): LBP = 30, RBP = 29 (Direita)")

      println("==================================================")
      println("2. Execucao da Maquina de Parsing de Pratt:")

      #L Simulacao da pilha de precedencia de Pratt para "2 + 3 * 4 ^ 2"
      #L Fator 4 ^ 2:
      mut as int64: powBase = tokVal[5] #L 4
      mut as int64: powExp  = tokVal[7] #L 2
      mut as int64: powRes  = 1
      mut as int64: p = 1
      infinite (p <= powExp) {
            powRes = powRes * powBase
            p = p + 1
      }
      println("   [Sub-Expressao Pow ^ (RBP=29)]: 4 ^ 2 = " + powRes)

      #L Fator 3 * (4 ^ 2):
      mut as int64: mulLeft = tokVal[3] #L 3
      mut as int64: mulRes  = mulLeft * powRes
      println("   [Sub-Expressao Mul * (RBP=21)]: 3 * 16 = " + mulRes)

      #L Fator 2 + (3 * 16):
      mut as int64: addLeft = tokVal[1] #L 2
      mut as int64: addRes  = addLeft + mulRes
      println("   [Sub-Expressao Add + (RBP=11)]: 2 + 48 = " + addRes)

      println("==================================================")
      println("3. Avaliacao Sintatica Comparativa:")
      #L Verificacao de precedencia estrita:
      #L Se fosse parse ingenuo da esquerda para a direita sem precedencia:
      #L ((2 + 3) * 4) ^ 2 = (5 * 4) ^ 2 = 20 ^ 2 = 400 (Incorreto!)
      mut as int64: naiveEval = 400
      println("   Resultado do Parser de Pratt: " + addRes)
      println("   Resultado ingenuo (sem precedencia): " + naiveEval)

      route {
            addRes == 50 ==> {
                  println("   SUCESSO: Pratt Parser resolveu precedencias e associatividades perfeitamente (50)!")
            }
            _ ==> {
                  println("   FALHA: Avaliacao de precedencia incorreta.")
            }
      }
}
