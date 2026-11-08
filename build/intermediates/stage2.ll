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
declare i8* @flux_std_io_read_file(i8*)
declare i64 @flux_std_io_write_file(i8*, i8*)
declare i64 @flux_std_io_file_exists(i8*)
declare i64 @flux_std_io_dir_exists(i8*)
declare i8* @flux_std_io_list_dir(i8*, i8* (i64, i64)*, i8* (i8*, i64, i64, i8*)*)
declare i8* @flux_std_io_path_join(i8*, i8*)
declare i8* @flux_std_io_path_base_name(i8*)
declare i8* @flux_std_io_path_dir_name(i8*)
declare i64 @flux_std_io_delete_file(i8*)
declare i64 @flux_std_os_exec(i8*)
declare i8* @flux_std_os_exec_output(i8*)
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
@.str.39 = private unnamed_addr constant [6 x i8] c"RT701\00", align 1
@.str.40 = private unnamed_addr constant [6 x i8] c"RT706\00", align 1
@.str.41 = private unnamed_addr constant [6 x i8] c"RT707\00", align 1
@.str.42 = private unnamed_addr constant [14 x i8] c"  \F0\9F\92\A1 Dica: \00", align 1
@.str.43 = private unnamed_addr constant [11 x i8] c"compliance\00", align 1
@.str.44 = private unnamed_addr constant [9 x i8] c"exemplos\00", align 1
@.str.45 = private unnamed_addr constant [9 x i8] c"examples\00", align 1
@.str.46 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.47 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_BE.exe\00", align 1
@.str.48 = private unnamed_addr constant [14 x i8] c"compliance_BE\00", align 1
@.str.49 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_BE.exe\00", align 1
@.str.50 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_IN.exe\00", align 1
@.str.51 = private unnamed_addr constant [14 x i8] c"compliance_IN\00", align 1
@.str.52 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_IN.exe\00", align 1
@.str.53 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_NR.exe\00", align 1
@.str.54 = private unnamed_addr constant [14 x i8] c"compliance_NR\00", align 1
@.str.55 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_NR.exe\00", align 1
@.str.56 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_SA.exe\00", align 1
@.str.57 = private unnamed_addr constant [14 x i8] c"compliance_SA\00", align 1
@.str.58 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_SA.exe\00", align 1
@.str.59 = private unnamed_addr constant [19 x i8] c"bin\5Ccompliance.exe\00", align 1
@.str.60 = private unnamed_addr constant [21 x i8] c".\5Cbin\5Ccompliance.exe\00", align 1
@.str.61 = private unnamed_addr constant [12 x i8] c"examples_in\00", align 1
@.str.62 = private unnamed_addr constant [12 x i8] c"examples_lv\00", align 1
@.str.63 = private unnamed_addr constant [12 x i8] c"examples_vm\00", align 1
@.str.64 = private unnamed_addr constant [13 x i8] c"examples_vmr\00", align 1
@.str.65 = private unnamed_addr constant [13 x i8] c"examples_was\00", align 1
@.str.66 = private unnamed_addr constant [13 x i8] c"examples_wat\00", align 1
@.str.67 = private unnamed_addr constant [12 x i8] c"exemplos_in\00", align 1
@.str.68 = private unnamed_addr constant [12 x i8] c"exemplos_lv\00", align 1
@.str.69 = private unnamed_addr constant [12 x i8] c"exemplos_vm\00", align 1
@.str.70 = private unnamed_addr constant [13 x i8] c"exemplos_vmr\00", align 1
@.str.71 = private unnamed_addr constant [13 x i8] c"exemplos_was\00", align 1
@.str.72 = private unnamed_addr constant [13 x i8] c"exemplos_wat\00", align 1
@.str.73 = private unnamed_addr constant [5 x i8] c"bin\5C\00", align 1
@.str.74 = private unnamed_addr constant [5 x i8] c".exe\00", align 1
@.str.75 = private unnamed_addr constant [7 x i8] c".\5Cbin\5C\00", align 1
@.str.76 = private unnamed_addr constant [4 x i8] c"vmr\00", align 1
@.str.77 = private unnamed_addr constant [7 x i8] c".fvmbc\00", align 1
@.str.78 = private unnamed_addr constant [19 x i8] c".\5Cbin\5Cfluxvm.exe \22\00", align 1
@.str.79 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.80 = private unnamed_addr constant [14 x i8] c"Parse Error: \00", align 1
@.str.81 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.82 = private unnamed_addr constant [6 x i8] c"arena\00", align 1
@.str.83 = private unnamed_addr constant [8 x i8] c"root_id\00", align 1
@.str.84 = private unnamed_addr constant [25 x i8] c"build/intermediates/ast/\00", align 1
@.str.85 = private unnamed_addr constant [6 x i8] c".json\00", align 1
@.str.86 = private unnamed_addr constant [7 x i8] c"errors\00", align 1
@.str.87 = private unnamed_addr constant [7 x i8] c"output\00", align 1
@.str.88 = private unnamed_addr constant [30 x i8] c"Compilation Error on target: \00", align 1
@.str.89 = private unnamed_addr constant [5 x i8] c"llvm\00", align 1
@.str.90 = private unnamed_addr constant [3 x i8] c"lv\00", align 1
@.str.91 = private unnamed_addr constant [65 x i8] c"clang -O2 -Wno-deprecated-declarations -Wno-override-module -o \22\00", align 1
@.str.92 = private unnamed_addr constant [8 x i8] c".exe\22 \22\00", align 1
@.str.93 = private unnamed_addr constant [66 x i8] c".ll\22 -Llib -lfluxcompiler -lfluxrt -ladvapi32 -lws2_32 -lkernel32\00", align 1
@.str.94 = private unnamed_addr constant [6 x i8] c".exe\22\00", align 1
@.str.95 = private unnamed_addr constant [8 x i8] c".fvmbc\22\00", align 1
@.str.96 = private unnamed_addr constant [4 x i8] c"wat\00", align 1
@.str.97 = private unnamed_addr constant [13 x i8] c"wasmer run \22\00", align 1
@.str.98 = private unnamed_addr constant [6 x i8] c".wat\22\00", align 1
@.str.99 = private unnamed_addr constant [5 x i8] c"wasm\00", align 1
@.str.100 = private unnamed_addr constant [4 x i8] c"was\00", align 1
@.str.101 = private unnamed_addr constant [7 x i8] c".wasm\22\00", align 1

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
  %t260_i64 = load i64, i64* %exp_err, align 8
  %t260 = inttoptr i64 %t260_i64 to i8*
  %t261 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.39, i32 0, i32 0
  %t262_cmp = call i32 @flux_str_compare(i8* %t260, i8* %t261)
  %t262 = icmp ne i32 %t262_cmp, 0
  %t263 = and i1 %t259, %t262
  %t264_i64 = load i64, i64* %exp_err, align 8
  %t264 = inttoptr i64 %t264_i64 to i8*
  %t265 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.40, i32 0, i32 0
  %t266_cmp = call i32 @flux_str_compare(i8* %t264, i8* %t265)
  %t266 = icmp ne i32 %t266_cmp, 0
  %t267 = and i1 %t263, %t266
  %t268_i64 = load i64, i64* %exp_err, align 8
  %t268 = inttoptr i64 %t268_i64 to i8*
  %t269 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.41, i32 0, i32 0
  %t270_cmp = call i32 @flux_str_compare(i8* %t268, i8* %t269)
  %t270 = icmp ne i32 %t270_cmp, 0
  %t271 = and i1 %t267, %t270
  br i1 %t271, label %ft_25, label %route_arm_256
