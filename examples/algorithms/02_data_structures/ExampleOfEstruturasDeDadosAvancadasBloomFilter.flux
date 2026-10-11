#L ============================================================================
#L Algoritmo: Bloom Filter (Filtro Probabilistico de Pertinencia)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas e arvores
#L Complexidade: Insercao O(k) | Consulta O(k) | Espaco O(m)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasBloomFilter) {
      println("==================================================")
      println("  SciAlgo: Bloom Filter (Probabilistic Set Filter)")
      println("==================================================")

      #L Parametros do Bloom Filter:
      #L m = tamanho do vetor de bits (32 bits)
      #L k = numero de funcoes hash independentes (3 funcoes)
      mut as int64: m = 32
      mut as int64: k = 3
      println("1. Inicializando Bloom Filter:")
      println("   - Tamanho do vetor (m): " + m + " bits")
      println("   - Funcoes hash (k): " + k)

      #L Inicializa o vetor de 32 bits zerados (1-based index: 1..32)
      mut as list of int64: bits = [
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
      ]

      #L Conjunto de elementos a inserir
      mut as list of int64: inserted_elements = [10, 25, 42, 73, 99]
      mut as int64: num_inserted = listLength(inserted_elements)

      println("2. Inserindo elementos no Bloom Filter...")
      mut as int64: idx = 1
      infinite (idx <= num_inserted) {
            mut as int64: elem = inserted_elements[idx]

            #L Calculo das k=3 funcoes hash para o elemento:
            #L h1(x) = ((x * 31 + 17) % m) + 1
            #L h2(x) = ((x * 79 + 43) % m) + 1
            #L h3(x) = ((x * 151 + 89) % m) + 1
            mut as int64: h1 = (((elem * 31) + 17) /r m) + 1
            mut as int64: h2 = (((elem * 79) + 43) /r m) + 1
            mut as int64: h3 = (((elem * 151) + 89) /r m) + 1

            bits[h1] = 1
            bits[h2] = 1
            bits[h3] = 1

            println("   -> Inserido " + elem + " (posicoes: " + h1 + ", " + h2 + ", " + h3 + ")")
            idx = idx + 1
      }

      #L Contagem de bits ativos
      mut as int64: set_bits = 0
      mut as int64: bi = 1
      infinite (bi <= m) {
            route {
                  bits[bi] == 1 ==> {
                        set_bits = set_bits + 1
                  }
                  _ ==> {}
            }
            bi = bi + 1
      }
      println("3. Estado do vetor de bits apos insercoes:")
      println("   - Total de bits em 1: " + set_bits + " / " + m)

      #L 4. Consultas de Pertinencia
      println("4. Realizando testes de pertinencia (membership test):")
      mut as list of int64: test_queries = [10, 25, 42, 73, 99, 15, 33, 50, 88, 105]
      mut as int64: num_queries = listLength(test_queries)

      mut as int64: qi = 1
      mut as int64: true_positives = 0
      mut as int64: true_negatives = 0
      mut as int64: false_positives = 0
      mut as int64: false_negatives = 0

      infinite (qi <= num_queries) {
            mut as int64: q = test_queries[qi]

            mut as int64: q_h1 = (((q * 31) + 17) /r m) + 1
            mut as int64: q_h2 = (((q * 79) + 43) /r m) + 1
            mut as int64: q_h3 = (((q * 151) + 89) /r m) + 1

            mut as bool: in_filter = false
            route {
                  bits[q_h1] == 1 && bits[q_h2] == 1 && bits[q_h3] == 1 ==> {
                        in_filter = true
                  }
                  _ ==> {
                        in_filter = false
                  }
            }

            #L Verifica se realmente pertencia ao conjunto inserido
            mut as bool: actually_inserted = false
            mut as int64: ci = 1
            infinite (ci <= num_inserted) {
                  route {
                        inserted_elements[ci] == q ==> {
                              actually_inserted = true
                        }
                        _ ==> {}
                  }
                  ci = ci + 1
            }

            route {
                  in_filter ==> {
                        route {
                              actually_inserted ==> {
                                    true_positives = true_positives + 1
                                    println("   [PASS] Chave " + q + ": Possivelmente no conjunto (Verdadeiro Positivo)")
                              }
                              _ ==> {
                                    false_positives = false_positives + 1
                                    println("   [ALERTA] Chave " + q + ": Possivelmente no conjunto (Falso Positivo)")
                              }
                        }
                  }
                  _ ==> {
                        route {
                              actually_inserted ==> {
                                    false_negatives = false_negatives + 1
                                    println("   [ERRO] Chave " + q + ": Falso Negativo (Violacao de invariante!)")
                              }
                              _ ==> {
                                    true_negatives = true_negatives + 1
                                    println("   [PASS] Chave " + q + ": Definitivamente NAO esta no conjunto (Verdadeiro Negativo)")
                              }
                        }
                  }
            }

            qi = qi + 1
      }

      println("5. Estatisticas do Filtro:")
      println("   - Verdadeiros Positivos: " + true_positives)
      println("   - Verdadeiros Negativos: " + true_negatives)
      println("   - Falsos Positivos: " + false_positives)
      println("   - Falsos Negativos: " + false_negatives + " (invariante: deve ser 0)")

      println("==================================================")
      println("Bloom Filter executado com sucesso!")
}
