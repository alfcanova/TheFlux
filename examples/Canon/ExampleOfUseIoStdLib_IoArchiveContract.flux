use IoStdLib

program (ExampleOfUseIoStdLib_IoArchiveContract) {
      println("==================================================")
      println("  Exemplo: IoArchiveContract (18 Operacoes)")
      println("==================================================")

      #L Criar arquivo de fixture
      mut as string: fix_path = "archive_fixture.txt"
      writeFile(fix_path, "Conteudo arquivado pelo TheFlux IoArchiveContract!")

      #L 1. ZIP
      mut as string: zip_path = "teste_archive.zip"
      mut as string: out_zip_dir = "out_zip"
      mut as bool: z_ok = archiveZip(fix_path, zip_path)
      println("1. archiveZip: " + z_ok)
      mut as bool: unz_ok = archiveUnzip(zip_path, out_zip_dir)
      println("   archiveUnzip: " + unz_ok)

      #L 2. TAR
      mut as string: tar_path = "teste_archive.tar"
      mut as string: out_tar_dir = "out_tar"
      mut as bool: tar_ok = archiveTar(fix_path, tar_path)
      println("2. archiveTar: " + tar_ok)
      mut as bool: untar_ok = archiveExtractTar(tar_path, out_tar_dir)
      println("   archiveExtractTar: " + untar_ok)

      #L 3. TAR.GZ
      mut as string: targz_path = "teste_archive.tar.gz"
      mut as string: out_targz_dir = "out_targz"
      mut as bool: tgz_ok = archiveTarGz(fix_path, targz_path)
      println("3. archiveTarGz: " + tgz_ok)
      mut as bool: untgz_ok = archiveExtractTarGz(targz_path, out_targz_dir)
      println("   archiveExtractTarGz: " + untgz_ok)

      #L 4. TAR.BZ2
      mut as string: tarbz2_path = "teste_archive.tar.bz2"
      mut as string: out_tarbz2_dir = "out_tarbz2"
      mut as bool: tbz_ok = archiveTarBz2(fix_path, tarbz2_path)
      println("4. archiveTarBz2: " + tbz_ok)
      mut as bool: untbz_ok = archiveExtractTarBz2(tarbz2_path, out_tarbz2_dir)
      println("   archiveExtractTarBz2: " + untbz_ok)

      #L 5. TAR.XZ
      mut as string: tarxz_path = "teste_archive.tar.xz"
      mut as string: out_tarxz_dir = "out_tarxz"
      mut as bool: txz_ok = archiveTarXz(fix_path, tarxz_path)
      println("5. archiveTarXz: " + txz_ok)
      mut as bool: untxz_ok = archiveExtractTarXz(tarxz_path, out_tarxz_dir)
      println("   archiveExtractTarXz: " + untxz_ok)

      #L 6. TAR.ZST
      mut as string: tarzst_path = "teste_archive.tar.zst"
      mut as string: out_tarzst_dir = "out_tarzst"
      mut as bool: tzst_ok = archiveTarZst(fix_path, tarzst_path)
      println("6. archiveTarZst: " + tzst_ok)
      mut as bool: untzst_ok = archiveExtractTarZst(tarzst_path, out_tarzst_dir)
      println("   archiveExtractTarZst: " + untzst_ok)

      #L 7. 7-Zip (.7z)
      mut as string: sz_path = "teste_archive.7z"
      mut as string: out_7z_dir = "out_7z"
      mut as bool: sz_ok = archiveCreate7z(fix_path, sz_path)
      println("7. archiveCreate7z: " + sz_ok)
      mut as bool: unsz_ok = archiveExtract7z(sz_path, out_7z_dir)
      println("   archiveExtract7z: " + unsz_ok)

      #L 8. Inspecao e Extracao Parcial
      mut as bool: is_arc = archiveIsArchive(zip_path)
      println("8. archiveIsArchive: " + is_arc)
      mut as string: fmt_detected = archiveDetectFormat(zip_path)
      println("   archiveDetectFormat: " + fmt_detected)

      mut as list of data: files = archiveListFiles(zip_path)
      println("   archiveListFiles ok: " + (files[1] == "archive_fixture.txt"))

      mut as string: out_part_dir = "out_part"
      mut as bool: ext_file_ok = archiveExtractFile(zip_path, "archive_fixture.txt", out_part_dir)
      println("   archiveExtractFile: " + ext_file_ok)

      #L Limpeza
      deleteFile(fix_path)
      deleteFile(zip_path)
      deleteFile(tar_path)
      deleteFile(targz_path)
      deleteFile(tarbz2_path)
      deleteFile(tarxz_path)
      deleteFile(tarzst_path)
      deleteFile(sz_path)
      removeDir(out_zip_dir)
      removeDir(out_tar_dir)
      removeDir(out_targz_dir)
      removeDir(out_tarbz2_dir)
      removeDir(out_tarxz_dir)
      removeDir(out_tarzst_dir)
      removeDir(out_7z_dir)
      removeDir(out_part_dir)
}
