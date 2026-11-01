; ModuleID = 'Main'
target triple = "x86_64-pc-windows-msvc"

%flux.result = type { i8*, i64, double, i8* }

declare %flux.result @f_diagnosticExplain(i8*)
declare %flux.result @f_diagnosticGetHeader(i8*, i8*)
declare %flux.result @f_diagnosticGetHint(i8*)
declare %flux.result @f_parseFile(i8*)
declare %flux.result @f_parseDumpAst(i8*)
declare %flux.result @f_semanticAnalyze(i8*, i64)
declare %flux.result @f_fmirBuildFromAst(i8*, i64)
declare %flux.result @f_fmirDumpText(i8*)
declare %flux.result @f_backendCompile(i8*, i8*, i8*)

declare void @flux_runtime_init_args(i32, i8**)
declare i32 @printf(i8*, ...)
declare i32 @fflush(i8*)
declare void @exit(i32)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i64 @strlen(i8*)
declare i32 @strcmp(i8*, i8*)
declare i32 @snprintf(i8*, i64, i8*, ...)
declare double @pow(double, double)
declare double @llvm.sqrt.f64(double)
declare i8* @flux_str_concat(i8*, i8*)
declare i32 @flux_str_compare(i8*, i8*)
declare i8* @flux_str_slice(i8*, i64, i64)
declare i64 @flux_str_len(i8*)
declare i8* @flux_list_create(i64)
declare void @flux_list_push_val(i8*, i64)
declare i64 @flux_list_get_val(i8*, i64)
declare i64 @flux_list_get(i8*, i64)
declare void @flux_list_set(i8*, i64, i64)
declare i64 @flux_list_len(i8*)
declare i8* @flux_map_build(i64)
declare void @flux_list_print(i8*)
declare void @flux_map_print(i8*)
declare i8* @flux_map_set(i8*, i8*, i64, i64)
declare i64 @flux_map_get(i8*, i8*)
declare i64 @flux_map_get_tag(i8*, i8*)
declare i1 @flux_map_contains_key(i8*, i8*)
declare i64 @flux_map_len(i8*)
declare i64 @flux_std_io_read_file(i8*)
declare i64 @flux_std_io_write_file(i8*, i8*)
declare i64 @flux_std_io_file_exists(i8*)
declare i64 @flux_std_io_delete_file(i8*)
declare i64 @flux_std_os_exec(i8*)
declare i64 @flux_std_os_exit(i64)
declare i8* @flux_list_build(i64, i64)
declare i8* @flux_list_push(i8*, i64, i64, i8*)
declare i8* @flux_std_runtime_get_args(i8* (i64, i64)*, i8* (i8*, i64, i64, i8*)*)
declare i64 @flux_std_datetime_now()
declare i64 @flux_std_datetime_monotonic_now()
declare i64 @flux_std_datetime_monotonic_elapsed(i64)

@.fmt_int = private unnamed_addr constant [5 x i8] c"%ld\0A\00", align 1
@.fmt_int_val = private unnamed_addr constant [4 x i8] c"%ld\00", align 1
@.fmt_str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt_str_val = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.fmt_float = private unnamed_addr constant [7 x i8] c"%.17g\0A\00", align 1
@.fmt_float_val = private unnamed_addr constant [6 x i8] c"%.17g\00", align 1
@.str_true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str_false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

@.str.0 = private unnamed_addr constant [4 x i8] c"sta\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"val\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"nice\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"ok\00", align 1
@.str.5 = private unnamed_addr constant [24 x i8] c"TheFlux Compiler v0.9.9\00", align 1
@.str.6 = private unnamed_addr constant [36 x i8] c"Usage: fluxc [options] <input.flux>\00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"Options:\00", align 1
@.str.8 = private unnamed_addr constant [55 x i8] c"  --version, -v               Display compiler version\00", align 1
@.str.9 = private unnamed_addr constant [76 x i8] c"  --target <target>           Target backend (in, vm, vmr, llvm, wat, wasm)\00", align 1
@.str.10 = private unnamed_addr constant [49 x i8] c"  -o, --output <path>         Output destination\00", align 1
@.str.11 = private unnamed_addr constant [44 x i8] c"  --emit-ast                  Dump AST JSON\00", align 1
@.str.12 = private unnamed_addr constant [43 x i8] c"  --emit-fmir                 Dump FMIR IR\00", align 1
@.str.13 = private unnamed_addr constant [49 x i8] c"  --emit-llvm                 Emit LLVM IR (.ll)\00", align 1
@.str.14 = private unnamed_addr constant [59 x i8] c"  --emit-wat                  Emit WebAssembly Text (.wat)\00", align 1
@.str.15 = private unnamed_addr constant [54 x i8] c"  --explain <code>            Explain diagnostic code\00", align 1
@.str.16 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"in\00", align 1
@.str.18 = private unnamed_addr constant [4 x i8] c"out\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"--version\00", align 1
@.str.20 = private unnamed_addr constant [3 x i8] c"-v\00", align 1
@.str.21 = private unnamed_addr constant [9 x i8] c"--target\00", align 1
@.str.22 = private unnamed_addr constant [3 x i8] c"-o\00", align 1
@.str.23 = private unnamed_addr constant [9 x i8] c"--output\00", align 1
@.str.24 = private unnamed_addr constant [11 x i8] c"--emit-ast\00", align 1
@.str.25 = private unnamed_addr constant [12 x i8] c"--emit-fmir\00", align 1
@.str.26 = private unnamed_addr constant [12 x i8] c"--emit-llvm\00", align 1
@.str.27 = private unnamed_addr constant [11 x i8] c"--emit-wat\00", align 1
@.str.28 = private unnamed_addr constant [9 x i8] c"--no-run\00", align 1
@.str.29 = private unnamed_addr constant [10 x i8] c"--explain\00", align 1
@.str.30 = private unnamed_addr constant [2 x i8] c"\22\00", align 1
@.str.31 = private unnamed_addr constant [3 x i8] c" \22\00", align 1
@.str.32 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.33 = private unnamed_addr constant [6 x i8] c"0.9.9\00", align 1
@.str.34 = private unnamed_addr constant [32 x i8] c"Error: No input file specified.\00", align 1
@.str.35 = private unnamed_addr constant [18 x i8] c"#L EXPECT_ERROR: \00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.37 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.38 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.39 = private unnamed_addr constant [14 x i8] c"  \F0\9F\92\A1 Dica: \00", align 1
@.str.40 = private unnamed_addr constant [11 x i8] c"compliance\00", align 1
@.str.41 = private unnamed_addr constant [9 x i8] c"exemplos\00", align 1
@.str.42 = private unnamed_addr constant [9 x i8] c"examples\00", align 1
@.str.43 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.44 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_BE.exe\00", align 1
@.str.45 = private unnamed_addr constant [14 x i8] c"compliance_BE\00", align 1
@.str.46 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_BE.exe\00", align 1
@.str.47 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_IN.exe\00", align 1
@.str.48 = private unnamed_addr constant [14 x i8] c"compliance_IN\00", align 1
@.str.49 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_IN.exe\00", align 1
@.str.50 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_NR.exe\00", align 1
@.str.51 = private unnamed_addr constant [14 x i8] c"compliance_NR\00", align 1
@.str.52 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_NR.exe\00", align 1
@.str.53 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_SA.exe\00", align 1
@.str.54 = private unnamed_addr constant [14 x i8] c"compliance_SA\00", align 1
@.str.55 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_SA.exe\00", align 1
@.str.56 = private unnamed_addr constant [19 x i8] c"bin\5Ccompliance.exe\00", align 1
@.str.57 = private unnamed_addr constant [21 x i8] c".\5Cbin\5Ccompliance.exe\00", align 1
@.str.58 = private unnamed_addr constant [12 x i8] c"examples_in\00", align 1
@.str.59 = private unnamed_addr constant [12 x i8] c"examples_lv\00", align 1
@.str.60 = private unnamed_addr constant [12 x i8] c"examples_vm\00", align 1
@.str.61 = private unnamed_addr constant [13 x i8] c"examples_vmr\00", align 1
@.str.62 = private unnamed_addr constant [13 x i8] c"examples_was\00", align 1
@.str.63 = private unnamed_addr constant [13 x i8] c"examples_wat\00", align 1
@.str.64 = private unnamed_addr constant [12 x i8] c"exemplos_in\00", align 1
@.str.65 = private unnamed_addr constant [12 x i8] c"exemplos_lv\00", align 1
@.str.66 = private unnamed_addr constant [12 x i8] c"exemplos_vm\00", align 1
@.str.67 = private unnamed_addr constant [13 x i8] c"exemplos_vmr\00", align 1
@.str.68 = private unnamed_addr constant [13 x i8] c"exemplos_was\00", align 1
@.str.69 = private unnamed_addr constant [13 x i8] c"exemplos_wat\00", align 1
@.str.70 = private unnamed_addr constant [5 x i8] c"bin\5C\00", align 1
@.str.71 = private unnamed_addr constant [5 x i8] c".exe\00", align 1
@.str.72 = private unnamed_addr constant [7 x i8] c".\5Cbin\5C\00", align 1
@.str.73 = private unnamed_addr constant [4 x i8] c"vmr\00", align 1
@.str.74 = private unnamed_addr constant [7 x i8] c".fvmbc\00", align 1
@.str.75 = private unnamed_addr constant [19 x i8] c".\5Cbin\5Cfluxvm.exe \22\00", align 1
@.str.76 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.77 = private unnamed_addr constant [14 x i8] c"Parse Error: \00", align 1
@.str.78 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.79 = private unnamed_addr constant [6 x i8] c"arena\00", align 1
@.str.80 = private unnamed_addr constant [8 x i8] c"root_id\00", align 1
@.str.81 = private unnamed_addr constant [19 x i8] c"intermediates/ast/\00", align 1
@.str.82 = private unnamed_addr constant [6 x i8] c".json\00", align 1
@.str.83 = private unnamed_addr constant [7 x i8] c"errors\00", align 1
@.str.84 = private unnamed_addr constant [7 x i8] c"output\00", align 1
@.str.85 = private unnamed_addr constant [30 x i8] c"Compilation Error on target: \00", align 1
@.str.86 = private unnamed_addr constant [5 x i8] c"llvm\00", align 1
@.str.87 = private unnamed_addr constant [3 x i8] c"lv\00", align 1
@.str.88 = private unnamed_addr constant [65 x i8] c"clang -O2 -Wno-deprecated-declarations -Wno-override-module -o \22\00", align 1
@.str.89 = private unnamed_addr constant [8 x i8] c".exe\22 \22\00", align 1
@.str.90 = private unnamed_addr constant [66 x i8] c".ll\22 -Lbin -lfluxcompiler -lfluxrt -ladvapi32 -lws2_32 -lkernel32\00", align 1
@.str.91 = private unnamed_addr constant [6 x i8] c".exe\22\00", align 1
@.str.92 = private unnamed_addr constant [8 x i8] c".fvmbc\22\00", align 1
@.str.93 = private unnamed_addr constant [4 x i8] c"wat\00", align 1
@.str.94 = private unnamed_addr constant [13 x i8] c"wasmer run \22\00", align 1
@.str.95 = private unnamed_addr constant [6 x i8] c".wat\22\00", align 1
@.str.96 = private unnamed_addr constant [5 x i8] c"wasm\00", align 1
@.str.97 = private unnamed_addr constant [4 x i8] c"was\00", align 1
@.str.98 = private unnamed_addr constant [7 x i8] c".wasm\22\00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @flux_runtime_init_args(i32 %argc, i8** %argv)
  %args = alloca i64, align 8
  %n_args = alloca i64, align 8
  %input_file = alloca i64, align 8
  %extra_args = alloca i64, align 8
  %target = alloca i64, align 8
  %output_path = alloca i64, align 8
  %flag_version = alloca i64, align 8
  %flag_no_run = alloca i64, align 8
  %flag_emit_ast = alloca i64, align 8
  %flag_emit_fmir = alloca i64, align 8
  %flag_emit_llvm = alloca i64, align 8
  %flag_emit_wat = alloca i64, align 8
  %explain_code = alloca i64, align 8
  %i = alloca i64, align 8
  %arg = alloca i64, align 8
  %explanation = alloca i64, align 8
  %src_code = alloca i64, align 8
  %src_len = alloca i64, align 8
  %exp_err = alloca i64, align 8
  %exp_pref = alloca i64, align 8
  %slast = alloca i64, align 8
  %elen = alloca i64, align 8
  %c6 = alloca i64, align 8
  %err_hdr = alloca i64, align 8
  %err_hint = alloca i64, align 8
  %in_len = alloca i64, align 8
  %is_compliance = alloca i64, align 8
  %ck = alloca i64, align 8
  %is_exemplos = alloca i64, align 8
  %ek = alloca i64, align 8
  %arg_suffix = alloca i64, align 8
  %bi = alloca i64, align 8
  %rc = alloca i64, align 8
  %ex_names = alloca i64, align 8
  %eni = alloca i64, align 8
  %enm = alloca i64, align 8
  %enmlen = alloca i64, align 8
  %ebi = alloca i64, align 8
  %bin_name = alloca i64, align 8
  %vm_cmd = alloca i64, align 8
  %vm_rc = alloca i64, align 8
  %parse_res = alloca i64, align 8
  %arena = alloca i64, align 8
  %root_id = alloca i64, align 8
  %ast_json = alloca i64, align 8
  %sem_report = alloca i64, align 8
  %errors = alloca i64, align 8
  %n_err = alloca i64, align 8
  %ei = alloca i64, align 8
  %fmir_mod = alloca i64, align 8
  %fmir_dump = alloca i64, align 8
  %options = alloca i64, align 8
  %comp_res = alloca i64, align 8
  %clang_cmd = alloca i64, align 8
  %cl_rc = alloca i64, align 8
  %r_rc = alloca i64, align 8
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %args, align 8
  %t2_i64 = load i64, i64* %args, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t3 = call i64 @flux_list_len(i8* %t2)
  store i64 %t3, i64* %n_args, align 8
  %t6 = load i64, i64* %n_args, align 8
  %t7 = add i64 0, 1
  %t8 = icmp slt i64 %t6, %t7
  br i1 %t8, label %ft_0, label %route_arm_5
