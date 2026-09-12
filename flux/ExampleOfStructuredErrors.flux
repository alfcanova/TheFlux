#L Documentacao de Uso: Tratamento de Erros Estruturados no Esquema Canonico
#L Este exemplo demonstra como TheFlux implementa controle de erros, fallback,
#L recuperacao de falhas e cleanup usando exclusivamente as primitivas canonicas:
#L 1. Emissao estruturada: emit(nice, ...), emit(fail, ...)
#L 2. Despacho e propagacao com o operador ?
#L 3. Inspecao direta de metadados: .sta, .val, .msg
#L 4. Cleanup garantido com ensure { cleanup }

function (dividir) (as int64: dividendo, as int64: divisor) as int64 {
      mut as int64: resultado = (dividendo /i divisor) ? {
            ==> emit(fail, divisor, "divisao por zero")
            ==> emit(nice, resultado, "divisao executada")
      }
}

function (calcularRaiz) (as int64: n) as int64 {
      mut as int64: err_cod = 400
      route {
            n < 0 ==> {
                  emit(fail, err_cod, "radicando negativo nao suportado")
            }
            _ ==> {
                  emit(nice, n, "raiz calculada")
            }
      }
}

function (falhaControlada) () as int64 {
      mut as int64: err_simulado = 101
      mut as int64: r = (0) ensure {
            print("Cleanup interno da funcao executado")
      }
      emit(fail, err_simulado, "falha simulada no subsistema")
}

function (avaliarOperacao) (as int64: a, as int64: b) as int64 {
      (b == 0) ? {
            ==> emit(fail, b, "divisor nulo detectado")
            ==> emit(nice, a, "divisor valido")
      }
}

program (ExampleOfStructuredErrors) {
      print("=== 1. Emissao e Despacho de Falha Estruturada ===")
      mut as int64: r1 = dividir(10, 0)
      print(r1.sta)
      print(r1.val)
      print(r1.msg)

      print("=== 2. Sucesso com Mesma Interface Canonica ===")
      mut as int64: r2 = dividir(10, 2)
      print(r2.sta)
      print(r2.val)
      print(r2.msg)

      print("=== 3. Validacao com Rota e Diagnostico ===")
      mut as int64: r3 = calcularRaiz(-9)
      print(r3.sta)
      print(r3.val)
      print(r3.msg)

      print("=== 4. Cleanup Garantido com ensure ===")
      mut as int64: r4 = falhaControlada()
      print(r4.sta)
      print(r4.val)
      print(r4.msg)

      print("=== 5. Despacho Bifurcado com Operador ? ===")
      mut as int64: res_op = avaliarOperacao(15, 0)
      print(res_op.sta)
      print(res_op.val)
      print(res_op.msg)
}
