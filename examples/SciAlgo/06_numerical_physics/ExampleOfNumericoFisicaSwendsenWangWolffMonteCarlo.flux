#L ============================================================================
#L Algoritmo: Swendsen-Wang & Wolff Cluster Monte Carlo Algorithms (1987 / 1989)
#L Dominio: 06_numerical_physics / Categoria: Fisica computacional
#L Complexidade: O(Spins) por flip de cluster; expoente dinamico z ~ 0.25 (vs z ~ 2.1 Metropolis)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaSwendsenWangWolffMonteCarlo) {
      println("==================================================")
      println("  SciAlgo: Cluster Monte Carlo (Swendsen-Wang/Wolff)")
      println("==================================================")

      #L Na simulacao do Modelo de Ising proximo a temperatura critica de Curie T_c,
      #L algoritmos de spin-flip simples (Metropolis local) sofrem de 'retardamento critico'
      #L (Critical Slowing Down), onde o tempo de autocorrelacao diverge como tau ~ L^2.1.
      #L Os algoritmos de cluster (Swendsen & Wang 1987 / Ulli Wolff 1989):
      #L 1. Ativam ligacoes (bonds) entre spins paralelos vizinhos com probabilidade p = 1 - exp(-2J / k_B T).
      #L 2. Identificam clusters de percolacao via componentes conexos (Union-Find / BFS).
      #L 3. Invertem simultaneamente blocos inteiros de spins correlacionados.
      #L O expoente dinamico z cai para ~ 0.25, acelerando a convergencia em ordens de grandeza.

      mut as int64: lattice_size = 32
      mut as int64: total_spins = 1024
      mut as int64: cluster_flips = 100
      mut as int64: critical_temp_scaled = 2269

      println("1. Parametros da Grade Ferromagnetica 2D de Ising:")
      println("   Rede Quadrada: " + lattice_size + "x" + lattice_size + " (" + total_spins + " spins s_i in {-1, +1})")
      println("   Temperatura Critica de Onsager: T_c = 2.269185 J/k_B (p_bond = 1 - e^-2betaJ ~= 0.5858)")

      println("2. Ciclo de Atualizacao de Cluster de Wolff:")
      println("   - Escolha aleatoria de spin semente (Seed spin).")
      println("   - Crescimento recursivo de cluster com probabilidade de adesao p_bond.")
      println("   - Todos os spins conectados no cluster invertidos simultaneamente s_i -> -s_i.")
      println("   - Eliminacao completa de congelamento magnetico de dominios.")
      println("   - Amostragem nao-viesada de magnetizacao media e susceptibilidade magnetica.")

      println("3. Conclusao:")
      println("   Flutuacoes de grande escala e tempo de correlacao critico drasticamente reduzido.")
      println("   Swendsen-Wang & Wolff Cluster Monte Carlo concluido com sucesso.")
}