ft_25:
  %t272_i64 = load i64, i64* %exp_err, align 8
  %t272 = inttoptr i64 %t272_i64 to i8*
  %t273_i64 = load i64, i64* %input_file, align 8
  %t273 = inttoptr i64 %t273_i64 to i8*
  %t274_res = call %flux.result @f_diagnosticGetHeader(i8* %t272, i8* %t273)
  %t274_val = extractvalue %flux.result %t274_res, 1
  %t274 = inttoptr i64 %t274_val to i8*
  %st_43 = ptrtoint i8* %t274 to i64
  store i64 %st_43, i64* %err_hdr, align 8
  %t275_i64 = load i64, i64* %exp_err, align 8
  %t275 = inttoptr i64 %t275_i64 to i8*
  %t276_res = call %flux.result @f_diagnosticGetHint(i8* %t275)
  %t276_val = extractvalue %flux.result %t276_res, 1
  %t276 = inttoptr i64 %t276_val to i8*
  %st_44 = ptrtoint i8* %t276 to i64
  store i64 %st_44, i64* %err_hint, align 8
  %t277_i64 = load i64, i64* %err_hdr, align 8
  %t277 = inttoptr i64 %t277_i64 to i8*
  %pr_sn_15 = icmp eq i8* %t277, null
  %pr_sc_15 = select i1 %pr_sn_15, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t277
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_15)
  call i32 @fflush(i8* null)
  %t278 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.42, i32 0, i32 0
  %t279_i64 = load i64, i64* %err_hint, align 8
  %t279 = inttoptr i64 %t279_i64 to i8*
  %t280 = call i8* @flux_str_concat(i8* %t278, i8* %t279)
  %pr_sn_16 = icmp eq i8* %t280, null
  %pr_sc_16 = select i1 %pr_sn_16, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t280
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_16)
  call i32 @fflush(i8* null)
  %t281 = add i64 0, 1
  %t282 = call i64 @flux_std_os_exit(i64 %t281)
  br label %route_end_255
route_arm_256:
  br label %route_end_255
route_end_255:
  %t284_i64 = load i64, i64* %input_file, align 8
  %t284 = inttoptr i64 %t284_i64 to i8*
  %t285 = call i64 @flux_str_len(i8* %t284)
  store i64 %t285, i64* %in_len, align 8
  %t286 = add i1 0, 0
  %st_b_46 = zext i1 %t286 to i64
  store i64 %st_b_46, i64* %is_compliance, align 8
  %t287 = add i64 0, 1
  store i64 %t287, i64* %ck, align 8
  br label %loop_start_288
loop_start_288:
  %t291 = load i64, i64* %ck, align 8
  %t292 = add i64 0, 9
  %t293 = add i64 %t291, %t292
  %t294 = load i64, i64* %in_len, align 8
  %t295 = icmp sgt i64 %t293, %t294
  br i1 %t295, label %ft_26, label %route_arm_290
ft_26:
  br label %loop_end_288
route_arm_290:
  %t297_i64 = load i64, i64* %input_file, align 8
  %t297 = inttoptr i64 %t297_i64 to i8*
  %t298 = load i64, i64* %ck, align 8
  %t299 = load i64, i64* %ck, align 8
  %t300 = add i64 0, 9
  %t301 = add i64 %t299, %t300
  %t302 = call i8* @flux_str_slice(i8* %t297, i64 %t298, i64 %t301)
  %t303 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.43, i32 0, i32 0
  %t304_cmp = call i32 @flux_str_compare(i8* %t302, i8* %t303)
  %t304 = icmp eq i32 %t304_cmp, 0
  br i1 %t304, label %ft_27, label %route_arm_296
ft_27:
  %t305 = add i1 0, 1
  %st_b_48 = zext i1 %t305 to i64
  store i64 %st_b_48, i64* %is_compliance, align 8
  br label %loop_end_288
route_arm_296:
  %t307 = load i64, i64* %ck, align 8
  %t308 = add i64 0, 1
  %t309 = add i64 %t307, %t308
  store i64 %t309, i64* %ck, align 8
  br label %route_end_289
route_end_289:
  br label %loop_start_288
loop_end_288:
  %t310 = add i1 0, 0
  %st_b_50 = zext i1 %t310 to i64
  store i64 %st_b_50, i64* %is_exemplos, align 8
  %t311 = add i64 0, 1
  store i64 %t311, i64* %ek, align 8
  br label %loop_start_312
loop_start_312:
  %t315 = load i64, i64* %ek, align 8
  %t316 = add i64 0, 7
  %t317 = add i64 %t315, %t316
  %t318 = load i64, i64* %in_len, align 8
  %t319 = icmp sgt i64 %t317, %t318
  br i1 %t319, label %ft_28, label %route_arm_314
ft_28:
  br label %loop_end_312
route_arm_314:
  %t321_i64 = load i64, i64* %input_file, align 8
  %t321 = inttoptr i64 %t321_i64 to i8*
  %t322 = load i64, i64* %ek, align 8
  %t323 = load i64, i64* %ek, align 8
  %t324 = add i64 0, 7
  %t325 = add i64 %t323, %t324
  %t326 = call i8* @flux_str_slice(i8* %t321, i64 %t322, i64 %t325)
  %t327 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.44, i32 0, i32 0
  %t328_cmp = call i32 @flux_str_compare(i8* %t326, i8* %t327)
  %t328 = icmp eq i32 %t328_cmp, 0
  %t329_i64 = load i64, i64* %input_file, align 8
  %t329 = inttoptr i64 %t329_i64 to i8*
  %t330 = load i64, i64* %ek, align 8
  %t331 = load i64, i64* %ek, align 8
  %t332 = add i64 0, 7
  %t333 = add i64 %t331, %t332
  %t334 = call i8* @flux_str_slice(i8* %t329, i64 %t330, i64 %t333)
  %t335 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.45, i32 0, i32 0
  %t336_cmp = call i32 @flux_str_compare(i8* %t334, i8* %t335)
  %t336 = icmp eq i32 %t336_cmp, 0
  %t337 = or i1 %t328, %t336
  br i1 %t337, label %ft_29, label %route_arm_320
ft_29:
  %t338 = add i1 0, 1
  %st_b_52 = zext i1 %t338 to i64
  store i64 %st_b_52, i64* %is_exemplos, align 8
  br label %loop_end_312
route_arm_320:
  %t340 = load i64, i64* %ek, align 8
  %t341 = add i64 0, 1
  %t342 = add i64 %t340, %t341
  store i64 %t342, i64* %ek, align 8
  br label %route_end_313
route_end_313:
  br label %loop_start_312
loop_end_312:
  %t343 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %st_54 = ptrtoint i8* %t343 to i64
  store i64 %st_54, i64* %arg_suffix, align 8
  %t346_i64 = load i64, i64* %extra_args, align 8
  %t346 = inttoptr i64 %t346_i64 to i8*
  %t347 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t348_cmp = call i32 @flux_str_compare(i8* %t346, i8* %t347)
  %t348 = icmp ne i32 %t348_cmp, 0
  br i1 %t348, label %ft_30, label %route_arm_345
