# 🔬 TODO_SciAlgo: Catálogo e Roadmap de Algoritmos Científicos em TheFlux

> **Status**: Planejamento e Roteiro de Implementação  
> **Origem**: Baseado no catálogo exaustivo de `docs/TODO_algo.txt`  
> **Suíte Alvo**: `examples/algorithms/` com execução nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)

---

## 📊 1. Resumo Executivo & Métricas do Catálogo

- **Total de Entradas Catalogadas**: 1.278 algoritmos (1.294 nos títulos temáticos)
- **Algoritmos Já Implementados**: **201** (167 na suíte [`examples/algorithms/`](file:///D:/Projetos/TheFlux/examples/algorithms) + 35 em [`flux/`](file:///D:/Projetos/TheFlux/flux))
- **Algoritmos a Implementar**: **1.077** algoritmos restantes
- **Taxa de Conclusão Global**: **15,7%**
- **Suíte Ativa (`examples/algorithms/`)**: **166** arquivos `.flux` com 100% de paridade nos 6 backends
- **Divisão Estrutural**: **10 Grandes Domínios Científicos** e **49 Categorias Temáticas**

### Tabela de Domínios e Volumes

| Domínio | Escopo Temático | Total de Algoritmos | Implementados | % Concluído | Status |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Domínio I: Fundamentos, Busca e Ordenação** | Subcategorias especializadas | **149** | **149** | **100,0%** | ✅ Concluído |
| **Domínio II: Estruturas de Dados Avançadas & Streaming** | Subcategorias especializadas | **63** | **7** | **11,1%** | 🔄 Em andamento |
| **Domínio III: Teoria dos Grafos & Redes** | Subcategorias especializadas | **119** | **9** | **7,6%** | 🔄 Em andamento |
| **Domínio IV: Strings, Texto & Teoria da Informação** | Subcategorias especializadas | **105** | **9** | **8,6%** | 🔄 Em andamento |
| **Domínio V: Matemática Computacional, Teoria dos Números & Álgebra** | Subcategorias especializadas | **143** | **10** | **7,0%** | 🔄 Em andamento |
| **Domínio VI: Métodos Numéricos, Geometria & Física Computacional** | Subcategorias especializadas | **144** | **0** | **0,0%** | ⏳ Planejado |
| **Domínio VII: Otimização & Estatística Científica** | Subcategorias especializadas | **84** | **0** | **0,0%** | ⏳ Planejado |
| **Domínio VIII: Inteligência Artificial, ML & Deep Learning** | Subcategorias especializadas | **245** | **1** | **0,4%** | 🔄 Em andamento |
| **Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura** | Subcategorias especializadas | **185** | **16** | **8,6%** | 🔄 Em andamento |
| **Domínio X: Bioinformática & Computação Quântica** | Subcategorias especializadas | **41** | **0** | **0,0%** | ⏳ Planejado |
| **Total Geral** | **10 Grandes Domínios** | **1.278** | **201** | **15,7%** | 🚀 **Suíte Ativa** |

---
## 📁 2. Arquitetura da Suíte e Diretórios

Os algoritmos serão organizados de forma hierárquica e modular sob a pasta `examples/algorithms/`:

```text
TheFlux/
├── examples/
│   └── algorithms/
│       ├── 01_foundations/         # Paradigmas, Busca, Ordenação, Arrays, Especiais
│       ├── 02_data_structures/     # DSU, AVL, Red-Black, Segment Tree, Heaps, Cuckoo, Streaming
│       ├── 03_graphs/              # DFS, BFS, Dijkstra, Kruskal, Dinic, Bron-Kerbosch
│       ├── 04_strings/             # KMP, Aho-Corasick, Suffix Array, Levenshtein, Huffman, LZ77
│       ├── 05_mathematics/         # Crivos, Miller-Rabin, FFT/NTT, Álgebra Linear, Decomposições
│       ├── 06_numerical_physics/   # Newton-Raphson, Runge-Kutta, N-Body, Verlet, Voronoi, Delaunay
│       ├── 07_optimization_stat/   # Adam, Simplex, Genético, MCMC, Kalman, PCA
│       ├── 08_artificial_intel/    # Regressões, Árvores, SVM, MLP Backprop, CNN, Transformer, Q-Learning
│       ├── 09_systems_infra/       # Shunting-Yard, Pratt, Thompson DFA, AES, RSA, Paxos, Raft, Joins
│       └── 10_bio_quantum/         # BLAST, Needleman-Wunsch, UPGMA, Grover, Deutsch-Jozsa, QFT
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
- **Fase 10: Bioinformática, Algoritmos Quânticos & Catálogo Final (Domínio X)**: BLAST, Needleman-Wunsch, Grover, Deutsch-Jozsa, QFT.

---

## ⭐ 5. As 15 Recomendações Prioritárias de Alto Impacto

Algoritmos de especial relevância para sistemas modernos destacados para implementação prioritária (todos 100% implementados em TheFlux nativo e verdes nos 6 backends):

- [x] **Binary Heap** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfBinaryHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfBinaryHeap.flux))*
- [x] **Hash Table** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfHashTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfHashTable.flux))*
- [x] **Persistent Segment Tree** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfPersistentSegmentTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfPersistentSegmentTree.flux))*
- [x] **Wavelet Tree** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfWaveletTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfWaveletTree.flux))*
- [x] **Chu–Liu/Edmonds** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfChuLiuEdmonds.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfChuLiuEdmonds.flux))*
- [x] **Yen’s Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfYenKShortestPaths.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfYenKShortestPaths.flux))*
- [x] **Bron–Kerbosch** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfBronKerbosch.flux))*
- [x] **Christofides’ Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfChristofidesTSP.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfChristofidesTSP.flux))*
- [x] **Misra–Gries** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfMisraGriesStreaming.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfMisraGriesStreaming.flux))*
- [x] **Consistent Hashing** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfConsistentHashingRing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfConsistentHashingRing.flux) e [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [x] **Gossip Protocol** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfGossipProtocol.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfGossipProtocol.flux))*
- [x] **PBFT** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfPBFTConsensus.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfPBFTConsensus.flux))*
- [x] **MapReduce** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfMapReducePipeline.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfMapReducePipeline.flux))*
- [x] **Merkle Tree** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfMerkleTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfMerkleTree.flux))*
- [x] **HNSW** — *(Implementado em [`examples/algorithms/08_artificial_intel/ExampleOfHNSWVectorSearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ExampleOfHNSWVectorSearch.flux))*
---

## 📚 6. Catálogo Completo dos 1.294 Algoritmos por Domínio

### Domínio I: Fundamentos, Busca e Ordenação (149 algoritmos)

#### 1. Fundamentos e paradigmas algorítmicos (25 algoritmos)

- [x] **Brute Force** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsBruteForce.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsBruteForce.flux))*
- [x] **Divide and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDivideAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDivideAndConquer.flux))*
- [x] **Decrease and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDecreaseAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDecreaseAndConquer.flux))*
- [x] **Transform and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsTransformAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsTransformAndConquer.flux))*
- [x] **Greedy Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsGreedyAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsGreedyAlgorithm.flux))*
- [x] **Dynamic Programming** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDynamicProgramming.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDynamicProgramming.flux))*
- [x] **Backtracking** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsBacktracking.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsBacktracking.flux))*
- [x] **Branch and Bound** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsBranchAndBound.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsBranchAndBound.flux))*
- [x] **Meet-in-the-Middle** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsMeetInTheMiddle.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsMeetInTheMiddle.flux))*
- [x] **Randomized Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsRandomizedAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsRandomizedAlgorithm.flux))*
- [x] **Monte Carlo Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsMonteCarloAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsMonteCarloAlgorithm.flux))*
- [x] **Las Vegas Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsLasVegasAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsLasVegasAlgorithm.flux))*
- [x] **Online Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsOnlineAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsOnlineAlgorithm.flux))*
- [x] **Offline Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsOfflineAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsOfflineAlgorithm.flux))*
- [x] **Approximation Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsApproximationAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsApproximationAlgorithm.flux))*
- [x] **Streaming Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsStreamingAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsStreamingAlgorithm.flux))*
- [x] **Amortized Algorithms** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsAmortizedAlgorithms.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsAmortizedAlgorithms.flux))*
- [x] **Incremental Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsIncrementalAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsIncrementalAlgorithm.flux))*
- [x] **Decremental Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDecrementalAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDecrementalAlgorithm.flux))*
- [x] **Parallel Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsParallelAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsParallelAlgorithm.flux))*
- [x] **Distributed Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDistributedAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsDistributedAlgorithm.flux))*
- [x] **External-Memory Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsExternalMemoryAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsExternalMemoryAlgorithm.flux))*
- [x] **External Sorting** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsExternalSorting.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsExternalSorting.flux))*
- [x] **Heuristic Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsHeuristicSearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsHeuristicSearch.flux))*
- [x] **Metaheuristic Optimization** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsMetaheuristicOptimization.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfAlgorithmicFoundationsAndParadigmsMetaheuristicOptimization.flux))*

