# 📚 `DateTimeStdLib` — Date, Time, Timezone, and Monotonic Clock Management

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/DateTimeStdLib/DateTimeStdLib.fdsl`  
> **Import Mode**: `use DateTimeStdLib` or `use DateTimeStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`DateTimeStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Full-featured date and time manipulation, Unix epoch timestamps, IANA timezone conversions, strict ISO 8601 parsing and formatting, calendar arithmetic, and nanosecond-resolution monotonic interval timing.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `DateTimeStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **6 domain modules** declaring a total of **68 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `DateTimeCompare.fdsl` | `DateTimeCompareContract` | Specialized domain for `DateTimeCompare` | 4 |
| `DateTimeDate.fdsl` | `DateTimeDateContract` | Specialized domain for `DateTimeDate` | 19 |
| `DateTimeFormat.fdsl` | `DateTimeFormatContract` | Specialized domain for `DateTimeFormat` | 10 |
| `DateTimeMonotonic.fdsl` | `DateTimeMonotonicContract` | Specialized domain for `DateTimeMonotonic` | 2 |
| `DateTimeTime.fdsl` | `DateTimeTimeContract` | Specialized domain for `DateTimeTime` | 26 |
| `DateTimeTimeZone.fdsl` | `DateTimeTimeZoneContract` | Specialized domain for `DateTimeTimeZone` | 7 |

---

## 3. Public Types, Structures, and Enumerations

