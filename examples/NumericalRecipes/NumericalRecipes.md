# 📘 Numerical Recipes in TheFlux (3rd Edition, 2007) - Modelo 2

> **Status**: Catálogo Completo dos 205 Algoritmos Reais da 3ª Edição (Modelo 2)
> **Origem**: Baseado no tratado *Numerical Recipes: The Art of Scientific Computing (3rd Edition, 2007, Cambridge University Press)*
> **Suíte Alvo**: `examples/NumericalRecipes/` com 100% de paridade nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)



---


## 📊 1. Resumo Executivo & Métricas da Suíte

- **Total de Algoritmos Catalogados**: **205** algoritmos científicos clássicos
- **Algoritmos Implementados em TheFlux**: **205** (100,0% de cobertura)
- **Paridade Multi-Backend**: **100%** de conformidade nos 6 backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)
- **Divisão Estrutural**: **22 Capítulos Canônicos** cobrindo desde Álgebra Linear a EDPs e Geometria Computacional
- **Abordagem de Direitos Autorais**: *Clean-room implementation* integral em sintaxe nativa TheFlux (`.flux`)

### Tabela Geral de Capítulos e Volumes

| Capítulo                                                                       | Escopo Científico            | Total de Algoritmos | Implementados | % Concluído | Status |
|--------------------------------------------------------------------------------|------------------------------|:-------------------:|:-------------:|:-----------:|:------:|
| **Preliminares, Precisão de Máquina & Análise de Erro**                          | 01_preliminaries             |                   5 |             5 |   **100,0%**  | ✅ Concluído |
| **Resolução de Sistemas de Equações Algébricas Lineares**                        | 02_linear_algebra            |                  13 |            13 |   **100,0%**  | ✅ Concluído |
| **Interpolação e Extrapolação**                                                  | 03_interpolation             |                  10 |            10 |   **100,0%**  | ✅ Concluído |
| **Integração Numérica de Funções**                                               | 04_integration               |                  10 |            10 |   **100,0%**  | ✅ Concluído |
| **Avaliação de Funções, Séries e Frações Contínuas**                             | 05_function_evaluation       |                  14 |            14 |   **100,0%**  | ✅ Concluído |
| **Funções Especiais da Física Matemática**                                       | 06_special_functions         |                  14 |            14 |   **100,0%**  | ✅ Concluído |
| **Geração de Números Aleatórios e Métodos de Monte Carlo**                       | 07_random_numbers            |                  11 |            11 |   **100,0%**  | ✅ Concluído |
| **Algoritmos de Ordenação e Seleção Estatística**                                | 08_sorting_selection         |                   8 |             8 |   **100,0%**  | ✅ Concluído |
| **Localização de Raízes e Sistemas de Equações Não-Lineares**                    | 09_root_finding              |                   9 |             9 |   **100,0%**  | ✅ Concluído |
| **Minimização e Maximização de Funções**                                         | 10_minimization              |                  14 |            14 |   **100,0%**  | ✅ Concluído |
| **Sistemas de Autovalores e Autovetores**                                        | 11_eigensystems              |                   8 |             8 |   **100,0%**  | ✅ Concluído |
| **Transformada Rápida de Fourier (FFT)**                                         | 12_fast_fourier_transform    |                   9 |             9 |   **100,0%**  | ✅ Concluído |
| **Aplicações Espectrais e Processamento de Sinais por Fourier**                  | 13_fourier_spectral          |                  11 |            11 |   **100,0%**  | ✅ Concluído |
| **Descrição Estatística de Dados**                                               | 14_statistical_description   |                  10 |            10 |   **100,0%**  | ✅ Concluído |
| **Modelagem, Ajuste de Parâmetros e Teoria da Estimação**                        | 15_modeling_data             |                   9 |             9 |   **100,0%**  | ✅ Concluído |
| **Classificação, Agrupamento e Inferência Estatística**                          | 16_classification_inference  |                   7 |             7 |   **100,0%**  | ✅ Concluído |
| **Integração Numérica de Equações Diferenciais Ordinárias (EDOs)**               | 17_differential_equations    |                   8 |             8 |   **100,0%**  | ✅ Concluído |
| **Problemas de Valor de Contorno em Dois Pontos (BVPs)**                         | 18_boundary_value_problems   |                   6 |             6 |   **100,0%**  | ✅ Concluído |
| **Equações Integrais e Teoria Inversa**                                          | 19_integral_equations        |                   7 |             7 |   **100,0%**  | ✅ Concluído |
| **Resolução Numérica de Equações Diferenciais Parciais (EDPs)**                  | 20_partial_differential_eqs  |                   7 |             7 |   **100,0%**  | ✅ Concluído |
| **Geometria Computacional**                                                      | 21_computational_geometry    |                   8 |             8 |   **100,0%**  | ✅ Concluído |
| **Algoritmos Discretos, Criptográficos e Menos Numéricos**                       | 22_less_numerical            |                   7 |             7 |   **100,0%**  | ✅ Concluído |
| **Total Geral**                                                                | **22 Capítulos Canônicos**   |                 205 |           205 |   **100,0%**  | 🚀 **Suíte Ativa** |