#### 2. Busca (33 algoritmos)

- [x] **Linear Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchSequencial.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchSequencial.flux))*
- [x] **Binary Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchBinaria.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchBinaria.flux))*
- [x] **Ternary Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchTernary.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchTernary.flux))*
- [x] **Fibonacci Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchFibonacci.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchFibonacci.flux))*
- [x] **Jump Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchJump.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchJump.flux))*
- [x] **Interpolation Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchInterpolation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchInterpolation.flux))*
- [x] **Exponential Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchExponential.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchExponential.flux))*
- [x] **Uniform Binary Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchUniformBinary.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchUniformBinary.flux))*
- [x] **Eytzinger Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchEytzinger.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchEytzinger.flux))*
- [x] **Depth-First Search — DFS** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchEmProfundidade.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchEmProfundidade.flux))*
- [x] **Breadth-First Search — BFS** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchEmLargura.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchEmLargura.flux))*
- [x] **Bidirectional Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchBidirectional.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchBidirectional.flux))*
- [x] **Iterative Deepening DFS** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchIDDFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchIDDFS.flux))*
- [x] **Iterative Deepening A\*** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchIterativeDeepeningAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchIterativeDeepeningAStar.flux))*
- [x] **Uniform-Cost Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchUniformCost.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchUniformCost.flux))*
- [x] **Best-First Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchBestFirst.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchBestFirst.flux))*
- [x] **Beam Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchBeam.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchBeam.flux))*
- [x] **Beam Stack Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchBeamStack.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchBeamStack.flux))*
- [x] **A\*** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchAStar.flux))*
- [x] **B\*** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchBStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchBStar.flux))*
- [x] **D\*** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchDStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchDStar.flux))*
- [x] **D\* Lite** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchDStarLite.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchDStarLite.flux))*
- [x] **Jump Point Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchJumpPoint.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchJumpPoint.flux))*
- [x] **IDA\*** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchIDAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchIDAStar.flux))*
- [x] **SMA\*** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchSMAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchSMAStar.flux))*
- [x] **Recursive Best-First Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchRBFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchRBFS.flux))*
- [x] **Minimax** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchMinimax.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchMinimax.flux))*
- [x] **Expectimax** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchExpectimax.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchExpectimax.flux))*
- [x] **Alpha-Beta Pruning** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchAlphaBeta.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchAlphaBeta.flux))*
- [x] **Negamax** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchNegamax.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchNegamax.flux))*
- [x] **Principal Variation Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchPVS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchPVS.flux))*
- [x] **MTD(f)** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchMTDf.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchMTDf.flux))*
- [x] **Monte Carlo Tree Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchMCTS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchMCTS.flux))*

#### 3. Ordenação (42 algoritmos)

