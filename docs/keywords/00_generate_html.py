"""Generate a single HTML page from all KW_*.yaml documentation files.
Supports --lang pt (Portuguese, default) and --lang en (English).
"""
import os
import sys
import glob
import yaml
import json
import argparse

DOCS_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT_FILE_EN = os.path.join(DOCS_DIR, "theflux_docs_en.html")
OUTPUT_FILE_PT = os.path.join(DOCS_DIR, "theflux_docs.html")

# ── English examples ───────────────────────────────────────────────
EXAMPLES_EN = [
    {
        "id": "hello_world",
        "title": "Hello World",
        "desc": "Minimal program that prints a message to stdout. Introduces program, print, and #L comments.",
        "tags": ["keyword"],
        "code": '''#L Classic Hello World example in TheFlux

program (HelloWorld) {
      print("Hello, TheFlux!")
}'''
    },
    {
        "id": "fibonacci",
        "title": "Recursive Fibonacci",
        "desc": "Recursive function computing the Fibonacci sequence. Demonstrates function, route with subject, emit, infinite loops, and arithmetic operators.",
        "tags": ["keyword", "operator"],
        "code": '''function fibonacci(n: int64): int64 {
      route (n) {
            <= 1 --> {
                  emit(nice, n, "base")
            }
            _ --> {
                  emit(nice, fibonacci(n - 1) + fibonacci(n - 2), "recursive")
            }
      }
}

program (ExampleOfFibonacci) {
      infinite (pos in 1 .. 10) {
            print("Fibonacci pos " + pos + " = " + fibonacci(pos))
      }
}'''
    },
    {
        "id": "route_idade",
        "title": "Age Classification (route)",
        "desc": "Multi-branch conditional using route with a subject. Demonstrates comparison operators, integer literals, and the catch-all _ branch.",
        "tags": ["keyword", "operator"],
        "code": '''program (ClassifyAge) {
      mut as int64: age= 25

      route (age) {
            < 0 --> {
                  print("Error: negative age invalid")
            }
            < 12 --> {
                  print("Child")
            }
            < 18 --> {
                  print("Teenager")
            }
            < 60 --> {
                  print("Adult")
            }
            < 120 --> {
                  print("Senior")
            }
            _ --> {
                  print("Error: age out of valid range")
            }
      }
}'''
    },
    {
        "id": "enum_match",
        "title": "Enum with Match",
        "desc": "Discriminated enum (Result) with typed variants and pattern matching via match. Demonstrates Enum, match, ::, and string interpolation.",
        "tags": ["keyword", "type"],
        "code": '''enum (Result) {
      Ok(value: int64)
      Error(msg: string)
}

program (EnumMatchExample) {
      mut as Result: answer= Result::Ok(.value: 41)
      mut as Result: failure= Result::Error(.msg: "failed")

      print(match answer {
            Result::Ok(.value: val) ==> "Success: #{val}"
            Result::Error(.msg: m) ==> "Failure: #{m}"
      })

      print(match failure {
            Result::Ok(.value: val) ==> val
            Result::Error(.msg: m) ==> m
      })
}'''
    },
    {
        "id": "calculator_agent",
        "title": "Calculator with Agent and Contract",
        "desc": ".fdsl file declaring a contract and an agent implementing 5 arithmetic operations. Demonstrates contract, agent, impl, op, emit, and integer types.",
        "tags": ["keyword"],
        "code": '''#L File: CalculatorAgent.fdsl
contract (BasicOperations) {
      op add(a: int64, b: int64): int64
      op subtract(a: int64, b: int64): int64
      op integerDivide(a: int64, b: int64): int64
      op remainder(a: int64, b: int64): int64
      op multiply(a: int64, b: int64): int64
}

agent (CalculatorAgent) impl BasicOperations {
      op add(a: int64, b: int64): int64 {
            mut result: int64 = a + b
            emit(nice, result, "Addition complete")
      }
      op subtract(a: int64, b: int64): int64 {
            mut result: int64 = a - b
            emit(nice, result, "Subtraction complete")
      }
      op integerDivide(a: int64, b: int64): int64 {
            mut result: int64 = a /i b
            emit(nice, result, "Integer division complete")
      }
      op remainder(a: int64, b: int64): int64 {
            mut result: int64 = a /r b
            emit(nice, result, "Remainder computed")
      }
      op multiply(a: int64, b: int64): int64 {
            mut result: int64 = a * b
            emit(nice, result, "Multiplication complete")
      }
}'''
    },
    {
        "id": "calculator_usage",
        "title": "Using the Calculator (.flux)",
        "desc": ".flux file importing the calculator agent and running all operations. Demonstrates use, dataflow --> print, and operation imports with aliases.",
        "tags": ["keyword"],
        "code": '''#L Import full agent with alias
use CalculatorAgent as CA

#L Import specific operations with aliases
use CalculatorAgent::{add as addition}
use CalculatorAgent::{subtract as subtraction}
use CalculatorAgent::{multiply as multiplication}

program (CalculatorExample) {
      mut as int64: x= 15
      mut as int64: y= 4

      print("Addition:")
      addition(x, y) --> print
      CA::add(x, y) --> print

      print("Subtraction:")
      subtraction(x, y) --> print

      print("Multiplication:")
      multiplication(x, y) --> print

      print("Direct pipeline to print:")
      7 + 3 --> print
}'''
    },
    {
        "id": "structured_errors",
        "title": "Structured Error Handling",
        "desc": "Demonstrates error, catch, fallback, ensure, panic, and the ? propagation operator. Includes a function that emits fail and caller recovery.",
        "tags": ["keyword", "operator"],
        "code": '''function controlledFailure(): int64 {
      emit(fail, 0, "controlled failure")
}

program (ErrorHandlingExample) {
      #L Error with catch
      print(error("invalid input") catch "recovered")

      #L Fallback to default value
      print(controlledFailure() fallback 7)

      #L Ensure + catch (cleanup always runs)
      print(controlledFailure() ensure {
            print("cleanup executed")
      } catch 9)

      #L ? operator with catch (short-circuit)
      imut RES: string = error("must fail")? catch "ok"
      print(RES)
}'''
    },
    {
        "id": "dataflow_pipeline",
        "title": "Dataflow Pipeline (split/join/--)",
        "desc": "Demonstrates --> for pipelines, split for bifurcation, and join for merging data flows.",
        "tags": ["keyword", "operator"],
        "code": '''program (DataflowExample) {
      #L Simple pipeline: function --> print
      mut as int64: result = 10 ==> it * 2
      print("Lambda with ==>: " + result)

      #L Split: bifurcates flows into parallel paths
      mut as list: routes = 100 split 200 split 300
      routes[2] --> print

      #L Join: consolidates flows into a single list
      mut as list: flow = 10 join 20 join 30 join 40
      flow[1] --> print
      flow[4] --> print

      #L Combined split + join
      (1 split 2) join (3 split 4) --> print
}'''
    },
    {
        "id": "ownership",
        "title": "Ownership: move, borrow, keep, and unsafe",
        "desc": "Demonstrates the language's ownership rules: transfer with move, borrowing with borrow, preservation with keep, and bypass with unsafe.",
        "tags": ["keyword"],
        "code": '''program (OwnershipExample) {
      #L Move: transfers ownership (invalidates source)
      mut as int64: payload = 100
      mut as int64: receiver = move(payload)
      print("Moved value: " + receiver)
      # payload cannot be used until reassignment
      payload = 200  # revive

      #L Borrow: exclusive mutable reference
      mut as int64: x = 42
      mut as int64: ref_x = borrow(x)
      print("Borrow: " + ref_x)

      #L Keep: preserves ownership during operation
      mut as int64: signal = 10
      mut as complex64: result = keep(signal) + 5
      print("Signal preserved: " + signal)

      #L Unsafe: disables static checks
      unsafe {
            mut as int64: p1 = borrow(payload)
            mut as int64: p2 = borrow(payload)
            print("Multiple borrows in unsafe: " + p1)
      }
}'''
    },
    {
        "id": "async_tasks",
        "title": "Async Tasks (async/await/spawn)",
        "desc": "Non-blocking functions returning a Future (async), dispatching dataflow to the runtime as green threads (spawn), and linear synchronization (await).",
        "tags": ["keyword"],
        "code": '''async function double(val: int64): int64 {
      emit(nice, val * 2, "ok")
}

program (AsyncExample) {
      #L async marks an operation as non-blocking, returning a Future
      print(await double(21))           # 42

      #L spawn dispatches a dataflow node/path to the runtime as a green thread
      mut as int64: scheduled = spawn double(20 + 1)

      #L await: linear synchronization point on the Future
      print(await scheduled)            # 42
}'''
    },
    {
        "id": "dijkstra",
        "title": "Dijkstra's Algorithm",
        "desc": "Complete implementation of Dijkstra's shortest path algorithm using tensors and infinite loops. Demonstrates tensor, nested loops, route, and index manipulation.",
        "tags": ["keyword", "type"],
        "code": '''program (Dijkstra) {
      mut graph: tensor[5, 5] of int64 = [
            [0, 2, 5, 0, 0],
            [0, 0, 1, 2, 0],
            [0, 0, 0, 3, 8],
            [0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0]
      ]
      mut distance: tensor[5] of int64 = [0, 9999, 9999, 9999, 9999]
      mut visited: tensor[5] of int64 = [0, 0, 0, 0, 0]
      mut as int64: step= 1
      mut as int64: vertex= 1
      mut as int64: current= 0
      mut as int64: smallest= 9999

      print("Dijkstra's Algorithm - Source: 1")

      infinite (step <= 5) {
            current = 0
            smallest = 9999
            infinite (vertex in 1 .. 5) {
                  route { visited[vertex] == 0 and
                        distance[vertex] < smallest --> {
                        smallest = distance[vertex]
                        current = vertex
                  }}
            }
            route { current == 0 --> { break } }

            visited[current] = 1
            print("Close vertex: " + current)

            infinite (neighbor in 1 .. 5) {
                  mut as int64: weight = graph[current, neighbor]
                  route { weight > 0 and visited[neighbor] == 0 --> {
                        mut as complex64: new_dist = distance[current] + weight
                        route { new_dist < distance[neighbor] --> {
                              distance[neighbor] = new_dist
                              print("Update " + neighbor +
                                    " to " + new_dist)
                        }}
                  }}
            }
      }

      infinite (vertex in 1 .. 5) {
            print("Distance[" + vertex + "] = " +
                  distance[vertex])
      }
}'''
    },
    {
        "id": "struct_data",
        "title": "Structs and Data Collections",
        "desc": "Demonstrates Struct declaration, named-field initialization, field access, and mutation. Includes data, list, and map with slicing and indexing.",
        "tags": ["keyword", "type"],
        "code": '''struct (event) {
      mut as string: name
      imut as datetime: WHEN
      mut as int64: counter
}

program (StructDataExample) {
      #L Struct
      mut as event: evt= event(.name: "start",
            .WHEN: 1970-01-01T00:00:00.000000000Z,
            .counter: 1)
      print(evt.name + " - " + evt.counter)

      #L Data (dynamic record)
      mut as data: payload= {.status: "ok", .cycle: 42}
      print(payload.status)
      payload.total = 3
      print(payload.total)

      #L List (1-based indexing)
      mut as list: xs= [10, 20, 30]
      print(xs[1])
      print(xs[2..4])

      #L Map
      mut as map: map= {.key: "value"}
      map["new"] = "data"
      print(map["key"])
}'''
    },
]

