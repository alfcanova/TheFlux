"""Local HTTP server for the web_wasm runner page.

Serves the project root (so /web_wasm/index.html and /t_wasm-1.0/*.wasm work)
and exposes GET /api/files with the listing of t_wasm-1.0/ as JSON.

Usage:
    python web_wasm/server.py [--port 8000]
"""
from __future__ import annotations

import argparse
import json
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WASM_DIR = ROOT / "t_wasm-1.0"


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        if self.path.startswith("/api/files") or self.path.endswith(".wasm"):
            self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def do_GET(self):
        if self.path == "/api/files":
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            files = sorted(
                p.name for p in WASM_DIR.iterdir() if p.is_file()
            )
            self.wfile.write(json.dumps(files).encode("utf-8"))
            return
        super().do_GET()

    def log_message(self, fmt, *args):
        print(f"[web_wasm] {self.address_string()} - {fmt % args}")


def main() -> None:
    parser = argparse.ArgumentParser(description="TheFlux web_wasm runner server")
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args()

    if not WASM_DIR.is_dir():
        print(f"Erro: pasta {WASM_DIR} nao encontrada.")
        raise SystemExit(1)

    httpd = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    print(f"Servidor rodando em http://localhost:{args.port}")
    print(f"Listando arquivos de: {WASM_DIR}")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nEncerrando...")


if __name__ == "__main__":
    main()