- [x] **Bubble Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBubble.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBubble.flux))*
- [x] **Cocktail Shaker Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortShaker.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortShaker.flux))*
- [x] **Comb Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortComb.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortComb.flux))*
- [x] **Gnome Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortGnome.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortGnome.flux))*
- [x] **Odd-Even Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortOddEven.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortOddEven.flux))*
- [x] **Insertion Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortInsertion.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortInsertion.flux))*
- [x] **Selection Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortSelection.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortSelection.flux))*
- [x] **Shell Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortShell.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortShell.flux))*
- [x] **Quick Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortQuick.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortQuick.flux))*
- [x] **Randomized QuickSort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortRandomizedQuick.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortRandomizedQuick.flux))*
- [x] **Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortMerge.flux) e [`examples/algorithms/01_foundations/ExampleOfSortMergeTopDown.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortMergeTopDown.flux))*
- [x] **Bottom-Up Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortMergeBottomUp.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortMergeBottomUp.flux))*
- [x] **Heap Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortHeap.flux))*
- [x] **Tree Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortTree.flux))*
- [x] **Cycle Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortCycle.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortCycle.flux))*
- [x] **Counting Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortCounting.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortCounting.flux))*
- [x] **Radix Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortRadix.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortRadix.flux))*
- [x] **Bucket Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBucket.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBucket.flux))*
- [x] **Pigeonhole Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortPigeonhole.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortPigeonhole.flux))*
- [x] **Flashsort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortFlash.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortFlash.flux))*
- [x] **Patience Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortPatience.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortPatience.flux))*
- [x] **Strand Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortStrand.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortStrand.flux))*
- [x] **Library Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortLibrary.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortLibrary.flux))*
- [x] **Bead Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBead.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBead.flux))*
- [x] **Pancake Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortPancake.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortPancake.flux))*
- [x] **Bitonic Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBitonic.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBitonic.flux))*
- [x] **Bitonic Sorting Network** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBitonicNetwork.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBitonicNetwork.flux))*
- [x] **Odd-Even Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortOddEvenMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortOddEvenMerge.flux))*
- [x] **Stooge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortStooge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortStooge.flux))*
- [x] **Slowsort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortSlow.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortSlow.flux))*
- [x] **Bogosort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBogo.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBogo.flux))*
- [x] **Spaghetti Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortSpaghetti.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortSpaghetti.flux))*
- [x] **Burstsort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortBurst.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortBurst.flux))*
- [x] **Postman Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortPostman.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortPostman.flux))*
- [x] **Introsort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortIntro.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortIntro.flux))*
- [x] **Timsort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortTim.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortTim.flux))*
- [x] **Smoothsort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortSmooth.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortSmooth.flux))*
- [x] **Tournament Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortTournament.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortTournament.flux))*
- [x] **External Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortExternalMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortExternalMerge.flux))*
- [x] **Polyphase Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortPolyphaseMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortPolyphaseMerge.flux))*
- [x] **Natural Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortNaturalMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortNaturalMerge.flux))*
- [x] **Samplesort** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSortSample.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSortSample.flux))*

#### 4. Arrays e sequências (30 algoritmos)

- [x] **Two-Pointer Technique** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysTwoPointer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysTwoPointer.flux))*
- [x] **Sliding Window** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysSlidingWindow.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysSlidingWindow.flux))*
- [x] **Fast and Slow Pointers** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysFastAndSlowPointers.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysFastAndSlowPointers.flux))*
- [x] **Kadane's Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysKadane.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysKadane.flux))*
- [x] **Boyer-Moore Majority Vote** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysBoyerMooreMajorityVote.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysBoyerMooreMajorityVote.flux))*
- [x] **Dutch National Flag** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysDutchNationalFlag.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysDutchNationalFlag.flux))*
- [x] **Fisher-Yates Shuffle** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysFisherYates.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysFisherYates.flux))*
- [x] **Reservoir Sampling** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysReservoirSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysReservoirSampling.flux))*
- [x] **Floyd Random Sampling** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysFloydRandomSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysFloydRandomSampling.flux))*
- [x] **Quickselect** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysQuickselect.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysQuickselect.flux))*
- [x] **Introselect** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysIntroselect.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysIntroselect.flux))*
- [x] **Median of Medians** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysMedianOfMedians.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysMedianOfMedians.flux))*
- [x] **Mo's Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysMosAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysMosAlgorithm.flux))*
- [x] **Mo's Algorithm with Modifications** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysMosAlgorithmWithModifications.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysMosAlgorithmWithModifications.flux))*
- [x] **Offline Query Processing** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysOfflineQueryProcessing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysOfflineQueryProcessing.flux))*
- [x] **Parallel Binary Search** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysParallelBinarySearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysParallelBinarySearch.flux))*
- [x] **CDQ Divide and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysCDQDivideAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysCDQDivideAndConquer.flux))*
- [x] **Square-Root Decomposition** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysSquareRootDecomposition.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysSquareRootDecomposition.flux))*
- [x] **Sparse Table** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysSparseTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysSparseTable.flux))*
- [x] **Range Minimum Query** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysRangeMinimumQuery.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysRangeMinimumQuery.flux))*
- [x] **Range Maximum Query** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysRangeMaximumQuery.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysRangeMaximumQuery.flux))*
- [x] **Prefix Sum** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysPrefixSum.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysPrefixSum.flux))*
- [x] **Difference Array** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysDifferenceArray.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysDifferenceArray.flux))*
- [x] **Difference Constraints** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysDifferenceConstraints.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysDifferenceConstraints.flux))*
- [x] **Monotonic Stack** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysMonotonicStack.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysMonotonicStack.flux))*
- [x] **Monotonic Queue** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysMonotonicQueue.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysMonotonicQueue.flux))*
- [x] **Sliding Window Minimum** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysSlidingWindowMinimum.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysSlidingWindowMinimum.flux))*
- [x] **Sliding Window Maximum** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysSlidingWindowMaximum.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysSlidingWindowMaximum.flux))*
- [x] **Coordinate Compression** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysCoordinateCompression.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysCoordinateCompression.flux))*
- [x] **Sweep Line** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfArraysSweepLine.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfArraysSweepLine.flux))*

#### 42. Algoritmos especiais (19 algoritmos)

- [x] **Josephus** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsJosephus.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsJosephus.flux))*
- [x] **Tortoise and Hare** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsTortoiseAndHare.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsTortoiseAndHare.flux))*
- [x] **Brent's Cycle Detection** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsBrent.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsBrent.flux))*
- [x] **Ackermann Function** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsAckermann.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsAckermann.flux))*
- [x] **Doomsday Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsDoomsday.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsDoomsday.flux))*
- [x] **Zeller's Congruence** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsZeller.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsZeller.flux))*
- [x] **Easter Algorithms** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsEaster.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsEaster.flux))*
- [x] **Zobrist Hashing** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsZobrist.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsZobrist.flux))*
- [x] **Cuckoo Hashing** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsCuckoo.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsCuckoo.flux))*
- [x] **Bloom Filter** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsBloomFilter.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsBloomFilter.flux))*
- [x] **Skip List Algorithms** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsSkipList.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsSkipList.flux))*
- [x] **Reservoir Sampling** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsReservoirSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsReservoirSampling.flux))*
- [x] **Alias Method** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsAliasMethod.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsAliasMethod.flux))*
- [x] **Shunting-Yard** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsShuntingYard.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsShuntingYard.flux))*
- [x] **Ramer-Douglas-Peucker** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsRamerDouglasPeucker.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsRamerDouglasPeucker.flux))*
- [x] **Kahan Summation** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsKahanSummation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsKahanSummation.flux))*
- [x] **Horner's Method** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsHorner.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsHorner.flux))*
- [x] **Booth's Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsBooth.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsBooth.flux))*
- [x] **Fast Doubling** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsFastDoubling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSpecialAlgorithmsFastDoubling.flux))*

### Domínio II: Estruturas de Dados Avançadas & Streaming (63 algoritmos)

#### 5. Estruturas de dados e algoritmos associados (42 algoritmos)

- [ ] Disjoint Set Union
- [ ] Union-Find
- [ ] Fenwick Tree
- [ ] Segment Tree
- [ ] Lazy Propagation
- [ ] Sparse Table
- [ ] Sqrt Tree
- [ ] Treap
- [ ] Randomized Treap
- [ ] Splay Tree
- [ ] AVL Tree
- [ ] Red-Black Tree
- [ ] B-Tree
- [ ] B+ Tree
- [ ] 2-3 Tree
- [ ] 2-3-4 Tree
- [ ] Trie
- [ ] Radix Tree
- [ ] Patricia Trie
- [ ] Ternary Search Tree
- [ ] Suffix Tree
- [ ] Suffix Automaton
- [ ] Skip List
- [ ] Interval Tree
- [ ] Range Tree
- [ ] KD-Tree
- [ ] Quadtree
- [ ] Octree
- [ ] Cartesian Tree
- [ ] Link-Cut Tree
- [ ] Heavy-Light Decomposition
- [ ] Centroid Decomposition
- [ ] DSU on Tree
- [ ] Euler Tour Tree
- [ ] Rope
- [x] **Bloom Filter** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [ ] Cuckoo Hashing
- [ ] Cuckoo Filter
- [ ] Count-Min Sketch
- [ ] HyperLogLog
- [x] **MinHash** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [ ] Locality-Sensitive Hashing

#### Estruturas de dados (Adições Prioritárias) (12 algoritmos)

> A lista cita várias árvores avançadas, mas não destaca suficientemente estruturas extremamente usadas na prática, como heaps, tabelas hash e caches.

- [x] **Binary Heap** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfBinaryHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfBinaryHeap.flux))*
- [ ] D-ary Heap
- [ ] Pairing Heap
- [ ] Van Emde Boas Tree
- [x] **Wavelet Tree** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfWaveletTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfWaveletTree.flux))*
- [x] **Persistent Segment Tree** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfPersistentSegmentTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfPersistentSegmentTree.flux))*
- [ ] Persistent Data Structures
- [x] **Hash Table** — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfHashTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfHashTable.flux))*
- [ ] Robin Hood Hashing
- [ ] Hopscotch Hashing
- [ ] LRU Cache
- [ ] LFU Cache

#### 3. Algoritmos de seleção e streaming (Adições Prioritárias) (9 algoritmos)

> Essa área está presente, mas poderia ser organizada como algoritmos para dados massivos e streaming.

- [ ] Floyd’s Tortoise and Hare Algorithm — embora a ideia apareça como “Tortoise and Hare”, deveria estar também na seção de arrays e sequências
- [ ] Brent’s Cycle Detection — já aparece apenas no final
- [x] **Misra–Gries Algorithm** — elementos frequentes em streams — *(Implementado em [`examples/algorithms/02_data_structures/ExampleOfMisraGriesStreaming.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/ExampleOfMisraGriesStreaming.flux))*
- [ ] Space-Saving Algorithm — top-k em streams
- [ ] Count-Min Sketch já aparece
- [ ] HyperLogLog já aparece
- [ ] Flajolet–Martin Algorithm
- [ ] Min-wise Independent Permutations
- [ ] Reservoir Sampling já aparece

### Domínio III: Teoria dos Grafos & Redes (119 algoritmos)

#### 6. Grafos — representação, travessia e conectividade (40 algoritmos)

- [x] **DFS** — *(Já implementado em [`flux/ExampleOfBuscaEmProfundidade.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaEmProfundidade.flux))*
- [x] **BFS** — *(Já implementado em [`flux/ExampleOfBuscaEmLargura.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaEmLargura.flux))*
- [ ] Connected Components
- [ ] Strongly Connected Components
- [ ] Kosaraju
- [ ] Tarjan SCC
- [ ] Gabow SCC
- [ ] Path-Based SCC
- [ ] Topological Sort
- [ ] Kahn's Algorithm
- [ ] Cycle Detection
- [ ] Bipartite Graph Test
- [ ] Articulation Points
- [ ] Bridge Finding
- [ ] Online Bridge Finding
- [ ] Biconnected Components
- [ ] Block-Cut Tree
- [ ] 2-SAT
- [ ] Graph Condensation
- [ ] Transitive Closure
- [ ] Warshall Algorithm
- [ ] Eulerian Path
- [ ] Eulerian Circuit
- [ ] Hierholzer
- [ ] Prüfer Code
- [ ] Tree Diameter
- [ ] Tree Center
- [ ] Tree Centroid
- [ ] Tree Isomorphism
- [ ] Tree Traversal
- [ ] Euler Tour Technique
- [ ] Lowest Common Ancestor
- [ ] Binary Lifting
- [ ] Tarjan Offline LCA
- [ ] Farach-Colton and Bender LCA
- [ ] Heavy-Light Decomposition
- [ ] Centroid Decomposition
- [ ] DSU on Tree
- [ ] Rerooting
- [ ] Virtual Tree

#### 7. Caminhos mínimos (19 algoritmos)

