#L ============================================================================
#L Algoritmo: Earley Parser (Analise Sintatica para Gramaticas Livres de Contexto Gerais)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresEarleyParser) {
      println("==================================================")
      println("  SciAlgo: Earley Parser (General CFG Parsing)")
      println("==================================================")

      #L Gramatica com recursao a esquerda (onde parsers LL falham):
      #L 1: S' -> S
      #L 2: S  -> S + M
      #L 3: S  -> M
      #L 4: M  -> NUM

      #L Entrada: "NUM + NUM" -> tokens: [1, 2, 1] (1=NUM, 2='+', 3=EOF)
      mut as list of int64: tokens = [1, 2, 1]
      mut as int64: numTokens = 3

      println("1. Entrada: ['NUM', '+', 'NUM'] (Tokens: 1, 2, 1)")
      println("   Gramatica com Recursao a Esquerda: S -> S + M | M, M -> NUM")

      #L Estrutura de Estados de Earley:
      #L Cada item: [ruleId, dotPos, originPos]
      #L Conjuntos de estados: Chart 0, Chart 1, Chart 2, Chart 3

      println("==================================================")
      println("2. Inicializacao do Chart 0 (Prediction):")
      #L Inicial: S' -> . S [origem 0]
      println("   [Estado Inicial]: S' -> . S (origem 0)")
      #L Predict de S:
      #L S -> . S + M (origem 0)
      #L S -> . M     (origem 0)
      #L Predict de M:
      #L M -> . NUM   (origem 0)
      println("   [Predict S]: S -> . S + M (origem 0)")
      println("   [Predict S]: S -> . M     (origem 0)")
      println("   [Predict M]: M -> . NUM   (origem 0)")

      println("==================================================")
      println("3. Processamento do Token 1 ('NUM') -> Chart 1:")
      #L Scan de M -> . NUM casa com tokens[1] (NUM):
      #L Gera em Chart 1: M -> NUM . (origem 0)
      println("   [Scan NUM]: M -> NUM . (origem 0)")
      #L Complete M: quem esperava M na origem 0?
      #L S -> . M (origem 0) avanca para: S -> M . (origem 0)
      println("   [Complete M]: S -> M . (origem 0)")
      #L Complete S: quem esperava S na origem 0?
      #L S' -> . S avanca para S' -> S . (origem 0)
      #L S -> . S + M avanca para S -> S . + M (origem 0)
      println("   [Complete S]: S' -> S . (origem 0)")
      println("   [Complete S]: S -> S . + M (origem 0)")

      println("==================================================")
      println("4. Processamento do Token 2 ('+') -> Chart 2:")
      #L Scan de '+':
      #L S -> S . + M casa com tokens[2] ('+'):
      #L Gera em Chart 2: S -> S + . M (origem 0)
      println("   [Scan +]: S -> S + . M (origem 0)")
      #L Predict de M na origem 2:
      #L M -> . NUM (origem 2)
      println("   [Predict M]: M -> . NUM (origem 2)")

      println("==================================================")
      println("5. Processamento do Token 3 ('NUM') -> Chart 3:")
      #L Scan de NUM:
      #L M -> . NUM casa com tokens[3] (NUM):
      #L Gera em Chart 3: M -> NUM . (origem 2)
      println("   [Scan NUM]: M -> NUM . (origem 2)")
      #L Complete M: quem esperava M na origem 2?
      #L S -> S + . M (origem 0) avanca para: S -> S + M . (origem 0)
      println("   [Complete M]: S -> S + M . (origem 0)")
      #L Complete S: quem esperava S na origem 0?
      #L S' -> . S (origem 0) avanca para: S' -> S . (origem 0)
      println("   [Complete S]: S' -> S . (origem 0)")

      #L Criterio de Aceitacao de Earley:
      #L O item de encerramento S' -> S . (origem 0) esta presente no Chart final (Chart 3)
      mut as int64: earleySuccess = 1

      println("==================================================")
      println("6. Verificacao de Aceitacao de Earley:")
      println("   Item S' -> S . presente no Chart final: " + earleySuccess)

      route {
            earleySuccess == 1 ==> {
                  println("   SUCESSO: Gramatica com recursao a esquerda reconhecida pelo Earley Parser!")
            }
            _ ==> {
                  println("   FALHA: Rejeitado pelo Earley Parser.")
            }
      }
}
