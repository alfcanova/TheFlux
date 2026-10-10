# 🔬 TODO_SciAlgo: Catálogo e Roadmap de Algoritmos Científicos em TheFlux

> **Status**: Planejamento e Roteiro de Implementação  
> **Origem**: Baseado no catálogo exaustivo de `docs/TODO_algo.txt`  
> **Suíte Alvo**: `examples/algorithms/` com execução nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)

---

## 📊 1. Resumo Executivo & Métricas do Catálogo

- **Total de Entradas Catalogadas**: 1.308 algoritmos (1.324 nos títulos temáticos)
- **Algoritmos Já Implementados**: **536** (516 na suíte [`examples/algorithms/`](file:///D:/Projetos/TheFlux/examples/algorithms) + 21 em [`flux/`](file:///D:/Projetos/TheFlux/flux))
- **Algoritmos a Implementar**: **772** algoritmos restantes
- **Taxa de Conclusão Global**: **41,0%**
- **Suíte Ativa (`examples/algorithms/`)**: **510** arquivos `.flux` com 100% de paridade nos 6 backends
- **Divisão Estrutural**: **10 Grandes Domínios Científicos** e **49 Categorias Temáticas**

### Tabela de Domínios e Volumes

| Domínio | Escopo Temático | Total de Algoritmos | Implementados | % Concluído | Status |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Domínio I: Fundamentos, Busca e Ordenação** | Subcategorias especializadas | **149** | **149** | **100,0%** | ✅ Concluído |
| **Domínio II: Estruturas de Dados Avançadas & Streaming** | Subcategorias especializadas | **63** | **63** | **100,0%** | ✅ Concluído |
| **Domínio III: Teoria dos Grafos & Redes** | Subcategorias especializadas | **119** | **119** | **100,0%** | ✅ Concluído |
| **Domínio IV: Strings, Texto & Teoria da Informação** | Subcategorias especializadas | **105** | **9** | **8,6%** | 🔄 Em andamento |
| **Domínio V: Matemática Computacional, Teoria dos Números & Álgebra** | Subcategorias especializadas | **143** | **10** | **7,0%** | 🔄 Em andamento |
| **Domínio VI: Métodos Numéricos, Geometria & Física Computacional** | Subcategorias especializadas | **144** | **0** | **0,0%** | ⏳ Planejado |
| **Domínio VII: Otimização & Estatística Científica** | Subcategorias especializadas | **84** | **0** | **0,0%** | ⏳ Planejado |
| **Domínio VIII: Inteligência Artificial, ML & Deep Learning** | Subcategorias especializadas | **245** | **1** | **0,4%** | 🔄 Em andamento |
| **Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura** | Subcategorias especializadas | **185** | **185** | **100,0%** | ✅ Concluído |
| **Domínio X: Bioinformática, Computação Quântica & Criptografia Pós-Quântica** | Subcategorias especializadas | **71** | **0** | **0,0%** | ⏳ Planejado |
| **Total Geral** | **10 Grandes Domínios** | **1.308** | **536** | **41,0%** | 🚀 **Suíte Ativa** |

---
## 📁 2. Arquitetura da Suíte e Diretórios

Os algoritmos são organizados de forma hierárquica e modular sob a pasta `examples/algorithms/`, com subpastas temáticas em ordem alfabética para facilitar a navegação e escalabilidade:

```text
TheFlux/
├── examples/
│   └── algorithms/
│       ├── 01_foundations/         # Paradigmas, Busca, Ordenação, Arrays, Especiais
│       │   ├── arrays/             # Two-Pointer, Kadane, Sliding Window, Sparse Table
│       │   ├── paradigms/          # Brute Force, Divide and Conquer, Greedy, DP, Backtracking
│       │   ├── search/             # Linear, Binária, A*, D*, Minimax, Alpha-Beta
│       │   ├── sort/               # Quick, Merge, Heap, Radix, Tim, Intro
│       │   └── special/            # Josephus, Brent, Horner, Kahan, Bloom Filter
│       ├── 02_data_structures/     # DSU, AVL, Red-Black, Segment Tree, Heaps, Streaming
│       │   ├── advanced/           # AVL, Red-Black, Segment Tree, Treap, KD-Tree, B-Tree
│       │   ├── basic/              # Heaps (Binary, D-ary, Pairing), Hash Tables, Caches
│       │   └── streaming/          # HyperLogLog, Count-Min, Misra-Gries, Space-Saving
│       ├── 03_graphs/              # Grafos, MST, Caminhos Mínimos, Teoria da Complexidade
│       │   ├── complexity/         # Cook-Levin, Karp Reduction, Hopcroft-Karp, Bron-Kerbosch
│       │   ├── core/               # Dijkstra, Chu-Liu, Yen, Coloração, Fluxos
│       │   └── mst/                # Kruskal, Prim, Boruvka, Second-Best MST
│       ├── 04_strings/             # Strings, Distâncias, Compressão, Teoria da Informação
│       ├── 05_mathematics/         # Teoria dos Números, Álgebra Linear, Decomposições
│       ├── 06_numerical_physics/   # Newton-Raphson, Runge-Kutta, N-Body, Verlet
│       ├── 07_optimization_stat/   # Adam, Simplex, Genético, MCMC, Kalman, PCA
│       ├── 08_artificial_intel/    # Regressões, Árvores, SVM, MLP Backprop, Vetores
│       │   └── machine_learning/   # HNSW Vector Search, Classificadores
│       ├── 09_systems_infra/       # Sistemas Distribuídos, Consenso, Compiladores, Cripto
│       │   └── distributed/        # Consistent Hashing, Gossip, PBFT, MapReduce, Merkle
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

- [x] **Binary Heap** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux))*
- [x] **Hash Table** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasHashTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasHashTable.flux))*
- [x] **Persistent Segment Tree** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux))*
- [x] **Wavelet Tree** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux))*
- [x] **Chu–Liu/Edmonds** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralChuLiuEdmonds.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralChuLiuEdmonds.flux))*
- [x] **Yen’s Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralYenKShortestPaths.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralYenKShortestPaths.flux))*
- [x] **Bron–Kerbosch** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeBronKerbosch.flux))*
- [x] **Christofides’ Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeChristofidesTSP.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeChristofidesTSP.flux))*
- [x] **Misra–Gries** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingMisraGries.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingMisraGries.flux))*
- [x] **Consistent Hashing** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfConsistentHashingRing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfConsistentHashingRing.flux) e [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [x] **Gossip Protocol** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfGossipProtocol.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfGossipProtocol.flux))*
- [x] **PBFT** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfPBFTConsensus.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfPBFTConsensus.flux))*
- [x] **MapReduce** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfMapReducePipeline.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfMapReducePipeline.flux))*
- [x] **Merkle Tree** — *(Implementado em [`examples/algorithms/09_systems_infra/distributed/ExampleOfMerkleTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/09_systems_infra/distributed/ExampleOfMerkleTree.flux))*
- [x] **HNSW** — *(Implementado em [`examples/algorithms/08_artificial_intel/machine_learning/ExampleOfHNSWVectorSearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/machine_learning/ExampleOfHNSWVectorSearch.flux))*
---

## 📚 6. Catálogo Completo dos 1.308 Algoritmos por Domínio

### Domínio I: Fundamentos, Busca e Ordenação (149 algoritmos)

#### Algoritmos especiais (19 algoritmos)

- [x] **Josephus** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisJosephus.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisJosephus.flux))*
- [x] **Tortoise and Hare** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisTortoiseAndHare.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisTortoiseAndHare.flux))*
- [x] **Brent's Cycle Detection** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBrent.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBrent.flux))*
- [x] **Ackermann Function** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisAckermann.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisAckermann.flux))*
- [x] **Doomsday Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisDoomsday.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisDoomsday.flux))*
- [x] **Zeller's Congruence** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisZeller.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisZeller.flux))*
- [x] **Easter Algorithms** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisEaster.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisEaster.flux))*
- [x] **Zobrist Hashing** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisZobrist.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisZobrist.flux))*
- [x] **Cuckoo Hashing** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisCuckoo.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisCuckoo.flux))*
- [x] **Bloom Filter** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBloomFilter.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBloomFilter.flux))*
- [x] **Skip List Algorithms** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisSkipList.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisSkipList.flux))*
- [x] **Reservoir Sampling** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisReservoirSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisReservoirSampling.flux))*
- [x] **Alias Method** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisAliasMethod.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisAliasMethod.flux))*
- [x] **Shunting-Yard** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisShuntingYard.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisShuntingYard.flux))*
- [x] **Ramer-Douglas-Peucker** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisRamerDouglasPeucker.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisRamerDouglasPeucker.flux))*
- [x] **Kahan Summation** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisKahanSummation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisKahanSummation.flux))*
- [x] **Horner's Method** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisHorner.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisHorner.flux))*
- [x] **Booth's Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBooth.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBooth.flux))*
- [x] **Fast Doubling** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisFastDoubling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisFastDoubling.flux))*

#### Arrays e sequências (30 algoritmos)

- [x] **Two-Pointer Technique** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysTwoPointer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysTwoPointer.flux))*
- [x] **Sliding Window** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSlidingWindow.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSlidingWindow.flux))*
- [x] **Fast and Slow Pointers** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysFastAndSlowPointers.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysFastAndSlowPointers.flux))*
- [x] **Kadane's Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysKadane.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysKadane.flux))*
- [x] **Boyer-Moore Majority Vote** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysBoyerMooreMajorityVote.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysBoyerMooreMajorityVote.flux))*
- [x] **Dutch National Flag** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysDutchNationalFlag.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysDutchNationalFlag.flux))*
- [x] **Fisher-Yates Shuffle** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysFisherYates.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysFisherYates.flux))*
- [x] **Reservoir Sampling** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysReservoirSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysReservoirSampling.flux))*
- [x] **Floyd Random Sampling** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysFloydRandomSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysFloydRandomSampling.flux))*
- [x] **Quickselect** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysQuickselect.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysQuickselect.flux))*
- [x] **Introselect** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysIntroselect.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysIntroselect.flux))*
- [x] **Median of Medians** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMedianOfMedians.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMedianOfMedians.flux))*
- [x] **Mo's Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMosAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMosAlgorithm.flux))*
- [x] **Mo's Algorithm with Modifications** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMosAlgorithmWithModifications.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMosAlgorithmWithModifications.flux))*
- [x] **Offline Query Processing** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysOfflineQueryProcessing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysOfflineQueryProcessing.flux))*
- [x] **Parallel Binary Search** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysParallelBinarySearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysParallelBinarySearch.flux))*
- [x] **CDQ Divide and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysCDQDivideAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysCDQDivideAndConquer.flux))*
- [x] **Square-Root Decomposition** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSquareRootDecomposition.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSquareRootDecomposition.flux))*
- [x] **Sparse Table** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSparseTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSparseTable.flux))*
- [x] **Range Minimum Query** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysRangeMinimumQuery.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysRangeMinimumQuery.flux))*
- [x] **Range Maximum Query** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysRangeMaximumQuery.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysRangeMaximumQuery.flux))*
- [x] **Prefix Sum** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysPrefixSum.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysPrefixSum.flux))*
- [x] **Difference Array** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysDifferenceArray.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysDifferenceArray.flux))*
- [x] **Difference Constraints** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysDifferenceConstraints.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysDifferenceConstraints.flux))*
- [x] **Monotonic Stack** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMonotonicStack.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMonotonicStack.flux))*
- [x] **Monotonic Queue** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMonotonicQueue.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysMonotonicQueue.flux))*
- [x] **Sliding Window Minimum** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSlidingWindowMinimum.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSlidingWindowMinimum.flux))*
- [x] **Sliding Window Maximum** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSlidingWindowMaximum.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSlidingWindowMaximum.flux))*
- [x] **Coordinate Compression** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysCoordinateCompression.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysCoordinateCompression.flux))*
- [x] **Sweep Line** — *(Implementado em [`examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSweepLine.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/arrays/ExampleOfFundamentosArraysSweepLine.flux))*