- [x] **Dijkstra** — *(Implementado em [`examples/algorithms/01_foundations/ExampleOfSearchDijkstra.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/ExampleOfSearchDijkstra.flux))*
- [ ] Bidirectional Dijkstra
- [ ] Bellman-Ford
- [ ] SPFA
- [ ] 0-1 BFS
- [ ] Dial's Algorithm
- [ ] D'Esopo-Pape
- [ ] Floyd-Warshall
- [ ] Johnson
- [x] **A*** — *(Já implementado em [`flux/ExampleOfBuscaAStar.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaAStar.flux))*
- [ ] D*
- [ ] D* Lite
- [ ] ALT
- [ ] Contraction Hierarchies
- [ ] Hub Labeling
- [ ] Lee Algorithm
- [ ] Shortest Path Faster Algorithm
- [ ] Longest Path in DAG
- [ ] Critical Path Method

#### 8. Árvores geradoras mínimas (9 algoritmos)

- [ ] Kruskal
- [ ] Prim
- [ ] Borůvka
- [ ] Reverse-Delete
- [ ] Sollin
- [ ] Euclidean MST
- [ ] Second-Best MST
- [ ] Dynamic MST
- [ ] Minimum Bottleneck Spanning Tree

#### 9. Fluxo, corte e matching (24 algoritmos)

- [ ] Ford-Fulkerson
- [ ] Edmonds-Karp
- [ ] Dinic
- [ ] Dinic with Scaling
- [ ] Push-Relabel
- [ ] Highest-Label Push-Relabel
- [ ] MPM
- [ ] Stoer-Wagner
- [ ] Karger's Min-Cut
- [ ] Karger-Stein
- [ ] Minimum-Cost Flow
- [ ] Successive Shortest Path
- [ ] Min-Cost Max-Flow with Potentials
- [ ] Cycle-Canceling
- [ ] Flow with Demands
- [ ] Kuhn Matching
- [ ] Hungarian Algorithm
- [ ] Kuhn-Munkres
- [ ] Hopcroft-Karp
- [ ] Edmonds' Blossom
- [ ] Gale-Shapley
- [ ] Stable Marriage
- [ ] Stable Roommates
- [ ] Assignment Algorithm

#### 2. Grafos (Adições Prioritárias) (14 algoritmos)

> Também adicionaria uma subseção específica para algoritmos difíceis de grafos, com coloração, clique, caminhos disjuntos e problemas NP-difíceis.

- [x] **Chu–Liu/Edmonds Algorithm** — árvore geradora mínima direcionada — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfChuLiuEdmonds.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfChuLiuEdmonds.flux))*
- [x] **Yen’s Algorithm** — k menores caminhos — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfYenKShortestPaths.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfYenKShortestPaths.flux))*
- [ ] Suurballe’s Algorithm — caminhos disjuntos
- [ ] Karger’s Algorithm já aparece, mas poderia ser acompanhado de outras variantes de corte
- [x] **Bron–Kerbosch Algorithm** — cliques máximas — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfBronKerbosch.flux))*
- [ ] Welsh–Powell Algorithm — coloração de grafos
- [ ] DSATUR — coloração de grafos
- [ ] Edmonds’ Algorithm for Directed MST
- [ ] Transitive Reduction
- [ ] Graph Coloring Algorithms
- [ ] Maximum Clique Algorithms
- [ ] Minimum Feedback Vertex Set
- [ ] BFS/DFS Paralelo
- [ ] Graph Contraction

#### 8. Teoria da computação e complexidade (Adições Prioritárias) (13 algoritmos)

> A lista menciona algoritmos, mas quase não apresenta a base teórica necessária para avaliá-los. Eu incluiria:

> Eu criaria uma seção própria chamada Complexidade, reduções e algoritmos de aproximação.

- [ ] Redução de Karp
- [ ] Redução de Cook
- [ ] Teorema de Cook-Levin
- [ ] Algoritmo de Hopcroft–Karp já aparece, mas pode ser associado à complexidade
- [ ] Algoritmos de aproximação para Set Cover
- [ ] Algoritmo de aproximação para Vertex Cover
- [x] **Christofides’ Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfChristofidesTSP.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfChristofidesTSP.flux))*
- [ ] PTAS para Knapsack
- [ ] FPTAS para Knapsack
- [ ] Branch and Cut já aparece
- [x] **Bron–Kerbosch** — *(Implementado em [`examples/algorithms/03_graphs/ExampleOfBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/ExampleOfBronKerbosch.flux))*
- [ ] Algoritmos parametrizados
- [ ] Kernelization

### Domínio IV: Strings, Texto & Teoria da Informação (105 algoritmos)

#### 10. Strings (31 algoritmos)

- [ ] Naive String Matching
- [ ] Knuth-Morris-Pratt
- [ ] Prefix Function
- [ ] Rabin-Karp
- [ ] Z Algorithm
- [ ] Boyer-Moore
- [ ] Boyer-Moore-Horspool
- [ ] Sunday Algorithm
- [ ] Zhu-Takaoka
- [ ] Wu-Manber
- [ ] Bitap
- [ ] Aho-Corasick
- [ ] Ukkonen
- [ ] Suffix Array
- [ ] Kasai Algorithm
- [ ] DC3 / Kärkkäinen-Sanders
- [ ] Suffix Tree
- [ ] Suffix Automaton
- [ ] Palindromic Tree / Eertree
- [ ] Manacher
- [ ] Lyndon Factorization
- [ ] Duval Algorithm
- [ ] Booth's Algorithm
- [ ] Minimal Rotation
- [ ] Rolling Hash
- [ ] Double Hashing
- [ ] String Hashing
- [x] **Burrows-Wheeler Transform** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux))*
- [ ] FM-Index
- [ ] Trigram Search
- [ ] Wildcard Matching

#### 11. Distância e similaridade de strings (14 algoritmos)

- [ ] Hamming Distance
- [ ] Levenshtein Distance
- [ ] Damerau-Levenshtein Distance
- [ ] Jaro Distance
- [ ] Jaro-Winkler
- [ ] Jaccard Similarity
- [ ] Dice Coefficient
- [ ] Longest Common Subsequence
- [ ] Longest Common Substring
- [ ] Shortest Common Supersequence
- [ ] Hirschberg Algorithm
- [ ] Needleman-Wunsch
- [ ] Smith-Waterman
- [ ] Dynamic Time Warping

#### 31. Compressão (30 algoritmos)

- [ ] Huffman Coding
- [ ] Adaptive Huffman
- [ ] Shannon-Fano
- [ ] Arithmetic Coding
- [ ] Range Coding
- [ ] Golomb Coding
- [ ] Rice Coding
- [ ] Elias Gamma
- [ ] Elias Delta
- [ ] Elias Omega
- [ ] Fibonacci Coding
- [ ] Run-Length Encoding
- [ ] LZ77
- [ ] LZ78
- [ ] LZW
- [ ] LZSS
- [x] **LZMA** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressLzmaContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressLzmaContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressXzContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressXzContract.flux))*
- [ ] LZO
- [ ] LZ4
- [x] **DEFLATE** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressDeflateContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressDeflateContract.flux), [`flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux))*
- [ ] PPM
- [x] **Burrows-Wheeler Transform** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux))*
- [ ] Move-to-Front
- [ ] Delta Encoding
- [ ] Byte Pair Encoding
- [ ] Vector Quantization
- [ ] SPIHT
- [ ] Embedded Zerotree Wavelet
- [ ] Fractal Compression
- [ ] Wavelet Compression

#### 32. Teoria da informação e códigos (17 algoritmos)

- [ ] Hamming Code
- [ ] Reed-Solomon
- [ ] BCH
- [ ] Berlekamp-Massey
- [ ] Peterson-Gorenstein-Zierler
- [ ] BCJR
- [ ] Viterbi Decoder
- [ ] Turbo Codes
- [ ] LDPC
- [x] **CRC** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux))*
- [x] **Adler-32** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux))*
- [x] **Fletcher Checksum** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux))*
- [x] **Luhn Algorithm** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux))*
- [ ] Verhoeff
- [ ] Damm Algorithm
- [ ] Gray Code
- [ ] Parity Check

#### 6. Compressão e processamento de dados (Adições Prioritárias) (13 algoritmos)

- [ ] Brotli
- [x] **Zstandard — Zstd** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressZstdContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressZstdContract.flux))*
- [ ] LZ4 já aparece
- [ ] Snappy
- [ ] LZMA já aparece
- [ ] Huffman Canonical Coding
- [ ] ANS — Asymmetric Numeral Systems
- [ ] tANS
- [ ] rANS
- [ ] Burrows-Wheeler + Move-to-Front já aparecem separadamente
- [ ] Delta-of-Delta Encoding
- [ ] Frame of Reference Encoding
- [ ] Roaring Bitmaps

