use ListStdLib

function (heapify) (as list of int64: arr, as int64: n, as int64: i) as list of int64 {
      mut as list of int64: temp_arr = arr
      mut as int64: largest = i
      mut as int64: l = 2 * i
      mut as int64: r = 2 * i + 1
      
      route {
            l <= n ==> {
                  route {
                        temp_arr[l] > temp_arr[largest] ==> {
                              largest = l
                        }
                  }
            }
      }
      
      route {
            r <= n ==> {
                  route {
                        temp_arr[r] > temp_arr[largest] ==> {
                              largest = r
                        }
                  }
            }
      }
      
      route {
            largest != i ==> {
                  mut as int64: temp_val = temp_arr[i]
                  temp_arr[i] = temp_arr[largest]
                  temp_arr[largest] = temp_val
                  temp_arr = heapify(temp_arr, n, largest)
            }
      }
      emit(nice, temp_arr, "ok")
}

function (heapSort) (as list of int64: arr) as list of int64 {
      mut as int64: n = listLength(arr)
      mut as list of int64: temp = []
      mut as int64: k = 1
      infinite (k <= n) {
            temp = listPushBack(temp, arr[k])
            k = k + 1
      }
      
      mut as int64: i = n /i 2
      infinite (i >= 1) {
            temp = heapify(temp, n, i)
            i = i - 1
      }
      
      mut as int64: j = n
      mut as int64: swap = 0
      infinite (j >= 2) {
            swap = temp[1]
            temp[1] = temp[j]
            temp[j] = swap
            temp = heapify(temp, j - 1, 1)
            j = j - 1
      }
      
      emit(nice, temp, "ok")
}

program (ExampleOfSortHeap) {
      mut as list of int64: arr = []
      mut as int64: i = 1
      mut as int64: seed = 12345
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: val = 0

      infinite (i <= 10) {
            seed = (a * seed + c) /r m
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

      mut as list of int64: sorted = heapSort(arr)

      print("")
      print("=== HEAP SORT ===")
      print(sorted)
}
