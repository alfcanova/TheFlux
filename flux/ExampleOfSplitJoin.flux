#L Documentacao de Uso: Topologia de Dataflow (split / join)
#L O `split` e o `join` sao operadores focados no roteamento e manipulacao
#L de concorrencia macica de dados (topology manipulation). 

program (ExemplosTopologia) {
      
      #L 1. Roteamento Simples (Bifurcacao e Convergencia)
      #L O operador `split` bifurca os fluxos em vias paralelas.
      #L O operador `join` recolhe e unifica fluxos bifurcados.
      
      mut as list of int64: fluxo = 10 join 20 join 30 join 40
      
      #L Nota: No interpretador, as listas podem ser indexadas (fluxo[1]).
      #L Na maquina WASM atual, listas dinamicas ainda nao suportam a 
      #L instrucao nativa de Index para `print`, mas sao alocadas serialmente!
      
      print("Acessando rotas unificadas do fluxo:")
      fluxo[1] --> print
      fluxo[2] --> print
      fluxo[3] --> print
      fluxo[4] --> print
      
      #L 2. Pipeline Dinamico e Dataflows
      #L Usado massivamente para aplicar pipelines a multiplos elementos.
      #L No interpretador, e executado sequencialmente. 
      #L No backend Rust/C++ nativo (futuro), os splits representarao multi-threading / SIMD.
      
      print("Extracao de rotas do dataflow (split aninhado):")
      mut as list of int64: rotas = 100 split 200 split 300
      rotas[2] --> print
      
      #L 3. Dataflows diretos
      #L Operadores de manipulacao topologica podem ser conectados diretamente:
      #L Abaixo uma simulacao de roteamento que e agregada no final:
      print("Saida de topologia complexa no interpretador:")
      (1 split 2) join (3 split 4) --> print
}
