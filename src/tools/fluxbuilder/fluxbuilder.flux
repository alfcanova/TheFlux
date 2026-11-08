#L ==============================================================================
#L TheFlux Tool: fluxbuilder (v1.0.0)
#L Utilitario Nativo de Inicializacao, Scaffolding, Integracao e Estilizacao
#L ==============================================================================

function (builderPrintBanner) () as int64 {
      print("==============================================================================")
      print("       TheFlux Project Builder & Integrator (v1.0.0)")
      print("       Assistente Interativo de Criacao e Scaffolding de Projetos")
      print("==============================================================================")
      emit(nice, 0, "ok")
}

function (builderPrintHelp) () as int64 {
      print("fluxbuilder - Utilitario de Scaffolding, Integracao e Reparacao TheFlux (v1.0.0)")
      print("")
      print("Sintaxe:")
      print("  fluxbuilder [opcoes] [diretorio_alvo]")
      print("")
      print("Modos de Execucao:")
      print("  fluxbuilder                   Inicia o assistente interativo (Wizard) no diretorio atual")
      print("  fluxbuilder <NomeProjeto>     Cria um novo projeto na subpasta <NomeProjeto>")
      print("  fluxbuilder -r, --repair      Executa o Modo Reparo (idempotente) no diretorio alvo")
      print("  fluxbuilder -c, --doctor      Executa o diagnostico do ambiente TheFlux / Clang / Git")
      print("  fluxbuilder -h, --help        Exibe este manual de ajuda")
      print("  fluxbuilder -v, --version     Exibe a versao do utilitario")
      print("")
      print("Opcoes do Modo Nao-Interativo (aceitam '-' ou '--'):")
      print("  -n, --non-interactive         Executa sem perguntas interativas usando parametros passados")
      print("  -y, --yes                     Assume respostas padrao para todas as perguntas")
      print("  --name <nome>                 Nome unico do projeto (sera sanitizado/slugificado)")
      print("  --ver <versao>                Versao inicial do projeto (padrao: 1.0.0)")
      print("  --author <autor>              Nome do desenvolvedor / autor")
      print("  --email <email>               E-mail de contato do autor (validacao rigorosa com '@')")
      print("  --db <engine>                 Banco de dados: PostgreSQL, SQLite, MySQL ou None")
      print("  --link <modo>                 Modo de linkagem: Static ou Dynamic")
      print("  --pkgs <pacotes>              Lista de pacotes/dependencias iniciais")
      print("  --license <licenca>           Modelo de licenca: MIT, Apache-2.0, GPLv3 ou Proprietary")
      print("  --git <true|false>            Inicializar repositorio Git local")
      print("")
      print("Exemplos:")
      print("  fluxbuilder")
      print("  fluxbuilder MeuApp")
      print("  fluxbuilder --repair .")
      print("  fluxbuilder --doctor")
      print("  fluxbuilder -n --name api_gateway --email dev@corp.com --db PostgreSQL")
      emit(nice, 0, "ok")
}

function (builderPrintVersion) () as int64 {
      print("fluxbuilder version 1.0.0 (TheFlux Project Builder & Integrator)")
      emit(nice, 0, "ok")
}

