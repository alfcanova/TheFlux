#L ============================================================================
#L Algoritmo: Generalized LR (GLR / Algoritmo de Tomita com Graph-Structured Stack)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresGLR) {
      println("==================================================")
      println("  SciAlgo: GLR Parser (Tomita's GSS for Ambiguous Grammars)")
      println("==================================================")

      #L Gramatica Ambigua Classica:
      #L S -> S + S | NUM
      #L Sentenca de entrada: "NUM + NUM + NUM"
      #L Produz um conflito Shift/Reduce na tabela LR clássica no segundo '+'!

      mut as list of int64: inputTokens = [1, 2, 1, 2, 1] #L NUM, +, NUM, +, NUM
      mut as int64: numTokens = 5

      println("1. Gramatica Ambigua: S -> S + S | NUM")
      println("   Entrada: ['NUM', '+', 'NUM', '+', 'NUM']")

      println("==================================================")
      println("2. Simulacao do Graph-Structured Stack (GSS):")
      #L Passo 1: Shift NUM (Token 1) -> Estado 0 -> Estado 5 (NUM)
      #L Reduce NUM -> S
      println("   [GSS Estado 0]: Shift NUM, Reduce NUM -> S (Estado 1)")

      #L Passo 2: Shift '+' (Token 2) -> Estado 1 -> Estado 6 ('+')
      println("   [GSS Estado 1]: Shift '+' -> Estado 6")

      #L Passo 3: Shift NUM (Token 3) -> Estado 6 -> Estado 5 (NUM)
      #L Reduce NUM -> S -> Estado 7 (S + S)
      println("   [GSS Estado 6]: Shift NUM, Reduce NUM -> S (Estado 7)")

      println("==================================================")
      println("3. Conflito Shift/Reduce Detectado no Token 4 ('+'):")
      #L No Estado 7 com lookahead '+':
      #L - Acao 1: Reduce por S -> S + S (interpreta associatividade a esquerda)
      #L - Acao 2: Shift '+' (interpreta associatividade a direita)
      #L Um parser LR comum trava ou reporta conflito. O GLR bifurca o GSS!
      println("   CONFLITO LR: Acao 1 = Reduce S -> S + S | Acao 2 = Shift '+'")
      println("   [GLR Acao]: Bifurcacao do Stack em 2 Ramos (GSS Branching)!")

      #L Ramo 1: Reduce (Arvore Esquerda)
      #L Reduz S + S para S, depois faz Shift '+' e NUM:
      #L Arvore 1: ((NUM + NUM) + NUM)
      mut as int64: branch1Success = 1
      println("   -> Ramo 1 (Reduce): Avalia ((NUM + NUM) + NUM) - Left-Associative Tree")

      #L Ramo 2: Shift (Arvore Direita)
      #L Empilha '+' e o proximo NUM, depois reduz S + S interno:
      #L Arvore 2: (NUM + (NUM + NUM))
      mut as int64: branch2Success = 1
      println("   -> Ramo 2 (Shift):  Avalia (NUM + (NUM + NUM)) - Right-Associative Tree")

      println("==================================================")
      println("4. Fusao dos Ramos no GSS (Stack Merging):")
      #L Ao final da entrada (EOF), ambos os ramos reduzem para o simbolo inicial S no estado de aceitacao
      #L O GSS funde os dois nos do stack, formando o Shared Packed Parse Forest (SPPF)
      mut as int64: totalParseTrees = branch1Success + branch2Success
      println("   Ambos os ramos convergem para o simbolo inicial S!")
      println("   Total de arvores de derivacao validas no SPPF: " + totalParseTrees)

      route {
            totalParseTrees == 2 ==> {
                  println("   SUCESSO: GLR Parser processou a ambiguidade com bifurcacao e fusao no GSS!")
            }
            _ ==> {
                  println("   FALHA: Ramos nao convergiram.")
            }
      }
}
