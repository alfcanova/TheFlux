from __future__ import annotations

import itertools
import os
import threading
import time
from typing import Any, Callable


# ──────────────────────────────────────────────────────────────────────────────
# Canais CSP (Communicating Sequential Processes)
# ──────────────────────────────────────────────────────────────────────────────

class _Channel:
    def __init__(self, capacity: int = 0) -> None:
        self.capacity = max(0, int(capacity))
        self.lock = threading.Lock()
        self.not_empty = threading.Condition(self.lock)
        self.not_full = threading.Condition(self.lock)
        self.queue: list[Any] = []
        self.is_closed = False

    def send(self, message: Any, block: bool = True) -> bool:
        with self.not_full:
            if self.is_closed:
                return False
            if self.capacity > 0:
                while len(self.queue) >= self.capacity:
                    if self.is_closed:
                        return False
                    if not block:
                        return False
                    self.not_full.wait(timeout=0.05)
            self.queue.append(message)
            self.not_empty.notify()
            return True

    def recv(self, block: bool = True) -> tuple[bool, Any]:
        with self.not_empty:
            while not self.queue:
                if self.is_closed:
                    return False, None
                if not block:
                    return False, None
                self.not_empty.wait(timeout=0.05)
            val = self.queue.pop(0)
            self.not_full.notify()
            return True, val

    def close(self) -> bool:
        with self.lock:
            if self.is_closed:
                return True
            self.is_closed = True
            self.not_empty.notify_all()
            self.not_full.notify_all()
            return True

    def length(self) -> int:
        with self.lock:
            return len(self.queue)

    def is_empty(self) -> bool:
        with self.lock:
            return len(self.queue) == 0


_channel_counter = itertools.count(1)
_channels_lock = threading.Lock()
_channels: dict[int, _Channel] = {}


def _extract_channel_id(port: Any) -> int:
    if isinstance(port, dict):
        if "send" in port:
            return _extract_channel_id(port["send"])
        if "recv" in port:
            return _extract_channel_id(port["recv"])
    if hasattr(port, "data"):
        return _extract_channel_id(port.data)
    try:
        return int(port)
    except Exception:
        return 0


def channel_create(capacity: int = 0) -> dict[str, int]:
    with _channels_lock:
        cid = next(_channel_counter)
        _channels[cid] = _Channel(capacity)
        return {"send": cid, "recv": cid}


def channel_create_with_capacity(capacity: int) -> dict[str, int]:
    return channel_create(capacity)


def channel_send(port: Any, message: Any) -> bool:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return False
    return ch.send(message, block=True)


def channel_recv(port: Any) -> Any:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return ""
    ok, val = ch.recv(block=True)
    return val if ok else ""


def channel_try_send(port: Any, message: Any) -> bool:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return False
    return ch.send(message, block=False)


def channel_try_recv(port: Any) -> dict[str, Any]:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return {"ok": False, "data": ""}
    ok, val = ch.recv(block=False)
    return {"ok": ok, "data": val if ok else ""}


def channel_close(port: Any) -> bool:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return False
    return ch.close()


def channel_is_closed(port: Any) -> bool:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return True
    with ch.lock:
        return ch.is_closed


def channel_is_empty(port: Any) -> bool:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return True
    return ch.is_empty()


def channel_length(port: Any) -> int:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return 0
    return ch.length()


def channel_capacity(port: Any) -> int:
    cid = _extract_channel_id(port)
    with _channels_lock:
        ch = _channels.get(cid)
    if not ch:
        return 0
    return ch.capacity


# ──────────────────────────────────────────────────────────────────────────────
# Sincronização Clássica: Mutex, Atômicos e WaitGroup
# ──────────────────────────────────────────────────────────────────────────────

_mutex_counter = itertools.count(1)
_mutexes_lock = threading.Lock()
_mutexes: dict[int, threading.Lock] = {}


def mutex_create() -> int:
    with _mutexes_lock:
        mid = next(_mutex_counter)
        _mutexes[mid] = threading.Lock()
        return mid


def mutex_lock(mutex_id: int) -> bool:
    with _mutexes_lock:
        m = _mutexes.get(int(mutex_id))
    if not m:
        return False
    m.acquire()
    return True


def mutex_unlock(mutex_id: int) -> bool:
    with _mutexes_lock:
        m = _mutexes.get(int(mutex_id))
    if not m:
        return False
    try:
        m.release()
        return True
    except RuntimeError:
        return False


def mutex_try_lock(mutex_id: int) -> bool:
    with _mutexes_lock:
        m = _mutexes.get(int(mutex_id))
    if not m:
        return False
    return m.acquire(blocking=False)


def mutex_destroy(mutex_id: int) -> bool:
    with _mutexes_lock:
        return _mutexes.pop(int(mutex_id), None) is not None


# Atomics
_atomic_counter = itertools.count(1)
_atomics_lock = threading.Lock()
_atomics: dict[int, int] = {}


def atomic_create(initial_value: int = 0) -> int:
    with _atomics_lock:
        aid = next(_atomic_counter)
        _atomics[aid] = int(initial_value)
        return aid


def atomic_get(atomic_id: int) -> int:
    with _atomics_lock:
        return _atomics.get(int(atomic_id), 0)


