import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
LEGACY_SRC = ROOT / "legacy" / "src"

def run_test(prog):
    print("=" * 60)
    print(f"TESTING: {prog}")
    print("=" * 60)
    
    # 1. Reference Compiler (legacy Stage 0)
    cmd1 = [sys.executable, "-c", f"import sys; sys.path.insert(0, r'{LEGACY_SRC}'); from flux_proto.cli import main; sys.argv=['flux_proto', '--target', 'run', r'{prog}']; main()"]
    r1 = subprocess.run(cmd1, cwd=ROOT, capture_output=True, text=True)
    print(f"1) Ground Truth (legacy Stage 0): code={r1.returncode}")
    lines1 = r1.stdout.strip().splitlines()
    print("   Output lines:", len(lines1))
    for l in lines1[:4]:
        print("   |", l)
    if len(lines1) > 4:
        print("   | ...")

    # 2. Self-hosted Compiler via Python
    cmd2 = [sys.executable, "-c", f"import sys; sys.path.insert(0, r'{ROOT / 'src'}'); sys.path.insert(0, r'{LEGACY_SRC}'); from flux_proto.cli import main; sys.argv=['flux_proto', '--target', 'run', r'src/main.flux', '--', '--target', 'in', r'{prog}']; main()"]
    r2 = subprocess.run(cmd2, cwd=ROOT, capture_output=True, text=True)
    print(f"2) Self-hosted (via Python): code={r2.returncode}")
    lines2 = r2.stdout.strip().splitlines()
    print("   Output lines:", len(lines2))
    for l in lines2[:4]:
        print("   |", l)
    if len(lines2) > 4:
        print("   | ...")

    # 3. Independent Binary (bin/fluxc.exe)
    fluxc_exe = ROOT / "bin" / "fluxc.exe"
    r3 = subprocess.run([str(fluxc_exe), "--target", "in", prog], cwd=ROOT, capture_output=True, text=True)
    print(f"3) Independent Binary (bin/fluxc.exe): code={r3.returncode}")
    lines3 = r3.stdout.strip().splitlines()
    print("   Output lines:", len(lines3))
    for l in lines3[:4]:
        print("   |", l)
    if len(lines3) > 4:
        print("   | ...")
    print()

if __name__ == "__main__":
    targets = [
        "flux/ExampleOfMut.flux",
        "flux/ExampleOfImut.flux",
        "flux/ExampleOfInteger.flux",
        "flux/ExampleOfPrint.flux",
        "flux/ExampleOfFloat.flux",
        "flux/ExampleOfChar.flux",
        "flux/ExampleOfString.flux",
        "flux/ExampleOfList.flux",
        "flux/ExampleOfMap.flux",
        "flux/ExampleOfSet.flux",
        "flux/ExampleOfStruct.flux",
    ]
    for t in targets:
        run_test(t)
