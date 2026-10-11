# 🔬 TODO_SciAlgo: Catálogo e Roadmap de Algoritmos Científicos em TheFlux

> **Status**: Planejamento e Roteiro de Implementação  
> **Origem**: Baseado no catálogo exaustivo de `docs/TODO_algo.txt`  
> **Suíte Alvo**: `examples/algorithms/` com execução nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)

---

## 📊 1. Resumo Executivo & Métricas do Catálogo

- **Total de Entradas Catalogadas**: 1.470 algoritmos (1.486 nos títulos temáticos)
- **Algoritmos Já Implementados**: **1.470** (2187 na suíte [`examples/algorithms/`](file:///D:/Projetos/TheFlux/examples/algorithms) + 0 em [`flux/`](file:///D:/Projetos/TheFlux/flux))
- **Algoritmos a Implementar**: **0** algoritmos restantes
- **Taxa de Conclusão Global**: **100,0%**
- **Suíte Ativa (`examples/algorithms/`)**: **1474** arquivos `.flux` com 100% de paridade nos 6 backends
- **Divisão Estrutural**: **10 Grandes Domínios Científicos** e **49 Categorias Temáticas**

### Tabela de Domínios e Volumes

| Domínio | Escopo Temático | Total de Algoritmos | Implementados | % Concluído | Status |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Domínio I: Fundamentos, Busca e Ordenação** | Subcategorias especializadas | **175** | **175** | **100,0%** | ✅ Concluído |
| **Domínio II: Estruturas de Dados Avançadas & Streaming** | Subcategorias especializadas | **88** | **88** | **100,0%** | ✅ Concluído |
| **Domínio III: Teoria dos Grafos & Redes** | Subcategorias especializadas | **144** | **144** | **100,0%** | ✅ Concluído |
| **Domínio IV: Strings, Texto & Teoria da Informação** | Subcategorias especializadas | **130** | **130** | **100,0%** | ✅ Concluído |
| **Domínio V: Matemática Computacional, Teoria dos Números & Álgebra** | Subcategorias especializadas | **143** | **143** | **100,0%** | ✅ Concluído |
| **Domínio VI: Métodos Numéricos, Geometria & Física Computacional** | Subcategorias especializadas | **144** | **144** | **100,0%** | ✅ Concluído |
| **Domínio VII: Otimização & Estatística Científica** | Subcategorias especializadas | **120** | **120** | **100,0%** | ✅ Concluído |
| **Domínio VIII: Inteligência Artificial, ML & Deep Learning** | Subcategorias especializadas | **245** | **245** | **100,0%** | ✅ Concluído |
| **Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura** | Subcategorias especializadas | **185** | **185** | **100,0%** | ✅ Concluído |
| **Domínio X: Bioinformática, Computação Quântica & Criptografia Pós-Quântica** | Subcategorias especializadas | **96** | **96** | **100,0%** | ✅ Concluído |
| **Total Geral** | **10 Grandes Domínios** | **1.470** | **1.470** | **100,0%** | 🚀 **Suíte Ativa** |

---
## 📁 2. Arquitetura da Suíte e Diretórios

Os algoritmos são organizados de forma hierárquica e modular sob a pasta `examples/algorithms/`, com subpastas temáticas em ordem alfabética para facilitar a navegação e escalabilidade:

```text
TheFlux/
├── examples/
│   └── algorithms/
│       ├── 01_foundations/         # Paradigmas, Busca, Ordenação, Arrays, Especiais
│       ├── 02_data_structures/     # DSU, AVL, Red-Black, Segment Tree, Heaps, Streaming
│       ├── 03_graphs/              # Grafos, MST, Caminhos Mínimos, Teoria da Complexidade
│       ├── 04_strings/             # Strings, Distâncias, Compressão, Teoria da Informação
│       ├── 05_mathematics/         # Teoria dos Números, Álgebra Linear, Decomposições
│       ├── 06_numerical_physics/   # Newton-Raphson, Runge-Kutta, N-Body, Verlet
│       ├── 07_optimization_stat/   # Adam, Simplex, Genético, MCMC, Kalman, PCA
│       ├── 08_artificial_intel/    # Regressões, Árvores, SVM, MLP Backprop, Vetores
│       ├── 09_systems_infra/       # Sistemas Distribuídos, Consenso, Compiladores, Cripto
│       └── 10_bio_quantum/         # Bioinformática, Algoritmos Quânticos e Pós-Quânticos
├── SciAlgo_compliance.py   # Runner dedicado nos 6 backends com relatórios
└── docs/
    └── TODO_SciAlgo.md             # Este catálogo e checklist mestre
```

---

## 📝 3. Padrão Idiomático de Implementação TheFlux

Cada algoritmo implementado seguirá um modelo autocontido, determinístico e tipado:

```theflux
// ============================================================================
// Algoritmo: Fast Fourier Transform (Cooley-Tukey Radix-2)
// Domínio: 05_mathematics / Categoria: Polinômios e Transformadas
// Complexidade: Tempo O(N log N) | Espaço O(N)
// Paridade: in, vm, vmr, llvm, wat, wasm
// ============================================================================

program (ExampleOfCooleyTukeyFFT) {
      // 1. Sinal discreto de entrada (N = 8)
      mut as Tensor[8] of float64: sinal_real = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
      mut as Tensor[8] of float64: sinal_imag = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      mut as int64: n = 8

      print("Iniciando Cooley-Tukey FFT para N = " + n)

      // 2. Reversão de bits dos índices e borboletas com route e infinite
      // ... algoritmo determinístico ...

      // 3. Verificação de saída com asserções impressas
      print("FFT Concluida com Sucesso")
}
```

---

## 🚀 4. Cronograma de Fases (Milestones)

- **Fase 0: Infraestrutura e Padrões**: Setup de `examples/algorithms/`, runner `SciAlgo_compliance.py` e espelhamento dos 24 exemplos existentes.
- **Fase 1: Fundamentos da Computação (Domínio I)**: Buscas e ordenações remanescentes, arrays e técnicas com ponteiros.
- **Fase 2: Estruturas de Dados Avançadas & Streaming (Domínio II)**: Árvores AVL/Red-Black, Segment Tree com Lazy Propagation, Heaps e Sketches.
- **Fase 3: Teoria dos Grafos & Redes (Domínio III)**: Bellman-Ford, Floyd-Warshall, Kruskal, Dinic, Hopcroft-Karp, Bron-Kerbosch.
- **Fase 4: Strings, Compressão e Teoria da Informação (Domínio IV)**: KMP, Aho-Corasick, Suffix Array, Huffman, LZ77, Reed-Solomon.
- **Fase 5: Matemática Computacional & Álgebra Linear (Domínio V)**: Miller-Rabin, Pollard-Rho, FFT/NTT, Decomposição LU/Cholesky/QR/SVD.
- **Fase 6: Métodos Numéricos & Física Computacional (Domínio VI)**: Runge-Kutta RK4, Verlet, Barnes-Hut N-Body, Ising Monte Carlo.
- **Fase 7: Otimização, Probabilidade & Estatística (Domínio VII)**: Adam, Simplex, Genético, MCMC Metropolis-Hastings, Filtro de Kalman.
- **Fase 8: Inteligência Artificial, ML & Deep Learning (Domínio VIII)**: CART, SVM, MLP Backpropagation, CNN, Transformer, Q-Learning.
- **Fase 9: Sistemas, Compiladores, SO & Criptografia (Domínio IX)**: Shunting-Yard, Pratt, RSA, AES, Paxos, Raft, Joins em Banco.
- **Fase 10: Bioinformática, Algoritmos Quânticos & Pós-Quânticos (Domínio X)**: BLAST, Needleman-Wunsch, Grover, Deutsch-Jozsa, QFT, ML-KEM, SLH-DSA.

---

## ⭐ 5. As 15 Recomendações Prioritárias de Alto Impacto

- [x] **Binary Heap** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux))*
- [x] **Hash Table** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasHashTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasHashTable.flux))*
- [x] **Persistent Segment Tree** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux))*
- [x] **Wavelet Tree** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux))*
- [x] **Chu–Liu/Edmonds** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfGrafosGeralChuLiuEdmonds.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralChuLiuEdmonds.flux))*
- [x] **Yen’s Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfGrafosGeralYenKShortestPaths.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralYenKShortestPaths.flux))*
- [x] **Bron–Kerbosch** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeBronKerbosch.flux))*
- [x] **Christofides’ Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeChristofidesTSP.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeChristofidesTSP.flux))*
- [x] **Misra–Gries** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingMisraGries.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingMisraGries.flux))*
- [x] **Consistent Hashing** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfConsistentHashingRing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfConsistentHashingRing.flux) e [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [x] **Gossip Protocol** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfGossipProtocol.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfGossipProtocol.flux))*
- [x] **PBFT** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfPBFTConsensus.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfPBFTConsensus.flux))*
- [x] **MapReduce** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfMapReducePipeline.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfMapReducePipeline.flux))*
- [x] **Merkle Tree** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfMerkleTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfMerkleTree.flux))*
- [x] [HNSW — Hierarchical Navigable Small World](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialHNSW.flux)
---

## 📚 6. Catálogo Completo dos 1.308 Algoritmos por Domínio



### Domínio I: Fundamentos, Busca e Ordenação (175 algoritmos)