ft_0:
  %t9 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.5, i32 0, i32 0
  %pr_sn_1 = icmp eq i8* %t9, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t9
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  %t10 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.6, i32 0, i32 0
  %pr_sn_2 = icmp eq i8* %t10, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t10
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  %t11 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.7, i32 0, i32 0
  %pr_sn_3 = icmp eq i8* %t11, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t11
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  %t12 = getelementptr inbounds [55 x i8], [55 x i8]* @.str.8, i32 0, i32 0
  %pr_sn_4 = icmp eq i8* %t12, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t12
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  %t13 = getelementptr inbounds [76 x i8], [76 x i8]* @.str.9, i32 0, i32 0
  %pr_sn_5 = icmp eq i8* %t13, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t13
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  %t14 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.10, i32 0, i32 0
  %pr_sn_6 = icmp eq i8* %t14, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t14
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  %t15 = getelementptr inbounds [44 x i8], [44 x i8]* @.str.11, i32 0, i32 0
  %pr_sn_7 = icmp eq i8* %t15, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t15
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  %t16 = getelementptr inbounds [43 x i8], [43 x i8]* @.str.12, i32 0, i32 0
  %pr_sn_8 = icmp eq i8* %t16, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t16
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  %t17 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.13, i32 0, i32 0
  %pr_sn_9 = icmp eq i8* %t17, null
  %pr_sc_9 = select i1 %pr_sn_9, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t17
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_9)
  call i32 @fflush(i8* null)
  %t18 = getelementptr inbounds [59 x i8], [59 x i8]* @.str.14, i32 0, i32 0
  %pr_sn_10 = icmp eq i8* %t18, null
  %pr_sc_10 = select i1 %pr_sn_10, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t18
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_10)
  call i32 @fflush(i8* null)
  %t19 = getelementptr inbounds [54 x i8], [54 x i8]* @.str.15, i32 0, i32 0
  %pr_sn_11 = icmp eq i8* %t19, null
  %pr_sc_11 = select i1 %pr_sn_11, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t19
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_11)
  call i32 @fflush(i8* null)
  br label %route_end_4
route_arm_5:
  %t21 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %st_3 = ptrtoint i8* %t21 to i64
  store i64 %st_3, i64* %input_file, align 8
  %t22 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %st_4 = ptrtoint i8* %t22 to i64
  store i64 %st_4, i64* %extra_args, align 8
  %t23 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.17, i32 0, i32 0
  %st_5 = ptrtoint i8* %t23 to i64
  store i64 %st_5, i64* %target, align 8
  %t24 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.18, i32 0, i32 0
  %st_6 = ptrtoint i8* %t24 to i64
  store i64 %st_6, i64* %output_path, align 8
  %t25 = add i1 0, 0
  %st_b_7 = zext i1 %t25 to i64
  store i64 %st_b_7, i64* %flag_version, align 8
  %t26 = add i1 0, 0
  %st_b_8 = zext i1 %t26 to i64
  store i64 %st_b_8, i64* %flag_no_run, align 8
  %t27 = add i1 0, 0
  %st_b_9 = zext i1 %t27 to i64
  store i64 %st_b_9, i64* %flag_emit_ast, align 8
  %t28 = add i1 0, 0
  %st_b_10 = zext i1 %t28 to i64
  store i64 %st_b_10, i64* %flag_emit_fmir, align 8
  %t29 = add i1 0, 0
  %st_b_11 = zext i1 %t29 to i64
  store i64 %st_b_11, i64* %flag_emit_llvm, align 8
  %t30 = add i1 0, 0
  %st_b_12 = zext i1 %t30 to i64
  store i64 %st_b_12, i64* %flag_emit_wat, align 8
  %t31 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %st_13 = ptrtoint i8* %t31 to i64
  store i64 %st_13, i64* %explain_code, align 8
  %t32 = add i64 0, 1
  store i64 %t32, i64* %i, align 8
  br label %loop_start_33
loop_start_33:
  %t36 = load i64, i64* %i, align 8
  %t37 = load i64, i64* %n_args, align 8
  %t38 = icmp sgt i64 %t36, %t37
  br i1 %t38, label %ft_1, label %route_arm_35
ft_1:
  br label %loop_end_33
route_arm_35:
  %t40 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t41_i64 = load i64, i64* %args, align 8
  %t41 = inttoptr i64 %t41_i64 to i8*
  %t42 = load i64, i64* %i, align 8
  %t43_raw = call i64 @flux_list_get_val(i8* %t41, i64 %t42)
  %t43 = inttoptr i64 %t43_raw to i8*
  %t44 = call i8* @flux_str_concat(i8* %t40, i8* %t43)
  %st_15 = ptrtoint i8* %t44 to i64
  store i64 %st_15, i64* %arg, align 8
  %t47_i64 = load i64, i64* %arg, align 8
  %t47 = inttoptr i64 %t47_i64 to i8*
  %t48 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.19, i32 0, i32 0
  %t49_cmp = call i32 @flux_str_compare(i8* %t47, i8* %t48)
  %t49 = icmp eq i32 %t49_cmp, 0
  %t50_i64 = load i64, i64* %arg, align 8
  %t50 = inttoptr i64 %t50_i64 to i8*
  %t51 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.20, i32 0, i32 0
  %t52_cmp = call i32 @flux_str_compare(i8* %t50, i8* %t51)
  %t52 = icmp eq i32 %t52_cmp, 0
  %t53 = or i1 %t49, %t52
  br i1 %t53, label %ft_2, label %route_arm_46
ft_2:
  %t54 = add i1 0, 1
  %st_b_16 = zext i1 %t54 to i64
  store i64 %st_b_16, i64* %flag_version, align 8
  br label %route_end_45
route_arm_46:
  %t56_i64 = load i64, i64* %arg, align 8
  %t56 = inttoptr i64 %t56_i64 to i8*
  %t57 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.21, i32 0, i32 0
  %t58_cmp = call i32 @flux_str_compare(i8* %t56, i8* %t57)
  %t58 = icmp eq i32 %t58_cmp, 0
  br i1 %t58, label %ft_3, label %route_arm_55
ft_3:
  %t59 = load i64, i64* %i, align 8
  %t60 = add i64 0, 1
  %t61 = add i64 %t59, %t60
  store i64 %t61, i64* %i, align 8
  %t64 = load i64, i64* %i, align 8
  %t65 = load i64, i64* %n_args, align 8
  %t66 = icmp sle i64 %t64, %t65
  br i1 %t66, label %ft_4, label %route_arm_63
ft_4:
  %t67 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t68_i64 = load i64, i64* %args, align 8
  %t68 = inttoptr i64 %t68_i64 to i8*
  %t69 = load i64, i64* %i, align 8
  %t70_raw = call i64 @flux_list_get_val(i8* %t68, i64 %t69)
  %t70 = inttoptr i64 %t70_raw to i8*
  %t71 = call i8* @flux_str_concat(i8* %t67, i8* %t70)
  %st_18 = ptrtoint i8* %t71 to i64
  store i64 %st_18, i64* %target, align 8
  br label %route_end_62
route_arm_63:
  br label %route_end_62
route_end_62:
  br label %route_end_45
route_arm_55:
  %t74_i64 = load i64, i64* %arg, align 8
  %t74 = inttoptr i64 %t74_i64 to i8*
  %t75 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.22, i32 0, i32 0
  %t76_cmp = call i32 @flux_str_compare(i8* %t74, i8* %t75)
  %t76 = icmp eq i32 %t76_cmp, 0
  %t77_i64 = load i64, i64* %arg, align 8
  %t77 = inttoptr i64 %t77_i64 to i8*
  %t78 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.23, i32 0, i32 0
  %t79_cmp = call i32 @flux_str_compare(i8* %t77, i8* %t78)
  %t79 = icmp eq i32 %t79_cmp, 0
  %t80 = or i1 %t76, %t79
  br i1 %t80, label %ft_5, label %route_arm_73
ft_5:
  %t81 = load i64, i64* %i, align 8
  %t82 = add i64 0, 1
  %t83 = add i64 %t81, %t82
  store i64 %t83, i64* %i, align 8
  %t86 = load i64, i64* %i, align 8
  %t87 = load i64, i64* %n_args, align 8
  %t88 = icmp sle i64 %t86, %t87
  br i1 %t88, label %ft_6, label %route_arm_85
