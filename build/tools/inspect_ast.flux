use CompilerLib

program (Inspect) {
      mut as map: p = CompilerLib::parseFile("flux/ExampleOfPrint.flux")
      mut as map: arena = p["arena"]
      mut as int64: i = 66
      infinite {
            route {
                  i > 85 ==> { break }
                  _ ==> {
                        mut as map: n = CompilerLib::astArenaGetNode(arena, i)
                        print("Node " + i + ": kind=" + n["kind"] + " val=" + n["val"] + " left=" + n["left"] + " right=" + n["right"])
                        i = i + 1
                  }
            }
      }
}