| Nome do Algoritmo                                            | Local em Disco                                                                                                 |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| **Boyer-Moore Majority Vote**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysBoyerMooreMajorityVote.flux) |
| **CDQ Divide and Conquer**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysCDQDivideAndConquer.flux) |
| **Coordinate Compression**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysCoordinateCompression.flux) |
| **Difference Array**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysDifferenceArray.flux) |
| **Difference Constraints**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysDifferenceConstraints.flux) |
| **Dutch National Flag**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysDutchNationalFlag.flux) |
| **Fast and Slow Pointers**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysFastAndSlowPointers.flux) |
| **Fisher-Yates Shuffle**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysFisherYates.flux) |
| **Floyd Random Sampling**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysFloydRandomSampling.flux) |
| **Introselect**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysIntroselect.flux) |
| **Inversion Count**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysInversionCount.flux) |
| **Kadane's Algorithm**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysKadane.flux) |
| **Longest Increasing Subsequence — LIS**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysLongestIncreasingSubsequence.flux) |
| **Maximum Product Subarray**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysMaximumProductSubarray.flux) |
| **Median of Medians**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysMedianOfMedians.flux) |
| **Monotonic Queue**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysMonotonicQueue.flux) |
| **Monotonic Stack**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysMonotonicStack.flux) |
| **Mo's Algorithm**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysMosAlgorithm.flux) |
| **Mo's Algorithm with Modifications**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysMosAlgorithmWithModifications.flux) |
| **Next Permutation (Narayana Pandita)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysNextPermutation.flux) |
| **Offline Query Processing**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysOfflineQueryProcessing.flux) |
| **Parallel Binary Search**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysParallelBinarySearch.flux) |
| **Prefix Sum**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysPrefixSum.flux) |
| **Quickselect**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysQuickselect.flux) |
| **Range Maximum Query**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysRangeMaximumQuery.flux) |
| **Range Minimum Query**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysRangeMinimumQuery.flux) |
| **Reservoir Sampling**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysReservoirSampling.flux) |
| **Sliding Window**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysSlidingWindow.flux) |
| **Sliding Window Maximum**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysSlidingWindowMaximum.flux) |
| **Sliding Window Minimum**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysSlidingWindowMinimum.flux) |
| **Sparse Table**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysSparseTable.flux) |
| **Square-Root Decomposition**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysSquareRootDecomposition.flux) |
| **Sweep Line**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysSweepLine.flux) |
| **Trapping Rain Water**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysTrappingRainWater.flux) |
| **Two-Pointer Technique**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosArraysTwoPointer.flux) |
| **A-Star Search**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaAStar.flux) |
| **Alpha-Beta Pruning**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaAlphaBeta.flux) |
| **Breadth-First Search — BFS**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBFS.flux) |
| **B-Star Search**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBStar.flux) |
| **Beam Search**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBeam.flux) |
| **Beam Stack Search**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBeamStack.flux) |
| **Best-First Search**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBestFirst.flux) |
| **Bidirectional Search**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBidirectional.flux) |
| **Bidirectional A-Star**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBidirectionalAStar.flux) |
| **Binary Search**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaBinarySearch.flux) |
| **Depth-First Search — DFS**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaDFS.flux) |
| **D-Star Search**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaDStar.flux) |
| **D-Star Lite Search**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaDStarLite.flux) |
| **Dijkstra Search**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaDijkstra.flux) |
| **Expectimax**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaExpectimax.flux) |
| **Exponential Search**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaExponential.flux) |
| **Eytzinger Search**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaEytzinger.flux) |
| **Fibonacci Search**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaFibonacci.flux) |
| **Fringe Search**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaFringe.flux) |
| **Hill Climbing (Steepest Ascent)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaHillClimbing.flux) |
| **IDA-Star Search**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaIDAStar.flux) |
| **Iterative Deepening DFS**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaIDDFS.flux) |
| **Interpolation Search**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaInterpolation.flux) |
| **Iterative Deepening A-Star**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaIterativeDeepeningAStar.flux) |
| **Jump Search**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaJump.flux) |
| **Jump Point Search**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaJumpPoint.flux) |
| **Lifelong Planning A-Star — LPA-Star**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaLPAStar.flux) |
| **Linear Search**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaLinearSearch.flux) |
| **Monte Carlo Tree Search**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaMCTS.flux) |
| **MTD(f)**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaMTDf.flux) |
| **Minimax**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaMinimax.flux) |
| **Negamax**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaNegamax.flux) |
| **Principal Variation Search**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaPVS.flux) |
| **Recursive Best-First Search**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaRBFS.flux) |
| **SMA-Star Search**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaSMAStar.flux) |
| **Tabu Search**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaTabu.flux) |
| **Ternary Search**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaTernary.flux) |
| **Uniform Binary Search**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaUniformBinary.flux) |
| **Uniform-Cost Search**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosBuscaUniformCost.flux) |
| **Ackermann Function**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisAckermann.flux) |
| **Alias Method**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisAliasMethod.flux) |
| **Bloom Filter**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisBloomFilter.flux) |
| **Booth's Algorithm**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisBooth.flux) |
| **Brent's Cycle Detection**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisBrent.flux) |
| **Brian Kernighan's Bit Counting**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisBrianKernighan.flux) |
| **Cuckoo Hashing**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisCuckoo.flux) |
| **Doomsday Algorithm**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisDoomsday.flux) |
| **Easter Algorithms**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisEaster.flux) |
| **Fast Doubling**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisFastDoubling.flux) |
| **Fischer-Heun RMQ**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisFischerHeunRMQ.flux) |
| **Gosper's Hack**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisGospersHack.flux) |
| **Horner's Method**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisHorner.flux) |
| **Josephus**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisJosephus.flux) |
| **Kahan Summation**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisKahanSummation.flux) |
| **Karatsuba Multiplication**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisKaratsuba.flux) |
| **Ramer-Douglas-Peucker**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisRamerDouglasPeucker.flux) |
| **Reservoir Sampling**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisReservoirSampling.flux) |
| **Russian Peasant Multiplication**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisRussianPeasant.flux) |
| **Shunting-Yard**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisShuntingYard.flux) |
| **Skip List Algorithms**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisSkipList.flux) |
| **Tortoise and Hare**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisTortoiseAndHare.flux) |
| **Zeller's Congruence**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisZeller.flux) |
| **Zobrist Hashing**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosEspeciaisZobrist.flux) |
| **Bead Sort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBead.flux) |
| **Bitonic Sort**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBitonic.flux) |
| **Bitonic Sorting Network**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBitonicNetwork.flux) |
| **Block Sort (WikiSort / GrailSort)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBlock.flux) |
| **Bogosort**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBogo.flux) |
| **Bubble Sort**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBubble.flux) |
| **Bucket Sort**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBucket.flux) |
| **Burstsort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoBurst.flux) |
| **Comb Sort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoComb.flux) |
| **Counting Sort**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoCounting.flux) |
| **Cycle Sort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoCycle.flux) |
| **Drop-Merge Sort**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoDropMerge.flux) |
| **Dual-Pivot Quicksort (Yaroslavskiy)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoDualPivotQuick.flux) |
| **External Merge Sort**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoExternalMerge.flux) |
| **Flashsort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoFlash.flux) |
| **Gnome Sort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoGnome.flux) |
| **Heap Sort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoHeap.flux) |
| **Insertion Sort**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoInsertion.flux) |
| **Introsort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoIntro.flux) |
| **Library Sort**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoLibrary.flux) |
| **Bottom-Up Merge Sort**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoMergeBottomUp.flux) |
| **Merge Sort (Top-Down)**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoMergeTopDown.flux) |
| **Natural Merge Sort**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoNaturalMerge.flux) |
| **Odd-Even Sort**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoOddEven.flux) |
| **Odd-Even Merge Sort**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoOddEvenMerge.flux) |
| **Pancake Sort**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoPancake.flux) |
| **Patience Sort**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoPatience.flux) |
| **Pigeonhole Sort**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoPigeonhole.flux) |
| **Polyphase Merge Sort**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoPolyphaseMerge.flux) |
| **Postman Sort**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoPostman.flux) |
| **Quick Sort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoQuick.flux) |
| **Radix Sort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoRadix.flux) |
| **Randomized QuickSort**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoRandomizedQuick.flux) |
| **Samplesort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoSample.flux) |
| **Selection Sort**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoSelection.flux) |
| **Cocktail Shaker Sort**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoShaker.flux) |
| **Shear Sort (2D Mesh)**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoShear.flux) |
| **Shell Sort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoShell.flux) |
| **Slowsort**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoSlow.flux) |
| **Smoothsort**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoSmooth.flux) |
| **Spaghetti Sort**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoSpaghetti.flux) |
| **Stooge Sort**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoStooge.flux) |
| **Strand Sort**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoStrand.flux) |
| **Three-Way Quicksort (Bentley-McIlroy)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoThreeWayQuick.flux) |
| **Timsort**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoTim.flux) |
| **Tournament Sort**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoTournament.flux) |
| **Tree Sort**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosOrdenacaoTree.flux) |
| **Amortized Algorithms**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasAmortizedAlgorithms.flux) |
| **Approximation Algorithm**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasApproximationAlgorithm.flux) |
| **Backtracking**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasBacktracking.flux) |
| **Branch and Bound**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasBranchAndBound.flux) |
| **Brute Force**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasBruteForce.flux) |
| **Decrease and Conquer**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasDecreaseAndConquer.flux) |
| **Decremental Algorithm**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasDecrementalAlgorithm.flux) |
| **Distributed Algorithm**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasDistributedAlgorithm.flux) |
| **Divide and Conquer**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasDivideAndConquer.flux) |
| **Dynamic Convex Hull**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasDynamicConvexHull.flux) |
| **Dynamic Programming**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasDynamicProgramming.flux) |
| **External-Memory Algorithm**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasExternalMemoryAlgorithm.flux) |
| **External Sorting**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasExternalSorting.flux) |
| **Fractional Cascading**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasFractionalCascading.flux) |
| **Greedy Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasGreedyAlgorithm.flux) |
| **Heuristic Search**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasHeuristicSearch.flux) |
| **Incremental Algorithm**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasIncrementalAlgorithm.flux) |
| **Las Vegas Algorithm**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasLasVegasAlgorithm.flux) |
| **Matrix Exponentiation Paradigm**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasMatrixExponentiation.flux) |
| **Meet-in-the-Middle**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasMeetInTheMiddle.flux) |
| **Metaheuristic Optimization**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasMetaheuristicOptimization.flux) |
| **Monotone Chain Convex Hull**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasMonotoneChain.flux) |
| **Monte Carlo Algorithm**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasMonteCarloAlgorithm.flux) |
| **Offline Algorithm**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasOfflineAlgorithm.flux) |
| **Online Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasOnlineAlgorithm.flux) |
| **Parallel Algorithm**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasParallelAlgorithm.flux) |
| **Prune and Search (Megiddo)**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasPruneAndSearch.flux) |
| **Randomized Algorithm**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasRandomizedAlgorithm.flux) |
| **Streaming Algorithm**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasStreamingAlgorithm.flux) |
| **Transform and Conquer**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfFundamentosParadigmasTransformAndConquer.flux) |



### Domínio II: Estruturas de Dados Avançadas & Streaming (88 algoritmos)

| Nome do Algoritmo                                            | Local em Disco                                                                                                 |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| **AA-Tree**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasAATree.flux) |
| **AVL Tree**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasAVLTree.flux) |
| **BK-Tree**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasBKTree.flux) |
| **B+ Tree**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasBPlusTree.flux) |
| **B-Tree**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasBTree.flux) |
| **Binomial Heap**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasBinomialHeap.flux) |
| **Bloom Filter**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasBloomFilter.flux) |
| **Cartesian Tree**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasCartesianTree.flux) |
| **Centroid Decomposition**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasCentroidDecomposition.flux) |
| **Count-Min Sketch (Conservative Update)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasCountMinSketch.flux) |
| **Counting Bloom Filter**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasCountingBloomFilter.flux) |
| **Cuckoo Filter**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasCuckooFilter.flux) |
| **DSU on Tree**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasDSUOnTree.flux) |
| **Disjoint Set Union**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasDisjointSetUnion.flux) |
| **Euler Tour Tree**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasEulerTourTree.flux) |
| **Fenwick Tree**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasFenwickTree.flux) |
| **Fenwick Tree 2D**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasFenwickTree2D.flux) |
| **Fibonacci Heap**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasFibonacciHeap.flux) |
| **Finger Tree**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasFingerTree.flux) |
| **Heavy-Light Decomposition**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasHeavyLightDecomposition.flux) |
| **HyperLogLog++**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasHyperLogLogPlusPlus.flux) |
| **Implicit Treap**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasImplicitTreap.flux) |
| **Interval Tree**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasIntervalTree.flux) |
| **KD-Tree**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasKDTree.flux) |
| **Lazy Propagation**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasLazyPropagation.flux) |
| **Leftist Heap**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasLeftistHeap.flux) |
| **Link-Cut Tree**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasLinkCutTree.flux) |
| **Locality-Sensitive Hashing**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasLocalitySensitiveHashing.flux) |
| **MinHash**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasMinHash.flux) |
| **Octree**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasOctree.flux) |
| **Order Statistic Tree**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasOrderStatisticTree.flux) |
| **Patricia Trie**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasPatriciaTrie.flux) |
| **Quadtree**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasQuadtree.flux) |
| **Quotient Filter**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasQuotientFilter.flux) |
| **R-Star Tree**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRStarTree.flux) |
| **R-Tree**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRTree.flux) |
| **Radix Heap**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRadixHeap.flux) |
| **Radix Tree**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRadixTree.flux) |
| **Randomized Treap**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRandomizedTreap.flux) |
| **Range Tree**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRangeTree.flux) |
| **Red-Black Tree**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRedBlackTree.flux) |
| **Roaring Bitmap**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRoaringBitmap.flux) |
| **Rope**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasRope.flux) |
| **Scapegoat Tree**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasScapegoatTree.flux) |
| **Segment Tree**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSegmentTree.flux) |
| **Segment Tree 2D**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSegmentTree2D.flux) |
| **Skew Heap**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSkewHeap.flux) |
| **Skip List**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSkipList.flux) |
| **Sparse Table**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSparseTable.flux) |
| **Splay Tree**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSplayTree.flux) |
| **Sqrt Tree**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSqrtTree.flux) |
| **Succinct Bit Vector**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSuccinctBitVector.flux) |
| **Suffix Automaton**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSuffixAutomaton.flux) |
| **Suffix Tree**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasSuffixTree.flux) |
| **Ternary Search Tree**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasTernarySearchTree.flux) |
| **Treap**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasTreap.flux) |
| **Trie**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasTrie.flux) |
| **2-3-4 Tree**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasTwoThreeFourTree.flux) |
| **2-3 Tree**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasTwoThreeTree.flux) |
| **Union-Find**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasUnionFind.flux) |
| **XOR Filter**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosAvancadasXORFilter.flux) |
| **Binary Heap**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux) |
| **Brent's Cycle Detection**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasBrentCycleDetection.flux) |
| **Cuckoo Hashing**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasCuckooHashing.flux) |
| **D-ary Heap**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasDaryHeap.flux) |
| **Hash Table**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasHashTable.flux) |
| **Hopscotch Hashing**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasHopscotchHashing.flux) |
| **LFU Cache**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasLFUCache.flux) |
| **LRU Cache**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasLRUCache.flux) |
| **Pairing Heap**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasPairingHeap.flux) |
| **Persistent Data Structures**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasPersistentDataStructures.flux) |
| **Persistent Segment Tree**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux) |
| **Robin Hood Hashing**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasRobinHoodHashing.flux) |
| **Floyd's Tortoise and Hare**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasTortoiseAndHare.flux) |
| **Van Emde Boas Tree**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasVanEmdeBoasTree.flux) |
| **Wavelet Tree**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux) |
| **Count-Min Sketch**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingCountMinSketch.flux) |
| **Count-Sketch**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingCountSketch.flux) |
| **Flajolet-Martin Algorithm**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingFlajoletMartin.flux) |
| **HyperLogLog**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingHyperLogLog.flux) |
| **KLL Sketch**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingKLLSketch.flux) |
| **Lossy Counting**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingLossyCounting.flux) |
| **Min-wise Independent Permutations**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingMinWisePermutations.flux) |
| **Misra-Gries Algorithm**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingMisraGries.flux) |
| **Reservoir Sampling**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingReservoirSampling.flux) |
| **Space-Saving Algorithm**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingSpaceSaving.flux) |
| **Sticky Sampling**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingStickySampling.flux) |
| **t-digest**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfEstruturasDeDadosStreamingTDigest.flux) |



### Domínio III: Teoria dos Grafos & Redes (144 algoritmos)