ft_6:
  %t89 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t90_i64 = load i64, i64* %args, align 8
  %t90 = inttoptr i64 %t90_i64 to i8*
  %t91 = load i64, i64* %i, align 8
  %t92_raw = call i64 @flux_list_get_val(i8* %t90, i64 %t91)
  %t92 = inttoptr i64 %t92_raw to i8*
  %t93 = call i8* @flux_str_concat(i8* %t89, i8* %t92)
  %st_20 = ptrtoint i8* %t93 to i64
  store i64 %st_20, i64* %output_path, align 8
  br label %route_end_84
route_arm_85:
  br label %route_end_84
route_end_84:
  br label %route_end_45
route_arm_73:
  %t96_i64 = load i64, i64* %arg, align 8
  %t96 = inttoptr i64 %t96_i64 to i8*
  %t97 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.24, i32 0, i32 0
  %t98_cmp = call i32 @flux_str_compare(i8* %t96, i8* %t97)
  %t98 = icmp eq i32 %t98_cmp, 0
  br i1 %t98, label %ft_7, label %route_arm_95
ft_7:
  %t99 = add i1 0, 1
  %st_b_21 = zext i1 %t99 to i64
  store i64 %st_b_21, i64* %flag_emit_ast, align 8
  br label %route_end_45
route_arm_95:
  %t101_i64 = load i64, i64* %arg, align 8
  %t101 = inttoptr i64 %t101_i64 to i8*
  %t102 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.25, i32 0, i32 0
  %t103_cmp = call i32 @flux_str_compare(i8* %t101, i8* %t102)
  %t103 = icmp eq i32 %t103_cmp, 0
  br i1 %t103, label %ft_8, label %route_arm_100
ft_8:
  %t104 = add i1 0, 1
  %st_b_22 = zext i1 %t104 to i64
  store i64 %st_b_22, i64* %flag_emit_fmir, align 8
  br label %route_end_45
route_arm_100:
  %t106_i64 = load i64, i64* %arg, align 8
  %t106 = inttoptr i64 %t106_i64 to i8*
  %t107 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.26, i32 0, i32 0
  %t108_cmp = call i32 @flux_str_compare(i8* %t106, i8* %t107)
  %t108 = icmp eq i32 %t108_cmp, 0
  br i1 %t108, label %ft_9, label %route_arm_105
ft_9:
  %t109 = add i1 0, 1
  %st_b_23 = zext i1 %t109 to i64
  store i64 %st_b_23, i64* %flag_emit_llvm, align 8
  br label %route_end_45
route_arm_105:
  %t111_i64 = load i64, i64* %arg, align 8
  %t111 = inttoptr i64 %t111_i64 to i8*
  %t112 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.27, i32 0, i32 0
  %t113_cmp = call i32 @flux_str_compare(i8* %t111, i8* %t112)
  %t113 = icmp eq i32 %t113_cmp, 0
  br i1 %t113, label %ft_10, label %route_arm_110
ft_10:
  %t114 = add i1 0, 1
  %st_b_24 = zext i1 %t114 to i64
  store i64 %st_b_24, i64* %flag_emit_wat, align 8
  br label %route_end_45
route_arm_110:
  %t116_i64 = load i64, i64* %arg, align 8
  %t116 = inttoptr i64 %t116_i64 to i8*
  %t117 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.28, i32 0, i32 0
  %t118_cmp = call i32 @flux_str_compare(i8* %t116, i8* %t117)
  %t118 = icmp eq i32 %t118_cmp, 0
  br i1 %t118, label %ft_11, label %route_arm_115
ft_11:
  %t119 = add i1 0, 1
  %st_b_25 = zext i1 %t119 to i64
  store i64 %st_b_25, i64* %flag_no_run, align 8
  br label %route_end_45
route_arm_115:
  %t121_i64 = load i64, i64* %arg, align 8
  %t121 = inttoptr i64 %t121_i64 to i8*
  %t122 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.29, i32 0, i32 0
  %t123_cmp = call i32 @flux_str_compare(i8* %t121, i8* %t122)
  %t123 = icmp eq i32 %t123_cmp, 0
  br i1 %t123, label %ft_12, label %route_arm_120
ft_12:
  %t124 = load i64, i64* %i, align 8
  %t125 = add i64 0, 1
  %t126 = add i64 %t124, %t125
  store i64 %t126, i64* %i, align 8
  %t129 = load i64, i64* %i, align 8
  %t130 = load i64, i64* %n_args, align 8
  %t131 = icmp sle i64 %t129, %t130
  br i1 %t131, label %ft_13, label %route_arm_128
ft_13:
  %t132 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t133_i64 = load i64, i64* %args, align 8
  %t133 = inttoptr i64 %t133_i64 to i8*
  %t134 = load i64, i64* %i, align 8
  %t135_raw = call i64 @flux_list_get_val(i8* %t133, i64 %t134)
  %t135 = inttoptr i64 %t135_raw to i8*
  %t136 = call i8* @flux_str_concat(i8* %t132, i8* %t135)
  %st_27 = ptrtoint i8* %t136 to i64
  store i64 %st_27, i64* %explain_code, align 8
  br label %route_end_127
route_arm_128:
  br label %route_end_127
route_end_127:
  br label %route_end_45
route_arm_120:
  %t139_i64 = load i64, i64* %input_file, align 8
  %t139 = inttoptr i64 %t139_i64 to i8*
  %t140 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t141_cmp = call i32 @flux_str_compare(i8* %t139, i8* %t140)
  %t141 = icmp ne i32 %t141_cmp, 0
  br i1 %t141, label %ft_14, label %route_arm_138
ft_14:
  %t144_i64 = load i64, i64* %extra_args, align 8
  %t144 = inttoptr i64 %t144_i64 to i8*
  %t145 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t146_cmp = call i32 @flux_str_compare(i8* %t144, i8* %t145)
  %t146 = icmp eq i32 %t146_cmp, 0
  br i1 %t146, label %ft_15, label %route_arm_143
ft_15:
  %t147 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t148_i64 = load i64, i64* %arg, align 8
  %t148 = inttoptr i64 %t148_i64 to i8*
  %t149 = call i8* @flux_str_concat(i8* %t147, i8* %t148)
  %t150 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t151 = call i8* @flux_str_concat(i8* %t149, i8* %t150)
  %st_28 = ptrtoint i8* %t151 to i64
  store i64 %st_28, i64* %extra_args, align 8
  br label %route_end_142
route_arm_143:
  %t153_i64 = load i64, i64* %extra_args, align 8
  %t153 = inttoptr i64 %t153_i64 to i8*
  %t154 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.31, i32 0, i32 0
  %t155 = call i8* @flux_str_concat(i8* %t153, i8* %t154)
  %t156_i64 = load i64, i64* %arg, align 8
  %t156 = inttoptr i64 %t156_i64 to i8*
  %t157 = call i8* @flux_str_concat(i8* %t155, i8* %t156)
  %t158 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t159 = call i8* @flux_str_concat(i8* %t157, i8* %t158)
  %st_29 = ptrtoint i8* %t159 to i64
  store i64 %st_29, i64* %extra_args, align 8
  br label %route_end_142
route_end_142:
  br label %route_end_45
route_arm_138:
  %t161_i64 = load i64, i64* %arg, align 8
  %t161 = inttoptr i64 %t161_i64 to i8*
  %t162 = call i64 @flux_str_len(i8* %t161)
  %t163 = add i64 0, 0
  %t164 = icmp sgt i64 %t162, %t163
  %t165_i64 = load i64, i64* %arg, align 8
  %t165 = inttoptr i64 %t165_i64 to i8*
  %t166 = add i64 0, 1
  %t167 = call i8* @flux_str_slice(i8* %t165, i64 %t166, i64 %t166)
  %t168 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.32, i32 0, i32 0
  %t169_cmp = call i32 @flux_str_compare(i8* %t167, i8* %t168)
  %t169 = icmp eq i32 %t169_cmp, 0
  %t170 = and i1 %t164, %t169
  br i1 %t170, label %ft_16, label %route_arm_160
ft_16:
  br label %route_end_45
route_arm_160:
  %t172_i64 = load i64, i64* %arg, align 8
  %t172 = inttoptr i64 %t172_i64 to i8*
  %st_30 = ptrtoint i8* %t172 to i64
  store i64 %st_30, i64* %input_file, align 8
  br label %route_end_45
route_end_45:
  %t173 = load i64, i64* %i, align 8
  %t174 = add i64 0, 1
  %t175 = add i64 %t173, %t174
  store i64 %t175, i64* %i, align 8
  br label %route_end_34
route_end_34:
  br label %loop_start_33
loop_end_33:
  %t178_i64 = load i64, i64* %flag_version, align 8
  %t178 = trunc i64 %t178_i64 to i1
  br i1 %t178, label %ft_17, label %route_arm_177
ft_17:
  %t179 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.33, i32 0, i32 0
  %pr_sn_12 = icmp eq i8* %t179, null
  %pr_sc_12 = select i1 %pr_sn_12, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t179
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_12)
  call i32 @fflush(i8* null)
  br label %route_end_176
route_arm_177:
  %t181_i64 = load i64, i64* %explain_code, align 8
  %t181 = inttoptr i64 %t181_i64 to i8*
  %t182 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t183_cmp = call i32 @flux_str_compare(i8* %t181, i8* %t182)
  %t183 = icmp ne i32 %t183_cmp, 0
  br i1 %t183, label %ft_18, label %route_arm_180
ft_18:
  %t184_i64 = load i64, i64* %explain_code, align 8
  %t184 = inttoptr i64 %t184_i64 to i8*
  %t185_res = call %flux.result @f_diagnosticExplain(i8* %t184)
  %t185_val = extractvalue %flux.result %t185_res, 1
  %t185 = inttoptr i64 %t185_val to i8*
  %st_32 = ptrtoint i8* %t185 to i64
  store i64 %st_32, i64* %explanation, align 8
  %t186_i64 = load i64, i64* %explanation, align 8
  %t186 = inttoptr i64 %t186_i64 to i8*
  %pr_sn_13 = icmp eq i8* %t186, null
  %pr_sc_13 = select i1 %pr_sn_13, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t186
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_13)
  call i32 @fflush(i8* null)
  br label %route_end_176
route_arm_180:
  %t188_i64 = load i64, i64* %input_file, align 8
  %t188 = inttoptr i64 %t188_i64 to i8*
  %t189 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t190_cmp = call i32 @flux_str_compare(i8* %t188, i8* %t189)
  %t190 = icmp eq i32 %t190_cmp, 0
  br i1 %t190, label %ft_19, label %route_arm_187
ft_19:
  %t191 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.34, i32 0, i32 0
  %pr_sn_14 = icmp eq i8* %t191, null
  %pr_sc_14 = select i1 %pr_sn_14, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t191
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_14)
  call i32 @fflush(i8* null)
  br label %route_end_176