---


## 📁 2. Arquitetura da Suíte e Diretórios

Os algoritmos são distribuídos nos 22 subdiretórios correspondentes à estrutura original da obra:

```text
TheFlux/
└── examples/
    └── NumericalRecipes/
        ├── NumericalRecipes.md             # Catálogo mestre dos 205 algoritmos
        ├── NumericalRecipes_compliance.py  # Test runner automatizado dos 6 backends
        ├── NumericalRecipes_compliance.md  # Matriz oficial de conformidade de execução
        ├── 01_preliminaries/
        ├── 02_linear_algebra/
        ├── 03_interpolation/
        ├── 04_integration/
        ├── 05_function_evaluation/
        ├── 06_special_functions/
        ├── 07_random_numbers/
        ├── 08_sorting_selection/
        ├── 09_root_finding/
        ├── 10_minimization/
        ├── 11_eigensystems/
        ├── 12_fast_fourier_transform/
        ├── 13_fourier_spectral/
        ├── 14_statistical_description/
        ├── 15_modeling_data/
        ├── 16_classification_inference/
        ├── 17_differential_equations/
        ├── 18_boundary_value_problems/
        ├── 19_integral_equations/
        ├── 20_partial_differential_eqs/
        ├── 21_computational_geometry/
        ├── 22_less_numerical/
```



---


## 🔬 3. Catálogo Detalhado de Algoritmos por Capítulo (Modelo 2)

### 01. Preliminares, Precisão de Máquina & Análise de Erro (`01_preliminaries` - 5 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Error, Accuracy, and Stability (Precisão e Erro Numérico)**                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/01_preliminaries/ExampleOfNR_ErrorAccuracyStability.flux)                               |
| **Scientific Memory Layout (Layout de Memória e Vetores)**                         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/01_preliminaries/ExampleOfNR_MemoryModelSyntax.flux)                                    |
| **Numerical Conventions & Bounds (Limites Numéricos e IEEE 754)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/01_preliminaries/ExampleOfNR_NumericalConventions.flux)                                 |
| **Scientific Types & Abstractions (Abstrações Numéricas)**                         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/01_preliminaries/ExampleOfNR_ScientificTypesAbstraction.flux)                           |
| **Vector and Matrix Operations (Operações Vetoriais e Matriciais)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/01_preliminaries/ExampleOfNR_VectorMatrixObjects.flux)                                  |



### 02. Resolução de Sistemas de Equações Algébricas Lineares (`02_linear_algebra` - 13 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Bandec (Decomposicao de Matriz em Banda)**                                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_Bandec.flux)                                              |
| **Cholesky Decomposition (Decomposição de Cholesky L * L^T)**                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_CholeskyDecomposition.flux)                               |
| **Gaussian Elimination with Backsubstitution (Eliminação Gaussiana com Retrosub...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_GaussianEliminationBacksub.flux)                          |
| **Gauss-Jordan Elimination (Eliminação de Gauss-Jordan com Pivoteamento)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_GaussJordanElimination.flux)                              |
| **Iterative Improvement of Solutions (Refinamento Iterativo de Sistemas)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_IterativeImprovement.flux)                                |
| **LU Decomposition and Its Applications (Decomposição LU de Crout)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_LUDecomposition.flux)                                     |
| **Matrix Inversion Complexity (Inversão Subcúbica de Matrizes)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_MatrixInversionComplexity.flux)                           |
| **QR Decomposition (Decomposição QR por Householder)**                             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_QRDecomposition.flux)                                     |
| **Singular Value Decomposition — SVD (Decomposição em Valores Singulares)**        | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_SingularValueDecomposition.flux)                          |
| **Sparse Linear Systems (Sistemas Esparsos por Gradiente Conjugado)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_SparseLinearSystems.flux)                                 |
| **Toeplz (Algoritmo de Levinson para Matrizes Toeplitz)**                          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_Toeplz.flux)                                              |
| **Tridag (Algoritmo Tridiagonal de Thomas)**                                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_Tridag.flux)                                              |
| **Vander (Sistemas Lineares de Vandermonde)**                                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/02_linear_algebra/ExampleOfNR_Vander.flux)                                              |