| Nome do Algoritmo                                            | Local em Disco                                                                                                 |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| **Chinese Postman Problem**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosChinesePostman.flux) |
| **Eppstein's Algorithm (k-Shortest Paths)**                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosEppsteinKShortestPaths.flux) |
| **Held-Karp TSP**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosHeldKarpTSP.flux) |
| **Lifelong Planning A-Star (LPA-Star)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosLifelongPlanningAStar.flux) |
| **ALT**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosALT.flux) |
| **A-Star**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosAStar.flux) |
| **Bellman-Ford**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosBellmanFord.flux) |
| **Bidirectional Dijkstra**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosBidirectionalDijkstra.flux) |
| **Contraction Hierarchies**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosContractionHierarchies.flux) |
| **Critical Path Method**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosCriticalPathMethod.flux) |
| **D'Esopo-Pape**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosDEsopoPape.flux) |
| **D-Star**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosDStar.flux) |
| **D-Star Lite**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosDStarLite.flux) |
| **Dial's Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosDial.flux) |
| **Dijkstra**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosDijkstra.flux) |
| **Floyd-Warshall**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosFloydWarshall.flux) |
| **Hub Labeling**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosHubLabeling.flux) |
| **Johnson**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosJohnson.flux) |
| **Lee Algorithm**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosLeeAlgorithm.flux) |
| **Longest Path in DAG**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosLongestPathInDAG.flux) |
| **SPFA**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosSPFA.flux) |
| **Shortest Path Faster Algorithm**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosShortestPathFasterAlgorithm.flux) |
| **0-1 BFS**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosMinimosZeroOneBFS.flux) |
| **Thorup Undirected Shortest Path**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosCaminhosThorupShortestPath.flux) |
| **Branch and Cut**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeBranchAndCut.flux) |
| **Bron–Kerbosch**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeBronKerbosch.flux) |
| **Christofides’ Algorithm**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeChristofidesTSP.flux) |
| **Teorema de Cook-Levin**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeCookLevinTheorem.flux) |
| **Redução de Cook**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeCookReduction.flux) |
| **FPTAS para Knapsack**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeFPTASKnapsack.flux) |
| **Algoritmo de Hopcroft–Karp**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeHopcroftKarp.flux) |
| **Redução de Karp**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeKarpReduction.flux) |
| **Kernelization**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeKernelization.flux) |
| **PTAS para Knapsack**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadePTASKnapsack.flux) |
| **Algoritmos parametrizados**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeParameterizedAlgorithms.flux) |
| **Algoritmos de aproximação para Set Cover**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeSetCoverApproximation.flux) |
| **Algoritmo de aproximação para Vertex Cover**               | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosComplexidadeVertexCoverApproximation.flux) |
| **Articulation Points**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeArticulationPoints.flux) |
| **BFS**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeBFS.flux) |
| **Biconnected Components**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeBiconnectedComponents.flux) |
| **Binary Lifting**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeBinaryLifting.flux) |
| **Bipartite Graph Test**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeBipartiteGraphTest.flux) |
| **Block-Cut Tree**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeBlockCutTree.flux) |
| **Bridge Finding**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeBridgeFinding.flux) |
| **Centroid Decomposition**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeCentroidDecomposition.flux) |
| **Connected Components**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeConnectedComponents.flux) |
| **Cycle Detection**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeCycleDetection.flux) |
| **DFS**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeDFS.flux) |
| **DSU on Tree**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeDSUOnTree.flux) |
| **Euler Tour Technique**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeEulerTourTechnique.flux) |
| **Eulerian Circuit**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeEulerianCircuit.flux) |
| **Eulerian Path**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeEulerianPath.flux) |
| **Farach-Colton and Bender LCA**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeFarachColtonBenderLCA.flux) |
| **Gabow SCC**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeGabowSCC.flux) |
| **Graph Condensation**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeGraphCondensation.flux) |
| **Heavy-Light Decomposition**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeHeavyLightDecomposition.flux) |
| **Hierholzer**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeHierholzer.flux) |
| **Kahn's Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeKahn.flux) |
| **Kosaraju**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeKosaraju.flux) |
| **Lowest Common Ancestor**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeLowestCommonAncestor.flux) |
| **Online Bridge Finding**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeOnlineBridgeFinding.flux) |
| **Path-Based SCC**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadePathBasedSCC.flux) |
| **Prüfer Code**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadePruferCode.flux) |
| **Rerooting**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeRerooting.flux) |
| **Strongly Connected Components**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeStronglyConnectedComponents.flux) |
| **Tarjan Offline LCA**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTarjanOfflineLCA.flux) |
| **Tarjan SCC**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTarjanSCC.flux) |
| **Topological Sort**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTopologicalSort.flux) |
| **Transitive Closure**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTransitiveClosure.flux) |
| **Tree Center**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTreeCenter.flux) |
| **Tree Centroid**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTreeCentroid.flux) |
| **Tree Diameter**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTreeDiameter.flux) |
| **Tree Isomorphism**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTreeIsomorphism.flux) |
| **Tree Traversal**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTreeTraversal.flux) |
| **2-SAT**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeTwoSAT.flux) |
| **Virtual Tree**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeVirtualTree.flux) |
| **Warshall Algorithm**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosConectividadeWarshall.flux) |
| **Chordal Graph Recognition (MCS)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosEstruturaisChordalGraphMCS.flux) |
| **Lexicographic BFS (LexBFS)**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosEstruturaisLexicographicBFS.flux) |
| **Modular Decomposition**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosEstruturaisModularDecomposition.flux) |
| **SPQR Tree Decomposition**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosEstruturaisSPQRTree.flux) |
| **Tree Decomposition (Treewidth)**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosEstruturaisTreeDecomposition.flux) |
| **Assignment Algorithm**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteAssignmentAlgorithm.flux) |
| **Cycle-Canceling**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteCycleCanceling.flux) |
| **Dinic**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteDinic.flux) |
| **Dinic with Scaling**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteDinicWithScaling.flux) |
| **Edmonds' Blossom**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteEdmondsBlossom.flux) |
| **Edmonds-Karp**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteEdmondsKarp.flux) |
| **Flow with Demands**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteFlowWithDemands.flux) |
| **Ford-Fulkerson**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteFordFulkerson.flux) |
| **Gale-Shapley**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteGaleShapley.flux) |
| **Highest-Label Push-Relabel**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteHighestLabelPushRelabel.flux) |
| **Hopcroft-Karp**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteHopcroftKarp.flux) |
| **Hungarian Algorithm**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteHungarianAlgorithm.flux) |
| **Karger's Min-Cut**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteKargerMinCut.flux) |
| **Karger-Stein**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteKargerStein.flux) |
| **Kuhn Matching**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteKuhnMatching.flux) |
| **Kuhn-Munkres**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteKuhnMunkres.flux) |
| **MPM**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteMPM.flux) |
| **Min-Cost Max-Flow with Potentials**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteMinCostMaxFlowWithPotentials.flux) |
| **Minimum-Cost Flow**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteMinimumCostFlow.flux) |
| **Push-Relabel**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCortePushRelabel.flux) |
| **Stable Marriage**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteStableMarriage.flux) |
| **Stable Roommates**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteStableRoommates.flux) |
| **Stoer-Wagner**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteStoerWagner.flux) |
| **Successive Shortest Path**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoCorteSuccessiveShortestPath.flux) |
| **Excess-Scaling Min-Cost Flow**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoExcessScalingMinCost.flux) |
| **FIFO Push-Relabel**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoFIFOPushRelabel.flux) |
| **Gomory-Hu Cut Tree**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoGomoryHuTree.flux) |
| **Maximum Weight General Matching**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoMaximumWeightGeneralMatching.flux) |
| **Push-Relabel (Highest-Label and Gap)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosFluxoPushRelabelGapHeuristic.flux) |
| **Bron–Kerbosch Algorithm**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralBronKerbosch.flux) |
| **Chu–Liu/Edmonds Algorithm**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralChuLiuEdmonds.flux) |
| **DSATUR**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralDSATUR.flux) |
| **Edmonds’ Algorithm for Directed MST**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralEdmondsDirectedMST.flux) |
| **Graph Coloring Algorithms**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralGraphColoring.flux) |
| **Graph Contraction**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralGraphContraction.flux) |
| **Karger’s Algorithm**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralKargerMinCut.flux) |
| **Maximum Clique Algorithms**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralMaximumClique.flux) |
| **Minimum Feedback Vertex Set**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralMinimumFeedbackVertexSet.flux) |
| **BFS/DFS Paralelo**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralParallelBFSDFS.flux) |
| **Suurballe’s Algorithm**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralSuurballe.flux) |
| **Transitive Reduction**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralTransitiveReduction.flux) |
| **Welsh–Powell Algorithm**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralWelshPowell.flux) |
| **Yen’s Algorithm**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosGeralYenKShortestPaths.flux) |
| **Borůvka**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTBoruvka.flux) |
| **Dynamic MST**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTDynamicMST.flux) |
| **Euclidean MST**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTEuclideanMST.flux) |
| **Kruskal**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTKruskal.flux) |
| **Minimum Bottleneck Spanning Tree**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTMinimumBottleneck.flux) |
| **Prim**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTPrim.flux) |
| **Reverse-Delete**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTReverseDelete.flux) |
| **Second-Best MST**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTSecondBestMST.flux) |
| **Sollin**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosMSTSollin.flux) |
| **Boyer-Myrvold Planarity Test**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosPlanaresBoyerMyrvold.flux) |
| **Hopcroft-Tarjan Planarity Test**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosPlanaresHopcroftTarjan.flux) |
| **Lipton-Tarjan Planar Separator**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosPlanaresLiptonTarjanSeparator.flux) |
| **Schnyder Grid Embedding**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosPlanaresSchnyderEmbedding.flux) |
| **Tutte Spring Embedding**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosPlanaresTutteSpringEmbedding.flux) |
| **Brandes Betweenness Centrality**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosRedesBrandesBetweenness.flux) |
| **Closeness Centrality**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosRedesClosenessCentrality.flux) |
| **HITS Algorithm (Hubs and Authorities)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosRedesHITSAlgorithm.flux) |
| **Katz Centrality**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosRedesKatzCentrality.flux) |
| **Louvain Community Detection**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfGrafosRedesLouvainCommunityDetection.flux) |



### Domínio IV: Strings, Texto & Teoria da Informação (130 algoritmos)

| Nome do Algoritmo                                            | Local em Disco                                                                                                 |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| **Aho-Corasick**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoAhoCorasick.flux) |
| **Bitap**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoBitap.flux) |
| **Booth's Algorithm**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoBoothsAlgorithm.flux) |
| **Boyer-Moore**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoBoyerMoore.flux) |
| **Boyer-Moore-Horspool**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoBoyerMooreHorspool.flux) |
| **Burrows-Wheeler Transform**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoBurrowsWheeler.flux) |
| **DC3 / Kärkkäinen-Sanders**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoDC3.flux) |
| **Double Hashing**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoDoubleHashing.flux) |
| **Duval Algorithm**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoDuvalAlgorithm.flux) |
| **FM-Index**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoFMIndex.flux) |
| **Kasai Algorithm**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoKasaiAlgorithm.flux) |
| **Knuth-Morris-Pratt**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoKnuthMorrisPratt.flux) |
| **Lyndon Factorization**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoLyndonFactorization.flux) |
| **Manacher**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoManacher.flux) |
| **Minimal Rotation**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoMinimalRotation.flux) |
| **Myers' Bit-Parallel String Matching**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoMyersBitParallel.flux) |
| **Naive String Matching**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoNaiveMatching.flux) |
| **Palindromic Tree / Eertree**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoPalindromicTree.flux) |
| **Prefix Function**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoPrefixFunction.flux) |
| **Rabin-Karp**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoRabinKarp.flux) |
| **Rolling Hash**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoRollingHash.flux) |
| **String Hashing**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoStringHashing.flux) |
| **Suffix Array**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoSuffixArray.flux) |
| **Suffix Automaton**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoSuffixAutomaton.flux) |
| **Suffix Tree**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoSuffixTree.flux) |
| **Sunday Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoSundayAlgorithm.flux) |
| **Trigram Search**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoTrigramSearch.flux) |
| **Ukkonen**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoUkkonen.flux) |
| **Ukkonen's Cutoff Approximate Matching**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoUkkonenCutoff.flux) |
| **Wildcard Matching**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoWildcardMatching.flux) |
| **Wu-Manber**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoWuManber.flux) |
| **Z Algorithm**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoZAlgorithm.flux) |
| **Zhu-Takaoka**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCasamentoZhuTakaoka.flux) |
| **ANS — Asymmetric Numeral Systems**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsANS.flux) |
| **Burrows-Wheeler + Move-to-Front**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsBWTMovedToFront.flux) |
| **Brotli**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsBrotli.flux) |
| **Huffman Canonical Coding**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsCanonicalHuffman.flux) |
| **Delta-of-Delta Encoding**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsDeltaOfDelta.flux) |
| **FastPFOR Integer Codec**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsFastPFOR.flux) |
| **Frame of Reference Encoding**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsFrameOfReference.flux) |
| **LZ4**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsLZ4.flux) |
| **LZMA**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsLZMA.flux) |
| **Roaring Bitmaps**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsRoaringBitmaps.flux) |
| **Snappy**                                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsSnappy.flux) |
| **Zstandard — Zstd**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsZstandard.flux) |
| **Direct Asymmetric Numeral Systems (dANS)**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsdANS.flux) |
| **rANS**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecsrANS.flux) |
| **tANS**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCodecstANS.flux) |
| **Adaptive Huffman**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoAdaptiveHuffman.flux) |
| **Arithmetic Coding**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoArithmeticCoding.flux) |
| **Burrows-Wheeler Transform**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoBurrowsWheeler.flux) |
| **Byte Pair Encoding**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoBytePairEncoding.flux) |
| **Context Tree Weighting (CTW)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoContextTreeWeighting.flux) |
| **DEFLATE**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoDEFLATE.flux) |
| **Delta Encoding**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoDeltaEncoding.flux) |
| **Dynamic Markov Compression (DMC)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoDynamicMarkov.flux) |
| **Embedded Zerotree Wavelet**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoEZW.flux) |
| **Elias Delta**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoEliasDelta.flux) |
| **Elias Gamma**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoEliasGamma.flux) |
| **Elias Omega**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoEliasOmega.flux) |
| **Fibonacci Coding**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoFibonacciCoding.flux) |
| **Fractal Compression**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoFractalCompression.flux) |
| **Golomb Coding**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoGolombCoding.flux) |
| **Huffman Coding**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoHuffmanCoding.flux) |
| **LZ4**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZ4.flux) |
| **LZ77**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZ77.flux) |
| **LZ78**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZ78.flux) |
| **LZMA**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZMA.flux) |
| **LZO**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZO.flux) |
| **LZSS**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZSS.flux) |
| **LZW**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoLZW.flux) |
| **Move-to-Front**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoMoveToFront.flux) |
| **PAQ Multi-Context Mixing Compression**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoPAQContextMixing.flux) |
| **PPM**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoPPM.flux) |
| **Range Coding**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoRangeCoding.flux) |
| **Rice Coding**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoRiceCoding.flux) |
| **Run-Length Encoding**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoRunLengthEncoding.flux) |
| **SPIHT**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoSPIHT.flux) |
| **Shannon-Fano**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoShannonFano.flux) |
| **Vector Quantization**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoVectorQuantization.flux) |
| **Wavelet Compression**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsCompressaoWaveletCompression.flux) |
| **Damerau-Levenshtein Distance**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaDamerauLevenshtein.flux) |
| **Dice Coefficient**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaDiceCoefficient.flux) |
| **Dynamic Time Warping**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaDynamicTimeWarping.flux) |
| **Gotoh Affine Gap Penalty Alignment**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaGotohAffineGap.flux) |
| **Hamming Distance**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaHammingDistance.flux) |
| **Hirschberg Algorithm**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaHirschbergAlgorithm.flux) |
| **Jaccard Similarity**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaJaccardSimilarity.flux) |
| **Jaro Distance**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaJaroDistance.flux) |
| **Jaro-Winkler**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaJaroWinkler.flux) |
| **Extended Jaro-Winkler Distance**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaJaroWinklerExtended.flux) |
| **Levenshtein Distance**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaLevenshteinDistance.flux) |
| **Longest Common Subsequence**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaLongestCommonSubsequence.flux) |
| **Longest Common Substring**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaLongestCommonSubstring.flux) |
| **Munkres String Assignment Distance**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaMunkresAssignment.flux) |
| **Needleman-Wunsch**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaNeedlemanWunsch.flux) |
| **Normalized Compression Distance (NCD)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaNormalizedCompression.flux) |
| **Q-Gram Distance & Inverted Filter**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaQGramFilter.flux) |
| **Shortest Common Supersequence**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaShortestCommonSupersequence.flux) |
| **Smith-Waterman**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsDistanciaSmithWaterman.flux) |
| **Compact Directed Acyclic Word Graph (CDAWG)**              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsIndicesCDAWG.flux) |
| **Run-Length Burrows-Wheeler Transform (RLBWT)**             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsIndicesRLBWT.flux) |
| **Wavelet Matrix on Strings**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsIndicesWaveletMatrix.flux) |
| **Byte-Pair Encoding (BPE) LLM Tokenizer**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsParsingBPETokenizerLLM.flux) |
| **Crochemore's Maximal Suffix & Periodicity**                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsParsingCrochemoreMaximalSuffix.flux) |
| **Sliding Window LZSS Compression**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsParsingLZSSSlidingWindow.flux) |
| **Recursive Pairing (Re-Pair) Grammar Compression**          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsParsingRePair.flux) |
| **Sequitur Grammar Induction**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsParsingSequiturGrammar.flux) |
| **Adler-32**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoAdler32.flux) |
| **BCH**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoBCH.flux) |
| **BCJR**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoBCJR.flux) |
| **Berlekamp-Massey**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoBerlekampMassey.flux) |
| **CRC**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoCRC.flux) |
| **Damm Algorithm**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoDammAlgorithm.flux) |
| **Fletcher Checksum**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoFletcherChecksum.flux) |
| **Gray Code**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoGrayCode.flux) |
| **Hamming Code**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoHammingCode.flux) |
| **HighwayHash 4-Lane High Speed Hash**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoHighwayHash.flux) |
| **LDPC**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoLDPC.flux) |
| **Luby Transform (LT) Fountain Codes**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoLubyTransform.flux) |
| **Luhn Algorithm**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoLuhnAlgorithm.flux) |
| **Parity Check**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoParityCheck.flux) |
| **Peterson-Gorenstein-Zierler**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoPetersonGorensteinZierler.flux) |
| **Polar Codes (Arikan SC Decoder)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoPolarCodes.flux) |
| **Raptor Codes (Systematic Fountain Code)**                  | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoRaptorCodes.flux) |
| **Reed-Solomon**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoReedSolomon.flux) |
| **SipHash-2-4 Keyed Hash Function**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoSipHash.flux) |
| **Turbo Codes**                                              | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoTurboCodes.flux) |
| **Verhoeff**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoVerhoeff.flux) |
| **Viterbi Decoder**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/04_strings/ExampleOfStringsTeoriaInformacaoViterbiDecoder.flux) |