# ── Portuguese examples ────────────────────────────────────────────
EXAMPLES_PT = [
    {
        "id": "hello_world",
        "title": "Hello World",
        "desc": "Programa minimo que imprime uma mensagem na saida padrao. Introduz program, print e comentarios #L.",
        "tags": ["keyword"],
        "code": '''#L Exemplo classico Hello World em TheFlux

program (HelloWorld) {
      print("Hello, TheFlux!")
}'''
    },
    {
        "id": "fibonacci",
        "title": "Fibonacci Recursivo",
        "desc": "Funcao recursiva que calcula a sequencia de Fibonacci. Demonstra function, route com sujeito, emit, infinite com iteracao e operadores aritmeticos.",
        "tags": ["keyword", "operator"],
        "code": '''function fibonacci(n: int64): int64 {
      route (n) {
            <= 1 --> {
                  emit(nice, n, "base")
            }
            _ --> {
                  emit(nice, fibonacci(n - 1) + fibonacci(n - 2), "recursivo")
            }
      }
}

program (ExampleOfFibonacci) {
      infinite (posicao in 1 .. 10) {
            print("Fibonacci posicao: " + posicao + " = " + fibonacci(posicao))
      }
}'''
    },
    {
        "id": "route_idade",
        "title": "Classificacao por Idade (route)",
        "desc": "Condicional multi-braco usando route com sujeito. Demonstra operadores de comparacao, literais inteiros e o braco catch-all _.",
        "tags": ["keyword", "operator"],
        "code": '''program (ClassificarIdade) {
      mut as int64: idade= 25

      route (idade) {
            < 0 --> {
                  print("Erro: idade negativa invalida")
            }
            < 12 --> {
                  print("Crianca")
            }
            < 18 --> {
                  print("Adolescente")
            }
            < 60 --> {
                  print("Adulto")
            }
            < 120 --> {
                  print("Idoso")
            }
            _ --> {
                  print("Erro: idade fora do intervalo valido")
            }
      }
}'''
    },
    {
        "id": "enum_match",
        "title": "Enum com Match",
        "desc": "Enum discriminado (Resultado) com variantes tipadas e casamento de padrao via match. Demonstra Enum, match, :: e interpolacao de string.",
        "tags": ["keyword", "type"],
        "code": '''enum (Resultado) {
      Ok(valor: int64)
      Erro(mensagem: string)
}

program (ExemploEnumMatch) {
      mut as Resultado: resposta = Resultado::Ok(.valor: 41)
      mut as Resultado: falha = Resultado::Erro(.mensagem: "falhou")

      print(match resposta {
            Resultado::Ok(.valor: valor) ==> "Sucesso: #{valor}"
            Resultado::Erro(.mensagem: msg) ==> "Falha: #{msg}"
      })

      print(match falha {
            Resultado::Ok(.valor: valor) ==> valor
            Resultado::Erro(.mensagem: msg) ==> msg
      })
}'''
    },
    {
        "id": "calculadora_agent",
        "title": "Calculadora com Agent e Contract",
        "desc": "Arquivo .fdsl que declara um contrato e um agente implementando 5 operacoes aritmeticas. Demonstra contract, agent, impl, op, emit e tipos inteiros.",
        "tags": ["keyword"],
        "code": '''#L Arquivo: AgentOfCalculadora.fdsl
contract (OperacoesBasicas) {
      op somar(a: int64, b: int64): int64
      op subtrair(a: int64, b: int64): int64
      op dividirInteiro(a: int64, b: int64): int64
      op restoDivisao(a: int64, b: int64): int64
      op multiplicar(a: int64, b: int64): int64
}

agent (AgentOfCalculadora) impl OperacoesBasicas {
      op somar(a: int64, b: int64): int64 {
            mut resultado: int64 = a + b
            emit(nice, resultado, "Soma concluida")
      }
      op subtrair(a: int64, b: int64): int64 {
            mut resultado: int64 = a - b
            emit(nice, resultado, "Subtracao concluida")
      }
      op dividirInteiro(a: int64, b: int64): int64 {
            mut resultado: int64 = a /i b
            emit(nice, resultado, "Divisao inteira concluida")
      }
      op restoDivisao(a: int64, b: int64): int64 {
            mut resultado: int64 = a /r b
            emit(nice, resultado, "Resto concluido")
      }
      op multiplicar(a: int64, b: int64): int64 {
            mut resultado: int64 = a * b
            emit(nice, resultado, "Multiplicacao concluida")
      }
}'''
    },
    {
        "id": "calculadora_uso",
        "title": "Usando a Calculadora (.flux)",
        "desc": "Arquivo .flux que importa o agente calculadora e executa todas as operacoes. Demonstra use, dataflow --> print e importacao de operacoes com alias.",
        "tags": ["keyword"],
        "code": '''#L Importa o agente completo com alias
use AgentOfCalculadora as CA

#L Importa operacoes especificas com alias
use AgentOfCalculadora::{somar as adicao}
use AgentOfCalculadora::{subtrair as subtracao}
use AgentOfCalculadora::{multiplicar as multiplicacao}

program (ExemploCalculadora) {
      mut as int64: x= 15
      mut as int64: y= 4

      print("Adicao:")
      adicao(x, y) --> print
      CA::somar(x, y) --> print

      print("Subtracao:")
      subtracao(x, y) --> print

      print("Multiplicacao:")
      multiplicacao(x, y) --> print

      print("Pipeline direto no print:")
      7 + 3 --> print
}'''
    },
    {
        "id": "structured_errors",
        "title": "Tratamento de Erros Estruturados",
        "desc": "Demonstra error, catch, fallback, ensure, panic e o operador de propagacao ?. Inclui funcao que emite fail e recuperacao no chamador.",
        "tags": ["keyword", "operator"],
        "code": '''function falhaControlada(): int64 {
      emit(fail, 0, "falha controlada")
}

program (ExemploErros) {
      #L Error com catch
      print(error("entrada invalida") catch "recuperado")

      #L Fallback para valor padrao
      print(falhaControlada() fallback 7)

      #L Ensure + catch (cleanup sempre executado)
      print(falhaControlada() ensure {
            print("cleanup executado")
      } catch 9)

      #L Operador ? com catch (curto-circuito)
      imut RES: string = error("deve falhar")? catch "ok"
      print(RES)
}'''
    },
    {
        "id": "dataflow_pipeline",
        "title": "Pipeline de Dataflow (split/join/--)",
        "desc": "Demonstra o uso de --> para pipelines, split para bifurcacao e join para consolidacao de fluxos de dados.",
        "tags": ["keyword", "operator"],
        "code": '''program (ExemploDataflow) {
      #L Pipeline simples: funcao --> print
      mut as int64: resultado = 10 ==> it * 2
      print("Lambda com ==>: " + resultado)

      #L Split: bifurca fluxos em vias paralelas
      mut as list: rotas = 100 split 200 split 300
      rotas[2] --> print

      #L Join: consolida fluxos em lista unica
      mut as list: fluxo = 10 join 20 join 30 join 40
      fluxo[1] --> print
      fluxo[4] --> print

      #L Combinacao split + join
      (1 split 2) join (3 split 4) --> print
}'''
    },
    {
        "id": "ownership",
        "title": "Ownership: move, borrow, keep e unsafe",
        "desc": "Demonstra as regras de propriedade (ownership) da linguagem: transferencia com move, emprestimo com borrow, preservacao com keep e bypass com unsafe.",
        "tags": ["keyword"],
        "code": '''program (ExemploOwnership) {
      #L Move: transfere posse (invalida origem)
      mut as int64: payload = 100
      mut as int64: receiver = move(payload)
      print("Valor movido: " + receiver)
      # payload nao pode ser usado ate reatribuicao
      payload = 200  # reviver

      #L Borrow: emprestimo exclusivo para mutavel
      mut as int64: x = 42
      mut as int64: ref_x = borrow(x)
      print("Borrow: " + ref_x)

      #L Keep: preserva posse durante operacao
      mut as int64: signal = 10
      mut as complex64: result = keep(signal) + 5
      print("Signal mantido: " + signal)

      #L Unsafe: desativa verificacoes estaticas
      unsafe {
            mut as int64: p1 = borrow(payload)
            mut as int64: p2 = borrow(payload)
            print("Multiplos borrows em unsafe: " + p1)
      }
}'''
    },
    {
        "id": "async_tasks",
        "title": "Tarefas Assincronas (async/await/spawn)",
        "desc": "Funcoes nao-bloqueantes que retornam Future (async), despacho do dataflow ao runtime como green thread (spawn) e sincronizacao linear (await).",
        "tags": ["keyword"],
        "code": '''async function dobro(valor: int64): int64 {
      emit(nice, valor * 2, "ok")
}

program (ExemploAsync) {
      #L async marca operacao como nao-bloqueante, retornando um Future
      print(await dobro(21))            # 42

      #L spawn despacha um no/caminho do dataflow ao runtime como green thread
      mut as int64: agendada = spawn dobro(20 + 1)

      #L await: ponto de sincronizacao linear sobre o Future
      print(await agendada)             # 42
}'''
    },
    {
        "id": "dijkstra",
        "title": "Algoritmo de Dijkstra",
        "desc": "Implementacao completa do algoritmo de caminho minimo de Dijkstra usando tensores e loops infinite. Demonstra tensor, loops aninhados, route e manipulacao de indices.",
        "tags": ["keyword", "type"],
        "code": '''program (Dijkstra) {
      mut grafo: tensor[5, 5] of int64 = [
            [0, 2, 5, 0, 0],
            [0, 0, 1, 2, 0],
            [0, 0, 0, 3, 8],
            [0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0]
      ]
      mut distancia: tensor[5] of int64 = [0, 9999, 9999, 9999, 9999]
      mut visitado: tensor[5] of int64 = [0, 0, 0, 0, 0]
      mut as int64: passo= 1
      mut as int64: vertice= 1
      mut as int64: atual= 0
      mut as int64: menor= 9999

      print("Algoritmo de Dijkstra - Origem: 1")

      infinite (passo <= 5) {
            atual = 0
            menor = 9999
            infinite (vertice in 1 .. 5) {
                  route { visitado[vertice] == 0 and
                        distancia[vertice] < menor --> {
                        menor = distancia[vertice]
                        atual = vertice
                  }}
            }
            route { atual == 0 --> { break } }

            visitado[atual] = 1
            print("Fecha vertice: " + atual)

            infinite (vizinho in 1 .. 5) {
                  mut as int64: peso = grafo[atual, vizinho]
                  route { peso > 0 and visitado[vizinho] == 0 --> {
                        mut as complex64: nova_dist = distancia[atual] + peso
                        route { nova_dist < distancia[vizinho] --> {
                              distancia[vizinho] = nova_dist
                              print("Atualiza " + vizinho +
                                    " para " + nova_dist)
                        }}
                  }}
            }
      }

      infinite (vertice in 1 .. 5) {
            print("Distancia[" + vertice + "] = " +
                  distancia[vertice])
      }
}'''
    },
    {
        "id": "struct_data",
        "title": "Structs e Data Collections",
        "desc": "Demonstra declaracao de Struct, inicializacao com campos nomeados, acesso e mutacao de campos. Inclui uso de data, list e map com slicing e indexacao.",
        "tags": ["keyword", "type"],
        "code": '''struct (evento) {
      mut as string: nome
      imut as datetime: QUANDO
      mut as int64: contador
}

program (ExemploStructData) {
      #L Struct
      mut as evento: evt= evento(.nome: "inicio",
            .QUANDO: 1970-01-01T00:00:00.000000000Z,
            .contador: 1)
      print(evt.nome + " - " + evt.contador)

      #L Data (registro dinamico)
      mut as data: payload= {.status: "ok", .ciclo: 42}
      print(payload.status)
      payload.total = 3
      print(payload.total)

      #L List (1-based indexing)
      mut as list: xs= [10, 20, 30]
      print(xs[1])
      print(xs[2..4])

      #L Map
      mut as map: map= {.chave: "valor"}
      map["nova"] = "dados"
      print(map["chave"])
}'''
    },
]