### 03. Interpolação e Extrapolação (`03_interpolation` - 10 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **BaryRat_interp (Interpolacao Racional Baricentrica)**                            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_BaryRat_interp.flux)                                       |
| **Coefficients of Interpolating Polynomial (Coeficientes do Polinômio Interpola...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_CoefficientsInterpolatingPolynomial.flux)                  |
| **Laplace Interpolation (Interpolação e Reconstrução por Laplace)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_LaplaceInterpolation.flux)                                 |
| **Multidimensional Grid Interpolation (Interpolação em Grades 2D e 3D)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_MultidimensionalGridInterpolation.flux)                    |
| **Polynomial Interpolation — Neville (Algoritmo de Neville)**                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_PolynomialInterpolationNeville.flux)                       |
| **Rat_interp (Interpolacao Racional Bulirsch-Stoer)**                              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_Rat_interp.flux)                                           |
| **Scattered Data Interpolation (Interpolação de Dados Dispersos de Shepard)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_ScatteredDataInterpolationShepard.flux)                    |
| **Searching an Ordered Table (Busca Bisseccionada e Caçada em Tabelas)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_SearchingOrderedTable.flux)                                |
| **Spline2D_interp (Spline Bicubico em Grade 2D)**                                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_Spline2D_interp.flux)                                      |
| **Spline_interp (Spline Cubico Natural 1D)**                                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/03_interpolation/ExampleOfNR_Spline_interp.flux)                                        |



### 04. Integração Numérica de Funções (`04_integration` - 10 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Adaptive Quadrature (Quadratura Adaptativa com Controle de Erro)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_AdaptiveQuadrature.flux)                                     |
| **Classical Formulas for Equally Spaced (Fórmulas Clássicas de Newton-Cotes)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_ClassicalEquallySpacedFormulas.flux)                         |
| **Elementary Integration Algorithms (Regra de Simpson Estendida)**                 | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_ElementaryIntegrationAlgorithms.flux)                        |
| **Gauher (Quadratura de Gauss-Hermite)**                                           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_Gauher.flux)                                                 |
| **Gaulag (Quadratura de Gauss-Laguerre)**                                          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_Gaulag.flux)                                                 |
| **Gauleg (Quadratura de Gauss-Legendre)**                                          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_Gauleg.flux)                                                 |
| **Improper Integrals (Integração Numérica de Integrais Impróprias)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_ImproperIntegrals.flux)                                      |
| **Multidimensional Integrals (Integrais Multidimensionais em Hipercubos)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_MultidimensionalIntegrals.flux)                              |
| **Quadrature by Variable Transformation (Quadratura DE / Tanh-Sinh)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_QuadratureVariableTransformation.flux)                       |
| **Romberg Integration (Integração de Romberg com Extrapolação de Richardson)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/04_integration/ExampleOfNR_RombergIntegration.flux)                                     |



### 05. Avaliação de Funções, Séries e Frações Contínuas (`05_function_evaluation` - 14 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Chebyshev Approximation (Aproximação por Polinômios de Chebyshev)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_ChebyshevApproximation.flux)                         |
| **Derivatives & Integrals of Chebyshev (Derivadas e Integrais de Chebyshev)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_ChebyshevDerivativesIntegrals.flux)                  |
| **Clenshaw's Recurrence Formula (Fórmula de Recorrência de Clenshaw)**             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_ClenshawRecurrenceFormula.flux)                      |
| **Complex Arithmetic (Aritmética Complexa Estável)**                               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_ComplexArithmetic.flux)                              |
| **Economization of Power Series (Economização de Séries de Potências)**            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_EconomizationPowerSeries.flux)                       |
| **Evaluation of Continued Fractions (Frações Contínuas pelo Método de Lentz)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_EvaluationContinuedFractions.flux)                   |
| **Function Evaluation by Path Integration (Integração de Contorno Complexo)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_FunctionEvaluationPathIntegration.flux)              |
| **Numerical Derivatives — Ridders (Derivação Numérica de Ridders)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_NumericalDerivativesRidders.flux)                    |
| **Padé Approximants (Aproximantes Racionais de Padé [M/N])**                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_PadeApproximants.flux)                               |
| **Polynomial Approximation from Chebyshev (Conversão de Chebyshev para Polinômi...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_PolynomialFromChebyshevCoefficients.flux)            |
| **Polynomials & Rational Functions (Avaliação de Polinômios por Horner)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_PolynomialsRationalFunctions.flux)                   |
| **Quadratic & Cubic Equations (Equações Quadráticas e Cúbicas Estáveis)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_QuadraticCubicEquations.flux)                        |
| **Rational Chebyshev Approximation (Aproximação Racional de Chebyshev)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_RationalChebyshevApproximation.flux)                 |
| **Series & Their Convergence (Aceleração de Séries de van Wijngaarden)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/05_function_evaluation/ExampleOfNR_SeriesConvergenceAcceleration.flux)                  |



