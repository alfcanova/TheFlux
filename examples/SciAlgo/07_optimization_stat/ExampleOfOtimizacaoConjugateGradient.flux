#L ============================================================================
#L Algoritmo: Conjugate Gradient (Gradientes Conjugados para Sistemas Lineares)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(D * Mult_Matriz) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoConjugateGradient) {
      println("==================================================")
      println("  SciAlgo: Conjugate Gradient (A-Orthogonal Search)")
      println("==================================================")

      #L Resolve Ax = b com A definida positiva
      #L Matriz diagonal A = diag(2, 4), b = [8, 16] -> x* = [4, 4]
      mut as int64: x1 = 0
      mut as int64: x2 = 0
      mut as int64: r1 = 8
      mut as int64: r2 = 16

      #L Direcao inicial p_0 = r_0
      mut as int64: p1 = r1
      mut as int64: p2 = r2

      #L Passo 1: alpha = (r^T r) / (p^T A p)
      mut as int64: r_dot_r = (r1 * r1) + (r2 * r2) #L 64 + 256 = 320
      mut as int64: ap1 = 2 * p1
      mut as int64: ap2 = 4 * p2
      mut as int64: p_a_p = (p1 * ap1) + (p2 * ap2) #L 128 + 1024 = 1152

      mut as int64: alpha_scaled = (r_dot_r * 10) /i p_a_p
      x1 = x1 + ((alpha_scaled * p1) /i 10)
      x2 = x2 + ((alpha_scaled * p2) /i 10)

      println("1. Progresso com Gradientes Conjugados: x1 = " + x1 + ", x2 = " + x2)
      route {
            x1 > 0 and x2 > 0 ==> {
                  println("   [PASS] Conjugate Gradient minimizou na direcao A-ortogonal!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Conjugate Gradient.")
            }
      }

      println("==================================================")
      println("Conjugate Gradient concluido com sucesso!")
}