### Domínio V: Matemática Computacional, Teoria dos Números & Álgebra (143 algoritmos)

#### Álgebra computacional e polinômios (41 algoritmos)

- [x] [Gaussian Elimination](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraGaussianElimination.flux)
- [x] [Gauss-Jordan](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraGaussJordan.flux)
- [x] [Gaussian Elimination over GF(2)](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraGaussianGF2.flux)
- [x] [Gauss-Seidel](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraGaussSeidel.flux)
- [x] [Jacobi Method](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraJacobiMethod.flux)
- [x] [Cholesky](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraCholesky.flux)
- [x] [Gram-Schmidt](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraGramSchmidt.flux)
- [x] [QR Decomposition](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraQRDecomposition.flux)
- [x] [LU Decomposition](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraLUDecomposition.flux)
- [x] [Singular Value Decomposition](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraSVD.flux)
- [x] [Conjugate Gradient](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraConjugateGradient.flux)
- [x] [BiCG](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraBiCG.flux)
- [x] [GMRES](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraGMRES.flux)
- [x] [Arnoldi](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraArnoldi.flux)
- [x] [Lanczos](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraLanczos.flux)
- [x] [Power Iteration](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraPowerIteration.flux)
- [x] [Inverse Iteration](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraInverseIteration.flux)
- [x] [Rayleigh Quotient Iteration](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraRayleighQuotient.flux)
- [x] [Strassen Matrix Multiplication](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraStrassen.flux)
- [x] [Coppersmith-Winograd](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraCoppersmithWinograd.flux)
- [x] [Cannon's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraCannonsAlgorithm.flux)
- [x] [Karatsuba Multiplication](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraKaratsuba.flux)
- [x] [Toom-Cook](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraToomCook.flux)
- [x] [Schönhage-Strassen](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraSchonhageStrassen.flux)
- [x] [Fürer's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraFurersAlgorithm.flux)
- [x] [Polynomial GCD](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraPolynomialGCD.flux)
- [x] [Polynomial Interpolation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraPolynomialInterpolation.flux)
- [x] [Lagrange Interpolation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraLagrangeInterpolation.flux)
- [x] [Newton Interpolation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraNewtonInterpolation.flux)
- [x] [Berlekamp Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraBerlekampAlgorithm.flux)
- [x] [Berlekamp-Massey](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraBerlekampMassey.flux)
- [x] [Cantor-Zassenhaus](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraCantorZassenhaus.flux)
- [x] [Fast Polynomial Multiplication](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraFastPolynomialMultiplication.flux)
- [x] [Multipoint Evaluation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraMultipointEvaluation.flux)
- [x] [Formal Power Series](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraFormalPowerSeries.flux)
- [x] [NTT](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraNTT.flux)
- [x] [FFT](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraFFT.flux)
- [x] [FWHT](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraFWHT.flux)
- [x] [Bluestein FFT](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraBluesteinFFT.flux)
- [x] [Rader FFT](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraRaderFFT.flux)
- [x] [Cooley-Tukey FFT](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/algebra_polynomials/ExampleOfMatematicaAlgebraCooleyTukeyFFT.flux)

#### Combinatória (21 algoritmos)

- [x] [Inclusion-Exclusion](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaInclusionExclusion.flux)
- [x] [Burnside's Lemma](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaBurnsidesLemma.flux)
- [x] [Pólya Enumeration](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaPolyaEnumeration.flux)
- [x] [Stars and Bars](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaStarsAndBars.flux)
- [x] [Catalan Numbers](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaCatalanNumbers.flux)
- [x] [Bell Numbers](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaBellNumbers.flux)
- [x] [Stirling Numbers](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaStirlingNumbers.flux)
- [x] [Pascal Triangle](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaPascalTriangle.flux)
- [x] [Binomial Coefficient](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaBinomialCoefficient.flux)
- [x] [Heap's Permutation Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaHeapsPermutation.flux)
- [x] [Steinhaus-Johnson-Trotter](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaSteinhausJohnsonTrotter.flux)
- [x] [Fisher-Yates](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaFisherYates.flux)
- [x] [Josephus Problem](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaJosephusProblem.flux)
- [x] [Prüfer Code](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaPruferCode.flux)
- [x] [Generating Functions](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaGeneratingFunctions.flux)
- [x] [Partition Algorithms](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaPartitionAlgorithms.flux)
- [x] [Subset Enumeration](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaSubsetEnumeration.flux)
- [x] [Submask Enumeration](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaSubmaskEnumeration.flux)
- [x] [Gray Code](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaGrayCode.flux)
- [x] [Balanced Parentheses Generation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaBalancedParentheses.flux)
- [x] [Meet-in-the-Middle](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/combinatorics/ExampleOfMatematicaCombinatoriaMeetInTheMiddle.flux)

#### Programação dinâmica (29 algoritmos)

- [x] [0/1 Knapsack](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaZeroOneKnapsack.flux)
- [x] [Unbounded Knapsack](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaUnboundedKnapsack.flux)
- [x] [Bounded Knapsack](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaBoundedKnapsack.flux)
- [x] [Longest Increasing Subsequence](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaLongestIncreasingSubsequence.flux)
- [x] [Longest Decreasing Subsequence](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaLongestDecreasingSubsequence.flux)
- [x] [Longest Common Subsequence](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaLongestCommonSubsequence.flux)
- [x] [Matrix Chain Multiplication](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaMatrixChainMultiplication.flux)
- [x] [Edit Distance](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaEditDistance.flux)
- [x] [Digit DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaDigitDP.flux)
- [x] [Bitmask DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaBitmaskDP.flux)
- [x] [Tree DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaTreeDP.flux)
- [x] [Profile DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaProfileDP.flux)
- [x] [Broken Profile DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaBrokenProfileDP.flux)
- [x] [Rerooting DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaRerootingDP.flux)
- [x] [SOS DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaSOSDP.flux)
- [x] [Subset Convolution](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaSubsetConvolution.flux)
- [x] [Divide-and-Conquer DP](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaDivideAndConquerDP.flux)
- [x] [Knuth Optimization](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaKnuthOptimization.flux)
- [x] [Convex Hull Trick](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaConvexHullTrick.flux)
- [x] [Li Chao Tree](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaLiChaoTree.flux)
- [x] [Monotonic Queue Optimization](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaMonotonicQueueOptimization.flux)
- [x] [Aliens Trick](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaAliensTrick.flux)
- [x] [Lagrangian Relaxation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaLagrangianRelaxation.flux)
- [x] [Kitamasa Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaKitamasaAlgorithm.flux)
- [x] [Linear Recurrence](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaLinearRecurrence.flux)
- [x] [Bostan-Mori](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaBostanMori.flux)
- [x] [Viterbi](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaViterbi.flux)
- [x] [Forward-Backward](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaForwardBackward.flux)
- [x] [Baum-Welch](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/dynamic_programming/ExampleOfMatematicaProgramacaoDinamicaBaumWelch.flux)

#### Teoria dos números (52 algoritmos)

- [x] [Euclidean Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosEuclideanAlgorithm.flux)
- [x] [Extended Euclidean Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosExtendedEuclidean.flux)
- [x] [Binary GCD](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosBinaryGCD.flux)
- [x] [Binary Exponentiation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosBinaryExponentiation.flux)
- [x] [Exponentiation by Squaring](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosExponentiationBySquaring.flux)
- [x] [Addition Chain](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosAdditionChain.flux)
- [x] [Sieve of Eratosthenes](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSieveOfEratosthenes.flux)
- [x] [Linear Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosLinearSieve.flux)
- [x] [Segmented Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSegmentedSieve.flux)
- [x] [Sieve of Atkin](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSieveOfAtkin.flux)
- [x] [Sieve of Sundaram](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSieveOfSundaram.flux)
- [x] [Wheel Factorization](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosWheelFactorization.flux)
- [x] [Trial Division](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosTrialDivision.flux)
- [x] [Fermat Primality Test](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosFermatPrimalityTest.flux)
- [x] [Solovay-Strassen](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSolovayStrassen.flux)
- [x] [Miller-Rabin](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosMillerRabin.flux)
- [x] [Baillie-PSW](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosBailliePSW.flux)
- [x] [Lucas Primality Test](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosLucasPrimalityTest.flux)
- [x] [Pocklington](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPocklington.flux)
- [x] [AKS](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosAKS.flux)
- [x] [Lucas-Lehmer](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosLucasLehmer.flux)
- [x] [Pollard Rho](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPollardRho.flux)
- [x] [Pollard p−1](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPollardPMinus1.flux)
- [x] [Fermat Factorization](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosFermatFactorization.flux)
- [x] [Dixon Factorization](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosDixonFactorization.flux)
- [x] [Quadratic Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosQuadraticSieve.flux)
- [x] [General Number Field Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosGeneralNumberFieldSieve.flux)
- [x] [Special Number Field Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSpecialNumberFieldSieve.flux)
- [x] [Lenstra ECM](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosLenstraECM.flux)
- [x] [Discrete Logarithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosDiscreteLogarithm.flux)
- [x] [Baby-Step Giant-Step](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosBabyStepGiantStep.flux)
- [x] [Pollard Rho for Discrete Log](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPollardRhoDiscreteLog.flux)
- [x] [Pollard Kangaroo](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPollardKangaroo.flux)
- [x] [Pohlig-Hellman](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPohligHellman.flux)
- [x] [Index Calculus](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosIndexCalculus.flux)
- [x] [Primitive Root](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPrimitiveRoot.flux)
- [x] [Modular Inverse](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosModularInverse.flux)
- [x] [Chinese Remainder Theorem](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosChineseRemainderTheorem.flux)
- [x] [Garner Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosGarnerAlgorithm.flux)
- [x] [Tonelli-Shanks](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosTonelliShanks.flux)
- [x] [Cipolla Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosCipollaAlgorithm.flux)
- [x] [Modular Square Root](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosModularSquareRoot.flux)
- [x] [Legendre Formula](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosLegendreFormula.flux)
- [x] [Lucas Theorem](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosLucasTheorem.flux)
- [x] [Wilson Theorem](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosWilsonTheorem.flux)
- [x] [Euler Totient Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosEulerTotientSieve.flux)
- [x] [Möbius Sieve](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosMobiusSieve.flux)
- [x] [Fast Doubling](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosFastDoubling.flux)
- [x] [Pell Equation](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosPellEquation.flux)
- [x] [Continued Fractions](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosContinuedFractions.flux)
- [x] [Stern-Brocot](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosSternBrocot.flux)
- [x] [Farey Sequence](file:///D:/Projetos/TheFlux/examples/algorithms/05_mathematics/number_theory/ExampleOfMatematicaTeoriaDosNumerosFareySequence.flux)


### Domínio VI: Métodos Numéricos, Geometria & Física Computacional (144 algoritmos)

#### Computação gráfica (21 algoritmos)

- [x] [Bresenham Line Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaBresenhamLine.flux)
- [x] [Digital Differential Analyzer](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaDDA.flux)
- [x] [Xiaolin Wu](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaXiaolinWu.flux)
- [x] [Midpoint Circle Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaMidpointCircle.flux)
- [x] [Scanline Rendering](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaScanlineRendering.flux)
- [x] [Painter's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaPaintersAlgorithm.flux)
- [x] [Z-Buffer](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaZBuffer.flux)
- [x] [Binary Space Partitioning](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaBSP.flux)
- [x] [Warnock Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaWarnockAlgorithm.flux)
- [x] [Newell's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaNewellsAlgorithm.flux)
- [x] [Gouraud Shading](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaGouraudShading.flux)
- [x] [Phong Shading](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaPhongShading.flux)
- [x] [Blinn-Phong](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaBlinnPhong.flux)
- [x] [Ray Casting](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaRayCasting.flux)
- [x] [Ray Tracing](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaRayTracing.flux)
- [x] [Path Tracing](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaPathTracing.flux)
- [x] [Bidirectional Path Tracing](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaBidirectionalPathTracing.flux)
- [x] [Photon Mapping](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaPhotonMapping.flux)
- [x] [Metropolis Light Transport](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaMetropolisLightTransport.flux)
- [x] [SLERP](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaSLERP.flux)
- [x] [Summed Area Table](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/graphics/ExampleOfNumericoComputacaoGraficaSummedAreaTable.flux)

#### Física computacional (47 algoritmos)

- [x] [N-Body Simulation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaNBodySimulation.flux)
- [x] [Barnes-Hut](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaBarnesHut.flux)
- [x] [Fast Multipole Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFastMultipoleMethod.flux)
- [x] [Verlet Integration](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaVerletIntegration.flux)
- [x] [Velocity Verlet](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaVelocityVerlet.flux)
- [x] [Leapfrog Integration](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaLeapfrogIntegration.flux)
- [x] [Runge-Kutta](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaRungeKutta.flux)
- [x] [Symplectic Integrator](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaSymplecticIntegrator.flux)
- [x] [Molecular Dynamics](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaMolecularDynamics.flux)
- [x] [Monte Carlo Simulation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaMonteCarloSimulation.flux)
- [x] [Metropolis Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaMetropolisAlgorithm.flux)
- [x] [Glauber Dynamics](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaGlauberDynamics.flux)
- [x] [Ising Model Monte Carlo](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaIsingModelMonteCarlo.flux)
- [x] [Wang-Landau Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaWangLandau.flux)
- [x] [Kinetic Monte Carlo](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaKineticMonteCarlo.flux)
- [x] [Gillespie Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaGillespieAlgorithm.flux)
- [x] [Gillespie Direct Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaGillespieDirectMethod.flux)
- [x] [Gillespie First-Reaction Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaGillespieFirstReaction.flux)
- [x] [Finite Difference Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFiniteDifference.flux)
- [x] [Finite Element Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFiniteElement.flux)
- [x] [Finite Volume Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFiniteVolume.flux)
- [x] [Spectral Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaSpectralMethod.flux)
- [x] [Pseudospectral Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaPseudospectralMethod.flux)
- [x] [Fast Fourier Transform](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFastFourierTransform.flux)
- [x] [Multigrid](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaMultigrid.flux)
- [x] [Conjugate Gradient](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaConjugateGradient.flux)
- [x] [Thomas Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaThomasAlgorithm.flux)
- [x] [Crank-Nicolson](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaCrankNicolson.flux)
- [x] [Lax-Wendroff](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaLaxWendroff.flux)
- [x] [Lax-Friedrichs](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaLaxFriedrichs.flux)
- [x] [Upwind Scheme](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaUpwindScheme.flux)
- [x] [Leapfrog Scheme](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaLeapfrogScheme.flux)
- [x] [ADI Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaADIMethod.flux)
- [x] [Poisson Solver](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaPoissonSolver.flux)
- [x] [Jacobi Poisson Solver](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaJacobiPoissonSolver.flux)
- [x] [Gauss-Seidel Poisson Solver](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaGaussSeidelPoissonSolver.flux)
- [x] [Successive Over-Relaxation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaSuccessiveOverRelaxation.flux)
- [x] [Fast Poisson Solver](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFastPoissonSolver.flux)
- [x] [Particle-in-Cell](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaParticleInCell.flux)
- [x] [Smoothed Particle Hydrodynamics](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaSmoothedParticleHydrodynamics.flux)
- [x] [Lattice Boltzmann Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaLatticeBoltzmann.flux)
- [x] [Finite Element PDE Solver](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFiniteElementPDESolver.flux)
- [x] [Level Set Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaLevelSetMethod.flux)
- [x] [Fast Marching Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFastMarchingMethod.flux)
- [x] [Rainflow Counting](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaRainflowCounting.flux)
- [x] [Constraint Dynamics](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaConstraintDynamics.flux)
- [x] [Featherstone Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/physics/ExampleOfNumericoFisicaFeatherstoneAlgorithm.flux)

#### Geometria computacional (41 algoritmos)

- [x] [Graham Scan](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaGrahamScan.flux)
- [x] [Andrew Monotone Chain](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaAndrewMonotoneChain.flux)
- [x] [Jarvis March](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaJarvisMarch.flux)
- [x] [Quickhull](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaQuickhull.flux)
- [x] [Chan's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaChansAlgorithm.flux)
- [x] [Kirkpatrick-Seidel](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaKirkpatrickSeidel.flux)
- [x] [Divide-and-Conquer Convex Hull](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaDivideAndConquerConvexHull.flux)
- [x] [Closest Pair of Points](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaClosestPairOfPoints.flux)
- [x] [Line Segment Intersection](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaLineSegmentIntersection.flux)
- [x] [Bentley-Ottmann](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaBentleyOttmann.flux)
- [x] [Shamos-Hoey](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaShamosHoey.flux)
- [x] [Sweep Line](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaSweepLine.flux)
- [x] [Rotating Calipers](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaRotatingCalipers.flux)
- [x] [Point in Polygon](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaPointInPolygon.flux)
- [x] [Ray Casting](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaRayCasting.flux)
- [x] [Winding Number](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaWindingNumber.flux)
- [x] [Point Location](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaPointLocation.flux)
- [x] [Half-Plane Intersection](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaHalfPlaneIntersection.flux)
- [x] [Polygon Triangulation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaPolygonTriangulation.flux)
- [x] [Sutherland-Hodgman](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaSutherlandHodgman.flux)
- [x] [Weiler-Atherton](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaWeilerAtherton.flux)
- [x] [Vatti Clipping](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaVattiClipping.flux)
- [x] [Cohen-Sutherland](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaCohenSutherland.flux)
- [x] [Liang-Barsky](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaLiangBarsky.flux)
- [x] [Cyrus-Beck](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaCyrusBeck.flux)
- [x] [Nicholl-Lee-Nicholl](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaNichollLeeNicholl.flux)
- [x] [Minkowski Sum](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaMinkowskiSum.flux)
- [x] [Shoelace Formula](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaShoelaceFormula.flux)
- [x] [Minimum Enclosing Circle](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaMinimumEnclosingCircle.flux)
- [x] [Minimum Bounding Rectangle](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaMinimumBoundingRectangle.flux)
- [x] [Delaunay Triangulation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaDelaunayTriangulation.flux)
- [x] [Voronoi Diagram](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaVoronoiDiagram.flux)
- [x] [Bowyer-Watson](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaBowyerWatson.flux)
- [x] [Fortune's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaFortunesAlgorithm.flux)
- [x] [Chew's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaChewsAlgorithm.flux)
- [x] [Ruppert's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaRuppertsAlgorithm.flux)
- [x] [Marching Cubes](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaMarchingCubes.flux)
- [x] [Marching Triangles](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaMarchingTriangles.flux)
- [x] [Ramer-Douglas-Peucker](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaRamerDouglasPeucker.flux)
- [x] [Gilbert-Johnson-Keerthi](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaGilbertJohnsonKeerthi.flux)
- [x] [Iterative Closest Point](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/geometry/ExampleOfNumericoGeometriaIterativeClosestPoint.flux)

#### Métodos numéricos (35 algoritmos)

- [x] [Bisection](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosBisection.flux)
- [x] [False Position](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosFalsePosition.flux)
- [x] [Illinois Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosIllinoisMethod.flux)
- [x] [Newton-Raphson](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosNewtonRaphson.flux)
- [x] [Secant Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosSecantMethod.flux)
- [x] [Ridder Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosRidderMethod.flux)
- [x] [Muller's Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosMullersMethod.flux)
- [x] [Halley's Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosHalleysMethod.flux)
- [x] [ITP Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosITPMethod.flux)
- [x] [Golden-Section Search](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosGoldenSectionSearch.flux)
- [x] [Trapezoidal Rule](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosTrapezoidalRule.flux)
- [x] [Simpson's Rule](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosSimpsonsRule.flux)
- [x] [Romberg Integration](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosRombergIntegration.flux)
- [x] [Gaussian Quadrature](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosGaussianQuadrature.flux)
- [x] [Monte Carlo Integration](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosMonteCarloIntegration.flux)
- [x] [Euler Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosEulerMethod.flux)
- [x] [Backward Euler](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosBackwardEuler.flux)
- [x] [Runge-Kutta](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosRungeKutta.flux)
- [x] [Verlet Integration](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosVerletIntegration.flux)
- [x] [Velocity Verlet](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosVelocityVerlet.flux)
- [x] [Leapfrog Integration](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosLeapfrogIntegration.flux)
- [x] [Crank-Nicolson](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosCrankNicolson.flux)
- [x] [Finite Difference Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosFiniteDifference.flux)
- [x] [Finite Element Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosFiniteElement.flux)
- [x] [Finite Volume Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosFiniteVolume.flux)
- [x] [Lax-Friedrichs](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosLaxFriedrichs.flux)
- [x] [Lax-Wendroff](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosLaxWendroff.flux)
- [x] [Upwind Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosUpwindMethod.flux)
- [x] [Runge-Kutta-Fehlberg](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosRungeKuttaFehlberg.flux)
- [x] [Multigrid](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosMultigrid.flux)
- [x] [Fast Marching Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosFastMarchingMethod.flux)
- [x] [Level Set Method](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosLevelSetMethod.flux)
- [x] [Kahan Summation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosKahanSummation.flux)
- [x] [Pairwise Summation](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosPairwiseSummation.flux)
- [x] [Binary Splitting](file:///D:/Projetos/TheFlux/examples/algorithms/06_numerical_physics/numerical_methods/ExampleOfNumericoMetodosNumericosBinarySplitting.flux)



### Domínio VII: Otimização & Estatística Científica (120 algoritmos)

| Nome do Algoritmo                                            | Local em Disco                                                                                                 |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| **ADMM (Alternating Direction Multipliers)**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoADMM.flux) |
| **AdaGrad (Adaptive Gradient)**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAdaGrad.flux) |
| **Adam (Adaptive Moment Estimation)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAdam.flux) |
| **AdamW (Decoupled Weight Decay)**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAdamW.flux) |
| **Adan (Adaptive Nesterov Momentum)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAdan.flux) |
| **Acceptance-Rejection Sampling**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemAcceptanceRejection.flux) |
| **Alias Method (Walker Discrete O(1))**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemAliasMethod.flux) |
| **Box-Muller Transform**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemBoxMuller.flux) |
| **Gibbs Sampling**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemGibbsSampling.flux) |
| **Hamiltonian Monte Carlo (HMC)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemHamiltonianMonteCarlo.flux) |
| **Importance Sampling**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemImportanceSampling.flux) |
| **Inverse Transform Sampling**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemInverseTransformSampling.flux) |
| **Markov Chain Monte Carlo (MCMC)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemMCMC.flux) |
| **Marsaglia Polar Method**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemMarsagliaPolarMethod.flux) |
| **Metropolis-Hastings Algorithm**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemMetropolisHastings.flux) |
| **Monte Carlo Integration & Estimation**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemMonteCarlo.flux) |
| **No-U-Turn Sampler (NUTS)**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemNUTS.flux) |
| **Quasi-Monte Carlo (Halton Sequence)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemQuasiMonteCarlo.flux) |
| **Rejection Sampling**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemRejectionSampling.flux) |
| **Reservoir Sampling**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemReservoirSampling.flux) |
| **Slice Sampling (Radford Neal)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemSliceSampling.flux) |
| **Stratified Sampling**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemStratifiedSampling.flux) |
| **VEGAS Adaptive Monte Carlo**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemVEGAS.flux) |
| **Ziggurat Algorithm (Marsaglia-Tsang)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAmostragemZigguratAlgorithm.flux) |
| **Ant Colony Optimization (ACO)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAntColony.flux) |
| **Artificial Bee Colony (ABC)**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoArtificialBeeColony.flux) |
| **Augmented Lagrangian Method (ALM)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoAugmentedLagrangian.flux) |
| **BFGS (Quasi-Newton Method)**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoBFGS.flux) |
| **Bat Algorithm (Echolocation Search)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoBatAlgorithm.flux) |
| **Bayesian Optimization (Expected Improvement)**             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoBayesianOptimization.flux) |
| **Benders Decomposition**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoBendersDecomposition.flux) |
| **Branch and Cut (MIP Optimizer)**                           | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoBranchAndCut.flux) |
| **CMA-ES (Covariance Matrix Adaptation)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoCMAES.flux) |
| **Conjugate Gradient (Nonlinear / Linear)**                  | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoConjugateGradient.flux) |
| **Coordinate Descent**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoCoordinateDescent.flux) |
| **Cross-Entropy Method (CEM)**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoCrossEntropyMethod.flux) |
| **Cuckoo Search (Lévy Flights)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoCuckooSearch.flux) |
| **Cutting Plane (Gomory Cuts)**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoCuttingPlane.flux) |
| **Differential Evolution (DE)**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoDifferentialEvolution.flux) |
| **ARIMA (Box-Jenkins Time Series)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaARIMA.flux) |
| **Anderson-Darling Goodness-of-Fit Test**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaAndersonDarling.flux) |
| **Baum-Welch (HMM Expectation-Maximization)**                | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaBaumWelch.flux) |
| **Bayesian Inference (Beta-Binomial Conjugate)**             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaBayesianInference.flux) |
| **Bootstrap Resampling**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaBootstrap.flux) |
| **Cross-Validation (K-Fold)**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaCrossValidation.flux) |
| **Ensemble Kalman Filter (EnKF)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaEnsembleKalmanFilter.flux) |
| **Expectation-Maximization (EM)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaExpectationMaximization.flux) |
| **Expectation Propagation (EP)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaExpectationPropagation.flux) |
| **Extended Kalman Filter (EKF)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaExtendedKalmanFilter.flux) |
| **Fisher Exact Test (2x2 Contingency)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaFisherExactTest.flux) |
| **Fisher Linear Discriminant (LDA)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaFisherLinearDiscriminant.flux) |
| **Forward-Backward Algorithm (HMM Smoothing)**               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaForwardBackward.flux) |
| **Hidden Markov Model (HMM Evaluation)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaHiddenMarkovModel.flux) |
| **Independent Component Analysis (FastICA)**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaICA.flux) |
| **Information Criteria (AIC & BIC)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaInformationCriteria.flux) |
| **Jackknife Estimator**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaJackknife.flux) |
| **Kernel Density Estimation (KDE)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaKDE.flux) |
| **Kalman Filter (Linear 1D/ND)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaKalmanFilter.flux) |
| **Kolmogorov-Smirnov Test (KS Test)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaKolmogorovSmirnov.flux) |
| **Kruskal-Wallis Nonparametric ANOVA**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaKruskalWallis.flux) |
| **Mann-Whitney U Test (Wilcoxon Rank-Sum)**                  | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaMannWhitneyU.flux) |
| **Principal Component Analysis (PCA)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaPCA.flux) |
| **Partial Least Squares (PLS / NIPALS)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaPartialLeastSquares.flux) |
| **Particle Filter (Sequential Monte Carlo / SMC)**           | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaParticleFilter.flux) |
| **RANSAC (Random Sample Consensus)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaRANSAC.flux) |
| **Rank Correlation (Spearman & Kendall)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaRankCorrelation.flux) |
| **Regression Algorithms (OLS & Ridge)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaRegressionAlgorithms.flux) |
| **Shapiro-Wilk Normality Test**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaShapiroWilk.flux) |
| **Unscented Kalman Filter (UKF)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaUnscentedKalmanFilter.flux) |
| **Viterbi Algorithm (HMM Optimal Decoding)**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaViterbi.flux) |
| **Wilcoxon Signed-Rank Test**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEstatisticaWilcoxonSignedRank.flux) |
| **Evolution Strategy ((1+1)-ES Rechenberg)**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoEvolutionStrategy.flux) |
| **FISTA (Accelerated Proximal Gradient)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoFISTA.flux) |
| **Firefly Algorithm**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoFireflyAlgorithm.flux) |
| **Frank-Wolfe (Conditional Gradient)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoFrankWolfe.flux) |
| **GRASP (Greedy Randomized Adaptive Search)**                | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGRASP.flux) |
| **Gauss-Newton Nonlinear Least Squares**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGaussNewton.flux) |
| **Genetic Algorithm (Canonical GA)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGeneticAlgorithm.flux) |
| **Genetic Programming (Expression Trees)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGeneticProgramming.flux) |
| **Gradient Descent (Standard Batch GD)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGradientDescent.flux) |
| **Gravitational Search Algorithm (GSA)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGravitationalSearch.flux) |
| **Grey Wolf Optimizer (GWO)**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoGreyWolf.flux) |
| **Harmony Search**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoHarmonySearch.flux) |
| **Harris Hawks Optimization (HHO)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoHarrisHawks.flux) |
| **Hill Climbing (Greedy Local Search)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoHillClimbing.flux) |
| **Interior Point Method (Primal-Dual Barrier)**              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoInteriorPoint.flux) |
| **Karmarkar Algorithm (Projective Method)**                  | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoKarmarkar.flux) |
| **L-BFGS (Limited-Memory BFGS)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoLBFGS.flux) |
| **Lagrangian Relaxation & Subgradient**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoLagrangianRelaxation.flux) |
| **Levenberg-Marquardt Damped Least Squares**                 | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoLevenbergMarquardt.flux) |
| **Line Search (Backtracking Armijo Condition)**              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoLineSearch.flux) |
| **Lion Optimizer (EvoLved Sign Momentum)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoLion.flux) |
| **Lookahead Optimizer**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoLookahead.flux) |
| **Mini-Batch Stochastic Gradient Descent**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoMiniBatchSGD.flux) |
| **Mirror Descent (Bregman Divergence)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoMirrorDescent.flux) |
| **Momentum (Polyak Classical Momentum)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoMomentum.flux) |
| **Moth-Flame Optimization (MFO)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoMothFlame.flux) |
| **Nadam (Nesterov-Accelerated Adaptive Moments)**            | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoNadam.flux) |
| **Nelder-Mead Downhill Simplex**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoNelderMead.flux) |
| **Nesterov Accelerated Gradient (NAG)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoNesterovMomentum.flux) |
| **Newton Optimization (Second-Order Hessian)**               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoNewton.flux) |
| **Particle Swarm Optimization (PSO)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoParticleSwarm.flux) |
| **Powell Method (Conjugate Directions)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoPowellMethod.flux) |
| **RAdam (Rectified Adaptive Moments)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoRAdam.flux) |
| **RMSProp (Root Mean Square Propagation)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoRMSProp.flux) |
| **Random-Restart Hill Climbing**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoRandomRestartHillClimbing.flux) |
| **SAM (Sharpness-Aware Minimization)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSAM.flux) |
| **Stochastic Gradient Descent (SGD)**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSGD.flux) |
| **SPSA (Simultaneous Perturbation)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSPSA.flux) |
| **Salp Swarm Algorithm (SSA)**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSalpSwarm.flux) |
| **Sequential Quadratic Programming (SQP)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSequentialQuadraticProgramming.flux) |
| **Shampoo (Tensor Preconditioned)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoShampoo.flux) |
| **Simplex Algorithm (Dantzig Linear Program)**               | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSimplex.flux) |
| **Simulated Annealing**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSimulatedAnnealing.flux) |
| **Subgradient Method (Polyak Step Size)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoSubgradientPolyak.flux) |
| **Tabu Search (Short-Term Memory)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoTabuSearch.flux) |
| **Trust-Region Dogleg (Powell Method)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoTrustRegionDogleg.flux) |
| **VFSR (Very Fast Simulated Reannealing)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoVFSR.flux) |
| **Water Cycle Algorithm (WCA)**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoWaterCycle.flux) |
| **Whale Optimization Algorithm (WOA)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/07_optimization_stat/ExampleOfOtimizacaoWhale.flux) |



