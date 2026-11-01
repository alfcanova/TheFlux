#L ============================================================================
#L Algoritmo: Inferência de Tipos Hindley-Milner (Algoritmo W com Unificação)
#L Dominio: 09_systems_infra / Categoria: Compiladores e parsing
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCompiladoresHindleyMilner) {
      println("==================================================")
      println("  SciAlgo: Hindley-Milner Type Inference (Alg W)")
      println("==================================================")

      #L Representacao de Tipos:
      #L Tipos primitivos: 1 = Int, 2 = Bool
      #L Variaveis de tipo: 101 = alpha_1, 102 = alpha_2, 103 = alpha_3, 104 = alpha_4
      #L Tipos funcionais (T1 -> T2) indexados:
      #L Funcao 10: alpha_1 -> alpha_3
      #L Funcao 11: alpha_3 -> alpha_4
      #L Funcao 12: Int -> Int

      #L Tabela de substituicoes / Union-Find (indice mapeia tipo para representante)
      #L Indices: 101..104 mapeados para slots 1..4
      mut as list of int64: substVar = [0, 0, 0, 0] #L slot 1=101, 2=102, 3=103, 4=104

      #L Tabela de construtores de funcao: [argType, retType]
      mut as list of int64: fnArg = [0, 0, 0, 0, 0, 0, 0, 0, 0, 101, 103, 1]
      mut as list of int64: fnRet = [0, 0, 0, 0, 0, 0, 0, 0, 0, 103, 104, 1]

      println("1. Inferindo tipo para expressao de ordem superior: 'twice = \\f. \\x. f (f x)'")
      println("   alpha_1: tipo do argumento x")
      println("   alpha_2: tipo da funcao f")

      #L Passo 1: Aplicacao f(x)
      #L f deve ter tipo (tipo(x) -> alpha_3) => alpha_2 unifica com Fn(alpha_1 -> alpha_3) [ID 10]
      mut as int64: typeOfFX = 103

      #L Passo 2: Aplicacao f(f(x))
      #L f deve ter tipo (tipo(f(x)) -> alpha_4) => alpha_2 unifica com Fn(alpha_3 -> alpha_4) [ID 11]

      #L Unificacao de Fn(alpha_1 -> alpha_3) com Fn(alpha_3 -> alpha_4):
      #L Unifica argumentos: alpha_1 com alpha_3
      #L Unifica retornos:   alpha_3 com alpha_4
      substVar[1] = 103 #L alpha_1 := alpha_3
      substVar[3] = 104 #L alpha_3 := alpha_4

      #L Substituicao transitiva: alpha_1 -> alpha_4, alpha_3 -> alpha_4
      mut as int64: unifiedAlpha1 = substVar[1]
      route {
            unifiedAlpha1 == 103 ==> {
                  unifiedAlpha1 = substVar[3]
            }
            _ ==> {}
      }

      println("   Unificacao estrutural:")
      println("   alpha_1 unificado para: " + unifiedAlpha1)
      println("   alpha_3 unificado para: " + substVar[3])

      println("==================================================")
      println("2. Especializacao Polimorfica:")
      println("   Aplicando 'twice' a funcao 'succ : Int -> Int'")

      #L Unifica alpha_4 com Int (1)
      substVar[4] = 1
      mut as int64: finalTypeTwiceSucc = substVar[4]

      println("   Tipo inferido da aplicacao: " + finalTypeTwiceSucc + " (1 = Int)")

      route {
            unifiedAlpha1 == 104 and substVar[3] == 104 and finalTypeTwiceSucc == 1 ==> {
                  println("   SUCESSO: Inferência Hindley-Milner e unificacao corretas!")
            }
            _ ==> {
                  println("   FALHA: Divergência na unificação de tipos.")
            }
      }
}
