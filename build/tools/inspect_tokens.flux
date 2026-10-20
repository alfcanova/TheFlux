use CompilerLib

program (Inspect) {
      mut as string: src = stdIoReadFile("flux/ExampleOfPrint.flux")
      mut as list of data: toks = CompilerLib::lexerTokenize(src)
      mut as int64: n = stdCollectionLength(toks)
      mut as int64: i = 1
      infinite {
            route {
                  i > n ==> { break }
                  _ ==> {
                        mut as map: t = toks[i]
                        route {
                              t["line"] >= 15 and t["line"] <= 20 ==> {
                                    print("TOK line " + t["line"] + " col " + t["col"] + ": type=" + t["type"] + " val=" + t["val"])
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
}
