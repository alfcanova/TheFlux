# 📚 Standard Modular Library Architecture (*StdLib) for TheFlux

> **Status**: ✅ Certified with 100% Parity across all 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Canonical Reference Case**: `stdlib/MathStdLib/`

---

> [!IMPORTANT]
> ### ⚠️ UNIVERSAL LANGUAGE CONTRACT
> The architectural guidelines, naming conventions, directory topologies, domain contracts, declarative manifests (`use`), and transparent merging mechanisms defined in this document are **mandatory, universal language standards of TheFlux**.
> 
> **This architecture strictly governs all 37 standard libraries (`*StdLib`) in the TheFlux ecosystem** (e.g., `ThreadStdLib`, `NetStdLib`, `IoStdLib`, `CompressStdLib`, `DbStdLib`, `LinAlgStdLib`, `SimdStdLib`, etc.), as well as all future modular libraries. The **`MathStdLib`** implementation detailed herein serves as the **canonical reference model** for the entire platform.

---

## 📦 0. Catalog of 37 Standard Libraries across the 4 Architectural Pillars

|--------------------------|----------------------------|------------------------------|---------------------------|
| 🔤 1. Core, Text & OO    | 📊 2. Structures & State   | 🧮 3. Math & Graphics        | 🌐 4. System, I/O & Net   |
|--------------------------|----------------------------|------------------------------|---------------------------|
| ✅ `CharStdLib`          | ✅ `CompressStdLib`        | ✅ `FinStdLib`               | ✅ `ArchiveStdLib`        |
| ✅ `ConvertStdLib`       | ✅ `DateTimeStdLib`        | ✅ `GraphPlotStdLib`         | ✅ `GfxStdLib`            |
| ✅ `DebugStdLib`         | ✅ `DbStdLib`              | ✅ `HashStdLib`              | ✅ `GuiStdLib`            |
| ✅ `DslStdLib`           | ✅ `FsmStdLib`             | ✅ `LinAlgStdLib`            | ✅ `IoStdLib`             |
| ✅ `FileSignatureStdLib` | ✅ `ListStdLib`            | ✅ `MathStdLib`              | ✅ `LowLevelStdLib`       |
| ✅ `OoStdLib`            | ✅ `RandomStdLib`          | ✅ `SimdStdLib`              | ✅ `NativeGfxStdLib`      |
| ✅ `FormatStdLib`        | ✅ `MapStdLib`             | ✅ `PhysStdLib`              | ✅ `NetStdLib`            |
| ✅ `RegexStdLib`         | ✅ `SetStdLib`             | ✅ `StatStdLib`              | ✅ `OsStdLib`             |
| ✅ `StringStdLib`        | ✅ `StructStdLib`          | ✅ `SymbolicStdLib`          | ✅ `RuntimeStdLib`        |
|                          |                            |                              | ✅ `ThreadStdLib`         |
|--------------------------|----------------------------|------------------------------|---------------------------|

*Total: 37 Standard Libraries in FDSL (`.fdsl`) with 100% multi-backend parity across all 6 official targets.*

---

## 🎯 1. Architectural Principles and Design Guidelines

### 1.1 Flat Directory Structure with Mandatory `StdLib` Suffix
Each standard library is encapsulated within its own dedicated directory directly under `stdlib/`, bearing the required `StdLib` suffix. All domain files reside **strictly at the root level of the folder**, without intermediate subdirectories (such as `trig/` or `io/`), guaranteeing navigational simplicity and deterministic resolution:

```text
stdlib/
└── <Name>StdLib/                       # E.g.: MathStdLib, NetStdLib, ThreadStdLib
    ├── <Name>StdLib.fdsl               # Master Aggregator File (Declarative Manifest)
    ├── <DomainA>.fdsl                  # Contract + Storages + Ops for Domain A
    ├── <DomainB>.fdsl                  # Contract + Storages + Ops for Domain B
    └── <DomainC>.fdsl                  # Contract + Storages + Ops for Domain C
```