function (builderTrimRight) (as string: s) as string {
      mut as int64: n = stdCollectionLength(s)
      infinite {
            route {
                  n < 1 ==> { break }
                  _ ==> {
                        mut as string: ch = s[n]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" or ch == "\n" ==> {
                                    n = n - 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      route {
            n < 1 ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, s[1..n], "ok") }
      }
}

function (builderTrimBoth) (as string: s) as string {
      mut as int64: n = stdCollectionLength(s)
      mut as int64: start_idx = 1
      infinite {
            route {
                  start_idx > n ==> { break }
                  _ ==> {
                        mut as string: ch = s[start_idx]
                        route {
                              ch == " " or ch == "\t" or ch == "\r" or ch == "\n" ==> {
                                    start_idx = start_idx + 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      mut as int64: end_idx = n
      infinite {
            route {
                  end_idx < start_idx ==> { break }
                  _ ==> {
                        mut as string: ch2 = s[end_idx]
                        route {
                              ch2 == " " or ch2 == "\t" or ch2 == "\r" or ch2 == "\n" ==> {
                                    end_idx = end_idx - 1
                              }
                              _ ==> { break }
                        }
                  }
            }
      }
      route {
            start_idx > end_idx ==> { emit(nice, "", "ok") }
            _ ==> { emit(nice, s[start_idx..end_idx], "ok") }
      }
}

function (builderValidateEmail) (as string: email) as bool {
      mut as int64: elen = stdCollectionLength(email)
      route {
            elen < 5 ==> { emit(nice, false, "ok") }
            _ ==> {}
      }
      mut as int64: at_count = 0
      mut as int64: at_pos = 0
      mut as int64: i = 1
      infinite {
            route {
                  i > elen ==> { break }
                  _ ==> {
                        mut as string: ch = email[i]
                        route {
                              ch == "@" ==> {
                                    at_count = at_count + 1
                                    at_pos = i
                              }
                              ch == " " or ch == "\t" or ch == "\r" or ch == "\n" ==> {
                                    emit(nice, false, "ok")
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
      route {
            at_count != 1 ==> { emit(nice, false, "ok") }
            at_pos <= 1 ==> { emit(nice, false, "ok") }
            at_pos >= elen - 2 ==> { emit(nice, false, "ok") }
            _ ==> {}
      }
      mut as string: domain = email[(at_pos + 1)..elen]
      mut as int64: dlen = stdCollectionLength(domain)
      mut as string: first_d = domain[1]
      mut as string: last_d = domain[dlen]
      route {
            first_d == "." or last_d == "." ==> { emit(nice, false, "ok") }
            _ ==> {}
      }
      mut as int64: dot_count = 0
      mut as int64: j = 1
      mut as bool: prev_dot = false
      infinite {
            route {
                  j > dlen ==> { break }
                  _ ==> {
                        mut as string: dch = domain[j]
                        route {
                              dch == "." ==> {
                                    route {
                                          prev_dot ==> { emit(nice, false, "ok") }
                                          _ ==> {}
                                    }
                                    dot_count = dot_count + 1
                                    prev_dot = true
                              }
                              _ ==> {
                                    prev_dot = false
                              }
                        }
                        j = j + 1
                  }
            }
      }
      route {
            dot_count < 1 ==> { emit(nice, false, "ok") }
            _ ==> { emit(nice, true, "ok") }
      }
}

function (builderIsAlphaNum) (as string: ch) as bool {
      mut as string: valid = "abcdefghijklmnopqrstuvwxyz0123456789"
      mut as int64: vlen = stdCollectionLength(valid)
      mut as int64: vi = 1
      infinite {
            route {
                  vi > vlen ==> { break }
                  valid[vi] == ch ==> { emit(nice, true, "ok") }
                  _ ==> { vi = vi + 1 }
            }
      }
      emit(nice, false, "ok")
}

function (builderSlugify) (as string: raw_name) as string {
      mut as int64: nlen = stdCollectionLength(raw_name)
      route {
            nlen == 0 ==> { emit(nice, "flux_app", "ok") }
            _ ==> {}
      }
      mut as string: out = ""
      mut as int64: i = 1
      mut as bool: prev_is_sep = false
      infinite {
            route {
                  i > nlen ==> { break }
                  _ ==> {
                        mut as string: ch = raw_name[i]
                        mut as string: low = ch
                        route {
                              ch == "A" ==> { low = "a" }
                              ch == "B" ==> { low = "b" }
                              ch == "C" ==> { low = "c" }
                              ch == "D" ==> { low = "d" }
                              ch == "E" ==> { low = "e" }
                              ch == "F" ==> { low = "f" }
                              ch == "G" ==> { low = "g" }
                              ch == "H" ==> { low = "h" }
                              ch == "I" ==> { low = "i" }
                              ch == "J" ==> { low = "j" }
                              ch == "K" ==> { low = "k" }
                              ch == "L" ==> { low = "l" }
                              ch == "M" ==> { low = "m" }
                              ch == "N" ==> { low = "n" }
                              ch == "O" ==> { low = "o" }
                              ch == "P" ==> { low = "p" }
                              ch == "Q" ==> { low = "q" }
                              ch == "R" ==> { low = "r" }
                              ch == "S" ==> { low = "s" }
                              ch == "T" ==> { low = "t" }
                              ch == "U" ==> { low = "u" }
                              ch == "V" ==> { low = "v" }
                              ch == "W" ==> { low = "w" }
                              ch == "X" ==> { low = "x" }
                              ch == "Y" ==> { low = "y" }
                              ch == "Z" ==> { low = "z" }
                              _ ==> {}
                        }
                        route {
                              builderIsAlphaNum(low) ==> {
                                    out = out + low
                                    prev_is_sep = false
                              }
                              low == "-" or low == "_" ==> {
                                    route {
                                          not prev_is_sep and stdCollectionLength(out) > 0 ==> {
                                                out = out + low
                                                prev_is_sep = true
                                          }
                                          _ ==> {}
                                    }
                              }
                              low == " " or low == "/" or low == "\\" or low == ":" or low == "." ==> {
                                    route {
                                          not prev_is_sep and stdCollectionLength(out) > 0 ==> {
                                                out = out + "_"
                                                prev_is_sep = true
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
      }
      route {
            stdCollectionLength(out) == 0 ==> { emit(nice, "flux_app", "ok") }
            _ ==> { emit(nice, out, "ok") }
      }
}

function (builderToPascalCase) (as string: slug) as string {
      mut as int64: slen = stdCollectionLength(slug)
      route {
            slen == 0 ==> { emit(nice, "App", "ok") }
            _ ==> {}
      }
      mut as string: out = ""
      mut as bool: cap_next = true
      mut as int64: i = 1
      infinite {
            route {
                  i > slen ==> { break }
                  _ ==> {
                        mut as string: ch = slug[i]
                        route {
                              ch == "_" or ch == "-" ==> {
                                    cap_next = true
                              }
                              _ ==> {
                                    mut as string: c = ch
                                    route {
                                          cap_next ==> {
                                                route {
                                                      ch == "a" ==> { c = "A" }
                                                      ch == "b" ==> { c = "B" }
                                                      ch == "c" ==> { c = "C" }
                                                      ch == "d" ==> { c = "D" }
                                                      ch == "e" ==> { c = "E" }
                                                      ch == "f" ==> { c = "F" }
                                                      ch == "g" ==> { c = "G" }
                                                      ch == "h" ==> { c = "H" }
                                                      ch == "i" ==> { c = "I" }
                                                      ch == "j" ==> { c = "J" }
                                                      ch == "k" ==> { c = "K" }
                                                      ch == "l" ==> { c = "L" }
                                                      ch == "m" ==> { c = "M" }
                                                      ch == "n" ==> { c = "N" }
                                                      ch == "o" ==> { c = "O" }
                                                      ch == "p" ==> { c = "P" }
                                                      ch == "q" ==> { c = "Q" }
                                                      ch == "r" ==> { c = "R" }
                                                      ch == "s" ==> { c = "S" }
                                                      ch == "t" ==> { c = "T" }
                                                      ch == "u" ==> { c = "U" }
                                                      ch == "v" ==> { c = "V" }
                                                      ch == "w" ==> { c = "W" }
                                                      ch == "x" ==> { c = "X" }
                                                      ch == "y" ==> { c = "Y" }
                                                      ch == "z" ==> { c = "Z" }
                                                      _ ==> {}
                                                }
                                                cap_next = false
                                          }
                                          _ ==> {}
                                    }
                                    out = out + c
                              }
                        }
                        i = i + 1
                  }
            }
      }
      route {
            stdCollectionLength(out) == 0 ==> { emit(nice, "App", "ok") }
            _ ==> { emit(nice, out, "ok") }
      }
}

function (builderGetDateInfo) () as map {
      mut as int64: now_ns = stdDatetimeNow()
      mut as string: iso_date = ""
      mut as string: year_str = ""

      route {
            now_ns > 0 ==> {
                  mut as int64: sec = now_ns /i 1000000000
                  mut as int64: days = sec /i 86400
                  mut as int64: z = days + 719468
                  mut as int64: era = z /i 146097
                  mut as int64: doe = z - era * 146097
                  mut as int64: yoe = (doe - doe /i 1460 + doe /i 36524 - doe /i 146096) /i 365
                  mut as int64: y = yoe + era * 400
                  mut as int64: doy = doe - (365 * yoe + yoe /i 4 - yoe /i 100)
                  mut as int64: mp = (5 * doy + 2) /i 153
                  mut as int64: d = doy - (153 * mp + 2) /i 5 + 1
                  mut as int64: m = mp + 3
                  route {
                        mp >= 10 ==> { m = mp - 9 }
                        _ ==> {}
                  }
                  mut as int64: year = y
                  route {
                        m <= 2 ==> { year = y + 1 }
                        _ ==> {}
                  }
                  mut as string: m_str = "" + m
                  route {
                        m < 10 ==> { m_str = "0" + m }
                        _ ==> {}
                  }
                  mut as string: d_str = "" + d
                  route {
                        d < 10 ==> { d_str = "0" + d }
                        _ ==> {}
                  }
                  iso_date = "" + year + "-" + m_str + "-" + d_str
                  year_str = "" + year
            }
            _ ==> {
                  #L Fallback dinamico via OS shell se stdDatetimeNow nao estiver despachado
                  mut as string: cmd = "powershell -NoProfile -Command (Get-Date -Format 'yyyy-MM-dd')"
                  route {
                        stdIoDirExists("/dev") ==> { cmd = "date +%Y-%m-%d" }
                        _ ==> {}
                  }
                  mut as string: raw_out = builderTrimBoth(stdOsExecOutput(cmd))
                  route {
                        stdCollectionLength(raw_out) >= 10 ==> {
                              iso_date = raw_out[1..10]
                              year_str = raw_out[1..4]
                        }
                        _ ==> {
                              iso_date = "2026-11-08"
                              year_str = "2026"
                        }
                  }
            }
      }

      mut as map: res = map{}
      res["year"] = year_str
      res["date"] = iso_date
      emit(nice, res, "ok")
}

function (builderMkdirAll) (as string: path) as int64 {
      route {
            path == "" or path == "." or stdIoDirExists(path) ==> {
                  emit(nice, 1, "ok")
            }
            _ ==> {}
      }
      route {
            stdIoDirExists("/dev") ==> {
                  stdOsExec("mkdir -p \"" + path + "\" >/dev/null 2>&1")
                  emit(nice, 1, "ok")
            }
            _ ==> {
                  mut as int64: plen = stdCollectionLength(path)
                  mut as string: win_p = ""
                  mut as int64: i = 1
                  infinite {
                        route {
                              i > plen ==> { break }
                              _ ==> {
                                    mut as string: ch = path[i]
                                    route {
                                          ch == "/" ==> { win_p = win_p + "\\" }
                                          _ ==> { win_p = win_p + ch }
                                    }
                                    i = i + 1
                              }
                        }
                  }
                  stdOsExec("cmd /c if not exist \"" + win_p + "\" mkdir \"" + win_p + "\" >nul 2>&1")
                  emit(nice, 1, "ok")
            }
      }
}

function (builderWriteFileSafe) (as string: path, as string: content, as bool: overwrite) as int64 {
      route {
            stdIoFileExists(path) and (not overwrite) ==> {
                  emit(nice, 0, "ok")
            }
            _ ==> {
                  stdIoWriteFile(path, content)
                  emit(nice, 1, "ok")
            }
      }
}

function (builderTrimQuotes) (as string: s) as string {
      mut as string: trimmed = builderTrimBoth(s)
      mut as int64: tlen = stdCollectionLength(trimmed)
      route {
            tlen >= 2 ==> {
                  mut as string: c1 = trimmed[1]
                  mut as string: c2 = trimmed[tlen]
                  route {
                        (c1 == "\"" and c2 == "\"") or (c1 == "'" and c2 == "'") ==> {
                              emit(nice, trimmed[2..(tlen - 1)], "ok")
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }
      emit(nice, trimmed, "ok")
}

function (builderParseYamlLine) (as string: line, as string: key) as string {
      mut as string: tr = builderTrimBoth(line)
      mut as int64: tlen = stdCollectionLength(tr)
      mut as int64: klen = stdCollectionLength(key)
      route {
            tlen <= klen + 1 ==> { emit(nice, "", "ok") }
            _ ==> {}
      }
      mut as string: head = tr[1..klen]
      mut as string: sep = tr[(klen + 1)..(klen + 1)]
      route {
            head == key and sep == ":" ==> {
                  mut as string: raw_val = tr[(klen + 2)..tlen]
                  emit(nice, builderTrimQuotes(raw_val), "ok")
            }
            _ ==> {
                  emit(nice, "", "ok")
            }
      }
}

function (builderExtractYamlValue) (as string: content, as string: key) as string {
      mut as int64: clen = stdCollectionLength(content)
      mut as int64: i = 1
      mut as string: line = ""
      infinite {
            route {
                  i > clen ==> {
                        route {
                              stdCollectionLength(line) > 0 ==> {
                                    mut as string: val = builderParseYamlLine(line, key)
                                    route {
                                          val != "" ==> { emit(nice, val, "ok") }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        break
                  }
                  _ ==> {
                        mut as string: ch = content[i]
                        route {
                              ch == "\n" or ch == "\r" ==> {
                                    mut as string: val = builderParseYamlLine(line, key)
                                    route {
                                          val != "" ==> { emit(nice, val, "ok") }
                                          _ ==> {}
                                    }
                                    line = ""
                              }
                              _ ==> {
                                    line = line + ch
                              }
                        }
                        i = i + 1
                  }
            }
      }
      emit(nice, "", "ok")
}

function (builderGenerateManifestYaml) (as string: name, as string: version, as string: author, as string: email, as string: db_engine, as string: link_mode, as bool: git_init, as string: pkgs, as string: license_type, as string: year, as string: date_iso) as string {
      mut as int64: port = 5432
      route {
            db_engine == "MySQL" ==> { port = 3306 }
            db_engine == "SQLite" or db_engine == "None" ==> { port = 0 }
            _ ==> {}
      }
      mut as string: git_s = "false"
      route {
            git_init ==> { git_s = "true" }
            _ ==> {}
      }
      mut as string: out = "#L ==============================================================================\n"
      out = out + "#L TheFlux Project Infrastructure Manifest\n"
      out = out + "#L Generated by fluxbuilder v1.0.0\n"
      out = out + "#L ==============================================================================\n\n"
      out = out + "project:\n"
      out = out + "  name: \"" + name + "\"\n"
      out = out + "  version: \"" + version + "\"\n"
      out = out + "  description: \"Projeto TheFlux gerado via fluxbuilder\"\n"
      out = out + "  created_at: \"" + date_iso + "\"\n\n"
      out = out + "author:\n"
      out = out + "  name: \"" + author + "\"\n"
      out = out + "  email: \"" + email + "\"\n\n"
      out = out + "infrastructure:\n"
      out = out + "  database:\n"
      out = out + "    engine: \"" + db_engine + "\"\n"
      out = out + "    host: \"localhost\"\n"
      out = out + "    port: " + port + "\n"
      out = out + "    name: \"" + name + "_db\"\n"
      out = out + "  linking:\n"
      out = out + "    mode: \"" + link_mode + "\"\n"
      out = out + "  git:\n"
      out = out + "    initialized: " + git_s + "\n\n"
      out = out + "ecosystem:\n"
      out = out + "  packages:\n"
      out = out + "    - \"" + pkgs + "\"\n\n"
      out = out + "license:\n"
      out = out + "  type: \"" + license_type + "\"\n"
      out = out + "  holder: \"" + author + "\"\n"
      out = out + "  year: " + year + "\n"
      emit(nice, out, "ok")
}

function (builderGenerateVsCodeSettings) () as string {
      mut as string: out = "{\n"
      out = out + "      \"editor.tabSize\": 6,\n"
      out = out + "      \"editor.insertSpaces\": true,\n"
      out = out + "      \"editor.detectIndentation\": false,\n"
      out = out + "      \"files.trimTrailingWhitespace\": true,\n"
      out = out + "      \"files.insertFinalNewline\": true,\n"
      out = out + "      \"editor.tokenColorCustomizations\": {\n"
      out = out + "            \"textMateRules\": [\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Mutable Variables (mut)\",\n"
      out = out + "                        \"scope\": [\"variable.other.readwrite.flux\", \"storage.modifier.mut.flux\", \"keyword.declaration.mut.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#FF6B6B\",\n"
      out = out + "                              \"background\": \"#3B1A1E\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Immutable Constants (imut)\",\n"
      out = out + "                        \"scope\": [\"variable.other.constant.flux\", \"storage.modifier.imut.flux\", \"keyword.declaration.imut.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#4ECCA3\",\n"
      out = out + "                              \"background\": \"#183324\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux High-level Architecture (contract, agent, impl)\",\n"
      out = out + "                        \"scope\": [\"storage.type.contract.flux\", \"storage.type.agent.flux\", \"storage.type.impl.flux\", \"entity.name.type.class.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#C792EA\",\n"
      out = out + "                              \"background\": \"#2E1C38\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Program & Functions (program, function)\",\n"
      out = out + "                        \"scope\": [\"entity.name.function.flux\", \"keyword.control.program.flux\", \"keyword.control.function.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#82AAFF\",\n"
      out = out + "                              \"background\": \"#1A2744\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Operations (op)\",\n"
      out = out + "                        \"scope\": [\"entity.name.function.op.flux\", \"keyword.control.op.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#00E5FF\",\n"
      out = out + "                              \"background\": \"#103344\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Routing & Control (route, match)\",\n"
      out = out + "                        \"scope\": [\"keyword.control.route.flux\", \"keyword.control.match.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#FFCB6B\",\n"
      out = out + "                              \"background\": \"#382F18\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Flow Arrow (==>)\",\n"
      out = out + "                        \"scope\": [\"keyword.operator.flow.flux\", \"keyword.operator.arrow.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#00FFFF\",\n"
      out = out + "                              \"background\": \"#0A333A\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Loops (infinite, break, continue)\",\n"
      out = out + "                        \"scope\": [\"keyword.control.loop.flux\", \"keyword.control.break.flux\", \"keyword.control.continue.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#FF9580\",\n"
      out = out + "                              \"background\": \"#36201B\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Signals (emit)\",\n"
      out = out + "                        \"scope\": [\"keyword.control.emit.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#F78C6C\",\n"
      out = out + "                              \"background\": \"#35211B\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Channel Outcomes (nice)\",\n"
      out = out + "                        \"scope\": [\"constant.language.channel.nice.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#A8FFB2\",\n"
      out = out + "                              \"background\": \"#193822\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Failure Channel (fail)\",\n"
      out = out + "                        \"scope\": [\"constant.language.channel.fail.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#FF8585\",\n"
      out = out + "                              \"background\": \"#3D1B1E\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Type Connectors (as, of, in)\",\n"
      out = out + "                        \"scope\": [\"keyword.operator.as.flux\", \"keyword.operator.of.flux\", \"keyword.operator.in.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#B2CCD6\",\n"
      out = out + "                              \"background\": \"#202A36\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Logic Operators (and, or, not)\",\n"
      out = out + "                        \"scope\": [\"keyword.operator.logical.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#89DDFF\",\n"
      out = out + "                              \"background\": \"#1B2D38\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Ownership & Borrowing (keep, borrow, borrow_mut, copy, move)\",\n"
      out = out + "                        \"scope\": [\"keyword.operator.ownership.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#FFB454\",\n"
      out = out + "                              \"background\": \"#382815\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Concurrency & System (unsafe, comptime, async, await, spawn, spy)\",\n"
      out = out + "                        \"scope\": [\"keyword.control.async.flux\", \"keyword.control.system.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#E06C75\",\n"
      out = out + "                              \"background\": \"#351D24\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Modules & Data (use, struct, enum)\",\n"
      out = out + "                        \"scope\": [\"keyword.control.import.flux\", \"storage.type.struct.flux\", \"storage.type.enum.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#C3E88D\",\n"
      out = out + "                              \"background\": \"#21331B\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux IO Builtins (print, input)\",\n"
      out = out + "                        \"scope\": [\"support.function.builtin.io.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#80CBC4\",\n"
      out = out + "                              \"background\": \"#1B3230\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Wildcard (_)\",\n"
      out = out + "                        \"scope\": [\"constant.language.wildcard.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#D19A66\",\n"
      out = out + "                              \"background\": \"#30241A\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Arithmetic Operators (/i, /r, /f, %)\",\n"
      out = out + "                        \"scope\": [\"keyword.operator.arithmetic.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#E5C07B\",\n"
      out = out + "                              \"background\": \"#382E19\"\n"
      out = out + "                        }\n"
      out = out + "                  },\n"
      out = out + "                  {\n"
      out = out + "                        \"name\": \"TheFlux Comments (#L, #B, #D)\",\n"
      out = out + "                        \"scope\": [\"comment.line.flux\", \"comment.block.flux\"],\n"
      out = out + "                        \"settings\": {\n"
      out = out + "                              \"foreground\": \"#7F848E\",\n"
      out = out + "                              \"fontStyle\": \"italic\",\n"
      out = out + "                              \"background\": \"#1C2026\"\n"
      out = out + "                        }\n"
      out = out + "                  }\n"
      out = out + "            ]\n"
      out = out + "      }\n"
      out = out + "}\n"
      emit(nice, out, "ok")
}

function (builderGenerateReadme) (as string: name, as string: version, as string: author, as string: email, as string: db_engine, as string: link_mode, as string: license_type, as string: year) as string {
      mut as string: out = "# " + name + "\n\n"
      out = out + "> Versão: **" + version + "** | Licença: **" + license_type + "** | Ano: **" + year + "**\n\n"
      out = out + "Projeto desenvolvido na linguagem **TheFlux**, utilizando arquitetura orientada a fluxos de dados, contratos semânticos e tipagem estrita com compilação nativa.\n\n"
      out = out + "## Arquitetura de Diretórios Canônica\n\n"
      out = out + "| Subpasta | Descrição | Papel no Ciclo de Vida |\n"
      out = out + "|---|---|---|\n"
      out = out + "| `📁 bin/` | Binários compilados | Ignorado pelo Git (`.gitignore` local) para evitar envio de artefatos pesados |\n"
      out = out + "| `📁 lib/` | Bibliotecas e linkagem | Registra formalmente a diretriz de linkagem (`" + link_mode + "`) |\n"
      out = out + "| `📁 db/` | Banco de Dados | Esquema e definições SQL pré-configuradas para engine `" + db_engine + "` |\n"
      out = out + "| `📁 doc/` | Documentação | Manuais de engenharia, diagramas e notas de arquitetura |\n"
      out = out + "| `📁 pkg/` | Pacotes e Dependências | Manifesto legível de bibliotecas associadas do ecossistema |\n"
      out = out + "| `📁 tmp/` | Temporários | Pasta rastreada via `.gitkeep`, ignorando caches e logs locais |\n"
      out = out + "| `📁 flux/` | Pipelines de Fluxo | Espaço dedicado para orquestração e fluxos de processos |\n"
      out = out + "| `📁 fdsl/` | Contratos FDSL | Definições formais de Contratos (`contract`) e Agentes (`agent`) |\n\n"
      out = out + "## Como Compilar e Executar\n\n"
      out = out + "O projeto inclui scripts de automação de compilação prontos:\n\n"
      out = out + "### Windows:\n"
      out = out + "```cmd\n"
      out = out + "scripts\\build.bat\n"
      out = out + "bin\\" + name + ".exe\n"
      out = out + "```\n\n"
      out = out + "### Linux / macOS:\n"
      out = out + "```bash\n"
      out = out + "chmod +x scripts/build.sh\n"
      out = out + "./scripts/build.sh\n"
      out = out + "./bin/" + name + "\n"
      out = out + "```\n\n"
      out = out + "## Autoria e Suporte\n\n"
      out = out + "- **Desenvolvedor:** " + author + "\n"
      out = out + "- **E-mail de Contato:** [" + email + "](mailto:" + email + ")\n"
      out = out + "- **Infraestrutura:** Registrada formalmente no manifesto `project_config.yaml`.\n"
      emit(nice, out, "ok")
}

function (builderGenerateLicense) (as string: license_type, as string: author, as string: year) as string {
      mut as string: out = ""
      route {
            license_type == "Apache-2.0" ==> {
                  out = "                                 Apache License\n"
                  out = out + "                           Version 2.0, January 2004\n"
                  out = out + "                        http://www.apache.org/licenses/\n\n"
                  out = out + "   Copyright " + year + " " + author + "\n\n"
                  out = out + "   Licensed under the Apache License, Version 2.0 (the \"License\");\n"
                  out = out + "   you may not use this file except in compliance with the License.\n"
                  out = out + "   You may obtain a copy of the License at\n\n"
                  out = out + "       http://www.apache.org/licenses/LICENSE-2.0\n\n"
                  out = out + "   Unless required by applicable law or agreed to in writing, software\n"
                  out = out + "   distributed under the License is distributed on an \"AS IS\" BASIS,\n"
                  out = out + "   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n"
                  out = out + "   See the License for the specific language governing permissions and\n"
                  out = out + "   limitations under the License.\n"
            }
            license_type == "GPLv3" ==> {
                  out = "                    GNU GENERAL PUBLIC LICENSE\n"
                  out = out + "                       Version 3, 29 June 2007\n\n"
                  out = out + " Copyright (C) " + year + " " + author + "\n\n"
                  out = out + " Everyone is permitted to copy and distribute verbatim copies\n"
                  out = out + " of this license document, but changing it is not allowed.\n\n"
                  out = out + " This program is free software: you can redistribute it and/or modify\n"
                  out = out + " it under the terms of the GNU General Public License as published by\n"
                  out = out + " the Free Software Foundation, either version 3 of the License, or\n"
                  out = out + " (at your option) any later version.\n\n"
                  out = out + " This program is distributed in the hope that it will be useful,\n"
                  out = out + " but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
                  out = out + " MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
                  out = out + " GNU General Public License for more details.\n"
            }
            license_type == "Proprietary" ==> {
                  out = "PROPRIETARY AND CONFIDENTIAL LICENSE\n\n"
                  out = out + "Copyright (c) " + year + " " + author + ". All rights reserved.\n\n"
                  out = out + "This software and its documentation are confidential and proprietary to\n"
                  out = out + author + ". Unauthorized copying, modification, distribution, or decompilation\n"
                  out = out + "of this software, via any medium, is strictly prohibited.\n"
            }
            _ ==> {
                  out = "MIT License\n\n"
                  out = out + "Copyright (c) " + year + " " + author + "\n\n"
                  out = out + "Permission is hereby granted, free of charge, to any person obtaining a copy\n"
                  out = out + "of this software and associated documentation files (the \"Software\"), to deal\n"
                  out = out + "in the Software without restriction, including without limitation the rights\n"
                  out = out + "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n"
                  out = out + "copies of the Software, and to permit persons to whom the Software is\n"
                  out = out + "furnished to do so, subject to the following conditions:\n\n"
                  out = out + "The above copyright notice and this permission notice shall be included in all\n"
                  out = out + "copies or substantial portions of the Software.\n\n"
                  out = out + "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n"
                  out = out + "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n"
                  out = out + "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n"
                  out = out + "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n"
                  out = out + "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n"
                  out = out + "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n"
                  out = out + "SOFTWARE.\n"
            }
      }
      emit(nice, out, "ok")
}

function (builderGenerateEnvExample) (as string: name, as string: version, as string: db_engine) as string {
      mut as int64: port = 5432
      route {
            db_engine == "MySQL" ==> { port = 3306 }
            db_engine == "SQLite" or db_engine == "None" ==> { port = 0 }
            _ ==> {}
      }
      mut as string: out = "#L ==============================================================================\n"
      out = out + "#L Modelo de Variaveis de Ambiente: " + name + "\n"
      out = out + "#L ==============================================================================\n\n"
      out = out + "APP_ENV=development\n"
      out = out + "APP_NAME=" + name + "\n"
      out = out + "APP_VERSION=" + version + "\n\n"
      out = out + "# Configuracao do Banco de Dados (" + db_engine + ")\n"
      out = out + "DB_ENGINE=" + db_engine + "\n"
      out = out + "DB_HOST=localhost\n"
      out = out + "DB_PORT=" + port + "\n"
      out = out + "DB_NAME=" + name + "_db\n"
      out = out + "DB_USER=flux_user\n"
      out = out + "DB_PASSWORD=flux_secret_password\n"
      emit(nice, out, "ok")
}

function (builderGenerateGitignore) () as string {
      mut as string: out = "# TheFlux Project Root Gitignore\n\n"
      out = out + "# Segredos e credenciais locais\n"
      out = out + ".env\n"
      out = out + ".env.local\n"
      out = out + "*.secret\n\n"
      out = out + "# Arquivos temporarios e caches\n"
      out = out + "*.tmp\n"
      out = out + "*.log\n"
      out = out + "tmp/*\n"
      out = out + "!tmp/.gitignore\n"
      out = out + "!tmp/.gitkeep\n\n"
      out = out + "# Binarios compilados na raiz\n"
      out = out + "bin/*\n"
      out = out + "!bin/.gitignore\n"
      emit(nice, out, "ok")
}

function (builderGenerateEditorConfig) () as string {
      mut as string: out = "# EditorConfig - TheFlux Canonical Style Standard\n"
      out = out + "root = true\n\n"
      out = out + "[*]\n"
      out = out + "charset = utf-8\n"
      out = out + "end_of_line = lf\n"
      out = out + "insert_final_newline = true\n"
      out = out + "trim_trailing_whitespace = true\n\n"
      out = out + "[*.{flux,fdsl}]\n"
      out = out + "indent_style = space\n"
      out = out + "indent_size = 6\n"
      emit(nice, out, "ok")
}

function (builderGenerateBinGitignore) () as string {
      mut as string: out = "# Ignorar todos os binarios gerados na pasta bin\n"
      out = out + "*\n"
      out = out + "!.gitignore\n"
      emit(nice, out, "ok")
}

function (builderGenerateLibLinkingMode) (as string: link_mode) as string {
      mut as string: out = "# TheFlux Linking Mode Configuration\n"
      out = out + "LINKING_MODE=" + link_mode + "\n"
      out = out + "# Static:  Vinculacao estatica de arquivos .a / .lib no executavel\n"
      out = out + "# Dynamic: Vinculacao dinamica modular via bibliotecas compartilhadas (.dll / .so)\n"
      emit(nice, out, "ok")
}

function (builderGenerateDbSchema) (as string: name, as string: db_engine) as string {
      mut as string: out = ""
      route {
            db_engine == "SQLite" ==> {
                  out = "-- TheFlux Schema Template: SQLite\n"
                  out = out + "-- Database: " + name + ".db\n\n"
                  out = out + "CREATE TABLE IF NOT EXISTS tb_flux_entity (\n"
                  out = out + "    id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                  out = out + "    uuid TEXT NOT NULL UNIQUE,\n"
                  out = out + "    nome TEXT NOT NULL,\n"
                  out = out + "    dados TEXT DEFAULT '{}',\n"
                  out = out + "    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP\n"
                  out = out + ");\n\n"
                  out = out + "CREATE INDEX IF NOT EXISTS idx_flux_entity_uuid ON tb_flux_entity (uuid);\n"
            }
            db_engine == "MySQL" ==> {
                  out = "-- TheFlux Schema Template: MySQL\n"
                  out = out + "-- Database: " + name + "_db\n\n"
                  out = out + "CREATE TABLE IF NOT EXISTS tb_flux_entity (\n"
                  out = out + "    id BIGINT AUTO_INCREMENT PRIMARY KEY,\n"
                  out = out + "    uuid VARCHAR(64) NOT NULL UNIQUE,\n"
                  out = out + "    nome VARCHAR(255) NOT NULL,\n"
                  out = out + "    dados JSON,\n"
                  out = out + "    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP\n"
                  out = out + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n"
                  out = out + "CREATE INDEX idx_flux_entity_uuid ON tb_flux_entity (uuid);\n"
            }
            db_engine == "None" ==> {
                  out = "-- TheFlux Schema Template: Nenhum Banco de Dados Configurado\n"
                  out = "-- Insira definicoes SQL ou scripts DDL quando necessario.\n"
            }
            _ ==> {
                  out = "-- TheFlux Schema Template: PostgreSQL\n"
                  out = out + "-- Database: " + name + "_db\n\n"
                  out = out + "CREATE TABLE IF NOT EXISTS tb_flux_entity (\n"
                  out = out + "    id BIGSERIAL PRIMARY KEY,\n"
                  out = out + "    uuid VARCHAR(64) NOT NULL UNIQUE,\n"
                  out = out + "    nome VARCHAR(255) NOT NULL,\n"
                  out = out + "    dados JSONB DEFAULT '{}',\n"
                  out = out + "    criado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP\n"
                  out = out + ");\n\n"
                  out = out + "CREATE INDEX IF NOT EXISTS idx_flux_entity_uuid ON tb_flux_entity (uuid);\n"
            }
      }
      emit(nice, out, "ok")
}

function (builderGenerateDocReadme) (as string: name) as string {
      mut as string: out = "# Documentacao e Manuais de Engenharia: " + name + "\n\n"
      out = out + "Esta pasta destina-se a:\n"
      out = out + "- Diagramas de arquitetura e modelos de dominio\n"
      out = out + "- Manuais de integracao de servicos e APIs\n"
      out = out + "- Documentos de requisitos e decisoes tecnicas (ADRs)\n"
      emit(nice, out, "ok")
}

function (builderGeneratePkgDependencies) (as string: pkgs, as string: link_mode) as string {
      mut as string: out = "# TheFlux Package Dependencies Manifest\n\n"
      out = out + "dependencies:\n"
      out = out + "  ecosystem_packages:\n"
      out = out + "    - \"" + pkgs + "\"\n"
      out = out + "  linking_strategy: \"" + link_mode + "\"\n"
      emit(nice, out, "ok")
}

function (builderGenerateTmpGitignore) () as string {
      mut as string: out = "# Ignorar todos os arquivos temporarios da pasta tmp\n"
      out = out + "*\n"
      out = out + "!.gitignore\n"
      out = out + "!.gitkeep\n"
      emit(nice, out, "ok")
}

function (builderGenerateFdslMain) (as string: name) as string {
      mut as string: p_name = builderToPascalCase(name)
      mut as string: out = "#L ==============================================================================\n"
      out = out + "#L Contrato e Agente FDSL Inicial: " + name + "\n"
      out = out + "#L ==============================================================================\n\n"
      out = out + "contract (" + p_name + "Contract) {\n"
      out = out + "      op processarMensagem (as string: texto) as string\n"
      out = out + "      op somarValores (as int64: a, as int64: b) as int64\n"
      out = out + "}\n\n"
      out = out + "agent (" + p_name + "Agent) impl " + p_name + "Contract {\n"
      out = out + "      op processarMensagem (as string: texto) as string ==> {\n"
      out = out + "            emit(nice, \"[\" + \"" + name + "\" + \"] Processado: \" + texto, \"ok\")\n"
      out = out + "      }\n\n"
      out = out + "      op somarValores (as int64: a, as int64: b) as int64 ==> {\n"
      out = out + "            emit(nice, a + b, \"ok\")\n"
      out = out + "      }\n"
      out = out + "}\n"
      emit(nice, out, "ok")
}

function (builderGenerateAppFlux) (as string: name, as string: version) as string {
      mut as string: p_name = builderToPascalCase(name)
      mut as string: out = "#L ==============================================================================\n"
      out = out + "#L Ponto de Entrada da Aplicacao: " + name + "\n"
      out = out + "#L ==============================================================================\n\n"
      out = out + "use main as M\n\n"
      out = out + "program (" + p_name + "App) {\n"
      out = out + "      print(\"==================================================\")\n"
      out = out + "      print(\"  " + name + " (v" + version + ") - TheFlux Engine\")\n"
      out = out + "      print(\"==================================================\")\n"
      out = out + "      mut as string: msg = M::processarMensagem(\"Inicializacao de fluxo concluida\")\n"
      out = out + "      print(msg)\n"
      out = out + "      mut as int64: total = M::somarValores(10, 20)\n"
      out = out + "      print(\"Total de inicializacao: \", total)\n"
      out = out + "      print(\"Projeto " + name + " pronto para desenvolvimento!\")\n"
      out = out + "}\n"
      emit(nice, out, "ok")
}

function (builderGenerateBuildBat) (as string: name) as string {
      mut as string: out = "@echo off\n"
      out = out + "setlocal\n"
      out = out + "echo ==================================================\n"
      out = out + "echo   Building TheFlux Project: " + name + "\n"
      out = out + "echo ==================================================\n\n"
      out = out + "if not exist bin mkdir bin\n\n"
      out = out + "echo Compilando via fluxc...\n"
      out = out + "where fluxc >nul 2>&1\n"
      out = out + "if %ERRORLEVEL% equ 0 (\n"
      out = out + "    fluxc --no-run --target llvm -o bin\\" + name + " app.flux\n"
      out = out + ") else (\n"
      out = out + "    if exist ..\\..\\bin\\fluxc.exe (\n"
      out = out + "        ..\\..\\bin\\fluxc.exe --no-run --target llvm -o bin\\" + name + " app.flux\n"
      out = out + "    ) else (\n"
      out = out + "        echo [ERRO] fluxc nao encontrado no PATH.\n"
      out = out + "        exit /b 1\n"
      out = out + "    )\n"
      out = out + ")\n\n"
      out = out + "if %ERRORLEVEL% neq 0 (\n"
      out = out + "    echo [ERRO] Falha na compilacao!\n"
      out = out + "    exit /b %ERRORLEVEL%\n"
      out = out + ")\n\n"
      out = out + "echo [OK] Build concluido com sucesso: bin\\" + name + ".exe\n"
      emit(nice, out, "ok")
}

function (builderGenerateBuildSh) (as string: name) as string {
      mut as string: out = "#!/usr/bin/env bash\n"
      out = out + "set -e\n"
      out = out + "echo \"==================================================\"\n"
      out = out + "echo \"  Building TheFlux Project: " + name + "\"\n"
      out = out + "echo \"==================================================\"\n\n"
      out = out + "mkdir -p bin\n\n"
      out = out + "echo \"Compilando via fluxc...\"\n"
      out = out + "FLUXC_CMD=\"fluxc\"\n"
      out = out + "if ! command -v fluxc &> /dev/null; then\n"
      out = out + "    if [ -f \"../../bin/fluxc\" ]; then\n"
      out = out + "        FLUXC_CMD=\"../../bin/fluxc\"\n"
      out = out + "    fi\n"
      out = out + "fi\n\n"
      out = out + "\"$FLUXC_CMD\" --no-run --target llvm -o \"bin/" + name + "\" app.flux\n"
      out = out + "echo \"[OK] Build concluido com sucesso: bin/" + name + "\"\n"
      emit(nice, out, "ok")
}

function (builderScaffoldProject) (as string: target_dir, as map: config, as bool: is_repair) as int64 {
      mut as string: name = "" + config["name"]
      mut as string: version = "" + config["version"]
      mut as string: author = "" + config["author"]
      mut as string: email = "" + config["email"]
      mut as string: db_engine = "" + config["db"]
      mut as string: link_mode = "" + config["link"]
      mut as bool: git_init = "" + config["git"] == "true"
      mut as string: pkgs = "" + config["pkgs"]
      mut as string: license_type = "" + config["license"]
      mut as string: year = "" + config["year"]
      mut as string: date_iso = "" + config["date"]

      mut as int64: created_count = 0
      mut as int64: preserved_count = 0

      #L 1. Criacao do Diretorio Principal
      route {
            not stdIoDirExists(target_dir) ==> {
                  builderMkdirAll(target_dir)
            }
            _ ==> {}
      }

      #L 2. Criacao das 8 Pastas Canonicas + scripts + .vscode
      mut as list of string: subdirs = ["bin", "lib", "db", "doc", "pkg", "tmp", "flux", "fdsl", "scripts", ".vscode"]
      mut as int64: num_dirs = stdCollectionLength(subdirs)
      mut as int64: di = 1
      infinite {
            route {
                  di > num_dirs ==> { break }
                  _ ==> {
                        mut as string: sdir = stdIoPathJoin(target_dir, "" + subdirs[di])
                        route {
                              not stdIoDirExists(sdir) ==> {
                                    builderMkdirAll(sdir)
                              }
                              _ ==> {}
                        }
                        di = di + 1
                  }
            }
      }

      #L 3. Manifesto project_config.yaml
      mut as string: p_yaml = stdIoPathJoin(target_dir, "project_config.yaml")
      mut as string: c_yaml = builderGenerateManifestYaml(name, version, author, email, db_engine, link_mode, git_init, pkgs, license_type, year, date_iso)
      route {
            builderWriteFileSafe(p_yaml, c_yaml, not is_repair) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> {
                  preserved_count = preserved_count + 1
            }
      }

      #L 4. Arquivos das 8 Pastas
      #L bin/.gitignore
      mut as string: p_bin_git = stdIoPathJoin(target_dir, "bin/.gitignore")
      route {
            builderWriteFileSafe(p_bin_git, builderGenerateBinGitignore(), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L lib/linking_mode.txt
      mut as string: p_lib_txt = stdIoPathJoin(target_dir, "lib/linking_mode.txt")
      route {
            builderWriteFileSafe(p_lib_txt, builderGenerateLibLinkingMode(link_mode), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L db/schema.sql
      mut as string: p_db_sql = stdIoPathJoin(target_dir, "db/schema.sql")
      route {
            builderWriteFileSafe(p_db_sql, builderGenerateDbSchema(name, db_engine), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L doc/README.md
      mut as string: p_doc_md = stdIoPathJoin(target_dir, "doc/README.md")
      route {
            builderWriteFileSafe(p_doc_md, builderGenerateDocReadme(name), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L pkg/dependencies.yaml
      mut as string: p_pkg_yml = stdIoPathJoin(target_dir, "pkg/dependencies.yaml")
      route {
            builderWriteFileSafe(p_pkg_yml, builderGeneratePkgDependencies(pkgs, link_mode), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L tmp/.gitkeep e tmp/.gitignore
      mut as string: p_tmp_keep = stdIoPathJoin(target_dir, "tmp/.gitkeep")
      route {
            builderWriteFileSafe(p_tmp_keep, "", false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }
      mut as string: p_tmp_git = stdIoPathJoin(target_dir, "tmp/.gitignore")
      route {
            builderWriteFileSafe(p_tmp_git, builderGenerateTmpGitignore(), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L flux/.gitkeep
      mut as string: p_flx_keep = stdIoPathJoin(target_dir, "flux/.gitkeep")
      route {
            builderWriteFileSafe(p_flx_keep, "", false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L fdsl/main.fdsl
      mut as string: p_fdsl = stdIoPathJoin(target_dir, "fdsl/main.fdsl")
      route {
            builderWriteFileSafe(p_fdsl, builderGenerateFdslMain(name), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L 5. Arquivos de Raiz
      #L README.md
      mut as string: p_root_md = stdIoPathJoin(target_dir, "README.md")
      route {
            builderWriteFileSafe(p_root_md, builderGenerateReadme(name, version, author, email, db_engine, link_mode, license_type, year), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L LICENSE.md
      mut as string: p_root_lic = stdIoPathJoin(target_dir, "LICENSE.md")
      route {
            builderWriteFileSafe(p_root_lic, builderGenerateLicense(license_type, author, year), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L .env.example
      mut as string: p_env_ex = stdIoPathJoin(target_dir, ".env.example")
      route {
            builderWriteFileSafe(p_env_ex, builderGenerateEnvExample(name, version, db_engine), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L .env
      mut as string: p_env = stdIoPathJoin(target_dir, ".env")
      route {
            builderWriteFileSafe(p_env, builderGenerateEnvExample(name, version, db_engine), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L .gitignore
      mut as string: p_root_git = stdIoPathJoin(target_dir, ".gitignore")
      route {
            builderWriteFileSafe(p_root_git, builderGenerateGitignore(), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L .editorconfig
      mut as string: p_ed_cfg = stdIoPathJoin(target_dir, ".editorconfig")
      route {
            builderWriteFileSafe(p_ed_cfg, builderGenerateEditorConfig(), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L 6. Scripts de Compilacao
      mut as string: p_sc_bat = stdIoPathJoin(target_dir, "scripts/build.bat")
      route {
            builderWriteFileSafe(p_sc_bat, builderGenerateBuildBat(name), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      mut as string: p_sc_sh = stdIoPathJoin(target_dir, "scripts/build.sh")
      route {
            builderWriteFileSafe(p_sc_sh, builderGenerateBuildSh(name), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L 7. Estilizacao de IDE: .vscode/settings.json
      mut as string: p_vsc = stdIoPathJoin(target_dir, ".vscode/settings.json")
      route {
            builderWriteFileSafe(p_vsc, builderGenerateVsCodeSettings(), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L 8. Ponto de Entrada da Aplicacao: app.flux
      mut as string: p_app_flux = stdIoPathJoin(target_dir, "app.flux")
      route {
            builderWriteFileSafe(p_app_flux, builderGenerateAppFlux(name, version), false) == 1 ==> {
                  created_count = created_count + 1
            }
            _ ==> { preserved_count = preserved_count + 1 }
      }

      #L 9. Copia bibliotecas TheFlux SDK para lib/ se disponiveis no ambiente
      route {
            (stdIoFileExists("lib/fluxcompiler.lib") or stdIoFileExists("lib/libfluxcompiler.a")) and (not is_repair) ==> {
                  route {
                        stdIoDirExists("/dev") ==> {
                              stdOsExec("cp -f lib/* \"" + target_dir + "/lib/\" >/dev/null 2>&1")
                        }
                        _ ==> {
                              mut as string: win_lib = target_dir + "\\lib"
                              stdOsExec("cmd /c copy /Y lib\\*.* \"" + win_lib + "\" >nul 2>&1")
                        }
                  }
            }
            _ ==> {}
      }

      #L 10. Inicializacao Git (se solicitada e nao for modo reparo)
      route {
            git_init and (not is_repair) ==> {
                  mut as string: devnull = " >nul 2>&1"
                  route {
                        stdIoDirExists("/dev") ==> { devnull = " >/dev/null 2>&1" }
                        _ ==> {}
                  }
                  stdOsExec("git init \"" + target_dir + "\"" + devnull)
            }
            _ ==> {}
      }

      route {
            is_repair ==> {
                  print("------------------------------------------------------------------------------")
                  print("[✓] Modo Reparo Concluido com Sucesso em: " + target_dir)
                  print("    - Arquivos estruturais restaurados : " + created_count)
                  print("    - Arquivos existentes preservados : " + preserved_count)
                  print("    - Codigo do usuario mantido 100% integro.")
                  print("------------------------------------------------------------------------------")
            }
            _ ==> {
                  print("------------------------------------------------------------------------------")
                  print("[✓] Projeto TheFlux inicializado com sucesso!")
                  print("    Diretorio        : " + target_dir)
                  print("    Projeto          : " + name + " (v" + version + ")")
                  print("    Autor            : " + author + " <" + email + ">")
                  print("    Banco de Dados   : " + db_engine)
                  print("    Modo de Linkagem : " + link_mode)
                  print("    Licenca Legal    : " + license_type + " (" + year + ")")
                  print("    Arquivos criados : " + created_count)
                  print("------------------------------------------------------------------------------")
                  print("Proximos passos:")
                  print("  1. cd " + target_dir)
                  print("  2. scripts\\build.bat   (ou ./scripts/build.sh)")
                  print("  3. bin\\" + name + ".exe")
                  print("------------------------------------------------------------------------------")
            }
      }
      emit(nice, 0, "ok")
}

function (builderRunRepairMode) (as string: target_dir) as int64 {
      mut as string: manifest_path = stdIoPathJoin(target_dir, "project_config.yaml")
      route {
            not stdIoFileExists(manifest_path) ==> {
                  print("[ERRO] Manifesto project_config.yaml nao encontrado em: " + target_dir)
                  print("       Execute o fluxbuilder sem a flag -r para iniciar um novo projeto.")
                  emit(nice, 1, "fail")
            }
            _ ==> {}
      }

      print("[*] Iniciando Modo Reparo (Idempotente) em: " + target_dir)
      mut as string: content = stdIoReadFile(manifest_path)

      mut as string: name = builderExtractYamlValue(content, "name")
      route { name == "" ==> { name = "flux_app" } _ ==> {} }

      mut as string: version = builderExtractYamlValue(content, "version")
      route { version == "" ==> { version = "1.0.0" } _ ==> {} }

      mut as string: author = builderExtractYamlValue(content, "author")
      route {
            author == "" ==> { author = builderExtractYamlValue(content, "holder") }
            _ ==> {}
      }
      route { author == "" ==> { author = "TheFlux Developer" } _ ==> {} }

      mut as string: email = builderExtractYamlValue(content, "email")
      route { email == "" ==> { email = "developer@theflux.org" } _ ==> {} }

      mut as string: db_engine = builderExtractYamlValue(content, "engine")
      route { db_engine == "" ==> { db_engine = "PostgreSQL" } _ ==> {} }

      mut as string: link_mode = builderExtractYamlValue(content, "mode")
      route { link_mode == "" ==> { link_mode = "Static" } _ ==> {} }

      mut as string: license_type = builderExtractYamlValue(content, "type")
      route { license_type == "" ==> { license_type = "MIT" } _ ==> {} }

      mut as map: date_info = builderGetDateInfo()
      mut as string: year = "" + date_info["year"]
      mut as string: date_iso = "" + date_info["date"]

      mut as map: cfg = map{}
      cfg["name"] = name
      cfg["version"] = version
      cfg["author"] = author
      cfg["email"] = email
      cfg["db"] = db_engine
      cfg["link"] = link_mode
      cfg["git"] = "false"
      cfg["pkgs"] = "IoStdLib, MathStdLib"
      cfg["license"] = license_type
      cfg["year"] = year
      cfg["date"] = date_iso

      builderScaffoldProject(target_dir, cfg, true)
      emit(nice, 0, "ok")
}

function (builderRunDoctor) () as int64 {
      print("==============================================================================")
      print("       TheFlux Doctor - Diagnostico de Ambiente de Desenvolvimento")
      print("==============================================================================")
      print("")

      mut as string: devnull = " >nul 2>&1"
      route {
            stdIoDirExists("/dev") ==> { devnull = " >/dev/null 2>&1" }
            _ ==> {}
      }

      #L 1. Compilador TheFlux (fluxc)
      route {
            stdIoFileExists("bin/fluxc.exe") or stdIoFileExists("bin/fluxc") or stdOsExec("fluxc --version" + devnull) == 0 ==> {
                  print("  [OK]    fluxc       : Operacional (Compilador TheFlux disponivel)")
            }
            _ ==> {
                  print("  [FALHA] fluxc       : Nao encontrado em bin/ nem no PATH")
            }
      }

      #L 2. Backend Clang / LLVM
      route {
            stdOsExec("clang --version" + devnull) == 0 ==> {
                  print("  [OK]    clang       : Operacional (Backend C/LLVM disponivel no PATH)")
            }
            _ ==> {
                  print("  [FALHA] clang       : Clang nao encontrado no PATH. Instale o LLVM 18+")
            }
      }

      #L 3. Controle de Versao Git
      route {
            stdOsExec("git --version" + devnull) == 0 ==> {
                  print("  [OK]    git         : Operacional (Controle de versao disponivel)")
            }
            _ ==> {
                  print("  [AVISO] git         : Git nao encontrado no PATH")
            }
      }

      #L 4. Formatador Canonico fluxfmt
      route {
            stdIoFileExists("bin/fluxfmt.exe") or stdIoFileExists("bin/fluxfmt") or stdOsExec("fluxfmt --version" + devnull) == 0 ==> {
                  print("  [OK]    fluxfmt     : Operacional (Formatador canonico instalado)")
            }
            _ ==> {
                  print("  [AVISO] fluxfmt     : Nao instalado em bin/ (execute scripts/build_tools.bat)")
            }
      }

      #L 5. Linter Estatico fluxlinter
      route {
            stdIoFileExists("bin/fluxlinter.exe") or stdIoFileExists("bin/fluxlinter") or stdOsExec("fluxlinter --version" + devnull) == 0 ==> {
                  print("  [OK]    fluxlinter  : Operacional (Linter estatico instalado)")
            }
            _ ==> {
                  print("  [AVISO] fluxlinter  : Nao instalado em bin/ (execute scripts/build_tools.bat)")
            }
      }

      print("")
      print("Diagnostico de integridade concluido.")
      emit(nice, 0, "ok")
}

program (FluxBuilder) {
      mut as list of string: args = stdRuntimeGetArgs()
      mut as int64: n_args = stdCollectionLength(args)

      mut as bool: flag_help = false
      mut as bool: flag_version = false
      mut as bool: flag_doctor = false
      mut as bool: flag_repair = false
      mut as bool: flag_non_interactive = false
      mut as bool: flag_yes = false

      mut as string: opt_name = ""
      mut as string: opt_ver = ""
      mut as string: opt_author = ""
      mut as string: opt_email = ""
      mut as string: opt_db = ""
      mut as string: opt_link = ""
      mut as string: opt_pkgs = ""
      mut as string: opt_license = ""
      mut as string: opt_git = ""
      mut as string: target_path = ""

      mut as int64: i = 1
      route {
            n_args >= 2 and ("" + args[2]) == "--" ==> {
                  i = 3
            }
            _ ==> {}
      }

      infinite {
            route {
                  i > n_args ==> { break }
                  _ ==> {
                        mut as string: arg = "" + args[i]
                        route {
                              arg == "--" ==> {}
                              arg == "help" or arg == "-h" or arg == "--h" or arg == "--help" or arg == "-help" ==> {
                                    flag_help = true
                              }
                              arg == "version" or arg == "-v" or arg == "--v" or arg == "--version" or arg == "-version" ==> {
                                    flag_version = true
                              }
                              arg == "doctor" or arg == "-c" or arg == "--c" or arg == "--doctor" or arg == "-doctor" ==> {
                                    flag_doctor = true
                              }
                              arg == "repair" or arg == "-r" or arg == "--r" or arg == "--repair" or arg == "-repair" ==> {
                                    flag_repair = true
                              }
                              arg == "-n" or arg == "--n" or arg == "--non-interactive" or arg == "-non-interactive" ==> {
                                    flag_non_interactive = true
                              }
                              arg == "-y" or arg == "--y" or arg == "--yes" or arg == "-yes" ==> {
                                    flag_yes = true
                              }
                              arg == "--name" or arg == "-name" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_name = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--ver" or arg == "-ver" or arg == "--version-num" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_ver = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--author" or arg == "-author" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_author = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--email" or arg == "-email" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_email = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--db" or arg == "-db" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_db = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--link" or arg == "-link" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_link = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--pkgs" or arg == "-pkgs" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_pkgs = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--license" or arg == "-license" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_license = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              arg == "--git" or arg == "-git" ==> {
                                    i = i + 1
                                    route {
                                          i <= n_args ==> { opt_git = "" + args[i] }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {
                                    route {
                                          target_path == "" ==> {
                                                target_path = arg
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                        i = i + 1
                  }
            }
      }

      route {
            flag_help ==> {
                  builderPrintHelp()
                  stdOsExit(0)
            }
            flag_version ==> {
                  builderPrintVersion()
                  stdOsExit(0)
            }
            flag_doctor ==> {
                  builderRunDoctor()
                  stdOsExit(0)
            }
            _ ==> {}
      }

      #L Determinacao do Diretorio Alvo
      mut as string: target_dir = target_path
      route {
            target_dir == "" ==> {
                  target_dir = "."
            }
            _ ==> {}
      }

      #L Verificacao de Modo Reparo Automático ou Explícito
      mut as string: cand_manifest = stdIoPathJoin(target_dir, "project_config.yaml")
      route {
            flag_repair or stdIoFileExists(cand_manifest) ==> {
                  builderRunRepairMode(target_dir)
                  stdOsExit(0)
            }
            _ ==> {}
      }

      #L Modo Wizard Interativo vs Modo Nao-Interativo
      mut as string: proj_name = "meu_app"
      mut as string: proj_ver = "1.0.0"
      mut as string: proj_author = "TheFlux Developer"
      mut as string: proj_email = "developer@theflux.org"
      mut as string: proj_db = "PostgreSQL"
      mut as string: proj_link = "Static"
      mut as string: proj_pkgs = "IoStdLib, MathStdLib"
      mut as string: proj_license = "MIT"
      mut as bool: proj_git = true

      route {
            flag_non_interactive or flag_yes ==> {
                  route {
                        opt_name != "" ==> { proj_name = builderSlugify(opt_name) }
                        target_path != "" and target_path != "." ==> { proj_name = builderSlugify(target_path) }
                        _ ==> {}
                  }
                  route { opt_ver != "" ==> { proj_ver = opt_ver } _ ==> {} }
                  route { opt_author != "" ==> { proj_author = opt_author } _ ==> {} }
                  route {
                        opt_email != "" ==> {
                              route {
                                    builderValidateEmail(opt_email) ==> { proj_email = opt_email }
                                    _ ==> {
                                          print("[ERRO] E-mail informado invalido: " + opt_email)
                                          stdOsExit(2)
                                    }
                              }
                        }
                        _ ==> {}
                  }
                  route { opt_db != "" ==> { proj_db = opt_db } _ ==> {} }
                  route { opt_link != "" ==> { proj_link = opt_link } _ ==> {} }
                  route { opt_pkgs != "" ==> { proj_pkgs = opt_pkgs } _ ==> {} }
                  route { opt_license != "" ==> { proj_license = opt_license } _ ==> {} }
                  route {
                        opt_git == "false" or opt_git == "0" or opt_git == "n" or opt_git == "N" ==> {
                              proj_git = false
                        }
                        _ ==> {}
                  }
            }
            _ ==> {
                  #L Assistente Interativo Terminal
                  builderPrintBanner()
                  print("")

                  #L 1. Nome do Projeto
                  mut as string: def_name = "meu_app"
                  route {
                        target_path != "" and target_path != "." ==> {
                              def_name = builderSlugify(target_path)
                        }
                        _ ==> {}
                  }
                  mut as string: raw_pname = input("Nome do Projeto [" + def_name + "]: ")
                  mut as string: cl_pname = builderTrimBoth(raw_pname)
                  route {
                        stdCollectionLength(cl_pname) == 0 ==> { proj_name = def_name }
                        _ ==> { proj_name = builderSlugify(cl_pname) }
                  }
                  print("  -> Identificador definido: " + proj_name)

                  #L 2. Versao
                  mut as string: raw_ver = input("Versao do Projeto [1.0.0]: ")
                  mut as string: cl_ver = builderTrimBoth(raw_ver)
                  route {
                        stdCollectionLength(cl_ver) > 0 ==> { proj_ver = cl_ver }
                        _ ==> {}
                  }
                  print("  -> Versao: " + proj_ver)

                  #L 3. Autor
                  mut as string: raw_author = input("Nome do Desenvolvedor [TheFlux Developer]: ")
                  mut as string: cl_author = builderTrimBoth(raw_author)
                  route {
                        stdCollectionLength(cl_author) > 0 ==> { proj_author = cl_author }
                        _ ==> {}
                  }
                  print("  -> Autor: " + proj_author)

                  #L 4. E-mail com Validacao Estrita Contínua
                  infinite {
                        mut as string: raw_mail = input("E-mail de Contato (obrigatorio): ")
                        mut as string: cl_mail = builderTrimBoth(raw_mail)
                        route {
                              builderValidateEmail(cl_mail) ==> {
                                    proj_email = cl_mail
                                    break
                              }
                              _ ==> {
                                    print("  [!] Formato de e-mail invalido. Exemplo: autor@dominio.com")
                                    print("      O e-mail deve conter '@', nome de usuario e dominio valido.")
                              }
                        }
                  }
                  print("  -> E-mail validado: " + proj_email)

                  #L 5. Git Init
                  mut as string: raw_git = input("Inicializar repositorio Git? (s/n) [s]: ")
                  mut as string: cl_git = builderTrimBoth(raw_git)
                  route {
                        cl_git == "n" or cl_git == "N" or cl_git == "nao" or cl_git == "false" ==> {
                              proj_git = false
                        }
                        _ ==> {
                              proj_git = true
                        }
                  }
                  mut as string: g_msg = "Nao"
                  route { proj_git ==> { g_msg = "Sim" } _ ==> {} }
                  print("  -> Git: " + g_msg)

                  #L 6. Banco de Dados
                  print("")
                  print("Selecione o Tipo de Banco de Dados:")
                  print("  1. PostgreSQL (Padrao para servicos e nuvem)")
                  print("  2. SQLite (Banco leve em arquivo para dev local)")
                  print("  3. MySQL (Padrao web tradicional)")
                  print("  4. Nenhum (Sem banco de dados inicial)")
                  mut as string: raw_db = input("Escolha [1-4, padrao 1]: ")
                  mut as string: cl_db = builderTrimBoth(raw_db)
                  route {
                        cl_db == "2" or cl_db == "sqlite" or cl_db == "SQLite" ==> { proj_db = "SQLite" }
                        cl_db == "3" or cl_db == "mysql" or cl_db == "MySQL" ==> { proj_db = "MySQL" }
                        cl_db == "4" or cl_db == "none" or cl_db == "nenhum" ==> { proj_db = "None" }
                        _ ==> { proj_db = "PostgreSQL" }
                  }
                  print("  -> Banco de Dados: " + proj_db)

                  #L 7. Modo de Linkagem
                  print("")
                  print("Selecione o Modo de Linkagem:")
                  print("  1. Estatica (.a / .lib - Binario standalone auto-contido)")
                  print("  2. Dinamica (.so / .dll - Modular e desacoplado)")
                  mut as string: raw_lk = input("Escolha [1-2, padrao 1]: ")
                  mut as string: cl_lk = builderTrimBoth(raw_lk)
                  route {
                        cl_lk == "2" or cl_lk == "dinamica" or cl_lk == "dynamic" ==> { proj_link = "Dynamic" }
                        _ ==> { proj_link = "Static" }
                  }
                  print("  -> Modo de Linkagem: " + proj_link)

                  #L 8. Pacotes
                  mut as string: raw_pk = input("Pacotes associados [IoStdLib, MathStdLib]: ")
                  mut as string: cl_pk = builderTrimBoth(raw_pk)
                  route {
                        stdCollectionLength(cl_pk) > 0 ==> { proj_pkgs = cl_pk }
                        _ ==> {}
                  }
                  print("  -> Pacotes: " + proj_pkgs)

                  #L 9. Licenca
                  print("")
                  print("Selecione o Tipo de Licenca:")
                  print("  1. MIT (Permissiva e popular)")
                  print("  2. Apache 2.0 (Permissiva com protecao de patentes)")
                  print("  3. GPLv3 (Copyleft estrito)")
                  print("  4. Proprietaria (Todos os direitos reservados)")
                  mut as string: raw_lic = input("Escolha [1-4, padrao 1]: ")
                  mut as string: cl_lic = builderTrimBoth(raw_lic)
                  route {
                        cl_lic == "2" or cl_lic == "apache" or cl_lic == "Apache" ==> { proj_license = "Apache-2.0" }
                        cl_lic == "3" or cl_lic == "gpl" or cl_lic == "GPL" ==> { proj_license = "GPLv3" }
                        cl_lic == "4" or cl_lic == "proprietaria" ==> { proj_license = "Proprietary" }
                        _ ==> { proj_license = "MIT" }
                  }
                  print("  -> Licenca: " + proj_license)
                  print("")
            }
      }

      #L Se nenhum diretorio foi especificado e nao estamos no modo '.', usa proj_name
      route {
            target_path == "" ==> {
                  target_dir = proj_name
            }
            _ ==> {}
      }

      mut as map: date_res = builderGetDateInfo()
      mut as string: cur_year = "" + date_res["year"]
      mut as string: cur_date = "" + date_res["date"]

      mut as map: pcfg = map{}
      pcfg["name"] = proj_name
      pcfg["version"] = proj_ver
      pcfg["author"] = proj_author
      pcfg["email"] = proj_email
      pcfg["db"] = proj_db
      pcfg["link"] = proj_link
      mut as string: pgit_s = "false"
      route { proj_git ==> { pgit_s = "true" } _ ==> {} }
      pcfg["git"] = pgit_s
      pcfg["pkgs"] = proj_pkgs
      pcfg["license"] = proj_license
      pcfg["year"] = cur_year
      pcfg["date"] = cur_date

      builderScaffoldProject(target_dir, pcfg, false)
      stdOsExit(0)
}
