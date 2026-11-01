"""Archive and container management helpers for TheFlux (TAR, GZ, BZ2, XZ, ZST, ZIP, 7z, RAR)."""
from __future__ import annotations

import io
import os
import shutil
import subprocess
import tarfile
import zipfile
from pathlib import Path

try:
    import zstandard as zstd
except ImportError:
    zstd = None


# ==============================================================================
# Security: Path Traversal Prevention (Anti-Zip Slip)
# ==============================================================================

def _is_safe_path(base_dir: str, target_path: str) -> bool:
    base = os.path.abspath(base_dir)
    target = os.path.abspath(target_path)
    return target.startswith(base) and (len(target) == len(base) or target[len(base)] in (os.sep, "/"))


def _locate_7z_binary() -> str | None:
    found = shutil.which("7z") or shutil.which("7za")
    if found:
        return found
    candidates = [
        r"C:\Program Files\7-Zip\7z.exe",
        r"C:\Program Files (x86)\7-Zip\7z.exe",
    ]
    for c in candidates:
        if os.path.exists(c):
            return c
    return None


# ==============================================================================
# TAR & Compressed TAR Containers
# ==============================================================================

def archive_tar(src_path: str, dst_tar: str) -> bool:
    return _create_tar_archive(src_path, dst_tar, mode="w")


def archive_tar_gz(src_path: str, dst_targz: str) -> bool:
    return _create_tar_archive(src_path, dst_targz, mode="w:gz")


def archive_tar_bz2(src_path: str, dst_tarbz2: str) -> bool:
    return _create_tar_archive(src_path, dst_tarbz2, mode="w:bz2")


def archive_tar_xz(src_path: str, dst_tarxz: str) -> bool:
    return _create_tar_archive(src_path, dst_tarxz, mode="w:xz")


def archive_tar_zst(src_path: str, dst_tarzst: str) -> bool:
    if zstd is None:
        return False
    try:
        buf = io.BytesIO()
        with tarfile.open(fileobj=buf, mode="w") as tar:
            _add_to_tar(tar, src_path)
        tar_bytes = buf.getvalue()

        cctx = zstd.ZstdCompressor(level=3)
        compressed = cctx.compress(tar_bytes)

        os.makedirs(os.path.dirname(os.path.abspath(dst_tarzst)), exist_ok=True)
        with open(dst_tarzst, "wb") as f:
            f.write(compressed)
        return True
    except Exception:
        return False


def _create_tar_archive(src_path: str, dst_path: str, mode: str) -> bool:
    if not os.path.exists(src_path):
        return False
    try:
        os.makedirs(os.path.dirname(os.path.abspath(dst_path)), exist_ok=True)
        with tarfile.open(dst_path, mode) as tar:
            _add_to_tar(tar, src_path)
        return True
    except Exception:
        return False


def _add_to_tar(tar: tarfile.TarFile, src_path: str) -> None:
    src_p = Path(src_path)
    if src_p.is_file():
        tar.add(str(src_p), arcname=src_p.name)
    elif src_p.is_dir():
        for root, dirs, files in os.walk(src_path):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, start=src_path)
                tar.add(full_path, arcname=rel_path)


def archive_extract_tar(src_tar: str, dst_dir: str) -> bool:
    if not os.path.exists(src_tar):
        return False
    try:
        os.makedirs(dst_dir, exist_ok=True)
        # Check if zstd tar
        if src_tar.endswith(".tar.zst") or src_tar.endswith(".tzst"):
            return _extract_tar_zst(src_tar, dst_dir)

        with tarfile.open(src_tar, "r:*") as tar:
            for member in tar.getmembers():
                dest_file = os.path.join(dst_dir, member.name)
                if not _is_safe_path(dst_dir, dest_file):
                    continue  # Skip dangerous Zip Slip entry
                tar.extract(member, path=dst_dir)
        return True
    except Exception:
        return False


def archive_extract_tar_gz(src_targz: str, dst_dir: str) -> bool:
    return archive_extract_tar(src_targz, dst_dir)


def archive_extract_tar_bz2(src_tarbz2: str, dst_dir: str) -> bool:
    return archive_extract_tar(src_tarbz2, dst_dir)


def archive_extract_tar_xz(src_tarxz: str, dst_dir: str) -> bool:
    return archive_extract_tar(src_tarxz, dst_dir)


def archive_extract_tar_zst(src_tarzst: str, dst_dir: str) -> bool:
    return _extract_tar_zst(src_tarzst, dst_dir)


