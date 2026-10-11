#L ============================================================================
#L Algoritmo: Trapping Rain Water (Two Pointers)
#L Dominio: 01_foundations / Arrays e Sequencias
#L Complexidade: O(n) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysTrappingRainWater) {
      println("==================================================")
      println("  SciAlgo: Trapping Rain Water (Two Pointers)      ")
      println("==================================================")

      mut as list of int64: height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]
      mut as int64: n = listLength(height)
      println("1. Vetor de Alturas: " + height)

      mut as int64: left = 1
      mut as int64: right = n
      mut as int64: left_max = 0
      mut as int64: right_max = 0
      mut as int64: water = 0

      infinite (left < right) {
            route {
                  height[left] <= height[right] ==> {
                        route {
                              height[left] >= left_max ==> {
                                    left_max = height[left]
                              }
                              _ ==> {
                                    water = water + (left_max - height[left])
                              }
                        }
                        left = left + 1
                  }
                  _ ==> {
                        route {
                              height[right] >= right_max ==> {
                                    right_max = height[right]
                              }
                              _ ==> {
                                    water = water + (right_max - height[right])
                              }
                        }
                        right = right - 1
                  }
            }
      }

      println("2. Volume Total de Agua Retida: " + water)
      println("3. Validacao (Agua esperada == 6): " + (water == 6))
      println("==================================================")
}
