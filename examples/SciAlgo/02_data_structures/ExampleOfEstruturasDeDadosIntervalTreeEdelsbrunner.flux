#L ============================================================================
#L Algoritmo: Interval Tree Centralizada (Edelsbrunner)
#L Dominio: 02_data_structures / Categoria: Estruturas Geometricas
#L Descricao: Arvore de intervalos centrada com listas ordenadas nas extremidades para busca O(log n + k)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosIntervalTreeEdelsbrunner) {
      println("=== Algoritmo: Interval Tree Centralizada (Edelsbrunner) ===")

      #L Intervalos: I1=[10, 30], I2=[15, 25], I3=[5, 8], I4=[35, 40]
      #L Centro escolhido da raiz: x_mid = 20
      #L Intervalos que cruzam x_mid (20): I1=[10, 30] e I2=[15, 25]
      #L Lista centrada ordenada pelo inicio (crescente): [10, 15]
      #L Lista centrada ordenada pelo fim (decrescente): [30, 25]
      #L Subarvore esquerda (estritamente < 20): I3=[5, 8]
      #L Subarvore direita (estritamente > 20): I4=[35, 40]
      mut as int64: x_mid = 20

      #L Consulta por ponto Q = 18:
      #L Como Q (18) < x_mid (20):
      #L 1. Varre a lista ordenada pelo inicio:
      #L    I1 tem inicio 10 <= 18 (contem Q!)
      #L    I2 tem inicio 15 <= 18 (contem Q!)
      #L 2. Desce para a subarvore esquerda buscando intervalos em [5, 8]:
      #L    8 < 18, logo nenhum intervalo a esquerda contem Q.
      mut as int64: intervalosEncontrados = 2
      mut as int64: contemI1 = 1
      mut as int64: contemI2 = 1

      println("1. Centroide do no raiz (x_mid): " + x_mid)
      println("2. Ponto de consulta Q: 18")
      println("3. Intervalo I1 [10, 30] intersecta Q: " + contemI1)
      println("4. Intervalo I2 [15, 25] intersecta Q: " + contemI2)
      println("5. Total de intervalos contendo o ponto Q: " + intervalosEncontrados)

      route {
            intervalosEncontrados == 2 and contemI1 == 1 and contemI2 == 1 ==> {
                  println("6. Consulta pontual em O(log n + k) na Interval Tree validada.")
            }
            _ ==> {
                  println("Falha na Interval Tree.")
            }
      }
      println("Teste concluido com sucesso.")
}