ft_30:
  %t349 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.38, i32 0, i32 0
  %t350_i64 = load i64, i64* %extra_args, align 8
  %t350 = inttoptr i64 %t350_i64 to i8*
  %t351 = call i8* @flux_str_concat(i8* %t349, i8* %t350)
  %st_55 = ptrtoint i8* %t351 to i64
  store i64 %st_55, i64* %arg_suffix, align 8
  br label %route_end_344
route_arm_345:
  br label %route_end_344
route_end_344:
  %t355_i64 = load i64, i64* %target, align 8
  %t355 = inttoptr i64 %t355_i64 to i8*
  %t356 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.17, i32 0, i32 0
  %t357_cmp = call i32 @flux_str_compare(i8* %t355, i8* %t356)
  %t357 = icmp eq i32 %t357_cmp, 0
  %t358_i64 = load i64, i64* %target, align 8
  %t358 = inttoptr i64 %t358_i64 to i8*
  %t359 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.46, i32 0, i32 0
  %t360_cmp = call i32 @flux_str_compare(i8* %t358, i8* %t359)
  %t360 = icmp eq i32 %t360_cmp, 0
  %t361 = or i1 %t357, %t360
  br i1 %t361, label %ft_31, label %route_arm_354
ft_31:
  %t364_i64 = load i64, i64* %is_compliance, align 8
  %t364 = trunc i64 %t364_i64 to i1
  br i1 %t364, label %ft_32, label %route_arm_363
ft_32:
  %t367 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.47, i32 0, i32 0
  %t368_i64 = call i64 @flux_std_io_file_exists(i8* %t367)
  %t368 = trunc i64 %t368_i64 to i1
  %t369 = load i64, i64* %in_len, align 8
  %t370 = add i64 0, 13
  %t371 = icmp sge i64 %t369, %t370
  %t372 = and i1 %t368, %t371
  br i1 %t372, label %ft_33, label %route_arm_366
ft_33:
  %t373 = add i64 0, 1
  store i64 %t373, i64* %bi, align 8
  br label %loop_start_374
loop_start_374:
  %t377 = load i64, i64* %bi, align 8
  %t378 = add i64 0, 12
  %t379 = add i64 %t377, %t378
  %t380 = load i64, i64* %in_len, align 8
  %t381 = icmp sgt i64 %t379, %t380
  br i1 %t381, label %ft_34, label %route_arm_376
ft_34:
  br label %loop_end_374
route_arm_376:
  %t383_i64 = load i64, i64* %input_file, align 8
  %t383 = inttoptr i64 %t383_i64 to i8*
  %t384 = load i64, i64* %bi, align 8
  %t385 = load i64, i64* %bi, align 8
  %t386 = add i64 0, 12
  %t387 = add i64 %t385, %t386
  %t388 = call i8* @flux_str_slice(i8* %t383, i64 %t384, i64 %t387)
  %t389 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.48, i32 0, i32 0
  %t390_cmp = call i32 @flux_str_compare(i8* %t388, i8* %t389)
  %t390 = icmp eq i32 %t390_cmp, 0
  br i1 %t390, label %ft_35, label %route_arm_382
ft_35:
  %t391 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.49, i32 0, i32 0
  %t392_i64 = load i64, i64* %arg_suffix, align 8
  %t392 = inttoptr i64 %t392_i64 to i8*
  %t393 = call i8* @flux_str_concat(i8* %t391, i8* %t392)
  %t394 = call i64 @flux_std_os_exec(i8* %t393)
  store i64 %t394, i64* %rc, align 8
  %t395 = load i64, i64* %rc, align 8
  %t396 = call i64 @flux_std_os_exit(i64 %t395)
  br label %route_end_375
route_arm_382:
  %t398 = load i64, i64* %bi, align 8
  %t399 = add i64 0, 1
  %t400 = add i64 %t398, %t399
  store i64 %t400, i64* %bi, align 8
  br label %route_end_375
route_end_375:
  br label %loop_start_374
loop_end_374:
  br label %route_end_365
route_arm_366:
  br label %route_end_365
route_end_365:
  %t404 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.50, i32 0, i32 0
  %t405_i64 = call i64 @flux_std_io_file_exists(i8* %t404)
  %t405 = trunc i64 %t405_i64 to i1
  %t406 = load i64, i64* %in_len, align 8
  %t407 = add i64 0, 13
  %t408 = icmp sge i64 %t406, %t407
  %t409 = and i1 %t405, %t408
  br i1 %t409, label %ft_36, label %route_arm_403
ft_36:
  %t410 = add i64 0, 1
  store i64 %t410, i64* %bi, align 8
  br label %loop_start_411
loop_start_411:
  %t414 = load i64, i64* %bi, align 8
  %t415 = add i64 0, 12
  %t416 = add i64 %t414, %t415
  %t417 = load i64, i64* %in_len, align 8
  %t418 = icmp sgt i64 %t416, %t417
  br i1 %t418, label %ft_37, label %route_arm_413
ft_37:
  br label %loop_end_411
route_arm_413:
  %t420_i64 = load i64, i64* %input_file, align 8
  %t420 = inttoptr i64 %t420_i64 to i8*
  %t421 = load i64, i64* %bi, align 8
  %t422 = load i64, i64* %bi, align 8
  %t423 = add i64 0, 12
  %t424 = add i64 %t422, %t423
  %t425 = call i8* @flux_str_slice(i8* %t420, i64 %t421, i64 %t424)
  %t426 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.51, i32 0, i32 0
  %t427_cmp = call i32 @flux_str_compare(i8* %t425, i8* %t426)
  %t427 = icmp eq i32 %t427_cmp, 0
  br i1 %t427, label %ft_38, label %route_arm_419
ft_38:
  %t428 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.52, i32 0, i32 0
  %t429_i64 = load i64, i64* %arg_suffix, align 8
  %t429 = inttoptr i64 %t429_i64 to i8*
  %t430 = call i8* @flux_str_concat(i8* %t428, i8* %t429)
  %t431 = call i64 @flux_std_os_exec(i8* %t430)
  store i64 %t431, i64* %rc, align 8
  %t432 = load i64, i64* %rc, align 8
  %t433 = call i64 @flux_std_os_exit(i64 %t432)
  br label %route_end_412
route_arm_419:
  %t435 = load i64, i64* %bi, align 8
  %t436 = add i64 0, 1
  %t437 = add i64 %t435, %t436
  store i64 %t437, i64* %bi, align 8
  br label %route_end_412
route_end_412:
  br label %loop_start_411
loop_end_411:
  br label %route_end_402
route_arm_403:
  br label %route_end_402
route_end_402:
  %t441 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.53, i32 0, i32 0
  %t442_i64 = call i64 @flux_std_io_file_exists(i8* %t441)
  %t442 = trunc i64 %t442_i64 to i1
  %t443 = load i64, i64* %in_len, align 8
  %t444 = add i64 0, 13
  %t445 = icmp sge i64 %t443, %t444
  %t446 = and i1 %t442, %t445
  br i1 %t446, label %ft_39, label %route_arm_440
ft_39:
  %t447 = add i64 0, 1
  store i64 %t447, i64* %bi, align 8
  br label %loop_start_448
