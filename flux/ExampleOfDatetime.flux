program (ExampleOfDatetime) {
      print("=== Datetime: literal com nanossegundos ===")
      mut as datetime: epoca = 1970-01-01T00:00:00.000000000Z
      mut as datetime: agora = 2026-06-14T15:30:00.123456789Z
      print(epoca)
      print(agora)

      print("=== Datetime: offsets e fracao curta ===")
      mut as datetime: com_offset = 2024-01-01T12:30:00+03
      mut as datetime: offset_compacto = 2024-01-01T12:30:00+0300
      mut as datetime: offset_extenso = 2024-01-01T12:30:00.5-03:00
      print(com_offset)
      print(offset_compacto)
      print(offset_extenso)
}