#### Busca (33 algoritmos)

- [x] **Linear Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaSequencial.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaSequencial.flux))*
- [x] **Binary Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBinaria.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBinaria.flux))*
- [x] **Ternary Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaTernary.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaTernary.flux))*
- [x] **Fibonacci Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaFibonacci.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaFibonacci.flux))*
- [x] **Jump Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaJump.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaJump.flux))*
- [x] **Interpolation Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaInterpolation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaInterpolation.flux))*
- [x] **Exponential Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaExponential.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaExponential.flux))*
- [x] **Uniform Binary Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaUniformBinary.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaUniformBinary.flux))*
- [x] **Eytzinger Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaEytzinger.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaEytzinger.flux))*
- [x] **Depth-First Search — DFS** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaEmProfundidade.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaEmProfundidade.flux))*
- [x] **Breadth-First Search — BFS** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaEmLargura.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaEmLargura.flux))*
- [x] **Bidirectional Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBidirectional.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBidirectional.flux))*
- [x] **Iterative Deepening DFS** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaIDDFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaIDDFS.flux))*
- [x] **Iterative Deepening A\*** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaIterativeDeepeningAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaIterativeDeepeningAStar.flux))*
- [x] **Uniform-Cost Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaUniformCost.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaUniformCost.flux))*
- [x] **Best-First Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBestFirst.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBestFirst.flux))*
- [x] **Beam Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBeam.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBeam.flux))*
- [x] **Beam Stack Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBeamStack.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBeamStack.flux))*
- [x] **A\*** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaAStar.flux))*
- [x] **B\*** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaBStar.flux))*
- [x] **D\*** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaDStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaDStar.flux))*
- [x] **D\* Lite** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaDStarLite.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaDStarLite.flux))*
- [x] **Jump Point Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaJumpPoint.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaJumpPoint.flux))*
- [x] **IDA\*** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaIDAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaIDAStar.flux))*
- [x] **SMA\*** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaSMAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaSMAStar.flux))*
- [x] **Recursive Best-First Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaRBFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaRBFS.flux))*
- [x] **Minimax** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaMinimax.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaMinimax.flux))*
- [x] **Expectimax** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaExpectimax.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaExpectimax.flux))*
- [x] **Alpha-Beta Pruning** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaAlphaBeta.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaAlphaBeta.flux))*
- [x] **Negamax** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaNegamax.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaNegamax.flux))*
- [x] **Principal Variation Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaPVS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaPVS.flux))*
- [x] **MTD(f)** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaMTDf.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaMTDf.flux))*
- [x] **Monte Carlo Tree Search** — *(Implementado em [`examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaMCTS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/search/ExampleOfFundamentosBuscaMCTS.flux))*

#### Fundamentos e paradigmas algorítmicos (25 algoritmos)

- [x] **Brute Force** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasBruteForce.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasBruteForce.flux))*
- [x] **Divide and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDivideAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDivideAndConquer.flux))*
- [x] **Decrease and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDecreaseAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDecreaseAndConquer.flux))*
- [x] **Transform and Conquer** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasTransformAndConquer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasTransformAndConquer.flux))*
- [x] **Greedy Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasGreedyAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasGreedyAlgorithm.flux))*
- [x] **Dynamic Programming** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDynamicProgramming.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDynamicProgramming.flux))*
- [x] **Backtracking** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasBacktracking.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasBacktracking.flux))*
- [x] **Branch and Bound** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasBranchAndBound.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasBranchAndBound.flux))*
- [x] **Meet-in-the-Middle** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasMeetInTheMiddle.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasMeetInTheMiddle.flux))*
- [x] **Randomized Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasRandomizedAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasRandomizedAlgorithm.flux))*
- [x] **Monte Carlo Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasMonteCarloAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasMonteCarloAlgorithm.flux))*
- [x] **Las Vegas Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasLasVegasAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasLasVegasAlgorithm.flux))*
- [x] **Online Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasOnlineAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasOnlineAlgorithm.flux))*
- [x] **Offline Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasOfflineAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasOfflineAlgorithm.flux))*
- [x] **Approximation Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasApproximationAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasApproximationAlgorithm.flux))*
- [x] **Streaming Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasStreamingAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasStreamingAlgorithm.flux))*
- [x] **Amortized Algorithms** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasAmortizedAlgorithms.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasAmortizedAlgorithms.flux))*
- [x] **Incremental Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasIncrementalAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasIncrementalAlgorithm.flux))*
- [x] **Decremental Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDecrementalAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDecrementalAlgorithm.flux))*
- [x] **Parallel Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasParallelAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasParallelAlgorithm.flux))*
- [x] **Distributed Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDistributedAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasDistributedAlgorithm.flux))*
- [x] **External-Memory Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasExternalMemoryAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasExternalMemoryAlgorithm.flux))*
- [x] **External Sorting** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasExternalSorting.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasExternalSorting.flux))*
- [x] **Heuristic Search** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasHeuristicSearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasHeuristicSearch.flux))*
- [x] **Metaheuristic Optimization** — *(Implementado em [`examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasMetaheuristicOptimization.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/paradigms/ExampleOfFundamentosParadigmasMetaheuristicOptimization.flux))*