route_arm_187:
  %t193_i64 = load i64, i64* %input_file, align 8
  %t193 = inttoptr i64 %t193_i64 to i8*
  %t194 = call i8* @flux_std_io_read_file(i8* %t193)
  %st_33 = ptrtoint i8* %t194 to i64
  store i64 %st_33, i64* %src_code, align 8
  %t195_i64 = load i64, i64* %src_code, align 8
  %t195 = inttoptr i64 %t195_i64 to i8*
  %t196 = call i64 @flux_str_len(i8* %t195)
  store i64 %t196, i64* %src_len, align 8
  %t197 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %st_35 = ptrtoint i8* %t197 to i64
  store i64 %st_35, i64* %exp_err, align 8
  %t200 = load i64, i64* %src_len, align 8
  %t201 = add i64 0, 22
  %t202 = icmp sge i64 %t200, %t201
  br i1 %t202, label %ft_20, label %route_arm_199
ft_20:
  %t203_i64 = load i64, i64* %src_code, align 8
  %t203 = inttoptr i64 %t203_i64 to i8*
  %t204 = add i64 0, 1
  %t205 = add i64 0, 17
  %t206 = call i8* @flux_str_slice(i8* %t203, i64 %t204, i64 %t205)
  %st_36 = ptrtoint i8* %t206 to i64
  store i64 %st_36, i64* %exp_pref, align 8
  %t209_i64 = load i64, i64* %exp_pref, align 8
  %t209 = inttoptr i64 %t209_i64 to i8*
  %t210 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.35, i32 0, i32 0
  %t211_cmp = call i32 @flux_str_compare(i8* %t209, i8* %t210)
  %t211 = icmp eq i32 %t211_cmp, 0
  br i1 %t211, label %ft_21, label %route_arm_208
ft_21:
  %t212 = add i64 0, 23
  store i64 %t212, i64* %slast, align 8
  %t215 = load i64, i64* %src_len, align 8
  %t216 = add i64 0, 23
  %t217 = icmp slt i64 %t215, %t216
  br i1 %t217, label %ft_22, label %route_arm_214
ft_22:
  %t218 = load i64, i64* %src_len, align 8
  store i64 %t218, i64* %slast, align 8
  br label %route_end_213
route_arm_214:
  br label %route_end_213
route_end_213:
  %t220_i64 = load i64, i64* %src_code, align 8
  %t220 = inttoptr i64 %t220_i64 to i8*
  %t221 = add i64 0, 18
  %t222 = load i64, i64* %slast, align 8
  %t223 = call i8* @flux_str_slice(i8* %t220, i64 %t221, i64 %t222)
  %st_39 = ptrtoint i8* %t223 to i64
  store i64 %st_39, i64* %exp_err, align 8
  %t224_i64 = load i64, i64* %exp_err, align 8
  %t224 = inttoptr i64 %t224_i64 to i8*
  %t225 = call i64 @flux_str_len(i8* %t224)
  store i64 %t225, i64* %elen, align 8
  %t228 = load i64, i64* %elen, align 8
  %t229 = add i64 0, 6
  %t230 = icmp sge i64 %t228, %t229
  br i1 %t230, label %ft_23, label %route_arm_227
ft_23:
  %t231_i64 = load i64, i64* %exp_err, align 8
  %t231 = inttoptr i64 %t231_i64 to i8*
  %t232 = add i64 0, 6
  %t233 = call i8* @flux_str_slice(i8* %t231, i64 %t232, i64 %t232)
  %st_41 = ptrtoint i8* %t233 to i64
  store i64 %st_41, i64* %c6, align 8
  %t236_i64 = load i64, i64* %c6, align 8
  %t236 = inttoptr i64 %t236_i64 to i8*
  %t237 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.36, i32 0, i32 0
  %t238_cmp = call i32 @flux_str_compare(i8* %t236, i8* %t237)
  %t238 = icmp eq i32 %t238_cmp, 0
  %t239_i64 = load i64, i64* %c6, align 8
  %t239 = inttoptr i64 %t239_i64 to i8*
  %t240 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.37, i32 0, i32 0
  %t241_cmp = call i32 @flux_str_compare(i8* %t239, i8* %t240)
  %t241 = icmp eq i32 %t241_cmp, 0
  %t242 = or i1 %t238, %t241
  %t243_i64 = load i64, i64* %c6, align 8
  %t243 = inttoptr i64 %t243_i64 to i8*
  %t244 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.38, i32 0, i32 0
  %t245_cmp = call i32 @flux_str_compare(i8* %t243, i8* %t244)
  %t245 = icmp eq i32 %t245_cmp, 0
  %t246 = or i1 %t242, %t245
  br i1 %t246, label %ft_24, label %route_arm_235
ft_24:
  %t247_i64 = load i64, i64* %exp_err, align 8
  %t247 = inttoptr i64 %t247_i64 to i8*
  %t248 = add i64 0, 1
  %t249 = add i64 0, 5
  %t250 = call i8* @flux_str_slice(i8* %t247, i64 %t248, i64 %t249)
  %st_42 = ptrtoint i8* %t250 to i64
  store i64 %st_42, i64* %exp_err, align 8
  br label %route_end_234
route_arm_235:
  br label %route_end_234
route_end_234:
  br label %route_end_226
route_arm_227:
  br label %route_end_226
route_end_226:
  br label %route_end_207
route_arm_208:
  br label %route_end_207
route_end_207:
  br label %route_end_198
route_arm_199:
  br label %route_end_198
route_end_198:
  %t257_i64 = load i64, i64* %exp_err, align 8
  %t257 = inttoptr i64 %t257_i64 to i8*
  %t258 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t259_cmp = call i32 @flux_str_compare(i8* %t257, i8* %t258)
  %t259 = icmp ne i32 %t259_cmp, 0
  br i1 %t259, label %ft_25, label %route_arm_256
ft_25:
  %t260_i64 = load i64, i64* %exp_err, align 8
  %t260 = inttoptr i64 %t260_i64 to i8*
  %t261_i64 = load i64, i64* %input_file, align 8
  %t261 = inttoptr i64 %t261_i64 to i8*
  %t262_res = call %flux.result @f_diagnosticGetHeader(i8* %t260, i8* %t261)
  %t262_val = extractvalue %flux.result %t262_res, 1
  %t262 = inttoptr i64 %t262_val to i8*
  %st_43 = ptrtoint i8* %t262 to i64
  store i64 %st_43, i64* %err_hdr, align 8
  %t263_i64 = load i64, i64* %exp_err, align 8
  %t263 = inttoptr i64 %t263_i64 to i8*
  %t264_res = call %flux.result @f_diagnosticGetHint(i8* %t263)
  %t264_val = extractvalue %flux.result %t264_res, 1
  %t264 = inttoptr i64 %t264_val to i8*
  %st_44 = ptrtoint i8* %t264 to i64
  store i64 %st_44, i64* %err_hint, align 8
  %t265_i64 = load i64, i64* %err_hdr, align 8
  %t265 = inttoptr i64 %t265_i64 to i8*
  %pr_sn_15 = icmp eq i8* %t265, null
  %pr_sc_15 = select i1 %pr_sn_15, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t265
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_15)
  call i32 @fflush(i8* null)
  %t266 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.39, i32 0, i32 0
  %t267_i64 = load i64, i64* %err_hint, align 8
  %t267 = inttoptr i64 %t267_i64 to i8*
  %t268 = call i8* @flux_str_concat(i8* %t266, i8* %t267)
  %pr_sn_16 = icmp eq i8* %t268, null
  %pr_sc_16 = select i1 %pr_sn_16, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t268
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_16)
  call i32 @fflush(i8* null)
  %t269 = add i64 0, 1
  %t270 = call i64 @flux_std_os_exit(i64 %t269)
  br label %route_end_255
route_arm_256:
  br label %route_end_255
route_end_255:
  %t272_i64 = load i64, i64* %input_file, align 8
  %t272 = inttoptr i64 %t272_i64 to i8*
  %t273 = call i64 @flux_str_len(i8* %t272)
  store i64 %t273, i64* %in_len, align 8
  %t274 = add i1 0, 0
  %st_b_46 = zext i1 %t274 to i64
  store i64 %st_b_46, i64* %is_compliance, align 8
  %t275 = add i64 0, 1
  store i64 %t275, i64* %ck, align 8
  br label %loop_start_276
loop_start_276:
  %t279 = load i64, i64* %ck, align 8
  %t280 = add i64 0, 9
  %t281 = add i64 %t279, %t280
  %t282 = load i64, i64* %in_len, align 8
  %t283 = icmp sgt i64 %t281, %t282
  br i1 %t283, label %ft_26, label %route_arm_278
ft_26:
  br label %loop_end_276
route_arm_278:
  %t285_i64 = load i64, i64* %input_file, align 8
  %t285 = inttoptr i64 %t285_i64 to i8*
  %t286 = load i64, i64* %ck, align 8
  %t287 = load i64, i64* %ck, align 8
  %t288 = add i64 0, 9
  %t289 = add i64 %t287, %t288
  %t290 = call i8* @flux_str_slice(i8* %t285, i64 %t286, i64 %t289)
  %t291 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.40, i32 0, i32 0
  %t292_cmp = call i32 @flux_str_compare(i8* %t290, i8* %t291)
  %t292 = icmp eq i32 %t292_cmp, 0
  br i1 %t292, label %ft_27, label %route_arm_284
ft_27:
  %t293 = add i1 0, 1
  %st_b_48 = zext i1 %t293 to i64
  store i64 %st_b_48, i64* %is_compliance, align 8
  br label %loop_end_276
route_arm_284:
  %t295 = load i64, i64* %ck, align 8
  %t296 = add i64 0, 1
  %t297 = add i64 %t295, %t296
  store i64 %t297, i64* %ck, align 8
  br label %route_end_277
route_end_277:
  br label %loop_start_276
loop_end_276:
  %t298 = add i1 0, 0
  %st_b_50 = zext i1 %t298 to i64
  store i64 %st_b_50, i64* %is_exemplos, align 8
  %t299 = add i64 0, 1
  store i64 %t299, i64* %ek, align 8
  br label %loop_start_300
loop_start_300:
  %t303 = load i64, i64* %ek, align 8
  %t304 = add i64 0, 7
  %t305 = add i64 %t303, %t304
  %t306 = load i64, i64* %in_len, align 8
  %t307 = icmp sgt i64 %t305, %t306
  br i1 %t307, label %ft_28, label %route_arm_302
ft_28:
  br label %loop_end_300
route_arm_302:
  %t309_i64 = load i64, i64* %input_file, align 8
  %t309 = inttoptr i64 %t309_i64 to i8*
  %t310 = load i64, i64* %ek, align 8
  %t311 = load i64, i64* %ek, align 8
  %t312 = add i64 0, 7
  %t313 = add i64 %t311, %t312
  %t314 = call i8* @flux_str_slice(i8* %t309, i64 %t310, i64 %t313)
  %t315 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.41, i32 0, i32 0
  %t316_cmp = call i32 @flux_str_compare(i8* %t314, i8* %t315)
  %t316 = icmp eq i32 %t316_cmp, 0
  %t317_i64 = load i64, i64* %input_file, align 8
  %t317 = inttoptr i64 %t317_i64 to i8*
  %t318 = load i64, i64* %ek, align 8
  %t319 = load i64, i64* %ek, align 8
  %t320 = add i64 0, 7
  %t321 = add i64 %t319, %t320
  %t322 = call i8* @flux_str_slice(i8* %t317, i64 %t318, i64 %t321)
  %t323 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.42, i32 0, i32 0
  %t324_cmp = call i32 @flux_str_compare(i8* %t322, i8* %t323)
  %t324 = icmp eq i32 %t324_cmp, 0
  %t325 = or i1 %t316, %t324
  br i1 %t325, label %ft_29, label %route_arm_308