### Domínio VIII: Inteligência Artificial, ML & Deep Learning (261 algoritmos)

#### Algoritmos de grafos para IA (16 algoritmos)

- [x] [PageRank](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosPageRank.flux)
- [x] [HITS](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosHITS.flux)
- [x] [TrustRank](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosTrustRank.flux)
- [x] [Girvan-Newman](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosGirvanNewman.flux)
- [x] [Label Propagation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosLabelPropagation.flux)
- [x] [Louvain](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosLouvain.flux)
- [x] [Leiden](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosLeiden.flux)
- [x] [Random Walk](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosRandomWalk.flux)
- [x] [DeepWalk](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosDeepWalk.flux)
- [x] [Node2Vec](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosNode2Vec.flux)
- [x] [Graph Embedding](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosGraphEmbedding.flux)
- [x] [GraphSAGE](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosGraphSAGE.flux)
- [x] [Graph Convolutional Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosGraphConvolutionalNetwork.flux)
- [x] [Graph Attention Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosGraphAttentionNetwork.flux)
- [x] [Graph Isomorphism Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosGraphIsomorphismNetwork.flux)
- [x] [Heterogeneous Graph Neural Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/graph_ai/ExampleOfIAGrafosHeterogeneousGraphNeuralNetwork.flux)
#### Busca vetorial, RAG e adaptação de modelos (31 algoritmos)