#### Ordenação (42 algoritmos)

- [x] **Bubble Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBubble.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBubble.flux))*
- [x] **Cocktail Shaker Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoShaker.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoShaker.flux))*
- [x] **Comb Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoComb.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoComb.flux))*
- [x] **Gnome Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoGnome.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoGnome.flux))*
- [x] **Odd-Even Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoOddEven.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoOddEven.flux))*
- [x] **Insertion Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoInsertion.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoInsertion.flux))*
- [x] **Selection Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSelection.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSelection.flux))*
- [x] **Shell Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoShell.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoShell.flux))*
- [x] **Quick Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoQuick.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoQuick.flux))*
- [x] **Randomized QuickSort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoRandomizedQuick.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoRandomizedQuick.flux))*
- [x] **Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoMerge.flux) e [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoMergeTopDown.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoMergeTopDown.flux))*
- [x] **Bottom-Up Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoMergeBottomUp.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoMergeBottomUp.flux))*
- [x] **Heap Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoHeap.flux))*
- [x] **Tree Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoTree.flux))*
- [x] **Cycle Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoCycle.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoCycle.flux))*
- [x] **Counting Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoCounting.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoCounting.flux))*
- [x] **Radix Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoRadix.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoRadix.flux))*
- [x] **Bucket Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBucket.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBucket.flux))*
- [x] **Pigeonhole Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPigeonhole.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPigeonhole.flux))*
- [x] **Flashsort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoFlash.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoFlash.flux))*
- [x] **Patience Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPatience.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPatience.flux))*
- [x] **Strand Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoStrand.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoStrand.flux))*
- [x] **Library Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoLibrary.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoLibrary.flux))*
- [x] **Bead Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBead.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBead.flux))*
- [x] **Pancake Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPancake.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPancake.flux))*
- [x] **Bitonic Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBitonic.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBitonic.flux))*
- [x] **Bitonic Sorting Network** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBitonicNetwork.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBitonicNetwork.flux))*
- [x] **Odd-Even Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoOddEvenMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoOddEvenMerge.flux))*
- [x] **Stooge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoStooge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoStooge.flux))*
- [x] **Slowsort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSlow.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSlow.flux))*
- [x] **Bogosort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBogo.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBogo.flux))*
- [x] **Spaghetti Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSpaghetti.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSpaghetti.flux))*
- [x] **Burstsort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBurst.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoBurst.flux))*
- [x] **Postman Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPostman.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPostman.flux))*
- [x] **Introsort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoIntro.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoIntro.flux))*
- [x] **Timsort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoTim.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoTim.flux))*
- [x] **Smoothsort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSmooth.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSmooth.flux))*
- [x] **Tournament Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoTournament.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoTournament.flux))*
- [x] **External Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoExternalMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoExternalMerge.flux))*
- [x] **Polyphase Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPolyphaseMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoPolyphaseMerge.flux))*
- [x] **Natural Merge Sort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoNaturalMerge.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoNaturalMerge.flux))*
- [x] **Samplesort** — *(Implementado em [`examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSample.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/sort/ExampleOfFundamentosOrdenacaoSample.flux))*


### Domínio II: Estruturas de Dados Avançadas & Streaming (63 algoritmos)

#### Estruturas de dados avançadas e árvores (42 algoritmos)

- [x] **Disjoint Set Union** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasDisjointSetUnion.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasDisjointSetUnion.flux))*
- [x] **Union-Find** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasDisjointSetUnion.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasDisjointSetUnion.flux))*
- [x] **Fenwick Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasFenwickTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasFenwickTree.flux))*
- [x] **Segment Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSegmentTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSegmentTree.flux))*
- [x] **Lazy Propagation** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasLazyPropagation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasLazyPropagation.flux))*
- [x] **Sparse Table** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSparseTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSparseTable.flux))*
- [x] **Sqrt Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSqrtTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSqrtTree.flux))*
- [x] **Treap** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTreap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTreap.flux))*
- [x] **Randomized Treap** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTreap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTreap.flux))*
- [x] **Splay Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSplayTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSplayTree.flux))*
- [x] **AVL Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasAVLTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasAVLTree.flux))*
- [x] **Red-Black Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRedBlackTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRedBlackTree.flux))*
- [x] **B-Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasBTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasBTree.flux))*
- [x] **B+ Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasBPlusTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasBPlusTree.flux))*
- [x] **2-3 Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTwoThreeTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTwoThreeTree.flux))*
- [x] **2-3-4 Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTwoThreeFourTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTwoThreeFourTree.flux))*
- [x] **Trie** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTrie.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTrie.flux))*
- [x] **Radix Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRadixTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRadixTree.flux))*
- [x] **Patricia Trie** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRadixTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRadixTree.flux))*
- [x] **Ternary Search Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTernarySearchTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasTernarySearchTree.flux))*
- [x] **Suffix Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSuffixTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSuffixTree.flux))*
- [x] **Suffix Automaton** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSuffixAutomaton.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasSuffixAutomaton.flux))*
- [x] **Skip List** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisSkipList.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisSkipList.flux))*
- [x] **Interval Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasIntervalTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasIntervalTree.flux))*
- [x] **Range Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRangeTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRangeTree.flux))*
- [x] **KD-Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasKDTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasKDTree.flux))*
- [x] **Quadtree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasQuadtree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasQuadtree.flux))*
- [x] **Octree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasOctree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasOctree.flux))*
- [x] **Cartesian Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasCartesianTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasCartesianTree.flux))*
- [x] **Link-Cut Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasLinkCutTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasLinkCutTree.flux))*
- [x] **Heavy-Light Decomposition** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasHeavyLightDecomposition.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasHeavyLightDecomposition.flux))*
- [x] **Centroid Decomposition** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasCentroidDecomposition.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasCentroidDecomposition.flux))*
- [x] **DSU on Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasDSUOnTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasDSUOnTree.flux))*
- [x] **Euler Tour Tree** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasEulerTourTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasEulerTourTree.flux))*
- [x] **Rope** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRope.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasRope.flux))*
- [x] **Bloom Filter** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux) e [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBloomFilter.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBloomFilter.flux))*
- [x] **Cuckoo Hashing** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisCuckoo.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisCuckoo.flux))*
- [x] **Cuckoo Filter** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasCuckooFilter.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasCuckooFilter.flux))*
- [x] **Count-Min Sketch** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingCountMinSketch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingCountMinSketch.flux))*
- [x] **HyperLogLog** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingHyperLogLog.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingHyperLogLog.flux))*
- [x] **MinHash** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashDistributedContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashDistributedContract.flux))*
- [x] **Locality-Sensitive Hashing** — *(Implementado em [`examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasLocalitySensitiveHashing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/advanced/ExampleOfEstruturasDeDadosAvancadasLocalitySensitiveHashing.flux))*