loop_start_448:
  %t451 = load i64, i64* %bi, align 8
  %t452 = add i64 0, 12
  %t453 = add i64 %t451, %t452
  %t454 = load i64, i64* %in_len, align 8
  %t455 = icmp sgt i64 %t453, %t454
  br i1 %t455, label %ft_40, label %route_arm_450
ft_40:
  br label %loop_end_448
route_arm_450:
  %t457_i64 = load i64, i64* %input_file, align 8
  %t457 = inttoptr i64 %t457_i64 to i8*
  %t458 = load i64, i64* %bi, align 8
  %t459 = load i64, i64* %bi, align 8
  %t460 = add i64 0, 12
  %t461 = add i64 %t459, %t460
  %t462 = call i8* @flux_str_slice(i8* %t457, i64 %t458, i64 %t461)
  %t463 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.54, i32 0, i32 0
  %t464_cmp = call i32 @flux_str_compare(i8* %t462, i8* %t463)
  %t464 = icmp eq i32 %t464_cmp, 0
  br i1 %t464, label %ft_41, label %route_arm_456
ft_41:
  %t465 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.55, i32 0, i32 0
  %t466_i64 = load i64, i64* %arg_suffix, align 8
  %t466 = inttoptr i64 %t466_i64 to i8*
  %t467 = call i8* @flux_str_concat(i8* %t465, i8* %t466)
  %t468 = call i64 @flux_std_os_exec(i8* %t467)
  store i64 %t468, i64* %rc, align 8
  %t469 = load i64, i64* %rc, align 8
  %t470 = call i64 @flux_std_os_exit(i64 %t469)
  br label %route_end_449
route_arm_456:
  %t472 = load i64, i64* %bi, align 8
  %t473 = add i64 0, 1
  %t474 = add i64 %t472, %t473
  store i64 %t474, i64* %bi, align 8
  br label %route_end_449
route_end_449:
  br label %loop_start_448
loop_end_448:
  br label %route_end_439
route_arm_440:
  br label %route_end_439
route_end_439:
  %t478 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.56, i32 0, i32 0
  %t479_i64 = call i64 @flux_std_io_file_exists(i8* %t478)
  %t479 = trunc i64 %t479_i64 to i1
  %t480 = load i64, i64* %in_len, align 8
  %t481 = add i64 0, 13
  %t482 = icmp sge i64 %t480, %t481
  %t483 = and i1 %t479, %t482
  br i1 %t483, label %ft_42, label %route_arm_477
ft_42:
  %t484 = add i64 0, 1
  store i64 %t484, i64* %bi, align 8
  br label %loop_start_485
loop_start_485:
  %t488 = load i64, i64* %bi, align 8
  %t489 = add i64 0, 12
  %t490 = add i64 %t488, %t489
  %t491 = load i64, i64* %in_len, align 8
  %t492 = icmp sgt i64 %t490, %t491
  br i1 %t492, label %ft_43, label %route_arm_487
ft_43:
  br label %loop_end_485
route_arm_487:
  %t494_i64 = load i64, i64* %input_file, align 8
  %t494 = inttoptr i64 %t494_i64 to i8*
  %t495 = load i64, i64* %bi, align 8
  %t496 = load i64, i64* %bi, align 8
  %t497 = add i64 0, 12
  %t498 = add i64 %t496, %t497
  %t499 = call i8* @flux_str_slice(i8* %t494, i64 %t495, i64 %t498)
  %t500 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.57, i32 0, i32 0
  %t501_cmp = call i32 @flux_str_compare(i8* %t499, i8* %t500)
  %t501 = icmp eq i32 %t501_cmp, 0
  br i1 %t501, label %ft_44, label %route_arm_493
ft_44:
  %t502 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.58, i32 0, i32 0
  %t503_i64 = load i64, i64* %arg_suffix, align 8
  %t503 = inttoptr i64 %t503_i64 to i8*
  %t504 = call i8* @flux_str_concat(i8* %t502, i8* %t503)
  %t505 = call i64 @flux_std_os_exec(i8* %t504)
  store i64 %t505, i64* %rc, align 8
  %t506 = load i64, i64* %rc, align 8
  %t507 = call i64 @flux_std_os_exit(i64 %t506)
  br label %route_end_486
route_arm_493:
  %t509 = load i64, i64* %bi, align 8
  %t510 = add i64 0, 1
  %t511 = add i64 %t509, %t510
  store i64 %t511, i64* %bi, align 8
  br label %route_end_486
route_end_486:
  br label %loop_start_485
loop_end_485:
  br label %route_end_476
route_arm_477:
  br label %route_end_476
route_end_476:
  %t515 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.59, i32 0, i32 0
  %t516_i64 = call i64 @flux_std_io_file_exists(i8* %t515)
  %t516 = trunc i64 %t516_i64 to i1
  %t517 = load i64, i64* %in_len, align 8
  %t518 = add i64 0, 10
  %t519 = icmp sge i64 %t517, %t518
  %t520 = and i1 %t516, %t519
  br i1 %t520, label %ft_45, label %route_arm_514
ft_45:
  %t521 = add i64 0, 1
  store i64 %t521, i64* %bi, align 8
  br label %loop_start_522
loop_start_522:
  %t525 = load i64, i64* %bi, align 8
  %t526 = add i64 0, 9
  %t527 = add i64 %t525, %t526
  %t528 = load i64, i64* %in_len, align 8
  %t529 = icmp sgt i64 %t527, %t528
  br i1 %t529, label %ft_46, label %route_arm_524
ft_46:
  br label %loop_end_522
route_arm_524:
  %t531_i64 = load i64, i64* %input_file, align 8
  %t531 = inttoptr i64 %t531_i64 to i8*
  %t532 = load i64, i64* %bi, align 8
  %t533 = load i64, i64* %bi, align 8
  %t534 = add i64 0, 9
  %t535 = add i64 %t533, %t534
  %t536 = call i8* @flux_str_slice(i8* %t531, i64 %t532, i64 %t535)
  %t537 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.43, i32 0, i32 0
  %t538_cmp = call i32 @flux_str_compare(i8* %t536, i8* %t537)
  %t538 = icmp eq i32 %t538_cmp, 0
  br i1 %t538, label %ft_47, label %route_arm_530
ft_47:
  %t539 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.60, i32 0, i32 0
  %t540_i64 = load i64, i64* %arg_suffix, align 8
  %t540 = inttoptr i64 %t540_i64 to i8*
  %t541 = call i8* @flux_str_concat(i8* %t539, i8* %t540)
  %t542 = call i64 @flux_std_os_exec(i8* %t541)
  store i64 %t542, i64* %rc, align 8
  %t543 = load i64, i64* %rc, align 8
  %t544 = call i64 @flux_std_os_exit(i64 %t543)
  br label %route_end_523
route_arm_530:
  %t546 = load i64, i64* %bi, align 8
  %t547 = add i64 0, 1
  %t548 = add i64 %t546, %t547
  store i64 %t548, i64* %bi, align 8
  br label %route_end_523
route_end_523:
  br label %loop_start_522
loop_end_522:
  br label %route_end_513
route_arm_514:
  br label %route_end_513
route_end_513:
  br label %route_end_362
route_arm_363:
  br label %route_end_362
route_end_362:
  %t553_i64 = load i64, i64* %is_exemplos, align 8
  %t553 = trunc i64 %t553_i64 to i1
  br i1 %t553, label %ft_48, label %route_arm_552