EXAMPLES = EXAMPLES_PT  # default, overridden by --lang


# ── Language-specific configuration ─────────────────────────────────
LANG_CONFIG = {
    "pt": {
        "html_lang": "pt-BR",
        "title": "TheFlux - Documentacao da Linguagem",
        "hero_title": "TheFlux Language",
        "hero_desc": "Documentacao completa de palavras-chave, tipos, operadores e literais",
        "search_placeholder": "Buscar...",
        "sidebar_subtitle": "Documentacao da Linguagem v0.1",
        "nav_conceitos": "Conceitos",
        "nav_categorias": "Categorias",
        "filter_all": "Todas",
        "filter_examples": "Exemplos",
        "section_examples_title": "Exemplos Completos",
        "section_examples_desc": "Programas completos demonstrando os conceitos da linguagem em acao.",
        "stat_total": "Total",
        "stat_categorias": "Categorias",
        "stat_exemplos": "Exemplos completos",
        "label_syntax": "Sintaxe",
        "label_example": "Exemplo",
        "label_restricoes": "Restricoes",
        "detail_desc": "Descricao",
        "detail_syntax": "Sintaxe",
        "detail_pseudocode": "Pseudocodigo",
        "detail_usos": "Usos",
        "detail_restricoes": "Restricoes",
        "btn_copy": "📋 Copiar",
        "btn_copied": "✓ Copiado!",
        "tag_keyword": "Keywords",
        "tag_operator": "Operadores",
        "tag_type": "Tipos",
        "tag_literal": "Literais",
        "category_order": [
            "Declaracao de Tipo", "Declaracao de Variavel", "Declaracao de Funcao",
            "Declaracao de Operacao", "Declaracao de Contrato", "Implementacao de Contrato",
            "Declaracao de Agente", "Ponto de Entrada", "Declaracao de Importacao",
            "Estrutura de Loop", "Estrutura Condicional", "Pattern Matching",
            "Controle de Fluxo", "Instrucao de Saida", "Instrucao de Retorno",
            "Status de Retorno", "Entrada de Dados",
            "Tipo Numerico - Inteiro", "Tipo Numerico - Ponto Flutuante",
            "Tipo Numerico - Complexo", "Tipo Escalar Primitivo",
            "Tipo de Colecao", "Tipo de Tensor",
            "Erro Fatal", "Expressao de Erro", "Recuperacao de Erro",
            "Execucao Garantida", "Propagacao de Erro",
            "Operador Aritmetico", "Operador de Comparacao", "Operador Logico",
            "Operador Bitwise", "Operador de Atribuicao", "Operador de Dataflow",
            "Operador de Range / Slice", "Operador de Acesso", "Operador de Cast",
            "Tarefas Assincronas", "Ownership (Propriedade)", "Bloco Inseguro",
            "Metaprogramacao (Compile-time)", "Metaprogramacao (Macro)",
            "Metaprogramacao (AST)", "Iteracao", "Telemetria/Debug",
            "Literal", "Literal Numerico", "Token Especial - Wildcard",
            "Comentario / Documentacao", "Interpolacao de String",
            "Composicao de Tipo", "Outros",
        ],
    },
    "en": {
        "html_lang": "en",
        "title": "TheFlux - Language Documentation",
        "hero_title": "TheFlux Language",
        "hero_desc": "Complete documentation of keywords, types, operators, and literals",
        "search_placeholder": "Search...",
        "sidebar_subtitle": "Language Documentation v0.1",
        "nav_conceitos": "Concepts",
        "nav_categorias": "Categories",
        "filter_all": "All",
        "filter_examples": "Examples",
        "section_examples_title": "Complete Examples",
        "section_examples_desc": "Full programs demonstrating language concepts in action.",
        "stat_total": "Total",
        "stat_categorias": "Categories",
        "stat_exemplos": "Complete examples",
        "label_syntax": "Syntax",
        "label_example": "Example",
        "label_restricoes": "Restrictions",
        "detail_desc": "Description",
        "detail_syntax": "Syntax",
        "detail_pseudocode": "Pseudocode",
        "detail_usos": "Usages",
        "detail_restricoes": "Restrictions",
        "btn_copy": "📋 Copy",
        "btn_copied": "✓ Copied!",
        "tag_keyword": "Keywords",
        "tag_operator": "Operators",
        "tag_type": "Types",
        "tag_literal": "Literals",
        "category_order": [
            "Type Declaration", "Variable Declaration", "Function Declaration",
            "Operation Declaration", "Contract Declaration", "Contract Implementation",
            "Agent Declaration", "Entry Point", "Import Declaration",
            "Loop Structure", "Conditional Structure", "Pattern Matching",
            "Flow Control", "Output Instruction", "Return Instruction",
            "Return Status", "Data Input",
            "Numeric Type - Integer", "Numeric Type - Floating Point",
            "Numeric Type - Complex", "Primitive Scalar Type",
            "Collection Type", "Tensor Type",
            "Fatal Error", "Error Expression", "Error Recovery",
            "Guaranteed Execution", "Error Propagation",
            "Arithmetic Operator", "Comparison Operator", "Logical Operator",
            "Bitwise Operator", "Assignment Operator", "Dataflow Operator",
            "Range / Slice Operator", "Access Operator", "Cast Operator",
            "Asynchronous Tasks", "Ownership", "Unsafe Block",
            "Metaprogramming (Compile-time)", "Metaprogramming (Macro)",
            "Metaprogramming (AST)", "Iteration", "Telemetry/Debug",
            "Literal", "Numeric Literal", "Special Token - Wildcard",
            "Comment / Documentation", "String Interpolation",
            "Type Composition", "Others",
        ],
    }
}


