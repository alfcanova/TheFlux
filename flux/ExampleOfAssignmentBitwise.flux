program (ExampleOfAssignmentBitwise) {
      print("=== AssignmentBitwise: compostas bitwise ===")
      mut as int64: flags = 12
      flags =& 10
      print("flags =& 10: " + flags)
      mut as int64: valor = 12
      valor =| 10
      print("valor =| 10: " + valor)
      mut as int64: x = 12
      x =^ 10
      print("x =^ 10: " + x)
      mut as int64: shift = 3
      shift =<< 2
      print("shift =<< 2: " + shift)
      mut as int64: direita = 12
      direita =>> 2
      print("direita =>> 2: " + direita)
      mut as int64: zfill = -8
      zfill =>>> 1
      print("zfill =>>> 1: " + zfill)

      print("=== AssignmentBitwise: =~ ignora o RHS ===")
      mut as int64: alvo = 5
      alvo =~ 99
      print("alvo =~ 99 (alvo = ~alvo): " + alvo)
}