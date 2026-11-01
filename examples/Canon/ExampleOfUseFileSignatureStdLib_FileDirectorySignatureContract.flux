use FileSignatureStdLib
use IoStdLib

program (ExampleOfUseFileSignatureStdLib_FileDirectorySignatureContract) {
      println("==================================================")
      println("  Exemplo: FileDirectorySignatureContract (4 Operacoes)")
      println("==================================================")

      createDir("io_sig_test_dir")
      writeFile("io_sig_test_dir/arquivo.txt", "conteudo fixture io_stdlib\n")

      mut as list of data: sigs = fileSignDirectory("io_sig_test_dir")
      println("1. fileSignDirectory: " + sigs[1])

      mut as list of data: filt = fileFilterAndSign("io_sig_test_dir", ".txt")
      println("2. fileFilterAndSign: " + filt[1])

      mut as string: manifest = fileCreateManifest("io_sig_test_dir")
      println("3. fileCreateManifest != \"\": " + (manifest != ""))

      mut as string: manifest_line = "e9ba6c121ce3affa5e7a39baced4a502cc90ff1896d28acf562e26a28a054efa  arquivo.txt"
      println("4. fileChecksumManifest: " + fileChecksumManifest(manifest_line))

      deleteFile("io_sig_test_dir/arquivo.txt")
      removeDir("io_sig_test_dir")
}
