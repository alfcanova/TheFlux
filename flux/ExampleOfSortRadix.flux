use ListStdLib

function (getMax) (as list of int64: arr, as int64: n) as int64 {
      mut as list of int64: temp = arr
      mut as int64: mx = temp[1]
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  temp[i] > mx ==> {
                        mx = temp[i]
                  }
            }
            i = i + 1
      }
      emit(nice, mx, "ok")
}

function (countSort) (as list of int64: arr, as int64: n, as int64: exp) as list of int64 {
      mut as list of int64: temp = arr
      mut as list of int64: output = []
      mut as list of int64: count = []
      mut as int64: i = 1
      infinite (i <= n) {
            output = listPushBack(output, 0)
            i = i + 1
      }
      mut as int64: j = 1
      infinite (j <= 10) {
            count = listPushBack(count, 0)
            j = j + 1
      }
      
      mut as int64: k = 1
      mut as int64: idx = 0
      infinite (k <= n) {
            idx = (temp[k] /i exp) /r 10
            count[idx + 1] = count[idx + 1] + 1
            k = k + 1
      }
      
      mut as int64: c = 2
      infinite (c <= 10) {
            count[c] = count[c] + count[c - 1]
            c = c + 1
      }
      
      mut as int64: p = n
      mut as int64: idx2 = 0
      infinite (p >= 1) {
            idx2 = (temp[p] /i exp) /r 10
            output[count[idx2 + 1]] = temp[p]
            count[idx2 + 1] = count[idx2 + 1] - 1
            p = p - 1
      }
      
      mut as int64: m_idx = 1
      infinite (m_idx <= n) {
            temp[m_idx] = output[m_idx]
            m_idx = m_idx + 1
      }
      
      emit(nice, temp, "ok")
}

function (radixSort) (as list of int64: arr) as list of int64 {
      mut as list of int64: temp = arr
      mut as int64: n = listLength(temp)
      mut as int64: m = getMax(temp, n)
      
      mut as int64: exp = 1
      infinite (m /i exp > 0) {
            temp = countSort(temp, n, exp)
            exp = exp * 10
      }
      emit(nice, temp, "ok")
}

program (ExampleOfSortRadix) {
      mut as list of int64: arr = []
      mut as int64: i = 1
      mut as int64: seed = 12345
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m_lcg = 2147483647
      mut as int64: val = 0

      infinite (i <= 10) {
            seed = (a * seed + c) /r m_lcg
            route {
                  seed < 0 ==> {
                        seed = seed * -1
                  }
            }
            val = seed /r 1000
            arr = listPushBack(arr, val)
            i = i + 1
      }

      print("=== DADOS ORIGINAIS ===")
      print(arr)

      mut as list of int64: sorted = radixSort(arr)

      print("")
      print("=== RADIX SORT ===")
      print(sorted)
}
