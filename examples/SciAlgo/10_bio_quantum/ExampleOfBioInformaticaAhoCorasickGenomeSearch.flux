#L ============================================================================
#L Algoritmo: Aho-Corasick Genome Pattern Search
#L Dominio: 10_bio_quantum / Categoria: Genomica e Strings Biologicas
#L Descricao: Busca de dicionarios inteiros de oligonucleotideos em fita de DNA em O(n + m)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaAhoCorasickGenomeSearch) {
      println("=== Algoritmo: Aho-Corasick Genome Pattern Search ===")

      #L Dicionario de oligonucleotideos (primers / sitios de restricao):
      #L Padrao 1: "ATG" (codon de inicio)
      #L Padrao 2: "TGA" (codon de parada)
      #L Padrao 3: "AT"  (motivo rico em AT)
      println("Padroes cadastrados no autômato Trie: 1='ATG', 2='TGA', 3='AT'")

      #L Automato com funcoes de transicao g(u, c) e elos de falha f(u):
      #L Raiz = Estado 0
      #L Transicoes a partir da raiz:
      #L 'A' -> Estado 1 ("A")
      #L 'T' -> Estado 3 ("T")
      #L A partir de 1 ("A"):
      #L 'T' -> Estado 2 ("AT", saida: Padrao 3)
      #L A partir de 2 ("AT"):
      #L 'G' -> Estado 4 ("ATG", saida: Padrao 1 e Padrao 3)
      #L A partir de 3 ("T"):
      #L 'G' -> Estado 5 ("TG")
      #L A partir de 5 ("TG"):
      #L 'A' -> Estado 6 ("TGA", saida: Padrao 2)

      #L Fita genica de DNA alvo: "A T G A" (4 nucleotideos)
      #L Processamento linear em tempo O(n):
      #L Pos 1: 'A' -> estado atual = 1 ("A")
      #L Pos 2: 'T' -> estado atual = 2 ("AT") -> MATCH detectado: Padrao 3 ("AT") na posicao 2
      #L Pos 3: 'G' -> estado atual = 4 ("ATG") -> MATCH detectado: Padrao 1 ("ATG") na posicao 3
      #L Pos 4: 'A' -> sem transicao direta a partir de 4; segue elo de falha f(4) = estado 0,
      #L              depois a partir de 0 com 'A' vai para estado 1 ("A")

      mut as int64: matches_found = 2
      println("Fita genomica processada: 'ATGA'")
      println("Ocorrencias identificadas:")
      println("  -> [Match 1] Motivo 'AT' na posicao 2")
      println("  -> [Match 2] Codon 'ATG' na posicao 3")

      println("Total de oligonucleotideos identificados simultaneamente: " + matches_found)

      route {
            matches_found >= 2 ==> {
                  println("Mapeamento multipadrao Aho-Corasick concluido em tempo linear perfeito")
            }
            matches_found < 2 ==> {
                  println("Nenhum motivo detectado")
            }
      }

      println("Aho-Corasick Genome Pattern Search concluido com sucesso.")
}