#### Estruturas de dados fundamentais e caches (12 algoritmos)

- [x] **Binary Heap** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasBinaryHeap.flux))*
- [x] **D-ary Heap** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasDaryHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasDaryHeap.flux))*
- [x] **Pairing Heap** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPairingHeap.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPairingHeap.flux))*
- [x] **Van Emde Boas Tree** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasVanEmdeBoasTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasVanEmdeBoasTree.flux))*
- [x] **Wavelet Tree** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasWaveletTree.flux))*
- [x] **Persistent Segment Tree** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPersistentSegmentTree.flux))*
- [x] **Persistent Data Structures** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPersistentDataStructures.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasPersistentDataStructures.flux))*
- [x] **Hash Table** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasHashTable.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasHashTable.flux))*
- [x] **Robin Hood Hashing** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasRobinHoodHashing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasRobinHoodHashing.flux))*
- [x] **Hopscotch Hashing** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasHopscotchHashing.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasHopscotchHashing.flux))*
- [x] **LRU Cache** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasLRUCache.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasLRUCache.flux))*
- [x] **LFU Cache** — *(Implementado em [`examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasLFUCache.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/basic/ExampleOfEstruturasDeDadosBasicasLFUCache.flux))*

#### Seleção e streaming (9 algoritmos)

- [x] **Floyd’s Tortoise and Hare Algorithm** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisTortoiseAndHare.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisTortoiseAndHare.flux))*
- [x] **Brent’s Cycle Detection** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBrent.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisBrent.flux))*
- [x] **Misra–Gries Algorithm** — elementos frequentes em streams — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingMisraGries.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingMisraGries.flux))*
- [x] **Space-Saving Algorithm** — top-k em streams — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingSpaceSaving.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingSpaceSaving.flux))*
- [x] **Count-Min Sketch** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingCountMinSketch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingCountMinSketch.flux))*
- [x] **HyperLogLog** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingHyperLogLog.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingHyperLogLog.flux))*
- [x] **Flajolet–Martin Algorithm** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingFlajoletMartin.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingFlajoletMartin.flux))*
- [x] **Min-wise Independent Permutations** — *(Implementado em [`examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingMinWisePermutations.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/02_data_structures/streaming/ExampleOfEstruturasDeDadosStreamingMinWisePermutations.flux))*
- [x] **Reservoir Sampling** — *(Implementado em [`examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisReservoirSampling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/01_foundations/special/ExampleOfFundamentosEspeciaisReservoirSampling.flux))*


### Domínio III: Teoria dos Grafos & Redes (119 algoritmos)

#### Árvores geradoras mínimas — MST (9 algoritmos)

- [x] **Kruskal** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTKruskal.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTKruskal.flux))*
- [x] **Prim** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTPrim.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTPrim.flux))*
- [x] **Borůvka** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTBoruvka.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTBoruvka.flux))*
- [x] **Reverse-Delete** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTReverseDelete.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTReverseDelete.flux))*
- [x] **Sollin** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTSollin.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTSollin.flux))*
- [x] **Euclidean MST** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTEuclideanMST.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTEuclideanMST.flux))*
- [x] **Second-Best MST** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTSecondBestMST.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTSecondBestMST.flux))*
- [x] **Dynamic MST** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTDynamicMST.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTDynamicMST.flux))*
- [x] **Minimum Bottleneck Spanning Tree** — *(Implementado em [`examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTMinimumBottleneck.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/mst/ExampleOfGrafosMSTMinimumBottleneck.flux))*