def load_all_yamls(lang="pt"):
    if lang == "en":
        base_dir = os.path.join(DOCS_DIR, "en")
    else:
        base_dir = DOCS_DIR
    files = sorted(glob.glob(os.path.join(base_dir, "KW_*.yaml")))
    entries = []
    for fpath in files:
        with open(fpath, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
        if data and "keyword" in data:
            entries.append(data)
    return entries


def categorize(entry):
    return entry.get("category", "Outros" if entry.get("category") else "Others")


def get_tag(category):
    cat_lower = category.lower()
    if "operador" in cat_lower or "operator" in cat_lower:
        if "cast" not in cat_lower:
            return "operator"
    if "tipo" in cat_lower or "type" in cat_lower:
        if cat_lower.startswith("tipo") or cat_lower.startswith("type") or "numeric" in cat_lower or "scalar" in cat_lower or "collection" in cat_lower or "tensor" in cat_lower:
            return "type"
    if cat_lower == "literal" or cat_lower == "literal numerico" or cat_lower == "numeric literal":
        return "literal"
    return "keyword"


TAG_CONFIG = {
    "keyword": {"color": "#ff7b72", "icon": "K"},
    "operator": {"color": "#d2a8ff", "icon": "O"},
    "type": {"color": "#79c0ff", "icon": "T"},
    "literal": {"color": "#3fb950", "icon": "L"},
}


def html_escape(text):
    if text is None:
        return ""
    return str(text).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def highlight_code(code):
    code = html_escape(code)
    import re
    keywords = r"\b(mut|imut|Struct|Enum|contract|impl|function|break|continue|match|error|catch|ensure|fallback|panic|program|emit|nice|fail|route|infinite|agent|op|use|of|comptime|macro|quote|unquote|spawn|async|await|keep|move|borrow|unsafe|print|input|spy|as|in|true|false|True|False|TRUE|FALSE|split|join|and|or|not)\b"
    code = re.sub(keywords, r'<span class="kw">\1</span>', code)
    types = r"\b(int8|int16|int32|int64|uint8|uint16|uint32|uint64|float16|float32|float64|fp8_e4m3|fp8_e5m2|bf16_e8m7|tf32_e8m10|complex16|complex32|complex64|complex128|char|bool|datetime|string|data|list|set|map|tensor|task|int|uint|float|complex|none)\b"
    code = re.sub(types, r'<span class="type">\1</span>', code)
    code = re.sub(r'("[^"]*")', r'<span class="str">\1</span>', code)
    code = re.sub(r"\b(\d+\.?\d*(?:[eE][+-]?\d+)?i?)\b", r'<span class="num">\1</span>', code)
    code = re.sub(r"(#L[^\n]*)", r'<span class="cmt">\1</span>', code)
    code = re.sub(r"(#D)", r'<span class="cmt">\1</span>', code)
    code = re.sub(r"(D#)", r'<span class="cmt">\1</span>', code)
    return code


def to_safe_id(text):
    raw = text.lower().replace(" ", "_").replace("/", "_").replace("-", "_")
    raw = raw.replace("(", "").replace(")", "").replace("<", "").replace(">", "")
    trans = str.maketrans("aaaaceeeeiiiiooooouuuucn", "aaaaceeeeiiiiooooouuuucn")
    return raw.translate(trans)


def build_tag_badge(tag, lang="pt"):
    cfg = TAG_CONFIG.get(tag, TAG_CONFIG["keyword"])
    c = cfg["color"]
    label = LANG_CONFIG.get(lang, LANG_CONFIG["pt"]).get(f"tag_{tag}", tag)
    return f'<span class="tag-badge tag-{tag}" style="background:{c}1a;color:{c};border:1px solid{c}44">{label}</span>'


def build_detail_panel(idx, entry, lang_cfg, lang="pt"):
    kw = entry.get("keyword", "")
    desc = entry.get("description", "")
    syntax = entry.get("syntax", "")
    pseudocode = entry.get("pseudocode", "")
    usages = entry.get("usages", [])
    restrictions = entry.get("restrictions", [])
    tag = get_tag(categorize(entry))
    parts = []
    parts.append(f'<div id="detail-{idx}" class="detail-panel">')
    parts.append(f'<div class="detail-header"><span class="keyword">{html_escape(kw)}</span><button class="close-btn" onclick="closeDetail()">&times;</button></div>')
    parts.append('<div class="detail-body">')
    parts.append(f'<div class="detail-meta">{build_tag_badge(tag, lang)}</div>')
    if desc:
        parts.append(f'<div class="detail-section"><h3>{lang_cfg["detail_desc"]}</h3><p>{html_escape(desc).replace(chr(10),"<br>")}</p></div>')
    if syntax:
        syntax_id = f'dc-{idx}-syntax'
        parts.append(f'<div class="detail-section"><h3>{lang_cfg["detail_syntax"]}</h3><div class="copy-wrap" id="{syntax_id}"><button class="copy-btn" onclick="copyCode(\'{syntax_id}\')" title="{html_escape(lang_cfg["btn_copy"])}">{html_escape(lang_cfg["btn_copy"])}</button><pre><code>{highlight_code(syntax)}</code></pre></div></div>')
    if pseudocode:
        pcode_id = f'dc-{idx}-pseudo'
        parts.append(f'<div class="detail-section"><h3>{lang_cfg["detail_pseudocode"]}</h3><div class="copy-wrap" id="{pcode_id}"><button class="copy-btn" onclick="copyCode(\'{pcode_id}\')" title="{html_escape(lang_cfg["btn_copy"])}">{html_escape(lang_cfg["btn_copy"])}</button><pre><code>{highlight_code(pseudocode)}</code></pre></div></div>')
    if usages:
        parts.append(f'<div class="detail-section"><h3>{lang_cfg["detail_usos"]}</h3>')
        for u in usages:
            u_name = u.get("name", "")
            u_desc = u.get("description", "")
            u_examples = u.get("examples", [])
            if u_name:
                parts.append(f'<h4>{html_escape(u_name)}</h4>')
            if u_desc:
                parts.append(f'<p>{html_escape(u_desc)}</p>')
            for ex_idx, ex in enumerate(u_examples):
                ex_code = ex.get("code", "")
                ex_desc = ex.get("description", "")
                if isinstance(ex_code, list):
                    ex_code = "\n".join(str(c) for c in ex_code)
                if ex_desc:
                    parts.append(f'<p class="ex-desc">{html_escape(ex_desc)}</p>')
                ex_id = f'dc-{idx}-ex-{ex_idx}'
                parts.append(f'<div class="copy-wrap" id="{ex_id}"><button class="copy-btn" onclick="copyCode(\'{ex_id}\')" title="{html_escape(lang_cfg["btn_copy"])}">{html_escape(lang_cfg["btn_copy"])}</button><pre><code>{highlight_code(ex_code)}</code></pre></div>')
        parts.append('</div>')
    if restrictions:
        parts.append(f'<div class="detail-section"><h3>{lang_cfg["detail_restricoes"]}</h3><ul>')
        for r in restrictions:
            parts.append(f'<li>{html_escape(r)}</li>')
        parts.append('</ul></div>')
    parts.append('</div></div>')
    return "\n".join(parts)


def build_card(idx, entry, lang_cfg, lang="pt"):
    kw = entry.get("keyword", "")
    desc = entry.get("description", "")
    syntax = entry.get("syntax", "")
    usages = entry.get("usages", [])
    restrictions = entry.get("restrictions", [])
    tag = get_tag(categorize(entry))
    parts = []
    parts.append(f'<div class="card" data-index="{idx}" data-tag="{tag}">')
    parts.append(f'<div class="card-header"><span class="keyword">{html_escape(kw)}</span>{build_tag_badge(tag, lang)}</div>')
    parts.append('<div class="card-body">')
    if desc:
        parts.append(f'<p class="desc">{html_escape(desc.split(".")[0] + ".")}</p>')
    if syntax:
        syntax_lines = syntax.strip().split("\n")
        preview_lines = [l for l in syntax_lines if l.strip()][:3]
        preview = "<br>".join(html_escape(l) for l in preview_lines)
        parts.append(f'<div class="syntax"><span class="label">{lang_cfg["label_syntax"]}</span><pre><code>{preview}</code></pre></div>')
    if usages:
        usage = usages[0]
        u_examples = usage.get("examples", [])
        if u_examples:
            ex = u_examples[0]
            ex_code = ex.get("code", "")
            if isinstance(ex_code, list):
                ex_code = "\n".join(str(c) for c in ex_code)
            parts.append(f'<div class="example"><span class="label">{lang_cfg["label_example"]}</span><pre><code>{highlight_code(ex_code)}</code></pre></div>')
    if restrictions and len(restrictions) <= 3:
        parts.append(f'<div class="restrictions"><span class="label">{lang_cfg["label_restricoes"]}</span><ul>')
        for r in restrictions:
            parts.append(f'<li>{html_escape(r)}</li>')
        parts.append('</ul></div>')
    parts.append('</div></div>')
    return "\n".join(parts)


def build_examples_section(lang_cfg, lang="pt"):
    tabs_html = f'<div id="examples-section" class="examples-section"><h2 class="section-title">{lang_cfg["section_examples_title"]}</h2><p class="section-desc">{lang_cfg["section_examples_desc"]}</p>'
    tabs_html += '<div class="examples-tabs" id="examplesTabs">'

    for i, ex in enumerate(EXAMPLES):
        active = " active" if i == 0 else ""
        tabs_html += f'<button class="example-tab{active}" data-example="{ex["id"]}" onclick="switchExample(\'{ex["id"]}\')">{html_escape(ex["title"])}</button>'

    tabs_html += '</div><div class="example-panels">'

    for i, ex in enumerate(EXAMPLES):
        show = " show" if i == 0 else ""
        tags_html = " ".join(build_tag_badge(t, lang) for t in ex["tags"])
        tabs_html += f'<div id="ex-{ex["id"]}" class="example-panel{show}">'
        tabs_html += '<div class="example-panel-header">'
        tabs_html += f'<div><h3>{html_escape(ex["title"])}</h3><p>{html_escape(ex["desc"])}</p></div>'
        tabs_html += f'<div class="example-meta">{tags_html}</div>'
        tabs_html += '</div>'
        tabs_html += '<div class="example-code-wrap">'
        tabs_html += f'<button class="copy-btn" onclick="copyCode(\'ex-{ex["id"]}\')" title="{html_escape(lang_cfg["btn_copy"])}">{html_escape(lang_cfg["btn_copy"])}</button>'
        tabs_html += f'<pre class="example-code"><code>{highlight_code(ex["code"])}</code></pre>'
        tabs_html += '</div>'
        tabs_html += '</div>'

    tabs_html += '</div></div>'
    return tabs_html


def build_html(entries, lang="pt"):
    lang_cfg = LANG_CONFIG[lang]

    groups = {}
    for entry in entries:
        cat = categorize(entry)
        groups.setdefault(cat, []).append(entry)

    category_order = lang_cfg["category_order"]
    sorted_cats = [c for c in category_order if c in groups]
    remaining = [c for c in sorted(groups.keys()) if c not in category_order]
    sorted_cats += sorted(remaining)

    tag_counts = {"keyword": 0, "operator": 0, "type": 0, "literal": 0}
    for entry in entries:
        tag = get_tag(categorize(entry))
        if tag in tag_counts:
            tag_counts[tag] += 1

    cards_html = ""
    nav_items = ""
    nav_examples = ""
    global_index = 0
    global_index_cards = 0

    for cat in sorted_cats:
        items = groups[cat]
        card_id = to_safe_id(cat)
        nav_items += f'<a href="#{card_id}" class="nav-item">{html_escape(cat)} ({len(items)})</a>'
        cards_html += f'<section id="{card_id}" class="category">'
        cards_html += f'<h2 class="cat-title">{html_escape(cat)}</h2>'
        cards_html += '<div class="card-grid">'
        for entry in items:
            idx = global_index
            global_index += 1
            cards_html += build_card(idx, entry, lang_cfg, lang)
        cards_html += '</div></section>'

    # Build example nav links
    for ex in EXAMPLES:
        nav_examples += (
            f'<a href="#examples-section" class="nav-item nav-example" '
            f'data-example="{ex["id"]}" '
            f'onclick="goToExample(\'{ex["id"]}\')">'
            f'{html_escape(ex["title"])}</a>'
        )

    detail_sections = ""
    for cat in sorted_cats:
        for entry in groups[cat]:
            idx = global_index_cards
            detail_sections += build_detail_panel(idx, entry, lang_cfg, lang)
            global_index_cards += 1

    examples_section = build_examples_section(lang_cfg, lang)

    tag_buttons = ""
    for tag_key in ["keyword", "operator", "type", "literal"]:
        cfg = TAG_CONFIG[tag_key]
        cnt = tag_counts.get(tag_key, 0)
        active = " active" if tag_key == "keyword" else ""
        label = lang_cfg[f"tag_{tag_key}"]
        tag_buttons += (
            f'<button class="tag-filter tag-filter-{tag_key}{active}" '
            f'data-tag="{tag_key}" onclick="setTagFilter(\'{tag_key}\')" '
            f'style="--tag-color:{cfg["color"]}">'
            f'<span class="tag-dot" style="background:{cfg["color"]}"></span>'
            f'{label} <span class="tag-count">{cnt}</span>'
            f'</button>'
        )

    html_lang_attr = lang_cfg["html_lang"]
    subtitle = lang_cfg["sidebar_subtitle"]
    search_placeholder = lang_cfg["search_placeholder"]
    filter_all_label = lang_cfg["filter_all"]
    filter_examples_label = lang_cfg["filter_examples"]
    nav_conceitos = lang_cfg["nav_conceitos"]
    nav_categorias = lang_cfg["nav_categorias"]
    hero_title = lang_cfg["hero_title"]
    hero_desc = lang_cfg["hero_desc"]
    stat_total = lang_cfg["stat_total"]
    stat_categorias = lang_cfg["stat_categorias"]
    stat_exemplos = lang_cfg["stat_exemplos"]
    btn_copy = lang_cfg["btn_copy"]
    btn_copied = lang_cfg["btn_copied"]

    # Language selector
    other_lang = "en" if lang == "pt" else "pt"
    other_file = "theflux_docs_en.html" if lang == "pt" else "theflux_docs.html"
    lang_selector = (
        f'<a href="theflux_docs.html" class="{"active" if lang == "pt" else ""}">PT</a>'
        f'<a href="{other_file}" class="{"active" if lang == "en" else ""}">EN</a>'
    )

    html = f"""<!DOCTYPE html>
<html lang="{html_lang_attr}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{lang_cfg["title"]}</title>
<style>
  :root {{
    --bg: #0d1117;
    --surface: #161b22;
    --border: #30363d;
    --text: #e6edf3;
    --text-dim: #8b949e;
    --keyword: #ff7b72;
    --type: #79c0ff;
    --string: #a5d6ff;
    --number: #79c0ff;
    --comment: #8b949e;
    --accent: #58a6ff;
    --accent2: #3fb950;
    --warn: #d29922;
    --card-bg: #1c2128;
    --ex-bg: #0d1117;
  }}
  * {{ margin: 0; padding: 0; box-sizing: border-box; }}
  body {{
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
    line-height: 1.6;
  }}
  .wrapper {{ display: flex; min-height: 100vh; }}
  .sidebar {{
    width: 280px; background: var(--surface); border-right: 1px solid var(--border);
    padding: 20px 16px; position: fixed; top: 0; left: 0; height: 100vh;
    overflow-y: auto; z-index: 100;
  }}
  .sidebar-header {{
    display: flex; align-items: center; justify-content: space-between;
  }}
  .sidebar-header h1 {{ font-size: 20px; color: var(--accent); margin: 0; flex: 1; text-align: center; }}
  .sidebar .subtitle {{ color: var(--text-dim); font-size: 12px; margin-bottom: 16px; text-align: center; }}
  .lang-toggle {{
    display: flex; gap: 2px;
    background: var(--bg); border-radius: 6px;
    padding: 2px; border: 1px solid var(--border);
    flex-shrink: 0;
  }}
  .lang-toggle a {{
    text-decoration: none; padding: 2px 8px;
    border-radius: 4px; font-size: 11px; font-weight: 600;
    color: var(--text-dim); transition: all 0.15s;
    font-family: inherit;
  }}
  .lang-toggle a:hover {{ color: var(--text); }}
  .lang-toggle a.active {{
    background: var(--accent); color: #fff;
  }}
  .tag-filters {{ display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 12px; padding-bottom: 12px; border-bottom: 1px solid var(--border); }}
  .tag-filter {{ display: inline-flex; align-items: center; gap: 5px; padding: 5px 10px; border-radius: 20px; border: 1px solid var(--border); background: transparent; color: var(--text-dim); font-size: 12px; cursor: pointer; transition: all 0.15s; font-family: inherit; }}
  .tag-filter:hover {{ background: rgba(255,255,255,0.04); color: var(--text); }}
  .tag-filter.active {{ background: color-mix(in srgb, var(--tag-color) 15%, transparent); border-color: var(--tag-color); color: var(--text); }}
  .tag-dot {{ width: 8px; height: 8px; border-radius: 50%; display: inline-block; }}
  .tag-count {{ color: var(--text-dim); font-size: 11px; opacity: 0.7; }}
  .tag-filter.active .tag-count {{ opacity: 1; }}
  .tag-badge {{ display: inline-block; font-size: 9px; padding: 2px 7px; border-radius: 10px; font-weight: 600; letter-spacing: 0.3px; text-transform: uppercase; margin-left: auto; flex-shrink: 0; }}
  .sidebar .nav-item {{ display: block; padding: 5px 10px; color: var(--text-dim); text-decoration: none; font-size: 12px; border-radius: 6px; transition: all 0.15s; border-left: 2px solid transparent; }}
.sidebar .nav-item:hover {{ background: rgba(88,166,255,0.08); color: var(--text); border-left-color: var(--accent); }}
.sidebar .nav-item.active {{ color: var(--accent); background: rgba(88,166,255,0.1); border-left-color: var(--accent); }}
.sidebar .nav-item.nav-example {{ border-left-color: var(--accent2); font-size: 11px; padding-left: 14px; }}
  .main {{ margin-left: 280px; flex: 1; padding: 32px 48px; max-width: 1200px; }}
  .hero {{ margin-bottom: 32px; padding-bottom: 20px; border-bottom: 1px solid var(--border); }}
  .hero h1 {{ font-size: 36px; background: linear-gradient(135deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }}
  .hero p {{ color: var(--text-dim); font-size: 15px; margin-top: 8px; }}
  .hero .stats {{ display: flex; gap: 12px; margin-top: 14px; flex-wrap: wrap; }}
  .hero .stat {{ background: var(--surface); padding: 6px 14px; border-radius: 8px; border: 1px solid var(--border); font-size: 13px; }}
  .hero .stat span {{ color: var(--accent); font-weight: 600; }}

  /* Section titles */
  .section-title {{ font-size: 22px; color: var(--accent); margin-bottom: 8px; }}
  .section-desc {{ color: var(--text-dim); font-size: 14px; margin-bottom: 20px; }}

  .category {{ margin-bottom: 32px; scroll-margin-top: 16px; }}
  .cat-title {{ font-size: 13px; color: var(--accent); margin-bottom: 12px; padding-bottom: 6px; border-bottom: 1px solid var(--border); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }}
  .card-grid {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 10px; }}
  .card {{
    background: var(--card-bg); border: 1px solid var(--border);
    border-radius: 10px; overflow: hidden; cursor: pointer;
    transition: transform 0.25s cubic-bezier(0.22, 1, 0.36, 1),
                box-shadow 0.25s ease, border-color 0.2s ease;
  }}
  .card:hover {{
    border-color: var(--accent);
    transform: translateY(-4px) scale(1.02);
    box-shadow: 0 0 20px rgba(88,166,255,0.15),
                0 8px 30px rgba(0,0,0,0.35);
  }}
  .card-header {{
    padding: 8px 12px; background: rgba(88,166,255,0.06);
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 8px;
    transition: background 0.25s ease;
  }}
  .card:hover .card-header {{
    background: rgba(88,166,255,0.12);
  }}
  .card-header .keyword {{ font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace; font-size: 13px; font-weight: 600; color: var(--keyword); }}
  .card-body {{ padding: 10px 12px 12px; }}
  .card-body .desc {{ color: var(--text); font-size: 12px; line-height: 1.5; margin-bottom: 6px; }}
  .label {{ display: inline-block; font-size: 9px; text-transform: uppercase; letter-spacing: 0.8px; color: var(--text-dim); margin-bottom: 3px; font-weight: 600; }}
  .syntax, .example {{ margin-top: 6px; }}
  .card pre {{ background: #0d1117; border: 1px solid #21262d; border-radius: 6px; padding: 6px 8px; font-size: 11px; line-height: 1.5; overflow-x: auto; font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace; }}
  .card .restrictions {{ margin-top: 6px; font-size: 11px; }}
  .card .restrictions ul {{ list-style: none; padding: 0; }}
  .card .restrictions li {{ color: var(--text-dim); padding: 1px 0; padding-left: 10px; position: relative; }}
  .card .restrictions li::before {{ content: "\\2022"; position: absolute; left: 0; color: var(--warn); }}
  .kw {{ color: var(--keyword); font-weight: 500; }}
  .type {{ color: var(--type); }}
  .str {{ color: var(--string); }}
  .num {{ color: var(--number); }}
  .cmt {{ color: var(--comment); font-style: italic; }}

  /* Detail modal */
  .detail-panel {{
    display: none; position: fixed; top: 50%; left: 50%;
    width: 80%; max-width: 900px; max-height: 85vh;
    background: var(--surface); border: 1px solid var(--border);
    border-radius: 12px; z-index: 1000; overflow-y: auto;
    box-shadow: 0 20px 60px rgba(0,0,0,0.5);
  }}
  .detail-panel.open {{
    display: block;
    animation: modalIn 0.25s cubic-bezier(0.22, 1, 0.36, 1) forwards;
  }}
  @keyframes modalIn {{
    from {{ opacity: 0; transform: translate(-50%, -50%) scale(0.92); }}
    to   {{ opacity: 1; transform: translate(-50%, -50%) scale(1); }}
  }}
  .overlay {{
    display: none; position: fixed; top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.6); z-index: 999;
    backdrop-filter: blur(2px); -webkit-backdrop-filter: blur(2px);
  }}
  .overlay.open {{
    display: block;
    animation: overlayIn 0.2s ease forwards;
  }}
  @keyframes overlayIn {{
    from {{ opacity: 0; }}
    to {{ opacity: 1; }}
  }}
  .detail-panel.closing {{
    display: block;
    animation: modalOut 0.2s ease forwards;
  }}
  @keyframes modalOut {{
    from {{ opacity: 1; transform: translate(-50%, -50%) scale(1); }}
    to   {{ opacity: 0; transform: translate(-50%, -50%) scale(0.95); }}
  }}
  .overlay.closing {{
    display: block;
    animation: overlayOut 0.15s ease forwards;
  }}
  @keyframes overlayOut {{
    from {{ opacity: 1; }}
    to {{ opacity: 0; }}
  }}
  .detail-header {{ padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; background: var(--surface); z-index: 1; }}
  .detail-header .keyword {{ font-family: 'SF Mono', 'Fira Code', monospace; font-size: 20px; font-weight: 600; color: var(--keyword); }}
  .close-btn {{ background: none; border: none; color: var(--text-dim); font-size: 28px; cursor: pointer; padding: 0 4px; line-height: 1; }}
  .close-btn:hover {{ color: var(--text); }}
  .detail-body {{ padding: 20px; }}
  .detail-meta {{ margin-bottom: 16px; display: flex; gap: 8px; }}
  .detail-section {{ margin-bottom: 20px; }}
  .detail-section h3 {{ font-size: 14px; color: var(--accent); text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 8px; }}
  .detail-section h4 {{ font-size: 14px; color: var(--accent2); margin: 12px 0 4px; }}
  .detail-section p {{ color: var(--text); font-size: 14px; line-height: 1.6; }}
  .detail-section pre {{ background: #0d1117; border: 1px solid #21262d; border-radius: 6px; padding: 12px 14px; font-size: 13px; overflow-x: auto; font-family: 'SF Mono', 'Fira Code', monospace; line-height: 1.5; margin: 8px 0; }}
  .detail-section ul {{ padding-left: 20px; }}
  .detail-section li {{ color: var(--text-dim); margin: 4px 0; font-size: 13px; }}
  .ex-desc {{ color: var(--text-dim); font-size: 13px; font-style: italic; margin-top: 4px; }}

  .search-box {{ width: 100%; padding: 7px 10px; background: var(--bg); border: 1px solid var(--border); border-radius: 8px; color: var(--text); font-size: 13px; margin-bottom: 10px; outline: none; transition: border-color 0.2s; }}
  .search-box:focus {{ border-color: var(--accent); }}
  .search-box::placeholder {{ color: var(--text-dim); }}
  .nav-section-label {{ font-size: 10px; text-transform: uppercase; letter-spacing: 0.8px; color: var(--text-dim); margin: 12px 0 4px; font-weight: 600; }}

  /* Examples section */
  .examples-section {{
    margin: 40px 0;
    padding-top: 32px;
    border-top: 1px solid var(--border);
  }}
  .examples-tabs {{
    display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 16px;
  }}
  .example-tab {{
    padding: 7px 14px; border-radius: 8px; border: 1px solid var(--border);
    background: transparent; color: var(--text-dim); font-size: 12px;
    cursor: pointer; transition: all 0.15s; font-family: inherit;
  }}
  .example-tab:hover {{ background: rgba(88,166,255,0.08); color: var(--text); border-color: var(--accent); }}
  .example-tab.active {{ background: rgba(88,166,255,0.12); color: var(--accent); border-color: var(--accent); font-weight: 600; }}
  .example-panels {{ position: relative; }}
  .example-panel {{ display: none; }}
  .example-panel.show {{ display: block; animation: fadeInPanel 0.25s ease; }}
  .example-panel.leaving {{
    display: block;
    animation: fadeOutPanel 0.2s ease forwards;
  }}
  @keyframes fadeInPanel {{ from {{ opacity: 0; transform: translateY(8px); }} to {{ opacity: 1; transform: translateY(0); }} }}
  @keyframes fadeOutPanel {{ from {{ opacity: 1; transform: translateY(0); }} to {{ opacity: 0; transform: translateY(-6px); }} }}
  .example-panel-header {{
    display: flex; justify-content: space-between; align-items: flex-start;
    margin-bottom: 12px; gap: 12px;
  }}
  .example-panel-header h3 {{ font-size: 16px; color: var(--text); }}
  .example-panel-header p {{ color: var(--text-dim); font-size: 13px; margin-top: 4px; max-width: 600px; }}
  .example-meta {{ display: flex; gap: 6px; flex-shrink: 0; }}
  .example-meta .tag-badge {{ margin-left: 0; }}
  .example-code-wrap, .copy-wrap {{
    position: relative;
  }}
  .copy-btn {{
    position: absolute; top: 8px; right: 8px;
    padding: 4px 10px; border-radius: 6px;
    border: 1px solid var(--border);
    background: var(--surface);
    color: var(--text-dim); font-size: 11px;
    cursor: pointer; transition: all 0.15s;
    font-family: inherit; z-index: 1;
    opacity: 0; pointer-events: none;
  }}
  .example-code-wrap:hover .copy-btn, .copy-wrap:hover .copy-btn {{
    opacity: 1; pointer-events: auto;
  }}
  .copy-btn:hover {{
    background: rgba(88,166,255,0.12);
    color: var(--accent); border-color: var(--accent);
  }}
  .copy-btn.copied {{
    background: rgba(63,185,80,0.15);
    color: var(--accent2); border-color: var(--accent2);
  }}
  .example-code {{
    background: var(--ex-bg) !important;
    border: 1px solid #21262d; border-radius: 8px;
    padding: 16px 18px !important;
    font-size: 13px !important; line-height: 1.6 !important;
    overflow-x: auto; font-family: 'SF Mono', 'Fira Code', monospace;
    white-space: pre; tab-size: 6;
  }}

  /* Progress bar */
  .progress-bar {{
    position: fixed; top: 0; left: 0; height: 3px;
    background: linear-gradient(90deg, var(--accent), var(--accent2));
    z-index: 1001; transition: width 0.1s ease;
    width: 0%;
  }}

  @media (hover: none) {{
    .copy-btn {{ opacity: 1; pointer-events: auto; }}
  }}
  @media (max-width: 768px) {{
    .sidebar {{ width: 100%; height: auto; position: relative; padding: 14px; border-right: none; border-bottom: 1px solid var(--border); }}
    .main {{ margin-left: 0; padding: 16px; }}
    .card-grid {{ grid-template-columns: 1fr; }}
    .detail-panel {{ width: 95%; }}
    .example-panel-header {{ flex-direction: column; }}
  }}
</style>
</head>
<body>
<div class="progress-bar" id="progressBar"></div>
<div class="overlay" id="overlay" onclick="closeDetail()"></div>
<div class="wrapper">
  <nav class="sidebar">
    <div class="sidebar-header">
      <h1>TheFlux</h1>
      <div class="lang-toggle">{lang_selector}</div>
    </div>
    <p class="subtitle">{subtitle}</p>
    <input type="text" class="search-box" id="search" placeholder="{search_placeholder}" oninput="filterCards()">
    <div class="tag-filters">
      <button class="tag-filter tag-filter-all active" data-tag="all" onclick="setTagFilter('all')" style="--tag-color:var(--accent)">
        <span class="tag-dot" style="background:var(--accent)"></span>{filter_all_label} <span class="tag-count">{len(entries)}</span>
      </button>
      {tag_buttons}
      <button class="tag-filter tag-filter-examples" data-tag="examples" onclick="setTagFilter('examples')" style="--tag-color:var(--accent2)">
        <span class="tag-dot" style="background:var(--accent2)"></span>{filter_examples_label} <span class="tag-count">{len(EXAMPLES)}</span>
      </button>
    </div>
    <div id="nav-examples">
{nav_examples}
    </div>
    <div id="nav-list">
{nav_items}
    </div>
  </nav>
  <main class="main">
    <div class="hero">
      <h1>{hero_title}</h1>
      <p>{hero_desc}</p>
      <div class="stats">
        <div class="stat">{stat_total}: <span>{len(entries)}</span> entries</div>
        <div class="stat">{stat_categorias}: <span>{len(groups)}</span></div>
        <div class="stat">{stat_exemplos}: <span>{len(EXAMPLES)}</span></div>
      </div>
    </div>
    {cards_html}
    {examples_section}
  </main>
</div>
{detail_sections}
<script>
var activeTag = 'all';
var activeNavId = '';

function setTagFilter(tag) {{
  activeTag = tag;
  var buttons = document.querySelectorAll('.tag-filter');
  for (var i = 0; i < buttons.length; i++) {{
    var btn = buttons[i];
    btn.classList.toggle('active', btn.getAttribute('data-tag') === tag);
  }}
  filterCards();
}}

function updateProgressBar() {{
  var scrollTop = window.scrollY;
  var docHeight = document.documentElement.scrollHeight - window.innerHeight;
  var progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
  document.getElementById('progressBar').style.width = progress + '%';
}}

function updateScrollSpy() {{
  var sections = document.querySelectorAll('.category');
  var hero = document.querySelector('.hero');
  var examplesSection = document.getElementById('examples-section');
  var currentId = '';

  // Check hero first (top of page)
  if (hero) {{
    var heroBottom = hero.getBoundingClientRect().bottom;
    if (heroBottom > 60) {{ currentId = ''; }}
  }}

  // Check category sections
  if (!currentId) {{
    var closestSection = null;
    var closestDist = Infinity;
    sections.forEach(function(s) {{
      var rect = s.getBoundingClientRect();
      var dist = Math.abs(rect.top - 100);
      if (rect.top < window.innerHeight && rect.bottom > 100) {{
        if (dist < closestDist) {{
          closestDist = dist;
          closestSection = s;
        }}
      }}
    }});
    if (closestSection) {{ currentId = closestSection.id; }}
  }}

  // Check examples section
  if (examplesSection) {{
    var exRect = examplesSection.getBoundingClientRect();
    if (exRect.top < window.innerHeight && exRect.bottom > 100) {{
      currentId = 'examples-section';
    }}
  }}

  if (currentId !== activeNavId) {{
    activeNavId = currentId;
    document.querySelectorAll('.nav-item').forEach(function(item) {{
      var sid = item.getAttribute('href').substring(1);
      item.classList.toggle('active', sid === currentId);
    }});
  }}
}}

function onScroll() {{
  updateProgressBar();
  updateScrollSpy();
}}

// Throttled scroll handler
var scrollTimeout;
window.addEventListener('scroll', function() {{
  if (!scrollTimeout) {{
    scrollTimeout = setTimeout(function() {{
      scrollTimeout = null;
      onScroll();
    }}, 50);
  }}
}});

// Run once on load
window.addEventListener('load', function() {{ filterCards(); onScroll(); }});
window.addEventListener('resize', onScroll);

function filterCards() {{
  var q = document.getElementById('search').value.toLowerCase();
  var cards = document.querySelectorAll('.card');
  var sections = document.querySelectorAll('.category');
  var examplesSection = document.getElementById('examples-section');
  var navExamples = document.getElementById('nav-examples');
  var navList = document.getElementById('nav-list');

  if (activeTag === 'examples') {{
    // Show only the examples section
    cards.forEach(function(c) {{ c.style.display = 'none'; }});
    sections.forEach(function(s) {{ s.style.display = 'none'; }});
    if (examplesSection) examplesSection.style.display = '';
    if (navExamples) navExamples.style.display = '';
    if (navList) navList.style.display = 'none';
    onScroll();
    return;
  }}

  cards.forEach(function(c) {{
    var tagMatch = activeTag === 'all' || c.getAttribute('data-tag') === activeTag;
    c.style.display = (tagMatch && c.textContent.toLowerCase().includes(q)) ? '' : 'none';
  }});
  sections.forEach(function(s) {{
    var visible = false;
    var sc = s.querySelectorAll('.card');
    for (var i = 0; i < sc.length; i++) {{ if (sc[i].style.display !== 'none') {{ visible = true; break; }} }}
    s.style.display = visible ? '' : 'none';
  }});

  // Filter sidebar nav-items to match visible sections
  var navItems = document.querySelectorAll('#nav-list .nav-item');
  navItems.forEach(function(n) {{
    var sectionId = n.getAttribute('href').substring(1);
    var section = document.getElementById(sectionId);
    n.style.display = (section && section.style.display !== 'none') ? '' : 'none';
  }});

  // Show/hide examples section and nav
  if (examplesSection) {{
    examplesSection.style.display = (activeTag === 'all') ? '' : 'none';
  }}
  if (navExamples) {{
    navExamples.style.display = (activeTag === 'all') ? '' : 'none';
  }}
  if (navList) {{
    navList.style.display = '';
  }}

  // Re-run scroll spy after filtering
  onScroll();
}}
(function() {{
  var cards = document.querySelectorAll('.card');
  for (var i = 0; i < cards.length; i++) {{
    (function(card) {{
      card.addEventListener('click', function() {{
        if (closingDetail) return;
        var idx = card.getAttribute('data-index');
        var panel = document.getElementById('detail-' + idx);
        if (panel) {{ panel.classList.add('open'); document.getElementById('overlay').classList.add('open'); document.body.style.overflow = 'hidden'; }}
      }});
    }})(cards[i]);
  }}
}})();
var closingDetail = false;

function closeDetail() {{
  if (closingDetail) return;
  var panels = document.querySelectorAll('.detail-panel.open');
  if (panels.length === 0) return;
  closingDetail = true;
  var overlay = document.getElementById('overlay');
  panels.forEach(function(p) {{ p.classList.remove('open'); p.classList.add('closing'); }});
  if (overlay) {{ overlay.classList.remove('open'); overlay.classList.add('closing'); }}
}}

document.addEventListener('animationend', function(e) {{
  if (e.target.classList.contains('closing')) {{
    e.target.classList.remove('closing');
    if (e.target.classList.contains('detail-panel')) {{
      document.body.style.overflow = '';
      closingDetail = false;
    }}
  }}
}});
document.addEventListener('keydown', function(e) {{ if (e.key === 'Escape') closeDetail(); }});

var switchingExample = false;

function switchExample(id) {{
  if (switchingExample) return;
  var tabs = document.querySelectorAll('.example-tab');
  for (var i = 0; i < tabs.length; i++) {{
    tabs[i].classList.toggle('active', tabs[i].getAttribute('data-example') === id);
  }}
  var currentPanel = document.querySelector('.example-panel.show');
  var newPanel = document.getElementById('ex-' + id);
  if (!newPanel) return;
  if (currentPanel === newPanel) return;
  if (currentPanel) {{
    switchingExample = true;
    currentPanel.classList.remove('show');
    currentPanel.classList.add('leaving');
    var onEnd = function() {{
      currentPanel.removeEventListener('animationend', onEnd);
      currentPanel.classList.remove('leaving');
      newPanel.classList.add('show');
      switchingExample = false;
    }};
    currentPanel.addEventListener('animationend', onEnd);
  }} else {{
    newPanel.classList.add('show');
  }}
}}

function goToExample(id) {{
  switchExample(id);
  var section = document.getElementById('examples-section');
  if (section) {{
    section.scrollIntoView({{ behavior: 'smooth', block: 'start' }});
  }}
}}

function copyCode(panelId) {{
  var panel = document.getElementById(panelId);
  if (!panel) return;
  var codeEl = panel.querySelector('code');
  if (!codeEl) return;
  var text = codeEl.textContent || codeEl.innerText;
  if (navigator.clipboard && navigator.clipboard.writeText) {{
    navigator.clipboard.writeText(text).then(function() {{        var btn = panel.querySelector('.copy-btn');
      if (btn) {{
        btn.innerHTML = '{btn_copied}';
        btn.classList.add('copied');
        setTimeout(function() {{ btn.innerHTML = '{btn_copy}'; btn.classList.remove('copied'); }}, 2000);
      }}
    }}).catch(function() {{
      // clipboard write failed - do nothing
    }});
  }} else {{
    // Fallback for older browsers
    var ta = document.createElement('textarea');
    ta.value = text;
    ta.style.position = 'fixed';
    ta.style.opacity = '0';
    document.body.appendChild(ta);
    ta.select();
    try {{ document.execCommand('copy'); }} catch(e) {{}}
    document.body.removeChild(ta);
  }}
}}
</script>
</body>
</html>"""
    return html


def main():
    parser = argparse.ArgumentParser(description="Generate TheFlux documentation HTML")
    parser.add_argument("--lang", choices=["pt", "en"], default="pt",
                        help="Language: pt (Portuguese, default) or en (English)")
    args = parser.parse_args()

    global EXAMPLES
    if args.lang == "en":
        EXAMPLES = EXAMPLES_EN
    else:
        EXAMPLES = EXAMPLES_PT

    entries = load_all_yamls(args.lang)
    print(f"Carregados {len(entries)} arquivos YAML ({args.lang}).")
    html = build_html(entries, lang=args.lang)

    if args.lang == "en":
        output = OUTPUT_FILE_EN
    else:
        output = OUTPUT_FILE_PT

    with open(output, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"HTML gerado: {output}")
    print(f"Exemplos incluidos: {len(EXAMPLES)}")


if __name__ == "__main__":
    main()