ft_48:
  %t554 = call i8* @flux_list_create(i64 16)
  %t555 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.61, i32 0, i32 0
  %p_lp_1 = ptrtoint i8* %t555 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_1)
  %t556 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.62, i32 0, i32 0
  %p_lp_2 = ptrtoint i8* %t556 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_2)
  %t557 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.63, i32 0, i32 0
  %p_lp_3 = ptrtoint i8* %t557 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_3)
  %t558 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.64, i32 0, i32 0
  %p_lp_4 = ptrtoint i8* %t558 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_4)
  %t559 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.65, i32 0, i32 0
  %p_lp_5 = ptrtoint i8* %t559 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_5)
  %t560 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.66, i32 0, i32 0
  %p_lp_6 = ptrtoint i8* %t560 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_6)
  %t561 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.67, i32 0, i32 0
  %p_lp_7 = ptrtoint i8* %t561 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_7)
  %t562 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.68, i32 0, i32 0
  %p_lp_8 = ptrtoint i8* %t562 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_8)
  %t563 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.69, i32 0, i32 0
  %p_lp_9 = ptrtoint i8* %t563 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_9)
  %t564 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.70, i32 0, i32 0
  %p_lp_10 = ptrtoint i8* %t564 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_10)
  %t565 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.71, i32 0, i32 0
  %p_lp_11 = ptrtoint i8* %t565 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_11)
  %t566 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.72, i32 0, i32 0
  %p_lp_12 = ptrtoint i8* %t566 to i64
  call void @flux_list_push_val(i8* %t554, i64 %p_lp_12)
  %st_71 = ptrtoint i8* %t554 to i64
  store i64 %st_71, i64* %ex_names, align 8
  %t567 = add i64 0, 1
  store i64 %t567, i64* %eni, align 8
  br label %loop_start_568
loop_start_568:
  %t571 = load i64, i64* %eni, align 8
  %t572 = add i64 0, 12
  %t573 = icmp sgt i64 %t571, %t572
  br i1 %t573, label %ft_49, label %route_arm_570
ft_49:
  br label %loop_end_568
route_arm_570:
  %t575 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t576_i64 = load i64, i64* %ex_names, align 8
  %t576 = inttoptr i64 %t576_i64 to i8*
  %t577 = load i64, i64* %eni, align 8
  %t578_raw = call i64 @flux_list_get_val(i8* %t576, i64 %t577)
  %t578 = inttoptr i64 %t578_raw to i8*
  %t579 = call i8* @flux_str_concat(i8* %t575, i8* %t578)
  %st_73 = ptrtoint i8* %t579 to i64
  store i64 %st_73, i64* %enm, align 8
  %t580_i64 = load i64, i64* %enm, align 8
  %t580 = inttoptr i64 %t580_i64 to i8*
  %t581 = call i64 @flux_str_len(i8* %t580)
  store i64 %t581, i64* %enmlen, align 8
  %t582 = add i64 0, 1
  store i64 %t582, i64* %ebi, align 8
  br label %loop_start_583
loop_start_583:
  %t586 = load i64, i64* %ebi, align 8
  %t587 = load i64, i64* %enmlen, align 8
  %t588 = add i64 %t586, %t587
  %t589 = add i64 0, 1
  %t590 = sub i64 %t588, %t589
  %t591 = load i64, i64* %in_len, align 8
  %t592 = icmp sgt i64 %t590, %t591
  br i1 %t592, label %ft_50, label %route_arm_585
ft_50:
  br label %loop_end_583
route_arm_585:
  %t594_i64 = load i64, i64* %input_file, align 8
  %t594 = inttoptr i64 %t594_i64 to i8*
  %t595 = load i64, i64* %ebi, align 8
  %t596 = load i64, i64* %ebi, align 8
  %t597 = load i64, i64* %enmlen, align 8
  %t598 = add i64 %t596, %t597
  %t599 = add i64 0, 1
  %t600 = sub i64 %t598, %t599
  %t601 = call i8* @flux_str_slice(i8* %t594, i64 %t595, i64 %t600)
  %t602_i64 = load i64, i64* %enm, align 8
  %t602 = inttoptr i64 %t602_i64 to i8*
  %t603_cmp = call i32 @flux_str_compare(i8* %t601, i8* %t602)
  %t603 = icmp eq i32 %t603_cmp, 0
  br i1 %t603, label %ft_51, label %route_arm_593
ft_51:
  %t604_i64 = load i64, i64* %enm, align 8
  %t604 = inttoptr i64 %t604_i64 to i8*
  %st_76 = ptrtoint i8* %t604 to i64
  store i64 %st_76, i64* %bin_name, align 8
  %t607 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.73, i32 0, i32 0
  %t608_i64 = load i64, i64* %bin_name, align 8
  %t608 = inttoptr i64 %t608_i64 to i8*
  %t609 = call i8* @flux_str_concat(i8* %t607, i8* %t608)
  %t610 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.74, i32 0, i32 0
  %t611 = call i8* @flux_str_concat(i8* %t609, i8* %t610)
  %t612_i64 = call i64 @flux_std_io_file_exists(i8* %t611)
  %t612 = trunc i64 %t612_i64 to i1
  br i1 %t612, label %ft_52, label %route_arm_606
ft_52:
  %t613 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.75, i32 0, i32 0
  %t614_i64 = load i64, i64* %bin_name, align 8
  %t614 = inttoptr i64 %t614_i64 to i8*
  %t615 = call i8* @flux_str_concat(i8* %t613, i8* %t614)
  %t616 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.74, i32 0, i32 0
  %t617 = call i8* @flux_str_concat(i8* %t615, i8* %t616)
  %t618_i64 = load i64, i64* %arg_suffix, align 8
  %t618 = inttoptr i64 %t618_i64 to i8*
  %t619 = call i8* @flux_str_concat(i8* %t617, i8* %t618)
  %t620 = call i64 @flux_std_os_exec(i8* %t619)
  store i64 %t620, i64* %rc, align 8
  %t621 = load i64, i64* %rc, align 8
  %t622 = call i64 @flux_std_os_exit(i64 %t621)
  br label %route_end_605
route_arm_606:
  br label %route_end_605
route_end_605:
  br label %loop_end_583
route_arm_593:
  %t625 = load i64, i64* %ebi, align 8
  %t626 = add i64 0, 1
  %t627 = add i64 %t625, %t626
  store i64 %t627, i64* %ebi, align 8
  br label %route_end_584
route_end_584:
  br label %loop_start_583
loop_end_583:
  %t628 = load i64, i64* %eni, align 8
  %t629 = add i64 0, 1
  %t630 = add i64 %t628, %t629
  store i64 %t630, i64* %eni, align 8
  br label %route_end_569
route_end_569:
  br label %loop_start_568
loop_end_568:
  br label %route_end_551
route_arm_552:
  br label %route_end_551
route_end_551:
  br label %route_end_353
route_arm_354:
  br label %route_end_353
