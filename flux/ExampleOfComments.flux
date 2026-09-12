#L Exemplo de Comentarios (#L, #B...B#, #D...D#) na linguagem TheFlux

#D
- Programa: ExampleOfComentarios
- Descricao: Demonstracao completa das 3 formas de comentarios e docstrings estruturadas
- Parametros: Nenhum
- Retorno: Saida padrao com mensagens de teste
- Autor: TheFlux
- Versao: 0.5
D#
program (ExampleOfComentarios) {
      mut as int64: i = 1

      #D
      - Bloco: Contador
      - Descricao: Contar de 1 ate 5 com loop infinite
      - Autor: Andre Luiz Fassone Canova
      D#
      infinite (i <= 5) {
            print("Contador: #{i}")
            i =+ 1
      }

      #B
      Este e um comentario em bloco multi-linha.
      Ele pode conter explicacoes detalhadas, notas de arquitetura
      e nao interfere na analise semantica ou execucao dos backends.
      B#

      #L Comentario de linha simples
      print("Outras chaves sugeridas")
      print("The End")
}
