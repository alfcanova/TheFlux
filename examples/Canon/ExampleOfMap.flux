program (ExampleOfMap) {
      println("==================================================")
      println("  TheFlux - Exemplo de Primitivas Nativas de Map")
      println("  (Sem bibliotecas stdlib, apenas backend basico)")
      println("==================================================")

      println("\n=== 1. Inicializacao e Literais de Map ===")
      mut as map: vazio = map{}
      println("Mapa vazio: " + vazio)

      mut as map: metricas = map{"threads": 8, "batch": 32}
      println("Metricas iniciais: " + metricas)

      mut as map: codigos = map{.1 of uint8: "Norte" of string, .2 of uint8: "Sul" of string}
      println("Chaves tipadas (.1 => Norte): " + codigos["1"])
      println("Chaves tipadas (.2 => Sul): " + codigos["2"])

      mut as map: config = map{"nome": "TheFlux", "versao": 1, "ativo": true, "taxa": 99.5}
      println("Registro heterogeneo: " + config)

      println("\n=== 2. Acesso Indexado, Leitura e Mutacao ===")
      println("Leitura direta metricas[\"threads\"]: " + metricas["threads"])
      println("Chave inexistente (retorna none): " + metricas["ausente"])

      metricas["threads"] = 16
      metricas["batch"] = 64
      metricas["timeout"] = 300
      println("Apos mutacao e insercao: " + metricas)

      println("\n=== 3. Operador de Pertencimento in ===")
      println("\"threads\" in metricas: " + ("threads" in metricas))
      println("\"inexistente\" in metricas: " + ("inexistente" in metricas))

      println("\n=== 4. Iteracao Nativa com infinite (k in m) ===")
      infinite (k in metricas) {
            println("  Par -> Chave: " + k + " | Valor: " + metricas[k])
      }

      println("\n=== 5. Controle de Fluxo e Busca Manual com route/break ===")
      mut as bool: encontrou_batch = false
      infinite (k in metricas) {
            route {
                  k == "batch" ==> {
                        encontrou_batch = true
                        break
                  }
            }
      }
      println("Encontrou chave \"batch\"? " + encontrou_batch)

      println("\n=== 6. Mapas Compostos com Listas e Sub-Mapas ===")
      mut as map: usuario = map{
            "id": 101,
            "perfil": map{"cargo": "Engenheiro", "nivel": "Senior"},
            "habilidades": ["TheFlux", "Compiladores", "VM"]
      }
      println("Usuario completo: " + usuario)
      println("Cargo interno: " + (usuario["perfil"] as map)["cargo"])
      println("Primeira habilidade (1-indexed): " + (usuario["habilidades"] as list of data)[1])
}
