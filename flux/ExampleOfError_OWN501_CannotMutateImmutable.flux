#L EXPECT_ERROR: OWN501
program (Main) {
      imut as int64: TAXA = 10
      TAXA = 20
      print(TAXA)
}