- [x] [Beam Search with Diverse Decoding](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialBeamSearchDiverse.flux)
- [x] [Speculative Decoding](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialSpeculativeDecoding.flux)
- [x] [Contrastive Search](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialContrastiveSearch.flux)
- [x] [Best-of-N Sampling](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialBestOfNSampling.flux)
- [x] [Monte Carlo Dropout](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialMonteCarloDropout.flux)
- [x] [Retrieval-Augmented Generation — RAG](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialRAG.flux)
- [x] [Maximal Marginal Relevance — MMR](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialMMR.flux)
- [x] [HNSW — Hierarchical Navigable Small World](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialHNSW.flux)
- [x] [Product Quantization](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialProductQuantization.flux)
- [x] [IVF-Flat](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialIVFFlat.flux)
- [x] [IVF-PQ](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialIVFPQ.flux)
- [x] [LoRA](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialLoRA.flux)
- [x] [QLoRA](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialQLoRA.flux)
- [x] [Knowledge Distillation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialKnowledgeDistillation.flux)
- [x] [Neural Architecture Search](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/vector_search_rag/ExampleOfIABuscaVetorialNeuralArchitectureSearch.flux)
#### Deep Learning e visão computacional (49 algoritmos)

- [x] [LeNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVLeNet.flux)
- [x] [AlexNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVAlexNet.flux)
- [x] [VGG](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVVGG.flux)
- [x] [GoogLeNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVGoogLeNet.flux)
- [x] [Inception](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVInception.flux)
- [x] [ResNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVResNet.flux)
- [x] [DenseNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVDenseNet.flux)
- [x] [EfficientNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVEfficientNet.flux)
- [x] [MobileNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVMobileNet.flux)
- [x] [U-Net](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVUNet.flux)
- [x] [FCN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVFCN.flux)
- [x] [SegNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSegNet.flux)
- [x] [Mask R-CNN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVMaskRCNN.flux)
- [x] [R-CNN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVRCNN.flux)
- [x] [Fast R-CNN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVFastRCNN.flux)
- [x] [Faster R-CNN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVFasterRCNN.flux)
- [x] [YOLO](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVYOLO.flux)
- [x] [SSD](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSSD.flux)
- [x] [RetinaNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVRetinaNet.flux)
- [x] [DETR](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVDETR.flux)
- [x] [Vision Transformer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVVisionTransformer.flux)
- [x] [Swin Transformer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSwinTransformer.flux)
- [x] [Capsule Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVCapsuleNetwork.flux)
- [x] [Canny](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVCanny.flux)
- [x] [Sobel](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSobel.flux)
- [x] [Prewitt](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVPrewitt.flux)
- [x] [Scharr](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVScharr.flux)
- [x] [Laplacian Edge Detection](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVLaplacianEdgeDetection.flux)
- [x] [Hough Transform](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVHoughTransform.flux)
- [x] [Generalized Hough](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVGeneralizedHough.flux)
- [x] [SIFT](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSIFT.flux)
- [x] [SURF](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSURF.flux)
- [x] [HOG](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVHOG.flux)
- [x] [Optical Flow](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVOpticalFlow.flux)
- [x] [Lucas-Kanade](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVLucasKanade.flux)
- [x] [Farneback Optical Flow](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVFarnebackOpticalFlow.flux)
- [x] [GrabCut](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVGrabCut.flux)
- [x] [Watershed](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVWatershed.flux)
- [x] [Region Growing](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVRegionGrowing.flux)
- [x] [Connected Component Labeling](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVConnectedComponentLabeling.flux)
- [x] [Flood Fill](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVFloodFill.flux)
- [x] [Histogram Equalization](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVHistogramEqualization.flux)
- [x] [Adaptive Histogram Equalization](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVAdaptiveHistogramEqualization.flux)
- [x] [Median Filter](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVMedianFilter.flux)
- [x] [Gaussian Filter](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVGaussianFilter.flux)
- [x] [Richardson-Lucy Deconvolution](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVRichardsonLucyDeconvolution.flux)
- [x] [Blind Deconvolution](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVBlindDeconvolution.flux)
- [x] [Seam Carving](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVSeamCarving.flux)
- [x] [Floyd-Steinberg Dithering](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/deep_learning_cv/ExampleOfIADeepLearningCVFloydSteinbergDithering.flux)
#### Ensemble Learning (21 algoritmos)

- [x] [Bagging](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleBagging.flux)
- [x] [Boosting](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleBoosting.flux)
- [x] [AdaBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleAdaBoost.flux)
- [x] [BrownBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleBrownBoost.flux)
- [x] [LogitBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleLogitBoost.flux)
- [x] [LPBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleLPBoost.flux)
- [x] [Gradient Boosting](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleGradientBoosting.flux)
- [x] [XGBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleXGBoost.flux)
- [x] [LightGBM](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleLightGBM.flux)
- [x] [CatBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleCatBoost.flux)
- [x] [Random Subspace](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleRandomSubspace.flux)
- [x] [Rotation Forest](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleRotationForest.flux)
- [x] [Stacking](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleStacking.flux)
- [x] [Blending](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleBlending.flux)
- [x] [Voting Classifier](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleVotingClassifier.flux)
- [x] [MultiBoosting](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleMultiBoosting.flux)
- [x] [RUSBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleRUSBoost.flux)
- [x] [SMOTEBoost](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleSMOTEBoost.flux)
- [x] [Balanced Random Forest](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleBalancedRandomForest.flux)
- [x] [Easy Ensemble](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleEasyEnsemble.flux)
- [x] [Feature Space Ensemble](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ensemble/ExampleOfIAEnsembleFeatureSpaceEnsemble.flux)
#### IA generativa (24 algoritmos)

- [x] [Variational Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaVariationalAutoencoder.flux)
- [x] [GAN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaGAN.flux)
- [x] [DCGAN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaDCGAN.flux)
- [x] [WGAN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaWGAN.flux)
- [x] [WGAN-GP](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaWGANGP.flux)
- [x] [StyleGAN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaStyleGAN.flux)
- [x] [Pix2Pix](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaPix2Pix.flux)
- [x] [CycleGAN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaCycleGAN.flux)
- [x] [Diffusion Models](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaDiffusionModels.flux)
- [x] [DDPM](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaDDPM.flux)
- [x] [DDIM](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaDDIM.flux)
- [x] [Score-Based Diffusion](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaScoreBasedDiffusion.flux)
- [x] [Normalizing Flows](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaNormalizingFlows.flux)
- [x] [Autoregressive Models](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaAutoregressiveModels.flux)
- [x] [Transformer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaTransformer.flux)
- [x] [Mixture of Experts](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaMixtureOfExperts.flux)
- [x] [Beam Search](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaBeamSearch.flux)
- [x] [Top-k Sampling](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaTopKSampling.flux)
- [x] [Nucleus Sampling](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaNucleusSampling.flux)
- [x] [Temperature Sampling](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaTemperatureSampling.flux)
- [x] [Contrastive Learning](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaContrastiveLearning.flux)
- [x] [SimCLR](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaSimCLR.flux)
- [x] [CLIP](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaCLIP.flux)
- [x] [Masked Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/generative_ai/ExampleOfIAGenerativaMaskedAutoencoder.flux)
#### Machine Learning clássico (38 algoritmos)