### 1.2 The Master Aggregator File: Manifest, Public Types, and Shared Infrastructure
The master file must be named `<Name>StdLib/<Name>StdLib.fdsl`. It serves as the **Declarative Manifest, Public Type Interface, and Shared Infrastructure Provider** for the library, governed by three core rules:
1. **Shared Public Type Declarations**: When a library exposes structures (`struct`) or enumerations (`enum`) shared across multiple domains (such as `DecompressQuota` in `CompressStdLib`, `FinDecimal` in `FinStdLib`, or `SymbolicNode` in `SymbolicStdLib`), they are declared at the top of the master aggregator file.
2. **Shared General Utility Operations (`op _*`)**: Auxiliary internal operations consumed by **two or more `.fdsl` files** (such as string helpers `_fmtStrLen`, list helpers `_listContains`, or struct reflection `_extractStructType`) reside directly inside the master agent: `agent (<Name>StdLib) { op _... ==> { ... } }`.
3. **Explicit Module Declarations**: Lists all domain modules that comprise the library via `use <Module>` or `use <Module>.fdsl` directives.
4. **Strict Isolation Against Foreign Files**: The compiler loads **only the modules explicitly declared in the manifest**. Any extraneous file placed in the directory (scratch scripts, unmerged branches, temporary backups) is **completely ignored**.
5. **Strict Typo Detection and Early Rejection**: If an undeclared module is referenced or misspelled (e.g., `use Trignometry`), the compiler raises an immediate `ImportError` (`IMP201`), preventing silent failures.

### 1.3 Contracts, Constants, and Domain Modules
To ensure maximum cohesion, modularity, and functional decoupling:
1. **Formal Contract Implementation**: Every child `.fdsl` file must define a formal domain contract (`contract (<Domain>Contract)`) and implement it through the library's base agent (`agent (<Name>StdLib) impl <DomainContract> { ... }`).
2. **Zero Orphan Files**: Every `.fdsl` file must belong to a contract. Orphan helper files without contracts are forbidden.
3. **Domain-Local Helpers**: Operations used exclusively by a single domain file reside private to that domain (`FormatEncoding.fdsl` retains Base64 helpers `_fmtOrd` and `_fmtChr`; `FormatYaml.fdsl` retains `_fmtCharToHexDigit`).
4. **Immutable Constants and Dedicated Storages**: Domain constants reside in dedicated storages (`storage (MathConstantsStorage)`), preventing global namespace pollution.

---

## 🔬 2. Canonical Case Study: `MathStdLib`

### 2.1 Directory Structure
```text
stdlib/MathStdLib/
├── MathStdLib.fdsl                     # Master Aggregator and Declarative Manifest
├── MathConstantsContract.fdsl          # Constants: PI, E, PHI, SQRT2, LN2, LN10
├── MathBasicArithmeticContract.fdsl    # Operations: abs, sign, min, max, clamp
├── MathTrigonometryContract.fdsl       # Trigonometry: sin, cos, tan, asin, acos, atan
├── MathExponentialContract.fdsl        # Exponential/Log: exp, ln, log10, log2, pow
├── MathHyperbolicContract.fdsl         # Hyperbolic: sinh, cosh, tanh, asinh, acosh
├── MathSpecialFunctionsContract.fdsl   # Special: gamma, lgamma, erf, erfc, beta
└── MathIntegerTheoryContract.fdsl      # Number Theory: gcd, lcm, isPrime, factorial
```

### 2.2 Master Aggregator File (`stdlib/MathStdLib/MathStdLib.fdsl`)
```theflux
#L TheFlux Standard Library: MathStdLib
#L Master Aggregator and Declarative Domain Manifest

#L Shared Global Types
enum (RoundingMode) {
      RoundNearest
      RoundUp
      RoundDown
      RoundZero
}

#L Declarative Domain Module Manifest
use MathConstantsContract.fdsl
use MathBasicArithmeticContract.fdsl
use MathTrigonometryContract.fdsl
use MathExponentialContract.fdsl
use MathHyperbolicContract.fdsl
use MathSpecialFunctionsContract.fdsl
use MathIntegerTheoryContract.fdsl

#L Master Base Agent for MathStdLib
agent (MathStdLib) {
      #L Shared Internal Infrastructure (consumed across multiple domains)
      op _approxEqual(as float64: a, as float64: b, as float64: eps) as bool ==> {
            mut as float64: diff = a - b
            route (diff < 0.0) {
                  true  --> { diff = -diff }
                  false --> { }
            }
            emit(nice, diff <= eps, "ok")
      }
}
```