### 06. Funções Especiais da Física Matemática (`06_special_functions` - 14 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Bessel Fractional, Airy & Spherical (Bessel Fracionária e Funções de Airy)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_BesselFractionalAirySpherical.flux)                    |
| **Bessel Functions of Integer Order (Funções de Bessel J_n e Y_n)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_BesselIntegerOrder.flux)                               |
| **Dawson's Integral (Integral de Dawson F(x))**                                    | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_DawsonsIntegral.flux)                                  |
| **Elliptic Integrals & Jacobian Functions (Integrais Elípticas de Carlson)**       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_EllipticIntegralsJacobian.flux)                        |
| **Exponential Integrals (Integrais Exponenciais En(x) e Ei(x))**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_ExponentialIntegrals.flux)                             |
| **Fresnel Integrals (Integrais de Fresnel C(x), S(x) e Si(x), Ci(x))**             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_FresnelCosineSineIntegrals.flux)                       |
| **Gamma & Beta Functions (Função Gamma de Lanczos e Função Beta)**                 | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_GammaBetaFactorials.flux)                              |
| **Generalized Fermi-Dirac Integrals (Integrais de Fermi-Dirac)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_GeneralizedFermiDiracIntegrals.flux)                   |
| **Hypergeometric Functions (Funções Hipergeométricas de Gauss 2F1)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_HypergeometricFunctions.flux)                          |
| **Incomplete Beta Function (Função Beta Incompleta Ix(a, b))**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_IncompleteBetaFunction.flux)                           |
| **Incomplete Gamma & Error Function (Gamma Incompleta e Função de Erro erf)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_IncompleteGammaErrorFunction.flux)                     |
| **Inverse of x log(x) — Lambert W (Inversa de x log(x) e W de Lambert)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_InverseXLogX.flux)                                     |
| **Spherical Harmonics (Harmônicos Esféricos Y_lm e Legendre)**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_SphericalHarmonics.flux)                               |
| **Statistical Functions (Funções de Distribuição Cumulativa)**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/06_special_functions/ExampleOfNR_StatisticalDistributionFunctions.flux)                 |



### 07. Geração de Números Aleatórios e Métodos de Monte Carlo (`07_random_numbers` - 11 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Adaptive Monte Carlo — VEGAS (Integração Adaptativa de VEGAS)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_AdaptiveMonteCarloVegas.flux)                             |
| **Deviates from Other Distributions (Distribuições Exponencial e Poisson)**        | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_DeviatesOtherDistributions.flux)                          |
| **Completely Hashing a Large Array (Hash de Alta Entropia para Arrays)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_HashingLargeArray.flux)                                   |
| **Hash Tables & Hash Memories (Tabelas de Dispersão Científicas)**                 | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_HashTablesMemories.flux)                                  |
| **Linear Feedback Shift Registers — LFSR (Gerador por Registrador LFSR)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_LinearFeedbackShiftRegisters.flux)                        |
| **Multivariate Normal Deviates (Distribuição Normal Multivariada)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_MultivariateNormalDeviates.flux)                          |
| **Quasi-Random Sequences — Sobol (Sequências de Baixa Discrepância de Sobol)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_QuasiRandomSobolSequences.flux)                           |
| **Ran (Gerador Canonico de Numeros Pseudoaleatorios 64-bit)**                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_Ran.flux)                                                 |
| **Ranfib (Gerador Lagged-Fibonacci 64-bit)**                                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_Ranfib.flux)                                              |
| **Ranq1 (Gerador Rapido Xorshift 64-bit)**                                         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_Ranq1.flux)                                               |
| **Simple Monte Carlo Integration (Integração Monte Carlo Uniforme)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/07_random_numbers/ExampleOfNR_SimpleMonteCarloIntegration.flux)                         |



### 08. Algoritmos de Ordenação e Seleção Estatística (`08_sorting_selection` - 8 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Equivalence Classes (Determinação de Classes de Equivalência)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_EquivalenceClasses.flux)                               |
| **Heapsort (Ordenação por Heap Binário in-place)**                                 | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_HeapSort.flux)                                         |
| **Indexing & Ranking (Ordenação Indireta por Índices e Postos)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_IndexingAndRanking.flux)                               |
| **Piksrt (Straight Insertion Sort)**                                               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_Piksrt.flux)                                           |
| **Quicksort (Quicksort com Particionamento e Mediana de Três)**                    | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_QuickSort.flux)                                        |
| **Select (Quickselect M-esimo Maior Elemento)**                                    | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_Select.flux)                                           |
| **Selip (Selecao in-place de K-esimo Elemento)**                                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_Selip.flux)                                            |
| **Shell (Ordenacao por Shellsort)**                                                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/08_sorting_selection/ExampleOfNR_Shell.flux)                                            |



