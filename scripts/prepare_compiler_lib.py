import re

with open('build/intermediates/stage1.ll', 'r', encoding='utf-8') as f:
    s = f.read()

# 1. Delegate @flux_str_char_len and @flux_str_slice to O(1) C runtime (libfluxrt.a)
s = re.sub(
    r'define\s+(?:linkonce_odr\s+|internal\s+)?i64\s+@flux_str_char_len\([^\)]*\)\s*\{.*?\n\}',
    'declare i64 @flux_str_char_len(i8*)',
    s,
    count=1,
    flags=re.S
)
s = re.sub(
    r'define\s+(?:linkonce_odr\s+|internal\s+)?i8\*\s+@flux_str_slice\([^\)]*\)\s*\{.*?\n\}',
    'declare i8* @flux_str_slice(i8*, i64, i64)',
    s,
    count=1,
    flags=re.S
)

with open('build/intermediates/stage1.ll', 'w', encoding='utf-8', newline='\n') as f:
    f.write(s)

# 2. In stage1_compiler.ll:
#    - Rename main -> stage1_main and mark internal
#    - Mark ALL remaining @flux_* definitions as internal
sc = s.replace('define i32 @main(i32 %argc, i8** %argv) {', 'define internal i32 @stage1_main(i32 %argc, i8** %argv) {', 1)

sc = re.sub(r'define\s+(?:linkonce_odr\s+)?([a-zA-Z0-9_\*]+\s+@flux_[a-zA-Z0-9_]+)', r'define internal \1', sc)

with open('build/intermediates/stage1_compiler.ll', 'w', encoding='utf-8', newline='\n') as f:
    f.write(sc)

print("stage1.ll and stage1_compiler.ll prepared with libfluxrt O(1) UTF-8 slicing and internal symbols!")