### 2.3 Domain Module (`stdlib/MathStdLib/MathTrigonometryContract.fdsl`)
```theflux
#L TheFlux Standard Library: MathStdLib -> Trigonometry Domain

contract (MathTrigonometryContract) {
      op sin64(as float64: rad) as float64
      op cos64(as float64: rad) as float64
      op tan64(as float64: rad) as float64
}

agent (MathStdLib) impl MathTrigonometryContract {
      op sin64(as float64: rad) as float64 ==> {
            #L High-precision polynomial Taylor approximation
            mut as float64: result = rad - (rad^e 3.0) / 6.0 + (rad^e 5.0) / 120.0
            emit(nice, result, "sin evaluated")
      }

      op cos64(as float64: rad) as float64 ==> {
            mut as float64: result = 1.0 - (rad^e 2.0) / 2.0 + (rad^e 4.0) / 24.0
            emit(nice, result, "cos evaluated")
      }

      op tan64(as float64: rad) as float64 ==> {
            mut as float64: s = MathStdLib::sin64(rad)
            mut as float64: c = MathStdLib::cos64(rad)
            route (c == 0.0) {
                  true  --> { emit(fail, 0.0, "tan undefined: cos is zero") }
                  false --> { emit(nice, s / c, "tan evaluated") }
            }
      }
}
```

---

## ⚙️ 3. Semantic Lowering, AST Merging & Compiler Integration

### 3.1 Transparent AST Fusion
When a program imports a modular library (`use MathStdLib`):
1. **Directory Discovery**: The import resolver detects `stdlib/MathStdLib/MathStdLib.fdsl`.
2. **Manifest Processing**: It parses `MathStdLib.fdsl`, extracts its declared modules, and verifies their presence.
3. **AST Consolidation**: The resolver parses each declared domain file and merges its contracts, storage variables, and agent operations into a unified monolithic in-memory representation.
4. **Hierarchical Multi-Segment Dispatch**: Operations can be called via their global alias or explicit hierarchical path:
   ```theflux
   # Direct call via agent
   MathStdLib::sin64(1.5707963) --> print

   # Hierarchical qualified call
   MathStdLib::MathTrigonometryContract::sin64(1.5707963) --> print
   ```

### 3.2 Concrete Usage Example

```theflux
#L ExampleOfUseMathStdLib.flux
use MathStdLib

program (MathExample) {
      print("Testing MathStdLib Trigonometry:")
      mut as float64: angle = 0.5235987755982988  # PI / 6 (30 degrees)
      print("sin(PI/6): " + MathStdLib::sin64(angle))
      print("cos(PI/6): " + MathStdLib::cos64(angle))
}
```

---

## 🧪 4. Testing & Multi-Backend Compliance

The entire standard library suite is validated continuously through [`backend_compliance.py`](file:///D:/Projetos/TheFlux/backend_compliance.py):

```powershell
# Run the complete modular suite across all 6 backends:
python backend_compliance.py --modular

# Run a specific domain test:
python backend_compliance.py ExampleOfUseMathStdLib_TrigonometryContract
```

Every single contract operation guarantees bit-for-bit identical output across:
- **`in`**: In-memory AST reference interpreter
- **`vm`**: Bytecode compiler and Python-based VM
- **`vmr`**: Deserialized bytecode runner
- **`llvm`**: Native compiled machine code via Clang
- **`wat`**: Textual WebAssembly S-expressions
- **`wasm`**: Binary WebAssembly via WASI