ft_29:
  %t326 = add i1 0, 1
  %st_b_52 = zext i1 %t326 to i64
  store i64 %st_b_52, i64* %is_exemplos, align 8
  br label %loop_end_300
route_arm_308:
  %t328 = load i64, i64* %ek, align 8
  %t329 = add i64 0, 1
  %t330 = add i64 %t328, %t329
  store i64 %t330, i64* %ek, align 8
  br label %route_end_301
route_end_301:
  br label %loop_start_300
loop_end_300:
  %t331 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %st_54 = ptrtoint i8* %t331 to i64
  store i64 %st_54, i64* %arg_suffix, align 8
  %t334_i64 = load i64, i64* %extra_args, align 8
  %t334 = inttoptr i64 %t334_i64 to i8*
  %t335 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t336_cmp = call i32 @flux_str_compare(i8* %t334, i8* %t335)
  %t336 = icmp ne i32 %t336_cmp, 0
  br i1 %t336, label %ft_30, label %route_arm_333
ft_30:
  %t337 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.38, i32 0, i32 0
  %t338_i64 = load i64, i64* %extra_args, align 8
  %t338 = inttoptr i64 %t338_i64 to i8*
  %t339 = call i8* @flux_str_concat(i8* %t337, i8* %t338)
  %st_55 = ptrtoint i8* %t339 to i64
  store i64 %st_55, i64* %arg_suffix, align 8
  br label %route_end_332
route_arm_333:
  br label %route_end_332
route_end_332:
  %t343_i64 = load i64, i64* %target, align 8
  %t343 = inttoptr i64 %t343_i64 to i8*
  %t344 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.17, i32 0, i32 0
  %t345_cmp = call i32 @flux_str_compare(i8* %t343, i8* %t344)
  %t345 = icmp eq i32 %t345_cmp, 0
  %t346_i64 = load i64, i64* %target, align 8
  %t346 = inttoptr i64 %t346_i64 to i8*
  %t347 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.43, i32 0, i32 0
  %t348_cmp = call i32 @flux_str_compare(i8* %t346, i8* %t347)
  %t348 = icmp eq i32 %t348_cmp, 0
  %t349 = or i1 %t345, %t348
  br i1 %t349, label %ft_31, label %route_arm_342
ft_31:
  %t352_i64 = load i64, i64* %is_compliance, align 8
  %t352 = trunc i64 %t352_i64 to i1
  br i1 %t352, label %ft_32, label %route_arm_351
ft_32:
  %t355 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.44, i32 0, i32 0
  %t356_i64 = call i64 @flux_std_io_file_exists(i8* %t355)
  %t356 = trunc i64 %t356_i64 to i1
  %t357 = load i64, i64* %in_len, align 8
  %t358 = add i64 0, 13
  %t359 = icmp sge i64 %t357, %t358
  %t360 = and i1 %t356, %t359
  br i1 %t360, label %ft_33, label %route_arm_354
ft_33:
  %t361 = add i64 0, 1
  store i64 %t361, i64* %bi, align 8
  br label %loop_start_362
loop_start_362:
  %t365 = load i64, i64* %bi, align 8
  %t366 = add i64 0, 12
  %t367 = add i64 %t365, %t366
  %t368 = load i64, i64* %in_len, align 8
  %t369 = icmp sgt i64 %t367, %t368
  br i1 %t369, label %ft_34, label %route_arm_364
ft_34:
  br label %loop_end_362
route_arm_364:
  %t371_i64 = load i64, i64* %input_file, align 8
  %t371 = inttoptr i64 %t371_i64 to i8*
  %t372 = load i64, i64* %bi, align 8
  %t373 = load i64, i64* %bi, align 8
  %t374 = add i64 0, 12
  %t375 = add i64 %t373, %t374
  %t376 = call i8* @flux_str_slice(i8* %t371, i64 %t372, i64 %t375)
  %t377 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.45, i32 0, i32 0
  %t378_cmp = call i32 @flux_str_compare(i8* %t376, i8* %t377)
  %t378 = icmp eq i32 %t378_cmp, 0
  br i1 %t378, label %ft_35, label %route_arm_370
ft_35:
  %t379 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.46, i32 0, i32 0
  %t380_i64 = load i64, i64* %arg_suffix, align 8
  %t380 = inttoptr i64 %t380_i64 to i8*
  %t381 = call i8* @flux_str_concat(i8* %t379, i8* %t380)
  %t382 = call i64 @flux_std_os_exec(i8* %t381)
  store i64 %t382, i64* %rc, align 8
  %t383 = load i64, i64* %rc, align 8
  %t384 = call i64 @flux_std_os_exit(i64 %t383)
  br label %route_end_363
route_arm_370:
  %t386 = load i64, i64* %bi, align 8
  %t387 = add i64 0, 1
  %t388 = add i64 %t386, %t387
  store i64 %t388, i64* %bi, align 8
  br label %route_end_363
route_end_363:
  br label %loop_start_362
loop_end_362:
  br label %route_end_353
route_arm_354:
  br label %route_end_353
route_end_353:
  %t392 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.47, i32 0, i32 0
  %t393_i64 = call i64 @flux_std_io_file_exists(i8* %t392)
  %t393 = trunc i64 %t393_i64 to i1
  %t394 = load i64, i64* %in_len, align 8
  %t395 = add i64 0, 13
  %t396 = icmp sge i64 %t394, %t395
  %t397 = and i1 %t393, %t396
  br i1 %t397, label %ft_36, label %route_arm_391
ft_36:
  %t398 = add i64 0, 1
  store i64 %t398, i64* %bi, align 8
  br label %loop_start_399
loop_start_399:
  %t402 = load i64, i64* %bi, align 8
  %t403 = add i64 0, 12
  %t404 = add i64 %t402, %t403
  %t405 = load i64, i64* %in_len, align 8
  %t406 = icmp sgt i64 %t404, %t405
  br i1 %t406, label %ft_37, label %route_arm_401
ft_37:
  br label %loop_end_399
route_arm_401:
  %t408_i64 = load i64, i64* %input_file, align 8
  %t408 = inttoptr i64 %t408_i64 to i8*
  %t409 = load i64, i64* %bi, align 8
  %t410 = load i64, i64* %bi, align 8
  %t411 = add i64 0, 12
  %t412 = add i64 %t410, %t411
  %t413 = call i8* @flux_str_slice(i8* %t408, i64 %t409, i64 %t412)
  %t414 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.48, i32 0, i32 0
  %t415_cmp = call i32 @flux_str_compare(i8* %t413, i8* %t414)
  %t415 = icmp eq i32 %t415_cmp, 0
  br i1 %t415, label %ft_38, label %route_arm_407
ft_38:
  %t416 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.49, i32 0, i32 0
  %t417_i64 = load i64, i64* %arg_suffix, align 8
  %t417 = inttoptr i64 %t417_i64 to i8*
  %t418 = call i8* @flux_str_concat(i8* %t416, i8* %t417)
  %t419 = call i64 @flux_std_os_exec(i8* %t418)
  store i64 %t419, i64* %rc, align 8
  %t420 = load i64, i64* %rc, align 8
  %t421 = call i64 @flux_std_os_exit(i64 %t420)
  br label %route_end_400
route_arm_407:
  %t423 = load i64, i64* %bi, align 8
  %t424 = add i64 0, 1
  %t425 = add i64 %t423, %t424
  store i64 %t425, i64* %bi, align 8
  br label %route_end_400
route_end_400:
  br label %loop_start_399
loop_end_399:
  br label %route_end_390
route_arm_391:
  br label %route_end_390
route_end_390:
  %t429 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.50, i32 0, i32 0
  %t430_i64 = call i64 @flux_std_io_file_exists(i8* %t429)
  %t430 = trunc i64 %t430_i64 to i1
  %t431 = load i64, i64* %in_len, align 8
  %t432 = add i64 0, 13
  %t433 = icmp sge i64 %t431, %t432
  %t434 = and i1 %t430, %t433
  br i1 %t434, label %ft_39, label %route_arm_428
ft_39:
  %t435 = add i64 0, 1
  store i64 %t435, i64* %bi, align 8
  br label %loop_start_436
loop_start_436:
  %t439 = load i64, i64* %bi, align 8
  %t440 = add i64 0, 12
  %t441 = add i64 %t439, %t440
  %t442 = load i64, i64* %in_len, align 8
  %t443 = icmp sgt i64 %t441, %t442
  br i1 %t443, label %ft_40, label %route_arm_438
ft_40:
  br label %loop_end_436
route_arm_438:
  %t445_i64 = load i64, i64* %input_file, align 8
  %t445 = inttoptr i64 %t445_i64 to i8*
  %t446 = load i64, i64* %bi, align 8
  %t447 = load i64, i64* %bi, align 8
  %t448 = add i64 0, 12
  %t449 = add i64 %t447, %t448
  %t450 = call i8* @flux_str_slice(i8* %t445, i64 %t446, i64 %t449)
  %t451 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.51, i32 0, i32 0
  %t452_cmp = call i32 @flux_str_compare(i8* %t450, i8* %t451)
  %t452 = icmp eq i32 %t452_cmp, 0
  br i1 %t452, label %ft_41, label %route_arm_444
ft_41:
  %t453 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.52, i32 0, i32 0
  %t454_i64 = load i64, i64* %arg_suffix, align 8
  %t454 = inttoptr i64 %t454_i64 to i8*
  %t455 = call i8* @flux_str_concat(i8* %t453, i8* %t454)
  %t456 = call i64 @flux_std_os_exec(i8* %t455)
  store i64 %t456, i64* %rc, align 8
  %t457 = load i64, i64* %rc, align 8
  %t458 = call i64 @flux_std_os_exit(i64 %t457)
  br label %route_end_437
route_arm_444:
  %t460 = load i64, i64* %bi, align 8
  %t461 = add i64 0, 1
  %t462 = add i64 %t460, %t461
  store i64 %t462, i64* %bi, align 8
  br label %route_end_437
route_end_437:
  br label %loop_start_436
loop_end_436:
  br label %route_end_427
route_arm_428:
  br label %route_end_427
route_end_427:
  %t466 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.53, i32 0, i32 0
  %t467_i64 = call i64 @flux_std_io_file_exists(i8* %t466)
  %t467 = trunc i64 %t467_i64 to i1
  %t468 = load i64, i64* %in_len, align 8
  %t469 = add i64 0, 13
  %t470 = icmp sge i64 %t468, %t469
  %t471 = and i1 %t467, %t470
  br i1 %t471, label %ft_42, label %route_arm_465
ft_42:
  %t472 = add i64 0, 1
  store i64 %t472, i64* %bi, align 8
  br label %loop_start_473
loop_start_473:
  %t476 = load i64, i64* %bi, align 8
  %t477 = add i64 0, 12
  %t478 = add i64 %t476, %t477
  %t479 = load i64, i64* %in_len, align 8
  %t480 = icmp sgt i64 %t478, %t479
  br i1 %t480, label %ft_43, label %route_arm_475
