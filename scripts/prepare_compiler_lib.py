import re

with open('build/intermediates/stage1.ll', 'r', encoding='utf-8') as f:
    s = f.read()

# 1. Update clang command in stage1 to link -lfluxcompiler
s = s.replace(
    '([51 x i8], [51 x i8]* @.str.87, i32 0, i32 0)',
    '([66 x i8], [66 x i8]* @.str.87, i32 0, i32 0)',
    1
)
s = s.replace(
    '@.str.87 = private unnamed_addr constant [51 x i8] c".ll\\22 -Lbin -lfluxrt -ladvapi32 -lws2_32 -lkernel32\\00"',
    '@.str.87 = private unnamed_addr constant [66 x i8] c".ll\\22 -Lbin -lfluxcompiler -lfluxrt -ladvapi32 -lws2_32 -lkernel32\\00"',
    1
)

with open('build/intermediates/stage1.ll', 'w', encoding='utf-8', newline='\n') as f:
    f.write(s)

# 2. In stage1_compiler.ll:
#    - Rename main -> stage1_main and mark internal
#    - Mark ALL @flux_* functions as internal
sc = s.replace('define i32 @main(i32 %argc, i8** %argv) {', 'define internal i32 @stage1_main(i32 %argc, i8** %argv) {', 1)

# Regex to make every `define [linkage] <type> @flux_<name>(...)` internal:
# Avoid double internal if already internal
sc = re.sub(r'define\s+(?:linkonce_odr\s+)?([a-zA-Z0-9_\*]+\s+@flux_[a-zA-Z0-9_]+)', r'define internal \1', sc)

with open('build/intermediates/stage1_compiler.ll', 'w', encoding='utf-8', newline='\n') as f:
    f.write(sc)

print("stage1.ll and stage1_compiler.ll prepared with all flux_* internal!")
