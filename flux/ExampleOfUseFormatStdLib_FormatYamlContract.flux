use FormatStdLib

program (ExampleOfUseFormatStdLib_FormatYamlContract) {
      println("==================================================")
      println("  Exemplo: FormatYamlContract (YAML 1.2 Completo)")
      println("==================================================")

      #L Documento com tipos Core Schema, ancoras, apelidos e merge keys
      mut as string: yaml_text = "default_config: &base\n  timeout: 30\n  retries: 3\nservidor:\n  <<: *base\n  host: 127.0.0.1\n  porta: 8080"
      mut as data: doc = formatParseYaml(yaml_text)
      println("1. Parse YAML (Anchors & Merge Key): " + doc)
      println("2. Stringify YAML: " + formatStringifyYaml(doc))

      #L Escalares de bloco (Literal |)
      mut as string: yaml_block = "descricao: |\n  Linha 1 do bloco\n  Linha 2 do bloco"
      mut as data: doc_block = formatParseYaml(yaml_block)
      println("3. Bloco Literal: " + doc_block)

      #L Multi-documentos (---)
      mut as string: yaml_multi = "---\napp: Frontend\n---\napp: Backend\nporta: 5000"
      mut as list of data: all_docs = formatParseYamlAll(yaml_multi)
      println("4. Multi-documentos: " + all_docs)
      println("5. Stringify All Docs: " + formatStringifyYamlAll(all_docs))
      println("6. Valido (yaml_text): " + formatIsValidYaml(yaml_text))
}