### 09. Localização de Raízes e Sistemas de Equações Não-Lineares (`09_root_finding` - 9 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Globally Convergent Methods — Broyden (Método de Quase-Newton de Broyden)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_GloballyConvergentBroyden.flux)                             |
| **Newton-Raphson for Nonlinear Systems (Newton-Raphson Multidimensional)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_NewtonRaphsonNonlinearSystems.flux)                         |
| **Roots of Polynomials — Laguerre (Método de Laguerre para Polinômios)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_RootsOfPolynomialsLaguerre.flux)                            |
| **Rtbis (Busca de Raizes por Bissecao)**                                           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_Rtbis.flux)                                                 |
| **Rtnewt (Newton-Raphson com Derivadas)**                                          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_Rtnewt.flux)                                                |
| **Rtsafe (Newton-Raphson com Salvaguarda de Bissecao)**                            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_Rtsafe.flux)                                                |
| **Secant Method & False Position (Método da Secante e Regula Falsi)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_SecantFalsePosition.flux)                                   |
| **Brent's Root Finding Method (Método de Raiz de Brent-Dekker)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_VanWijngaardenDekkerBrent.flux)                             |
| **Zbrak (Bracketing e Varredura de Raizes)**                                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/09_root_finding/ExampleOfNR_Zbrak.flux)                                                 |



### 10. Minimização e Maximização de Funções (`10_minimization` - 14 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Bracketing a Minimum (Delimitação Inicial de Mínimo Unidimensional)**            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_BracketingMinimum.flux)                                     |
| **Brent (Minimizacao 1D sem Derivadas)**                                           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_Brent.flux)                                                 |
| **Conjugate Gradient — FR/PR (Gradiente Conjugado Fletcher-Reeves)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_ConjugateGradientFletcherReeves.flux)                       |
| **Dbrent (Minimizacao 1D com Derivadas)**                                          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_Dbrent.flux)                                                |
| **Powell's Direction Set Method (Método de Direções de Powell)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_DirectionSetPowellsMethod.flux)                             |
| **Downhill Simplex — Nelder-Mead (Método Simplex de Nelder-Mead)**                 | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_DownhillSimplexNelderMead.flux)                             |
| **Dynamic Programming (Programação Dinâmica para Decisões Sequenciais)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_DynamicProgrammingKnapsack.flux)                            |
| **Golden Section Search (Busca da Seção Áurea 1D)**                                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_GoldenSectionSearch.flux)                                   |
| **Interior-Point Methods (Métodos de Pontos Interiores em PL)**                    | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_InteriorPointLinearProgramming.flux)                        |
| **Linear Programming — Simplex (Método Simplex para Programação Linear)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_LinearProgrammingSimplex.flux)                              |
| **Line Methods in Multidimensions (Minimização Multidimensional em Linha)**        | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_LineMethodsMultidimensions.flux)                            |
| **1D Search with First Derivatives (Minimização 1D com Derivadas)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_OneDimensionalSearchDerivatives.flux)                       |
| **Quasi-Newton — BFGS (Otimização Quase-Newtoniana BFGS)**                         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_QuasiNewtonBFGS.flux)                                       |
| **Simulated Annealing (Recozimento Simulado para Otimização Global)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/10_minimization/ExampleOfNR_SimulatedAnnealingOptimization.flux)                        |



### 11. Sistemas de Autovalores e Autovetores (`11_eigensystems` - 8 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Eigenvalues of Tridiagonal Matrix (Algoritmo QL para Matriz Tridiagonal)**       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_EigenvaluesTridiagonalMatrix.flux)                          |
| **Hermitian Matrices (Autovalores de Matrizes Hermitianas)**                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_HermitianMatricesEigenvalues.flux)                          |
| **Inverse Iteration for Eigenvectors (Iteração Inversa de Autovetores)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_InverseIterationFindingEigenvectors.flux)                   |
| **Jacobi Transformations (Transformações de Jacobi para Matrizes Simétricas)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_JacobiTransformationsSymmetric.flux)                        |
| **QR Algorithm for Hessenberg (Algoritmo QR de Francis)**                          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_QRAlgorithmRealHessenberg.flux)                             |
| **Real Nonsymmetric Matrices (Redução à Forma de Hessenberg)**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_RealNonsymmetricMatricesHessenberg.flux)                    |
| **Real Symmetric Matrices (Propriedades Espectrais de Matrizes Simétricas)**       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_RealSymmetricMatricesProperties.flux)                       |
| **Reduction to Tridiagonal Form (Redução a Tridiagonal por Householder)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/11_eigensystems/ExampleOfNR_ReductionTridiagonalHouseholderGivens.flux)                 |