ft_43:
  br label %loop_end_473
route_arm_475:
  %t482_i64 = load i64, i64* %input_file, align 8
  %t482 = inttoptr i64 %t482_i64 to i8*
  %t483 = load i64, i64* %bi, align 8
  %t484 = load i64, i64* %bi, align 8
  %t485 = add i64 0, 12
  %t486 = add i64 %t484, %t485
  %t487 = call i8* @flux_str_slice(i8* %t482, i64 %t483, i64 %t486)
  %t488 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.54, i32 0, i32 0
  %t489_cmp = call i32 @flux_str_compare(i8* %t487, i8* %t488)
  %t489 = icmp eq i32 %t489_cmp, 0
  br i1 %t489, label %ft_44, label %route_arm_481
ft_44:
  %t490 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.55, i32 0, i32 0
  %t491_i64 = load i64, i64* %arg_suffix, align 8
  %t491 = inttoptr i64 %t491_i64 to i8*
  %t492 = call i8* @flux_str_concat(i8* %t490, i8* %t491)
  %t493 = call i64 @flux_std_os_exec(i8* %t492)
  store i64 %t493, i64* %rc, align 8
  %t494 = load i64, i64* %rc, align 8
  %t495 = call i64 @flux_std_os_exit(i64 %t494)
  br label %route_end_474
route_arm_481:
  %t497 = load i64, i64* %bi, align 8
  %t498 = add i64 0, 1
  %t499 = add i64 %t497, %t498
  store i64 %t499, i64* %bi, align 8
  br label %route_end_474
route_end_474:
  br label %loop_start_473
loop_end_473:
  br label %route_end_464
route_arm_465:
  br label %route_end_464
route_end_464:
  %t503 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.56, i32 0, i32 0
  %t504_i64 = call i64 @flux_std_io_file_exists(i8* %t503)
  %t504 = trunc i64 %t504_i64 to i1
  %t505 = load i64, i64* %in_len, align 8
  %t506 = add i64 0, 10
  %t507 = icmp sge i64 %t505, %t506
  %t508 = and i1 %t504, %t507
  br i1 %t508, label %ft_45, label %route_arm_502
ft_45:
  %t509 = add i64 0, 1
  store i64 %t509, i64* %bi, align 8
  br label %loop_start_510
loop_start_510:
  %t513 = load i64, i64* %bi, align 8
  %t514 = add i64 0, 9
  %t515 = add i64 %t513, %t514
  %t516 = load i64, i64* %in_len, align 8
  %t517 = icmp sgt i64 %t515, %t516
  br i1 %t517, label %ft_46, label %route_arm_512
ft_46:
  br label %loop_end_510
route_arm_512:
  %t519_i64 = load i64, i64* %input_file, align 8
  %t519 = inttoptr i64 %t519_i64 to i8*
  %t520 = load i64, i64* %bi, align 8
  %t521 = load i64, i64* %bi, align 8
  %t522 = add i64 0, 9
  %t523 = add i64 %t521, %t522
  %t524 = call i8* @flux_str_slice(i8* %t519, i64 %t520, i64 %t523)
  %t525 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.40, i32 0, i32 0
  %t526_cmp = call i32 @flux_str_compare(i8* %t524, i8* %t525)
  %t526 = icmp eq i32 %t526_cmp, 0
  br i1 %t526, label %ft_47, label %route_arm_518
ft_47:
  %t527 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.57, i32 0, i32 0
  %t528_i64 = load i64, i64* %arg_suffix, align 8
  %t528 = inttoptr i64 %t528_i64 to i8*
  %t529 = call i8* @flux_str_concat(i8* %t527, i8* %t528)
  %t530 = call i64 @flux_std_os_exec(i8* %t529)
  store i64 %t530, i64* %rc, align 8
  %t531 = load i64, i64* %rc, align 8
  %t532 = call i64 @flux_std_os_exit(i64 %t531)
  br label %route_end_511
route_arm_518:
  %t534 = load i64, i64* %bi, align 8
  %t535 = add i64 0, 1
  %t536 = add i64 %t534, %t535
  store i64 %t536, i64* %bi, align 8
  br label %route_end_511
route_end_511:
  br label %loop_start_510
loop_end_510:
  br label %route_end_501
route_arm_502:
  br label %route_end_501
route_end_501:
  br label %route_end_350
route_arm_351:
  br label %route_end_350
route_end_350:
  %t541_i64 = load i64, i64* %is_exemplos, align 8
  %t541 = trunc i64 %t541_i64 to i1
  br i1 %t541, label %ft_48, label %route_arm_540
ft_48:
  %t542 = call i8* @flux_list_create(i64 16)
  %t543 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.58, i32 0, i32 0
  %p_lp_1 = ptrtoint i8* %t543 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_1)
  %t544 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.59, i32 0, i32 0
  %p_lp_2 = ptrtoint i8* %t544 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_2)
  %t545 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.60, i32 0, i32 0
  %p_lp_3 = ptrtoint i8* %t545 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_3)
  %t546 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.61, i32 0, i32 0
  %p_lp_4 = ptrtoint i8* %t546 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_4)
  %t547 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.62, i32 0, i32 0
  %p_lp_5 = ptrtoint i8* %t547 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_5)
  %t548 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.63, i32 0, i32 0
  %p_lp_6 = ptrtoint i8* %t548 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_6)
  %t549 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.64, i32 0, i32 0
  %p_lp_7 = ptrtoint i8* %t549 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_7)
  %t550 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.65, i32 0, i32 0
  %p_lp_8 = ptrtoint i8* %t550 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_8)
  %t551 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.66, i32 0, i32 0
  %p_lp_9 = ptrtoint i8* %t551 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_9)
  %t552 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.67, i32 0, i32 0
  %p_lp_10 = ptrtoint i8* %t552 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_10)
  %t553 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.68, i32 0, i32 0
  %p_lp_11 = ptrtoint i8* %t553 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_11)
  %t554 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.69, i32 0, i32 0
  %p_lp_12 = ptrtoint i8* %t554 to i64
  call void @flux_list_push_val(i8* %t542, i64 %p_lp_12)
  %st_71 = ptrtoint i8* %t542 to i64
  store i64 %st_71, i64* %ex_names, align 8
  %t555 = add i64 0, 1
  store i64 %t555, i64* %eni, align 8
  br label %loop_start_556
loop_start_556:
  %t559 = load i64, i64* %eni, align 8
  %t560 = add i64 0, 12
  %t561 = icmp sgt i64 %t559, %t560
  br i1 %t561, label %ft_49, label %route_arm_558
ft_49:
  br label %loop_end_556
route_arm_558:
  %t563 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t564_i64 = load i64, i64* %ex_names, align 8
  %t564 = inttoptr i64 %t564_i64 to i8*
  %t565 = load i64, i64* %eni, align 8
  %t566_raw = call i64 @flux_list_get_val(i8* %t564, i64 %t565)
  %t566 = inttoptr i64 %t566_raw to i8*
  %t567 = call i8* @flux_str_concat(i8* %t563, i8* %t566)
  %st_73 = ptrtoint i8* %t567 to i64
  store i64 %st_73, i64* %enm, align 8
  %t568_i64 = load i64, i64* %enm, align 8
  %t568 = inttoptr i64 %t568_i64 to i8*
  %t569 = call i64 @flux_str_len(i8* %t568)
  store i64 %t569, i64* %enmlen, align 8
  %t570 = add i64 0, 1
  store i64 %t570, i64* %ebi, align 8
  br label %loop_start_571
loop_start_571:
  %t574 = load i64, i64* %ebi, align 8
  %t575 = load i64, i64* %enmlen, align 8
  %t576 = add i64 %t574, %t575
  %t577 = add i64 0, 1
  %t578 = sub i64 %t576, %t577
  %t579 = load i64, i64* %in_len, align 8
  %t580 = icmp sgt i64 %t578, %t579
  br i1 %t580, label %ft_50, label %route_arm_573
ft_50:
  br label %loop_end_571
route_arm_573:
  %t582_i64 = load i64, i64* %input_file, align 8
  %t582 = inttoptr i64 %t582_i64 to i8*
  %t583 = load i64, i64* %ebi, align 8
  %t584 = load i64, i64* %ebi, align 8
  %t585 = load i64, i64* %enmlen, align 8
  %t586 = add i64 %t584, %t585
  %t587 = add i64 0, 1
  %t588 = sub i64 %t586, %t587
  %t589 = call i8* @flux_str_slice(i8* %t582, i64 %t583, i64 %t588)
  %t590_i64 = load i64, i64* %enm, align 8
  %t590 = inttoptr i64 %t590_i64 to i8*
  %t591_cmp = call i32 @flux_str_compare(i8* %t589, i8* %t590)
  %t591 = icmp eq i32 %t591_cmp, 0
  br i1 %t591, label %ft_51, label %route_arm_581
ft_51:
  %t592_i64 = load i64, i64* %enm, align 8
  %t592 = inttoptr i64 %t592_i64 to i8*
  %st_76 = ptrtoint i8* %t592 to i64
  store i64 %st_76, i64* %bin_name, align 8
  %t595 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.70, i32 0, i32 0
  %t596_i64 = load i64, i64* %bin_name, align 8
  %t596 = inttoptr i64 %t596_i64 to i8*
  %t597 = call i8* @flux_str_concat(i8* %t595, i8* %t596)
  %t598 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.71, i32 0, i32 0
  %t599 = call i8* @flux_str_concat(i8* %t597, i8* %t598)
  %t600_i64 = call i64 @flux_std_io_file_exists(i8* %t599)
  %t600 = trunc i64 %t600_i64 to i1
  br i1 %t600, label %ft_52, label %route_arm_594
ft_52:
  %t601 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.72, i32 0, i32 0
  %t602_i64 = load i64, i64* %bin_name, align 8
  %t602 = inttoptr i64 %t602_i64 to i8*
  %t603 = call i8* @flux_str_concat(i8* %t601, i8* %t602)
  %t604 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.71, i32 0, i32 0
  %t605 = call i8* @flux_str_concat(i8* %t603, i8* %t604)
  %t606_i64 = load i64, i64* %arg_suffix, align 8
  %t606 = inttoptr i64 %t606_i64 to i8*
  %t607 = call i8* @flux_str_concat(i8* %t605, i8* %t606)
  %t608 = call i64 @flux_std_os_exec(i8* %t607)
  store i64 %t608, i64* %rc, align 8
  %t609 = load i64, i64* %rc, align 8
  %t610 = call i64 @flux_std_os_exit(i64 %t609)
  br label %route_end_593
route_arm_594:
  br label %route_end_593
route_end_593:
  br label %loop_end_571
route_arm_581:
  %t613 = load i64, i64* %ebi, align 8
  %t614 = add i64 0, 1
  %t615 = add i64 %t613, %t614
  store i64 %t615, i64* %ebi, align 8
  br label %route_end_572
route_end_572:
  br label %loop_start_571
loop_end_571:
  %t616 = load i64, i64* %eni, align 8
  %t617 = add i64 0, 1
  %t618 = add i64 %t616, %t617
  store i64 %t618, i64* %eni, align 8
  br label %route_end_557
