use CompilerLib

program (Inspect) {
      mut as string: code = "xs --> print\n"
      mut as list of data: toks = CompilerLib::lexerTokenize(code)
      mut as map: ts = CompilerLib::tokenStreamNew(toks)
      mut as map: ar = CompilerLib::astArenaNew()
      
      mut as map: s = CompilerLib::parseStatement(ts, ar)
      mut as map: s_ar = s["arena"]
      mut as map: n1 = CompilerLib::astArenaGetNode(s_ar, 1)
      print("Node 1: kind=" + n1["kind"] + " val=" + n1["val"] + " left=" + n1["left"] + " right=" + n1["right"])
}
