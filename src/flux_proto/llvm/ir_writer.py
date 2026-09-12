from __future__ import annotations

import sys


class IRWriter:
    def __init__(self) -> None:
        self._lines: list[str] = []
        self._strings: dict[str, str] = {}
        self._string_lens: dict[str, int] = {}
        self._string_idx = 0
        self._local_idx = 0
        self._block_idx = 0
        self._current_block: str | None = None
        self._current_func: str | None = None
        self._in_function = False

    def _indent(self, text: str = "") -> str:
        return "  " + text if text else ""

    def _escape(self, s: str) -> str:
        return s.replace("\\", "\\5C").replace("\"", "\\22").replace("\n", "\\0A").replace("\t", "\\09").replace("\r", "\\0D")

    def add_comment(self, text: str) -> None:
        self._lines.append(f"; {text}")

    def add_module_info(self) -> None:
        if sys.platform == "win32":
            self._lines.append('target triple = "x86_64-pc-windows-msvc"')
        elif sys.platform == "darwin":
            self._lines.append('target triple = "x86_64-apple-macosx"')
        else:
            self._lines.append('target triple = "x86_64-pc-linux-gnu"')

    def get_string_global(self, value: str) -> str:
        if value in self._strings:
            return self._strings[value]
        name = f".str.{self._string_idx}"
        self._string_idx += 1
        self._strings[value] = name
        self._string_lens[name] = len(value.encode("utf-8"))
        return name

    def string_len_of(self, name: str) -> int | None:
        return self._string_lens.get(name)

    def emit_string_constants(self) -> None:
        for value, name in self._strings.items():
            escaped = self._escape(value)
            n = len(value.encode("utf-8")) + 1
            self._lines.append(f'@{name} = private unnamed_addr constant [{n} x i8] c"{escaped}\\00"')

    def add_global(self, name: str, llvm_type: str, initializer: str | None = None) -> None:
        init = initializer if initializer else "zeroinitializer"
        self._lines.append(f"@{name} = global {llvm_type} {init}")

    def add_type(self, name: str, body: str) -> None:
        self._lines.append(f"%{name} = type {body}")

    def declare_function(self, name: str, return_type: str, param_types: list[str], vararg: bool = False) -> None:
        params = ", ".join(p for p in param_types)
        if vararg:
            params += ", ..." if params else "..."
        self._lines.append(f"declare {return_type} @{name}({params})")

    def begin_function(self, name: str, return_type: str, param_types: list[str] | None = None) -> None:
        self._current_func = name
        self._in_function = True
        self._local_idx = 0
        self._block_idx = 0
        params = ", ".join(p for p in (param_types or []))
        self._lines.append(f"")
        self._lines.append(f"define {return_type} @{name}({params}) {{")

    def end_function(self) -> None:
        self._lines.append("}")
        self._current_func = None
        self._in_function = False
        self._current_block = None

    def new_block(self, label: str | None = None) -> str:
        if label is None:
            label = f"bb{self._block_idx}"
            self._block_idx += 1
        self._current_block = label
        self._lines.append(f"{label}:")
        return label

    def emit(self, instruction: str) -> None:
        self._lines.append(self._indent(instruction))

    def new_local(self, hint: str = "") -> str:
        if hint:
            name = f"%{hint}.{self._local_idx}"
        else:
            name = f"%t{self._local_idx}"
        self._local_idx += 1
        return name

    def set_current_block(self, label: str) -> None:
        self._current_block = label

    def ir(self) -> str:
        return "\n".join(self._lines) + "\n"
