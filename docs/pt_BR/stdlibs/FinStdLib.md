# 📚 `FinStdLib` — Matemática Financeira de Alta Precisão e Análise de Investimentos

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/FinStdLib/FinStdLib.fdsl`  
> **Modo de Importação**: `use FinStdLib` ou `use FinStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`FinStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Operações financeiras exatas utilizando ponto fixo decimal (`FinDecimal`) para anular imprecisões de ponto flutuante: juros simples e compostos, cronogramas de amortização (SAC/Price), Valor Presente Líquido (VPL), Taxa Interna de Retorno (TIR) e depreciação.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `FinStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **7 módulos de domínio** e declara **62 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `FinAmortization.fdsl` | `FinAmortizationContract` | Domínio especializado de `FinAmortization` | 4 |
| `FinComparison.fdsl` | `FinComparisonContract` | Domínio especializado de `FinComparison` | 11 |
| `FinDecimal.fdsl` | `FinDecimalContract` | Domínio especializado de `FinDecimal` | 17 |
| `FinDepreciation.fdsl` | `FinDepreciationContract` | Domínio especializado de `FinDepreciation` | 3 |
| `FinFormat.fdsl` | `FinFormatContract` | Domínio especializado de `FinFormat` | 3 |
| `FinRate.fdsl` | `FinRateContract` | Domínio especializado de `FinRate` | 12 |
| `FinTimeValueOfMoney.fdsl` | `FinTimeValueOfMoneyContract` | Domínio especializado de `FinTimeValueOfMoney` | 12 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

### Estrutura `struct (FinDecimal)`
*Declarada em: `FinStdLib.fdsl`*

```flux
struct (FinDecimal) {
      mut: .raw: int64
      mut: .scale: int64
}
```

### Estrutura `struct (AmortizationInstallment)`
*Declarada em: `FinStdLib.fdsl`*

```flux
struct (AmortizationInstallment) {
      mut: .month: int64
      mut: .payment: FinDecimal
      mut: .amortization: FinDecimal
      mut: .interest: FinDecimal
      mut: .balance: FinDecimal
}
```

### Enumeração `enum (RoundingMode)`
*Declarada em: `FinStdLib.fdsl`*