route_end_353:
  %t635_i64 = load i64, i64* %target, align 8
  %t635 = inttoptr i64 %t635_i64 to i8*
  %t636 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.76, i32 0, i32 0
  %t637_cmp = call i32 @flux_str_compare(i8* %t635, i8* %t636)
  %t637 = icmp eq i32 %t637_cmp, 0
  %t638 = load i64, i64* %in_len, align 8
  %t639 = add i64 0, 6
  %t640 = icmp sge i64 %t638, %t639
  %t641 = and i1 %t637, %t640
  %t642_i64 = load i64, i64* %input_file, align 8
  %t642 = inttoptr i64 %t642_i64 to i8*
  %t643 = load i64, i64* %in_len, align 8
  %t644 = add i64 0, 5
  %t645 = sub i64 %t643, %t644
  %t646 = load i64, i64* %in_len, align 8
  %t647 = call i8* @flux_str_slice(i8* %t642, i64 %t645, i64 %t646)
  %t648 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.77, i32 0, i32 0
  %t649_cmp = call i32 @flux_str_compare(i8* %t647, i8* %t648)
  %t649 = icmp eq i32 %t649_cmp, 0
  %t650 = and i1 %t641, %t649
  br i1 %t650, label %ft_53, label %route_arm_634
ft_53:
  %t651 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.78, i32 0, i32 0
  %t652_i64 = load i64, i64* %input_file, align 8
  %t652 = inttoptr i64 %t652_i64 to i8*
  %t653 = call i8* @flux_str_concat(i8* %t651, i8* %t652)
  %t654 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t655 = call i8* @flux_str_concat(i8* %t653, i8* %t654)
  %t656_i64 = load i64, i64* %arg_suffix, align 8
  %t656 = inttoptr i64 %t656_i64 to i8*
  %t657 = call i8* @flux_str_concat(i8* %t655, i8* %t656)
  %st_80 = ptrtoint i8* %t657 to i64
  store i64 %st_80, i64* %vm_cmd, align 8
  %t658_i64 = load i64, i64* %vm_cmd, align 8
  %t658 = inttoptr i64 %t658_i64 to i8*
  %t659 = call i64 @flux_std_os_exec(i8* %t658)
  store i64 %t659, i64* %vm_rc, align 8
  %t660 = load i64, i64* %vm_rc, align 8
  %t661 = call i64 @flux_std_os_exit(i64 %t660)
  br label %route_end_633
route_arm_634:
  br label %route_end_633
route_end_633:
  %t663_i64 = load i64, i64* %input_file, align 8
  %t663 = inttoptr i64 %t663_i64 to i8*
  %t664_res = call %flux.result @f_parseFile(i8* %t663)
  %t664_val = extractvalue %flux.result %t664_res, 1
  %t664 = inttoptr i64 %t664_val to i8*
  %st_82 = ptrtoint i8* %t664 to i64
  store i64 %st_82, i64* %parse_res, align 8
  %t667_i64 = load i64, i64* %parse_res, align 8
  %t667 = inttoptr i64 %t667_i64 to i8*
  %t668 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.79, i32 0, i32 0
  %t669_raw = call i64 @flux_map_get(i8* %t667, i8* %t668)
  %t669 = icmp ne i64 %t669_raw, 0
  %t670 = xor i1 %t669, 1
  br i1 %t670, label %ft_54, label %route_arm_666
ft_54:
  %t671 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.80, i32 0, i32 0
  %t672_i64 = load i64, i64* %parse_res, align 8
  %t672 = inttoptr i64 %t672_i64 to i8*
  %t673 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.81, i32 0, i32 0
  %t674_raw = call i64 @flux_map_get(i8* %t672, i8* %t673)
  %t674 = inttoptr i64 %t674_raw to i8*
  %t675 = call i8* @flux_str_concat(i8* %t671, i8* %t674)
  %pr_sn_17 = icmp eq i8* %t675, null
  %pr_sc_17 = select i1 %pr_sn_17, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t675
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_17)
  call i32 @fflush(i8* null)
  %t676 = add i64 0, 1
  %t677 = call i64 @flux_std_os_exit(i64 %t676)
  br label %route_end_665
route_arm_666:
  %t679_i64 = load i64, i64* %parse_res, align 8
  %t679 = inttoptr i64 %t679_i64 to i8*
  %t680 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.82, i32 0, i32 0
  %t681_raw = call i64 @flux_map_get(i8* %t679, i8* %t680)
  %t681 = inttoptr i64 %t681_raw to i8*
  %st_83 = ptrtoint i8* %t681 to i64
  store i64 %st_83, i64* %arena, align 8
  %t682_i64 = load i64, i64* %parse_res, align 8
  %t682 = inttoptr i64 %t682_i64 to i8*
  %t683 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.83, i32 0, i32 0
  %t684_raw = call i64 @flux_map_get(i8* %t682, i8* %t683)
  %t684 = add i64 0, %t684_raw
  store i64 %t684, i64* %root_id, align 8
  %t687_i64 = load i64, i64* %flag_emit_ast, align 8
  %t687 = trunc i64 %t687_i64 to i1
  br i1 %t687, label %ft_55, label %route_arm_686
ft_55:
  %t688_i64 = load i64, i64* %parse_res, align 8
  %t688 = inttoptr i64 %t688_i64 to i8*
  %t689_res = call %flux.result @f_parseDumpAst(i8* %t688)
  %t689_val = extractvalue %flux.result %t689_res, 1
  %t689 = inttoptr i64 %t689_val to i8*
  %st_85 = ptrtoint i8* %t689 to i64
  store i64 %st_85, i64* %ast_json, align 8
  %t690 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.84, i32 0, i32 0
  %t691_i64 = load i64, i64* %input_file, align 8
  %t691 = inttoptr i64 %t691_i64 to i8*
  %t692 = call i8* @flux_str_concat(i8* %t690, i8* %t691)
  %t693 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.85, i32 0, i32 0
  %t694 = call i8* @flux_str_concat(i8* %t692, i8* %t693)
  %t695_i64 = load i64, i64* %ast_json, align 8
  %t695 = inttoptr i64 %t695_i64 to i8*
  %t696 = call i64 @flux_std_io_write_file(i8* %t694, i8* %t695)
  br label %route_end_685
route_arm_686:
  br label %route_end_685
route_end_685:
  %t698_i64 = load i64, i64* %arena, align 8
  %t698 = inttoptr i64 %t698_i64 to i8*
  %t699 = load i64, i64* %root_id, align 8
  %t700_res = call %flux.result @f_semanticAnalyze(i8* %t698, i64 %t699)
  %t700_val = extractvalue %flux.result %t700_res, 1
  %t700 = inttoptr i64 %t700_val to i8*
  %st_86 = ptrtoint i8* %t700 to i64
  store i64 %st_86, i64* %sem_report, align 8
  %t703_i64 = load i64, i64* %sem_report, align 8
  %t703 = inttoptr i64 %t703_i64 to i8*
  %t704 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.79, i32 0, i32 0
  %t705_raw = call i64 @flux_map_get(i8* %t703, i8* %t704)
  %t705 = icmp ne i64 %t705_raw, 0
  %t706 = xor i1 %t705, 1
  br i1 %t706, label %ft_56, label %route_arm_702
ft_56:
  %t707_i64 = load i64, i64* %sem_report, align 8
  %t707 = inttoptr i64 %t707_i64 to i8*
  %t708 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.86, i32 0, i32 0
  %t709_raw = call i64 @flux_map_get(i8* %t707, i8* %t708)
  %t709 = inttoptr i64 %t709_raw to i8*
  %st_87 = ptrtoint i8* %t709 to i64
  store i64 %st_87, i64* %errors, align 8
  %t710_i64 = load i64, i64* %errors, align 8
  %t710 = inttoptr i64 %t710_i64 to i8*
  %t711 = call i64 @flux_list_len(i8* %t710)
  store i64 %t711, i64* %n_err, align 8
  %t712 = add i64 0, 1
  store i64 %t712, i64* %ei, align 8
  br label %loop_start_713