- [x] [Linear Regression](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoLinearRegression.flux)
- [x] [Logistic Regression](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoLogisticRegression.flux)
- [x] [Ridge Regression](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoRidgeRegression.flux)
- [x] [Lasso](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoLasso.flux)
- [x] [Elastic Net](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoElasticNet.flux)
- [x] [Polynomial Regression](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoPolynomialRegression.flux)
- [x] [Perceptron](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoPerceptron.flux)
- [x] [K-Nearest Neighbors](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoKNearestNeighbors.flux)
- [x] [Naive Bayes](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoNaiveBayes.flux)
- [x] [Decision Tree](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoDecisionTree.flux)
- [x] [ID3](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoID3.flux)
- [x] [C4.5](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoC45.flux)
- [x] [CART](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoCART.flux)
- [x] [Random Forest](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoRandomForest.flux)
- [x] [Extra Trees](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoExtraTrees.flux)
- [x] [Support Vector Machine](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoSupportVectorMachine.flux)
- [x] [One-Class SVM](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoOneClassSVM.flux)
- [x] [Kernel Methods](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoKernelMethods.flux)
- [x] [Gaussian Process](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoGaussianProcess.flux)
- [x] [K-Means](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoKMeans.flux)
- [x] [K-Means++](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoKMeansPlusPlus.flux)
- [x] [K-Medoids](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoKMedoids.flux)
- [x] [Mean Shift](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoMeanShift.flux)
- [x] [DBSCAN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoDBSCAN.flux)
- [x] [OPTICS](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoOPTICS.flux)
- [x] [Spectral Clustering](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoSpectralClustering.flux)
- [x] [Fuzzy C-Means](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoFuzzyCMeans.flux)
- [x] [Hierarchical Clustering](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoHierarchicalClustering.flux)
- [x] [Single-Linkage](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoSingleLinkage.flux)
- [x] [Complete-Linkage](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoCompleteLinkage.flux)
- [x] [Average-Linkage](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoAverageLinkage.flux)
- [x] [Ward's Method](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoWardsMethod.flux)
- [x] [Gaussian Mixture Model](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoGaussianMixtureModel.flux)
- [x] [Isolation Forest](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoIsolationForest.flux)
- [x] [Local Outlier Factor](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoLocalOutlierFactor.flux)
- [x] [Elliptic Envelope](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoEllipticEnvelope.flux)
- [x] [RANSAC](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoRANSAC.flux)
- [x] [Locality-Sensitive Hashing](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/classical_ml/ExampleOfIAMLClassicoLocalitySensitiveHashing.flux)
#### NLP — Processamento de linguagem natural (23 algoritmos)

- [x] [Bag of Words](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPBagOfWords.flux)
- [x] [TF-IDF](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPTFIDF.flux)
- [x] [Word2Vec](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPWord2Vec.flux)
- [x] [GloVe](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPGloVe.flux)
- [x] [ELMo](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPELMo.flux)
- [x] [BERT](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPBERT.flux)
- [x] [RoBERTa](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPRoBERTa.flux)
- [x] [GPT](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPGPT.flux)
- [x] [T5](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPT5.flux)
- [x] [XLNet](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPXLNet.flux)
- [x] [Seq2Seq](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPSeq2Seq.flux)
- [x] [Attention Mechanism](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPAttentionMechanism.flux)
- [x] [Transformer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPTransformer.flux)
- [x] [Masked Language Modeling](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPMaskedLanguageModeling.flux)
- [x] [Conditional Random Fields](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPConditionalRandomFields.flux)
- [x] [Hidden Markov Model](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPHiddenMarkovModel.flux)
- [x] [Latent Dirichlet Allocation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPLatentDirichletAllocation.flux)
- [x] [Lesk Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPLeskAlgorithm.flux)
- [x] [Stemming](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPStemming.flux)
- [x] [Porter Stemmer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPPorterStemmer.flux)
- [x] [Snowball Stemmer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPSnowballStemmer.flux)
- [x] [Lovins Stemmer](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPLovinsStemmer.flux)
- [x] [Sukhotin Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/nlp/ExampleOfIANLPSukhotinAlgorithm.flux)
#### Redes neurais (20 algoritmos)

- [x] [Perceptron](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisPerceptron.flux)
- [x] [Backpropagation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisBackpropagation.flux)
- [x] [Multilayer Perceptron](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisMultilayerPerceptron.flux)
- [x] [Hopfield Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisHopfieldNetwork.flux)
- [x] [Boltzmann Machine](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisBoltzmannMachine.flux)
- [x] [Restricted Boltzmann Machine](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisRestrictedBoltzmannMachine.flux)
- [x] [Deep Belief Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisDeepBeliefNetwork.flux)
- [x] [Radial Basis Function Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisRadialBasisFunctionNetwork.flux)
- [x] [Self-Organizing Map](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisSelfOrganizingMap.flux)
- [x] [Kohonen Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisKohonenNetwork.flux)
- [x] [Recurrent Neural Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisRecurrentNeuralNetwork.flux)
- [x] [LSTM](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisLSTM.flux)
- [x] [GRU](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisGRU.flux)
- [x] [Bidirectional RNN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisBidirectionalRNN.flux)
- [x] [Convolutional Neural Network](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisConvolutionalNeuralNetwork.flux)
- [x] [Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisAutoencoder.flux)
- [x] [Variational Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisVariationalAutoencoder.flux)
- [x] [Denoising Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisDenoisingAutoencoder.flux)
- [x] [Sparse Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisSparseAutoencoder.flux)
- [x] [Contractive Autoencoder](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/neural_networks/ExampleOfIARedesNeuraisContractiveAutoencoder.flux)
#### Reinforcement Learning (25 algoritmos)

- [x] [Dynamic Programming for MDP](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningDynamicProgrammingMDP.flux)
- [x] [Value Iteration](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningValueIteration.flux)
- [x] [Policy Iteration](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningPolicyIteration.flux)
- [x] [Monte Carlo RL](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningMonteCarloRL.flux)
- [x] [Temporal Difference Learning](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningTemporalDifferenceLearning.flux)
- [x] [TD(λ)](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningTDLambda.flux)
- [x] [Q-Learning](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningQLearning.flux)
- [x] [SARSA](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningSARSA.flux)
- [x] [Expected SARSA](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningExpectedSARSA.flux)
- [x] [Double Q-Learning](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningDoubleQLearning.flux)
- [x] [DQN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningDQN.flux)
- [x] [Double DQN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningDoubleDQN.flux)
- [x] [Dueling DQN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningDuelingDQN.flux)
- [x] [Rainbow DQN](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningRainbowDQN.flux)
- [x] [Policy Gradient](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningPolicyGradient.flux)
- [x] [REINFORCE](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningREINFORCE.flux)
- [x] [Actor-Critic](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningActorCritic.flux)
- [x] [A2C](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningA2C.flux)
- [x] [A3C](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningA3C.flux)
- [x] [PPO](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningPPO.flux)
- [x] [TRPO](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningTRPO.flux)
- [x] [SAC](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningSAC.flux)
- [x] [DDPG](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningDDPG.flux)
- [x] [TD3](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningTD3.flux)
- [x] [Monte Carlo Tree Search](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/reinforcement_learning/ExampleOfIAReinforcementLearningMonteCarloTreeSearch.flux)
#### Sistemas de recomendação (14 algoritmos)

- [x] [Collaborative Filtering](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoCollaborativeFiltering.flux)
- [x] [Content-Based Filtering](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoContentBasedFiltering.flux)
- [x] [Matrix Factorization](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoMatrixFactorization.flux)
- [x] [SVD Recommendation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoSVDRecommendation.flux)
- [x] [ALS](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoALS.flux)
- [x] [Apriori Recommendation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoAprioriRecommendation.flux)
- [x] [Eclat](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoEclat.flux)
- [x] [Neural Collaborative Filtering](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoNeuralCollaborativeFiltering.flux)
- [x] [Hybrid Recommendation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoHybridRecommendation.flux)
- [x] [Context-Aware Recommendation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoContextAwareRecommendation.flux)
- [x] [DeepFM](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoDeepFM.flux)
- [x] [Wide & Deep](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoWideAndDeep.flux)
- [x] [Knowledge Graph Recommendation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoKnowledgeGraphRecommendation.flux)
- [x] [Reinforcement Learning Recommendation](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/recommender_systems/ExampleOfIARecomendacaoReinforcementLearningRecommendation.flux)

### Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura (185 algoritmos)

#### Autômatos e linguagens formais (11 algoritmos)

- [x] [Powerset Construction](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosPowersetConstruction.flux)
- [x] [DFA Minimization](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosDFAMinimization.flux)
- [x] [Hopcroft DFA Minimization](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosHopcroftDFAMinimization.flux)
- [x] [Moore DFA Minimization](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosMooreDFAMinimization.flux)
- [x] [Brzozowski Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosBrzozowskiAlgorithm.flux)
- [x] [Thompson Construction](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosThompsonConstruction.flux)
- [x] [Glushkov Construction](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosGlushkovConstruction.flux)
- [x] [McNaughton-Yamada](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosMcNaughtonYamada.flux)
- [x] [CYK](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosCYK.flux)
- [x] [Earley](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosEarley.flux)
- [x] [Turing Machine Simulation Algorithms](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/automata/ExampleOfSistemasAutomatosTuringMachineSimulation.flux)

#### Bancos de dados e armazenamento (10 algoritmos)

- [x] [Nested Loop Join](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosNestedLoopJoin.flux)
- [x] [Block Nested Loop Join](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosBlockNestedLoopJoin.flux)
- [x] [Hash Join](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosHashJoin.flux)
- [x] [Sort-Merge Join](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosSortMergeJoin.flux)
- [x] [Grace Hash Join](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosGraceHashJoin.flux)
- [x] [ARIES](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosARIES.flux)
- [x] [Chase Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosChaseAlgorithm.flux)
- [x] [Two-Phase Locking](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosTwoPhaseLocking.flux)
- [x] [Timestamp Ordering](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosTimestampOrdering.flux)
- [x] [MVCC Algorithms](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/database/ExampleOfSistemasBancoDadosMVCCAlgorithms.flux)

#### Compiladores e parsing (18 algoritmos)

- [x] [Recursive Descent](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresRecursiveDescent.flux)
- [x] [Pratt Parser](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresPrattParser.flux)
- [x] [Packrat Parser](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresPackratParser.flux)
- [x] [CYK](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresCYK.flux)
- [x] [Earley Parser](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresEarleyParser.flux)
- [x] [GLR](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresGLR.flux)
- [x] [LL Parser](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresLLParser.flux)
- [x] [LR Parser](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresLRParser.flux)
- [x] [SLR](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresSLR.flux)
- [x] [LALR](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresLALR.flux)
- [x] [Canonical LR](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresCanonicalLR.flux)
- [x] [Operator-Precedence Parsing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresOperatorPrecedence.flux)
- [x] [Shunting-Yard](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresShuntingYard.flux)
- [x] [Sethi-Ullman](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresSethiUllman.flux)
- [x] [Hindley-Milner Type Inference](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresHindleyMilner.flux)
- [x] [Chaitin Register Allocation](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresChaitinRegisterAllocation.flux)
- [x] [C3 Linearization](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresC3Linearization.flux)
- [x] [Rete Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/compilers/ExampleOfSistemasCompiladoresReteAlgorithm.flux)

#### Computação concorrente e paralela (14 algoritmos)

- [x] [Parallel Prefix Sum / Scan](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelPrefixSum.flux)
- [x] [Parallel Reduction](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelReduction.flux)
- [x] [Bitonic Sort Parallel](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteBitonicSort.flux)
- [x] [Parallel Merge Sort](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelMergeSort.flux)
- [x] [Parallel Quicksort](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelQuicksort.flux)
- [x] [Parallel BFS](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelBFS.flux)
- [x] [Parallel DFS](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelDFS.flux)
- [x] [MapReduce](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteMapReduce.flux)
- [x] [Fork-Join](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteForkJoin.flux)
- [x] [Work Stealing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteWorkStealing.flux)
- [x] [BSP — Bulk Synchronous Parallel](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteBSP.flux)
- [x] [Gustafson’s Law e Amdahl’s Law](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteAmdahlGustafsonLaws.flux)
- [x] [CUDA Tiled Matrix Multiplication](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteCUDATiledMatrixMultiplication.flux)
- [x] [Parallel Shortest Paths](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/concurrent/ExampleOfSistemasConcorrenteParallelShortestPaths.flux)

#### Consenso e sistemas distribuídos descentralizados (16 algoritmos)

- [x] [Consistent Hashing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoConsistentHashingRing.flux)
- [x] [Rendezvous Hashing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoRendezvousHashing.flux)
- [x] [Gossip Protocol](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoGossipProtocol.flux)
- [x] [SWIM Membership Protocol](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoSWIMProtocol.flux)
- [x] [Chord Distributed Hash Table](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoChordDHT.flux)
- [x] [Kademlia](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoKademlia.flux)
- [x] [Two-Phase Commit](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoTwoPhaseCommit.flux)
- [x] [Three-Phase Commit](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoThreePhaseCommit.flux)
- [x] [Byzantine Fault Tolerant Consensus](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoByzantineFaultTolerance.flux)
- [x] [PBFT](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoPBFT.flux)
- [x] [HotStuff](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoHotStuff.flux)
- [x] [MapReduce](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoMapReduce.flux)
- [x] [Work Stealing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoWorkStealing.flux)
- [x] [Token Bucket](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoTokenBucket.flux)
- [x] [Leaky Bucket](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoLeakyBucket.flux)
- [x] [AIMD — Additive Increase, Multiplicative Decrease](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfSistemasConsensoAIMD.flux)

#### Criptografia moderna e hashing aplicado (24 algoritmos)

- [x] [AES-GCM](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaAESGCM.flux)
- [x] [ChaCha20-Poly1305](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaChaCha20Poly1305.flux)
- [x] [X25519](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaX25519.flux)
- [x] [Ed25519](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaEd25519.flux)
- [x] [HKDF](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaHKDF.flux)
- [x] [PBKDF2](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaPBKDF2.flux)
- [x] [BLAKE2](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaBLAKE2.flux)
- [x] [BLAKE3](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaBLAKE3.flux)
- [x] [Merkle Tree](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaMerkleTree.flux)
- [x] [Merkle–Damgård Construction](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaMerkleDamgard.flux)
- [x] [Fiat–Shamir Identification](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaFiatShamir.flux)
- [x] [Oblivious Transfer](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaObliviousTransfer.flux)
- [x] [Verifiable Random Function](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaVRF.flux)
- [x] [Shamir Secret Sharing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaShamirSecretSharing.flux)
- [x] [TLS Handshake](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaTLSHandshake.flux)
- [x] [Signal Double Ratchet](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaSignalDoubleRatchet.flux)
- [x] [Zero-Knowledge Proof (Schnorr Sigma-Protocol)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaZeroKnowledgeProof.flux)
- [x] [Criptografia Simétrica (Authenticated Encryption / SIV)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaAuthenticatedEncryption.flux)
- [x] [Criptografia Assimétrica (ECIES)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaECIES.flux)
- [x] [Hashes (Sponge Construction / Keccak)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaSpongeConstruction.flux)
- [x] [MACs e KDFs (Poly1305)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaPoly1305.flux)
- [x] [Assinaturas (Schnorr Signature)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaSchnorrSignature.flux)
- [x] [Protocolos (Diffie-Hellman Key Exchange)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaDiffieHellman.flux)
- [x] [Estruturas Autenticadas (Merkle Mountain Range)](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/crypto/ExampleOfSistemasCriptoModernaMerkleMountainRange.flux)

#### Primitivas criptográficas e cifras clássicas (37 algoritmos)

- [x] [RSA](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaRSA.flux)
- [x] [ElGamal](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaElGamal.flux)
- [x] [Diffie-Hellman](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaDiffieHellman.flux)
- [x] [Elliptic Curve Cryptography](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaECC.flux)
- [x] [ECDH](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaECDH.flux)
- [x] [DSA](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaDSA.flux)
- [x] [ECDSA](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaECDSA.flux)
- [x] [EdDSA](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaEdDSA.flux)
- [x] [AES](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaAES.flux)
- [x] [DES](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaDES.flux)
- [x] [3DES](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaTripleDES.flux)
- [x] [Blowfish](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaBlowfish.flux)
- [x] [Twofish](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaTwofish.flux)
- [x] [ChaCha20](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaChaCha20.flux)
- [x] [Salsa20](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaSalsa20.flux)
- [x] [RC4](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaRC4.flux)
- [x] [IDEA](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaIDEA.flux)
- [x] [Threefish](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaThreefish.flux)
- [x] [TEA](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaTEA.flux)
- [x] [MD5](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaMD5.flux)
- [x] [SHA-1](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaSHA1.flux)
- [x] [SHA-2](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaSHA2.flux)
- [x] [SHA-3](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaSHA3.flux)
- [x] [BLAKE](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaBLAKE.flux)
- [x] [RIPEMD](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaRIPEMD.flux)
- [x] [Whirlpool](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaWhirlpool.flux)
- [x] [HMAC](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaHMAC.flux)
- [x] [Poly1305](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaPoly1305.flux)
- [x] [SipHash](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaSipHash.flux)
- [x] [Argon2](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaArgon2.flux)
- [x] [bcrypt](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaBcrypt.flux)
- [x] [PBKDF2](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaPBKDF2.flux)
- [x] [scrypt](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaScrypt.flux)
- [x] [Shamir Secret Sharing](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaShamirSecretSharing.flux)
- [x] [Blum Blum Shub](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaBlumBlumShub.flux)
- [x] [Yarrow](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaYarrow.flux)
- [x] [Fortuna](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ciphers/ExampleOfSistemasCriptoClassicaFortuna.flux)

#### Redes de computadores e protocolos (6 algoritmos)

- [x] [Nagle's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/networking/ExampleOfSistemasRedesNagleAlgorithm.flux)
- [x] [Karn's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/networking/ExampleOfSistemasRedesKarnAlgorithm.flux)
- [x] [Exponential Backoff](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/networking/ExampleOfSistemasRedesExponentialBackoff.flux)
- [x] [Binary Exponential Backoff](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/networking/ExampleOfSistemasRedesBinaryExponentialBackoff.flux)
- [x] [Truncated Binary Exponential Backoff](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/networking/ExampleOfSistemasRedesTruncatedBinaryExponentialBackoff.flux)
- [x] [Luleå Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/networking/ExampleOfSistemasRedesLuleaAlgorithm.flux)

#### Sistemas distribuídos e coordenação clássica (19 algoritmos)

- [x] [Paxos](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoPaxos.flux)
- [x] [Multi-Paxos](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoMultiPaxos.flux)
- [x] [Raft](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoRaft.flux)
- [x] [Viewstamped Replication](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoViewstampedReplication.flux)
- [x] [Chandra-Toueg Consensus](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoChandraTouegConsensus.flux)
- [x] [Bully Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoBullyAlgorithm.flux)
- [x] [Ring Election](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoRingElection.flux)
- [x] [Ricart-Agrawala](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoRicartAgrawala.flux)
- [x] [Maekawa](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoMaekawa.flux)
- [x] [Raymond](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoRaymond.flux)
- [x] [Lamport Distributed Mutual Exclusion](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoLamportMutex.flux)
- [x] [Lamport Logical Clock](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoLamportClock.flux)
- [x] [Vector Clock](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoVectorClock.flux)
- [x] [Cristian's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoCristianAlgorithm.flux)
- [x] [Berkeley Clock Synchronization](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoBerkeleyAlgorithm.flux)
- [x] [Marzullo's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoMarzulloAlgorithm.flux)
- [x] [Chandy-Lamport Snapshot](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoChandyLamportSnapshot.flux)
- [x] [Dijkstra-Scholten](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoDijkstraScholten.flux)
- [x] [Huang Termination Detection](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/coordination/ExampleOfSistemasCoordenacaoHuangTerminationDetection.flux)

#### Sistemas operacionais e gerenciamento de recursos (30 algoritmos)

- [x] [FCFS Scheduling](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisFCFSScheduling.flux)
- [x] [Shortest Job First](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisShortestJobFirst.flux)
- [x] [Shortest Remaining Time](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisShortestRemainingTime.flux)
- [x] [Round Robin](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisRoundRobin.flux)
- [x] [Priority Scheduling](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisPriorityScheduling.flux)
- [x] [Multilevel Queue](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisMultilevelQueue.flux)
- [x] [Multilevel Feedback Queue](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisMultilevelFeedbackQueue.flux)
- [x] [Earliest Deadline First](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisEarliestDeadlineFirst.flux)
- [x] [Rate Monotonic](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisRateMonotonic.flux)
- [x] [Least Slack Time](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisLeastSlackTime.flux)
- [x] [List Scheduling](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisListScheduling.flux)
- [x] [Banker's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisBankersAlgorithm.flux)
- [x] [Peterson's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisPetersonAlgorithm.flux)
- [x] [Dekker's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisDekkerAlgorithm.flux)
- [x] [Lamport Bakery](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisLamportBakery.flux)
- [x] [LRU Page Replacement](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisLRUPageReplacement.flux)
- [x] [FIFO Page Replacement](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisFIFOPageReplacement.flux)
- [x] [Clock Page Replacement](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisClockPageReplacement.flux)
- [x] [ARC](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisARC.flux)
- [x] [Buddy Memory Allocation](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisBuddyMemoryAllocation.flux)
- [x] [Mark-and-Sweep](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisMarkAndSweep.flux)
- [x] [Mark-Compact](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisMarkCompact.flux)
- [x] [Cheney's Algorithm](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisCheneysAlgorithm.flux)
- [x] [Reference Counting](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisReferenceCounting.flux)
- [x] [Generational Garbage Collection](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisGenerationalGarbageCollection.flux)
- [x] [SCAN Disk Scheduling](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisSCANDiskScheduling.flux)
- [x] [C-SCAN](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisCSCAN.flux)
- [x] [LOOK](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisLOOK.flux)
- [x] [C-LOOK](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisCLOOK.flux)
- [x] [Shortest Seek Time First](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/operating_systems/ExampleOfSistemasOperacionaisShortestSeekTimeFirst.flux)



### Domínio X: Bioinformática, Computação Quântica & Criptografia Pós-Quântica (96 algoritmos)

| Nome do Algoritmo                                            | Local em Disco                                                                                                 |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| **BLAST**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaBLAST.flux) |
| **Genome Breakpoint Distance**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaBreakpointDistance.flux) |
| **Burrows-Wheeler Genome Alignment**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaBurrowsWheelerGenomeAlignment.flux) |
| **CRISPR Protospacer & PAM Search**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaCRISPRProtospacerSearch.flux) |
| **DALI Protein Structural Alignment**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaDALIProteinAlignment.flux) |
| **de Bruijn Graph Assembly**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaDeBruijnGraphAssembly.flux) |
| **Distance Geometry Protein Folding**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaDistanceGeometryFolding.flux) |
| **Felsenstein's Tree Pruning**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaFelsensteinPruning.flux) |
| **Fitch's Small Parsimony Algorithm**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaFitchSmallParsimony.flux) |
| **Hirschberg**                                               | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaHirschberg.flux) |
| **Kabsch Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaKabschAlgorithm.flux) |
| **Maximum Parsimony**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaMaximumParsimony.flux) |
| **Needleman-Wunsch**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaNeedlemanWunsch.flux) |
| **Neighbor-Joining**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaNeighborJoining.flux) |
| **Zuker RNA Minimum Free Energy (MFE)**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaRNAZukerMFE.flux) |
| **Ramachandran Plot Dihedral Validation**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaRamachandranPlot.flux) |
| **Sankoff's Generalized Parsimony**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaSankoffParsimony.flux) |
| **MEM Seed-and-Extend (BWA-MEM)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaSeedAndExtendMEM.flux) |
| **Smith-Waterman**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaSmithWaterman.flux) |
| **Sorting by Signed Reversals**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaSortingBySignedReversals.flux) |
| **UPGMA**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaUPGMA.flux) |
| **Velvet Assembly**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaVelvetAssembly.flux) |
| **Viterbi**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfBioInformaticaViterbi.flux) |
| **Amplitude Amplification**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaAmplitudeAmplification.flux) |
| **Amplitude Estimation**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaAmplitudeEstimation.flux) |
| **Bacon-Shor Subsystem Quantum Code**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaBaconShorCode.flux) |
| **Bernstein-Vazirani**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaBernsteinVazirani.flux) |
| **Boson Sampling**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaBosonSampling.flux) |
| **Deutsch Algorithm**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaDeutschAlgorithm.flux) |
| **Deutsch-Jozsa**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaDeutschJozsa.flux) |
| **Fixed-Point Grover Search**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaFixedPointGrover.flux) |
| **Grover's Algorithm**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaGroversAlgorithm.flux) |
| **HHL**                                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaHHL.flux) |
| **Hadamard Test**                                            | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaHadamardTest.flux) |
| **Hamiltonian Simulation**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaHamiltonianSimulation.flux) |
| **Hidden Shift Algorithm**                                   | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaHiddenShift.flux) |
| **Hidden Subgroup Algorithm**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaHiddenSubgroup.flux) |
| **Quantum Phase Estimation (Iterative)**                     | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaIterativePhaseEstimation.flux) |
| **Iterative Quantum Phase Estimation (IQPE)**                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaIterativeQPE.flux) |
| **Knill-Laflamme QEC Verification**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaKnillLaflammeVerification.flux) |
| **MWPM Surface Code Syndrome Decoder**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaMWPMSyndromeDecoder.flux) |
| **Magic State Distillation (15-to-1)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaMagicStateDistillation.flux) |
| **QAOA**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQAOA.flux) |
| **Quantum RAM (Bucket-Brigade Architecture)**                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQRAMBucketBrigade.flux) |
| **Quantum Singular Value Transformation (QSVT)**             | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQSVT.flux) |
| **Quantum Annealing**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumAnnealing.flux) |
| **Quantum Counting**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumCounting.flux) |
| **Quantum Dense Coding**                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumDenseCoding.flux) |
| **Quantum Fourier Transform**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumFourierTransform.flux) |
| **Quantum Kernel Estimation (QSVM)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumKernelSVM.flux) |
| **Quantum Phase Estimation**                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumPhaseEstimation.flux) |
| **Quantum Search**                                           | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumSearch.flux) |
| **Quantum Teleportation**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumTeleportation.flux) |
| **Quantum Walk**                                             | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumWalk.flux) |
| **Quantum Walk Search**                                      | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaQuantumWalkSearch.flux) |
| **Shor's Algorithm**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaShorsAlgorithm.flux) |
| **Simon's Algorithm**                                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaSimonsAlgorithm.flux) |
| **Swap Test**                                                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaSwapTest.flux) |
| **Kitaev Toric Code (Topological Memory)**                   | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaToricCodeKitaev.flux) |
| **Variational Quantum Eigensolver**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaVQE.flux) |
| **Quantum Principal Component Analysis (qPCA)**              | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfComputacaoQuanticaqPCA.flux) |
| **BIKE (Bit Flipping Key Encapsulation)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaBIKE.flux) |
| **BKZ (Block Korkine-Zolotarev)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaBKZ.flux) |
| **Babai’s Nearest Plane**                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaBabaiNearestPlane.flux) |
| **Bimodal Continuous LWE (CLWE)**                            | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaBimodalCLWE.flux) |
| **CSIDH**                                                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaCSIDH.flux) |
| **Classic McEliece**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaClassicMcEliece.flux) |
| **FORS (Forest of Random Subsets)**                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaFORS.flux) |
| **FN-DSA (Falcon)**                                          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaFalcon.flux) |
| **FrodoKEM**                                                 | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaFrodoKEM.flux) |
| **Transformada de Fujisaki-Okamoto (FO Transform)**          | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaFujisakiOkamoto.flux) |
| **Decodificador de Goppa (Patterson)**                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaGoppaDecoder.flux) |
| **HQC (Hamming Quasi-Cyclic)**                               | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaHQC.flux) |
| **KEM Híbrido Pós-Quântico (X25519 + ML-KEM-768)**           | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaHybridKEM.flux) |
| **Information Set Decoding (ISD / Algoritmo de Prange)**     | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaInformationSetDecoding.flux) |
| **LLL (Lenstra–Lenstra–Lovász)**                             | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaLLL.flux) |
| **LMS (Leighton-Micali Signatures)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaLMS.flux) |
| **Learning With Errors (LWE / Ring-LWE)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaLWE.flux) |
| **Lamport One-Time Signature (OTS)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaLamportOTS.flux) |
| **Dual-LWE Lattice Attack Estimator**                        | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaLatticeDualAttackEstimator.flux) |
| **MAYO**                                                     | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaMAYO.flux) |
| **MAYO Folded UOV Signature Scheme**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaMAYOSignature.flux) |
| **ML-DSA (CRYSTALS-Dilithium)**                              | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaMLDSA.flux) |
| **ML-KEM (CRYSTALS-Kyber)**                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaMLKEM.flux) |
| **Montgomery Curve Isogeny Point Arithmetic**                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaMontgomeryCurveIsogeny.flux) |
| **NTRU (NTRUEncrypt)**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaNTRUEncrypt.flux) |
| **Niederreiter Cryptosystem**                                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaNiederreiter.flux) |
| **Rainbow**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaRainbow.flux) |
| **Short Integer Solution (SIS / Module-SIS)**                | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaSIS.flux) |
| **SLH-DSA (SPHINCS+)**                                       | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaSLHDSA.flux) |
| **SNOVA Multivariate Signature Scheme**                      | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaSNOVASignature.flux) |
| **SQISign**                                                  | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaSQISign.flux) |
| **UOV (Unbalanced Oil and Vinegar)**                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaUOV.flux) |
| **Fórmulas de Vélu**                                         | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaVeluFormulas.flux) |
| **Winternitz One-Time Signature (WOTS+)**                    | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaWOTSPlus.flux) |
| **XMSS (eXtended Merkle Signature Scheme)**                  | (file:///D:/Projetos/TheFlux/examples/algorithms/10_bio_quantum/ExampleOfCriptografiaPosQuanticaXMSS.flux) |

