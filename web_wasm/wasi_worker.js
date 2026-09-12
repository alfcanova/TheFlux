/**
 * TheFlux - WASI Worker for Non-blocking Terminal Execution & Inline Input
 * Uses SharedArrayBuffer + Atomics.wait to pause WASM execution on stdin reads
 * without blocking the main browser UI thread.
 */

"use strict";

let sharedBuffer = null;
let int32View = null;
let uint8DataView = null;
let inputQueue = [];

const decoder = new TextDecoder("utf-8");
const encoder = new TextEncoder();

self.onmessage = async (e) => {
  const msg = e.data;
  if (msg.type === "start") {
    sharedBuffer = msg.sharedBuffer;
    if (sharedBuffer) {
      int32View = new Int32Array(sharedBuffer);
      uint8DataView = new Uint8Array(sharedBuffer, 16);
    }
    inputQueue = [];

    try {
      await runWasm(msg.wasmBytes);
    } catch (err) {
      self.postMessage({ type: "error", message: err.message });
    }
  }
};

async function runWasm(wasmBytes) {
  let instance = null;

  const wasiImportObject = {
    wasi_snapshot_preview1: {
      fd_write: (fd, iovsPtr, iovsLen, nwrittenPtr) => {
        if (fd !== 1 && fd !== 2) return 8; // EBADF
        const mem = new Uint8Array(instance.exports.memory.buffer);
        const view = new DataView(mem.buffer);
        let out = "";
        let total = 0;
        for (let i = 0; i < iovsLen; i++) {
          const ptr = view.getUint32(iovsPtr + i * 8, true);
          const len = view.getUint32(iovsPtr + i * 8 + 4, true);
          out += decoder.decode(mem.subarray(ptr, ptr + len));
          total += len;
        }
        view.setUint32(nwrittenPtr, total, true);
        self.postMessage({ type: "write", text: out });
        return 0; // SUCCESS
      },

      fd_read: (fd, iovsPtr, iovsLen, nreadPtr) => {
        if (fd !== 0) return 8; // EBADF

        // If local input queue is empty, wait for user input from main thread
        while (inputQueue.length === 0) {
          if (int32View && sharedBuffer) {
            // Signal main thread that terminal is now waiting for user keyboard input
            self.postMessage({ type: "wait_input" });

            // Ensure state is WAITING (0)
            Atomics.store(int32View, 0, 0);

            // Synchronously wait on Worker thread until main thread stores 1 and notifies
            Atomics.wait(int32View, 0, 0);

            // Worker woke up! Check if input is ready
            const state = Atomics.load(int32View, 0);
            if (state === 1) {
              const byteLen = Atomics.load(int32View, 1);
              for (let i = 0; i < byteLen; i++) {
                inputQueue.push(uint8DataView[i]);
              }
              // Reset state back to 0
              Atomics.store(int32View, 0, 0);
              break;
            } else if (state === 2) {
              // Aborted / terminated
              const view = new DataView(instance.exports.memory.buffer);
              view.setUint32(nreadPtr, 0, true);
              return 0;
            }
          } else {
            // Fallback if SharedArrayBuffer is not available
            self.postMessage({ type: "wait_input_fallback" });
            break;
          }
        }

        const mem = new Uint8Array(instance.exports.memory.buffer);
        const view = new DataView(mem.buffer);
        let totalRead = 0;

        for (let i = 0; i < iovsLen && inputQueue.length > 0; i++) {
          const ptr = view.getUint32(iovsPtr + i * 8, true);
          const len = view.getUint32(iovsPtr + i * 8 + 4, true);
          const toCopy = Math.min(len, inputQueue.length);
          for (let j = 0; j < toCopy; j++) {
            mem[ptr + j] = inputQueue.shift();
          }
          totalRead += toCopy;
        }

        view.setUint32(nreadPtr, totalRead, true);
        return 0;
      },

      proc_exit: (code) => {
        self.postMessage({ type: "exit", code });
        throw new Error(`WASI proc_exit called with code ${code}`);
      },

      environ_sizes_get: (environCountPtr, environBufSizePtr) => {
        const view = new DataView(instance.exports.memory.buffer);
        view.setUint32(environCountPtr, 0, true);
        view.setUint32(environBufSizePtr, 0, true);
        return 0;
      },

      environ_get: (_environPtr, _environBufPtr) => 0,

      args_sizes_get: (argcPtr, argvBufSizePtr) => {
        const view = new DataView(instance.exports.memory.buffer);
        view.setUint32(argcPtr, 0, true);
        view.setUint32(argvBufSizePtr, 0, true);
        return 0;
      },

      args_get: (_argvPtr, _argvBufPtr) => 0,

      clock_time_get: (_id, _precision, timePtr) => {
        const view = new DataView(instance.exports.memory.buffer);
        const nowNs = BigInt(Math.round(performance.now() * 1e6));
        view.setBigUint64(timePtr, nowNs, true);
        return 0;
      },

      fd_close: (_fd) => 0,
      fd_seek: (_fd, _offset, _whence, newOffsetPtr) => {
        const view = new DataView(instance.exports.memory.buffer);
        view.setBigUint64(newOffsetPtr, 0n, true);
        return 0;
      },
      fd_fdstat_get: (_fd, statPtr) => {
        const view = new DataView(instance.exports.memory.buffer);
        view.setUint8(statPtr, 2); // Filetype: Character Device
        view.setUint16(statPtr + 2, 0, true); // flags
        view.setBigUint64(statPtr + 8, 0n, true); // rights base
        view.setBigUint64(statPtr + 16, 0n, true); // rights inheriting
        return 0;
      },
      fd_fdstat_set_flags: (_fd, _flags) => 0,
      fd_prestat_get: (_fd, _prestatPtr) => 8, // EBADF
      fd_prestat_dir_name: (_fd, _pathPtr, _pathLen) => 8,
      random_get: (bufPtr, bufLen) => {
        const mem = new Uint8Array(instance.exports.memory.buffer);
        for (let i = 0; i < bufLen; i++) {
          mem[bufPtr + i] = Math.floor(Math.random() * 256);
        }
        return 0;
      }
    }
  };

  const result = await WebAssembly.instantiate(wasmBytes, wasiImportObject);
  instance = result.instance;

  if (typeof instance.exports._start === "function") {
    try {
      instance.exports._start();
    } catch (e) {
      if (!e.message.includes("WASI proc_exit")) {
        throw e;
      }
    }
  }

  self.postMessage({ type: "done" });
}