route_end_557:
  br label %loop_start_556
loop_end_556:
  br label %route_end_539
route_arm_540:
  br label %route_end_539
route_end_539:
  br label %route_end_341
route_arm_342:
  br label %route_end_341
route_end_341:
  %t623_i64 = load i64, i64* %target, align 8
  %t623 = inttoptr i64 %t623_i64 to i8*
  %t624 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.73, i32 0, i32 0
  %t625_cmp = call i32 @flux_str_compare(i8* %t623, i8* %t624)
  %t625 = icmp eq i32 %t625_cmp, 0
  %t626 = load i64, i64* %in_len, align 8
  %t627 = add i64 0, 6
  %t628 = icmp sge i64 %t626, %t627
  %t629 = and i1 %t625, %t628
  %t630_i64 = load i64, i64* %input_file, align 8
  %t630 = inttoptr i64 %t630_i64 to i8*
  %t631 = load i64, i64* %in_len, align 8
  %t632 = add i64 0, 5
  %t633 = sub i64 %t631, %t632
  %t634 = load i64, i64* %in_len, align 8
  %t635 = call i8* @flux_str_slice(i8* %t630, i64 %t633, i64 %t634)
  %t636 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.74, i32 0, i32 0
  %t637_cmp = call i32 @flux_str_compare(i8* %t635, i8* %t636)
  %t637 = icmp eq i32 %t637_cmp, 0
  %t638 = and i1 %t629, %t637
  br i1 %t638, label %ft_53, label %route_arm_622
ft_53:
  %t639 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.75, i32 0, i32 0
  %t640_i64 = load i64, i64* %input_file, align 8
  %t640 = inttoptr i64 %t640_i64 to i8*
  %t641 = call i8* @flux_str_concat(i8* %t639, i8* %t640)
  %t642 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t643 = call i8* @flux_str_concat(i8* %t641, i8* %t642)
  %t644_i64 = load i64, i64* %arg_suffix, align 8
  %t644 = inttoptr i64 %t644_i64 to i8*
  %t645 = call i8* @flux_str_concat(i8* %t643, i8* %t644)
  %st_80 = ptrtoint i8* %t645 to i64
  store i64 %st_80, i64* %vm_cmd, align 8
  %t646_i64 = load i64, i64* %vm_cmd, align 8
  %t646 = inttoptr i64 %t646_i64 to i8*
  %t647 = call i64 @flux_std_os_exec(i8* %t646)
  store i64 %t647, i64* %vm_rc, align 8
  %t648 = load i64, i64* %vm_rc, align 8
  %t649 = call i64 @flux_std_os_exit(i64 %t648)
  br label %route_end_621
route_arm_622:
  br label %route_end_621
route_end_621:
  %t651_i64 = load i64, i64* %input_file, align 8
  %t651 = inttoptr i64 %t651_i64 to i8*
  %t652_res = call %flux.result @f_parseFile(i8* %t651)
  %t652_val = extractvalue %flux.result %t652_res, 1
  %t652 = inttoptr i64 %t652_val to i8*
  %st_82 = ptrtoint i8* %t652 to i64
  store i64 %st_82, i64* %parse_res, align 8
  %t655_i64 = load i64, i64* %parse_res, align 8
  %t655 = inttoptr i64 %t655_i64 to i8*
  %t656 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.76, i32 0, i32 0
  %t657_raw = call i64 @flux_map_get(i8* %t655, i8* %t656)
  %t657 = icmp ne i64 %t657_raw, 0
  %t658 = xor i1 %t657, 1
  br i1 %t658, label %ft_54, label %route_arm_654
ft_54:
  %t659 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.77, i32 0, i32 0
  %t660_i64 = load i64, i64* %parse_res, align 8
  %t660 = inttoptr i64 %t660_i64 to i8*
  %t661 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.78, i32 0, i32 0
  %t662_raw = call i64 @flux_map_get(i8* %t660, i8* %t661)
  %t662 = inttoptr i64 %t662_raw to i8*
  %t663 = call i8* @flux_str_concat(i8* %t659, i8* %t662)
  %pr_sn_17 = icmp eq i8* %t663, null
  %pr_sc_17 = select i1 %pr_sn_17, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t663
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_17)
  call i32 @fflush(i8* null)
  %t664 = add i64 0, 1
  %t665 = call i64 @flux_std_os_exit(i64 %t664)
  br label %route_end_653
route_arm_654:
  %t667_i64 = load i64, i64* %parse_res, align 8
  %t667 = inttoptr i64 %t667_i64 to i8*
  %t668 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.79, i32 0, i32 0
  %t669_raw = call i64 @flux_map_get(i8* %t667, i8* %t668)
  %t669 = inttoptr i64 %t669_raw to i8*
  %st_83 = ptrtoint i8* %t669 to i64
  store i64 %st_83, i64* %arena, align 8
  %t670_i64 = load i64, i64* %parse_res, align 8
  %t670 = inttoptr i64 %t670_i64 to i8*
  %t671 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.80, i32 0, i32 0
  %t672_raw = call i64 @flux_map_get(i8* %t670, i8* %t671)
  %t672 = add i64 0, %t672_raw
  store i64 %t672, i64* %root_id, align 8
  %t675_i64 = load i64, i64* %flag_emit_ast, align 8
  %t675 = trunc i64 %t675_i64 to i1
  br i1 %t675, label %ft_55, label %route_arm_674
ft_55:
  %t676_i64 = load i64, i64* %parse_res, align 8
  %t676 = inttoptr i64 %t676_i64 to i8*
  %t677_res = call %flux.result @f_parseDumpAst(i8* %t676)
  %t677_val = extractvalue %flux.result %t677_res, 1
  %t677 = inttoptr i64 %t677_val to i8*
  %st_85 = ptrtoint i8* %t677 to i64
  store i64 %st_85, i64* %ast_json, align 8
  %t678 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.81, i32 0, i32 0
  %t679_i64 = load i64, i64* %input_file, align 8
  %t679 = inttoptr i64 %t679_i64 to i8*
  %t680 = call i8* @flux_str_concat(i8* %t678, i8* %t679)
  %t681 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.82, i32 0, i32 0
  %t682 = call i8* @flux_str_concat(i8* %t680, i8* %t681)
  %t683_i64 = load i64, i64* %ast_json, align 8
  %t683 = inttoptr i64 %t683_i64 to i8*
  %t684 = call i64 @flux_std_io_write_file(i8* %t682, i8* %t683)
  br label %route_end_673
route_arm_674:
  br label %route_end_673
route_end_673:
  %t686_i64 = load i64, i64* %arena, align 8
  %t686 = inttoptr i64 %t686_i64 to i8*
  %t687 = load i64, i64* %root_id, align 8
  %t688_res = call %flux.result @f_semanticAnalyze(i8* %t686, i64 %t687)
  %t688_val = extractvalue %flux.result %t688_res, 1
  %t688 = inttoptr i64 %t688_val to i8*
  %st_86 = ptrtoint i8* %t688 to i64
  store i64 %st_86, i64* %sem_report, align 8
  %t691_i64 = load i64, i64* %sem_report, align 8
  %t691 = inttoptr i64 %t691_i64 to i8*
  %t692 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.76, i32 0, i32 0
  %t693_raw = call i64 @flux_map_get(i8* %t691, i8* %t692)
  %t693 = icmp ne i64 %t693_raw, 0
  %t694 = xor i1 %t693, 1
  br i1 %t694, label %ft_56, label %route_arm_690
ft_56:
  %t695_i64 = load i64, i64* %sem_report, align 8
  %t695 = inttoptr i64 %t695_i64 to i8*
  %t696 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.83, i32 0, i32 0
  %t697_raw = call i64 @flux_map_get(i8* %t695, i8* %t696)
  %t697 = inttoptr i64 %t697_raw to i8*
  %st_87 = ptrtoint i8* %t697 to i64
  store i64 %st_87, i64* %errors, align 8
  %t698_i64 = load i64, i64* %errors, align 8
  %t698 = inttoptr i64 %t698_i64 to i8*
  %t699 = call i64 @flux_list_len(i8* %t698)
  store i64 %t699, i64* %n_err, align 8
  %t700 = add i64 0, 1
  store i64 %t700, i64* %ei, align 8
  br label %loop_start_701
loop_start_701:
  %t704 = load i64, i64* %ei, align 8
  %t705 = load i64, i64* %n_err, align 8
  %t706 = icmp sgt i64 %t704, %t705
  br i1 %t706, label %ft_57, label %route_arm_703
ft_57:
  br label %loop_end_701
route_arm_703:
  %t708 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t709_i64 = load i64, i64* %errors, align 8
  %t709 = inttoptr i64 %t709_i64 to i8*
  %t710 = load i64, i64* %ei, align 8
  %t711_raw = call i64 @flux_list_get_val(i8* %t709, i64 %t710)
  %t711 = inttoptr i64 %t711_raw to i8*
  %t712 = call i8* @flux_str_concat(i8* %t708, i8* %t711)
  %pr_sn_18 = icmp eq i8* %t712, null
  %pr_sc_18 = select i1 %pr_sn_18, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t712
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_18)
  call i32 @fflush(i8* null)
  %t713 = load i64, i64* %ei, align 8
  %t714 = add i64 0, 1
  %t715 = add i64 %t713, %t714
  store i64 %t715, i64* %ei, align 8
  br label %route_end_702
route_end_702:
  br label %loop_start_701
loop_end_701:
  %t716 = add i64 0, 1
  %t717 = call i64 @flux_std_os_exit(i64 %t716)
  br label %route_end_689
route_arm_690:
  %t719_i64 = load i64, i64* %arena, align 8
  %t719 = inttoptr i64 %t719_i64 to i8*
  %t720 = load i64, i64* %root_id, align 8
  %t721_res = call %flux.result @f_fmirBuildFromAst(i8* %t719, i64 %t720)
  %t721_val = extractvalue %flux.result %t721_res, 1
  %t721 = inttoptr i64 %t721_val to i8*
  %st_91 = ptrtoint i8* %t721 to i64
  store i64 %st_91, i64* %fmir_mod, align 8
  %t724_i64 = load i64, i64* %flag_emit_fmir, align 8
  %t724 = trunc i64 %t724_i64 to i1
  br i1 %t724, label %ft_58, label %route_arm_723
ft_58:
  %t725_i64 = load i64, i64* %fmir_mod, align 8
  %t725 = inttoptr i64 %t725_i64 to i8*
  %t726_res = call %flux.result @f_fmirDumpText(i8* %t725)
  %t726_val = extractvalue %flux.result %t726_res, 1
  %t726 = inttoptr i64 %t726_val to i8*
  %st_92 = ptrtoint i8* %t726 to i64
  store i64 %st_92, i64* %fmir_dump, align 8
  br label %route_end_722
route_arm_723:
  br label %route_end_722
