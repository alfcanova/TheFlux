use RandomStdLib

program (ExampleOfUseRandomStdLib_RandomUtilityContract) {
      println("==================================================")
      println("  Exemplo: RandomUtilityContract (6 Operacoes)")
      println("==================================================")

      mut as int64: state = randomLcgNew(42)

      #L 1. String com alfabeto customizado
      mut as string: vogais = "AEIOU"
      mut as list of data: p_str = randomString(state, 6, vogais)
      state = p_str[1] as int64
      println("1. randomString(6, 'AEIOU'): " + p_str[2])

      #L 2. Token alfanumerico (a-z, A-Z, 0-9)
      mut as list of data: p_token = randomAlphaNumeric(state, 12)
      state = p_token[1] as int64
      println("2. randomAlphaNumeric(12): " + p_token[2])

      #L 3. String Hexadecimal (0-9, a-f)
      mut as list of data: p_hex = randomHex(state, 8)
      state = p_hex[1] as int64
      println("3. randomHex(8): " + p_hex[2])

      #L 4. UUID v4 (Padrao RFC 4122)
      mut as list of data: p_uuid = randomUuidV4(state)
      state = p_uuid[1] as int64
      println("4. randomUuidV4: " + p_uuid[2])

      #L 5. Lista de inteiros aleatorios [min, max]
      mut as list of data: p_ints = randomIntList(state, 6, 10, 50)
      state = p_ints[1] as int64
      println("5. randomIntList(6 inteiros entre 10 e 50): " + p_ints[2])

      #L 6. Lista de floats aleatorios [0.0, 1.0)
      mut as list of data: p_floats = randomFloatList(state, 4)
      state = p_floats[1] as int64
      println("6. randomFloatList(4 floats): " + p_floats[2])
}