```flux
enum (RoundingMode) {
      FinHalfEven
      FinHalfUp
      FinUp
      FinDown
}
```

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `FinAmortizationContract` (`FinAmortization.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finAmortizationPrice` | `op finAmortizationPrice (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data` | `list of data` |
| `finAmortizationSac` | `op finAmortizationSac (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data` | `list of data` |
| `finAmortizationSaa` | `op finAmortizationSaa (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data` | `list of data` |
| `finAmortizationTotals` | `op finAmortizationTotals (as list of data: installments) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op finAmortizationPrice`
```flux
op finAmortizationPrice (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `annual_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `months` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAmortizationPrice` no domínio `FinAmortizationContract`.

##### `op finAmortizationSac`
```flux
op finAmortizationSac (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `annual_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `months` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAmortizationSac` no domínio `FinAmortizationContract`.

##### `op finAmortizationSaa`
```flux
op finAmortizationSaa (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `annual_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `months` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAmortizationSaa` no domínio `FinAmortizationContract`.

##### `op finAmortizationTotals`
```flux
op finAmortizationTotals (as list of data: installments) as map
```
- **Parâmetros**:
  - `installments` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAmortizationTotals` no domínio `FinAmortizationContract`.

### 4.2 Contrato `FinComparisonContract` (`FinComparison.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finEquals` | `op finEquals (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finCompare` | `op finCompare (as FinDecimal: a, as FinDecimal: b) as int64` | `int64` |
| `finGt` | `op finGt (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finGte` | `op finGte (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finLt` | `op finLt (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finLte` | `op finLte (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finIsZero` | `op finIsZero (as FinDecimal: val) as bool` | `bool` |
| `finIsPositive` | `op finIsPositive (as FinDecimal: val) as bool` | `bool` |
| `finIsNegative` | `op finIsNegative (as FinDecimal: val) as bool` | `bool` |
| `finBetween` | `op finBetween (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as bool` | `bool` |
| `finIsValidBalance` | `op finIsValidBalance (as FinDecimal: val) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op finEquals`
```flux
op finEquals (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finEquals` no domínio `FinComparisonContract`.

##### `op finCompare`
```flux
op finCompare (as FinDecimal: a, as FinDecimal: b) as int64
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finCompare` no domínio `FinComparisonContract`.

##### `op finGt`
```flux
op finGt (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finGt` no domínio `FinComparisonContract`.

##### `op finGte`
```flux
op finGte (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finGte` no domínio `FinComparisonContract`.

##### `op finLt`
```flux
op finLt (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finLt` no domínio `FinComparisonContract`.

##### `op finLte`
```flux
op finLte (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finLte` no domínio `FinComparisonContract`.

##### `op finIsZero`
```flux
op finIsZero (as FinDecimal: val) as bool
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finIsZero` no domínio `FinComparisonContract`.

##### `op finIsPositive`
```flux
op finIsPositive (as FinDecimal: val) as bool
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finIsPositive` no domínio `FinComparisonContract`.

##### `op finIsNegative`
```flux
op finIsNegative (as FinDecimal: val) as bool
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finIsNegative` no domínio `FinComparisonContract`.

##### `op finBetween`
```flux
op finBetween (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as bool
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finBetween` no domínio `FinComparisonContract`.

##### `op finIsValidBalance`
```flux
op finIsValidBalance (as FinDecimal: val) as bool
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finIsValidBalance` no domínio `FinComparisonContract`.

### 4.3 Contrato `FinDecimalContract` (`FinDecimal.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finCreateDecimal` | `op finCreateDecimal (as string: value) as FinDecimal` | `FinDecimal` |
| `finFromInt` | `op finFromInt (as int64: value) as FinDecimal` | `FinDecimal` |
| `finFromFloat` | `op finFromFloat (as float64: value) as FinDecimal` | `FinDecimal` |
| `finDecimalToString` | `op finDecimalToString (as FinDecimal: val) as string` | `string` |
| `finDecimalToFloat` | `op finDecimalToFloat (as FinDecimal: val) as float64` | `float64` |
| `finAdd` | `op finAdd (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finSubtract` | `op finSubtract (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finMultiply` | `op finMultiply (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finDivide` | `op finDivide (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finRound` | `op finRound (as FinDecimal: val, as int64: decimals, as RoundingMode: mode) as FinDecimal` | `FinDecimal` |
| `finAbs` | `op finAbs (as FinDecimal: val) as FinDecimal` | `FinDecimal` |
| `finNegate` | `op finNegate (as FinDecimal: val) as FinDecimal` | `FinDecimal` |
| `finMin` | `op finMin (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finMax` | `op finMax (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finClamp` | `op finClamp (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as FinDecimal` | `FinDecimal` |
| `finSplit` | `op finSplit (as FinDecimal: amount, as int64: parts) as list of data` | `list of data` |
| `finAllocate` | `op finAllocate (as FinDecimal: amount, as list of data: weights) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op finCreateDecimal`
```flux
op finCreateDecimal (as string: value) as FinDecimal
```
- **Parâmetros**:
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finCreateDecimal` no domínio `FinDecimalContract`.

##### `op finFromInt`
```flux
op finFromInt (as int64: value) as FinDecimal
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finFromInt` no domínio `FinDecimalContract`.

##### `op finFromFloat`
```flux
op finFromFloat (as float64: value) as FinDecimal
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finFromFloat` no domínio `FinDecimalContract`.

##### `op finDecimalToString`
```flux
op finDecimalToString (as FinDecimal: val) as string
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDecimalToString` no domínio `FinDecimalContract`.

##### `op finDecimalToFloat`
```flux
op finDecimalToFloat (as FinDecimal: val) as float64
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDecimalToFloat` no domínio `FinDecimalContract`.

##### `op finAdd`
```flux
op finAdd (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAdd` no domínio `FinDecimalContract`.

##### `op finSubtract`
```flux
op finSubtract (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finSubtract` no domínio `FinDecimalContract`.

##### `op finMultiply`
```flux
op finMultiply (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finMultiply` no domínio `FinDecimalContract`.

##### `op finDivide`
```flux
op finDivide (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ⚠️ Emite `fail` com status `"divisao por zero"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDivide` no domínio `FinDecimalContract`.

##### `op finRound`
```flux
op finRound (as FinDecimal: val, as int64: decimals, as RoundingMode: mode) as FinDecimal
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `decimals` (`int64`): Parâmetro de entrada para processamento da operação.
  - `mode` (`RoundingMode`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finRound` no domínio `FinDecimalContract`.

##### `op finAbs`
```flux
op finAbs (as FinDecimal: val) as FinDecimal
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAbs` no domínio `FinDecimalContract`.

##### `op finNegate`
```flux
op finNegate (as FinDecimal: val) as FinDecimal
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finNegate` no domínio `FinDecimalContract`.

##### `op finMin`
```flux
op finMin (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finMin` no domínio `FinDecimalContract`.

##### `op finMax`
```flux
op finMax (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parâmetros**:
  - `a` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `b` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finMax` no domínio `FinDecimalContract`.

##### `op finClamp`
```flux
op finClamp (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as FinDecimal
```
- **Parâmetros**:
  - `val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finClamp` no domínio `FinDecimalContract`.

##### `op finSplit`
```flux
op finSplit (as FinDecimal: amount, as int64: parts) as list of data
```
- **Parâmetros**:
  - `amount` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `parts` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ⚠️ Emite `fail` com status `"partes devem ser positivas"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finSplit` no domínio `FinDecimalContract`.

##### `op finAllocate`
```flux
op finAllocate (as FinDecimal: amount, as list of data: weights) as list of data
```
- **Parâmetros**:
  - `amount` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `weights` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ⚠️ Emite `fail` com status `"pesos devem somar mais que zero"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAllocate` no domínio `FinDecimalContract`.

### 4.4 Contrato `FinDepreciationContract` (`FinDepreciation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finDepreciationLinear` | `op finDepreciationLinear (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years) as FinDecimal` | `FinDecimal` |
| `finDepreciationSyd` | `op finDepreciationSyd (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal` | `FinDecimal` |
| `finDepreciationDdb` | `op finDepreciationDdb (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal` | `FinDecimal` |

#### Ficha Técnica das Operações:

##### `op finDepreciationLinear`
```flux
op finDepreciationLinear (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years) as FinDecimal
```
- **Parâmetros**:
  - `cost` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `salvage` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `life_years` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDepreciationLinear` no domínio `FinDepreciationContract`.

##### `op finDepreciationSyd`
```flux
op finDepreciationSyd (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal
```
- **Parâmetros**:
  - `cost` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `salvage` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `life_years` (`int64`): Parâmetro de entrada para processamento da operação.
  - `period` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDepreciationSyd` no domínio `FinDepreciationContract`.

##### `op finDepreciationDdb`
```flux
op finDepreciationDdb (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal
```
- **Parâmetros**:
  - `cost` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `salvage` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `life_years` (`int64`): Parâmetro de entrada para processamento da operação.
  - `period` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDepreciationDdb` no domínio `FinDepreciationContract`.

### 4.5 Contrato `FinFormatContract` (`FinFormat.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finFormatCurrency` | `op finFormatCurrency (as FinDecimal: value, as string: locale) as string` | `string` |
| `finFormatPercent` | `op finFormatPercent (as float64: rate, as int64: decimals) as string` | `string` |
| `finParseCurrency` | `op finParseCurrency (as string: text) as FinDecimal` | `FinDecimal` |

#### Ficha Técnica das Operações:

##### `op finFormatCurrency`
```flux
op finFormatCurrency (as FinDecimal: value, as string: locale) as string
```
- **Parâmetros**:
  - `value` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `locale` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finFormatCurrency` no domínio `FinFormatContract`.

##### `op finFormatPercent`
```flux
op finFormatPercent (as float64: rate, as int64: decimals) as string
```
- **Parâmetros**:
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `decimals` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finFormatPercent` no domínio `FinFormatContract`.

##### `op finParseCurrency`
```flux
op finParseCurrency (as string: text) as FinDecimal
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finParseCurrency` no domínio `FinFormatContract`.

### 4.6 Contrato `FinRateContract` (`FinRate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finEffectiveRate` | `op finEffectiveRate (as float64: nominal_rate, as int64: compounding_periods) as float64` | `float64` |
| `finNominalRate` | `op finNominalRate (as float64: effective_rate, as int64: compounding_periods) as float64` | `float64` |
| `finConvertRate` | `op finConvertRate (as float64: rate, as int64: from_periods, as int64: to_periods) as float64` | `float64` |
| `finRateEquivalent` | `op finRateEquivalent (as float64: rate, as float64: target_period, as float64: base_period) as float64` | `float64` |
| `finMonthlyToDailyRate` | `op finMonthlyToDailyRate (as float64: monthly_rate, as int64: days_in_month) as float64` | `float64` |
| `finMonthlyToAnnualRate` | `op finMonthlyToAnnualRate (as float64: monthly_rate) as float64` | `float64` |
| `finAnnualToDailyRate` | `op finAnnualToDailyRate (as float64: annual_rate, as int64: days_in_year) as float64` | `float64` |
| `finAnnualToMonthlyRate` | `op finAnnualToMonthlyRate (as float64: annual_rate) as float64` | `float64` |
| `finDailyToMonthlyRate` | `op finDailyToMonthlyRate (as float64: daily_rate, as int64: days_in_month) as float64` | `float64` |
| `finDailyToAnnualRate` | `op finDailyToAnnualRate (as float64: daily_rate, as int64: days_in_year) as float64` | `float64` |
| `finRealRate` | `op finRealRate (as float64: nominal_rate, as float64: inflation_rate) as float64` | `float64` |
| `finContinuousCompounding` | `op finContinuousCompounding (as FinDecimal: principal, as float64: rate, as float64: periods) as FinDecimal` | `FinDecimal` |

#### Ficha Técnica das Operações:

##### `op finEffectiveRate`
```flux
op finEffectiveRate (as float64: nominal_rate, as int64: compounding_periods) as float64
```
- **Parâmetros**:
  - `nominal_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `compounding_periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finEffectiveRate` no domínio `FinRateContract`.

##### `op finNominalRate`
```flux
op finNominalRate (as float64: effective_rate, as int64: compounding_periods) as float64
```
- **Parâmetros**:
  - `effective_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `compounding_periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finNominalRate` no domínio `FinRateContract`.

##### `op finConvertRate`
```flux
op finConvertRate (as float64: rate, as int64: from_periods, as int64: to_periods) as float64
```
- **Parâmetros**:
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `from_periods` (`int64`): Parâmetro de entrada para processamento da operação.
  - `to_periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finConvertRate` no domínio `FinRateContract`.

##### `op finRateEquivalent`
```flux
op finRateEquivalent (as float64: rate, as float64: target_period, as float64: base_period) as float64
```
- **Parâmetros**:
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `target_period` (`float64`): Parâmetro de entrada para processamento da operação.
  - `base_period` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"Periodo base invalido ou taxa menor que -100%"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finRateEquivalent` no domínio `FinRateContract`.

##### `op finMonthlyToDailyRate`
```flux
op finMonthlyToDailyRate (as float64: monthly_rate, as int64: days_in_month) as float64
```
- **Parâmetros**:
  - `monthly_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `days_in_month` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finMonthlyToDailyRate` no domínio `FinRateContract`.

##### `op finMonthlyToAnnualRate`
```flux
op finMonthlyToAnnualRate (as float64: monthly_rate) as float64
```
- **Parâmetros**:
  - `monthly_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finMonthlyToAnnualRate` no domínio `FinRateContract`.

##### `op finAnnualToDailyRate`
```flux
op finAnnualToDailyRate (as float64: annual_rate, as int64: days_in_year) as float64
```
- **Parâmetros**:
  - `annual_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `days_in_year` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAnnualToDailyRate` no domínio `FinRateContract`.

##### `op finAnnualToMonthlyRate`
```flux
op finAnnualToMonthlyRate (as float64: annual_rate) as float64
```
- **Parâmetros**:
  - `annual_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAnnualToMonthlyRate` no domínio `FinRateContract`.

##### `op finDailyToMonthlyRate`
```flux
op finDailyToMonthlyRate (as float64: daily_rate, as int64: days_in_month) as float64
```
- **Parâmetros**:
  - `daily_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `days_in_month` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDailyToMonthlyRate` no domínio `FinRateContract`.

##### `op finDailyToAnnualRate`
```flux
op finDailyToAnnualRate (as float64: daily_rate, as int64: days_in_year) as float64
```
- **Parâmetros**:
  - `daily_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `days_in_year` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDailyToAnnualRate` no domínio `FinRateContract`.

##### `op finRealRate`
```flux
op finRealRate (as float64: nominal_rate, as float64: inflation_rate) as float64
```
- **Parâmetros**:
  - `nominal_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `inflation_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finRealRate` no domínio `FinRateContract`.

##### `op finContinuousCompounding`
```flux
op finContinuousCompounding (as FinDecimal: principal, as float64: rate, as float64: periods) as FinDecimal
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finContinuousCompounding` no domínio `FinRateContract`.

### 4.7 Contrato `FinTimeValueOfMoneyContract` (`FinTimeValueOfMoney.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `finSimpleInterest` | `op finSimpleInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finCompoundInterest` | `op finCompoundInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finPresentValue` | `op finPresentValue (as FinDecimal: future_value, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finFutureValue` | `op finFutureValue (as FinDecimal: present_value, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finAnnuityPayment` | `op finAnnuityPayment (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finFutureValueOfAnnuity` | `op finFutureValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finPresentValueOfAnnuity` | `op finPresentValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finNetPresentValue` | `op finNetPresentValue (as float64: discount_rate, as list of data: cash_flows) as float64` | `float64` |
| `finInternalRateOfReturn` | `op finInternalRateOfReturn (as list of data: cash_flows) as float64` | `float64` |
| `finPaybackPeriod` | `op finPaybackPeriod (as FinDecimal: initial_investment, as list of data: cash_flows) as float64` | `float64` |
| `finDiscountedPayback` | `op finDiscountedPayback (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64` | `float64` |
| `finProfitabilityIndex` | `op finProfitabilityIndex (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op finSimpleInterest`
```flux
op finSimpleInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finSimpleInterest` no domínio `FinTimeValueOfMoneyContract`.

##### `op finCompoundInterest`
```flux
op finCompoundInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finCompoundInterest` no domínio `FinTimeValueOfMoneyContract`.

##### `op finPresentValue`
```flux
op finPresentValue (as FinDecimal: future_value, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `future_value` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finPresentValue` no domínio `FinTimeValueOfMoneyContract`.

##### `op finFutureValue`
```flux
op finFutureValue (as FinDecimal: present_value, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `present_value` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finFutureValue` no domínio `FinTimeValueOfMoneyContract`.

##### `op finAnnuityPayment`
```flux
op finAnnuityPayment (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `principal` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finAnnuityPayment` no domínio `FinTimeValueOfMoneyContract`.

##### `op finFutureValueOfAnnuity`
```flux
op finFutureValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `payment` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finFutureValueOfAnnuity` no domínio `FinTimeValueOfMoneyContract`.

##### `op finPresentValueOfAnnuity`
```flux
op finPresentValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal
```
- **Parâmetros**:
  - `payment` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `periods` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `FinDecimal`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finPresentValueOfAnnuity` no domínio `FinTimeValueOfMoneyContract`.

##### `op finNetPresentValue`
```flux
op finNetPresentValue (as float64: discount_rate, as list of data: cash_flows) as float64
```
- **Parâmetros**:
  - `discount_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cash_flows` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finNetPresentValue` no domínio `FinTimeValueOfMoneyContract`.

##### `op finInternalRateOfReturn`
```flux
op finInternalRateOfReturn (as list of data: cash_flows) as float64
```
- **Parâmetros**:
  - `cash_flows` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finInternalRateOfReturn` no domínio `FinTimeValueOfMoneyContract`.

##### `op finPaybackPeriod`
```flux
op finPaybackPeriod (as FinDecimal: initial_investment, as list of data: cash_flows) as float64
```
- **Parâmetros**:
  - `initial_investment` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `cash_flows` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finPaybackPeriod` no domínio `FinTimeValueOfMoneyContract`.

##### `op finDiscountedPayback`
```flux
op finDiscountedPayback (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64
```
- **Parâmetros**:
  - `initial_investment` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `discount_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cash_flows` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finDiscountedPayback` no domínio `FinTimeValueOfMoneyContract`.

##### `op finProfitabilityIndex`
```flux
op finProfitabilityIndex (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64
```
- **Parâmetros**:
  - `initial_investment` (`FinDecimal`): Parâmetro de entrada para processamento da operação.
  - `discount_rate` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cash_flows` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `finProfitabilityIndex` no domínio `FinTimeValueOfMoneyContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da FinStdLib
use FinStdLib

program (ExemploFinStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: FinStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = FinStdLib::finCompoundInterest(1000.0, 0.05, 12)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