loop_start_713:
  %t716 = load i64, i64* %ei, align 8
  %t717 = load i64, i64* %n_err, align 8
  %t718 = icmp sgt i64 %t716, %t717
  br i1 %t718, label %ft_57, label %route_arm_715
ft_57:
  br label %loop_end_713
route_arm_715:
  %t720 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.16, i32 0, i32 0
  %t721_i64 = load i64, i64* %errors, align 8
  %t721 = inttoptr i64 %t721_i64 to i8*
  %t722 = load i64, i64* %ei, align 8
  %t723_raw = call i64 @flux_list_get_val(i8* %t721, i64 %t722)
  %t723 = inttoptr i64 %t723_raw to i8*
  %t724 = call i8* @flux_str_concat(i8* %t720, i8* %t723)
  %pr_sn_18 = icmp eq i8* %t724, null
  %pr_sc_18 = select i1 %pr_sn_18, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t724
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_18)
  call i32 @fflush(i8* null)
  %t725 = load i64, i64* %ei, align 8
  %t726 = add i64 0, 1
  %t727 = add i64 %t725, %t726
  store i64 %t727, i64* %ei, align 8
  br label %route_end_714
route_end_714:
  br label %loop_start_713
loop_end_713:
  %t728 = add i64 0, 1
  %t729 = call i64 @flux_std_os_exit(i64 %t728)
  br label %route_end_701
route_arm_702:
  %t731_i64 = load i64, i64* %arena, align 8
  %t731 = inttoptr i64 %t731_i64 to i8*
  %t732 = load i64, i64* %root_id, align 8
  %t733_res = call %flux.result @f_fmirBuildFromAst(i8* %t731, i64 %t732)
  %t733_val = extractvalue %flux.result %t733_res, 1
  %t733 = inttoptr i64 %t733_val to i8*
  %st_91 = ptrtoint i8* %t733 to i64
  store i64 %st_91, i64* %fmir_mod, align 8
  %t736_i64 = load i64, i64* %flag_emit_fmir, align 8
  %t736 = trunc i64 %t736_i64 to i1
  br i1 %t736, label %ft_58, label %route_arm_735
ft_58:
  %t737_i64 = load i64, i64* %fmir_mod, align 8
  %t737 = inttoptr i64 %t737_i64 to i8*
  %t738_res = call %flux.result @f_fmirDumpText(i8* %t737)
  %t738_val = extractvalue %flux.result %t738_res, 1
  %t738 = inttoptr i64 %t738_val to i8*
  %st_92 = ptrtoint i8* %t738 to i64
  store i64 %st_92, i64* %fmir_dump, align 8
  br label %route_end_734
route_arm_735:
  br label %route_end_734
route_end_734:
  %t740 = call i8* @flux_map_build(i64 0)
  %st_93 = ptrtoint i8* %t740 to i64
  store i64 %st_93, i64* %options, align 8
  %t741 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.87, i32 0, i32 0
  %t742_i64 = load i64, i64* %output_path, align 8
  %t742 = inttoptr i64 %t742_i64 to i8*
  %ms_col_1_i64 = load i64, i64* %options, align 8
  %ms_col_1 = inttoptr i64 %ms_col_1_i64 to i8*
  %p_ms_1 = ptrtoint i8* %t742 to i64
  call i8* @flux_map_set(i8* %ms_col_1, i8* %t741, i64 4, i64 %p_ms_1)
  %t743_i64 = load i64, i64* %fmir_mod, align 8
  %t743 = inttoptr i64 %t743_i64 to i8*
  %t744_i64 = load i64, i64* %target, align 8
  %t744 = inttoptr i64 %t744_i64 to i8*
  %t745_i64 = load i64, i64* %options, align 8
  %t745 = inttoptr i64 %t745_i64 to i8*
  %t746_res = call %flux.result @f_backendCompile(i8* %t743, i8* %t744, i8* %t745)
  %t746_val = extractvalue %flux.result %t746_res, 1
  %t746 = inttoptr i64 %t746_val to i8*
  %st_94 = ptrtoint i8* %t746 to i64
  store i64 %st_94, i64* %comp_res, align 8
  %t749_i64 = load i64, i64* %comp_res, align 8
  %t749 = inttoptr i64 %t749_i64 to i8*
  %t750 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.79, i32 0, i32 0
  %t751_raw = call i64 @flux_map_get(i8* %t749, i8* %t750)
  %t751 = icmp ne i64 %t751_raw, 0
  %t752 = xor i1 %t751, 1
  br i1 %t752, label %ft_59, label %route_arm_748
ft_59:
  %t753 = getelementptr inbounds [30 x i8], [30 x i8]* @.str.88, i32 0, i32 0
  %t754_i64 = load i64, i64* %target, align 8
  %t754 = inttoptr i64 %t754_i64 to i8*
  %t755 = call i8* @flux_str_concat(i8* %t753, i8* %t754)
  %pr_sn_19 = icmp eq i8* %t755, null
  %pr_sc_19 = select i1 %pr_sn_19, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t755
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_19)
  call i32 @fflush(i8* null)
  %t756 = add i64 0, 1
  %t757 = call i64 @flux_std_os_exit(i64 %t756)
  br label %route_end_747
route_arm_748:
  br label %route_end_747
route_end_747:
  %t761_i64 = load i64, i64* %target, align 8
  %t761 = inttoptr i64 %t761_i64 to i8*
  %t762 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.89, i32 0, i32 0
  %t763_cmp = call i32 @flux_str_compare(i8* %t761, i8* %t762)
  %t763 = icmp eq i32 %t763_cmp, 0
  %t764_i64 = load i64, i64* %target, align 8
  %t764 = inttoptr i64 %t764_i64 to i8*
  %t765 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.90, i32 0, i32 0
  %t766_cmp = call i32 @flux_str_compare(i8* %t764, i8* %t765)
  %t766 = icmp eq i32 %t766_cmp, 0
  %t767 = or i1 %t763, %t766
  br i1 %t767, label %ft_60, label %route_arm_760
ft_60:
  %t768 = getelementptr inbounds [65 x i8], [65 x i8]* @.str.91, i32 0, i32 0
  %t769_i64 = load i64, i64* %output_path, align 8
  %t769 = inttoptr i64 %t769_i64 to i8*
  %t770 = call i8* @flux_str_concat(i8* %t768, i8* %t769)
  %t771 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.92, i32 0, i32 0
  %t772 = call i8* @flux_str_concat(i8* %t770, i8* %t771)
  %t773_i64 = load i64, i64* %output_path, align 8
  %t773 = inttoptr i64 %t773_i64 to i8*
  %t774 = call i8* @flux_str_concat(i8* %t772, i8* %t773)
  %t775 = getelementptr inbounds [66 x i8], [66 x i8]* @.str.93, i32 0, i32 0
  %t776 = call i8* @flux_str_concat(i8* %t774, i8* %t775)
  %st_95 = ptrtoint i8* %t776 to i64
  store i64 %st_95, i64* %clang_cmd, align 8
  %t777_i64 = load i64, i64* %clang_cmd, align 8
  %t777 = inttoptr i64 %t777_i64 to i8*
  %t778 = call i64 @flux_std_os_exec(i8* %t777)
  store i64 %t778, i64* %cl_rc, align 8
  %t781 = load i64, i64* %cl_rc, align 8
  %t782 = add i64 0, 0
  %t783 = icmp ne i64 %t781, %t782
  br i1 %t783, label %ft_61, label %route_arm_780