def atomic_set(atomic_id: int, value: int) -> bool:
    with _atomics_lock:
        aid = int(atomic_id)
        if aid in _atomics:
            _atomics[aid] = int(value)
            return True
        return False


def atomic_add(atomic_id: int, delta: int) -> int:
    with _atomics_lock:
        aid = int(atomic_id)
        if aid in _atomics:
            _atomics[aid] += int(delta)
            return _atomics[aid]
        return 0


def atomic_cas(atomic_id: int, expected: int, desired: int) -> bool:
    with _atomics_lock:
        aid = int(atomic_id)
        if aid in _atomics and _atomics[aid] == int(expected):
            _atomics[aid] = int(desired)
            return True
        return False


def atomic_destroy(atomic_id: int) -> bool:
    with _atomics_lock:
        return _atomics.pop(int(atomic_id), None) is not None


# WaitGroup
class _WaitGroup:
    def __init__(self) -> None:
        self.lock = threading.Lock()
        self.cond = threading.Condition(self.lock)
        self.count = 0

    def add(self, delta: int) -> bool:
        with self.cond:
            self.count += int(delta)
            if self.count <= 0:
                self.count = 0
                self.cond.notify_all()
            return True

    def done(self) -> bool:
        return self.add(-1)

    def wait(self) -> bool:
        with self.cond:
            while self.count > 0:
                self.cond.wait(timeout=0.05)
            return True


_wg_counter = itertools.count(1)
_wg_lock = threading.Lock()
_waitgroups: dict[int, _WaitGroup] = {}


def wait_group_create() -> int:
    with _wg_lock:
        wgid = next(_wg_counter)
        _waitgroups[wgid] = _WaitGroup()
        return wgid


def wait_group_add(wg_id: int, delta: int) -> bool:
    with _wg_lock:
        wg = _waitgroups.get(int(wg_id))
    if not wg:
        return False
    return wg.add(delta)


def wait_group_done(wg_id: int) -> bool:
    return wait_group_add(wg_id, -1)


def wait_group_wait(wg_id: int) -> bool:
    with _wg_lock:
        wg = _waitgroups.get(int(wg_id))
    if not wg:
        return False
    return wg.wait()


def wait_group_destroy(wg_id: int) -> bool:
    with _wg_lock:
        return _waitgroups.pop(int(wg_id), None) is not None


# ──────────────────────────────────────────────────────────────────────────────
# Ciclo de Vida de Threads
# ──────────────────────────────────────────────────────────────────────────────

class _ThreadHandle:
    def __init__(self, tid: int, thread: threading.Thread | None = None, target_fn: Callable[[], Any] | None = None) -> None:
        self.tid = tid
        self.thread = thread
        self.target_fn = target_fn
        self.result: Any = None
        self.is_alive = True
        self.is_detached = False


_thread_counter = itertools.count(1)
_threads_lock = threading.Lock()
_threads: dict[int, _ThreadHandle] = {}


def thread_spawn_with_runner(runner_fn: Callable[[], Any]) -> int:
    with _threads_lock:
        tid = next(_thread_counter)
        handle = _ThreadHandle(tid, target_fn=runner_fn)
        _threads[tid] = handle

    def _worker() -> None:
        try:
            handle.result = runner_fn()
        except Exception as e:
            handle.result = str(e)
        finally:
            handle.is_alive = False

    t = threading.Thread(target=_worker, daemon=True)
    handle.thread = t
    t.start()
    return tid


def thread_spawn(agent_name: str, op_name: str, payload: Any) -> int:
    """Dispara uma thread de worker para executar uma operacao nomeada."""
    with _threads_lock:
        tid = next(_thread_counter)
        handle = _ThreadHandle(tid)
        _threads[tid] = handle
        # Mock/registro para ambientes síncronos e simulação
        handle.result = payload
        handle.is_alive = False
        return tid


def thread_join(thread_id: int) -> Any:
    with _threads_lock:
        handle = _threads.get(int(thread_id))
    if not handle:
        return None
    if handle.thread and handle.thread.is_alive():
        handle.thread.join(timeout=5.0)
    return handle.result


def thread_is_alive(thread_id: int) -> bool:
    with _threads_lock:
        handle = _threads.get(int(thread_id))
    if not handle:
        return False
    if handle.thread:
        return handle.thread.is_alive()
    return handle.is_alive


def thread_current_id() -> int:
    return threading.get_ident() & 0x7FFFFFFF


def thread_detach(thread_id: int) -> bool:
    with _threads_lock:
        handle = _threads.get(int(thread_id))
        if handle:
            handle.is_detached = True
            return True
        return False


# ──────────────────────────────────────────────────────────────────────────────
# Sistema e Escalonador
# ──────────────────────────────────────────────────────────────────────────────

def thread_hardware_concurrency() -> int:
    return os.cpu_count() or 1


def thread_sleep(milliseconds: int) -> bool:
    ms = max(0, int(milliseconds))
    if ms > 0:
        time.sleep(ms / 1000.0)
    return True


def thread_sleep_ms(milliseconds: int) -> bool:
    return thread_sleep(milliseconds)


def thread_yield() -> bool:
    time.sleep(0)
    return True
