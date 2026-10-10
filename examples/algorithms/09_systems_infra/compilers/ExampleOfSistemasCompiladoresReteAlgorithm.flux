#L ============================================================================
#L Algoritmo: Algoritmo Rete (Rede de Casamento de Padroes Alfa e Beta)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresReteAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Rete Pattern Matching Algorithm")
      println("==================================================")

      #L Elementos da Memoria de Trabalho (Working Memory Elements - WMEs):
      #L Clientes: (id, status) onde status 1=Gold, 2=Silver
      #L WME 1: Cliente 101, status 1 (Gold)
      #L WME 2: Cliente 102, status 2 (Silver)
      #L WME 3: Cliente 103, status 1 (Gold)

      mut as list of int64: custId   = [101, 102, 103]
      mut as list of int64: custStat = [1, 2, 1]
      mut as int64: numCusts = 3

      #L Pedidos: (orderId, customerId, total)
      #L WME 4: Pedido 501, Cliente 101, Total 1200
      #L WME 5: Pedido 502, Cliente 102, Total 1500
      #L WME 6: Pedido 503, Cliente 101, Total 300
      #L WME 7: Pedido 504, Cliente 103, Total 2000

      mut as list of int64: orderId     = [501, 502, 503, 504]
      mut as list of int64: orderCustId = [101, 102, 101, 103]
      mut as list of int64: orderTotal  = [1200, 1500, 300, 2000]
      mut as int64: numOrders = 4

      #L Regra de Producao: "PedidoGoldEspecial"
      #L Condicao 1: Cliente.status == 1 (Gold)
      #L Condicao 2: Pedido.total >= 1000 E Pedido.customerId == Cliente.id

      println("1. Rede Alfa (Filtros de 1 Entrada):")

      #L Memoria Alfa 1: Clientes Gold
      mut as list of int64: alphaMemCust = [0, 0, 0]
      mut as int64: alphaCustCount = 0

      mut as int64: c = 1
      infinite (c <= numCusts) {
            route {
                  custStat[c] == 1 ==> {
                        alphaCustCount = alphaCustCount + 1
                        alphaMemCust[alphaCustCount] = custId[c]
                        println("   [No Alfa Cliente Gold]: Cliente " + custId[c] + " ativado")
                  }
                  _ ==> {}
            }
            c = c + 1
      }

      #L Memoria Alfa 2: Pedidos com Total >= 1000
      mut as list of int64: alphaMemOrderId = [0, 0, 0, 0]
      mut as list of int64: alphaMemOrderCust = [0, 0, 0, 0]
      mut as int64: alphaOrderCount = 0

      mut as int64: o = 1
      infinite (o <= numOrders) {
            route {
                  orderTotal[o] >= 1000 ==> {
                        alphaOrderCount = alphaOrderCount + 1
                        alphaMemOrderId[alphaOrderCount] = orderId[o]
                        alphaMemOrderCust[alphaOrderCount] = orderCustId[o]
                        println("   [No Alfa Pedido Alto Valor]: Pedido " + orderId[o] + " (Cliente " + orderCustId[o] + ", Total " + orderTotal[o] + ")")
                  }
                  _ ==> {}
            }
            o = o + 1
      }

      println("==================================================")
      println("2. Rede Beta (Juncao de 2 Entradas - Join Nodes):")

      #L Juncao entre Memoria Alfa 1 e Memoria Alfa 2 onde Cliente.id == Pedido.customerId
      mut as list of int64: matchCustId  = [0, 0, 0, 0]
      mut as list of int64: matchOrderId = [0, 0, 0, 0]
      mut as int64: matchCount = 0

      mut as int64: i = 1
      infinite (i <= alphaCustCount) {
            mut as int64: currentGoldCust = alphaMemCust[i]

            mut as int64: j = 1
            infinite (j <= alphaOrderCount) {
                  route {
                        alphaMemOrderCust[j] == currentGoldCust ==> {
                              matchCount = matchCount + 1
                              matchCustId[matchCount] = currentGoldCust
                              matchOrderId[matchCount] = alphaMemOrderId[j]
                              println("   [No Beta Juncao]: Match (Cliente " + currentGoldCust + ", Pedido " + alphaMemOrderId[j] + ")")
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("==================================================")
      println("3. Ativacao do No Terminal (Regras Disparadas):")
      println("   Total de ativacoes da regra 'PedidoGoldEspecial': " + matchCount)

      #L Esperamos exatamente 2 matches: (Cliente 101, Pedido 501) e (Cliente 103, Pedido 504)
      mut as int64: validRete = 0
      route {
            matchCount == 2 and matchCustId[1] == 101 and matchOrderId[1] == 501 and matchCustId[2] == 103 and matchOrderId[2] == 504 ==> {
                  validRete = 1
            }
            _ ==> {}
      }

      route {
            validRete == 1 ==> {
                  println("   SUCESSO: Algoritmo Rete executou casamentos alfa e beta com perfeicao!")
            }
            _ ==> {
                  println("   FALHA: Divergencia na rede Rete.")
            }
      }
}
