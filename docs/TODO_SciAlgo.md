# 🔬 TODO_SciAlgo: Catálogo e Roadmap de Algoritmos Científicos em TheFlux

> **Status**: Planejamento e Roteiro de Implementação  
> **Origem**: Baseado no catálogo exaustivo de `docs/TODO_algo.txt`  
> **Suíte Alvo**: `examples/algorithms/` com execução nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)

---

## 📊 1. Resumo Executivo & Métricas do Catálogo

- **Total de Entradas Catalogadas**: 1.294 algoritmos
- **Algoritmos Únicos (Deduplicados)**: 1.220 algoritmos
- **Algoritmos Já Implementados**: 24 programas em [`flux/`](file:///D:/Projetos/TheFlux/flux)
- **Algoritmos a Implementar**: 1.196 algoritmos
- **Divisão Estrutural**: **10 Grandes Domínios Científicos** e **49 Categorias Temáticas**

### Tabela de Domínios e Volumes

| Domínio | Escopo Temático | Total de Algoritmos |
| :--- | :--- | :---: |
| **Domínio I: Fundamentos, Busca e Ordenação** | Subcategorias especializadas | **149** |
| **Domínio II: Estruturas de Dados Avançadas & Streaming** | Subcategorias especializadas | **63** |
| **Domínio III: Teoria dos Grafos & Redes** | Subcategorias especializadas | **119** |
| **Domínio IV: Strings, Texto & Teoria da Informação** | Subcategorias especializadas | **105** |
| **Domínio V: Matemática Computacional, Teoria dos Números & Álgebra** | Subcategorias especializadas | **143** |
| **Domínio VI: Métodos Numéricos, Geometria & Física Computacional** | Subcategorias especializadas | **144** |
| **Domínio VII: Otimização & Estatística Científica** | Subcategorias especializadas | **84** |
| **Domínio VIII: Inteligência Artificial, ML & Deep Learning** | Subcategorias especializadas | **261** |
| **Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura** | Subcategorias especializadas | **185** |
| **Domínio X: Bioinformática & Computação Quântica** | Subcategorias especializadas | **41** |
| **Total Geral** | **10 Grandes Domínios** | **1.294** |

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
├── test_scientific_algorithms.py   # Runner dedicado nos 6 backends com relatórios
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

- **Fase 0: Infraestrutura e Padrões**: Setup de `examples/algorithms/`, runner `test_scientific_algorithms.py` e espelhamento dos 24 exemplos existentes.
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

Algoritmos de especial relevância para sistemas modernos destacados para implementação prioritária:

- [ ] **Binary Heap**
- [ ] **Hash Table**
- [ ] **Persistent Segment Tree**
- [ ] **Wavelet Tree**
- [ ] **Chu–Liu/Edmonds**
- [ ] **Yen’s Algorithm**
- [ ] **Bron–Kerbosch**
- [ ] **Christofides’ Algorithm**
- [ ] **Misra–Gries**
- [ ] **Consistent Hashing**
- [ ] **Gossip Protocol**
- [ ] **PBFT**
- [ ] **MapReduce**
- [ ] **Merkle Tree**
- [ ] **HNSW**

---

## 📚 6. Catálogo Completo dos 1.294 Algoritmos por Domínio

### Domínio I: Fundamentos, Busca e Ordenação (149 algoritmos)

#### 1. Fundamentos e paradigmas algorítmicos (25 algoritmos)

- [ ] Brute Force
- [ ] Divide and Conquer
- [ ] Decrease and Conquer
- [ ] Transform and Conquer
- [ ] Greedy Algorithm
- [ ] Dynamic Programming
- [ ] Backtracking
- [ ] Branch and Bound
- [ ] Meet-in-the-Middle
- [ ] Randomized Algorithm
- [ ] Monte Carlo Algorithm
- [ ] Las Vegas Algorithm
- [ ] Online Algorithm
- [ ] Offline Algorithm
- [ ] Approximation Algorithm
- [ ] Streaming Algorithm
- [ ] Amortized Algorithms
- [ ] Incremental Algorithm
- [ ] Decremental Algorithm
- [ ] Parallel Algorithm
- [ ] Distributed Algorithm
- [ ] External-Memory Algorithm
- [ ] External Sorting
- [ ] Heuristic Search
- [ ] Metaheuristic Optimization

#### 2. Busca (33 algoritmos)

- [x] **Linear Search** — *(Já implementado em [`flux/ExampleOfBuscaSequencial.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaSequencial.flux))*
- [x] **Binary Search** — *(Já implementado em [`flux/ExampleOfBuscaBinaria.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaBinaria.flux))*
- [ ] Ternary Search
- [ ] Fibonacci Search
- [ ] Jump Search
- [ ] Interpolation Search
- [ ] Exponential Search
- [ ] Uniform Binary Search
- [ ] Eytzinger Search
- [x] **Depth-First Search — DFS** — *(Já implementado em [lux/ExampleOfBuscaEmProfundidade.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaEmProfundidade.flux))*
- [x] **Breadth-First Search — BFS** — *(Já implementado em [lux/ExampleOfBuscaEmLargura.flux](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaEmLargura.flux))*
- [ ] Bidirectional Search
- [ ] Iterative Deepening DFS
- [ ] Iterative Deepening A*
- [ ] Uniform-Cost Search
- [ ] Best-First Search
- [ ] Beam Search
- [ ] Beam Stack Search
- [x] **A*** — *(Já implementado em [`flux/ExampleOfBuscaAStar.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaAStar.flux))*
- [ ] B*
- [ ] D*
- [ ] D* Lite
- [ ] Jump Point Search
- [ ] IDA*
- [ ] SMA*
- [ ] Recursive Best-First Search
- [ ] Minimax
- [ ] Expectimax
- [ ] Alpha-Beta Pruning
- [ ] Negamax
- [ ] Principal Variation Search
- [ ] MTD(f)
- [ ] Monte Carlo Tree Search

#### 3. Ordenação (42 algoritmos)

- [x] **Bubble Sort** — *(Já implementado em [`flux/ExampleOfSortBubble.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortBubble.flux))*
- [x] **Cocktail Shaker Sort** — *(Já implementado em [`flux/ExampleOfSortShaker.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortShaker.flux))*
- [x] **Comb Sort** — *(Já implementado em [`flux/ExampleOfSortComb.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortComb.flux))*
- [x] **Gnome Sort** — *(Já implementado em [`flux/ExampleOfSortGnome.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortGnome.flux))*
- [x] **Odd-Even Sort** — *(Já implementado em [`flux/ExampleOfSortOddEven.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortOddEven.flux))*
- [x] **Insertion Sort** — *(Já implementado em [`flux/ExampleOfSortInsertion.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortInsertion.flux))*
- [x] **Selection Sort** — *(Já implementado em [`flux/ExampleOfSortSelection.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortSelection.flux))*
- [x] **Shell Sort** — *(Já implementado em [`flux/ExampleOfSortShell.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortShell.flux))*
- [x] **Quick Sort** — *(Já implementado em [`flux/ExampleOfSortQuick.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortQuick.flux))*
- [ ] Randomized QuickSort
- [x] **Merge Sort** — *(Já implementado em [`flux/ExampleOfSortMerge.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortMerge.flux))*
- [x] **Bottom-Up Merge Sort** — *(Já implementado em [`flux/ExampleOfSortMergeBottomUp.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortMergeBottomUp.flux))*
- [x] **Heap Sort** — *(Já implementado em [`flux/ExampleOfSortHeap.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortHeap.flux))*
- [ ] Tree Sort
- [ ] Cycle Sort
- [ ] Counting Sort
- [x] **Radix Sort** — *(Já implementado em [`flux/ExampleOfSortRadix.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortRadix.flux))*
- [ ] Bucket Sort
- [ ] Pigeonhole Sort
- [ ] Flashsort
- [ ] Patience Sort
- [ ] Strand Sort
- [ ] Library Sort
- [ ] Bead Sort
- [x] **Pancake Sort** — *(Já implementado em [`flux/ExampleOfSortPancake.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortPancake.flux))*
- [x] **Bitonic Sort** — *(Já implementado em [`flux/ExampleOfSortBitonic.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortBitonic.flux))*
- [ ] Bitonic Sorting Network
- [ ] Odd-Even Merge Sort
- [x] **Stooge Sort** — *(Já implementado em [`flux/ExampleOfSortStooge.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortStooge.flux))*
- [ ] Slowsort
- [x] **Bogosort** — *(Já implementado em [`flux/ExampleOfSortBogo.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfSortBogo.flux))*
- [ ] Spaghetti Sort
- [ ] Burstsort
- [ ] Postman Sort
- [ ] Introsort
- [ ] Timsort
- [ ] Smoothsort
- [ ] Tournament Sort
- [ ] External Merge Sort
- [ ] Polyphase Merge Sort
- [ ] Natural Merge Sort
- [ ] Samplesort

#### 4. Arrays e sequências (30 algoritmos)

- [ ] Two-Pointer Technique
- [ ] Sliding Window
- [ ] Fast and Slow Pointers
- [ ] Kadane's Algorithm
- [ ] Boyer-Moore Majority Vote
- [ ] Dutch National Flag
- [ ] Fisher-Yates Shuffle
- [ ] Reservoir Sampling
- [ ] Floyd Random Sampling
- [ ] Quickselect
- [ ] Introselect
- [ ] Median of Medians
- [ ] Mo's Algorithm
- [ ] Mo's Algorithm with Modifications
- [ ] Offline Query Processing
- [ ] Parallel Binary Search
- [ ] CDQ Divide and Conquer
- [ ] Square-Root Decomposition
- [ ] Sparse Table
- [ ] Range Minimum Query
- [ ] Range Maximum Query
- [ ] Prefix Sum
- [ ] Difference Array
- [ ] Difference Constraints
- [ ] Monotonic Stack
- [ ] Monotonic Queue
- [ ] Sliding Window Minimum
- [ ] Sliding Window Maximum
- [ ] Coordinate Compression
- [ ] Sweep Line

#### 42. Algoritmos especiais (19 algoritmos)

- [ ] Josephus
- [ ] Tortoise and Hare
- [ ] Brent's Cycle Detection
- [ ] Ackermann Function
- [ ] Doomsday Algorithm
- [ ] Zeller's Congruence
- [ ] Easter Algorithms
- [ ] Zobrist Hashing
- [ ] Cuckoo Hashing
- [ ] Bloom Filter
- [ ] Skip List Algorithms
- [ ] Reservoir Sampling
- [ ] Alias Method
- [ ] Shunting-Yard
- [ ] Ramer-Douglas-Peucker
- [ ] Kahan Summation
- [ ] Horner's Method
- [ ] Booth's Algorithm
- [ ] Fast Doubling

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
- [ ] Bloom Filter
- [ ] Cuckoo Hashing
- [ ] Cuckoo Filter
- [ ] Count-Min Sketch
- [ ] HyperLogLog
- [ ] MinHash
- [ ] Locality-Sensitive Hashing

#### Estruturas de dados (Adições Prioritárias) (12 algoritmos)

> A lista cita várias árvores avançadas, mas não destaca suficientemente estruturas extremamente usadas na prática, como heaps, tabelas hash e caches.

- [ ] Binary Heap
- [ ] D-ary Heap
- [ ] Pairing Heap
- [ ] Van Emde Boas Tree
- [ ] Wavelet Tree
- [ ] Persistent Segment Tree
- [ ] Persistent Data Structures
- [ ] Hash Table
- [ ] Robin Hood Hashing
- [ ] Hopscotch Hashing
- [ ] LRU Cache
- [ ] LFU Cache

#### 3. Algoritmos de seleção e streaming (Adições Prioritárias) (9 algoritmos)

> Essa área está presente, mas poderia ser organizada como algoritmos para dados massivos e streaming.

- [ ] Floyd’s Tortoise and Hare Algorithm — embora a ideia apareça como “Tortoise and Hare”, deveria estar também na seção de arrays e sequências
- [ ] Brent’s Cycle Detection — já aparece apenas no final
- [ ] Misra–Gries Algorithm — elementos frequentes em streams
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

- [x] **Dijkstra** — *(Já implementado em [`flux/ExampleOfBuscaDijkstra.flux`](file:///D:/Projetos/TheFlux/flux/ExampleOfBuscaDijkstra.flux))*
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

- [ ] Chu–Liu/Edmonds Algorithm — árvore geradora mínima direcionada
- [ ] Yen’s Algorithm — k menores caminhos
- [ ] Suurballe’s Algorithm — caminhos disjuntos
- [ ] Karger’s Algorithm já aparece, mas poderia ser acompanhado de outras variantes de corte
- [ ] Bron–Kerbosch Algorithm — cliques máximas
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
- [ ] Christofides’ Algorithm
- [ ] PTAS para Knapsack
- [ ] FPTAS para Knapsack
- [ ] Branch and Cut já aparece
- [ ] Bron–Kerbosch
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
- [ ] Burrows-Wheeler Transform
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
- [ ] LZMA
- [ ] LZO
- [ ] LZ4
- [ ] DEFLATE
- [ ] PPM
- [ ] Burrows-Wheeler Transform
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
- [ ] CRC
- [ ] Adler-32
- [ ] Fletcher Checksum
- [ ] Luhn Algorithm
- [ ] Verhoeff
- [ ] Damm Algorithm
- [ ] Gray Code
- [ ] Parity Check

#### 6. Compressão e processamento de dados (Adições Prioritárias) (13 algoritmos)

- [ ] Brotli
- [ ] Zstandard — Zstd
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
- [ ] Binomial Coefficient
- [ ] Heap's Permutation Algorithm
- [ ] Steinhaus-Johnson-Trotter
- [ ] Fisher-Yates
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

- [ ] Euclidean Algorithm
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
- [ ] Cholesky
- [ ] Gram-Schmidt
- [ ] QR Decomposition
- [ ] LU Decomposition
- [ ] Singular Value Decomposition
- [ ] Conjugate Gradient
- [ ] BiCG
- [ ] GMRES
- [ ] Arnoldi
- [ ] Lanczos
- [ ] Power Iteration
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
- [ ] Fast Polynomial Multiplication
- [ ] Multipoint Evaluation
- [ ] Formal Power Series
- [ ] NTT
- [ ] FFT
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

> Minhas 15 principais recomendações

> Se fosse para acrescentar apenas quinze, eu escolheria:

- [ ] A parte de IA está boa, mas acrescentaria:
- [ ] Beam Search with Diverse Decoding
- [ ] Speculative Decoding
- [ ] Contrastive Search
- [ ] Best-of-N Sampling
- [ ] Monte Carlo Dropout
- [ ] Retrieval-Augmented Generation — RAG
- [ ] Maximal Marginal Relevance — MMR
- [ ] HNSW — Hierarchical Navigable Small World
- [ ] Product Quantization
- [ ] IVF-Flat
- [ ] IVF-PQ
- [ ] LoRA
- [ ] QLoRA
- [ ] Knowledge Distillation
- [ ] Neural Architecture Search
- [ ] Binary Heap
- [ ] Hash Table
- [ ] Persistent Segment Tree
- [ ] Wavelet Tree
- [ ] Chu–Liu/Edmonds
- [ ] Yen’s Algorithm
- [ ] Bron–Kerbosch
- [ ] Christofides’ Algorithm
- [ ] Misra–Gries
- [ ] Consistent Hashing
- [ ] Gossip Protocol
- [ ] PBFT
- [ ] MapReduce
- [ ] Merkle Tree
- [ ] HNSW

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
- [ ] MD5
- [ ] SHA-1
- [ ] SHA-2
- [ ] SHA-3
- [ ] BLAKE
- [ ] RIPEMD
- [ ] Whirlpool
- [ ] HMAC
- [ ] Poly1305
- [ ] SipHash
- [ ] Argon2
- [ ] bcrypt
- [ ] PBKDF2
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

- [ ] Consistent Hashing
- [ ] Rendezvous Hashing
- [ ] Gossip Protocol
- [ ] SWIM Membership Protocol
- [ ] Chord Distributed Hash Table
- [ ] Kademlia
- [ ] Two-Phase Commit
- [ ] Three-Phase Commit
- [ ] Byzantine Fault Tolerant Consensus
- [ ] PBFT
- [ ] HotStuff
- [ ] MapReduce
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
- [ ] BLAKE2
- [ ] BLAKE3
- [ ] Merkle Tree
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
- [ ] MapReduce
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