### Domínio V: Matemática Computacional, Teoria dos Números & Álgebra (143 algoritmos)

#### 12. Programação dinâmica (29 algoritmos)

- [ ] 0/1 Knapsack
- [ ] Unbounded Knapsack
- [ ] Bounded Knapsack
- [ ] Longest Increasing Subsequence
- [ ] Longest Decreasing Subsequence
- [ ] Longest Common Subsequence
- [ ] Matrix Chain Multiplication
- [ ] Edit Distance
- [ ] Digit DP
- [ ] Bitmask DP
- [ ] Tree DP
- [ ] Profile DP
- [ ] Broken Profile DP
- [ ] Rerooting DP
- [ ] SOS DP
- [ ] Subset Convolution
- [ ] Divide-and-Conquer DP
- [ ] Knuth Optimization
- [ ] Convex Hull Trick
- [ ] Li Chao Tree
- [ ] Monotonic Queue Optimization
- [ ] Aliens Trick
- [ ] Lagrangian Relaxation
- [ ] Kitamasa Algorithm
- [ ] Linear Recurrence
- [ ] Bostan-Mori
- [ ] Viterbi
- [ ] Forward-Backward
- [ ] Baum-Welch

#### 13. Combinatória (21 algoritmos)

- [ ] Inclusion-Exclusion
- [ ] Burnside's Lemma
- [ ] Pólya Enumeration
- [ ] Stars and Bars
- [ ] Catalan Numbers
- [ ] Bell Numbers
- [ ] Stirling Numbers
- [ ] Pascal Triangle
- [x] **Binomial Coefficient** — *(Já implementado em [`flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux))*
- [ ] Heap's Permutation Algorithm
- [ ] Steinhaus-Johnson-Trotter
- [x] **Fisher-Yates** — *(Já implementado em [`flux/ExampleOfUseRandomStdLib_RandomSequenceContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseRandomStdLib_RandomSequenceContract.flux))*
- [ ] Josephus Problem
- [ ] Prüfer Code
- [ ] Generating Functions
- [ ] Partition Algorithms
- [ ] Subset Enumeration
- [ ] Submask Enumeration
- [ ] Gray Code
- [ ] Balanced Parentheses Generation
- [ ] Meet-in-the-Middle

#### 14. Teoria dos números (52 algoritmos)

