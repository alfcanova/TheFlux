program (ExampleOfAssignmentArithmetic) {
      print("=== AssignmentArithmetic: atribuicao simples ===")
      mut as int64: contador = 5
      contador = 10
      print(contador)

      print("=== AssignmentArithmetic: compostas aritmeticas ===")
      mut as int64: soma = 2
      soma =+ 3
      print("soma =+ 3: " + soma)
      mut as int64: subtracao = 10
      subtracao =- 4
      print("subtracao =- 4: " + subtracao)
      mut as int64: multiplicacao = 3
      multiplicacao =* 7
      print("multiplicacao =* 7: " + multiplicacao)
      mut as int64: resto = 9
      resto =/r 4
      print("resto =/r 4: " + resto)
      mut as int64: potencia = 2
      potencia =^e 3
      print("potencia =^e 3: " + potencia)

      print("=== AssignmentArithmetic: atribuicao por indice ===")
      mut as list of int64: valores = [1, 2, 3]
      valores[1] = 15
      print(valores)
}