def _extract_tar_zst(src_tarzst: str, dst_dir: str) -> bool:
    if zstd is None or not os.path.exists(src_tarzst):
        return False
    try:
        os.makedirs(dst_dir, exist_ok=True)
        with open(src_tarzst, "rb") as f:
            compressed = f.read()
        dctx = zstd.ZstdDecompressor()
        tar_bytes = dctx.decompress(compressed)

        buf = io.BytesIO(tar_bytes)
        with tarfile.open(fileobj=buf, mode="r:*") as tar:
            for member in tar.getmembers():
                dest_file = os.path.join(dst_dir, member.name)
                if not _is_safe_path(dst_dir, dest_file):
                    continue
                tar.extract(member, path=dst_dir)
        return True
    except Exception:
        return False


# ==============================================================================
# ZIP Containers
# ==============================================================================

def archive_zip(src_path: str, dst_zip: str) -> bool:
    if not os.path.exists(src_path):
        return False
    try:
        os.makedirs(os.path.dirname(os.path.abspath(dst_zip)), exist_ok=True)
        with zipfile.ZipFile(dst_zip, "w", zipfile.ZIP_DEFLATED) as zf:
            src_p = Path(src_path)
            if src_p.is_file():
                zf.write(str(src_p), arcname=src_p.name)
            elif src_p.is_dir():
                for root, _, files in os.walk(src_path):
                    for file in files:
                        full_path = os.path.join(root, file)
                        rel_path = os.path.relpath(full_path, start=src_path)
                        zf.write(full_path, arcname=rel_path)
        return True
    except Exception:
        return False


def archive_unzip(src_zip: str, dst_dir: str) -> bool:
    if not os.path.exists(src_zip):
        return False
    try:
        os.makedirs(dst_dir, exist_ok=True)
        with zipfile.ZipFile(src_zip, "r") as zf:
            for member in zf.namelist():
                dest_file = os.path.join(dst_dir, member)
                if not _is_safe_path(dst_dir, dest_file):
                    continue
                zf.extract(member, path=dst_dir)
        return True
    except Exception:
        return False


# ==============================================================================
# 7-Zip (.7z) Containers
# ==============================================================================

def archive_create_7z(src_path: str, dst_7z: str) -> bool:
    if not os.path.exists(src_path):
        return False
    bin_7z = _locate_7z_binary()
    if bin_7z:
        try:
            os.makedirs(os.path.dirname(os.path.abspath(dst_7z)), exist_ok=True)
            if os.path.exists(dst_7z):
                os.remove(dst_7z)
            target = src_path + "\\*" if os.path.isdir(src_path) else src_path
            cmd = [bin_7z, "a", "-t7z", dst_7z, target, "-y"]
            res = subprocess.run(cmd, capture_output=True, timeout=30)
            return res.returncode == 0 and os.path.exists(dst_7z)
        except Exception:
            pass

    # Fallback to tar.xz or zip if 7z binary is unavailable
    return archive_tar_xz(src_path, dst_7z)


def archive_extract_7z(src_7z: str, dst_dir: str) -> bool:
    if not os.path.exists(src_7z):
        return False
    bin_7z = _locate_7z_binary()
    if bin_7z:
        try:
            os.makedirs(dst_dir, exist_ok=True)
            cmd = [bin_7z, "x", f"-o{dst_dir}", src_7z, "-y"]
            res = subprocess.run(cmd, capture_output=True, timeout=30)
            return res.returncode == 0
        except Exception:
            pass

    # Fallback to tar.xz or zip
    try:
        return archive_extract_tar(src_7z, dst_dir)
    except Exception:
        return False


# ==============================================================================
# RAR (.rar) Containers (Extraction Only)
# ==============================================================================

def archive_extract_rar(src_rar: str, dst_dir: str) -> bool:
    if not os.path.exists(src_rar):
        return False
    # 7-Zip extracts RAR natively!
    bin_7z = _locate_7z_binary()
    if bin_7z:
        try:
            os.makedirs(dst_dir, exist_ok=True)
            cmd = [bin_7z, "x", f"-o{dst_dir}", src_rar, "-y"]
            res = subprocess.run(cmd, capture_output=True, timeout=30)
            return res.returncode == 0
        except Exception:
            pass

    # Fallback check for unrar CLI
    unrar = shutil.which("unrar")
    if unrar:
        try:
            os.makedirs(dst_dir, exist_ok=True)
            cmd = [unrar, "x", "-y", src_rar, dst_dir]
            res = subprocess.run(cmd, capture_output=True, timeout=30)
            return res.returncode == 0
        except Exception:
            pass

    return False


# ==============================================================================
# Inspection and Partial Extraction
# ==============================================================================