### 12. Transformada Rápida de Fourier (FFT) (`12_fast_fourier_transform` - 9 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Cosft (Transformada Rapida de Cosseno)**                                         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_Cosft.flux)                                       |
| **Fourier Transform of Sampled Data (Transformada Discreta de Fourier DFT)**       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_DiscreteFourierTransformSampled.flux)             |
| **Memory-Local & External FFTs (FFT de Quatro Passos com Acesso Local)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_ExternalStorageMemoryLocalFFT.flux)               |
| **Fast Fourier Transform — FFT (FFT Radix-2 de Cooley-Tukey)**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_FastFourierTransformCooleyTukey.flux)             |
| **FFT of Real Functions (FFT Especializada para Funções Reais)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_FFTOfRealFunctions.flux)                          |
| **FFT in Two or More Dimensions (FFT 2D e Multidimensional)**                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_FFTTwoOrMoreDimensions.flux)                      |
| **Fourier Transforms of Real Data in 2D/3D (FFT 2D e 3D de Dados Reais)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_RealDataFFT2D3D.flux)                             |
| **Sinft (Transformada Rapida de Seno)**                                            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_Sinft.flux)                                       |
| **Twofft (FFT Simultanea de Duas Funcoes Reais em Uma Complexa)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/12_fast_fourier_transform/ExampleOfNR_Twofft.flux)                                      |



### 13. Aplicações Espectrais e Processamento de Sinais por Fourier (`13_fourier_spectral` - 11 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Computing Fourier Integrals (Integrais de Fourier por Filon/FFT)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_ComputingFourierIntegralsFFT.flux)                      |
| **Convolution & Deconvolution Using FFT (Convolução e Desconvolução Rápida)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_ConvolutionDeconvolutionFFT.flux)                       |
| **Correlation & Autocorrelation Using FFT (Correlação e Autocorrelação)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_CorrelationAutocorrelationFFT.flux)                     |
| **Digital Filtering in Time Domain (Filtros Digitais IIR e FIR)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_DigitalFilteringTimeDomain.flux)                        |
| **Linear Prediction & LPC (Predição Linear com Levinson-Durbin)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_LinearPredictionCodingLPC.flux)                         |
| **Maximum Entropy Method — Burg (Estimativa de Máxima Entropia de Burg)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_MaximumEntropyMethodBurg.flux)                          |
| **Numerical Use of Sampling Theorem (Teorema de Amostragem de Whittaker)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_NumericalSamplingTheorem.flux)                          |
| **Optimal (Wiener) Filtering (Filtro Ótimo de Wiener)**                            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_OptimalWienerFilteringFFT.flux)                         |
| **Power Spectrum Estimation — Welch (Densidade Espectral de Potência)**            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_PowerSpectrumEstimationFFT.flux)                        |
| **Spectral Analysis of Unevenly Sampled Data (Periodograma de Lomb-Scargle)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_SpectralAnalysisUnevenlySampledLomb.flux)               |
| **Wavelet Transforms (Transformada Wavelet Discreta DWT de Daubechies)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/13_fourier_spectral/ExampleOfNR_WaveletTransforms.flux)                                 |



### 14. Descrição Estatística de Dados (`14_statistical_description` - 10 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contingency Table Analysis (Tabelas de Contingência e Qui-Quadrado)**            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_ContingencyTableAnalysis.flux)                   |
| **Are Distributions Different? — KS Test (Teste de Kolmogorov-Smirnov)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_DistributionDifferenceKS.flux)                   |
| **FTest (Teste F para Razao de Variancias)**                                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_FTest.flux)                                      |
| **Information-Theoretic Properties (Entropia de Shannon e Informação Mútua)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_InformationTheoreticProperties.flux)             |
| **Linear Correlation — Pearson (Correlação Linear de Pearson)**                    | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_LinearCorrelationPearson.flux)                   |
| **Moments of Distribution (Momentos Estatísticos: Média, Variância, Assimetria ...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_MomentsMeanVarianceSkewKurtosis.flux)            |
| **Nonparametric Rank Correlation — Spearman/Kendall (Correlação de Postos)**       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_NonparametricRankCorrelation.flux)               |
| **Savitzky-Golay Smoothing Filters (Filtros de Savitzky-Golay)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_SavitzkyGolaySmoothingFilters.flux)              |
| **StudentTTest (Teste t de Student para Duas Medias)**                             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_StudentTTest.flux)                               |
| **2D Distributions Difference (Teste 2D de Fasano-Franceschini)**                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/14_statistical_description/ExampleOfNR_TwoDimensionalDistributionsDifference.flux)      |



### 15. Modelagem, Ajuste de Parâmetros e Teoria da Estimação (`15_modeling_data` - 9 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Confidence Limits on Estimated Parameters (Limites de Confiança de Parâmetros)** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_ConfidenceLimitsModelParameters.flux)                      |
| **Fitting Data to a Straight Line (Ajuste de Reta Linear y = a + bx)**             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_FittingStraightLine.flux)                                  |
| **Gaussian Process Regression (Regressão por Processos Gaussianos)**               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_GaussianProcessRegression.flux)                            |
| **General Linear Least Squares — SVD (Mínimos Quadrados Lineares Gerais com SVD)** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_GeneralLinearLeastSquares.flux)                            |
| **Least Squares as Maximum Likelihood (Mínimos Quadrados como Máxima Verossimil...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_LeastSquaresMaximumLikelihood.flux)                        |
| **Markov Chain Monte Carlo — MCMC (MCMC Metropolis-Hastings para Inferência Bay...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_MarkovChainMonteCarlo.flux)                                |
| **Nonlinear Models — Levenberg-Marquardt (Ajuste Não-Linear de Levenberg-Marqua...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_NonlinearModelsLevenbergMarquardt.flux)                    |
| **Robust Estimation — Huber Loss (Regressão Robusta com Perda de Huber)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_RobustEstimationHuber.flux)                                |
| **Straight Line with Errors in Both Coordinates (Ajuste com Erros em X e Y)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/15_modeling_data/ExampleOfNR_StraightLineErrorsBothCoordinates.flux)                    |



