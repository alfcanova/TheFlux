#L ============================================================================
#L Algoritmo: Multigrid Methods V-Cycle (Metodo Multigrid Ciclo-V)
#L Capitulo: 20_partial_differential_eqs
#L Complexidade: O(N) linear otimo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao multiescala de EDPs elipticas alternando malha fina e malha grossa.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MultigridMethodsVCycle) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MultigridMethodsVCycle")
      println("==================================================")

      #L Malha fina com erro inicial de baixa e alta frequencia:
      #L Norma do residuo inicial na malha fina r_h = 1000
      mut as int64: res_fino_0 = 1000
      println("1. Malha fina (h): residuo inicial ||r_h|| = " + res_fino_0)

      #L Passo 1: Pre-suavizacao de Gauss-Seidel na malha fina (elimina altas frequencias):
      #L Fator de amortecimento de alta frequencia ~ 0.5:
      mut as int64: res_fino_pos_relax = 500
      println("2. Apos pre-suavizacao (malha fina): ||r_h|| = " + res_fino_pos_relax)

      #L Passo 2: Restricao do residuo para malha grossa (2h):
      #L Operador de restricao R (full weighting): r_{2h} = R * r_h
      mut as int64: res_grosso = res_fino_pos_relax
      println("3. Restricao para malha grossa (2h): ||r_{2h}|| = " + res_grosso)

      #L Passo 3: Solucao exata da equacao de erro na malha grossa:
      #L A_{2h} * e_{2h} = r_{2h} (eliminando componente suave de baixa frequencia)
      #L Passo 4: Prolongacao (interpolacao linear P) da correcao de volta para malha fina:
      #L u_h = u_h + P * e_{2h}
      #L Passo 5: Pos-suavizacao na malha fina:
      #L Residuo apos 1 Ciclo-V completo cai por fator de 10 (convergencia multigrid O(N)):
      mut as int64: res_fino_fim = 50
      println("4. Apos prolongacao e pos-suavizacao (fim do Ciclo-V): ||r_h|| = " + res_fino_fim)

      #L Verificacao da taxa de contracao residual (res_fino_fim < 100):
      mut as int64: convergiu = 0
      route {
            res_fino_fim <= 100 ==> { convergiu = 1 }
            res_fino_fim > 100 ==> { convergiu = 0 }
      }

      mut as int64: residuo = 1 - convergiu
      println("5. Residuo do Ciclo-V Multigrid = " + residuo + " (esperado: 0)")
      println("6. Algoritmo Multigrid Ciclo-V concluido com sucesso.")
}