route_end_722:
  %t728 = call i8* @flux_map_build(i64 0)
  %st_93 = ptrtoint i8* %t728 to i64
  store i64 %st_93, i64* %options, align 8
  %t729 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.84, i32 0, i32 0
  %t730_i64 = load i64, i64* %output_path, align 8
  %t730 = inttoptr i64 %t730_i64 to i8*
  %ms_col_1_i64 = load i64, i64* %options, align 8
  %ms_col_1 = inttoptr i64 %ms_col_1_i64 to i8*
  %p_ms_1 = ptrtoint i8* %t730 to i64
  call i8* @flux_map_set(i8* %ms_col_1, i8* %t729, i64 4, i64 %p_ms_1)
  %t731_i64 = load i64, i64* %fmir_mod, align 8
  %t731 = inttoptr i64 %t731_i64 to i8*
  %t732_i64 = load i64, i64* %target, align 8
  %t732 = inttoptr i64 %t732_i64 to i8*
  %t733_i64 = load i64, i64* %options, align 8
  %t733 = inttoptr i64 %t733_i64 to i8*
  %t734_res = call %flux.result @f_backendCompile(i8* %t731, i8* %t732, i8* %t733)
  %t734_val = extractvalue %flux.result %t734_res, 1
  %t734 = inttoptr i64 %t734_val to i8*
  %st_94 = ptrtoint i8* %t734 to i64
  store i64 %st_94, i64* %comp_res, align 8
  %t737_i64 = load i64, i64* %comp_res, align 8
  %t737 = inttoptr i64 %t737_i64 to i8*
  %t738 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.76, i32 0, i32 0
  %t739_raw = call i64 @flux_map_get(i8* %t737, i8* %t738)
  %t739 = icmp ne i64 %t739_raw, 0
  %t740 = xor i1 %t739, 1
  br i1 %t740, label %ft_59, label %route_arm_736
ft_59:
  %t741 = getelementptr inbounds [30 x i8], [30 x i8]* @.str.85, i32 0, i32 0
  %t742_i64 = load i64, i64* %target, align 8
  %t742 = inttoptr i64 %t742_i64 to i8*
  %t743 = call i8* @flux_str_concat(i8* %t741, i8* %t742)
  %pr_sn_19 = icmp eq i8* %t743, null
  %pr_sc_19 = select i1 %pr_sn_19, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t743
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_19)
  call i32 @fflush(i8* null)
  %t744 = add i64 0, 1
  %t745 = call i64 @flux_std_os_exit(i64 %t744)
  br label %route_end_735
route_arm_736:
  br label %route_end_735
route_end_735:
  %t749_i64 = load i64, i64* %target, align 8
  %t749 = inttoptr i64 %t749_i64 to i8*
  %t750 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.86, i32 0, i32 0
  %t751_cmp = call i32 @flux_str_compare(i8* %t749, i8* %t750)
  %t751 = icmp eq i32 %t751_cmp, 0
  %t752_i64 = load i64, i64* %target, align 8
  %t752 = inttoptr i64 %t752_i64 to i8*
  %t753 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.87, i32 0, i32 0
  %t754_cmp = call i32 @flux_str_compare(i8* %t752, i8* %t753)
  %t754 = icmp eq i32 %t754_cmp, 0
  %t755 = or i1 %t751, %t754
  br i1 %t755, label %ft_60, label %route_arm_748
ft_60:
  %t756 = getelementptr inbounds [65 x i8], [65 x i8]* @.str.88, i32 0, i32 0
  %t757_i64 = load i64, i64* %output_path, align 8
  %t757 = inttoptr i64 %t757_i64 to i8*
  %t758 = call i8* @flux_str_concat(i8* %t756, i8* %t757)
  %t759 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.89, i32 0, i32 0
  %t760 = call i8* @flux_str_concat(i8* %t758, i8* %t759)
  %t761_i64 = load i64, i64* %output_path, align 8
  %t761 = inttoptr i64 %t761_i64 to i8*
  %t762 = call i8* @flux_str_concat(i8* %t760, i8* %t761)
  %t763 = getelementptr inbounds [66 x i8], [66 x i8]* @.str.90, i32 0, i32 0
  %t764 = call i8* @flux_str_concat(i8* %t762, i8* %t763)
  %st_95 = ptrtoint i8* %t764 to i64
  store i64 %st_95, i64* %clang_cmd, align 8
  %t765_i64 = load i64, i64* %clang_cmd, align 8
  %t765 = inttoptr i64 %t765_i64 to i8*
  %t766 = call i64 @flux_std_os_exec(i8* %t765)
  store i64 %t766, i64* %cl_rc, align 8
  %t769 = load i64, i64* %cl_rc, align 8
  %t770 = add i64 0, 0
  %t771 = icmp ne i64 %t769, %t770
  br i1 %t771, label %ft_61, label %route_arm_768
ft_61:
  %t772 = load i64, i64* %cl_rc, align 8
  %t773 = call i64 @flux_std_os_exit(i64 %t772)
  br label %route_end_767
route_arm_768:
  %t775_i64 = load i64, i64* %flag_no_run, align 8
  %t775 = trunc i64 %t775_i64 to i1
  %t776 = xor i1 %t775, 1
  br i1 %t776, label %ft_62, label %route_arm_774
ft_62:
  %t777 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t778_i64 = load i64, i64* %output_path, align 8
  %t778 = inttoptr i64 %t778_i64 to i8*
  %t779 = call i8* @flux_str_concat(i8* %t777, i8* %t778)
  %t780 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.91, i32 0, i32 0
  %t781 = call i8* @flux_str_concat(i8* %t779, i8* %t780)
  %t782_i64 = load i64, i64* %arg_suffix, align 8
  %t782 = inttoptr i64 %t782_i64 to i8*
  %t783 = call i8* @flux_str_concat(i8* %t781, i8* %t782)
  %t784 = call i64 @flux_std_os_exec(i8* %t783)
  store i64 %t784, i64* %r_rc, align 8
  %t785 = load i64, i64* %r_rc, align 8
  %t786 = call i64 @flux_std_os_exit(i64 %t785)
  br label %route_end_767
route_arm_774:
  br label %route_end_767
route_end_767:
  br label %route_end_747
route_arm_748:
  %t789_i64 = load i64, i64* %target, align 8
  %t789 = inttoptr i64 %t789_i64 to i8*
  %t790 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.73, i32 0, i32 0
  %t791_cmp = call i32 @flux_str_compare(i8* %t789, i8* %t790)
  %t791 = icmp eq i32 %t791_cmp, 0
  br i1 %t791, label %ft_63, label %route_arm_788
ft_63:
  %t794_i64 = load i64, i64* %flag_no_run, align 8
  %t794 = trunc i64 %t794_i64 to i1
  %t795 = xor i1 %t794, 1
  br i1 %t795, label %ft_64, label %route_arm_793
ft_64:
  %t796 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.75, i32 0, i32 0
  %t797_i64 = load i64, i64* %output_path, align 8
  %t797 = inttoptr i64 %t797_i64 to i8*
  %t798 = call i8* @flux_str_concat(i8* %t796, i8* %t797)
  %t799 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.92, i32 0, i32 0
  %t800 = call i8* @flux_str_concat(i8* %t798, i8* %t799)
  %t801_i64 = load i64, i64* %arg_suffix, align 8
  %t801 = inttoptr i64 %t801_i64 to i8*
  %t802 = call i8* @flux_str_concat(i8* %t800, i8* %t801)
  %t803 = call i64 @flux_std_os_exec(i8* %t802)
  store i64 %t803, i64* %r_rc, align 8
  %t804 = load i64, i64* %r_rc, align 8
  %t805 = call i64 @flux_std_os_exit(i64 %t804)
  br label %route_end_792
route_arm_793:
  br label %route_end_792
route_end_792:
  br label %route_end_747
route_arm_788:
  %t808_i64 = load i64, i64* %target, align 8
  %t808 = inttoptr i64 %t808_i64 to i8*
  %t809 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.93, i32 0, i32 0
  %t810_cmp = call i32 @flux_str_compare(i8* %t808, i8* %t809)
  %t810 = icmp eq i32 %t810_cmp, 0
  br i1 %t810, label %ft_65, label %route_arm_807
ft_65:
  %t813_i64 = load i64, i64* %flag_no_run, align 8
  %t813 = trunc i64 %t813_i64 to i1
  %t814 = xor i1 %t813, 1
  br i1 %t814, label %ft_66, label %route_arm_812
ft_66:
  %t815 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.94, i32 0, i32 0
  %t816_i64 = load i64, i64* %output_path, align 8
  %t816 = inttoptr i64 %t816_i64 to i8*
  %t817 = call i8* @flux_str_concat(i8* %t815, i8* %t816)
  %t818 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.95, i32 0, i32 0
  %t819 = call i8* @flux_str_concat(i8* %t817, i8* %t818)
  %t820_i64 = load i64, i64* %arg_suffix, align 8
  %t820 = inttoptr i64 %t820_i64 to i8*
  %t821 = call i8* @flux_str_concat(i8* %t819, i8* %t820)
  %t822 = call i64 @flux_std_os_exec(i8* %t821)
  store i64 %t822, i64* %r_rc, align 8
  %t823 = load i64, i64* %r_rc, align 8
  %t824 = call i64 @flux_std_os_exit(i64 %t823)
  br label %route_end_811
route_arm_812:
  br label %route_end_811
route_end_811:
  br label %route_end_747
route_arm_807:
  %t827_i64 = load i64, i64* %target, align 8
  %t827 = inttoptr i64 %t827_i64 to i8*
  %t828 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.96, i32 0, i32 0
  %t829_cmp = call i32 @flux_str_compare(i8* %t827, i8* %t828)
  %t829 = icmp eq i32 %t829_cmp, 0
  %t830_i64 = load i64, i64* %target, align 8
  %t830 = inttoptr i64 %t830_i64 to i8*
  %t831 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.97, i32 0, i32 0
  %t832_cmp = call i32 @flux_str_compare(i8* %t830, i8* %t831)
  %t832 = icmp eq i32 %t832_cmp, 0
  %t833 = or i1 %t829, %t832
  br i1 %t833, label %ft_67, label %route_arm_826
ft_67:
  %t836_i64 = load i64, i64* %flag_no_run, align 8
  %t836 = trunc i64 %t836_i64 to i1
  %t837 = xor i1 %t836, 1
  br i1 %t837, label %ft_68, label %route_arm_835
ft_68:
  %t838 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.94, i32 0, i32 0
  %t839_i64 = load i64, i64* %output_path, align 8
  %t839 = inttoptr i64 %t839_i64 to i8*
  %t840 = call i8* @flux_str_concat(i8* %t838, i8* %t839)
  %t841 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.98, i32 0, i32 0
  %t842 = call i8* @flux_str_concat(i8* %t840, i8* %t841)
  %t843_i64 = load i64, i64* %arg_suffix, align 8
  %t843 = inttoptr i64 %t843_i64 to i8*
  %t844 = call i8* @flux_str_concat(i8* %t842, i8* %t843)
  %t845 = call i64 @flux_std_os_exec(i8* %t844)
  store i64 %t845, i64* %r_rc, align 8
  %t846 = load i64, i64* %r_rc, align 8
  %t847 = call i64 @flux_std_os_exit(i64 %t846)
  br label %route_end_834
route_arm_835:
  br label %route_end_834
route_end_834:
  br label %route_end_747
route_arm_826:
  br label %route_end_747
route_end_747:
  br label %route_end_689
route_end_689:
  br label %route_end_653
route_end_653:
  br label %route_end_176
route_end_176:
  br label %route_end_4
route_end_4:
  ret i32 0
}
