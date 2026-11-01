## 1. Spec

- [x] 1.1 `specs/tensor/spec.md` — layout flat, indexação 1-based, erros (shape mismatch, bounds por dim), formato print

## 2. Interpreter (run)

- [ ] 2.1 Storage: buffer flat Python + strides de `_tensor_dims`; read com elem type correto; write c/ bounds por dim
- [ ] 2.2 Shape-check do literal na declaração (ragged/mismatch → erro)
- [ ] 2.3 Print aninhado + concat `str + tensor`
- [ ] 2.4 Unit tests: literal, multi-index, assign, default zeros, shape mismatch, elem types

## 3. VM (vmbc)

- [ ] 3.1 Opcodes `TGET/TSET` em opcodes.py/runtime.py
- [ ] 3.2 Compiler: idx_flat com strides const; storage flat; shape-check
- [ ] 3.3 Print/concat + unit tests

## 4. WAT

- [ ] 4.1 Layout header+data via `$flux_alloc`; inline offset constexpr; load/store
- [ ] 4.2 `$tensor_to_str` lendo header (formato aninhado)
- [ ] 4.3 IndexAccess/IndexAssign/literal/print/concat; default zero-fill
- [ ] 4.4 Validar vs interpretador

## 5. WASM

- [ ] 5.1 Espelho binário 1:1 do WAT
- [ ] 5.2 Validar vs interpretador

## 6. LLVM

- [ ] 6.1 Struct `[i64 rank][dims...][data...]`; GEP offsets const
- [ ] 6.2 Print loops printf; concat
- [ ] 6.3 Validar vs interpretador

## 7. Verificação final

- [ ] 7.1 `ExampleOfTensor.flux` passando nos 5 alvos (saída = run)
- [ ] 7.2 Compliance/backend_compliance sem regressões
- [ ] 7.3 Suíte completa verde (928+)
