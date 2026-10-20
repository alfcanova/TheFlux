# 📊 Tabela de Conformidade Multi-Backend: Numerical Recipes v3 (Self-Hosted Compiler)

> **Compilador**: TheFlux Self-Hosted Compiler v1.0.0
> **Suíte**: `examples/NumericalRecipes/` (22 capítulos clássicos)
> **Backends**: `in` (AST interpretado), `vm` (FVM Bytecode), `vmr` (FVM Reloaded), `llvm` (LLVM nativo), `wat` (WebAssembly Text), `wasm` (WebAssembly Binário)

### Tabela de conformidade — Capítulo 01: Preliminares, Precisão de Máquina & Análise de Erro (01_preliminaries)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_ErrorAccuracyStability.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MemoryModelSyntax.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_NumericalConventions.flux                                         |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ScientificTypesAbstraction.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_VectorMatrixObjects.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 02: Resolução de Sistemas de Equações Algébricas Lineares (02_linear_algebra)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_Bandec.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_CholeskyDecomposition.flux                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GaussianEliminationBacksub.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GaussJordanElimination.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_IterativeImprovement.flux                                         |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LUDecomposition.flux                                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MatrixInversionComplexity.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QRDecomposition.flux                                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SingularValueDecomposition.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SparseLinearSystems.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Toeplz.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Tridag.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Vander.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 03: Interpolação e Extrapolação (03_interpolation)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_BaryRat_interp.flux                                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_CoefficientsInterpolatingPolynomial.flux                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LaplaceInterpolation.flux                                         |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MultidimensionalGridInterpolation.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PolynomialInterpolationNeville.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Rat_interp.flux                                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ScatteredDataInterpolationShepard.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SearchingOrderedTable.flux                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Spline2D_interp.flux                                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Spline_interp.flux                                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 04: Integração Numérica de Funções (04_integration)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_AdaptiveQuadrature.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ClassicalEquallySpacedFormulas.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ElementaryIntegrationAlgorithms.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Gauher.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Gaulag.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Gauleg.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ImproperIntegrals.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MultidimensionalIntegrals.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QuadratureVariableTransformation.flux                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RombergIntegration.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 05: Avaliação de Funções, Séries e Frações Contínuas (05_function_evaluation)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_ChebyshevApproximation.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ChebyshevDerivativesIntegrals.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ClenshawRecurrenceFormula.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ComplexArithmetic.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_EconomizationPowerSeries.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_EvaluationContinuedFractions.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FunctionEvaluationPathIntegration.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_NumericalDerivativesRidders.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PadeApproximants.flux                                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PolynomialFromChebyshevCoefficients.flux                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PolynomialsRationalFunctions.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QuadraticCubicEquations.flux                                      |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RationalChebyshevApproximation.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SeriesConvergenceAcceleration.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 06: Funções Especiais da Física Matemática (06_special_functions)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_BesselFractionalAirySpherical.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_BesselIntegerOrder.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DawsonsIntegral.flux                                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_EllipticIntegralsJacobian.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ExponentialIntegrals.flux                                         |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FresnelCosineSineIntegrals.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GammaBetaFactorials.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GeneralizedFermiDiracIntegrals.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HypergeometricFunctions.flux                                      |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_IncompleteBetaFunction.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_IncompleteGammaErrorFunction.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_InverseXLogX.flux                                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SphericalHarmonics.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_StatisticalDistributionFunctions.flux                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 07: Geração de Números Aleatórios e Métodos de Monte Carlo (07_random_numbers)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_AdaptiveMonteCarloVegas.flux                                      |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DeviatesOtherDistributions.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HashingLargeArray.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HashTablesMemories.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LinearFeedbackShiftRegisters.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MultivariateNormalDeviates.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QuasiRandomSobolSequences.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Ran.flux                                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Ranfib.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Ranq1.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SimpleMonteCarloIntegration.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 08: Algoritmos de Ordenação e Seleção Estatística (08_sorting_selection)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_EquivalenceClasses.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HeapSort.flux                                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_IndexingAndRanking.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Piksrt.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QuickSort.flux                                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Select.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Selip.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Shell.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 09: Localização de Raízes e Sistemas de Equações Não-Lineares (09_root_finding)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_GloballyConvergentBroyden.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_NewtonRaphsonNonlinearSystems.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RootsOfPolynomialsLaguerre.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Rtbis.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Rtnewt.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Rtsafe.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SecantFalsePosition.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_VanWijngaardenDekkerBrent.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Zbrak.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 10: Minimização e Maximização de Funções (10_minimization)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_BracketingMinimum.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Brent.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ConjugateGradientFletcherReeves.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Dbrent.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DirectionSetPowellsMethod.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DownhillSimplexNelderMead.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DynamicProgrammingKnapsack.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GoldenSectionSearch.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_InteriorPointLinearProgramming.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LinearProgrammingSimplex.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LineMethodsMultidimensions.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_OneDimensionalSearchDerivatives.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QuasiNewtonBFGS.flux                                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SimulatedAnnealingOptimization.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 11: Sistemas de Autovalores e Autovetores (11_eigensystems)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_EigenvaluesTridiagonalMatrix.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HermitianMatricesEigenvalues.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_InverseIterationFindingEigenvectors.flux                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_JacobiTransformationsSymmetric.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QRAlgorithmRealHessenberg.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RealNonsymmetricMatricesHessenberg.flux                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RealSymmetricMatricesProperties.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ReductionTridiagonalHouseholderGivens.flux                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 12: Transformada Rápida de Fourier — FFT (12_fast_fourier_transform)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_Cosft.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DiscreteFourierTransformSampled.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ExternalStorageMemoryLocalFFT.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FastFourierTransformCooleyTukey.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FFTOfRealFunctions.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FFTTwoOrMoreDimensions.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RealDataFFT2D3D.flux                                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Sinft.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_Twofft.flux                                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 13: Aplicações Espectrais e Processamento de Sinais por Fourier (13_fourier_spectral)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_ComputingFourierIntegralsFFT.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ConvolutionDeconvolutionFFT.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_CorrelationAutocorrelationFFT.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DigitalFilteringTimeDomain.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LinearPredictionCodingLPC.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MaximumEntropyMethodBurg.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_NumericalSamplingTheorem.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_OptimalWienerFilteringFFT.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PowerSpectrumEstimationFFT.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SpectralAnalysisUnevenlySampledLomb.flux                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_WaveletTransforms.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 14: Descrição Estatística de Dados (14_statistical_description)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_ContingencyTableAnalysis.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DistributionDifferenceKS.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FTest.flux                                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_InformationTheoreticProperties.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LinearCorrelationPearson.flux                                     |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MomentsMeanVarianceSkewKurtosis.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_NonparametricRankCorrelation.flux                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SavitzkyGolaySmoothingFilters.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_StudentTTest.flux                                                 |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_TwoDimensionalDistributionsDifference.flux                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 15: Modelagem, Ajuste de Parâmetros e Teoria da Estimação (15_modeling_data)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_ConfidenceLimitsModelParameters.flux                              |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FittingStraightLine.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GaussianProcessRegression.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GeneralLinearLeastSquares.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LeastSquaresMaximumLikelihood.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MarkovChainMonteCarlo.flux                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_NonlinearModelsLevenbergMarquardt.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RobustEstimationHuber.flux                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_StraightLineErrorsBothCoordinates.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 16: Classificação, Agrupamento e Inferência Estatística (16_classification_inference)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_GaussianMixtureModelsEM.flux                                      |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HiddenMarkovModelsBaumWelch.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HierarchicalClusteringPhylogenetic.flux                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_KMeansClustering.flux                                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MarkovModelsTransitions.flux                                      |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SupportVectorMachines.flux                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ViterbiDecodingHMM.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 17: Integração Numérica de EDOs (17_differential_equations)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_AdaptiveStepsizeControlRungeKutta.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MultistepPredictorCorrectorAdams.flux                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RichardsonExtrapolationBulirschStoer.flux                         |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RungeKuttaCashKarp.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RungeKuttaRK4.flux                                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SecondOrderConservativeVerlet.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_StiffSetsOfEquationsRosenbrock.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_StochasticSimulationChemicalGillespie.flux                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 18: Problemas de Valor de Contorno em Dois Pontos — BVPs (18_boundary_value_problems)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_AutomatedAllocationMeshPoints.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HandlingInternalBoundarySingularities.flux                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RelaxationMethods.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ShootingToFittingPoint.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_TheShootingMethod.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_WorkedExampleSpheroidalHarmonics.flux                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 19: Equações Integrais e Teoria Inversa (19_integral_equations)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_BackusGilbertMethod.flux                                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FredholmEquationsSecondKindNystrom.flux                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_IntegralEquationsSingularKernels.flux                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_InverseProblemsAPrioriInformation.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LinearRegularizationMethodsTikhonov.flux                          |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MaximumEntropyImageRestoration.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_VolterraEquations.flux                                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 20: Resolução Numérica de EDPs (20_partial_differential_eqs)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_DiffusiveCrankNicolson.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FluxConservativeLaxWendroff.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_FourierCyclicReductionPoisson.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_InitialValueMultidimensionsADI.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_MultigridMethodsVCycle.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_RelaxationBoundaryValueSOR.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SpectralMethodsPDE.flux                                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 21: Geometria Computacional (21_computational_geometry)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_DelaunayTriangulationBowyerWatson.flux                            |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_KDTreesNearestNeighbor.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_LinesSegmentsPolygons.flux                                        |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PointsAndBoxes.flux                                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_QuadtreesOctreesSpatialStorage.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_SpheresAndRotationsQuaternions.flux                               |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_TrianglesTwoThreeDimensions.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_VoronoiDiagramApplications.flux                                   |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



### Tabela de conformidade — Capítulo 22: Algoritmos Discretos, Criptográficos e Menos Numéricos (22_less_numerical)

| arquivo                                                                       |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |
| ----------------------------------------------------------------------------- | ----- | ---- | ---- | ---- | ---- | ----- | ------ |
| ExampleOfNR_ArbitraryPrecisionArithmeticBigInt.flux                           |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_ArithmeticCoding.flux                                             |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_CyclicRedundancyChecksumCRC32.flux                                |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_DiagnosingMachineParameters.flux                                  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_GrayCodes.flux                                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_HuffmanDataCompression.flux                                       |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |
| ExampleOfNR_PlottingSimpleGraphsAscii.flux                                    |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |  ✅  |   ✅   |



## 📈 Sumário Consolidado de Backends

-   IN : ✅  205 of  205 — ✅
-   VM : ✅  205 of  205 — ✅
-  VMR : ✅  205 of  205 — ✅
- LLVM : ✅  205 of  205 — ✅
-  WAT : ✅  205 of  205 — ✅
- WASM : ✅  205 of  205 — ✅
-  ALL : ✅  1230 of  1230 — ✅



### Regressão:

Nenhuma regressão detectada.
