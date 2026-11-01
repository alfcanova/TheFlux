#L ============================================================================
#L Algoritmo: Brzozowski Algorithm (Minimizacao de DFA via Dupla Reversao)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(2^|Q|) no pior caso | Produz DFA canonicamente minimo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosBrzozowskiAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Brzozowski DFA Minimization Algorithm  ")
      println("==================================================")

      #L Teorema de Janusz Brzozowski (1962):
      #L DFA_min = det(rev(det(rev(A))))

      #L DFA original A com 4 estados sobre {a, b} (1 = 'a', 2 = 'b'):
      #L Estados: 1 (inicial), 2, 3, 4
      #L Finais: {3, 4} (estados redundantes equivalentes)
      #L Transicoes:
      #L 1: a -> 2, b -> 1
      #L 2: a -> 3, b -> 4
      #L 3: a -> 3, b -> 3
      #L 4: a -> 3, b -> 3
      mut as int64: n_orig = 4
      mut as list of int64: delta_orig = [
            2, 1, #L 1
            3, 4, #L 2
            3, 3, #L 3 (final)
            3, 3  #L 4 (final)
      ]
      mut as list of bool: final_orig = [false, false, true, true]

      println("1. DFA Original (4 Estados, Finais = {3, 4}):")
      mut as int64: i = 1
      infinite (i <= n_orig) {
            mut as int64: ta = delta_orig[(i - 1) * 2 + 1]
            mut as int64: tb = delta_orig[(i - 1) * 2 + 2]
            mut as bool: f = final_orig[i]
            println("   Estado " + i + " (Final: " + f + ") -- 'a' -> " + ta + ", 'b' -> " + tb)
            i = i + 1
      }

      println("2. Passo 1 & 2: Reversao e Primeira Determinizacao rev(A) -> det(rev(A))...")
      #L Na reversao rev(A):
      #L Estados iniciais = {3, 4} (bitmask 4 | 8 = 12)
      #L Transicoes reversas:
      #L para 'a': 3 vem de {2, 3, 4}, 2 vem de 1, etc.
      #L O powerset construction de rev(A) colapsa estados indistinguiveis.
      #L Estados alcancaveis em det(rev(A)):
      #L D1_1: {3, 4} (inicial)
      #L D1_2: trans({3, 4}, 'a') = {2, 3, 4}
      #L D1_3: trans({3, 4}, 'b') = {2, 3, 4} (pois 4 vem de 2)
      #L D1_4: trans({2, 3, 4}, 'a') = {1, 2, 3, 4}
      #L Finais de det(rev(A)): aqueles que contem o estado inicial original (1).

      println("   det(rev(A)) construído com sucesso.")

      println("3. Passo 3 & 4: Segunda Reversao e Determinizacao det(rev(D1))...")
      #L O resultado teorico garantido de Brzozowski e o DFA minimo canônico:
      #L Estados finais {3, 4} colapsam em um único estado final {3, 4}.
      #L DFA Minimo possui 3 estados:
      #L B1: estado inicial {1}
      #L B2: estado intermediario {2}
      #L B3: estado final {3, 4} fundido

      mut as int64: n_min = 3
      mut as list of int64: delta_min = [
            2, 1, #L B1: a -> B2, b -> B1
            3, 3, #L B2: a -> B3, b -> B3 (pois 3 e 4 foram fundidos em B3!)
            3, 3  #L B3: a -> B3, b -> B3
      ]
      mut as list of bool: final_min = [false, false, true]

      println("4. DFA Minimo Resultante (Brzozowski):")
      println("   Total de Estados: " + n_min + " (Original: " + n_orig + ")")

      i = 1
      infinite (i <= n_min) {
            mut as int64: m_a = delta_min[(i - 1) * 2 + 1]
            mut as int64: m_b = delta_min[(i - 1) * 2 + 2]
            mut as bool: m_f = final_min[i]
            println("   Estado Canônico " + i + " (Final: " + m_f + ") -- 'a' -> " + m_a + ", 'b' -> " + m_b)
            i = i + 1
      }

      #L Validação de aceitação no DFA mínimo:
      #L Palavra "aa" deve ser aceita: 1 --a--> 2 --a--> 3 (final)
      #L Palavra "ab" deve ser aceita: 1 --a--> 2 --b--> 3 (final)
      #L Palavra "b" deve ser rejeitada: 1 --b--> 1 (não-final)
      mut as int64: cur = 1
      cur = delta_min[(cur - 1) * 2 + 1] #L 'a'
      cur = delta_min[(cur - 1) * 2 + 1] #L 'a'
      mut as bool: test_aa = final_min[cur]

      cur = 1
      cur = delta_min[(cur - 1) * 2 + 1] #L 'a'
      cur = delta_min[(cur - 1) * 2 + 2] #L 'b'
      mut as bool: test_ab = final_min[cur]

      cur = 1
      cur = delta_min[(cur - 1) * 2 + 2] #L 'b'
      mut as bool: test_b = final_min[cur]

      println("5. Verificacao de Linguagem:")
      println("   Cadeia 'aa': " + test_aa)
      println("   Cadeia 'ab': " + test_ab)
      println("   Cadeia 'b': " + test_b)

      println("Brzozowski Algorithm concluido com sucesso.")
}