ft_61:
  %t784 = load i64, i64* %cl_rc, align 8
  %t785 = call i64 @flux_std_os_exit(i64 %t784)
  br label %route_end_779
route_arm_780:
  %t787_i64 = load i64, i64* %flag_no_run, align 8
  %t787 = trunc i64 %t787_i64 to i1
  %t788 = xor i1 %t787, 1
  br i1 %t788, label %ft_62, label %route_arm_786
ft_62:
  %t789 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.30, i32 0, i32 0
  %t790_i64 = load i64, i64* %output_path, align 8
  %t790 = inttoptr i64 %t790_i64 to i8*
  %t791 = call i8* @flux_str_concat(i8* %t789, i8* %t790)
  %t792 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.94, i32 0, i32 0
  %t793 = call i8* @flux_str_concat(i8* %t791, i8* %t792)
  %t794_i64 = load i64, i64* %arg_suffix, align 8
  %t794 = inttoptr i64 %t794_i64 to i8*
  %t795 = call i8* @flux_str_concat(i8* %t793, i8* %t794)
  %t796 = call i64 @flux_std_os_exec(i8* %t795)
  store i64 %t796, i64* %r_rc, align 8
  %t797 = load i64, i64* %r_rc, align 8
  %t798 = call i64 @flux_std_os_exit(i64 %t797)
  br label %route_end_779
route_arm_786:
  br label %route_end_779
route_end_779:
  br label %route_end_759
route_arm_760:
  %t801_i64 = load i64, i64* %target, align 8
  %t801 = inttoptr i64 %t801_i64 to i8*
  %t802 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.76, i32 0, i32 0
  %t803_cmp = call i32 @flux_str_compare(i8* %t801, i8* %t802)
  %t803 = icmp eq i32 %t803_cmp, 0
  br i1 %t803, label %ft_63, label %route_arm_800
ft_63:
  %t806_i64 = load i64, i64* %flag_no_run, align 8
  %t806 = trunc i64 %t806_i64 to i1
  %t807 = xor i1 %t806, 1
  br i1 %t807, label %ft_64, label %route_arm_805
ft_64:
  %t808 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.78, i32 0, i32 0
  %t809_i64 = load i64, i64* %output_path, align 8
  %t809 = inttoptr i64 %t809_i64 to i8*
  %t810 = call i8* @flux_str_concat(i8* %t808, i8* %t809)
  %t811 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.95, i32 0, i32 0
  %t812 = call i8* @flux_str_concat(i8* %t810, i8* %t811)
  %t813_i64 = load i64, i64* %arg_suffix, align 8
  %t813 = inttoptr i64 %t813_i64 to i8*
  %t814 = call i8* @flux_str_concat(i8* %t812, i8* %t813)
  %t815 = call i64 @flux_std_os_exec(i8* %t814)
  store i64 %t815, i64* %r_rc, align 8
  %t816 = load i64, i64* %r_rc, align 8
  %t817 = call i64 @flux_std_os_exit(i64 %t816)
  br label %route_end_804
route_arm_805:
  br label %route_end_804
route_end_804:
  br label %route_end_759
route_arm_800:
  %t820_i64 = load i64, i64* %target, align 8
  %t820 = inttoptr i64 %t820_i64 to i8*
  %t821 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.96, i32 0, i32 0
  %t822_cmp = call i32 @flux_str_compare(i8* %t820, i8* %t821)
  %t822 = icmp eq i32 %t822_cmp, 0
  br i1 %t822, label %ft_65, label %route_arm_819
ft_65:
  %t825_i64 = load i64, i64* %flag_no_run, align 8
  %t825 = trunc i64 %t825_i64 to i1
  %t826 = xor i1 %t825, 1
  br i1 %t826, label %ft_66, label %route_arm_824
ft_66:
  %t827 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.97, i32 0, i32 0
  %t828_i64 = load i64, i64* %output_path, align 8
  %t828 = inttoptr i64 %t828_i64 to i8*
  %t829 = call i8* @flux_str_concat(i8* %t827, i8* %t828)
  %t830 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.98, i32 0, i32 0
  %t831 = call i8* @flux_str_concat(i8* %t829, i8* %t830)
  %t832_i64 = load i64, i64* %arg_suffix, align 8
  %t832 = inttoptr i64 %t832_i64 to i8*
  %t833 = call i8* @flux_str_concat(i8* %t831, i8* %t832)
  %t834 = call i64 @flux_std_os_exec(i8* %t833)
  store i64 %t834, i64* %r_rc, align 8
  %t835 = load i64, i64* %r_rc, align 8
  %t836 = call i64 @flux_std_os_exit(i64 %t835)
  br label %route_end_823
route_arm_824:
  br label %route_end_823
route_end_823:
  br label %route_end_759
route_arm_819:
  %t839_i64 = load i64, i64* %target, align 8
  %t839 = inttoptr i64 %t839_i64 to i8*
  %t840 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.99, i32 0, i32 0
  %t841_cmp = call i32 @flux_str_compare(i8* %t839, i8* %t840)
  %t841 = icmp eq i32 %t841_cmp, 0
  %t842_i64 = load i64, i64* %target, align 8
  %t842 = inttoptr i64 %t842_i64 to i8*
  %t843 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.100, i32 0, i32 0
  %t844_cmp = call i32 @flux_str_compare(i8* %t842, i8* %t843)
  %t844 = icmp eq i32 %t844_cmp, 0
  %t845 = or i1 %t841, %t844
  br i1 %t845, label %ft_67, label %route_arm_838
ft_67:
  %t848_i64 = load i64, i64* %flag_no_run, align 8
  %t848 = trunc i64 %t848_i64 to i1
  %t849 = xor i1 %t848, 1
  br i1 %t849, label %ft_68, label %route_arm_847
ft_68:
  %t850 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.97, i32 0, i32 0
  %t851_i64 = load i64, i64* %output_path, align 8
  %t851 = inttoptr i64 %t851_i64 to i8*
  %t852 = call i8* @flux_str_concat(i8* %t850, i8* %t851)
  %t853 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.101, i32 0, i32 0
  %t854 = call i8* @flux_str_concat(i8* %t852, i8* %t853)
  %t855_i64 = load i64, i64* %arg_suffix, align 8
  %t855 = inttoptr i64 %t855_i64 to i8*
  %t856 = call i8* @flux_str_concat(i8* %t854, i8* %t855)
  %t857 = call i64 @flux_std_os_exec(i8* %t856)
  store i64 %t857, i64* %r_rc, align 8
  %t858 = load i64, i64* %r_rc, align 8
  %t859 = call i64 @flux_std_os_exit(i64 %t858)
  br label %route_end_846
route_arm_847:
  br label %route_end_846
route_end_846:
  br label %route_end_759
route_arm_838:
  br label %route_end_759
route_end_759:
  br label %route_end_701
route_end_701:
  br label %route_end_665
route_end_665:
  br label %route_end_176
route_end_176:
  br label %route_end_4
route_end_4:
  ret i32 0
}
