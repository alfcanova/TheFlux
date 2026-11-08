# 📚 `DateTimeStdLib` — Manipulação de Datas, Horários, Fusos e Relógios Monotônicos

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/DateTimeStdLib/DateTimeStdLib.fdsl`  
> **Modo de Importação**: `use DateTimeStdLib` ou `use DateTimeStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`DateTimeStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Gerenciamento completo de datas de calendário, horas de relógio, carimbos de época UTC/Unix, conversões de fusos horários IANA, formatação e parsing estritos no padrão ISO 8601 e cronometragem de alta precisão via temporizadores monotônicos.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `DateTimeStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **6 módulos de domínio** e declara **68 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `DateTimeCompare.fdsl` | `DateTimeCompareContract` | Domínio especializado de `DateTimeCompare` | 4 |
| `DateTimeDate.fdsl` | `DateTimeDateContract` | Domínio especializado de `DateTimeDate` | 19 |
| `DateTimeFormat.fdsl` | `DateTimeFormatContract` | Domínio especializado de `DateTimeFormat` | 10 |
| `DateTimeMonotonic.fdsl` | `DateTimeMonotonicContract` | Domínio especializado de `DateTimeMonotonic` | 2 |
| `DateTimeTime.fdsl` | `DateTimeTimeContract` | Domínio especializado de `DateTimeTime` | 26 |
| `DateTimeTimeZone.fdsl` | `DateTimeTimeZoneContract` | Domínio especializado de `DateTimeTimeZone` | 7 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `DateTimeStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `DateTimeCompareContract` (`DateTimeCompare.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dateTimeSameInstant` | `op dateTimeSameInstant (as datetime: left, as datetime: right) as bool` | `bool` |
| `dateTimeIsBefore` | `op dateTimeIsBefore (as datetime: left, as datetime: right) as bool` | `bool` |
| `dateTimeIsAfter` | `op dateTimeIsAfter (as datetime: left, as datetime: right) as bool` | `bool` |
| `dateTimeCompare` | `op dateTimeCompare (as datetime: left, as datetime: right) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op dateTimeSameInstant`
```flux
op dateTimeSameInstant (as datetime: left, as datetime: right) as bool
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSameInstant` no domínio `DateTimeCompareContract`.

##### `op dateTimeIsBefore`
```flux
op dateTimeIsBefore (as datetime: left, as datetime: right) as bool
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeIsBefore` no domínio `DateTimeCompareContract`.

##### `op dateTimeIsAfter`
```flux
op dateTimeIsAfter (as datetime: left, as datetime: right) as bool
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeIsAfter` no domínio `DateTimeCompareContract`.

##### `op dateTimeCompare`
```flux
op dateTimeCompare (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeCompare` no domínio `DateTimeCompareContract`.

### 4.2 Contrato `DateTimeDateContract` (`DateTimeDate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dateTimeCreateDate` | `op dateTimeCreateDate (as int64: year_value, as int64: month_value, as int64: day_value) as datetime` | `datetime` |
| `dateTimeYear` | `op dateTimeYear (as datetime: value) as int64` | `int64` |
| `dateTimeMonth` | `op dateTimeMonth (as datetime: value) as int64` | `int64` |
| `dateTimeDay` | `op dateTimeDay (as datetime: value) as int64` | `int64` |
| `dateTimeWeekday` | `op dateTimeWeekday (as datetime: value) as int64` | `int64` |
| `dateTimeDayOfYear` | `op dateTimeDayOfYear (as datetime: value) as int64` | `int64` |
| `dateTimeDaysInMonth` | `op dateTimeDaysInMonth (as datetime: value) as int64` | `int64` |
| `dateTimeQuarter` | `op dateTimeQuarter (as datetime: value) as int64` | `int64` |
| `dateTimeIsLeapYear` | `op dateTimeIsLeapYear (as datetime: value) as bool` | `bool` |
| `dateTimeIsWeekend` | `op dateTimeIsWeekend (as datetime: value) as bool` | `bool` |
| `dateTimeAddDays` | `op dateTimeAddDays (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractDays` | `op dateTimeSubtractDays (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddMonths` | `op dateTimeAddMonths (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractMonths` | `op dateTimeSubtractMonths (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddYears` | `op dateTimeAddYears (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractYears` | `op dateTimeSubtractYears (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeDaysBetween` | `op dateTimeDaysBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeMonthsBetween` | `op dateTimeMonthsBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeYearsBetween` | `op dateTimeYearsBetween (as datetime: left, as datetime: right) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op dateTimeCreateDate`
```flux
op dateTimeCreateDate (as int64: year_value, as int64: month_value, as int64: day_value) as datetime
```
- **Parâmetros**:
  - `year_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `month_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `day_value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeCreateDate` no domínio `DateTimeDateContract`.

##### `op dateTimeYear`
```flux
op dateTimeYear (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeYear` no domínio `DateTimeDateContract`.

##### `op dateTimeMonth`
```flux
op dateTimeMonth (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMonth` no domínio `DateTimeDateContract`.

##### `op dateTimeDay`
```flux
op dateTimeDay (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeDay` no domínio `DateTimeDateContract`.

##### `op dateTimeWeekday`
```flux
op dateTimeWeekday (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeWeekday` no domínio `DateTimeDateContract`.

##### `op dateTimeDayOfYear`
```flux
op dateTimeDayOfYear (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeDayOfYear` no domínio `DateTimeDateContract`.

##### `op dateTimeDaysInMonth`
```flux
op dateTimeDaysInMonth (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeDaysInMonth` no domínio `DateTimeDateContract`.

##### `op dateTimeQuarter`
```flux
op dateTimeQuarter (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeQuarter` no domínio `DateTimeDateContract`.

##### `op dateTimeIsLeapYear`
```flux
op dateTimeIsLeapYear (as datetime: value) as bool
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeIsLeapYear` no domínio `DateTimeDateContract`.

##### `op dateTimeIsWeekend`
```flux
op dateTimeIsWeekend (as datetime: value) as bool
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeIsWeekend` no domínio `DateTimeDateContract`.

##### `op dateTimeAddDays`
```flux
op dateTimeAddDays (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddDays` no domínio `DateTimeDateContract`.

##### `op dateTimeSubtractDays`
```flux
op dateTimeSubtractDays (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractDays` no domínio `DateTimeDateContract`.

##### `op dateTimeAddMonths`
```flux
op dateTimeAddMonths (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddMonths` no domínio `DateTimeDateContract`.

##### `op dateTimeSubtractMonths`
```flux
op dateTimeSubtractMonths (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractMonths` no domínio `DateTimeDateContract`.

##### `op dateTimeAddYears`
```flux
op dateTimeAddYears (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddYears` no domínio `DateTimeDateContract`.

##### `op dateTimeSubtractYears`
```flux
op dateTimeSubtractYears (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractYears` no domínio `DateTimeDateContract`.

##### `op dateTimeDaysBetween`
```flux
op dateTimeDaysBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeDaysBetween` no domínio `DateTimeDateContract`.

##### `op dateTimeMonthsBetween`
```flux
op dateTimeMonthsBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMonthsBetween` no domínio `DateTimeDateContract`.

##### `op dateTimeYearsBetween`
```flux
op dateTimeYearsBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeYearsBetween` no domínio `DateTimeDateContract`.

### 4.3 Contrato `DateTimeFormatContract` (`DateTimeFormat.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dateTimeEpoch` | `op dateTimeEpoch () as datetime` | `datetime` |
| `dateTimeNow` | `op dateTimeNow () as datetime` | `datetime` |
| `dateTimeToday` | `op dateTimeToday () as datetime` | `datetime` |
| `dateTimeTime` | `op dateTimeTime () as datetime` | `datetime` |
| `dateTimeNowFormatted` | `op dateTimeNowFormatted () as string` | `string` |
| `dateTimeFormatDuration` | `op dateTimeFormatDuration (as int64: duration_ns) as string` | `string` |
| `dateTimeParseIso` | `op dateTimeParseIso (as string: text) as datetime` | `datetime` |
| `dateTimeToIso` | `op dateTimeToIso (as datetime: value) as string` | `string` |
| `dateTimeToString` | `op dateTimeToString (as datetime: value) as string` | `string` |
| `dateTimeFormat` | `op dateTimeFormat (as datetime: value, as string: pattern) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op dateTimeEpoch`
```flux
op dateTimeEpoch () as datetime
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeEpoch` no domínio `DateTimeFormatContract`.

##### `op dateTimeNow`
```flux
op dateTimeNow () as datetime
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeNow` no domínio `DateTimeFormatContract`.

##### `op dateTimeToday`
```flux
op dateTimeToday () as datetime
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeToday` no domínio `DateTimeFormatContract`.

##### `op dateTimeTime`
```flux
op dateTimeTime () as datetime
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeTime` no domínio `DateTimeFormatContract`.

##### `op dateTimeNowFormatted`
```flux
op dateTimeNowFormatted () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeNowFormatted` no domínio `DateTimeFormatContract`.

##### `op dateTimeFormatDuration`
```flux
op dateTimeFormatDuration (as int64: duration_ns) as string
```
- **Parâmetros**:
  - `duration_ns` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeFormatDuration` no domínio `DateTimeFormatContract`.

##### `op dateTimeParseIso`
```flux
op dateTimeParseIso (as string: text) as datetime
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeParseIso` no domínio `DateTimeFormatContract`.

##### `op dateTimeToIso`
```flux
op dateTimeToIso (as datetime: value) as string
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeToIso` no domínio `DateTimeFormatContract`.

##### `op dateTimeToString`
```flux
op dateTimeToString (as datetime: value) as string
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeToString` no domínio `DateTimeFormatContract`.

##### `op dateTimeFormat`
```flux
op dateTimeFormat (as datetime: value, as string: pattern) as string
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `pattern` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeFormat` no domínio `DateTimeFormatContract`.

### 4.4 Contrato `DateTimeMonotonicContract` (`DateTimeMonotonic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dateTimeMonotonicNow` | `op dateTimeMonotonicNow () as int64` | `int64` |
| `dateTimeMonotonicElapsed` | `op dateTimeMonotonicElapsed (as int64: start_time_ns) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op dateTimeMonotonicNow`
```flux
op dateTimeMonotonicNow () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMonotonicNow` no domínio `DateTimeMonotonicContract`.

##### `op dateTimeMonotonicElapsed`
```flux
op dateTimeMonotonicElapsed (as int64: start_time_ns) as int64
```
- **Parâmetros**:
  - `start_time_ns` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMonotonicElapsed` no domínio `DateTimeMonotonicContract`.

### 4.5 Contrato `DateTimeTimeContract` (`DateTimeTime.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dateTimeCreateTime` | `op dateTimeCreateTime (as int64: hour_value, as int64: minute_value, as int64: second_value) as datetime` | `datetime` |
| `dateTimeCreateTimeFull` | `op dateTimeCreateTimeFull (as int64: hour_value, as int64: minute_value, as int64: second_value, as int64: millisecond_value, as int64: microsecond_value, as int64: nanosecond_value) as datetime` | `datetime` |
| `dateTimeHour` | `op dateTimeHour (as datetime: value) as int64` | `int64` |
| `dateTimeMinute` | `op dateTimeMinute (as datetime: value) as int64` | `int64` |
| `dateTimeSecond` | `op dateTimeSecond (as datetime: value) as int64` | `int64` |
| `dateTimeMillisecond` | `op dateTimeMillisecond (as datetime: value) as int64` | `int64` |
| `dateTimeMicrosecond` | `op dateTimeMicrosecond (as datetime: value) as int64` | `int64` |
| `dateTimeNanosecond` | `op dateTimeNanosecond (as datetime: value) as int64` | `int64` |
| `dateTimeAddHours` | `op dateTimeAddHours (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractHours` | `op dateTimeSubtractHours (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddMinutes` | `op dateTimeAddMinutes (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractMinutes` | `op dateTimeSubtractMinutes (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddSeconds` | `op dateTimeAddSeconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractSeconds` | `op dateTimeSubtractSeconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddMilliseconds` | `op dateTimeAddMilliseconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractMilliseconds` | `op dateTimeSubtractMilliseconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddMicroseconds` | `op dateTimeAddMicroseconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractMicroseconds` | `op dateTimeSubtractMicroseconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeAddNanoseconds` | `op dateTimeAddNanoseconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeSubtractNanoseconds` | `op dateTimeSubtractNanoseconds (as datetime: value, as int64: amount) as datetime` | `datetime` |
| `dateTimeHoursBetween` | `op dateTimeHoursBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeMinutesBetween` | `op dateTimeMinutesBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeSecondsBetween` | `op dateTimeSecondsBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeMillisecondsBetween` | `op dateTimeMillisecondsBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeMicrosecondsBetween` | `op dateTimeMicrosecondsBetween (as datetime: left, as datetime: right) as int64` | `int64` |
| `dateTimeNanosecondsBetween` | `op dateTimeNanosecondsBetween (as datetime: left, as datetime: right) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op dateTimeCreateTime`
```flux
op dateTimeCreateTime (as int64: hour_value, as int64: minute_value, as int64: second_value) as datetime
```
- **Parâmetros**:
  - `hour_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `minute_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `second_value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeCreateTime` no domínio `DateTimeTimeContract`.

##### `op dateTimeCreateTimeFull`
```flux
op dateTimeCreateTimeFull (as int64: hour_value, as int64: minute_value, as int64: second_value, as int64: millisecond_value, as int64: microsecond_value, as int64: nanosecond_value) as datetime
```
- **Parâmetros**:
  - `hour_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `minute_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `second_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `millisecond_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `microsecond_value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `nanosecond_value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeCreateTimeFull` no domínio `DateTimeTimeContract`.

##### `op dateTimeHour`
```flux
op dateTimeHour (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeHour` no domínio `DateTimeTimeContract`.

##### `op dateTimeMinute`
```flux
op dateTimeMinute (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMinute` no domínio `DateTimeTimeContract`.

##### `op dateTimeSecond`
```flux
op dateTimeSecond (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSecond` no domínio `DateTimeTimeContract`.

##### `op dateTimeMillisecond`
```flux
op dateTimeMillisecond (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMillisecond` no domínio `DateTimeTimeContract`.

##### `op dateTimeMicrosecond`
```flux
op dateTimeMicrosecond (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMicrosecond` no domínio `DateTimeTimeContract`.

##### `op dateTimeNanosecond`
```flux
op dateTimeNanosecond (as datetime: value) as int64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeNanosecond` no domínio `DateTimeTimeContract`.

##### `op dateTimeAddHours`
```flux
op dateTimeAddHours (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddHours` no domínio `DateTimeTimeContract`.

##### `op dateTimeSubtractHours`
```flux
op dateTimeSubtractHours (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractHours` no domínio `DateTimeTimeContract`.

##### `op dateTimeAddMinutes`
```flux
op dateTimeAddMinutes (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddMinutes` no domínio `DateTimeTimeContract`.

##### `op dateTimeSubtractMinutes`
```flux
op dateTimeSubtractMinutes (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractMinutes` no domínio `DateTimeTimeContract`.

##### `op dateTimeAddSeconds`
```flux
op dateTimeAddSeconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddSeconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeSubtractSeconds`
```flux
op dateTimeSubtractSeconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractSeconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeAddMilliseconds`
```flux
op dateTimeAddMilliseconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddMilliseconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeSubtractMilliseconds`
```flux
op dateTimeSubtractMilliseconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractMilliseconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeAddMicroseconds`
```flux
op dateTimeAddMicroseconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddMicroseconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeSubtractMicroseconds`
```flux
op dateTimeSubtractMicroseconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractMicroseconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeAddNanoseconds`
```flux
op dateTimeAddNanoseconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeAddNanoseconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeSubtractNanoseconds`
```flux
op dateTimeSubtractNanoseconds (as datetime: value, as int64: amount) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `amount` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSubtractNanoseconds` no domínio `DateTimeTimeContract`.

##### `op dateTimeHoursBetween`
```flux
op dateTimeHoursBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeHoursBetween` no domínio `DateTimeTimeContract`.

##### `op dateTimeMinutesBetween`
```flux
op dateTimeMinutesBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMinutesBetween` no domínio `DateTimeTimeContract`.

##### `op dateTimeSecondsBetween`
```flux
op dateTimeSecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeSecondsBetween` no domínio `DateTimeTimeContract`.

##### `op dateTimeMillisecondsBetween`
```flux
op dateTimeMillisecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMillisecondsBetween` no domínio `DateTimeTimeContract`.

##### `op dateTimeMicrosecondsBetween`
```flux
op dateTimeMicrosecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeMicrosecondsBetween` no domínio `DateTimeTimeContract`.

##### `op dateTimeNanosecondsBetween`
```flux
op dateTimeNanosecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parâmetros**:
  - `left` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `right` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeNanosecondsBetween` no domínio `DateTimeTimeContract`.

### 4.6 Contrato `DateTimeTimeZoneContract` (`DateTimeTimeZone.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dateTimeToTimeZone` | `op dateTimeToTimeZone (as datetime: value, as string: timezone_name) as string` | `string` |
| `dateTimeToLocal` | `op dateTimeToLocal (as datetime: value) as string` | `string` |
| `dateTimeToUtc` | `op dateTimeToUtc (as datetime: value) as datetime` | `datetime` |
| `dateTimeUtcOffset` | `op dateTimeUtcOffset (as datetime: value, as string: timezone_name) as float64` | `float64` |
| `dateTimeLocalTimeZone` | `op dateTimeLocalTimeZone () as string` | `string` |
| `dateTimeIsDaylightSavingTime` | `op dateTimeIsDaylightSavingTime (as datetime: value, as string: timezone_name) as bool` | `bool` |
| `dateTimeDstOffset` | `op dateTimeDstOffset (as datetime: value, as string: timezone_name) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op dateTimeToTimeZone`
```flux
op dateTimeToTimeZone (as datetime: value, as string: timezone_name) as string
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `timezone_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeToTimeZone` no domínio `DateTimeTimeZoneContract`.

##### `op dateTimeToLocal`
```flux
op dateTimeToLocal (as datetime: value) as string
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeToLocal` no domínio `DateTimeTimeZoneContract`.

##### `op dateTimeToUtc`
```flux
op dateTimeToUtc (as datetime: value) as datetime
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `datetime`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeToUtc` no domínio `DateTimeTimeZoneContract`.

##### `op dateTimeUtcOffset`
```flux
op dateTimeUtcOffset (as datetime: value, as string: timezone_name) as float64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `timezone_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeUtcOffset` no domínio `DateTimeTimeZoneContract`.

##### `op dateTimeLocalTimeZone`
```flux
op dateTimeLocalTimeZone () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeLocalTimeZone` no domínio `DateTimeTimeZoneContract`.

##### `op dateTimeIsDaylightSavingTime`
```flux
op dateTimeIsDaylightSavingTime (as datetime: value, as string: timezone_name) as bool
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `timezone_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeIsDaylightSavingTime` no domínio `DateTimeTimeZoneContract`.

##### `op dateTimeDstOffset`
```flux
op dateTimeDstOffset (as datetime: value, as string: timezone_name) as float64
```
- **Parâmetros**:
  - `value` (`datetime`): Parâmetro de entrada para processamento da operação.
  - `timezone_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dateTimeDstOffset` no domínio `DateTimeTimeZoneContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da DateTimeStdLib
use DateTimeStdLib

program (ExemploDateTimeStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: DateTimeStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = DateTimeStdLib::nowUtc()
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
