#L ============================================================================
#L Algoritmo: HKDF (HMAC-based Extract-and-Expand Key Derivation Function - RFC 5869)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaHKDF) {
      println("==================================================")
      println("  SciAlgo: HKDF (RFC 5869 Key Derivation Function)")
      println("==================================================")

      #L Entrada de material de chave (IKM) e Salt
      mut as int64: ikm = 987654321
      mut as int64: salt = 123456789

      #L Constantes HMAC ipad e opad
      mut as int64: ipad = 90  #L 0x5A
      mut as int64: opad = 165 #L 0xA5

      println("1. Etapa HKDF-Extract:")
      println("   IKM:  " + ikm)
      println("   Salt: " + salt)

      #L PRK = HMAC(salt, ikm)
      mut as int64: inner = ((salt ^ ipad) * 16777619 + ikm) & 2147483647
      mut as int64: prk = ((salt ^ opad) * 16777619 + inner) & 2147483647
      println("   Chave Pseudoaleatoria Extraida (PRK): " + prk)

      println("==================================================")
      println("2. Etapa HKDF-Expand com Contexto 'TLS':")
      mut as int64: infoContext = 847683 #L String "TLS" codificada

      #L Subchave 1: Cifragem AES/ChaCha (bloco 1)
      mut as int64: blockData1 = (infoContext * 256) + 1
      inner = ((prk ^ ipad) * 16777619 + blockData1) & 2147483647
      mut as int64: encKey = ((prk ^ opad) * 16777619 + inner) & 2147483647

      #L Subchave 2: Autenticacao MAC (bloco 2)
      mut as int64: blockData2 = (infoContext * 256) + 2
      inner = ((prk ^ ipad) * 16777619 + blockData2) & 2147483647
      mut as int64: authKey = ((prk ^ opad) * 16777619 + inner) & 2147483647

      #L Subchave 3: Vetor IV Inicial (bloco 3)
      mut as int64: blockData3 = (infoContext * 256) + 3
      inner = ((prk ^ ipad) * 16777619 + blockData3) & 2147483647
      mut as int64: ivKey = ((prk ^ opad) * 16777619 + inner) & 2147483647

      println("   Subchave 1 (Cifragem):     " + encKey)
      println("   Subchave 2 (Autenticacao): " + authKey)
      println("   Subchave 3 (Vetor IV):     " + ivKey)

      println("==================================================")
      println("3. Verificacao de Determinismo e Unicidade:")
      inner = ((prk ^ ipad) * 16777619 + blockData1) & 2147483647
      mut as int64: encKeyVerify = ((prk ^ opad) * 16777619 + inner) & 2147483647
      route {
            encKey == encKeyVerify ==> {
                  println("   Determinismo confirmado: regeneracao de chaves identica.")
            }
            _ ==> {
                  println("   Falha de determinismo.")
            }
      }

      route {
            encKey != authKey ==> {
                  route {
                        authKey != ivKey ==> {
                              println("   Unicidade confirmada: todas as 3 subchaves sao independentes.")
                        }
                        _ ==> {}
                  }
            }
            _ ==> {}
      }

      println("==================================================")
      println("4. Separacao de Dominio (Mudanca de Contexto):")
      mut as int64: appInfo = 658080 #L "APP"
      mut as int64: blockDataApp = (appInfo * 256) + 1
      inner = ((prk ^ ipad) * 16777619 + blockDataApp) & 2147483647
      mut as int64: appEncKey = ((prk ^ opad) * 16777619 + inner) & 2147483647
      println("   Subchave em contexto 'APP': " + appEncKey)
      route {
            encKey != appEncKey ==> {
                  println("   Separacao criptografica confirmada: contextos distintos produzem chaves distintas.")
            }
            _ ==> {}
      }
}