#### Caminhos mínimos (19 algoritmos)

- [x] **Dijkstra** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDijkstra.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDijkstra.flux))*
- [x] **Bidirectional Dijkstra** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosBidirectionalDijkstra.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosBidirectionalDijkstra.flux))*
- [x] **Bellman-Ford** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosBellmanFord.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosBellmanFord.flux))*
- [x] **SPFA** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosSPFA.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosSPFA.flux))*
- [x] **0-1 BFS** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosZeroOneBFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosZeroOneBFS.flux))*
- [x] **Dial's Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDial.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDial.flux))*
- [x] **D'Esopo-Pape** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDEsopoPape.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDEsopoPape.flux))*
- [x] **Floyd-Warshall** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosFloydWarshall.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosFloydWarshall.flux))*
- [x] **Johnson** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosJohnson.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosJohnson.flux))*
- [x] **A*** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosAStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosAStar.flux))*
- [x] **D*** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDStar.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDStar.flux))*
- [x] **D* Lite** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDStarLite.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosDStarLite.flux))*
- [x] **ALT** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosALT.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosALT.flux))*
- [x] **Contraction Hierarchies** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosContractionHierarchies.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosContractionHierarchies.flux))*
- [x] **Hub Labeling** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosHubLabeling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosHubLabeling.flux))*
- [x] **Lee Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosLeeAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosLeeAlgorithm.flux))*
- [x] **Shortest Path Faster Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosShortestPathFasterAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosShortestPathFasterAlgorithm.flux))*
- [x] **Longest Path in DAG** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosLongestPathInDAG.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosLongestPathInDAG.flux))*
- [x] **Critical Path Method** — *(Implementado em [`examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosCriticalPathMethod.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/shortest_path/ExampleOfGrafosCaminhosMinimosCriticalPathMethod.flux))*

#### Conectividade, travessia e representação de grafos (40 algoritmos)

- [x] **DFS** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeDFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeDFS.flux))*
- [x] **BFS** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBFS.flux))*
- [x] **Connected Components** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeConnectedComponents.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeConnectedComponents.flux))*
- [x] **Strongly Connected Components** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeStronglyConnectedComponents.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeStronglyConnectedComponents.flux))*
- [x] **Kosaraju** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeKosaraju.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeKosaraju.flux))*
- [x] **Tarjan SCC** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTarjanSCC.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTarjanSCC.flux))*
- [x] **Gabow SCC** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeGabowSCC.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeGabowSCC.flux))*
- [x] **Path-Based SCC** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadePathBasedSCC.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadePathBasedSCC.flux))*
- [x] **Topological Sort** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTopologicalSort.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTopologicalSort.flux))*
- [x] **Kahn's Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeKahn.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeKahn.flux))*
- [x] **Cycle Detection** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeCycleDetection.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeCycleDetection.flux))*
- [x] **Bipartite Graph Test** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBipartiteGraphTest.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBipartiteGraphTest.flux))*
- [x] **Articulation Points** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeArticulationPoints.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeArticulationPoints.flux))*
- [x] **Bridge Finding** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBridgeFinding.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBridgeFinding.flux))*
- [x] **Online Bridge Finding** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeOnlineBridgeFinding.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeOnlineBridgeFinding.flux))*
- [x] **Biconnected Components** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBiconnectedComponents.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBiconnectedComponents.flux))*
- [x] **Block-Cut Tree** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBlockCutTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBlockCutTree.flux))*
- [x] **2-SAT** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTwoSAT.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTwoSAT.flux))*
- [x] **Graph Condensation** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeGraphCondensation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeGraphCondensation.flux))*
- [x] **Transitive Closure** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTransitiveClosure.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTransitiveClosure.flux))*
- [x] **Warshall Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeWarshall.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeWarshall.flux))*
- [x] **Eulerian Path** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeEulerianPath.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeEulerianPath.flux))*
- [x] **Eulerian Circuit** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeEulerianCircuit.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeEulerianCircuit.flux))*
- [x] **Hierholzer** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeHierholzer.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeHierholzer.flux))*
- [x] **Prüfer Code** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadePruferCode.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadePruferCode.flux))*
- [x] **Tree Diameter** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeDiameter.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeDiameter.flux))*
- [x] **Tree Center** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeCenter.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeCenter.flux))*
- [x] **Tree Centroid** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeCentroid.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeCentroid.flux))*
- [x] **Tree Isomorphism** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeIsomorphism.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeIsomorphism.flux))*
- [x] **Tree Traversal** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeTraversal.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTreeTraversal.flux))*
- [x] **Euler Tour Technique** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeEulerTourTechnique.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeEulerTourTechnique.flux))*
- [x] **Lowest Common Ancestor** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeLowestCommonAncestor.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeLowestCommonAncestor.flux))*
- [x] **Binary Lifting** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBinaryLifting.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeBinaryLifting.flux))*
- [x] **Tarjan Offline LCA** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTarjanOfflineLCA.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeTarjanOfflineLCA.flux))*
- [x] **Farach-Colton and Bender LCA** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeFarachColtonBenderLCA.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeFarachColtonBenderLCA.flux))*
- [x] **Heavy-Light Decomposition** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeHeavyLightDecomposition.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeHeavyLightDecomposition.flux))*
- [x] **Centroid Decomposition** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeCentroidDecomposition.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeCentroidDecomposition.flux))*
- [x] **DSU on Tree** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeDSUOnTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeDSUOnTree.flux))*
- [x] **Rerooting** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeRerooting.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeRerooting.flux))*
- [x] **Virtual Tree** — *(Implementado em [`examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeVirtualTree.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/connectivity/ExampleOfGrafosConectividadeVirtualTree.flux))*