### 16. Classificação, Agrupamento e Inferência Estatística (`16_classification_inference` - 7 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **GMM (Gaussian Mixture Models via Expectation-Maximization)**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_GaussianMixtureModelsEM.flux)                   |
| **HMM (Treinamento de HMM via Algoritmo Baum-Welch)**                              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_HiddenMarkovModelsBaumWelch.flux)               |
| **Hierarchical Clustering — UPGMA (Agrupamento Hierárquico Filogenético)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_HierarchicalClusteringPhylogenetic.flux)        |
| **k-Means (Agrupamento por k-Medias com Centoides)**                               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_KMeansClustering.flux)                          |
| **MarkovModels (Cadeias de Markov e Matrizes de Transicao)**                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_MarkovModelsTransitions.flux)                   |
| **Support Vector Machines — SVM (Máquinas de Vetores de Suporte com SMO)**         | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_SupportVectorMachines.flux)                     |
| **Viterbi Decoding (Decodificação de Caminho Ótimo de Viterbi)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/16_classification_inference/ExampleOfNR_ViterbiDecodingHMM.flux)                        |



### 17. Integração Numérica de Equações Diferenciais Ordinárias (EDOs) (`17_differential_equations` - 8 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Adaptive Stepsize Control — Cash-Karp (Runge-Kutta Adaptativo com Controle de...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_AdaptiveStepsizeControlRungeKutta.flux)           |
| **Multistep Predictor-Corrector (Métodos Preditor-Corretor de Adams-Moulton)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_MultistepPredictorCorrectorAdams.flux)            |
| **Bulirsch-Stoer Method (Método de Alta Precisão de Bulirsch-Stoer)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_RichardsonExtrapolationBulirschStoer.flux)        |
| **CashKarp (Runge-Kutta Adaptativo de 5a Ordem)**                                  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_RungeKuttaCashKarp.flux)                          |
| **RK4 (Metodo de Runge-Kutta Classico de 4a Ordem)**                               | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_RungeKuttaRK4.flux)                               |
| **Second-Order Conservative Equations (Integrador Simplético de Störmer-Verlet)**  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_SecondOrderConservativeVerlet.flux)               |
| **Stiff Sets of Equations — Rosenbrock (Equações Rígidas pelo Método de Rosenbr...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_StiffSetsOfEquationsRosenbrock.flux)              |
| **Stochastic Simulation of Chemical Networks (Algoritmo Estocástico de Gillespi...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/17_differential_equations/ExampleOfNR_StochasticSimulationChemicalGillespie.flux)       |



### 18. Problemas de Valor de Contorno em Dois Pontos (BVPs) (`18_boundary_value_problems` - 6 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Automated Allocation of Mesh Points (Alocação Automática de Malha)**             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/18_boundary_value_problems/ExampleOfNR_AutomatedAllocationMeshPoints.flux)              |
| **Handling Internal Boundary Conditions (Tratamento de Singularidades e Contorn...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/18_boundary_value_problems/ExampleOfNR_HandlingInternalBoundarySingularities.flux)      |
| **Relaxation Methods (Método de Relaxação por Diferenças Finitas)**                | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/18_boundary_value_problems/ExampleOfNR_RelaxationMethods.flux)                          |
| **Shooting to a Fitting Point (Método do Tiro Bidirecional para Ponto de Encaix...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/18_boundary_value_problems/ExampleOfNR_ShootingToFittingPoint.flux)                     |
| **The Shooting Method (Método do Tiro com Newton-Raphson)**                        | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/18_boundary_value_problems/ExampleOfNR_TheShootingMethod.flux)                          |
| **Spheroidal Harmonics (Exemplo Prático: Harmônicos Esferoidais)**                 | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/18_boundary_value_problems/ExampleOfNR_WorkedExampleSpheroidalHarmonics.flux)           |