def archive_list_files(archive_path: str) -> list[str]:
    if not os.path.exists(archive_path):
        return []
    fmt = archive_detect_format(archive_path)

    # 1. ZIP
    if fmt == "zip":
        try:
            with zipfile.ZipFile(archive_path, "r") as zf:
                return zf.namelist()
        except Exception:
            return []

    # 2. TAR and compressed TAR
    if fmt in ("tar", "tar.gz", "tar.bz2", "tar.xz"):
        try:
            with tarfile.open(archive_path, "r:*") as tar:
                return [m.name for m in tar.getmembers()]
        except Exception:
            return []

    # 3. TAR.ZST
    if fmt == "tar.zst" and zstd is not None:
        try:
            with open(archive_path, "rb") as f:
                compressed = f.read()
            dctx = zstd.ZstdDecompressor()
            tar_bytes = dctx.decompress(compressed)
            with tarfile.open(fileobj=io.BytesIO(tar_bytes), mode="r:*") as tar:
                return [m.name for m in tar.getmembers()]
        except Exception:
            return []

    # 4. 7-Zip or RAR via 7z CLI
    bin_7z = _locate_7z_binary()
    if bin_7z:
        try:
            cmd = [bin_7z, "l", "-slt", archive_path]
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
            if res.returncode == 0:
                files = []
                for line in res.stdout.splitlines():
                    if line.startswith("Path = "):
                        p = line[7:].strip()
                        if p and p != archive_path and not p.endswith(os.path.basename(archive_path)):
                            files.append(p)
                if files:
                    return files
        except Exception:
            pass

    return []


def archive_extract_file(archive_path: str, entry_name: str, dst_dir: str) -> bool:
    if not os.path.exists(archive_path):
        return False
    fmt = archive_detect_format(archive_path)
    os.makedirs(dst_dir, exist_ok=True)

    if fmt == "zip":
        try:
            with zipfile.ZipFile(archive_path, "r") as zf:
                dest_file = os.path.join(dst_dir, entry_name)
                if not _is_safe_path(dst_dir, dest_file):
                    return False
                zf.extract(entry_name, path=dst_dir)
                return True
        except Exception:
            return False

    if fmt in ("tar", "tar.gz", "tar.bz2", "tar.xz"):
        try:
            with tarfile.open(archive_path, "r:*") as tar:
                member = tar.getmember(entry_name)
                dest_file = os.path.join(dst_dir, member.name)
                if not _is_safe_path(dst_dir, dest_file):
                    return False
                tar.extract(member, path=dst_dir)
                return True
        except Exception:
            return False

    bin_7z = _locate_7z_binary()
    if bin_7z:
        try:
            cmd = [bin_7z, "e", f"-o{dst_dir}", archive_path, entry_name, "-y"]
            res = subprocess.run(cmd, capture_output=True, timeout=15)
            return res.returncode == 0
        except Exception:
            pass

    return False


def archive_is_archive(file_path: str) -> bool:
    return archive_detect_format(file_path) != "unknown"


def archive_detect_format(file_path: str) -> str:
    if not os.path.exists(file_path) or not os.path.isfile(file_path):
        return "unknown"

    lower = file_path.lower()
    if lower.endswith(".tar.gz") or lower.endswith(".tgz"):
        return "tar.gz"
    if lower.endswith(".tar.bz2") or lower.endswith(".tbz2"):
        return "tar.bz2"
    if lower.endswith(".tar.xz") or lower.endswith(".txz"):
        return "tar.xz"
    if lower.endswith(".tar.zst") or lower.endswith(".tzst"):
        return "tar.zst"
    if lower.endswith(".tar"):
        return "tar"
    if lower.endswith(".zip"):
        return "zip"
    if lower.endswith(".7z"):
        return "7z"
    if lower.endswith(".rar"):
        return "rar"

    # Magic byte inspection
    try:
        with open(file_path, "rb") as f:
            head = f.read(512)
        if not head:
            return "unknown"
        if head.startswith((b"PK\x03\x04", b"PK\x05\x06", b"PK\x07\x08")):
            return "zip"
        if head.startswith(b"7z\xbc\xaf\x27\x1c"):
            return "7z"
        if head.startswith((b"Rar!\x1a\x07\x00", b"Rar!\x1a\x07\x01\x00")):
            return "rar"
        if head.startswith(b"\x1f\x8b"):
            return "tar.gz"
        if head.startswith(b"BZ"):
            return "tar.bz2"
        if head.startswith(b"\xfd7zXZ\x00"):
            return "tar.xz"
        if head.startswith(b"\x28\xb5\x2f\xfd"):
            return "tar.zst"
        if len(head) >= 262 and head[257:262] == b"ustar":
            return "tar"
    except Exception:
        pass

    return "unknown"