- [x] **Euclidean Algorithm** — *(Já implementado em [`flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux))*
- [ ] Extended Euclidean Algorithm
- [ ] Binary GCD
- [ ] Binary Exponentiation
- [ ] Exponentiation by Squaring
- [ ] Addition Chain
- [ ] Sieve of Eratosthenes
- [ ] Linear Sieve
- [ ] Segmented Sieve
- [ ] Sieve of Atkin
- [ ] Sieve of Sundaram
- [ ] Wheel Factorization
- [ ] Trial Division
- [ ] Fermat Primality Test
- [ ] Solovay-Strassen
- [ ] Miller-Rabin
- [ ] Baillie-PSW
- [ ] Lucas Primality Test
- [ ] Pocklington
- [ ] AKS
- [ ] Lucas-Lehmer
- [ ] Pollard Rho
- [ ] Pollard p−1
- [ ] Fermat Factorization
- [ ] Dixon Factorization
- [ ] Quadratic Sieve
- [ ] General Number Field Sieve
- [ ] Special Number Field Sieve
- [ ] Lenstra ECM
- [ ] Discrete Logarithm
- [ ] Baby-Step Giant-Step
- [ ] Pollard Rho for Discrete Log
- [ ] Pollard Kangaroo
- [ ] Pohlig-Hellman
- [ ] Index Calculus
- [ ] Primitive Root
- [ ] Modular Inverse
- [ ] Chinese Remainder Theorem
- [ ] Garner Algorithm
- [ ] Tonelli-Shanks
- [ ] Cipolla Algorithm
- [ ] Modular Square Root
- [ ] Legendre Formula
- [ ] Lucas Theorem
- [ ] Wilson Theorem
- [ ] Euler Totient Sieve
- [ ] Möbius Sieve
- [ ] Fast Doubling
- [ ] Pell Equation
- [ ] Continued Fractions
- [ ] Stern-Brocot
- [ ] Farey Sequence

#### 15. Álgebra computacional e polinômios (41 algoritmos)

- [ ] Gaussian Elimination
- [ ] Gauss-Jordan
- [ ] Gaussian Elimination over GF(2)
- [ ] Gauss-Seidel
- [ ] Jacobi Method
- [x] **Cholesky** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux))*
- [ ] Gram-Schmidt
- [x] **QR Decomposition** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixQRContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixQRContract.flux))*
- [x] **LU Decomposition** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixDecompositionContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixDecompositionContract.flux))*
- [x] **Singular Value Decomposition** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixSVDContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixSVDContract.flux))*
- [ ] Conjugate Gradient
- [ ] BiCG
- [ ] GMRES
- [ ] Arnoldi
- [ ] Lanczos
- [x] **Power Iteration** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux))*
- [ ] Inverse Iteration
- [ ] Rayleigh Quotient Iteration
- [ ] Strassen Matrix Multiplication
- [ ] Coppersmith-Winograd
- [ ] Cannon's Algorithm
- [ ] Karatsuba Multiplication
- [ ] Toom-Cook
- [ ] Schönhage-Strassen
- [ ] Fürer's Algorithm
- [ ] Polynomial GCD
- [ ] Polynomial Interpolation
- [ ] Lagrange Interpolation
- [ ] Newton Interpolation
- [ ] Berlekamp Algorithm
- [ ] Berlekamp-Massey
- [ ] Cantor-Zassenhaus
- [x] **Fast Polynomial Multiplication** — *(Já implementado em [`flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux))*
- [ ] Multipoint Evaluation
- [ ] Formal Power Series
- [ ] NTT
- [x] **FFT** — *(Já implementado em [`flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux))*
- [ ] FWHT
- [ ] Bluestein FFT
- [ ] Rader FFT
- [ ] Cooley-Tukey FFT

### Domínio VI: Métodos Numéricos, Geometria & Física Computacional (144 algoritmos)

#### 16. Geometria computacional (41 algoritmos)

- [ ] Graham Scan
- [ ] Andrew Monotone Chain
- [ ] Jarvis March
- [ ] Quickhull
- [ ] Chan's Algorithm
- [ ] Kirkpatrick-Seidel
- [ ] Divide-and-Conquer Convex Hull
- [ ] Closest Pair of Points
- [ ] Line Segment Intersection
- [ ] Bentley-Ottmann
- [ ] Shamos-Hoey
- [ ] Sweep Line
- [ ] Rotating Calipers
- [ ] Point in Polygon
- [ ] Ray Casting
- [ ] Winding Number
- [ ] Point Location
- [ ] Half-Plane Intersection
- [ ] Polygon Triangulation
- [ ] Sutherland-Hodgman
- [ ] Weiler-Atherton
- [ ] Vatti Clipping
- [ ] Cohen-Sutherland
- [ ] Liang-Barsky
- [ ] Cyrus-Beck
- [ ] Nicholl-Lee-Nicholl
- [ ] Minkowski Sum
- [ ] Shoelace Formula
- [ ] Minimum Enclosing Circle
- [ ] Minimum Bounding Rectangle
- [ ] Delaunay Triangulation
- [ ] Voronoi Diagram
- [ ] Bowyer-Watson
- [ ] Fortune's Algorithm
- [ ] Chew's Algorithm
- [ ] Ruppert's Algorithm
- [ ] Marching Cubes
- [ ] Marching Triangles
- [ ] Ramer-Douglas-Peucker
- [ ] Gilbert-Johnson-Keerthi
- [ ] Iterative Closest Point

#### 17. Métodos numéricos (35 algoritmos)

- [ ] Bisection
- [ ] False Position
- [ ] Illinois Method
- [ ] Newton-Raphson
- [ ] Secant Method
- [ ] Ridder Method
- [ ] Muller's Method
- [ ] Halley's Method
- [ ] ITP Method
- [ ] Golden-Section Search
- [ ] Trapezoidal Rule
- [ ] Simpson's Rule
- [ ] Romberg Integration
- [ ] Gaussian Quadrature
- [ ] Monte Carlo Integration
- [ ] Euler Method
- [ ] Backward Euler
- [ ] Runge-Kutta
- [ ] Verlet Integration
- [ ] Velocity Verlet
- [ ] Leapfrog Integration
- [ ] Crank-Nicolson
- [ ] Finite Difference Method
- [ ] Finite Element Method
- [ ] Finite Volume Method
- [ ] Lax-Friedrichs
- [ ] Lax-Wendroff
- [ ] Upwind Method
- [ ] Runge-Kutta-Fehlberg
- [ ] Multigrid
- [ ] Fast Marching Method
- [ ] Level Set Method
- [ ] Kahan Summation
- [ ] Pairwise Summation
- [ ] Binary Splitting

#### 39. Computação gráfica (21 algoritmos)

- [ ] Bresenham Line Algorithm
- [ ] Digital Differential Analyzer
- [ ] Xiaolin Wu
- [ ] Midpoint Circle Algorithm
- [ ] Scanline Rendering
- [ ] Painter's Algorithm
- [ ] Z-Buffer
- [ ] Binary Space Partitioning
- [ ] Warnock Algorithm
- [ ] Newell's Algorithm
- [ ] Gouraud Shading
- [ ] Phong Shading
- [ ] Blinn-Phong
- [ ] Ray Casting
- [ ] Ray Tracing
- [ ] Path Tracing
- [ ] Bidirectional Path Tracing
- [ ] Photon Mapping
- [ ] Metropolis Light Transport
- [ ] SLERP
- [ ] Summed Area Table

#### 40. Física computacional (47 algoritmos)

> Aqui eu faria uma seção particularmente forte, considerando seu interesse em Física:

- [ ] N-Body Simulation
- [ ] Barnes-Hut
- [ ] Fast Multipole Method
- [ ] Verlet Integration
- [ ] Velocity Verlet
- [ ] Leapfrog Integration
- [ ] Runge-Kutta
- [ ] Symplectic Integrator
- [ ] Molecular Dynamics
- [ ] Monte Carlo Simulation
- [ ] Metropolis Algorithm
- [ ] Glauber Dynamics
- [ ] Ising Model Monte Carlo
- [ ] Wang-Landau Algorithm
- [ ] Kinetic Monte Carlo
- [ ] Gillespie Algorithm
- [ ] Gillespie Direct Method
- [ ] Gillespie First-Reaction Method
- [ ] Finite Difference Method
- [ ] Finite Element Method
- [ ] Finite Volume Method
- [ ] Spectral Method
- [ ] Pseudospectral Method
- [ ] Fast Fourier Transform
- [ ] Multigrid
- [ ] Conjugate Gradient
- [ ] Thomas Algorithm
- [ ] Crank-Nicolson
- [ ] Lax-Wendroff
- [ ] Lax-Friedrichs
- [ ] Upwind Scheme
- [ ] Leapfrog Scheme
- [ ] ADI Method
- [ ] Poisson Solver
- [ ] Jacobi Poisson Solver
- [ ] Gauss-Seidel Poisson Solver
- [ ] Successive Over-Relaxation
- [ ] Fast Poisson Solver
- [ ] Particle-in-Cell
- [ ] Smoothed Particle Hydrodynamics
- [ ] Lattice Boltzmann Method
- [ ] Finite Element PDE Solver
- [ ] Level Set Method
- [ ] Fast Marching Method
- [ ] Rainflow Counting
- [ ] Constraint Dynamics
- [ ] Featherstone Algorithm

### Domínio VII: Otimização & Estatística Científica (84 algoritmos)

#### 18. Otimização (45 algoritmos)

- [ ] Gradient Descent
- [ ] Stochastic Gradient Descent
- [ ] Mini-Batch Gradient Descent
- [ ] Momentum
- [ ] Nesterov Momentum
- [ ] AdaGrad
- [ ] RMSProp
- [ ] Adam
- [ ] AdamW
- [ ] Nadam
- [ ] BFGS
- [ ] L-BFGS
- [ ] Gauss-Newton
- [ ] Levenberg-Marquardt
- [ ] Newton Optimization
- [ ] Coordinate Descent
- [ ] Conjugate Gradient
- [ ] Nelder-Mead
- [ ] Powell Method
- [ ] Simplex Algorithm
- [ ] Karmarkar Algorithm
- [ ] Interior Point
- [ ] Frank-Wolfe
- [ ] Line Search
- [ ] Differential Evolution
- [ ] Genetic Algorithm
- [ ] Genetic Programming
- [ ] Evolution Strategy
- [ ] CMA-ES
- [ ] Particle Swarm Optimization
- [ ] Ant Colony Optimization
- [ ] Artificial Bee Colony
- [ ] Firefly Algorithm
- [ ] Cuckoo Search
- [ ] Simulated Annealing
- [ ] Tabu Search
- [ ] Hill Climbing
- [ ] Random-Restart Hill Climbing
- [ ] Harmony Search
- [ ] Bayesian Optimization
- [ ] Cross-Entropy Method
- [ ] GRASP
- [ ] Branch and Cut
- [ ] Cutting Plane
- [ ] Lagrangian Relaxation

#### 19. Probabilidade e amostragem (16 algoritmos)

- [ ] Monte Carlo
- [ ] Markov Chain Monte Carlo
- [ ] Metropolis-Hastings
- [ ] Gibbs Sampling
- [ ] Hamiltonian Monte Carlo
- [ ] Rejection Sampling
- [ ] Importance Sampling
- [ ] Stratified Sampling
- [ ] Reservoir Sampling
- [ ] Alias Method
- [ ] Ziggurat Algorithm
- [ ] Box-Muller Transform
- [ ] Marsaglia Polar Method
- [ ] Inverse Transform Sampling
- [ ] Acceptance-Rejection Sampling
- [ ] VEGAS

#### 20. Estatística e inferência (23 algoritmos)

- [ ] Expectation-Maximization
- [ ] Expectation Propagation
- [ ] Kalman Filter
- [ ] Extended Kalman Filter
- [ ] Unscented Kalman Filter
- [ ] Particle Filter
- [ ] Hidden Markov Model
- [ ] Baum-Welch
- [ ] Viterbi
- [ ] Forward-Backward
- [ ] RANSAC
- [ ] Kolmogorov-Smirnov
- [ ] Kruskal-Wallis
- [ ] Fisher Exact Test
- [ ] Fisher Linear Discriminant
- [ ] Partial Least Squares
- [ ] PCA
- [ ] ICA
- [ ] Regression Algorithms
- [ ] Bootstrap
- [ ] Jackknife
- [ ] Cross-Validation
- [ ] Bayesian Inference

### Domínio VIII: Inteligência Artificial, ML & Deep Learning (261 algoritmos)

#### 21. Machine Learning (38 algoritmos)

- [ ] Linear Regression
- [ ] Logistic Regression
- [ ] Ridge Regression
- [ ] Lasso
- [ ] Elastic Net
- [ ] Polynomial Regression
- [ ] Perceptron
- [ ] K-Nearest Neighbors
- [ ] Naive Bayes
- [ ] Decision Tree
- [ ] ID3
- [ ] C4.5
- [ ] CART
- [ ] Random Forest
- [ ] Extra Trees
- [ ] Support Vector Machine
- [ ] One-Class SVM
- [ ] Kernel Methods
- [ ] Gaussian Process
- [ ] K-Means
- [ ] K-Means++
- [ ] K-Medoids
- [ ] Mean Shift
- [ ] DBSCAN
- [ ] OPTICS
- [ ] Spectral Clustering
- [ ] Fuzzy C-Means
- [ ] Hierarchical Clustering
- [ ] Single-Linkage
- [ ] Complete-Linkage
- [ ] Average-Linkage
- [ ] Ward's Method
- [ ] Gaussian Mixture Model
- [ ] Isolation Forest
- [ ] Local Outlier Factor
- [ ] Elliptic Envelope
- [ ] RANSAC
- [ ] Locality-Sensitive Hashing

#### 22. Ensemble Learning (21 algoritmos)

- [ ] Bagging
- [ ] Boosting
- [ ] AdaBoost
- [ ] BrownBoost
- [ ] LogitBoost
- [ ] LPBoost
- [ ] Gradient Boosting
- [ ] XGBoost
- [ ] LightGBM
- [ ] CatBoost
- [ ] Random Subspace
- [ ] Rotation Forest
- [ ] Stacking
- [ ] Blending
- [ ] Voting Classifier
- [ ] MultiBoosting
- [ ] RUSBoost
- [ ] SMOTEBoost
- [ ] Balanced Random Forest
- [ ] Easy Ensemble
- [ ] Feature Space Ensemble

#### 23. Redes neurais (20 algoritmos)

- [ ] Perceptron
- [ ] Backpropagation
- [ ] Multilayer Perceptron
- [ ] Hopfield Network
- [ ] Boltzmann Machine
- [ ] Restricted Boltzmann Machine
- [ ] Deep Belief Network
- [ ] Radial Basis Function Network
- [ ] Self-Organizing Map
- [ ] Kohonen Network
- [ ] Recurrent Neural Network
- [ ] LSTM
- [ ] GRU
- [ ] Bidirectional RNN
- [ ] Convolutional Neural Network
- [ ] Autoencoder
- [ ] Variational Autoencoder
- [ ] Denoising Autoencoder
- [ ] Sparse Autoencoder
- [ ] Contractive Autoencoder

#### 24. Deep Learning e visão computacional (49 algoritmos)

- [ ] LeNet
- [ ] AlexNet
- [ ] VGG
- [ ] GoogLeNet
- [ ] Inception
- [ ] ResNet
- [ ] DenseNet
- [ ] EfficientNet
- [ ] MobileNet
- [ ] U-Net
- [ ] FCN
- [ ] SegNet
- [ ] Mask R-CNN
- [ ] R-CNN
- [ ] Fast R-CNN
- [ ] Faster R-CNN
- [ ] YOLO
- [ ] SSD
- [ ] RetinaNet
- [ ] DETR
- [ ] Vision Transformer
- [ ] Swin Transformer
- [ ] Capsule Network
- [ ] Canny
- [ ] Sobel
- [ ] Prewitt
- [ ] Scharr
- [ ] Laplacian Edge Detection
- [ ] Hough Transform
- [ ] Generalized Hough
- [ ] SIFT
- [ ] SURF
- [ ] HOG
- [ ] Optical Flow
- [ ] Lucas-Kanade
- [ ] Farneback Optical Flow
- [ ] GrabCut
- [ ] Watershed
- [ ] Region Growing
- [ ] Connected Component Labeling
- [ ] Flood Fill
- [ ] Histogram Equalization
- [ ] Adaptive Histogram Equalization
- [ ] Median Filter
- [ ] Gaussian Filter
- [ ] Richardson-Lucy Deconvolution
- [ ] Blind Deconvolution
- [ ] Seam Carving
- [ ] Floyd-Steinberg Dithering

#### 25. NLP (23 algoritmos)

- [ ] Bag of Words
- [ ] TF-IDF
- [ ] Word2Vec
- [ ] GloVe
- [ ] ELMo
- [ ] BERT
- [ ] RoBERTa
- [ ] GPT
- [ ] T5
- [ ] XLNet
- [ ] Seq2Seq
- [ ] Attention Mechanism
- [ ] Transformer
- [ ] Masked Language Modeling
- [ ] Conditional Random Fields
- [ ] Hidden Markov Model
- [ ] Latent Dirichlet Allocation
- [ ] Lesk Algorithm
- [ ] Stemming
- [ ] Porter Stemmer
- [ ] Snowball Stemmer
- [ ] Lovins Stemmer
- [ ] Sukhotin Algorithm

#### 26. IA generativa (24 algoritmos)

- [ ] Variational Autoencoder
- [ ] GAN
- [ ] DCGAN
- [ ] WGAN
- [ ] WGAN-GP
- [ ] StyleGAN
- [ ] Pix2Pix
- [ ] CycleGAN
- [ ] Diffusion Models
- [ ] DDPM
- [ ] DDIM
- [ ] Score-Based Diffusion
- [ ] Normalizing Flows
- [ ] Autoregressive Models
- [ ] Transformer
- [ ] Mixture of Experts
- [ ] Beam Search
- [ ] Top-k Sampling
- [ ] Nucleus Sampling
- [ ] Temperature Sampling
- [ ] Contrastive Learning
- [ ] SimCLR
- [ ] CLIP
- [ ] Masked Autoencoder

#### 27. Reinforcement Learning (25 algoritmos)

- [ ] Dynamic Programming for MDP
- [ ] Value Iteration
- [ ] Policy Iteration
- [ ] Monte Carlo RL
- [ ] Temporal Difference Learning
- [ ] TD(λ)
- [ ] Q-Learning
- [ ] SARSA
- [ ] Expected SARSA
- [ ] Double Q-Learning
- [ ] DQN
- [ ] Double DQN
- [ ] Dueling DQN
- [ ] Rainbow DQN
- [ ] Policy Gradient
- [ ] REINFORCE
- [ ] Actor-Critic
- [ ] A2C
- [ ] A3C
- [ ] PPO
- [ ] TRPO
- [ ] SAC
- [ ] DDPG
- [ ] TD3
- [ ] Monte Carlo Tree Search

#### 28. Algoritmos de grafos para IA (16 algoritmos)

- [ ] PageRank
- [ ] HITS
- [ ] TrustRank
- [ ] Girvan-Newman
- [ ] Label Propagation
- [ ] Louvain
- [ ] Leiden
- [ ] Random Walk
- [ ] DeepWalk
- [ ] Node2Vec
- [ ] Graph Embedding
- [ ] GraphSAGE
- [ ] Graph Convolutional Network
- [ ] Graph Attention Network
- [ ] Graph Isomorphism Network
- [ ] Heterogeneous Graph Neural Network

#### 29. Sistemas de recomendação (14 algoritmos)

- [ ] Collaborative Filtering
- [ ] Content-Based Filtering
- [ ] Matrix Factorization
- [ ] SVD Recommendation
- [ ] ALS
- [ ] Apriori Recommendation
- [ ] Eclat
- [ ] Neural Collaborative Filtering
- [ ] Hybrid Recommendation
- [ ] Context-Aware Recommendation
- [ ] DeepFM
- [ ] Wide & Deep
- [ ] Knowledge Graph Recommendation
- [ ] Reinforcement Learning Recommendation

#### 9. Inteligência artificial (Adições Prioritárias) (31 algoritmos)

> Especialmente HNSW, Product Quantization e RAG são importantes para sistemas modernos de busca semântica e IA generativa.

- [ ] Beam Search with Diverse Decoding
- [ ] Speculative Decoding
- [ ] Contrastive Search
- [ ] Best-of-N Sampling
- [ ] Monte Carlo Dropout
- [ ] Retrieval-Augmented Generation — RAG
- [ ] Maximal Marginal Relevance — MMR
- [x] **HNSW** — Hierarchical Navigable Small World — *(Implementado em [`examples/algorithms/08_artificial_intel/ExampleOfHNSWVectorSearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/ExampleOfHNSWVectorSearch.flux))*
- [ ] Product Quantization
- [ ] IVF-Flat
- [ ] IVF-PQ
- [ ] LoRA
- [ ] QLoRA
- [ ] Knowledge Distillation
- [ ] Neural Architecture Search

### Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura (185 algoritmos)

#### 30. Criptografia (37 algoritmos)

- [ ] RSA
- [ ] ElGamal
- [ ] Diffie-Hellman
- [ ] Elliptic Curve Cryptography
- [ ] ECDH
- [ ] DSA
- [ ] ECDSA
- [ ] EdDSA
- [ ] AES
- [ ] DES
- [ ] 3DES
- [ ] Blowfish
- [ ] Twofish
- [ ] ChaCha20
- [ ] Salsa20
- [ ] RC4
- [ ] IDEA
- [ ] Threefish
- [ ] TEA
- [x] **MD5** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **SHA-1** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **SHA-2** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **SHA-3** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **BLAKE** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **RIPEMD** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [ ] Whirlpool
- [x] **HMAC** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashSecurityContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashSecurityContract.flux))*
- [ ] Poly1305
- [ ] SipHash
- [ ] Argon2
- [ ] bcrypt
- [x] **PBKDF2** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashSecurityContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashSecurityContract.flux))*
- [ ] scrypt
- [ ] Shamir Secret Sharing
- [ ] Blum Blum Shub
- [ ] Yarrow
- [ ] Fortuna

#### 33. Compiladores e parsing (18 algoritmos)

- [ ] Recursive Descent
- [ ] Pratt Parser
- [ ] Packrat Parser
- [ ] CYK
- [ ] Earley Parser
- [ ] GLR
- [ ] LL Parser
- [ ] LR Parser
- [ ] SLR
- [ ] LALR
- [ ] Canonical LR
- [ ] Operator-Precedence Parsing
- [ ] Shunting-Yard
- [ ] Sethi-Ullman
- [ ] Hindley-Milner Type Inference
- [ ] Chaitin Register Allocation
- [ ] C3 Linearization
- [ ] Rete Algorithm

