import os, subprocess, glob

tests = sorted(glob.glob("examples/Canon/ExampleOf*.flux"))[:20]
print(f"Testing {len(tests)} tests with fluxvm.exe...")
ok_count = 0
for t in tests:
    stem = os.path.splitext(os.path.basename(t))[0]
    fvmbc_path = f"t_fvmbc/{stem}.fvmbc"
    # generate fvmbc with python
    subprocess.run(f'cmd /c "set PYTHONPATH=src && python -m flux_proto \"{t}\" --target vmbc -o t_fvmbc/{stem}"', shell=True, capture_output=True)
    # run with fluxvm.exe
    res_vm = subprocess.run(f'.\\bin\\fluxvm.exe {fvmbc_path}', shell=True, capture_output=True, text=True)
    # run with python
    res_py = subprocess.run(f'cmd /c "set PYTHONPATH=src && python -X utf8 -c \"import json, sys; from flux_proto.vm.runtime import execute_bytecode; execute_bytecode(json.load(open(sys.argv[1], encoding=\'utf-8\')))\" {fvmbc_path}"', shell=True, capture_output=True, text=True)
    
    if res_vm.returncode == 0 and res_py.returncode == 0:
        ok_count += 1
    else:
        print(f"FAIL {stem}: vm_rc={res_vm.returncode}, py_rc={res_py.returncode}")
        if res_vm.stderr:
            print("  vm stderr:", res_vm.stderr.strip()[:200])

print(f"Result: {ok_count}/{len(tests)} OK")