The `DateTimeStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `DateTimeCompareContract` (`DateTimeCompare.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dateTimeSameInstant` | `op dateTimeSameInstant (as datetime: left, as datetime: right) as bool` | `bool` |
| `dateTimeIsBefore` | `op dateTimeIsBefore (as datetime: left, as datetime: right) as bool` | `bool` |
| `dateTimeIsAfter` | `op dateTimeIsAfter (as datetime: left, as datetime: right) as bool` | `bool` |
| `dateTimeCompare` | `op dateTimeCompare (as datetime: left, as datetime: right) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op dateTimeSameInstant`
```flux
op dateTimeSameInstant (as datetime: left, as datetime: right) as bool
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSameInstant` functionality within the `DateTimeCompareContract` domain.

##### `op dateTimeIsBefore`
```flux
op dateTimeIsBefore (as datetime: left, as datetime: right) as bool
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeIsBefore` functionality within the `DateTimeCompareContract` domain.

##### `op dateTimeIsAfter`
```flux
op dateTimeIsAfter (as datetime: left, as datetime: right) as bool
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeIsAfter` functionality within the `DateTimeCompareContract` domain.

##### `op dateTimeCompare`
```flux
op dateTimeCompare (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeCompare` functionality within the `DateTimeCompareContract` domain.

### 4.2 Contract `DateTimeDateContract` (`DateTimeDate.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op dateTimeCreateDate`
```flux
op dateTimeCreateDate (as int64: year_value, as int64: month_value, as int64: day_value) as datetime
```
- **Parameters**:
  - `year_value` (`int64`): Input argument for operation execution.
  - `month_value` (`int64`): Input argument for operation execution.
  - `day_value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeCreateDate` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeYear`
```flux
op dateTimeYear (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeYear` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeMonth`
```flux
op dateTimeMonth (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMonth` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeDay`
```flux
op dateTimeDay (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeDay` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeWeekday`
```flux
op dateTimeWeekday (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeWeekday` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeDayOfYear`
```flux
op dateTimeDayOfYear (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeDayOfYear` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeDaysInMonth`
```flux
op dateTimeDaysInMonth (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeDaysInMonth` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeQuarter`
```flux
op dateTimeQuarter (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeQuarter` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeIsLeapYear`
```flux
op dateTimeIsLeapYear (as datetime: value) as bool
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeIsLeapYear` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeIsWeekend`
```flux
op dateTimeIsWeekend (as datetime: value) as bool
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeIsWeekend` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeAddDays`
```flux
op dateTimeAddDays (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddDays` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeSubtractDays`
```flux
op dateTimeSubtractDays (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractDays` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeAddMonths`
```flux
op dateTimeAddMonths (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddMonths` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeSubtractMonths`
```flux
op dateTimeSubtractMonths (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractMonths` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeAddYears`
```flux
op dateTimeAddYears (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddYears` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeSubtractYears`
```flux
op dateTimeSubtractYears (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractYears` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeDaysBetween`
```flux
op dateTimeDaysBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeDaysBetween` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeMonthsBetween`
```flux
op dateTimeMonthsBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMonthsBetween` functionality within the `DateTimeDateContract` domain.

##### `op dateTimeYearsBetween`
```flux
op dateTimeYearsBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeYearsBetween` functionality within the `DateTimeDateContract` domain.

### 4.3 Contract `DateTimeFormatContract` (`DateTimeFormat.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op dateTimeEpoch`
```flux
op dateTimeEpoch () as datetime
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeEpoch` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeNow`
```flux
op dateTimeNow () as datetime
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeNow` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeToday`
```flux
op dateTimeToday () as datetime
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeToday` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeTime`
```flux
op dateTimeTime () as datetime
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeTime` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeNowFormatted`
```flux
op dateTimeNowFormatted () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeNowFormatted` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeFormatDuration`
```flux
op dateTimeFormatDuration (as int64: duration_ns) as string
```
- **Parameters**:
  - `duration_ns` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeFormatDuration` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeParseIso`
```flux
op dateTimeParseIso (as string: text) as datetime
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeParseIso` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeToIso`
```flux
op dateTimeToIso (as datetime: value) as string
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeToIso` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeToString`
```flux
op dateTimeToString (as datetime: value) as string
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeToString` functionality within the `DateTimeFormatContract` domain.

##### `op dateTimeFormat`
```flux
op dateTimeFormat (as datetime: value, as string: pattern) as string
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `pattern` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeFormat` functionality within the `DateTimeFormatContract` domain.

### 4.4 Contract `DateTimeMonotonicContract` (`DateTimeMonotonic.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dateTimeMonotonicNow` | `op dateTimeMonotonicNow () as int64` | `int64` |
| `dateTimeMonotonicElapsed` | `op dateTimeMonotonicElapsed (as int64: start_time_ns) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op dateTimeMonotonicNow`
```flux
op dateTimeMonotonicNow () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMonotonicNow` functionality within the `DateTimeMonotonicContract` domain.

##### `op dateTimeMonotonicElapsed`
```flux
op dateTimeMonotonicElapsed (as int64: start_time_ns) as int64
```
- **Parameters**:
  - `start_time_ns` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMonotonicElapsed` functionality within the `DateTimeMonotonicContract` domain.

### 4.5 Contract `DateTimeTimeContract` (`DateTimeTime.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op dateTimeCreateTime`
```flux
op dateTimeCreateTime (as int64: hour_value, as int64: minute_value, as int64: second_value) as datetime
```
- **Parameters**:
  - `hour_value` (`int64`): Input argument for operation execution.
  - `minute_value` (`int64`): Input argument for operation execution.
  - `second_value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeCreateTime` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeCreateTimeFull`
```flux
op dateTimeCreateTimeFull (as int64: hour_value, as int64: minute_value, as int64: second_value, as int64: millisecond_value, as int64: microsecond_value, as int64: nanosecond_value) as datetime
```
- **Parameters**:
  - `hour_value` (`int64`): Input argument for operation execution.
  - `minute_value` (`int64`): Input argument for operation execution.
  - `second_value` (`int64`): Input argument for operation execution.
  - `millisecond_value` (`int64`): Input argument for operation execution.
  - `microsecond_value` (`int64`): Input argument for operation execution.
  - `nanosecond_value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeCreateTimeFull` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeHour`
```flux
op dateTimeHour (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeHour` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeMinute`
```flux
op dateTimeMinute (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMinute` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSecond`
```flux
op dateTimeSecond (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSecond` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeMillisecond`
```flux
op dateTimeMillisecond (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMillisecond` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeMicrosecond`
```flux
op dateTimeMicrosecond (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMicrosecond` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeNanosecond`
```flux
op dateTimeNanosecond (as datetime: value) as int64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeNanosecond` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeAddHours`
```flux
op dateTimeAddHours (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddHours` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSubtractHours`
```flux
op dateTimeSubtractHours (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractHours` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeAddMinutes`
```flux
op dateTimeAddMinutes (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddMinutes` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSubtractMinutes`
```flux
op dateTimeSubtractMinutes (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractMinutes` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeAddSeconds`
```flux
op dateTimeAddSeconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddSeconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSubtractSeconds`
```flux
op dateTimeSubtractSeconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractSeconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeAddMilliseconds`
```flux
op dateTimeAddMilliseconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddMilliseconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSubtractMilliseconds`
```flux
op dateTimeSubtractMilliseconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractMilliseconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeAddMicroseconds`
```flux
op dateTimeAddMicroseconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddMicroseconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSubtractMicroseconds`
```flux
op dateTimeSubtractMicroseconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractMicroseconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeAddNanoseconds`
```flux
op dateTimeAddNanoseconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeAddNanoseconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSubtractNanoseconds`
```flux
op dateTimeSubtractNanoseconds (as datetime: value, as int64: amount) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `amount` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSubtractNanoseconds` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeHoursBetween`
```flux
op dateTimeHoursBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeHoursBetween` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeMinutesBetween`
```flux
op dateTimeMinutesBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMinutesBetween` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeSecondsBetween`
```flux
op dateTimeSecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeSecondsBetween` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeMillisecondsBetween`
```flux
op dateTimeMillisecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMillisecondsBetween` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeMicrosecondsBetween`
```flux
op dateTimeMicrosecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeMicrosecondsBetween` functionality within the `DateTimeTimeContract` domain.

##### `op dateTimeNanosecondsBetween`
```flux
op dateTimeNanosecondsBetween (as datetime: left, as datetime: right) as int64
```
- **Parameters**:
  - `left` (`datetime`): Input argument for operation execution.
  - `right` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeNanosecondsBetween` functionality within the `DateTimeTimeContract` domain.

### 4.6 Contract `DateTimeTimeZoneContract` (`DateTimeTimeZone.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dateTimeToTimeZone` | `op dateTimeToTimeZone (as datetime: value, as string: timezone_name) as string` | `string` |
| `dateTimeToLocal` | `op dateTimeToLocal (as datetime: value) as string` | `string` |
| `dateTimeToUtc` | `op dateTimeToUtc (as datetime: value) as datetime` | `datetime` |
| `dateTimeUtcOffset` | `op dateTimeUtcOffset (as datetime: value, as string: timezone_name) as float64` | `float64` |
| `dateTimeLocalTimeZone` | `op dateTimeLocalTimeZone () as string` | `string` |
| `dateTimeIsDaylightSavingTime` | `op dateTimeIsDaylightSavingTime (as datetime: value, as string: timezone_name) as bool` | `bool` |
| `dateTimeDstOffset` | `op dateTimeDstOffset (as datetime: value, as string: timezone_name) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op dateTimeToTimeZone`
```flux
op dateTimeToTimeZone (as datetime: value, as string: timezone_name) as string
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `timezone_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeToTimeZone` functionality within the `DateTimeTimeZoneContract` domain.

##### `op dateTimeToLocal`
```flux
op dateTimeToLocal (as datetime: value) as string
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeToLocal` functionality within the `DateTimeTimeZoneContract` domain.

##### `op dateTimeToUtc`
```flux
op dateTimeToUtc (as datetime: value) as datetime
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `datetime`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeToUtc` functionality within the `DateTimeTimeZoneContract` domain.

##### `op dateTimeUtcOffset`
```flux
op dateTimeUtcOffset (as datetime: value, as string: timezone_name) as float64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `timezone_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeUtcOffset` functionality within the `DateTimeTimeZoneContract` domain.

##### `op dateTimeLocalTimeZone`
```flux
op dateTimeLocalTimeZone () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeLocalTimeZone` functionality within the `DateTimeTimeZoneContract` domain.

##### `op dateTimeIsDaylightSavingTime`
```flux
op dateTimeIsDaylightSavingTime (as datetime: value, as string: timezone_name) as bool
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `timezone_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeIsDaylightSavingTime` functionality within the `DateTimeTimeZoneContract` domain.

##### `op dateTimeDstOffset`
```flux
op dateTimeDstOffset (as datetime: value, as string: timezone_name) as float64
```
- **Parameters**:
  - `value` (`datetime`): Input argument for operation execution.
  - `timezone_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dateTimeDstOffset` functionality within the `DateTimeTimeZoneContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for DateTimeStdLib
use DateTimeStdLib

program (ExampleOfDateTimeStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: DateTimeStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = DateTimeStdLib::nowUtc()
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