#### Fluxo, corte e matching (24 algoritmos)

- [x] **Ford-Fulkerson** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteFordFulkerson.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteFordFulkerson.flux))*
- [x] **Edmonds-Karp** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteEdmondsKarp.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteEdmondsKarp.flux))*
- [x] **Dinic** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteDinic.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteDinic.flux))*
- [x] **Dinic with Scaling** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteDinicWithScaling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteDinicWithScaling.flux))*
- [x] **Push-Relabel** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCortePushRelabel.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCortePushRelabel.flux))*
- [x] **Highest-Label Push-Relabel** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteHighestLabelPushRelabel.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteHighestLabelPushRelabel.flux))*
- [x] **MPM** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteMPM.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteMPM.flux))*
- [x] **Stoer-Wagner** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteStoerWagner.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteStoerWagner.flux))*
- [x] **Karger's Min-Cut** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKargerMinCut.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKargerMinCut.flux))*
- [x] **Karger-Stein** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKargerStein.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKargerStein.flux))*
- [x] **Minimum-Cost Flow** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteMinimumCostFlow.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteMinimumCostFlow.flux))*
- [x] **Successive Shortest Path** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteSuccessiveShortestPath.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteSuccessiveShortestPath.flux))*
- [x] **Min-Cost Max-Flow with Potentials** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteMinCostMaxFlowWithPotentials.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteMinCostMaxFlowWithPotentials.flux))*
- [x] **Cycle-Canceling** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteCycleCanceling.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteCycleCanceling.flux))*
- [x] **Flow with Demands** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteFlowWithDemands.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteFlowWithDemands.flux))*
- [x] **Kuhn Matching** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKuhnMatching.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKuhnMatching.flux))*
- [x] **Hungarian Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteHungarianAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteHungarianAlgorithm.flux))*
- [x] **Kuhn-Munkres** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKuhnMunkres.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteKuhnMunkres.flux))*
- [x] **Hopcroft-Karp** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteHopcroftKarp.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteHopcroftKarp.flux))*
- [x] **Edmonds' Blossom** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteEdmondsBlossom.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteEdmondsBlossom.flux))*
- [x] **Gale-Shapley** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteGaleShapley.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteGaleShapley.flux))*
- [x] **Stable Marriage** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteStableMarriage.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteStableMarriage.flux))*
- [x] **Stable Roommates** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteStableRoommates.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteStableRoommates.flux))*
- [x] **Assignment Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteAssignmentAlgorithm.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/flow/ExampleOfGrafosFluxoCorteAssignmentAlgorithm.flux))*

#### Grafos avançados, coloração e cortes (14 algoritmos)

- [x] **Chu–Liu/Edmonds Algorithm** — árvore geradora mínima direcionada — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralChuLiuEdmonds.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralChuLiuEdmonds.flux))*
- [x] **Yen’s Algorithm** — k menores caminhos — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralYenKShortestPaths.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralYenKShortestPaths.flux))*
- [x] **Suurballe’s Algorithm** — caminhos disjuntos — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralSuurballe.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralSuurballe.flux))*
- [x] **Karger’s Algorithm** — corte mínimo global — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralKargerMinCut.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralKargerMinCut.flux))*
- [x] **Bron–Kerbosch Algorithm** — cliques máximas — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralBronKerbosch.flux))*
- [x] **Welsh–Powell Algorithm** — coloração de grafos — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralWelshPowell.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralWelshPowell.flux))*
- [x] **DSATUR** — coloração de grafos — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralDSATUR.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralDSATUR.flux))*
- [x] **Edmonds’ Algorithm for Directed MST** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralEdmondsDirectedMST.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralEdmondsDirectedMST.flux))*
- [x] **Transitive Reduction** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralTransitiveReduction.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralTransitiveReduction.flux))*
- [x] **Graph Coloring Algorithms** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralGraphColoring.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralGraphColoring.flux))*
- [x] **Maximum Clique Algorithms** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralMaximumClique.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralMaximumClique.flux))*
- [x] **Minimum Feedback Vertex Set** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralMinimumFeedbackVertexSet.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralMinimumFeedbackVertexSet.flux))*
- [x] **BFS/DFS Paralelo** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralParallelBFSDFS.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralParallelBFSDFS.flux))*
- [x] **Graph Contraction** — *(Implementado em [`examples/algorithms/03_graphs/core/ExampleOfGrafosGeralGraphContraction.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/core/ExampleOfGrafosGeralGraphContraction.flux))*

#### Teoria da computação e complexidade (13 algoritmos)

- [x] **Redução de Karp** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeKarpReduction.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeKarpReduction.flux))*
- [x] **Redução de Cook** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeCookReduction.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeCookReduction.flux))*
- [x] **Teorema de Cook-Levin** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeCookLevinTheorem.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeCookLevinTheorem.flux))*
- [x] **Algoritmo de Hopcroft–Karp** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeHopcroftKarp.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeHopcroftKarp.flux))*
- [x] **Algoritmos de aproximação para Set Cover** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeSetCoverApproximation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeSetCoverApproximation.flux))*
- [x] **Algoritmo de aproximação para Vertex Cover** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeVertexCoverApproximation.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeVertexCoverApproximation.flux))*
- [x] **Christofides’ Algorithm** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeChristofidesTSP.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeChristofidesTSP.flux))*
- [x] **PTAS para Knapsack** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadePTASKnapsack.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadePTASKnapsack.flux))*
- [x] **FPTAS para Knapsack** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeFPTASKnapsack.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeFPTASKnapsack.flux))*
- [x] **Branch and Cut** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeBranchAndCut.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeBranchAndCut.flux))*
- [x] **Bron–Kerbosch** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeBronKerbosch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeBronKerbosch.flux))*
- [x] **Algoritmos parametrizados** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeParameterizedAlgorithms.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeParameterizedAlgorithms.flux))*
- [x] **Kernelization** — *(Implementado em [`examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeKernelization.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/03_graphs/complexity/ExampleOfGrafosComplexidadeKernelization.flux))*


