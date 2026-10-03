use ArchiveStdLib

program (ExampleOfUseArchiveStdLib_ArchiveManagementContract) {
      println("==================================================")
      println("  Exemplo: ArchiveStdLib Facade (ZIP, TAR e Binario)")
      println("==================================================")

      mut as string: fix_path = "archive_facade_fix.txt"
      writeBinaryFile(fix_path, "Conteudo para testar a fachada ArchiveStdLib!")

      #L 1. ZIP via ArchiveStdLib
      mut as string: zip_path = "facade_test.zip"
      mut as string: out_dir = "out_facade"
      mut as bool: z_ok = archiveZip(fix_path, zip_path)
      println("1. archiveZip via ArchiveStdLib: " + z_ok)

      mut as bool: unz_ok = archiveUnzip(zip_path, out_dir)
      println("2. archiveUnzip via ArchiveStdLib: " + unz_ok)

      mut as list of data: files = archiveListFiles(zip_path)
      println("3. archiveListFiles via ArchiveStdLib ok: " + (files[1] == "archive_facade_fix.txt"))

      #L 4. Leitura Binária
      mut as string: bin_read = readBinaryFile(fix_path)
      println("4. readBinaryFile via ArchiveStdLib: " + (bin_read == "Conteudo para testar a fachada ArchiveStdLib!"))

      #L Limpeza
      deleteFile(fix_path)
      deleteFile(zip_path)
      removeDir(out_dir)
}