#### 34. Autômatos e linguagens formais (11 algoritmos)

- [ ] Powerset Construction
- [ ] DFA Minimization
- [ ] Hopcroft DFA Minimization
- [ ] Moore DFA Minimization
- [ ] Brzozowski Algorithm
- [ ] Thompson Construction
- [ ] Glushkov Construction
- [ ] McNaughton-Yamada
- [ ] CYK
- [ ] Earley
- [ ] Turing Machine Simulation Algorithms

#### 35. Sistemas distribuídos (19 algoritmos)

- [ ] Paxos
- [ ] Multi-Paxos
- [ ] Raft
- [ ] Viewstamped Replication
- [ ] Chandra-Toueg Consensus
- [ ] Bully Algorithm
- [ ] Ring Election
- [ ] Ricart-Agrawala
- [ ] Maekawa
- [ ] Raymond
- [ ] Lamport Distributed Mutual Exclusion
- [ ] Lamport Logical Clock
- [ ] Vector Clock
- [ ] Cristian's Algorithm
- [ ] Berkeley Clock Synchronization
- [ ] Marzullo's Algorithm
- [ ] Chandy-Lamport Snapshot
- [ ] Dijkstra-Scholten
- [ ] Huang Termination Detection

#### 36. Sistemas operacionais (30 algoritmos)

- [ ] FCFS Scheduling
- [ ] Shortest Job First
- [ ] Shortest Remaining Time
- [ ] Round Robin
- [ ] Priority Scheduling
- [ ] Multilevel Queue
- [ ] Multilevel Feedback Queue
- [ ] Earliest Deadline First
- [ ] Rate Monotonic
- [ ] Least Slack Time
- [ ] List Scheduling
- [ ] Banker's Algorithm
- [ ] Peterson's Algorithm
- [ ] Dekker's Algorithm
- [ ] Lamport Bakery
- [ ] LRU Page Replacement
- [ ] FIFO Page Replacement
- [ ] Clock Page Replacement
- [ ] ARC
- [ ] Buddy Memory Allocation
- [ ] Mark-and-Sweep
- [ ] Mark-Compact
- [ ] Cheney's Algorithm
- [ ] Reference Counting
- [ ] Generational Garbage Collection
- [ ] SCAN Disk Scheduling
- [ ] C-SCAN
- [ ] LOOK
- [ ] C-LOOK
- [ ] Shortest Seek Time First

#### 37. Redes de computadores (6 algoritmos)

- [ ] Nagle's Algorithm
- [ ] Karn's Algorithm
- [ ] Exponential Backoff
- [ ] Binary Exponential Backoff
- [ ] Truncated Binary Exponential Backoff
- [ ] Luleå Algorithm

#### 38. Bancos de dados (10 algoritmos)

- [ ] Nested Loop Join
- [ ] Block Nested Loop Join
- [ ] Hash Join
- [ ] Sort-Merge Join
- [ ] Grace Hash Join
- [ ] ARIES
- [ ] Chase Algorithm
- [ ] Two-Phase Locking
- [ ] Timestamp Ordering
- [ ] MVCC Algorithms

#### 4. Sistemas distribuídos e redes (Adições Prioritárias) (16 algoritmos)

> Paxos e Raft estão presentes, mas faltam algoritmos muito relevantes para sistemas distribuídos modernos, especialmente PBFT, consistent hashing, gossip e MapReduce.

- [x] **Consistent Hashing** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfConsistentHashingRing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfConsistentHashingRing.flux) e [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [ ] Rendezvous Hashing
- [x] **Gossip Protocol** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfGossipProtocol.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfGossipProtocol.flux))*
- [ ] SWIM Membership Protocol
- [ ] Chord Distributed Hash Table
- [ ] Kademlia
- [ ] Two-Phase Commit
- [ ] Three-Phase Commit
- [ ] Byzantine Fault Tolerant Consensus
- [x] **PBFT** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfPBFTConsensus.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfPBFTConsensus.flux))*
- [ ] HotStuff
- [x] **MapReduce** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfMapReducePipeline.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfMapReducePipeline.flux))*
- [ ] Work Stealing
- [ ] Token Bucket
- [ ] Leaky Bucket
- [ ] AIMD — Additive Increase, Multiplicative Decrease

#### 5. Criptografia aplicada (Adições Prioritárias) (24 algoritmos)

> A lista inclui vários algoritmos criptográficos, mas eu acrescentaria:

- [ ] AES-GCM
- [ ] ChaCha20-Poly1305
- [ ] X25519
- [ ] Ed25519
- [ ] HKDF
- [ ] PBKDF2, scrypt e Argon2 já aparecem
- [x] **BLAKE2** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **BLAKE3** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashCryptoContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashCryptoContract.flux))*
- [x] **Merkle Tree** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfMerkleTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfMerkleTree.flux))*
- [ ] Merkle–Damgård Construction
- [ ] Fiat–Shamir Identification
- [ ] Oblivious Transfer
- [ ] Verifiable Random Function
- [ ] Shamir Secret Sharing já aparece
- [ ] TLS Handshake
- [ ] Signal Double Ratchet
- [ ] A seção atual mistura primitivas, algoritmos e protocolos. Eu separaria em:
- [ ] criptografia simétrica
- [ ] criptografia assimétrica
- [ ] hashes
- [ ] MACs e KDFs
- [ ] assinaturas
- [ ] protocolos
- [ ] estruturas autenticadas

#### 7. Computação paralela e distribuída (Adições Prioritárias) (14 algoritmos)

> Esta é uma das lacunas mais importantes. Eu adicionaria:

- [ ] Parallel Prefix Sum / Scan
- [ ] Parallel Reduction
- [ ] Bitonic Sort Parallel já aparece, mas poderia ser classificado aqui
- [ ] Parallel Merge Sort
- [ ] Parallel Quicksort
- [ ] Parallel BFS
- [ ] Parallel DFS
- [x] **MapReduce** — *(Implementado em [`examples/algorithms/09_systems_infra/ExampleOfMapReducePipeline.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/ExampleOfMapReducePipeline.flux))*
- [ ] Fork-Join
- [ ] Work Stealing
- [ ] BSP — Bulk Synchronous Parallel
- [ ] Gustafson’s Law e Amdahl’s Law como conceitos de análise
- [ ] CUDA Tiled Matrix Multiplication
- [ ] Parallel Shortest Paths

### Domínio X: Bioinformática & Computação Quântica (41 algoritmos)

#### 41. Bioinformática (13 algoritmos)

- [ ] BLAST
- [ ] Needleman-Wunsch
- [ ] Smith-Waterman
- [ ] Hirschberg
- [ ] Viterbi
- [ ] Kabsch Algorithm
- [ ] UPGMA
- [ ] Neighbor-Joining
- [ ] Maximum Parsimony
- [ ] de Bruijn Graph Assembly
- [ ] Burrows-Wheeler Genome Alignment
- [ ] Sorting by Signed Reversals
- [ ] Velvet Assembly

#### 43. Algoritmos quânticos (28 algoritmos)

- [ ] Deutsch Algorithm
- [ ] Deutsch-Jozsa
- [ ] Bernstein-Vazirani
- [ ] Simon's Algorithm
- [ ] Grover's Algorithm
- [ ] Shor's Algorithm
- [ ] Quantum Fourier Transform
- [ ] Quantum Phase Estimation
- [ ] Quantum Counting
- [ ] Amplitude Amplification
- [ ] Amplitude Estimation
- [ ] Quantum Walk
- [ ] Quantum Walk Search
- [ ] HHL
- [ ] Hadamard Test
- [ ] Swap Test
- [ ] Quantum Teleportation
- [ ] Quantum Dense Coding
- [ ] Quantum Singular Value Transformation
- [ ] Variational Quantum Eigensolver
- [ ] QAOA
- [ ] Quantum Annealing
- [ ] Hamiltonian Simulation
- [ ] Hidden Subgroup Algorithm
- [ ] Hidden Shift Algorithm
- [ ] Quantum Phase Estimation
- [ ] Quantum Search
- [ ] Boson Sampling