### Domínio IV: Strings, Texto & Teoria da Informação (105 algoritmos)

#### Codecs modernos e formatos de compressão (13 algoritmos)

- [ ] Brotli
- [x] **Zstandard — Zstd** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressZstdContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressZstdContract.flux))*
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

#### Compressão de dados e codificação clássica (30 algoritmos)

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
- [x] **LZMA** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressLzmaContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressLzmaContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressXzContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressXzContract.flux))*
- [ ] LZO
- [ ] LZ4
- [x] **DEFLATE** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressDeflateContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressDeflateContract.flux), [`flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux))*
- [ ] PPM
- [x] **Burrows-Wheeler Transform** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux))*
- [ ] Move-to-Front
- [ ] Delta Encoding
- [ ] Byte Pair Encoding
- [ ] Vector Quantization
- [ ] SPIHT
- [ ] Embedded Zerotree Wavelet
- [ ] Fractal Compression
- [ ] Wavelet Compression

#### Distância e similaridade de strings (14 algoritmos)

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

#### Strings e casamento de padrões (31 algoritmos)

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
- [x] **Burrows-Wheeler Transform** — *(Já implementado em [`flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressBzip2Contract.flux))*
- [ ] FM-Index
- [ ] Trigram Search
- [ ] Wildcard Matching

#### Teoria da informação e códigos corretores (17 algoritmos)

- [ ] Hamming Code
- [ ] Reed-Solomon
- [ ] BCH
- [ ] Berlekamp-Massey
- [ ] Peterson-Gorenstein-Zierler
- [ ] BCJR
- [ ] Viterbi Decoder
- [ ] Turbo Codes
- [ ] LDPC
- [x] **CRC** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressGzipContract.flux))*
- [x] **Adler-32** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux) e [`flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseCompressStdLib_CompressZlibContract.flux))*
- [x] **Fletcher Checksum** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux))*
- [x] **Luhn Algorithm** — *(Já implementado em [`flux/ExampleOfUseHashStdLib_HashChecksumContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseHashStdLib_HashChecksumContract.flux))*
- [ ] Verhoeff
- [ ] Damm Algorithm
- [ ] Gray Code
- [ ] Parity Check


### Domínio V: Matemática Computacional, Teoria dos Números & Álgebra (143 algoritmos)

#### Álgebra computacional e polinômios (41 algoritmos)

- [ ] Gaussian Elimination
- [ ] Gauss-Jordan
- [ ] Gaussian Elimination over GF(2)
- [ ] Gauss-Seidel
- [ ] Jacobi Method
- [x] **Cholesky** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux))*
- [ ] Gram-Schmidt
- [x] **QR Decomposition** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixQRContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixQRContract.flux))*
- [x] **LU Decomposition** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixDecompositionContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixDecompositionContract.flux))*
- [x] **Singular Value Decomposition** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixSVDContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixSVDContract.flux))*
- [ ] Conjugate Gradient
- [ ] BiCG
- [ ] GMRES
- [ ] Arnoldi
- [ ] Lanczos
- [x] **Power Iteration** — *(Já implementado em [`flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseLinAlgStdLib_MatrixAdvancedDecompositionContract.flux))*
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
- [x] **Fast Polynomial Multiplication** — *(Já implementado em [`flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux))*
- [ ] Multipoint Evaluation
- [ ] Formal Power Series
- [ ] NTT
- [x] **FFT** — *(Já implementado em [`flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseSymbolicStdLib_SymbolicTransformContract.flux))*
- [ ] FWHT
- [ ] Bluestein FFT
- [ ] Rader FFT
- [ ] Cooley-Tukey FFT

#### Combinatória (21 algoritmos)

- [ ] Inclusion-Exclusion
- [ ] Burnside's Lemma
- [ ] Pólya Enumeration
- [ ] Stars and Bars
- [ ] Catalan Numbers
- [ ] Bell Numbers
- [ ] Stirling Numbers
- [ ] Pascal Triangle
- [x] **Binomial Coefficient** — *(Já implementado em [`flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux))*
- [ ] Heap's Permutation Algorithm
- [ ] Steinhaus-Johnson-Trotter
- [x] **Fisher-Yates** — *(Já implementado em [`flux/ExampleOfUseRandomStdLib_RandomSequenceContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseRandomStdLib_RandomSequenceContract.flux))*
- [ ] Josephus Problem
- [ ] Prüfer Code
- [ ] Generating Functions
- [ ] Partition Algorithms
- [ ] Subset Enumeration
- [ ] Submask Enumeration
- [ ] Gray Code
- [ ] Balanced Parentheses Generation
- [ ] Meet-in-the-Middle

#### Programação dinâmica (29 algoritmos)

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

#### Teoria dos números (52 algoritmos)

- [x] **Euclidean Algorithm** — *(Já implementado em [`flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfUseMathStdLib_CombinatoricsContract.flux))*
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


