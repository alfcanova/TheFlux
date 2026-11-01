use RuntimeStdLib

program (ExampleOfUseRuntimeStdLib_RuntimeMemoryContract) {
      println("==================================================")
      println("  Exemplo: RuntimeMemoryContract (Memoria e Heap)")
      println("==================================================")

      mut as int64: alloc_mem = runtimeAllocatedMemory()
      println("1. Memoria alocada (>= 0): " + (alloc_mem >= 0))

      mut as int64: heap_sz = runtimeHeapSize()
      println("2. Tamanho do heap (> 0): " + (heap_sz > 0))

      mut as int64: val = 12345
      mut as int64: ptr = runtimePointerOf(val)
      println("3. Ponteiro de variavel (>= 0): " + (ptr >= 0))

      #L Aliases
      println("4. Alias allocatedMemory (>= 0): " + (allocatedMemory() >= 0))
      println("5. Alias heapSize (> 0): " + (heapSize() > 0))
      println("6. Alias pointerOf (>= 0): " + (pointerOf(val) >= 0))
}
