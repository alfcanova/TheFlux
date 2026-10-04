#L ============================================================================
#L Algoritmo: Hash Table com Enderecamento Aberto (Linear Probing)
#L Dominio: 02_data_structures / Categoria: Tabelas Hash e Dicionarios
#L Complexidade: Insercao O(1) medio | Busca O(1) medio | Remocao O(1) medio
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib
use StringStdLib

#L Hash polinomial deterministico para string
function (hashString) (as string: s, as int64: mod_cap) as int64 {
      mut as int64: h = 0
      mut as int64: n = stringLength(s)
      mut as int64: i = 1
      infinite (i <= n) {
            mut as string: ch = s[i]
            #L Codigo simplificado baseado no caractere
            mut as int64: code = stringLength(ch)
            route {
                  ch == "a" ==> { code = 97 }
                  ch == "b" ==> { code = 98 }
                  ch == "c" ==> { code = 99 }
                  ch == "d" ==> { code = 100 }
                  ch == "e" ==> { code = 101 }
                  ch == "g" ==> { code = 103 }
                  ch == "h" ==> { code = 104 }
                  ch == "i" ==> { code = 105 }
                  ch == "l" ==> { code = 108 }
                  ch == "m" ==> { code = 109 }
                  ch == "o" ==> { code = 111 }
                  ch == "p" ==> { code = 112 }
                  ch == "r" ==> { code = 114 }
                  ch == "t" ==> { code = 116 }
                  _ ==> { code = 65 }
            }
            h = (h * 31 + code) /r mod_cap
            i = i + 1
      }
      #L Retorna indice 1-based (1..mod_cap)
      mut as int64: idx = (h /r mod_cap) + 1
      emit(nice, idx, "ok")
}

function (htNew) (as int64: cap) as map {
      mut as list of string: keys = []
      mut as list of int64: vals = []
      mut as list of int64: states = [] #L 0=vazio, 1=ocupado, 2=tombstone
      
      mut as int64: i = 1
      infinite (i <= cap) {
            keys = listPushBack(keys, "")
            vals = listPushBack(vals, 0)
            states = listPushBack(states, 0)
            i = i + 1
      }
      
      mut as map: ht = map{
            "cap": cap,
            "size": 0,
            "keys": keys,
            "vals": vals,
            "states": states
      }
      emit(nice, ht, "ok")
}

function (htPut) (as map: ht, as string: key, as int64: val) as map {
      mut as int64: cap = ht["cap"] as int64
      mut as list of string: keys = ht["keys"] as list of string
      mut as list of int64: vals = ht["vals"] as list of int64
      mut as list of int64: states = ht["states"] as list of int64
      mut as int64: size = ht["size"] as int64
      
      mut as int64: pos = hashString(key, cap)
      mut as int64: first_tombstone = 0
      mut as int64: count = 0
      mut as bool: inserido = false
      
      infinite (count < cap) {
            mut as int64: st = states[pos]
            route {
                  st == 1 ==> {
                        route {
                              keys[pos] == key ==> {
                                    vals[pos] = val
                                    inserido = true
                                    break
                              }
                        }
                  }
                  st == 2 ==> {
                        route {
                              first_tombstone == 0 ==> {
                                    first_tombstone = pos
                              }
                        }
                  }
                  st == 0 ==> {
                        route {
                              first_tombstone != 0 ==> {
                                    pos = first_tombstone
                              }
                        }
                        keys[pos] = key
                        vals[pos] = val
                        states[pos] = 1
                        size = size + 1
                        inserido = true
                        break
                  }
            }
            pos = (pos /r cap) + 1
            count = count + 1
      }
      
      mut as map: res = map{
            "cap": cap,
            "size": size,
            "keys": keys,
            "vals": vals,
            "states": states
      }
      emit(nice, res, "ok")
}

function (htGet) (as map: ht, as string: key) as int64 {
      mut as int64: cap = ht["cap"] as int64
      mut as list of string: keys = ht["keys"] as list of string
      mut as list of int64: vals = ht["vals"] as list of int64
      mut as list of int64: states = ht["states"] as list of int64
      
      mut as int64: pos = hashString(key, cap)
      mut as int64: count = 0
      mut as int64: encontrado = -1
      
      infinite (count < cap) {
            mut as int64: st = states[pos]
            route {
                  st == 0 ==> {
                        break
                  }
                  st == 1 ==> {
                        route {
                              keys[pos] == key ==> {
                                    encontrado = vals[pos]
                                    break
                              }
                        }
                  }
            }
            pos = (pos /r cap) + 1
            count = count + 1
      }
      
      emit(nice, encontrado, "ok")
}

function (htDelete) (as map: ht, as string: key) as map {
      mut as int64: cap = ht["cap"] as int64
      mut as list of string: keys = ht["keys"] as list of string
      mut as list of int64: vals = ht["vals"] as list of int64
      mut as list of int64: states = ht["states"] as list of int64
      mut as int64: size = ht["size"] as int64
      
      mut as int64: pos = hashString(key, cap)
      mut as int64: count = 0
      
      infinite (count < cap) {
            mut as int64: st = states[pos]
            route {
                  st == 0 ==> {
                        break
                  }
                  st == 1 ==> {
                        route {
                              keys[pos] == key ==> {
                                    states[pos] = 2 #L Tombstone
                                    size = size - 1
                                    break
                              }
                        }
                  }
            }
            pos = (pos /r cap) + 1
            count = count + 1
      }
      
      mut as map: res = map{
            "cap": cap,
            "size": size,
            "keys": keys,
            "vals": vals,
            "states": states
      }
      emit(nice, res, "ok")
}

program (ExampleOfHashTable) {
      println("==================================================")
      println("  SciAlgo: Hash Table (Linear Probing)")
      println("==================================================")

      mut as map: ht = htNew(7)
      println("1. Tabela Hash inicializada com capacidade: " + ht["cap"])

      ht = htPut(ht, "alpha", 101)
      ht = htPut(ht, "beta", 202)
      ht = htPut(ht, "gamma", 303)
      ht = htPut(ht, "delta", 404)
      println("2. Inseridos 4 elementos. Tamanho atual: " + ht["size"])

      mut as int64: v_alpha = htGet(ht, "alpha")
      mut as int64: v_beta = htGet(ht, "beta")
      mut as int64: v_gamma = htGet(ht, "gamma")
      mut as int64: v_delta = htGet(ht, "delta")
      println("3. Leituras conferem:")
      println("   alpha: " + v_alpha)
      println("   beta: " + v_beta)
      println("   gamma: " + v_gamma)
      println("   delta: " + v_delta)

      #L Removendo 'beta' e verificando presenca de tombstone
      println("4. Removendo chave 'beta'...")
      ht = htDelete(ht, "beta")
      println("   Tamanho apos remocao: " + ht["size"])
      
      mut as int64: v_beta_apos = htGet(ht, "beta")
      println("   Busca por 'beta' (deve ser -1): " + v_beta_apos)

      #L Verifica que 'delta' continua acessivel mesmo com tombstone de 'beta'
      mut as int64: v_delta_apos = htGet(ht, "delta")
      println("   Busca por 'delta' apos tombstone: " + v_delta_apos)

      mut as bool: ok = (v_alpha == 101) and (v_beta_apos == -1) and (v_delta_apos == 404)
      println("5. Verificacao de integridade da Hash Table: " + ok)
      println("==================================================")
}