### Domínio VI: Métodos Numéricos, Geometria & Física Computacional (144 algoritmos)

#### Computação gráfica (21 algoritmos)

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

#### Física computacional (47 algoritmos)

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

#### Geometria computacional (41 algoritmos)

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

#### Métodos numéricos (35 algoritmos)

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


### Domínio VII: Otimização & Estatística Científica (84 algoritmos)

#### Estatística e inferência (23 algoritmos)

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

#### Otimização (45 algoritmos)

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

#### Probabilidade e amostragem (16 algoritmos)

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


### Domínio VIII: Inteligência Artificial, ML & Deep Learning (261 algoritmos)

#### Algoritmos de grafos para IA (16 algoritmos)

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

#### Busca vetorial, RAG e adaptação de modelos (31 algoritmos)

> Especialmente HNSW, Product Quantization e RAG são importantes para sistemas modernos de busca semântica e IA generativa.

- [ ] Beam Search with Diverse Decoding
- [ ] Speculative Decoding
- [ ] Contrastive Search
- [ ] Best-of-N Sampling
- [ ] Monte Carlo Dropout
- [ ] Retrieval-Augmented Generation — RAG
- [ ] Maximal Marginal Relevance — MMR
- [x] **HNSW** — Hierarchical Navigable Small World — *(Implementado em [`examples/algorithms/08_artificial_intel/machine_learning/ExampleOfHNSWVectorSearch.flux`](file:///D:/Projetos/TheFlux/examples/algorithms/08_artificial_intel/machine_learning/ExampleOfHNSWVectorSearch.flux))*
- [ ] Product Quantization
- [ ] IVF-Flat
- [ ] IVF-PQ
- [ ] LoRA
- [ ] QLoRA
- [ ] Knowledge Distillation
- [ ] Neural Architecture Search

#### Deep Learning e visão computacional (49 algoritmos)

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

#### Ensemble Learning (21 algoritmos)

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

#### IA generativa (24 algoritmos)

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

#### Machine Learning clássico (38 algoritmos)

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

#### NLP — Processamento de linguagem natural (23 algoritmos)

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

#### Redes neurais (20 algoritmos)

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

#### Reinforcement Learning (25 algoritmos)

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

#### Sistemas de recomendação (14 algoritmos)

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


### Domínio X: Bioinformática, Computação Quântica & Criptografia Pós-Quântica (71 algoritmos)

#### Algoritmos pós-quânticos e Criptografia Quântico-Resistente (30 algoritmos)

- [ ] ML-KEM (CRYSTALS-Kyber) — FIPS 203 Key Encapsulation Mechanism baseado em Module-LWE
- [ ] ML-DSA (CRYSTALS-Dilithium) — FIPS 204 Digital Signature Algorithm baseado em Module-LWE/SIS
- [ ] FN-DSA (Falcon) — assinatura digital compacta baseada em NTRU e Fast Fourier Sampling
- [ ] NTRU (NTRUEncrypt) — criptossistema clássico de reticulados sobre anéis polinomiais
- [ ] FrodoKEM — KEM conservador baseado em Learning with Errors (LWE) não estruturado
- [ ] LLL (Lenstra–Lenstra–Lovász) — algoritmo polinomial de redução de base de reticulados
- [ ] BKZ (Block Korkine-Zolotarev) — algoritmo avançado de redução de reticulados por blocos
- [ ] Babai’s Nearest Plane — algoritmo de aproximação para o Closest Vector Problem (CVP)
- [ ] Learning With Errors (LWE / Ring-LWE) — primitiva e gerador de erros gaussianos discretos
- [ ] Short Integer Solution (SIS / Module-SIS) — problema médio de reticulados para funções hash e assinaturas
- [ ] SLH-DSA (SPHINCS+) — FIPS 205 assinatura digital stateless baseada em árvores hiperbólicas de hash
- [ ] XMSS (eXtended Merkle Signature Scheme) — assinatura stateful padronizada na RFC 8391
- [ ] LMS (Leighton-Micali Signatures) — assinatura stateful hierárquica (RFC 8554 / NIST SP 800-208)
- [ ] Lamport One-Time Signature (OTS) — esquema pioneiro de assinatura de uso único via hash unidirecional
- [ ] Winternitz One-Time Signature (WOTS+) — assinatura em cadeia de hashes com tamanho de chave reduzido
- [ ] FORS (Forest of Random Subsets) — primitiva Few-Time Signature utilizada no SPHINCS+
- [ ] Classic McEliece — KEM pós-quântico de alta segurança baseado em códigos de Goppa lineares
- [ ] Niederreiter Cryptosystem — variante dual do McEliece baseada em decodificação de síndromes
- [ ] BIKE (Bit Flipping Key Encapsulation) — KEM baseado em códigos QC-MDPC com decodificação por inversão de bits
- [ ] HQC (Hamming Quasi-Cyclic) — KEM baseado em códigos quase-cíclicos com decodificação concatenada
- [ ] Information Set Decoding (ISD / Algoritmo de Prange) — algoritmo canônico para decodificação genérica de códigos
- [ ] Decodificador de Códigos de Goppa (Berlekamp-Massey / Patterson) — algoritmo de decodificação e localização de erros
- [ ] CSIDH — troca de chaves não interativa pós-quântica baseada em ação de grupo em curvas supersingulares
- [ ] SQISign — assinatura digital pós-quântica com chaves e assinaturas ultracompactas via quatérnios e isogenias
- [ ] Fórmulas de Vélu — cálculo e avaliação eficiente de isogenias explícitas entre curvas elípticas
- [ ] Rainbow — assinatura digital multivariada baseada em camadas invertíveis de Oil and Vinegar
- [ ] UOV (Unbalanced Oil and Vinegar) — esquema multivariado clássico com equações quadráticas em corpos finitos
- [ ] MAYO — variante compacta moderna do esquema UOV
- [ ] Transformada de Fujisaki-Okamoto (FO Transform) — conversão genérica de PKE CPA para KEM CCA com oráculo aleatório
- [ ] KEM Híbrido Pós-Quântico (X25519 + ML-KEM-768) — combinação paralela de chave clássica e quântico-resistente para TLS 1.3

#### Algoritmos quânticos (28 algoritmos)

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

#### Bioinformática (13 algoritmos)

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