### 19. Equações Integrais e Teoria Inversa (`19_integral_equations` - 7 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Backus-Gilbert Method (Método Inverso de Backus-Gilbert)**                       | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_BackusGilbertMethod.flux)                             |
| **Fredholm Equations of Second Kind (Equação de Fredholm de 2ª Espécie via Nyst...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_FredholmEquationsSecondKindNystrom.flux)              |
| **Integral Equations with Singular Kernels (Equações com Núcleos Singulares)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_IntegralEquationsSingularKernels.flux)                |
| **Inverse Problems & A Priori Information (Problemas Inversos e Informação a Pr...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_InverseProblemsAPrioriInformation.flux)               |
| **Linear Regularization Methods — Tikhonov (Regularização de Tikhonov)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_LinearRegularizationMethodsTikhonov.flux)             |
| **Maximum Entropy Image Restoration (Restauração por Máxima Entropia)**            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_MaximumEntropyImageRestoration.flux)                  |
| **Volterra Equations (Equações Integrais Causais de Volterra de 2ª Espécie)**      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/19_integral_equations/ExampleOfNR_VolterraEquations.flux)                               |



### 20. Resolução Numérica de Equações Diferenciais Parciais (EDPs) (`20_partial_differential_eqs` - 7 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Diffusive Initial Value Problems — Crank-Nicolson (Método de Crank-Nicolson)**   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_DiffusiveCrankNicolson.flux)                    |
| **Flux-Conservative Initial Value Problems (Esquema de Lax-Wendroff de 2ª Ordem)** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_FluxConservativeLaxWendroff.flux)               |
| **Fourier & Cyclic Reduction for Poisson (Resolvedor Rápido de Poisson por Four...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_FourierCyclicReductionPoisson.flux)             |
| **Initial Value Problems in Multidimensions — ADI (Método ADI Bidimensional)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_InitialValueMultidimensionsADI.flux)            |
| **Multigrid Methods — V-Cycle (Método Multigrid com Ciclo V)**                     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_MultigridMethodsVCycle.flux)                    |
| **Relaxation for Boundary Value — SOR (Sobre-Relaxação Sucessiva SOR)**            | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_RelaxationBoundaryValueSOR.flux)                |
| **Spectral Methods for PDEs (Métodos Espectrais de Fourier e Chebyshev)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/20_partial_differential_eqs/ExampleOfNR_SpectralMethodsPDE.flux)                        |



### 21. Geometria Computacional (`21_computational_geometry` - 8 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Triangulation & Delaunay (Triangulação de Delaunay de Bowyer-Watson)**           | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_DelaunayTriangulationBowyerWatson.flux)           |
| **KD-Trees & Nearest-Neighbor Finding (Árvores k-d e Busca de Vizinho Mais Próx...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_KDTreesNearestNeighbor.flux)                      |
| **Lines, Line Segments & Polygons (Linhas, Segmentos e Ponto em Polígono)**        | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_LinesSegmentsPolygons.flux)                       |
| **Points and Boxes (Estruturas de Pontos, Vetores e Caixas Delimitadoras AABB)**   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_PointsAndBoxes.flux)                              |
| **Quadtrees & Octrees (Indexação Espacial Hierárquica por Quadtrees)**             | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_QuadtreesOctreesSpatialStorage.flux)              |
| **Spheres & Rotations — Quaternions (Esferas e Rotações por Quatérnios)**          | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_SpheresAndRotationsQuaternions.flux)              |
| **Triangles in 2D & 3D (Geometria de Triângulos em 2D e 3D)**                      | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_TrianglesTwoThreeDimensions.flux)                 |
| **Applications of Delaunay — Voronoi Diagram (Diagramas de Voronoi)**              | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/21_computational_geometry/ExampleOfNR_VoronoiDiagramApplications.flux)                  |



### 22. Algoritmos Discretos, Criptográficos e Menos Numéricos (`22_less_numerical` - 7 algoritmos)

| Algoritmo (Nome Científico / Descrição)                                            | Arquivo TheFlux (Caminho e Referência no Repositório)                                                                                         |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Arithmetic at Arbitrary Precision — BigInt (Aritmética de Precisão Arbitrária)** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_ArbitraryPrecisionArithmeticBigInt.flux)                  |
| **Arithmetic Coding (Codificação Aritmética de Fluxo de Dados)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_ArithmeticCoding.flux)                                    |
| **Cyclic Redundancy & Checksums — CRC32 (Verificação de Redundância Cíclica CRC...** | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_CyclicRedundancyChecksumCRC32.flux)                       |
| **Diagnosing Machine Parameters (Diagnóstico de Parâmetros de Ponto Flutuante)**   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_DiagnosingMachineParameters.flux)                         |
| **Gray Codes (Geração e Conversão de Código de Gray de N-Bits)**                   | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_GrayCodes.flux)                                           |
| **Huffman Coding & Compression (Compressão de Dados por Codificação de Huffman)**  | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_HuffmanDataCompression.flux)                              |
| **Plotting Simple Graphs (Geração de Gráficos Científicos em Terminal ASCII)**     | (file:///D:/Projetos/TheFlux/examples/NumericalRecipes/22_less_numerical/ExampleOfNR_PlottingSimpleGraphsAscii.flux)                           |



