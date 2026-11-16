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
declare %flux.result @f_vmrExecuteFile(i8*)

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
declare i64 @atoll(i8*)
declare double @atof(i8*)
declare i8* @flux_str_concat(i8*, i8*)
declare i32 @flux_str_compare(i8*, i8*)
declare i8* @flux_str_slice(i8*, i64, i64)
declare i8* @flux_list_slice(i8*, i64, i64)
declare i64 @flux_str_len(i8*)
declare i8* @flux_list_create(i64)
declare void @flux_list_push_val(i8*, i64)
declare i64 @flux_list_get_val(i8*, i64)
declare i64 @flux_list_get(i8*, i64)
declare void @flux_list_set(i8*, i64, i64)
declare void @flux_list_set_tagged(i8*, i64, i64, i64)
declare void @flux_list_push_tagged(i8*, i64, i64)
declare i64 @flux_list_contains(i8*, i64)
declare void @flux_set_add_tagged(i8*, i64, i64)
declare i8* @flux_dataflow_join(i64, i64, i64, i64)
declare i8* @flux_complex_neg(i8*)
declare i64 @flux_list_len(i8*)
declare i1 @flux_is_list(i8*)
declare i8* @flux_map_build(i64)
declare void @flux_list_print(i8*)
declare void @flux_map_print(i8*)
declare i8* @flux_map_set(i8*, i8*, i64, i64)
declare i64 @flux_map_get(i8*, i8*)
declare i64 @flux_map_get_tag(i8*, i8*)
declare i1 @flux_map_contains_key(i8*, i8*)
declare i8* @flux_map_key_at(i8*, i64)
declare i64 @flux_map_len(i8*)
declare i8* @flux_std_io_read_file(i8*)
declare i8* @flux_runtime_input_string(i8*, i8*)
declare i64 @flux_std_io_write_file(i8*, i8*)
declare i8* @flux_std_io_read_hex_file(i8*)
declare i8* @flux_std_io_write_hex_file(i8*, i8*)
declare i8* @flux_std_string_llvm_escape(i8*)
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
declare i8* @flux_std_runtime_backend()
declare i8* @flux_std_runtime_compiler_version()
declare i8* @flux_std_runtime_executable_path()
declare i64 @flux_std_runtime_allocated_memory()
declare i64 @flux_std_runtime_heap_size()
declare i64 @flux_std_runtime_pointer_of(i8*)
declare i8* @flux_std_runtime_stack_trace(i8* (i64, i64)*, i8* (i8*, i64, i64, i8*)*)
declare i64 @flux_std_runtime_panic(i8*)
declare i64 @flux_std_runtime_trap()
declare i64 @flux_std_datetime_now()
declare i64 @flux_std_datetime_monotonic_now()
declare i64 @flux_std_datetime_monotonic_elapsed(i64)

declare i64 @flux_std_datetime_today()
declare i64 @flux_std_datetime_time()
declare i64 @flux_std_datetime_create_date(i64, i64, i64)
declare i64 @flux_std_datetime_create_time(i64, i64, i64)
declare i64 @flux_std_datetime_create_time_full(i64, i64, i64, i64, i64, i64)
declare i64 @flux_std_datetime_parse_iso(i8*)
declare i8* @flux_std_datetime_to_iso(i64)
declare i8* @flux_std_datetime_format(i64, i8*)
declare i64 @flux_std_datetime_year(i64)
declare i64 @flux_std_datetime_month(i64)
declare i64 @flux_std_datetime_day(i64)
declare i64 @flux_std_datetime_hour(i64)
declare i64 @flux_std_datetime_minute(i64)
declare i64 @flux_std_datetime_second(i64)
declare i64 @flux_std_datetime_millisecond(i64)
declare i64 @flux_std_datetime_microsecond(i64)
declare i64 @flux_std_datetime_nanosecond(i64)
declare i64 @flux_std_datetime_weekday(i64)
declare i64 @flux_std_datetime_day_of_year(i64)
declare i64 @flux_std_datetime_days_in_month(i64)
declare i64 @flux_std_datetime_quarter(i64)
declare i64 @flux_std_datetime_is_leap_year(i64)
declare i64 @flux_std_datetime_is_weekend(i64)
declare i64 @flux_std_datetime_add_days(i64, i64)
declare i64 @flux_std_datetime_add_hours(i64, i64)
declare i64 @flux_std_datetime_add_minutes(i64, i64)
declare i64 @flux_std_datetime_add_seconds(i64, i64)
declare i64 @flux_std_datetime_add_milliseconds(i64, i64)
declare i64 @flux_std_datetime_add_microseconds(i64, i64)
declare i64 @flux_std_datetime_add_nanoseconds(i64, i64)
declare i64 @flux_std_datetime_add_months(i64, i64)
declare i64 @flux_std_datetime_add_years(i64, i64)
declare i64 @flux_std_datetime_is_before(i64, i64)
declare i64 @flux_std_datetime_is_after(i64, i64)
declare i64 @flux_std_datetime_compare(i64, i64)
declare i64 @flux_std_datetime_days_between(i64, i64)
declare i64 @flux_std_datetime_months_between(i64, i64)
declare i64 @flux_std_datetime_years_between(i64, i64)
declare i64 @flux_std_datetime_hours_between(i64, i64)
declare i64 @flux_std_datetime_minutes_between(i64, i64)
declare i64 @flux_std_datetime_seconds_between(i64, i64)
declare i64 @flux_std_datetime_milliseconds_between(i64, i64)
declare i64 @flux_std_datetime_microseconds_between(i64, i64)
declare i64 @flux_std_datetime_nanoseconds_between(i64, i64)
declare i8* @flux_std_datetime_to_timezone(i64, i8*)
declare i8* @flux_std_datetime_to_local(i64)
declare i64 @flux_std_datetime_to_utc(i64)
declare double @flux_std_datetime_utc_offset(i64, i8*)
declare i8* @flux_std_datetime_local_timezone()
declare i64 @flux_std_datetime_is_daylight_saving_time(i64, i8*)
declare double @flux_std_datetime_dst_offset(i64, i8*)
declare i8* @flux_float_to_str(double)
declare i8* @flux_val_to_str(i64)
declare void @flux_val_print(i64)
declare i8* @flux_set_to_str(i8*)
declare void @flux_set_print(i8*)
declare i8* @flux_list_to_str(i8*)
declare i8* @flux_map_to_str(i8*)
declare i8* @flux_list_to_set(i8*)
declare double @flux_cast_special_float(double, i64)
declare i8* @flux_complex_create(double, double)
declare i8* @flux_complex_from_str(i8*)
declare i8* @flux_complex_add(i8*, i8*)
declare i8* @flux_complex_sub(i8*, i8*)
declare i8* @flux_complex_mul(i8*, i8*)
declare i8* @flux_complex_mul_real(i8*, double)
declare i8* @flux_complex_real_mul(double, i8*)
declare i8* @flux_complex_add_real(double, i8*)
declare i8* @flux_complex_real_add(i8*, double)
declare i8* @flux_complex_to_str(i8*)
declare void @flux_complex_print(i8*)
@.fmt_int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.fmt_int_val = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
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
@.str.5 = private unnamed_addr constant [6 x i8] c"int64\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"float64\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"bool\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"string\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"list\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"set\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"map\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@.str.13 = private unnamed_addr constant [13 x i8] c"_struct_name\00", align 1
@.str.14 = private unnamed_addr constant [5 x i8] c"fail\00", align 1
@.str.15 = private unnamed_addr constant [5 x i8] c"llvm\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"wat\00", align 1
@.str.17 = private unnamed_addr constant [5 x i8] c"wasm\00", align 1
@.str.18 = private unnamed_addr constant [3 x i8] c"in\00", align 1
@.str.19 = private unnamed_addr constant [3 x i8] c"vm\00", align 1
@.str.20 = private unnamed_addr constant [4 x i8] c"vmr\00", align 1
@.str.21 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"int\00", align 1
@.str.23 = private unnamed_addr constant [4 x i8] c"i64\00", align 1
@.str.24 = private unnamed_addr constant [4 x i8] c"INT\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"float\00", align 1
@.str.26 = private unnamed_addr constant [4 x i8] c"f64\00", align 1
@.str.27 = private unnamed_addr constant [8 x i8] c"float32\00", align 1
@.str.28 = private unnamed_addr constant [4 x i8] c"f32\00", align 1
@.str.29 = private unnamed_addr constant [6 x i8] c"FLOAT\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"BOOL\00", align 1
@.str.31 = private unnamed_addr constant [5 x i8] c"char\00", align 1
@.str.32 = private unnamed_addr constant [5 x i8] c"CHAR\00", align 1
@.str.33 = private unnamed_addr constant [4 x i8] c"str\00", align 1
@.str.34 = private unnamed_addr constant [7 x i8] c"STRING\00", align 1
@.str.35 = private unnamed_addr constant [5 x i8] c"LIST\00", align 1
@.str.36 = private unnamed_addr constant [4 x i8] c"SET\00", align 1
@.str.37 = private unnamed_addr constant [4 x i8] c"MAP\00", align 1
@.str.38 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.39 = private unnamed_addr constant [6 x i8] c"valid\00", align 1
@.str.40 = private unnamed_addr constant [24 x i8] c"TheFlux Compiler v1.0.0\00", align 1
@.str.41 = private unnamed_addr constant [36 x i8] c"Usage: fluxc [options] <input.flux>\00", align 1
@.str.42 = private unnamed_addr constant [9 x i8] c"Options:\00", align 1
@.str.43 = private unnamed_addr constant [55 x i8] c"  --version, -v               Display compiler version\00", align 1
@.str.44 = private unnamed_addr constant [76 x i8] c"  --target <target>           Target backend (in, vm, vmr, llvm, wat, wasm)\00", align 1
@.str.45 = private unnamed_addr constant [49 x i8] c"  -o, --output <path>         Output destination\00", align 1
@.str.46 = private unnamed_addr constant [44 x i8] c"  --emit-ast                  Dump AST JSON\00", align 1
@.str.47 = private unnamed_addr constant [43 x i8] c"  --emit-fmir                 Dump FMIR IR\00", align 1
@.str.48 = private unnamed_addr constant [49 x i8] c"  --emit-llvm                 Emit LLVM IR (.ll)\00", align 1
@.str.49 = private unnamed_addr constant [59 x i8] c"  --emit-wat                  Emit WebAssembly Text (.wat)\00", align 1
@.str.50 = private unnamed_addr constant [54 x i8] c"  --explain <code>            Explain diagnostic code\00", align 1
@.str.51 = private unnamed_addr constant [4 x i8] c"out\00", align 1
@.str.52 = private unnamed_addr constant [10 x i8] c"--version\00", align 1
@.str.53 = private unnamed_addr constant [3 x i8] c"-v\00", align 1
@.str.54 = private unnamed_addr constant [9 x i8] c"--target\00", align 1
@.str.55 = private unnamed_addr constant [3 x i8] c"-o\00", align 1
@.str.56 = private unnamed_addr constant [9 x i8] c"--output\00", align 1
@.str.57 = private unnamed_addr constant [11 x i8] c"--emit-ast\00", align 1
@.str.58 = private unnamed_addr constant [12 x i8] c"--emit-fmir\00", align 1
@.str.59 = private unnamed_addr constant [12 x i8] c"--emit-llvm\00", align 1
@.str.60 = private unnamed_addr constant [11 x i8] c"--emit-wat\00", align 1
@.str.61 = private unnamed_addr constant [9 x i8] c"--no-run\00", align 1
@.str.62 = private unnamed_addr constant [10 x i8] c"--explain\00", align 1
@.str.63 = private unnamed_addr constant [2 x i8] c"\22\00", align 1
@.str.64 = private unnamed_addr constant [3 x i8] c" \22\00", align 1
@.str.65 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.66 = private unnamed_addr constant [5 x i8] c".exe\00", align 1
@.str.67 = private unnamed_addr constant [5 x i8] c".EXE\00", align 1
@.str.68 = private unnamed_addr constant [4 x i8] c".ll\00", align 1
@.str.69 = private unnamed_addr constant [4 x i8] c".LL\00", align 1
@.str.70 = private unnamed_addr constant [7 x i8] c".fvmbc\00", align 1
@.str.71 = private unnamed_addr constant [7 x i8] c".FVMBC\00", align 1
@.str.72 = private unnamed_addr constant [5 x i8] c".wat\00", align 1
@.str.73 = private unnamed_addr constant [5 x i8] c".WAT\00", align 1
@.str.74 = private unnamed_addr constant [6 x i8] c".wasm\00", align 1
@.str.75 = private unnamed_addr constant [6 x i8] c".WASM\00", align 1
@.str.76 = private unnamed_addr constant [6 x i8] c"1.0.0\00", align 1
@.str.77 = private unnamed_addr constant [32 x i8] c"Error: No input file specified.\00", align 1
@.str.78 = private unnamed_addr constant [18 x i8] c"#L EXPECT_ERROR: \00", align 1
@.str.79 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.80 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.81 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.82 = private unnamed_addr constant [6 x i8] c"RT701\00", align 1
@.str.83 = private unnamed_addr constant [6 x i8] c"RT706\00", align 1
@.str.84 = private unnamed_addr constant [6 x i8] c"RT707\00", align 1
@.str.85 = private unnamed_addr constant [14 x i8] c"  \F0\9F\92\A1 Dica: \00", align 1
@.str.86 = private unnamed_addr constant [11 x i8] c"compliance\00", align 1
@.str.87 = private unnamed_addr constant [9 x i8] c"exemplos\00", align 1
@.str.88 = private unnamed_addr constant [9 x i8] c"examples\00", align 1
@.str.89 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.90 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_BE.exe\00", align 1
@.str.91 = private unnamed_addr constant [14 x i8] c"compliance_BE\00", align 1
@.str.92 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_BE.exe\00", align 1
@.str.93 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_IN.exe\00", align 1
@.str.94 = private unnamed_addr constant [14 x i8] c"compliance_IN\00", align 1
@.str.95 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_IN.exe\00", align 1
@.str.96 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_NR.exe\00", align 1
@.str.97 = private unnamed_addr constant [14 x i8] c"compliance_NR\00", align 1
@.str.98 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_NR.exe\00", align 1
@.str.99 = private unnamed_addr constant [22 x i8] c"bin\5Ccompliance_SA.exe\00", align 1
@.str.100 = private unnamed_addr constant [14 x i8] c"compliance_SA\00", align 1
@.str.101 = private unnamed_addr constant [24 x i8] c".\5Cbin\5Ccompliance_SA.exe\00", align 1
@.str.102 = private unnamed_addr constant [19 x i8] c"bin\5Ccompliance.exe\00", align 1
@.str.103 = private unnamed_addr constant [21 x i8] c".\5Cbin\5Ccompliance.exe\00", align 1
@.str.104 = private unnamed_addr constant [12 x i8] c"examples_in\00", align 1
@.str.105 = private unnamed_addr constant [12 x i8] c"examples_lv\00", align 1
@.str.106 = private unnamed_addr constant [12 x i8] c"examples_vm\00", align 1
@.str.107 = private unnamed_addr constant [13 x i8] c"examples_vmr\00", align 1
@.str.108 = private unnamed_addr constant [13 x i8] c"examples_was\00", align 1
@.str.109 = private unnamed_addr constant [13 x i8] c"examples_wat\00", align 1
@.str.110 = private unnamed_addr constant [12 x i8] c"exemplos_in\00", align 1
@.str.111 = private unnamed_addr constant [12 x i8] c"exemplos_lv\00", align 1
@.str.112 = private unnamed_addr constant [12 x i8] c"exemplos_vm\00", align 1
@.str.113 = private unnamed_addr constant [13 x i8] c"exemplos_vmr\00", align 1
@.str.114 = private unnamed_addr constant [13 x i8] c"exemplos_was\00", align 1
@.str.115 = private unnamed_addr constant [13 x i8] c"exemplos_wat\00", align 1
@.str.116 = private unnamed_addr constant [5 x i8] c"bin\5C\00", align 1
@.str.117 = private unnamed_addr constant [7 x i8] c".\5Cbin\5C\00", align 1
@.str.118 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.119 = private unnamed_addr constant [14 x i8] c"Parse Error: \00", align 1
@.str.120 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.121 = private unnamed_addr constant [6 x i8] c"arena\00", align 1
@.str.122 = private unnamed_addr constant [8 x i8] c"root_id\00", align 1
@.str.123 = private unnamed_addr constant [25 x i8] c"build/intermediates/ast/\00", align 1
@.str.124 = private unnamed_addr constant [6 x i8] c".json\00", align 1
@.str.125 = private unnamed_addr constant [7 x i8] c"errors\00", align 1
@.str.126 = private unnamed_addr constant [7 x i8] c"output\00", align 1
@.str.127 = private unnamed_addr constant [7 x i8] c"no_run\00", align 1
@.str.128 = private unnamed_addr constant [30 x i8] c"Compilation Error on target: \00", align 1
@.str.129 = private unnamed_addr constant [3 x i8] c"lv\00", align 1
@.str.130 = private unnamed_addr constant [65 x i8] c"clang -O2 -Wno-deprecated-declarations -Wno-override-module -o \22\00", align 1
@.str.131 = private unnamed_addr constant [8 x i8] c".exe\22 \22\00", align 1
@.str.132 = private unnamed_addr constant [66 x i8] c".ll\22 -Llib -lfluxcompiler -lfluxrt -ladvapi32 -lws2_32 -lkernel32\00", align 1
@.str.133 = private unnamed_addr constant [6 x i8] c".exe\22\00", align 1


define %flux.result @uf_RuntimeStdLib__runtimeBackend() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_backend()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeIsNative() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t2_i64 = load i64, i64* %_v_b, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.15, i32 0, i32 0
  %t4_cmp = call i32 @flux_str_compare(i8* %t2, i8* %t3)
  %t4 = icmp eq i32 %t4_cmp, 0
  %t5 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t4 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t5, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeIsWasm() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t2_i64 = load i64, i64* %_v_b, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t3 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.16, i32 0, i32 0
  %t4_cmp = call i32 @flux_str_compare(i8* %t2, i8* %t3)
  %t4 = icmp eq i32 %t4_cmp, 0
  %t5_i64 = load i64, i64* %_v_b, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_b__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t6 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.17, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8 = or i1 %t4, %t7
  %t9 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t8 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t9, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeIsInterpreter() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t2_i64 = load i64, i64* %_v_b, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.18, i32 0, i32 0
  %t4_cmp = call i32 @flux_str_compare(i8* %t2, i8* %t3)
  %t4 = icmp eq i32 %t4_cmp, 0
  %t5_i64 = load i64, i64* %_v_b, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_b__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.19, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8 = or i1 %t4, %t7
  %t9_i64 = load i64, i64* %_v_b, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_b__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t10 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.20, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  %t13 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t12 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t13, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimePointerSize() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t4_i64 = load i64, i64* %_v_b, align 8
  %t4 = inttoptr i64 %t4_i64 to i8*
  %t4_vsta = load i8*, i8** %_v_b__sta, align 8
  %t4_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t5 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.16, i32 0, i32 0
  %t6_cmp = call i32 @flux_str_compare(i8* %t4, i8* %t5)
  %t6 = icmp eq i32 %t6_cmp, 0
  %t7_i64 = load i64, i64* %_v_b, align 8
  %t7 = inttoptr i64 %t7_i64 to i8*
  %t7_vsta = load i8*, i8** %_v_b__sta, align 8
  %t7_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t8 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.17, i32 0, i32 0
  %t9_cmp = call i32 @flux_str_compare(i8* %t7, i8* %t8)
  %t9 = icmp eq i32 %t9_cmp, 0
  %t10 = or i1 %t6, %t9
  br i1 %t10, label %ft_0, label %route_arm_3
ft_0:
  %t11 = add i64 0, 4
  %t12 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t11, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t12, 3
  ret %flux.result %em_r3_1
route_arm_3:
  %t14 = add i64 0, 8
  %t15 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %t14, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t15, 3
  ret %flux.result %em_r3_2
route_end_2:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__runtimeCompilerVersion() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_compiler_version()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeGetArgs() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeGetArgCount() {
fn_entry:
  %_v_a = alloca i64, align 8
  %_v_a__sta = alloca i8*, align 8
  %_v_a__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_a__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_a__msg, align 8
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_a, align 8
  %t2_i64 = load i64, i64* %_v_a, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_a__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_a__msg, align 8
  %t3 = call i64 @flux_list_len(i8* %t2)
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeGetArg(i64 %in_1) {
fn_entry:
  %_v_index = alloca i64, align 8
  %_v_index__sta = alloca i8*, align 8
  %_v_index__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_index__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_index__msg, align 8
  %_v_a = alloca i64, align 8
  %_v_a__sta = alloca i8*, align 8
  %_v_a__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_a__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_a__msg, align 8
  %_v_n = alloca i64, align 8
  %_v_n__sta = alloca i8*, align 8
  %_v_n__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_n__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_n__msg, align 8
  store i64 %in_1, i64* %_v_index, align 8
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_a, align 8
  %t2_i64 = load i64, i64* %_v_a, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_a__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_a__msg, align 8
  %t3 = call i64 @flux_list_len(i8* %t2)
  store i64 %t3, i64* %_v_n, align 8
  %t6 = load i64, i64* %_v_index, align 8
  %t6_vsta = load i8*, i8** %_v_index__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_index__msg, align 8
  %t7 = add i64 0, 1
  %t8 = icmp sge i64 %t6, %t7
  %t9 = load i64, i64* %_v_index, align 8
  %t9_vsta = load i8*, i8** %_v_index__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_index__msg, align 8
  %t10 = load i64, i64* %_v_n, align 8
  %t10_vsta = load i8*, i8** %_v_n__sta, align 8
  %t10_vmsg = load i8*, i8** %_v_n__msg, align 8
  %t11 = icmp sle i64 %t9, %t10
  %t12 = and i1 %t8, %t11
  br i1 %t12, label %ft_0, label %route_arm_5
ft_0:
  %t13 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t14_i64 = load i64, i64* %_v_a, align 8
  %t14 = inttoptr i64 %t14_i64 to i8*
  %t14_vsta = load i8*, i8** %_v_a__sta, align 8
  %t14_vmsg = load i8*, i8** %_v_a__msg, align 8
  %t15 = load i64, i64* %_v_index, align 8
  %t15_vsta = load i8*, i8** %_v_index__sta, align 8
  %t15_vmsg = load i8*, i8** %_v_index__msg, align 8
  %t16_raw = call i64 @flux_list_get_val(i8* %t14, i64 %t15)
  %t16 = inttoptr i64 %t16_raw to i8*
  %cv_raw_1 = ptrtoint i8* %t16 to i64
  %cv_buf_1 = call i8* @flux_val_to_str(i64 %cv_raw_1)
  %t17 = call i8* @flux_str_concat(i8* %t13, i8* %cv_buf_1)
  %t18 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t17 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t18, 3
  ret %flux.result %em_r3_1
route_arm_5:
  %t20 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_2 = ptrtoint i8* %t20 to i64
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %em_vi_2, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t21, 3
  ret %flux.result %em_r3_2
route_end_4:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__runtimeExecutablePath() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_executable_path()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__backend() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_backend()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__isNative() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t2_i64 = load i64, i64* %_v_b, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.15, i32 0, i32 0
  %t4_cmp = call i32 @flux_str_compare(i8* %t2, i8* %t3)
  %t4 = icmp eq i32 %t4_cmp, 0
  %t5 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t4 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t5, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__isWasm() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t2_i64 = load i64, i64* %_v_b, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t3 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.16, i32 0, i32 0
  %t4_cmp = call i32 @flux_str_compare(i8* %t2, i8* %t3)
  %t4 = icmp eq i32 %t4_cmp, 0
  %t5_i64 = load i64, i64* %_v_b, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_b__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t6 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.17, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8 = or i1 %t4, %t7
  %t9 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t8 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t9, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__isInterpreter() {
fn_entry:
  %_v_b = alloca i64, align 8
  %_v_b__sta = alloca i8*, align 8
  %_v_b__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b__msg, align 8
  %t1 = call i8* @flux_std_runtime_backend()
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_b, align 8
  %t2_i64 = load i64, i64* %_v_b, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.18, i32 0, i32 0
  %t4_cmp = call i32 @flux_str_compare(i8* %t2, i8* %t3)
  %t4 = icmp eq i32 %t4_cmp, 0
  %t5_i64 = load i64, i64* %_v_b, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_b__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.19, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8 = or i1 %t4, %t7
  %t9_i64 = load i64, i64* %_v_b, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_b__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_b__msg, align 8
  %t10 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.20, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  %t13 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t12 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t13, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__compilerVersion() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_compiler_version()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__getArgs() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__getArgCount() {
fn_entry:
  %_v_a = alloca i64, align 8
  %_v_a__sta = alloca i8*, align 8
  %_v_a__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_a__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_a__msg, align 8
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_a, align 8
  %t2_i64 = load i64, i64* %_v_a, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_a__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_a__msg, align 8
  %t3 = call i64 @flux_list_len(i8* %t2)
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__getArg(i64 %in_1) {
fn_entry:
  %_v_index = alloca i64, align 8
  %_v_index__sta = alloca i8*, align 8
  %_v_index__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_index__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_index__msg, align 8
  %_v_a = alloca i64, align 8
  %_v_a__sta = alloca i8*, align 8
  %_v_a__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_a__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_a__msg, align 8
  %_v_n = alloca i64, align 8
  %_v_n__sta = alloca i8*, align 8
  %_v_n__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_n__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_n__msg, align 8
  store i64 %in_1, i64* %_v_index, align 8
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_a, align 8
  %t2_i64 = load i64, i64* %_v_a, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_a__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_a__msg, align 8
  %t3 = call i64 @flux_list_len(i8* %t2)
  store i64 %t3, i64* %_v_n, align 8
  %t6 = load i64, i64* %_v_index, align 8
  %t6_vsta = load i8*, i8** %_v_index__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_index__msg, align 8
  %t7 = add i64 0, 1
  %t8 = icmp sge i64 %t6, %t7
  %t9 = load i64, i64* %_v_index, align 8
  %t9_vsta = load i8*, i8** %_v_index__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_index__msg, align 8
  %t10 = load i64, i64* %_v_n, align 8
  %t10_vsta = load i8*, i8** %_v_n__sta, align 8
  %t10_vmsg = load i8*, i8** %_v_n__msg, align 8
  %t11 = icmp sle i64 %t9, %t10
  %t12 = and i1 %t8, %t11
  br i1 %t12, label %ft_0, label %route_arm_5
ft_0:
  %t13 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t14_i64 = load i64, i64* %_v_a, align 8
  %t14 = inttoptr i64 %t14_i64 to i8*
  %t14_vsta = load i8*, i8** %_v_a__sta, align 8
  %t14_vmsg = load i8*, i8** %_v_a__msg, align 8
  %t15 = load i64, i64* %_v_index, align 8
  %t15_vsta = load i8*, i8** %_v_index__sta, align 8
  %t15_vmsg = load i8*, i8** %_v_index__msg, align 8
  %t16_raw = call i64 @flux_list_get_val(i8* %t14, i64 %t15)
  %t16 = inttoptr i64 %t16_raw to i8*
  %cv_raw_1 = ptrtoint i8* %t16 to i64
  %cv_buf_1 = call i8* @flux_val_to_str(i64 %cv_raw_1)
  %t17 = call i8* @flux_str_concat(i8* %t13, i8* %cv_buf_1)
  %t18 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t17 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t18, 3
  ret %flux.result %em_r3_1
route_arm_5:
  %t20 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_2 = ptrtoint i8* %t20 to i64
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %em_vi_2, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t21, 3
  ret %flux.result %em_r3_2
route_end_4:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__runtimeGetTypeName(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeGetTypeId(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t5_i64 = load i64, i64* %_v_tn, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t6 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8_i64 = load i64, i64* %_v_tn, align 8
  %t8 = inttoptr i64 %t8_i64 to i8*
  %t8_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t8_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t9 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t10_cmp = call i32 @flux_str_compare(i8* %t8, i8* %t9)
  %t10 = icmp eq i32 %t10_cmp, 0
  %t11 = or i1 %t7, %t10
  %t12_i64 = load i64, i64* %_v_tn, align 8
  %t12 = inttoptr i64 %t12_i64 to i8*
  %t12_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t12_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t13 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t14_cmp = call i32 @flux_str_compare(i8* %t12, i8* %t13)
  %t14 = icmp eq i32 %t14_cmp, 0
  %t15 = or i1 %t11, %t14
  %t16_i64 = load i64, i64* %_v_tn, align 8
  %t16 = inttoptr i64 %t16_i64 to i8*
  %t16_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t16_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t17 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t18_cmp = call i32 @flux_str_compare(i8* %t16, i8* %t17)
  %t18 = icmp eq i32 %t18_cmp, 0
  %t19 = or i1 %t15, %t18
  br i1 %t19, label %ft_0, label %route_arm_4
ft_0:
  %t20 = add i64 0, 1
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t20, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t21, 3
  ret %flux.result %em_r3_1
route_arm_4:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i64 0, 2
  %t47 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %t46, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t47, 3
  ret %flux.result %em_r3_2
route_arm_22:
  %t49_i64 = load i64, i64* %_v_tn, align 8
  %t49 = inttoptr i64 %t49_i64 to i8*
  %t49_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t49_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t50 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t51_cmp = call i32 @flux_str_compare(i8* %t49, i8* %t50)
  %t51 = icmp eq i32 %t51_cmp, 0
  %t52_i64 = load i64, i64* %_v_tn, align 8
  %t52 = inttoptr i64 %t52_i64 to i8*
  %t52_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t52_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t53 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t54_cmp = call i32 @flux_str_compare(i8* %t52, i8* %t53)
  %t54 = icmp eq i32 %t54_cmp, 0
  %t55 = or i1 %t51, %t54
  br i1 %t55, label %ft_2, label %route_arm_48
ft_2:
  %t56 = add i64 0, 3
  %t57 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_3 = insertvalue %flux.result undef, i8* %em_sta_3, 0
  %em_r1_3 = insertvalue %flux.result %em_r0_3, i64 %t56, 1
  %em_r2_3 = insertvalue %flux.result %em_r1_3, double 0.0, 2
  %em_r3_3 = insertvalue %flux.result %em_r2_3, i8* %t57, 3
  ret %flux.result %em_r3_3
route_arm_48:
  %t59_i64 = load i64, i64* %_v_tn, align 8
  %t59 = inttoptr i64 %t59_i64 to i8*
  %t59_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t59_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t60 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t61_cmp = call i32 @flux_str_compare(i8* %t59, i8* %t60)
  %t61 = icmp eq i32 %t61_cmp, 0
  %t62_i64 = load i64, i64* %_v_tn, align 8
  %t62 = inttoptr i64 %t62_i64 to i8*
  %t62_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t62_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t63 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t64_cmp = call i32 @flux_str_compare(i8* %t62, i8* %t63)
  %t64 = icmp eq i32 %t64_cmp, 0
  %t65 = or i1 %t61, %t64
  br i1 %t65, label %ft_3, label %route_arm_58
ft_3:
  %t66 = add i64 0, 4
  %t67 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_4 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_4 = insertvalue %flux.result undef, i8* %em_sta_4, 0
  %em_r1_4 = insertvalue %flux.result %em_r0_4, i64 %t66, 1
  %em_r2_4 = insertvalue %flux.result %em_r1_4, double 0.0, 2
  %em_r3_4 = insertvalue %flux.result %em_r2_4, i8* %t67, 3
  ret %flux.result %em_r3_4
route_arm_58:
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72_i64 = load i64, i64* %_v_tn, align 8
  %t72 = inttoptr i64 %t72_i64 to i8*
  %t72_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t72_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t73 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t74_cmp = call i32 @flux_str_compare(i8* %t72, i8* %t73)
  %t74 = icmp eq i32 %t74_cmp, 0
  %t75 = or i1 %t71, %t74
  %t76_i64 = load i64, i64* %_v_tn, align 8
  %t76 = inttoptr i64 %t76_i64 to i8*
  %t76_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t76_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t77 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t78_cmp = call i32 @flux_str_compare(i8* %t76, i8* %t77)
  %t78 = icmp eq i32 %t78_cmp, 0
  %t79 = or i1 %t75, %t78
  br i1 %t79, label %ft_4, label %route_arm_68
ft_4:
  %t80 = add i64 0, 5
  %t81 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_5 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_5 = insertvalue %flux.result undef, i8* %em_sta_5, 0
  %em_r1_5 = insertvalue %flux.result %em_r0_5, i64 %t80, 1
  %em_r2_5 = insertvalue %flux.result %em_r1_5, double 0.0, 2
  %em_r3_5 = insertvalue %flux.result %em_r2_5, i8* %t81, 3
  ret %flux.result %em_r3_5
route_arm_68:
  %t83_i64 = load i64, i64* %_v_tn, align 8
  %t83 = inttoptr i64 %t83_i64 to i8*
  %t83_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t83_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t84 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t85_cmp = call i32 @flux_str_compare(i8* %t83, i8* %t84)
  %t85 = icmp eq i32 %t85_cmp, 0
  %t86_i64 = load i64, i64* %_v_tn, align 8
  %t86 = inttoptr i64 %t86_i64 to i8*
  %t86_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t86_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t87 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t88_cmp = call i32 @flux_str_compare(i8* %t86, i8* %t87)
  %t88 = icmp eq i32 %t88_cmp, 0
  %t89 = or i1 %t85, %t88
  br i1 %t89, label %ft_5, label %route_arm_82
ft_5:
  %t90 = add i64 0, 6
  %t91 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_6 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_6 = insertvalue %flux.result undef, i8* %em_sta_6, 0
  %em_r1_6 = insertvalue %flux.result %em_r0_6, i64 %t90, 1
  %em_r2_6 = insertvalue %flux.result %em_r1_6, double 0.0, 2
  %em_r3_6 = insertvalue %flux.result %em_r2_6, i8* %t91, 3
  ret %flux.result %em_r3_6
route_arm_82:
  %t93_i64 = load i64, i64* %_v_tn, align 8
  %t93 = inttoptr i64 %t93_i64 to i8*
  %t93_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t93_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t94 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t95_cmp = call i32 @flux_str_compare(i8* %t93, i8* %t94)
  %t95 = icmp eq i32 %t95_cmp, 0
  %t96_i64 = load i64, i64* %_v_tn, align 8
  %t96 = inttoptr i64 %t96_i64 to i8*
  %t96_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t96_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t97 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t98_cmp = call i32 @flux_str_compare(i8* %t96, i8* %t97)
  %t98 = icmp eq i32 %t98_cmp, 0
  %t99 = or i1 %t95, %t98
  br i1 %t99, label %ft_6, label %route_arm_92
ft_6:
  %t100 = add i64 0, 7
  %t101 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_7 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_7 = insertvalue %flux.result undef, i8* %em_sta_7, 0
  %em_r1_7 = insertvalue %flux.result %em_r0_7, i64 %t100, 1
  %em_r2_7 = insertvalue %flux.result %em_r1_7, double 0.0, 2
  %em_r3_7 = insertvalue %flux.result %em_r2_7, i8* %t101, 3
  ret %flux.result %em_r3_7
route_arm_92:
  %t103_i64 = load i64, i64* %_v_tn, align 8
  %t103 = inttoptr i64 %t103_i64 to i8*
  %t103_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t103_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t104 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t105_cmp = call i32 @flux_str_compare(i8* %t103, i8* %t104)
  %t105 = icmp eq i32 %t105_cmp, 0
  %t106_i64 = load i64, i64* %_v_tn, align 8
  %t106 = inttoptr i64 %t106_i64 to i8*
  %t106_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t106_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t107 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t108_cmp = call i32 @flux_str_compare(i8* %t106, i8* %t107)
  %t108 = icmp eq i32 %t108_cmp, 0
  %t109 = or i1 %t105, %t108
  br i1 %t109, label %ft_7, label %route_arm_102
ft_7:
  %t110 = add i64 0, 8
  %t111 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_8 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_8 = insertvalue %flux.result undef, i8* %em_sta_8, 0
  %em_r1_8 = insertvalue %flux.result %em_r0_8, i64 %t110, 1
  %em_r2_8 = insertvalue %flux.result %em_r1_8, double 0.0, 2
  %em_r3_8 = insertvalue %flux.result %em_r2_8, i8* %t111, 3
  ret %flux.result %em_r3_8
route_arm_102:
  %t113 = add i64 0, 9
  %t114 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_9 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_9 = insertvalue %flux.result undef, i8* %em_sta_9, 0
  %em_r1_9 = insertvalue %flux.result %em_r0_9, i64 %t113, 1
  %em_r2_9 = insertvalue %flux.result %em_r1_9, double 0.0, 2
  %em_r3_9 = insertvalue %flux.result %em_r2_9, i8* %t114, 3
  ret %flux.result %em_r3_9
route_end_3:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__runtimeIsPrimitive(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t3 = add i1 0, 0
  %st_b_2 = zext i1 %t3 to i64
  store i64 %st_b_2, i64* %_v_res, align 8
  %t6_i64 = load i64, i64* %_v_tn, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t7 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t8_cmp = call i32 @flux_str_compare(i8* %t6, i8* %t7)
  %t8 = icmp eq i32 %t8_cmp, 0
  %t9_i64 = load i64, i64* %_v_tn, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t10 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  %t13_i64 = load i64, i64* %_v_tn, align 8
  %t13 = inttoptr i64 %t13_i64 to i8*
  %t13_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t13_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t15_cmp = call i32 @flux_str_compare(i8* %t13, i8* %t14)
  %t15 = icmp eq i32 %t15_cmp, 0
  %t16 = or i1 %t12, %t15
  %t17_i64 = load i64, i64* %_v_tn, align 8
  %t17 = inttoptr i64 %t17_i64 to i8*
  %t17_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t17_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t18 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t19_cmp = call i32 @flux_str_compare(i8* %t17, i8* %t18)
  %t19 = icmp eq i32 %t19_cmp, 0
  %t20 = or i1 %t16, %t19
  br i1 %t20, label %ft_0, label %route_arm_5
ft_0:
  %t21 = add i1 0, 1
  %st_b_3 = zext i1 %t21 to i64
  store i64 %st_b_3, i64* %_v_res, align 8
  br label %route_end_4
route_arm_5:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i1 0, 1
  %st_b_4 = zext i1 %t46 to i64
  store i64 %st_b_4, i64* %_v_res, align 8
  br label %route_end_4
route_arm_22:
  %t48_i64 = load i64, i64* %_v_tn, align 8
  %t48 = inttoptr i64 %t48_i64 to i8*
  %t48_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t48_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t49 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t50_cmp = call i32 @flux_str_compare(i8* %t48, i8* %t49)
  %t50 = icmp eq i32 %t50_cmp, 0
  %t51_i64 = load i64, i64* %_v_tn, align 8
  %t51 = inttoptr i64 %t51_i64 to i8*
  %t51_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t51_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t52 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t53_cmp = call i32 @flux_str_compare(i8* %t51, i8* %t52)
  %t53 = icmp eq i32 %t53_cmp, 0
  %t54 = or i1 %t50, %t53
  br i1 %t54, label %ft_2, label %route_arm_47
ft_2:
  %t55 = add i1 0, 1
  %st_b_5 = zext i1 %t55 to i64
  store i64 %st_b_5, i64* %_v_res, align 8
  br label %route_end_4
route_arm_47:
  %t57_i64 = load i64, i64* %_v_tn, align 8
  %t57 = inttoptr i64 %t57_i64 to i8*
  %t57_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t57_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t58 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t59_cmp = call i32 @flux_str_compare(i8* %t57, i8* %t58)
  %t59 = icmp eq i32 %t59_cmp, 0
  %t60_i64 = load i64, i64* %_v_tn, align 8
  %t60 = inttoptr i64 %t60_i64 to i8*
  %t60_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t60_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t61 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t62_cmp = call i32 @flux_str_compare(i8* %t60, i8* %t61)
  %t62 = icmp eq i32 %t62_cmp, 0
  %t63 = or i1 %t59, %t62
  br i1 %t63, label %ft_3, label %route_arm_56
ft_3:
  %t64 = add i1 0, 1
  %st_b_6 = zext i1 %t64 to i64
  store i64 %st_b_6, i64* %_v_res, align 8
  br label %route_end_4
route_arm_56:
  %t66_i64 = load i64, i64* %_v_tn, align 8
  %t66 = inttoptr i64 %t66_i64 to i8*
  %t66_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t66_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t67 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t68_cmp = call i32 @flux_str_compare(i8* %t66, i8* %t67)
  %t68 = icmp eq i32 %t68_cmp, 0
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72 = or i1 %t68, %t71
  %t73_i64 = load i64, i64* %_v_tn, align 8
  %t73 = inttoptr i64 %t73_i64 to i8*
  %t73_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t73_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t74 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t75_cmp = call i32 @flux_str_compare(i8* %t73, i8* %t74)
  %t75 = icmp eq i32 %t75_cmp, 0
  %t76 = or i1 %t72, %t75
  br i1 %t76, label %ft_4, label %route_arm_65
ft_4:
  %t77 = add i1 0, 1
  %st_b_7 = zext i1 %t77 to i64
  store i64 %st_b_7, i64* %_v_res, align 8
  br label %route_end_4
route_arm_65:
  %t79 = add i1 0, 0
  %st_b_8 = zext i1 %t79 to i64
  store i64 %st_b_8, i64* %_v_res, align 8
  br label %route_end_4
route_end_4:
  %t80_i64 = load i64, i64* %_v_res, align 8
  %t80 = trunc i64 %t80_i64 to i1
  %t80_vsta = load i8*, i8** %_v_res__sta, align 8
  %t80_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t81 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t80 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t81, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeIsCollection(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t3 = add i1 0, 0
  %st_b_2 = zext i1 %t3 to i64
  store i64 %st_b_2, i64* %_v_res, align 8
  %t6_i64 = load i64, i64* %_v_tn, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t7 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t8_cmp = call i32 @flux_str_compare(i8* %t6, i8* %t7)
  %t8 = icmp eq i32 %t8_cmp, 0
  %t9_i64 = load i64, i64* %_v_tn, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t10 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  br i1 %t12, label %ft_0, label %route_arm_5
ft_0:
  %t13 = add i1 0, 1
  %st_b_3 = zext i1 %t13 to i64
  store i64 %st_b_3, i64* %_v_res, align 8
  br label %route_end_4
route_arm_5:
  %t15_i64 = load i64, i64* %_v_tn, align 8
  %t15 = inttoptr i64 %t15_i64 to i8*
  %t15_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t15_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t16 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t17_cmp = call i32 @flux_str_compare(i8* %t15, i8* %t16)
  %t17 = icmp eq i32 %t17_cmp, 0
  %t18_i64 = load i64, i64* %_v_tn, align 8
  %t18 = inttoptr i64 %t18_i64 to i8*
  %t18_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t18_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t19 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t20_cmp = call i32 @flux_str_compare(i8* %t18, i8* %t19)
  %t20 = icmp eq i32 %t20_cmp, 0
  %t21 = or i1 %t17, %t20
  br i1 %t21, label %ft_1, label %route_arm_14
ft_1:
  %t22 = add i1 0, 1
  %st_b_4 = zext i1 %t22 to i64
  store i64 %st_b_4, i64* %_v_res, align 8
  br label %route_end_4
route_arm_14:
  %t24_i64 = load i64, i64* %_v_tn, align 8
  %t24 = inttoptr i64 %t24_i64 to i8*
  %t24_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t24_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t25 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t26_cmp = call i32 @flux_str_compare(i8* %t24, i8* %t25)
  %t26 = icmp eq i32 %t26_cmp, 0
  %t27_i64 = load i64, i64* %_v_tn, align 8
  %t27 = inttoptr i64 %t27_i64 to i8*
  %t27_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t27_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t28 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t29_cmp = call i32 @flux_str_compare(i8* %t27, i8* %t28)
  %t29 = icmp eq i32 %t29_cmp, 0
  %t30 = or i1 %t26, %t29
  br i1 %t30, label %ft_2, label %route_arm_23
ft_2:
  %t31 = add i1 0, 1
  %st_b_5 = zext i1 %t31 to i64
  store i64 %st_b_5, i64* %_v_res, align 8
  br label %route_end_4
route_arm_23:
  %t33 = add i1 0, 0
  %st_b_6 = zext i1 %t33 to i64
  store i64 %st_b_6, i64* %_v_res, align 8
  br label %route_end_4
route_end_4:
  %t34_i64 = load i64, i64* %_v_res, align 8
  %t34 = trunc i64 %t34_i64 to i1
  %t34_vsta = load i8*, i8** %_v_res__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t35 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t34 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t35, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeIsStruct(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t3 = add i1 0, 0
  %st_b_2 = zext i1 %t3 to i64
  store i64 %st_b_2, i64* %_v_res, align 8
  %t6_i64 = load i64, i64* %_v_tn, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t7 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t8_cmp = call i32 @flux_str_compare(i8* %t6, i8* %t7)
  %t8 = icmp eq i32 %t8_cmp, 0
  %t9_i64 = load i64, i64* %_v_tn, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t10 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  %t13_i64 = load i64, i64* %_v_tn, align 8
  %t13 = inttoptr i64 %t13_i64 to i8*
  %t13_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t13_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t15_cmp = call i32 @flux_str_compare(i8* %t13, i8* %t14)
  %t15 = icmp eq i32 %t15_cmp, 0
  %t16 = or i1 %t12, %t15
  %t17_i64 = load i64, i64* %_v_tn, align 8
  %t17 = inttoptr i64 %t17_i64 to i8*
  %t17_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t17_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t18 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t19_cmp = call i32 @flux_str_compare(i8* %t17, i8* %t18)
  %t19 = icmp eq i32 %t19_cmp, 0
  %t20 = or i1 %t16, %t19
  br i1 %t20, label %ft_0, label %route_arm_5
ft_0:
  %t21 = add i1 0, 0
  %st_b_3 = zext i1 %t21 to i64
  store i64 %st_b_3, i64* %_v_res, align 8
  br label %route_end_4
route_arm_5:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i1 0, 0
  %st_b_4 = zext i1 %t46 to i64
  store i64 %st_b_4, i64* %_v_res, align 8
  br label %route_end_4
route_arm_22:
  %t48_i64 = load i64, i64* %_v_tn, align 8
  %t48 = inttoptr i64 %t48_i64 to i8*
  %t48_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t48_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t49 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t50_cmp = call i32 @flux_str_compare(i8* %t48, i8* %t49)
  %t50 = icmp eq i32 %t50_cmp, 0
  %t51_i64 = load i64, i64* %_v_tn, align 8
  %t51 = inttoptr i64 %t51_i64 to i8*
  %t51_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t51_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t52 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t53_cmp = call i32 @flux_str_compare(i8* %t51, i8* %t52)
  %t53 = icmp eq i32 %t53_cmp, 0
  %t54 = or i1 %t50, %t53
  br i1 %t54, label %ft_2, label %route_arm_47
ft_2:
  %t55 = add i1 0, 0
  %st_b_5 = zext i1 %t55 to i64
  store i64 %st_b_5, i64* %_v_res, align 8
  br label %route_end_4
route_arm_47:
  %t57_i64 = load i64, i64* %_v_tn, align 8
  %t57 = inttoptr i64 %t57_i64 to i8*
  %t57_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t57_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t58 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t59_cmp = call i32 @flux_str_compare(i8* %t57, i8* %t58)
  %t59 = icmp eq i32 %t59_cmp, 0
  %t60_i64 = load i64, i64* %_v_tn, align 8
  %t60 = inttoptr i64 %t60_i64 to i8*
  %t60_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t60_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t61 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t62_cmp = call i32 @flux_str_compare(i8* %t60, i8* %t61)
  %t62 = icmp eq i32 %t62_cmp, 0
  %t63 = or i1 %t59, %t62
  br i1 %t63, label %ft_3, label %route_arm_56
ft_3:
  %t64 = add i1 0, 0
  %st_b_6 = zext i1 %t64 to i64
  store i64 %st_b_6, i64* %_v_res, align 8
  br label %route_end_4
route_arm_56:
  %t66_i64 = load i64, i64* %_v_tn, align 8
  %t66 = inttoptr i64 %t66_i64 to i8*
  %t66_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t66_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t67 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t68_cmp = call i32 @flux_str_compare(i8* %t66, i8* %t67)
  %t68 = icmp eq i32 %t68_cmp, 0
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72 = or i1 %t68, %t71
  %t73_i64 = load i64, i64* %_v_tn, align 8
  %t73 = inttoptr i64 %t73_i64 to i8*
  %t73_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t73_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t74 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t75_cmp = call i32 @flux_str_compare(i8* %t73, i8* %t74)
  %t75 = icmp eq i32 %t75_cmp, 0
  %t76 = or i1 %t72, %t75
  br i1 %t76, label %ft_4, label %route_arm_65
ft_4:
  %t77 = add i1 0, 0
  %st_b_7 = zext i1 %t77 to i64
  store i64 %st_b_7, i64* %_v_res, align 8
  br label %route_end_4
route_arm_65:
  %t79_i64 = load i64, i64* %_v_tn, align 8
  %t79 = inttoptr i64 %t79_i64 to i8*
  %t79_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t79_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t80 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t81_cmp = call i32 @flux_str_compare(i8* %t79, i8* %t80)
  %t81 = icmp eq i32 %t81_cmp, 0
  %t82_i64 = load i64, i64* %_v_tn, align 8
  %t82 = inttoptr i64 %t82_i64 to i8*
  %t82_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t82_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t83 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t84_cmp = call i32 @flux_str_compare(i8* %t82, i8* %t83)
  %t84 = icmp eq i32 %t84_cmp, 0
  %t85 = or i1 %t81, %t84
  br i1 %t85, label %ft_5, label %route_arm_78
ft_5:
  %t86 = add i1 0, 0
  %st_b_8 = zext i1 %t86 to i64
  store i64 %st_b_8, i64* %_v_res, align 8
  br label %route_end_4
route_arm_78:
  %t88_i64 = load i64, i64* %_v_tn, align 8
  %t88 = inttoptr i64 %t88_i64 to i8*
  %t88_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t88_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t89 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t90_cmp = call i32 @flux_str_compare(i8* %t88, i8* %t89)
  %t90 = icmp eq i32 %t90_cmp, 0
  %t91_i64 = load i64, i64* %_v_tn, align 8
  %t91 = inttoptr i64 %t91_i64 to i8*
  %t91_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t91_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t92 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t93_cmp = call i32 @flux_str_compare(i8* %t91, i8* %t92)
  %t93 = icmp eq i32 %t93_cmp, 0
  %t94 = or i1 %t90, %t93
  br i1 %t94, label %ft_6, label %route_arm_87
ft_6:
  %t95 = add i1 0, 0
  %st_b_9 = zext i1 %t95 to i64
  store i64 %st_b_9, i64* %_v_res, align 8
  br label %route_end_4
route_arm_87:
  %t97_i64 = load i64, i64* %_v_tn, align 8
  %t97 = inttoptr i64 %t97_i64 to i8*
  %t97_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t97_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t98 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t99_cmp = call i32 @flux_str_compare(i8* %t97, i8* %t98)
  %t99 = icmp eq i32 %t99_cmp, 0
  %t100_i64 = load i64, i64* %_v_tn, align 8
  %t100 = inttoptr i64 %t100_i64 to i8*
  %t100_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t100_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t101 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t102_cmp = call i32 @flux_str_compare(i8* %t100, i8* %t101)
  %t102 = icmp eq i32 %t102_cmp, 0
  %t103 = or i1 %t99, %t102
  br i1 %t103, label %ft_7, label %route_arm_96
ft_7:
  %t104 = add i1 0, 0
  %st_b_10 = zext i1 %t104 to i64
  store i64 %st_b_10, i64* %_v_res, align 8
  br label %route_end_4
route_arm_96:
  %t106 = add i1 0, 1
  %st_b_11 = zext i1 %t106 to i64
  store i64 %st_b_11, i64* %_v_res, align 8
  br label %route_end_4
route_end_4:
  %t107_i64 = load i64, i64* %_v_res, align 8
  %t107 = trunc i64 %t107_i64 to i1
  %t107_vsta = load i8*, i8** %_v_res__sta, align 8
  %t107_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t108 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t107 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t108, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeSizeOf(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_s = alloca i64, align 8
  %_v_s__sta = alloca i8*, align 8
  %_v_s__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_s__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_s__msg, align 8
  %_v_slen = alloca i64, align 8
  %_v_slen__sta = alloca i8*, align 8
  %_v_slen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_slen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_slen__msg, align 8
  %_v___iter_idx_86 = alloca i64, align 8
  %_v___iter_idx_86__sta = alloca i8*, align 8
  %_v___iter_idx_86__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v___iter_idx_86__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v___iter_idx_86__msg, align 8
  %_v_c = alloca i64, align 8
  %_v_c__sta = alloca i8*, align 8
  %_v_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t5_i64 = load i64, i64* %_v_tn, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t6 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8_i64 = load i64, i64* %_v_tn, align 8
  %t8 = inttoptr i64 %t8_i64 to i8*
  %t8_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t8_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t9 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t10_cmp = call i32 @flux_str_compare(i8* %t8, i8* %t9)
  %t10 = icmp eq i32 %t10_cmp, 0
  %t11 = or i1 %t7, %t10
  %t12_i64 = load i64, i64* %_v_tn, align 8
  %t12 = inttoptr i64 %t12_i64 to i8*
  %t12_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t12_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t13 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t14_cmp = call i32 @flux_str_compare(i8* %t12, i8* %t13)
  %t14 = icmp eq i32 %t14_cmp, 0
  %t15 = or i1 %t11, %t14
  %t16_i64 = load i64, i64* %_v_tn, align 8
  %t16 = inttoptr i64 %t16_i64 to i8*
  %t16_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t16_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t17 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t18_cmp = call i32 @flux_str_compare(i8* %t16, i8* %t17)
  %t18 = icmp eq i32 %t18_cmp, 0
  %t19 = or i1 %t15, %t18
  br i1 %t19, label %ft_0, label %route_arm_4
ft_0:
  %t20 = add i64 0, 8
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t20, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t21, 3
  ret %flux.result %em_r3_1
route_arm_4:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i64 0, 8
  %t47 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %t46, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t47, 3
  ret %flux.result %em_r3_2
route_arm_22:
  %t49_i64 = load i64, i64* %_v_tn, align 8
  %t49 = inttoptr i64 %t49_i64 to i8*
  %t49_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t49_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t50 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t51_cmp = call i32 @flux_str_compare(i8* %t49, i8* %t50)
  %t51 = icmp eq i32 %t51_cmp, 0
  %t52_i64 = load i64, i64* %_v_tn, align 8
  %t52 = inttoptr i64 %t52_i64 to i8*
  %t52_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t52_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t53 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t54_cmp = call i32 @flux_str_compare(i8* %t52, i8* %t53)
  %t54 = icmp eq i32 %t54_cmp, 0
  %t55 = or i1 %t51, %t54
  br i1 %t55, label %ft_2, label %route_arm_48
ft_2:
  %t56 = add i64 0, 1
  %t57 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_3 = insertvalue %flux.result undef, i8* %em_sta_3, 0
  %em_r1_3 = insertvalue %flux.result %em_r0_3, i64 %t56, 1
  %em_r2_3 = insertvalue %flux.result %em_r1_3, double 0.0, 2
  %em_r3_3 = insertvalue %flux.result %em_r2_3, i8* %t57, 3
  ret %flux.result %em_r3_3
route_arm_48:
  %t59_i64 = load i64, i64* %_v_tn, align 8
  %t59 = inttoptr i64 %t59_i64 to i8*
  %t59_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t59_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t60 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t61_cmp = call i32 @flux_str_compare(i8* %t59, i8* %t60)
  %t61 = icmp eq i32 %t61_cmp, 0
  %t62_i64 = load i64, i64* %_v_tn, align 8
  %t62 = inttoptr i64 %t62_i64 to i8*
  %t62_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t62_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t63 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t64_cmp = call i32 @flux_str_compare(i8* %t62, i8* %t63)
  %t64 = icmp eq i32 %t64_cmp, 0
  %t65 = or i1 %t61, %t64
  br i1 %t65, label %ft_3, label %route_arm_58
ft_3:
  %t66 = add i64 0, 1
  %t67 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_4 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_4 = insertvalue %flux.result undef, i8* %em_sta_4, 0
  %em_r1_4 = insertvalue %flux.result %em_r0_4, i64 %t66, 1
  %em_r2_4 = insertvalue %flux.result %em_r1_4, double 0.0, 2
  %em_r3_4 = insertvalue %flux.result %em_r2_4, i8* %t67, 3
  ret %flux.result %em_r3_4
route_arm_58:
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72_i64 = load i64, i64* %_v_tn, align 8
  %t72 = inttoptr i64 %t72_i64 to i8*
  %t72_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t72_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t73 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t74_cmp = call i32 @flux_str_compare(i8* %t72, i8* %t73)
  %t74 = icmp eq i32 %t74_cmp, 0
  %t75 = or i1 %t71, %t74
  %t76_i64 = load i64, i64* %_v_tn, align 8
  %t76 = inttoptr i64 %t76_i64 to i8*
  %t76_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t76_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t77 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t78_cmp = call i32 @flux_str_compare(i8* %t76, i8* %t77)
  %t78 = icmp eq i32 %t78_cmp, 0
  %t79 = or i1 %t75, %t78
  br i1 %t79, label %ft_4, label %route_arm_68
ft_4:
  %t80 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t81_i64 = load i64, i64* %_v_value, align 8
  %t81 = inttoptr i64 %t81_i64 to i8*
  %t81_vsta = load i8*, i8** %_v_value__sta, align 8
  %t81_vmsg = load i8*, i8** %_v_value__msg, align 8
  %cv_raw_1 = ptrtoint i8* %t81 to i64
  %cv_buf_1 = call i8* @flux_val_to_str(i64 %cv_raw_1)
  %t82 = call i8* @flux_str_concat(i8* %t80, i8* %cv_buf_1)
  %st_2 = ptrtoint i8* %t82 to i64
  store i64 %st_2, i64* %_v_s, align 8
  %t83 = add i64 0, 0
  store i64 %t83, i64* %_v_slen, align 8
  %t84_i64 = load i64, i64* %_v_s, align 8
  %t84 = inttoptr i64 %t84_i64 to i8*
  %t84_vsta = load i8*, i8** %_v_s__sta, align 8
  %t84_vmsg = load i8*, i8** %_v_s__msg, align 8
  %t85 = call i64 @flux_str_len(i8* %t84)
  %t87 = add i64 0, 1
  store i64 %t87, i64* %_v___iter_idx_86, align 8
  %t88 = add i64 0, 1
  br label %loop_start_89
loop_start_89:
  %t90 = load i64, i64* %_v___iter_idx_86, align 8
  %t90_vsta = load i8*, i8** %_v___iter_idx_86__sta, align 8
  %t90_vmsg = load i8*, i8** %_v___iter_idx_86__msg, align 8
  %t91 = icmp sle i64 %t90, %t85
  br i1 %t91, label %ft_5, label %loop_end_89
ft_5:
  %cg_str_1 = call i8* @flux_str_slice(i8* %t84, i64 %t90, i64 %t90)
  %cg_si_1 = ptrtoint i8* %cg_str_1 to i64
  store i64 %cg_si_1, i64* %_v_c, align 8
  %t92 = load i64, i64* %_v_slen, align 8
  %t92_vsta = load i8*, i8** %_v_slen__sta, align 8
  %t92_vmsg = load i8*, i8** %_v_slen__msg, align 8
  %t93 = add i64 0, 1
  %t94 = add i64 %t92, %t93
  store i64 %t94, i64* %_v_slen, align 8
  br label %loop_step_89
loop_step_89:
  %t95 = load i64, i64* %_v___iter_idx_86, align 8
  %t95_vsta = load i8*, i8** %_v___iter_idx_86__sta, align 8
  %t95_vmsg = load i8*, i8** %_v___iter_idx_86__msg, align 8
  %t96 = add i64 %t95, %t88
  store i64 %t96, i64* %_v___iter_idx_86, align 8
  br label %loop_start_89
loop_end_89:
  %t97 = load i64, i64* %_v_slen, align 8
  %t97_vsta = load i8*, i8** %_v_slen__sta, align 8
  %t97_vmsg = load i8*, i8** %_v_slen__msg, align 8
  %t98 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_5 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_5 = insertvalue %flux.result undef, i8* %em_sta_5, 0
  %em_r1_5 = insertvalue %flux.result %em_r0_5, i64 %t97, 1
  %em_r2_5 = insertvalue %flux.result %em_r1_5, double 0.0, 2
  %em_r3_5 = insertvalue %flux.result %em_r2_5, i8* %t98, 3
  ret %flux.result %em_r3_5
route_arm_68:
  %t100_i64 = load i64, i64* %_v_tn, align 8
  %t100 = inttoptr i64 %t100_i64 to i8*
  %t100_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t100_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t101 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t102_cmp = call i32 @flux_str_compare(i8* %t100, i8* %t101)
  %t102 = icmp eq i32 %t102_cmp, 0
  %t103_i64 = load i64, i64* %_v_tn, align 8
  %t103 = inttoptr i64 %t103_i64 to i8*
  %t103_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t103_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t104 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t105_cmp = call i32 @flux_str_compare(i8* %t103, i8* %t104)
  %t105 = icmp eq i32 %t105_cmp, 0
  %t106 = or i1 %t102, %t105
  %t107_i64 = load i64, i64* %_v_tn, align 8
  %t107 = inttoptr i64 %t107_i64 to i8*
  %t107_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t107_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t108 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t109_cmp = call i32 @flux_str_compare(i8* %t107, i8* %t108)
  %t109 = icmp eq i32 %t109_cmp, 0
  %t110 = or i1 %t106, %t109
  %t111_i64 = load i64, i64* %_v_tn, align 8
  %t111 = inttoptr i64 %t111_i64 to i8*
  %t111_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t111_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t112 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t113_cmp = call i32 @flux_str_compare(i8* %t111, i8* %t112)
  %t113 = icmp eq i32 %t113_cmp, 0
  %t114 = or i1 %t110, %t113
  %t115_i64 = load i64, i64* %_v_tn, align 8
  %t115 = inttoptr i64 %t115_i64 to i8*
  %t115_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t115_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t116 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t117_cmp = call i32 @flux_str_compare(i8* %t115, i8* %t116)
  %t117 = icmp eq i32 %t117_cmp, 0
  %t118 = or i1 %t114, %t117
  %t119_i64 = load i64, i64* %_v_tn, align 8
  %t119 = inttoptr i64 %t119_i64 to i8*
  %t119_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t119_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t120 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t121_cmp = call i32 @flux_str_compare(i8* %t119, i8* %t120)
  %t121 = icmp eq i32 %t121_cmp, 0
  %t122 = or i1 %t118, %t121
  br i1 %t122, label %ft_6, label %route_arm_99
ft_6:
  %t123 = add i64 0, 16
  %t124 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_6 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_6 = insertvalue %flux.result undef, i8* %em_sta_6, 0
  %em_r1_6 = insertvalue %flux.result %em_r0_6, i64 %t123, 1
  %em_r2_6 = insertvalue %flux.result %em_r1_6, double 0.0, 2
  %em_r3_6 = insertvalue %flux.result %em_r2_6, i8* %t124, 3
  ret %flux.result %em_r3_6
route_arm_99:
  %t126 = add i64 0, 32
  %t127 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_7 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_7 = insertvalue %flux.result undef, i8* %em_sta_7, 0
  %em_r1_7 = insertvalue %flux.result %em_r0_7, i64 %t126, 1
  %em_r2_7 = insertvalue %flux.result %em_r1_7, double 0.0, 2
  %em_r3_7 = insertvalue %flux.result %em_r2_7, i8* %t127, 3
  ret %flux.result %em_r3_7
route_end_3:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__runtimeGetStructMetadata(i64 %in_1) {
fn_entry:
  %_v_struct_name = alloca i64, align 8
  %_v_struct_name__sta = alloca i8*, align 8
  %_v_struct_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_struct_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_struct_name__msg, align 8
  %_v_m = alloca i64, align 8
  %_v_m__sta = alloca i8*, align 8
  %_v_m__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_m__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_m__msg, align 8
  store i64 %in_1, i64* %_v_struct_name, align 8
  %t1 = call i8* @flux_map_build(i64 0)
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.38, i32 0, i32 0
  %t3_i64 = load i64, i64* %_v_struct_name, align 8
  %t3 = inttoptr i64 %t3_i64 to i8*
  %t3_vsta = load i8*, i8** %_v_struct_name__sta, align 8
  %t3_vmsg = load i8*, i8** %_v_struct_name__msg, align 8
  %p_ms_1 = ptrtoint i8* %t3 to i64
  call i8* @flux_map_set(i8* %t1, i8* %t2, i64 4, i64 %p_ms_1)
  %t4 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.39, i32 0, i32 0
  %t5 = add i1 0, 1
  %p_ms_b_2 = zext i1 %t5 to i64
  call i8* @flux_map_set(i8* %t1, i8* %t4, i64 1, i64 %p_ms_b_2)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_m, align 8
  %t6_i64 = load i64, i64* %_v_m, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_m__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_m__msg, align 8
  %t7 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t6 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t7, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__getTypeName(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__getTypeId(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t5_i64 = load i64, i64* %_v_tn, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t6 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8_i64 = load i64, i64* %_v_tn, align 8
  %t8 = inttoptr i64 %t8_i64 to i8*
  %t8_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t8_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t9 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t10_cmp = call i32 @flux_str_compare(i8* %t8, i8* %t9)
  %t10 = icmp eq i32 %t10_cmp, 0
  %t11 = or i1 %t7, %t10
  %t12_i64 = load i64, i64* %_v_tn, align 8
  %t12 = inttoptr i64 %t12_i64 to i8*
  %t12_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t12_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t13 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t14_cmp = call i32 @flux_str_compare(i8* %t12, i8* %t13)
  %t14 = icmp eq i32 %t14_cmp, 0
  %t15 = or i1 %t11, %t14
  %t16_i64 = load i64, i64* %_v_tn, align 8
  %t16 = inttoptr i64 %t16_i64 to i8*
  %t16_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t16_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t17 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t18_cmp = call i32 @flux_str_compare(i8* %t16, i8* %t17)
  %t18 = icmp eq i32 %t18_cmp, 0
  %t19 = or i1 %t15, %t18
  br i1 %t19, label %ft_0, label %route_arm_4
ft_0:
  %t20 = add i64 0, 1
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t20, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t21, 3
  ret %flux.result %em_r3_1
route_arm_4:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i64 0, 2
  %t47 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %t46, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t47, 3
  ret %flux.result %em_r3_2
route_arm_22:
  %t49_i64 = load i64, i64* %_v_tn, align 8
  %t49 = inttoptr i64 %t49_i64 to i8*
  %t49_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t49_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t50 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t51_cmp = call i32 @flux_str_compare(i8* %t49, i8* %t50)
  %t51 = icmp eq i32 %t51_cmp, 0
  %t52_i64 = load i64, i64* %_v_tn, align 8
  %t52 = inttoptr i64 %t52_i64 to i8*
  %t52_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t52_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t53 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t54_cmp = call i32 @flux_str_compare(i8* %t52, i8* %t53)
  %t54 = icmp eq i32 %t54_cmp, 0
  %t55 = or i1 %t51, %t54
  br i1 %t55, label %ft_2, label %route_arm_48
ft_2:
  %t56 = add i64 0, 3
  %t57 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_3 = insertvalue %flux.result undef, i8* %em_sta_3, 0
  %em_r1_3 = insertvalue %flux.result %em_r0_3, i64 %t56, 1
  %em_r2_3 = insertvalue %flux.result %em_r1_3, double 0.0, 2
  %em_r3_3 = insertvalue %flux.result %em_r2_3, i8* %t57, 3
  ret %flux.result %em_r3_3
route_arm_48:
  %t59_i64 = load i64, i64* %_v_tn, align 8
  %t59 = inttoptr i64 %t59_i64 to i8*
  %t59_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t59_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t60 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t61_cmp = call i32 @flux_str_compare(i8* %t59, i8* %t60)
  %t61 = icmp eq i32 %t61_cmp, 0
  %t62_i64 = load i64, i64* %_v_tn, align 8
  %t62 = inttoptr i64 %t62_i64 to i8*
  %t62_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t62_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t63 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t64_cmp = call i32 @flux_str_compare(i8* %t62, i8* %t63)
  %t64 = icmp eq i32 %t64_cmp, 0
  %t65 = or i1 %t61, %t64
  br i1 %t65, label %ft_3, label %route_arm_58
ft_3:
  %t66 = add i64 0, 4
  %t67 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_4 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_4 = insertvalue %flux.result undef, i8* %em_sta_4, 0
  %em_r1_4 = insertvalue %flux.result %em_r0_4, i64 %t66, 1
  %em_r2_4 = insertvalue %flux.result %em_r1_4, double 0.0, 2
  %em_r3_4 = insertvalue %flux.result %em_r2_4, i8* %t67, 3
  ret %flux.result %em_r3_4
route_arm_58:
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72_i64 = load i64, i64* %_v_tn, align 8
  %t72 = inttoptr i64 %t72_i64 to i8*
  %t72_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t72_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t73 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t74_cmp = call i32 @flux_str_compare(i8* %t72, i8* %t73)
  %t74 = icmp eq i32 %t74_cmp, 0
  %t75 = or i1 %t71, %t74
  %t76_i64 = load i64, i64* %_v_tn, align 8
  %t76 = inttoptr i64 %t76_i64 to i8*
  %t76_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t76_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t77 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t78_cmp = call i32 @flux_str_compare(i8* %t76, i8* %t77)
  %t78 = icmp eq i32 %t78_cmp, 0
  %t79 = or i1 %t75, %t78
  br i1 %t79, label %ft_4, label %route_arm_68
ft_4:
  %t80 = add i64 0, 5
  %t81 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_5 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_5 = insertvalue %flux.result undef, i8* %em_sta_5, 0
  %em_r1_5 = insertvalue %flux.result %em_r0_5, i64 %t80, 1
  %em_r2_5 = insertvalue %flux.result %em_r1_5, double 0.0, 2
  %em_r3_5 = insertvalue %flux.result %em_r2_5, i8* %t81, 3
  ret %flux.result %em_r3_5
route_arm_68:
  %t83_i64 = load i64, i64* %_v_tn, align 8
  %t83 = inttoptr i64 %t83_i64 to i8*
  %t83_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t83_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t84 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t85_cmp = call i32 @flux_str_compare(i8* %t83, i8* %t84)
  %t85 = icmp eq i32 %t85_cmp, 0
  %t86_i64 = load i64, i64* %_v_tn, align 8
  %t86 = inttoptr i64 %t86_i64 to i8*
  %t86_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t86_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t87 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t88_cmp = call i32 @flux_str_compare(i8* %t86, i8* %t87)
  %t88 = icmp eq i32 %t88_cmp, 0
  %t89 = or i1 %t85, %t88
  br i1 %t89, label %ft_5, label %route_arm_82
ft_5:
  %t90 = add i64 0, 6
  %t91 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_6 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_6 = insertvalue %flux.result undef, i8* %em_sta_6, 0
  %em_r1_6 = insertvalue %flux.result %em_r0_6, i64 %t90, 1
  %em_r2_6 = insertvalue %flux.result %em_r1_6, double 0.0, 2
  %em_r3_6 = insertvalue %flux.result %em_r2_6, i8* %t91, 3
  ret %flux.result %em_r3_6
route_arm_82:
  %t93_i64 = load i64, i64* %_v_tn, align 8
  %t93 = inttoptr i64 %t93_i64 to i8*
  %t93_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t93_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t94 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t95_cmp = call i32 @flux_str_compare(i8* %t93, i8* %t94)
  %t95 = icmp eq i32 %t95_cmp, 0
  %t96_i64 = load i64, i64* %_v_tn, align 8
  %t96 = inttoptr i64 %t96_i64 to i8*
  %t96_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t96_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t97 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t98_cmp = call i32 @flux_str_compare(i8* %t96, i8* %t97)
  %t98 = icmp eq i32 %t98_cmp, 0
  %t99 = or i1 %t95, %t98
  br i1 %t99, label %ft_6, label %route_arm_92
ft_6:
  %t100 = add i64 0, 7
  %t101 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_7 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_7 = insertvalue %flux.result undef, i8* %em_sta_7, 0
  %em_r1_7 = insertvalue %flux.result %em_r0_7, i64 %t100, 1
  %em_r2_7 = insertvalue %flux.result %em_r1_7, double 0.0, 2
  %em_r3_7 = insertvalue %flux.result %em_r2_7, i8* %t101, 3
  ret %flux.result %em_r3_7
route_arm_92:
  %t103_i64 = load i64, i64* %_v_tn, align 8
  %t103 = inttoptr i64 %t103_i64 to i8*
  %t103_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t103_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t104 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t105_cmp = call i32 @flux_str_compare(i8* %t103, i8* %t104)
  %t105 = icmp eq i32 %t105_cmp, 0
  %t106_i64 = load i64, i64* %_v_tn, align 8
  %t106 = inttoptr i64 %t106_i64 to i8*
  %t106_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t106_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t107 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t108_cmp = call i32 @flux_str_compare(i8* %t106, i8* %t107)
  %t108 = icmp eq i32 %t108_cmp, 0
  %t109 = or i1 %t105, %t108
  br i1 %t109, label %ft_7, label %route_arm_102
ft_7:
  %t110 = add i64 0, 8
  %t111 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_8 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_8 = insertvalue %flux.result undef, i8* %em_sta_8, 0
  %em_r1_8 = insertvalue %flux.result %em_r0_8, i64 %t110, 1
  %em_r2_8 = insertvalue %flux.result %em_r1_8, double 0.0, 2
  %em_r3_8 = insertvalue %flux.result %em_r2_8, i8* %t111, 3
  ret %flux.result %em_r3_8
route_arm_102:
  %t113 = add i64 0, 9
  %t114 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_9 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_9 = insertvalue %flux.result undef, i8* %em_sta_9, 0
  %em_r1_9 = insertvalue %flux.result %em_r0_9, i64 %t113, 1
  %em_r2_9 = insertvalue %flux.result %em_r1_9, double 0.0, 2
  %em_r3_9 = insertvalue %flux.result %em_r2_9, i8* %t114, 3
  ret %flux.result %em_r3_9
route_end_3:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__isPrimitive(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t3 = add i1 0, 0
  %st_b_2 = zext i1 %t3 to i64
  store i64 %st_b_2, i64* %_v_res, align 8
  %t6_i64 = load i64, i64* %_v_tn, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t7 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t8_cmp = call i32 @flux_str_compare(i8* %t6, i8* %t7)
  %t8 = icmp eq i32 %t8_cmp, 0
  %t9_i64 = load i64, i64* %_v_tn, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t10 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  %t13_i64 = load i64, i64* %_v_tn, align 8
  %t13 = inttoptr i64 %t13_i64 to i8*
  %t13_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t13_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t15_cmp = call i32 @flux_str_compare(i8* %t13, i8* %t14)
  %t15 = icmp eq i32 %t15_cmp, 0
  %t16 = or i1 %t12, %t15
  %t17_i64 = load i64, i64* %_v_tn, align 8
  %t17 = inttoptr i64 %t17_i64 to i8*
  %t17_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t17_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t18 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t19_cmp = call i32 @flux_str_compare(i8* %t17, i8* %t18)
  %t19 = icmp eq i32 %t19_cmp, 0
  %t20 = or i1 %t16, %t19
  br i1 %t20, label %ft_0, label %route_arm_5
ft_0:
  %t21 = add i1 0, 1
  %st_b_3 = zext i1 %t21 to i64
  store i64 %st_b_3, i64* %_v_res, align 8
  br label %route_end_4
route_arm_5:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i1 0, 1
  %st_b_4 = zext i1 %t46 to i64
  store i64 %st_b_4, i64* %_v_res, align 8
  br label %route_end_4
route_arm_22:
  %t48_i64 = load i64, i64* %_v_tn, align 8
  %t48 = inttoptr i64 %t48_i64 to i8*
  %t48_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t48_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t49 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t50_cmp = call i32 @flux_str_compare(i8* %t48, i8* %t49)
  %t50 = icmp eq i32 %t50_cmp, 0
  %t51_i64 = load i64, i64* %_v_tn, align 8
  %t51 = inttoptr i64 %t51_i64 to i8*
  %t51_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t51_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t52 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t53_cmp = call i32 @flux_str_compare(i8* %t51, i8* %t52)
  %t53 = icmp eq i32 %t53_cmp, 0
  %t54 = or i1 %t50, %t53
  br i1 %t54, label %ft_2, label %route_arm_47
ft_2:
  %t55 = add i1 0, 1
  %st_b_5 = zext i1 %t55 to i64
  store i64 %st_b_5, i64* %_v_res, align 8
  br label %route_end_4
route_arm_47:
  %t57_i64 = load i64, i64* %_v_tn, align 8
  %t57 = inttoptr i64 %t57_i64 to i8*
  %t57_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t57_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t58 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t59_cmp = call i32 @flux_str_compare(i8* %t57, i8* %t58)
  %t59 = icmp eq i32 %t59_cmp, 0
  %t60_i64 = load i64, i64* %_v_tn, align 8
  %t60 = inttoptr i64 %t60_i64 to i8*
  %t60_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t60_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t61 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t62_cmp = call i32 @flux_str_compare(i8* %t60, i8* %t61)
  %t62 = icmp eq i32 %t62_cmp, 0
  %t63 = or i1 %t59, %t62
  br i1 %t63, label %ft_3, label %route_arm_56
ft_3:
  %t64 = add i1 0, 1
  %st_b_6 = zext i1 %t64 to i64
  store i64 %st_b_6, i64* %_v_res, align 8
  br label %route_end_4
route_arm_56:
  %t66_i64 = load i64, i64* %_v_tn, align 8
  %t66 = inttoptr i64 %t66_i64 to i8*
  %t66_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t66_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t67 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t68_cmp = call i32 @flux_str_compare(i8* %t66, i8* %t67)
  %t68 = icmp eq i32 %t68_cmp, 0
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72 = or i1 %t68, %t71
  %t73_i64 = load i64, i64* %_v_tn, align 8
  %t73 = inttoptr i64 %t73_i64 to i8*
  %t73_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t73_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t74 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t75_cmp = call i32 @flux_str_compare(i8* %t73, i8* %t74)
  %t75 = icmp eq i32 %t75_cmp, 0
  %t76 = or i1 %t72, %t75
  br i1 %t76, label %ft_4, label %route_arm_65
ft_4:
  %t77 = add i1 0, 1
  %st_b_7 = zext i1 %t77 to i64
  store i64 %st_b_7, i64* %_v_res, align 8
  br label %route_end_4
route_arm_65:
  %t79 = add i1 0, 0
  %st_b_8 = zext i1 %t79 to i64
  store i64 %st_b_8, i64* %_v_res, align 8
  br label %route_end_4
route_end_4:
  %t80_i64 = load i64, i64* %_v_res, align 8
  %t80 = trunc i64 %t80_i64 to i1
  %t80_vsta = load i8*, i8** %_v_res__sta, align 8
  %t80_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t81 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t80 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t81, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__isCollection(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t3 = add i1 0, 0
  %st_b_2 = zext i1 %t3 to i64
  store i64 %st_b_2, i64* %_v_res, align 8
  %t6_i64 = load i64, i64* %_v_tn, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t7 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t8_cmp = call i32 @flux_str_compare(i8* %t6, i8* %t7)
  %t8 = icmp eq i32 %t8_cmp, 0
  %t9_i64 = load i64, i64* %_v_tn, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t10 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  br i1 %t12, label %ft_0, label %route_arm_5
ft_0:
  %t13 = add i1 0, 1
  %st_b_3 = zext i1 %t13 to i64
  store i64 %st_b_3, i64* %_v_res, align 8
  br label %route_end_4
route_arm_5:
  %t15_i64 = load i64, i64* %_v_tn, align 8
  %t15 = inttoptr i64 %t15_i64 to i8*
  %t15_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t15_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t16 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t17_cmp = call i32 @flux_str_compare(i8* %t15, i8* %t16)
  %t17 = icmp eq i32 %t17_cmp, 0
  %t18_i64 = load i64, i64* %_v_tn, align 8
  %t18 = inttoptr i64 %t18_i64 to i8*
  %t18_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t18_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t19 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t20_cmp = call i32 @flux_str_compare(i8* %t18, i8* %t19)
  %t20 = icmp eq i32 %t20_cmp, 0
  %t21 = or i1 %t17, %t20
  br i1 %t21, label %ft_1, label %route_arm_14
ft_1:
  %t22 = add i1 0, 1
  %st_b_4 = zext i1 %t22 to i64
  store i64 %st_b_4, i64* %_v_res, align 8
  br label %route_end_4
route_arm_14:
  %t24_i64 = load i64, i64* %_v_tn, align 8
  %t24 = inttoptr i64 %t24_i64 to i8*
  %t24_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t24_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t25 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t26_cmp = call i32 @flux_str_compare(i8* %t24, i8* %t25)
  %t26 = icmp eq i32 %t26_cmp, 0
  %t27_i64 = load i64, i64* %_v_tn, align 8
  %t27 = inttoptr i64 %t27_i64 to i8*
  %t27_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t27_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t28 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t29_cmp = call i32 @flux_str_compare(i8* %t27, i8* %t28)
  %t29 = icmp eq i32 %t29_cmp, 0
  %t30 = or i1 %t26, %t29
  br i1 %t30, label %ft_2, label %route_arm_23
ft_2:
  %t31 = add i1 0, 1
  %st_b_5 = zext i1 %t31 to i64
  store i64 %st_b_5, i64* %_v_res, align 8
  br label %route_end_4
route_arm_23:
  %t33 = add i1 0, 0
  %st_b_6 = zext i1 %t33 to i64
  store i64 %st_b_6, i64* %_v_res, align 8
  br label %route_end_4
route_end_4:
  %t34_i64 = load i64, i64* %_v_res, align 8
  %t34 = trunc i64 %t34_i64 to i1
  %t34_vsta = load i8*, i8** %_v_res__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t35 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t34 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t35, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__isStruct(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t3 = add i1 0, 0
  %st_b_2 = zext i1 %t3 to i64
  store i64 %st_b_2, i64* %_v_res, align 8
  %t6_i64 = load i64, i64* %_v_tn, align 8
  %t6 = inttoptr i64 %t6_i64 to i8*
  %t6_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t7 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t8_cmp = call i32 @flux_str_compare(i8* %t6, i8* %t7)
  %t8 = icmp eq i32 %t8_cmp, 0
  %t9_i64 = load i64, i64* %_v_tn, align 8
  %t9 = inttoptr i64 %t9_i64 to i8*
  %t9_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t9_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t10 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t11_cmp = call i32 @flux_str_compare(i8* %t9, i8* %t10)
  %t11 = icmp eq i32 %t11_cmp, 0
  %t12 = or i1 %t8, %t11
  %t13_i64 = load i64, i64* %_v_tn, align 8
  %t13 = inttoptr i64 %t13_i64 to i8*
  %t13_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t13_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t15_cmp = call i32 @flux_str_compare(i8* %t13, i8* %t14)
  %t15 = icmp eq i32 %t15_cmp, 0
  %t16 = or i1 %t12, %t15
  %t17_i64 = load i64, i64* %_v_tn, align 8
  %t17 = inttoptr i64 %t17_i64 to i8*
  %t17_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t17_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t18 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t19_cmp = call i32 @flux_str_compare(i8* %t17, i8* %t18)
  %t19 = icmp eq i32 %t19_cmp, 0
  %t20 = or i1 %t16, %t19
  br i1 %t20, label %ft_0, label %route_arm_5
ft_0:
  %t21 = add i1 0, 0
  %st_b_3 = zext i1 %t21 to i64
  store i64 %st_b_3, i64* %_v_res, align 8
  br label %route_end_4
route_arm_5:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i1 0, 0
  %st_b_4 = zext i1 %t46 to i64
  store i64 %st_b_4, i64* %_v_res, align 8
  br label %route_end_4
route_arm_22:
  %t48_i64 = load i64, i64* %_v_tn, align 8
  %t48 = inttoptr i64 %t48_i64 to i8*
  %t48_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t48_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t49 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t50_cmp = call i32 @flux_str_compare(i8* %t48, i8* %t49)
  %t50 = icmp eq i32 %t50_cmp, 0
  %t51_i64 = load i64, i64* %_v_tn, align 8
  %t51 = inttoptr i64 %t51_i64 to i8*
  %t51_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t51_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t52 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t53_cmp = call i32 @flux_str_compare(i8* %t51, i8* %t52)
  %t53 = icmp eq i32 %t53_cmp, 0
  %t54 = or i1 %t50, %t53
  br i1 %t54, label %ft_2, label %route_arm_47
ft_2:
  %t55 = add i1 0, 0
  %st_b_5 = zext i1 %t55 to i64
  store i64 %st_b_5, i64* %_v_res, align 8
  br label %route_end_4
route_arm_47:
  %t57_i64 = load i64, i64* %_v_tn, align 8
  %t57 = inttoptr i64 %t57_i64 to i8*
  %t57_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t57_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t58 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t59_cmp = call i32 @flux_str_compare(i8* %t57, i8* %t58)
  %t59 = icmp eq i32 %t59_cmp, 0
  %t60_i64 = load i64, i64* %_v_tn, align 8
  %t60 = inttoptr i64 %t60_i64 to i8*
  %t60_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t60_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t61 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t62_cmp = call i32 @flux_str_compare(i8* %t60, i8* %t61)
  %t62 = icmp eq i32 %t62_cmp, 0
  %t63 = or i1 %t59, %t62
  br i1 %t63, label %ft_3, label %route_arm_56
ft_3:
  %t64 = add i1 0, 0
  %st_b_6 = zext i1 %t64 to i64
  store i64 %st_b_6, i64* %_v_res, align 8
  br label %route_end_4
route_arm_56:
  %t66_i64 = load i64, i64* %_v_tn, align 8
  %t66 = inttoptr i64 %t66_i64 to i8*
  %t66_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t66_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t67 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t68_cmp = call i32 @flux_str_compare(i8* %t66, i8* %t67)
  %t68 = icmp eq i32 %t68_cmp, 0
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72 = or i1 %t68, %t71
  %t73_i64 = load i64, i64* %_v_tn, align 8
  %t73 = inttoptr i64 %t73_i64 to i8*
  %t73_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t73_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t74 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t75_cmp = call i32 @flux_str_compare(i8* %t73, i8* %t74)
  %t75 = icmp eq i32 %t75_cmp, 0
  %t76 = or i1 %t72, %t75
  br i1 %t76, label %ft_4, label %route_arm_65
ft_4:
  %t77 = add i1 0, 0
  %st_b_7 = zext i1 %t77 to i64
  store i64 %st_b_7, i64* %_v_res, align 8
  br label %route_end_4
route_arm_65:
  %t79_i64 = load i64, i64* %_v_tn, align 8
  %t79 = inttoptr i64 %t79_i64 to i8*
  %t79_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t79_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t80 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t81_cmp = call i32 @flux_str_compare(i8* %t79, i8* %t80)
  %t81 = icmp eq i32 %t81_cmp, 0
  %t82_i64 = load i64, i64* %_v_tn, align 8
  %t82 = inttoptr i64 %t82_i64 to i8*
  %t82_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t82_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t83 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t84_cmp = call i32 @flux_str_compare(i8* %t82, i8* %t83)
  %t84 = icmp eq i32 %t84_cmp, 0
  %t85 = or i1 %t81, %t84
  br i1 %t85, label %ft_5, label %route_arm_78
ft_5:
  %t86 = add i1 0, 0
  %st_b_8 = zext i1 %t86 to i64
  store i64 %st_b_8, i64* %_v_res, align 8
  br label %route_end_4
route_arm_78:
  %t88_i64 = load i64, i64* %_v_tn, align 8
  %t88 = inttoptr i64 %t88_i64 to i8*
  %t88_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t88_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t89 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t90_cmp = call i32 @flux_str_compare(i8* %t88, i8* %t89)
  %t90 = icmp eq i32 %t90_cmp, 0
  %t91_i64 = load i64, i64* %_v_tn, align 8
  %t91 = inttoptr i64 %t91_i64 to i8*
  %t91_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t91_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t92 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t93_cmp = call i32 @flux_str_compare(i8* %t91, i8* %t92)
  %t93 = icmp eq i32 %t93_cmp, 0
  %t94 = or i1 %t90, %t93
  br i1 %t94, label %ft_6, label %route_arm_87
ft_6:
  %t95 = add i1 0, 0
  %st_b_9 = zext i1 %t95 to i64
  store i64 %st_b_9, i64* %_v_res, align 8
  br label %route_end_4
route_arm_87:
  %t97_i64 = load i64, i64* %_v_tn, align 8
  %t97 = inttoptr i64 %t97_i64 to i8*
  %t97_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t97_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t98 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t99_cmp = call i32 @flux_str_compare(i8* %t97, i8* %t98)
  %t99 = icmp eq i32 %t99_cmp, 0
  %t100_i64 = load i64, i64* %_v_tn, align 8
  %t100 = inttoptr i64 %t100_i64 to i8*
  %t100_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t100_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t101 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t102_cmp = call i32 @flux_str_compare(i8* %t100, i8* %t101)
  %t102 = icmp eq i32 %t102_cmp, 0
  %t103 = or i1 %t99, %t102
  br i1 %t103, label %ft_7, label %route_arm_96
ft_7:
  %t104 = add i1 0, 0
  %st_b_10 = zext i1 %t104 to i64
  store i64 %st_b_10, i64* %_v_res, align 8
  br label %route_end_4
route_arm_96:
  %t106 = add i1 0, 1
  %st_b_11 = zext i1 %t106 to i64
  store i64 %st_b_11, i64* %_v_res, align 8
  br label %route_end_4
route_end_4:
  %t107_i64 = load i64, i64* %_v_res, align 8
  %t107 = trunc i64 %t107_i64 to i1
  %t107_vsta = load i8*, i8** %_v_res__sta, align 8
  %t107_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t108 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t107 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t108, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__sizeOf(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  %_v_tn = alloca i64, align 8
  %_v_tn__sta = alloca i8*, align 8
  %_v_tn__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_tn__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_tn__msg, align 8
  %_v_s = alloca i64, align 8
  %_v_s__sta = alloca i8*, align 8
  %_v_s__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_s__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_s__msg, align 8
  %_v_slen = alloca i64, align 8
  %_v_slen__sta = alloca i8*, align 8
  %_v_slen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_slen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_slen__msg, align 8
  %_v___iter_idx_86 = alloca i64, align 8
  %_v___iter_idx_86__sta = alloca i8*, align 8
  %_v___iter_idx_86__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v___iter_idx_86__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v___iter_idx_86__msg, align 8
  %_v_c = alloca i64, align 8
  %_v_c__sta = alloca i8*, align 8
  %_v_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.12, i32 0, i32 0
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_tn, align 8
  %t5_i64 = load i64, i64* %_v_tn, align 8
  %t5 = inttoptr i64 %t5_i64 to i8*
  %t5_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t6 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.22, i32 0, i32 0
  %t7_cmp = call i32 @flux_str_compare(i8* %t5, i8* %t6)
  %t7 = icmp eq i32 %t7_cmp, 0
  %t8_i64 = load i64, i64* %_v_tn, align 8
  %t8 = inttoptr i64 %t8_i64 to i8*
  %t8_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t8_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t9 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.5, i32 0, i32 0
  %t10_cmp = call i32 @flux_str_compare(i8* %t8, i8* %t9)
  %t10 = icmp eq i32 %t10_cmp, 0
  %t11 = or i1 %t7, %t10
  %t12_i64 = load i64, i64* %_v_tn, align 8
  %t12 = inttoptr i64 %t12_i64 to i8*
  %t12_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t12_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t13 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.23, i32 0, i32 0
  %t14_cmp = call i32 @flux_str_compare(i8* %t12, i8* %t13)
  %t14 = icmp eq i32 %t14_cmp, 0
  %t15 = or i1 %t11, %t14
  %t16_i64 = load i64, i64* %_v_tn, align 8
  %t16 = inttoptr i64 %t16_i64 to i8*
  %t16_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t16_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t17 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i32 0, i32 0
  %t18_cmp = call i32 @flux_str_compare(i8* %t16, i8* %t17)
  %t18 = icmp eq i32 %t18_cmp, 0
  %t19 = or i1 %t15, %t18
  br i1 %t19, label %ft_0, label %route_arm_4
ft_0:
  %t20 = add i64 0, 8
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t20, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t21, 3
  ret %flux.result %em_r3_1
route_arm_4:
  %t23_i64 = load i64, i64* %_v_tn, align 8
  %t23 = inttoptr i64 %t23_i64 to i8*
  %t23_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t23_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t24 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.25, i32 0, i32 0
  %t25_cmp = call i32 @flux_str_compare(i8* %t23, i8* %t24)
  %t25 = icmp eq i32 %t25_cmp, 0
  %t26_i64 = load i64, i64* %_v_tn, align 8
  %t26 = inttoptr i64 %t26_i64 to i8*
  %t26_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t26_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t27 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.6, i32 0, i32 0
  %t28_cmp = call i32 @flux_str_compare(i8* %t26, i8* %t27)
  %t28 = icmp eq i32 %t28_cmp, 0
  %t29 = or i1 %t25, %t28
  %t30_i64 = load i64, i64* %_v_tn, align 8
  %t30 = inttoptr i64 %t30_i64 to i8*
  %t30_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t30_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t31 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i32 0, i32 0
  %t32_cmp = call i32 @flux_str_compare(i8* %t30, i8* %t31)
  %t32 = icmp eq i32 %t32_cmp, 0
  %t33 = or i1 %t29, %t32
  %t34_i64 = load i64, i64* %_v_tn, align 8
  %t34 = inttoptr i64 %t34_i64 to i8*
  %t34_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t34_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t35 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.27, i32 0, i32 0
  %t36_cmp = call i32 @flux_str_compare(i8* %t34, i8* %t35)
  %t36 = icmp eq i32 %t36_cmp, 0
  %t37 = or i1 %t33, %t36
  %t38_i64 = load i64, i64* %_v_tn, align 8
  %t38 = inttoptr i64 %t38_i64 to i8*
  %t38_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t38_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t39 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.28, i32 0, i32 0
  %t40_cmp = call i32 @flux_str_compare(i8* %t38, i8* %t39)
  %t40 = icmp eq i32 %t40_cmp, 0
  %t41 = or i1 %t37, %t40
  %t42_i64 = load i64, i64* %_v_tn, align 8
  %t42 = inttoptr i64 %t42_i64 to i8*
  %t42_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t43 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i32 0, i32 0
  %t44_cmp = call i32 @flux_str_compare(i8* %t42, i8* %t43)
  %t44 = icmp eq i32 %t44_cmp, 0
  %t45 = or i1 %t41, %t44
  br i1 %t45, label %ft_1, label %route_arm_22
ft_1:
  %t46 = add i64 0, 8
  %t47 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_2 = insertvalue %flux.result undef, i8* %em_sta_2, 0
  %em_r1_2 = insertvalue %flux.result %em_r0_2, i64 %t46, 1
  %em_r2_2 = insertvalue %flux.result %em_r1_2, double 0.0, 2
  %em_r3_2 = insertvalue %flux.result %em_r2_2, i8* %t47, 3
  ret %flux.result %em_r3_2
route_arm_22:
  %t49_i64 = load i64, i64* %_v_tn, align 8
  %t49 = inttoptr i64 %t49_i64 to i8*
  %t49_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t49_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t50 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.7, i32 0, i32 0
  %t51_cmp = call i32 @flux_str_compare(i8* %t49, i8* %t50)
  %t51 = icmp eq i32 %t51_cmp, 0
  %t52_i64 = load i64, i64* %_v_tn, align 8
  %t52 = inttoptr i64 %t52_i64 to i8*
  %t52_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t52_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t53 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t54_cmp = call i32 @flux_str_compare(i8* %t52, i8* %t53)
  %t54 = icmp eq i32 %t54_cmp, 0
  %t55 = or i1 %t51, %t54
  br i1 %t55, label %ft_2, label %route_arm_48
ft_2:
  %t56 = add i64 0, 1
  %t57 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_3 = insertvalue %flux.result undef, i8* %em_sta_3, 0
  %em_r1_3 = insertvalue %flux.result %em_r0_3, i64 %t56, 1
  %em_r2_3 = insertvalue %flux.result %em_r1_3, double 0.0, 2
  %em_r3_3 = insertvalue %flux.result %em_r2_3, i8* %t57, 3
  ret %flux.result %em_r3_3
route_arm_48:
  %t59_i64 = load i64, i64* %_v_tn, align 8
  %t59 = inttoptr i64 %t59_i64 to i8*
  %t59_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t59_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t60 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t61_cmp = call i32 @flux_str_compare(i8* %t59, i8* %t60)
  %t61 = icmp eq i32 %t61_cmp, 0
  %t62_i64 = load i64, i64* %_v_tn, align 8
  %t62 = inttoptr i64 %t62_i64 to i8*
  %t62_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t62_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t63 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.32, i32 0, i32 0
  %t64_cmp = call i32 @flux_str_compare(i8* %t62, i8* %t63)
  %t64 = icmp eq i32 %t64_cmp, 0
  %t65 = or i1 %t61, %t64
  br i1 %t65, label %ft_3, label %route_arm_58
ft_3:
  %t66 = add i64 0, 1
  %t67 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_4 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_4 = insertvalue %flux.result undef, i8* %em_sta_4, 0
  %em_r1_4 = insertvalue %flux.result %em_r0_4, i64 %t66, 1
  %em_r2_4 = insertvalue %flux.result %em_r1_4, double 0.0, 2
  %em_r3_4 = insertvalue %flux.result %em_r2_4, i8* %t67, 3
  ret %flux.result %em_r3_4
route_arm_58:
  %t69_i64 = load i64, i64* %_v_tn, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t69_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t70 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.8, i32 0, i32 0
  %t71_cmp = call i32 @flux_str_compare(i8* %t69, i8* %t70)
  %t71 = icmp eq i32 %t71_cmp, 0
  %t72_i64 = load i64, i64* %_v_tn, align 8
  %t72 = inttoptr i64 %t72_i64 to i8*
  %t72_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t72_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t73 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.33, i32 0, i32 0
  %t74_cmp = call i32 @flux_str_compare(i8* %t72, i8* %t73)
  %t74 = icmp eq i32 %t74_cmp, 0
  %t75 = or i1 %t71, %t74
  %t76_i64 = load i64, i64* %_v_tn, align 8
  %t76 = inttoptr i64 %t76_i64 to i8*
  %t76_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t76_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t77 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i32 0, i32 0
  %t78_cmp = call i32 @flux_str_compare(i8* %t76, i8* %t77)
  %t78 = icmp eq i32 %t78_cmp, 0
  %t79 = or i1 %t75, %t78
  br i1 %t79, label %ft_4, label %route_arm_68
ft_4:
  %t80 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t81_i64 = load i64, i64* %_v_value, align 8
  %t81 = inttoptr i64 %t81_i64 to i8*
  %t81_vsta = load i8*, i8** %_v_value__sta, align 8
  %t81_vmsg = load i8*, i8** %_v_value__msg, align 8
  %cv_raw_1 = ptrtoint i8* %t81 to i64
  %cv_buf_1 = call i8* @flux_val_to_str(i64 %cv_raw_1)
  %t82 = call i8* @flux_str_concat(i8* %t80, i8* %cv_buf_1)
  %st_2 = ptrtoint i8* %t82 to i64
  store i64 %st_2, i64* %_v_s, align 8
  %t83 = add i64 0, 0
  store i64 %t83, i64* %_v_slen, align 8
  %t84_i64 = load i64, i64* %_v_s, align 8
  %t84 = inttoptr i64 %t84_i64 to i8*
  %t84_vsta = load i8*, i8** %_v_s__sta, align 8
  %t84_vmsg = load i8*, i8** %_v_s__msg, align 8
  %t85 = call i64 @flux_str_len(i8* %t84)
  %t87 = add i64 0, 1
  store i64 %t87, i64* %_v___iter_idx_86, align 8
  %t88 = add i64 0, 1
  br label %loop_start_89
loop_start_89:
  %t90 = load i64, i64* %_v___iter_idx_86, align 8
  %t90_vsta = load i8*, i8** %_v___iter_idx_86__sta, align 8
  %t90_vmsg = load i8*, i8** %_v___iter_idx_86__msg, align 8
  %t91 = icmp sle i64 %t90, %t85
  br i1 %t91, label %ft_5, label %loop_end_89
ft_5:
  %cg_str_1 = call i8* @flux_str_slice(i8* %t84, i64 %t90, i64 %t90)
  %cg_si_1 = ptrtoint i8* %cg_str_1 to i64
  store i64 %cg_si_1, i64* %_v_c, align 8
  %t92 = load i64, i64* %_v_slen, align 8
  %t92_vsta = load i8*, i8** %_v_slen__sta, align 8
  %t92_vmsg = load i8*, i8** %_v_slen__msg, align 8
  %t93 = add i64 0, 1
  %t94 = add i64 %t92, %t93
  store i64 %t94, i64* %_v_slen, align 8
  br label %loop_step_89
loop_step_89:
  %t95 = load i64, i64* %_v___iter_idx_86, align 8
  %t95_vsta = load i8*, i8** %_v___iter_idx_86__sta, align 8
  %t95_vmsg = load i8*, i8** %_v___iter_idx_86__msg, align 8
  %t96 = add i64 %t95, %t88
  store i64 %t96, i64* %_v___iter_idx_86, align 8
  br label %loop_start_89
loop_end_89:
  %t97 = load i64, i64* %_v_slen, align 8
  %t97_vsta = load i8*, i8** %_v_slen__sta, align 8
  %t97_vmsg = load i8*, i8** %_v_slen__msg, align 8
  %t98 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_5 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_5 = insertvalue %flux.result undef, i8* %em_sta_5, 0
  %em_r1_5 = insertvalue %flux.result %em_r0_5, i64 %t97, 1
  %em_r2_5 = insertvalue %flux.result %em_r1_5, double 0.0, 2
  %em_r3_5 = insertvalue %flux.result %em_r2_5, i8* %t98, 3
  ret %flux.result %em_r3_5
route_arm_68:
  %t100_i64 = load i64, i64* %_v_tn, align 8
  %t100 = inttoptr i64 %t100_i64 to i8*
  %t100_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t100_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t101 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.9, i32 0, i32 0
  %t102_cmp = call i32 @flux_str_compare(i8* %t100, i8* %t101)
  %t102 = icmp eq i32 %t102_cmp, 0
  %t103_i64 = load i64, i64* %_v_tn, align 8
  %t103 = inttoptr i64 %t103_i64 to i8*
  %t103_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t103_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t104 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.35, i32 0, i32 0
  %t105_cmp = call i32 @flux_str_compare(i8* %t103, i8* %t104)
  %t105 = icmp eq i32 %t105_cmp, 0
  %t106 = or i1 %t102, %t105
  %t107_i64 = load i64, i64* %_v_tn, align 8
  %t107 = inttoptr i64 %t107_i64 to i8*
  %t107_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t107_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t108 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.10, i32 0, i32 0
  %t109_cmp = call i32 @flux_str_compare(i8* %t107, i8* %t108)
  %t109 = icmp eq i32 %t109_cmp, 0
  %t110 = or i1 %t106, %t109
  %t111_i64 = load i64, i64* %_v_tn, align 8
  %t111 = inttoptr i64 %t111_i64 to i8*
  %t111_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t111_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t112 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.36, i32 0, i32 0
  %t113_cmp = call i32 @flux_str_compare(i8* %t111, i8* %t112)
  %t113 = icmp eq i32 %t113_cmp, 0
  %t114 = or i1 %t110, %t113
  %t115_i64 = load i64, i64* %_v_tn, align 8
  %t115 = inttoptr i64 %t115_i64 to i8*
  %t115_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t115_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t116 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.11, i32 0, i32 0
  %t117_cmp = call i32 @flux_str_compare(i8* %t115, i8* %t116)
  %t117 = icmp eq i32 %t117_cmp, 0
  %t118 = or i1 %t114, %t117
  %t119_i64 = load i64, i64* %_v_tn, align 8
  %t119 = inttoptr i64 %t119_i64 to i8*
  %t119_vsta = load i8*, i8** %_v_tn__sta, align 8
  %t119_vmsg = load i8*, i8** %_v_tn__msg, align 8
  %t120 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.37, i32 0, i32 0
  %t121_cmp = call i32 @flux_str_compare(i8* %t119, i8* %t120)
  %t121 = icmp eq i32 %t121_cmp, 0
  %t122 = or i1 %t118, %t121
  br i1 %t122, label %ft_6, label %route_arm_99
ft_6:
  %t123 = add i64 0, 16
  %t124 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_6 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_6 = insertvalue %flux.result undef, i8* %em_sta_6, 0
  %em_r1_6 = insertvalue %flux.result %em_r0_6, i64 %t123, 1
  %em_r2_6 = insertvalue %flux.result %em_r1_6, double 0.0, 2
  %em_r3_6 = insertvalue %flux.result %em_r2_6, i8* %t124, 3
  ret %flux.result %em_r3_6
route_arm_99:
  %t126 = add i64 0, 32
  %t127 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_7 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_7 = insertvalue %flux.result undef, i8* %em_sta_7, 0
  %em_r1_7 = insertvalue %flux.result %em_r0_7, i64 %t126, 1
  %em_r2_7 = insertvalue %flux.result %em_r1_7, double 0.0, 2
  %em_r3_7 = insertvalue %flux.result %em_r2_7, i8* %t127, 3
  ret %flux.result %em_r3_7
route_end_3:
  %def_sta = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %def_msg = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %def_r0 = insertvalue %flux.result undef, i8* %def_sta, 0
  %def_r1 = insertvalue %flux.result %def_r0, i64 0, 1
  %def_r2 = insertvalue %flux.result %def_r1, double 0.0, 2
  %def_r3 = insertvalue %flux.result %def_r2, i8* %def_msg, 3
  ret %flux.result %def_r3
}

define %flux.result @uf_RuntimeStdLib__runtimeAllocatedMemory() {
fn_entry:
  %t1 = call i64 @flux_std_runtime_allocated_memory()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeHeapSize() {
fn_entry:
  %t1 = call i64 @flux_std_runtime_heap_size()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimePointerOf(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = call i64 @flux_std_runtime_pointer_of(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__allocatedMemory() {
fn_entry:
  %t1 = call i64 @flux_std_runtime_allocated_memory()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__heapSize() {
fn_entry:
  %t1 = call i64 @flux_std_runtime_heap_size()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__pointerOf(i64 %in_1) {
fn_entry:
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  store i64 %in_1, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_value, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_value__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t2 = call i64 @flux_std_runtime_pointer_of(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimePanic(i64 %in_1) {
fn_entry:
  %_v_message = alloca i64, align 8
  %_v_message__sta = alloca i8*, align 8
  %_v_message__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_message__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_message__msg, align 8
  store i64 %in_1, i64* %_v_message, align 8
  %t1_i64 = load i64, i64* %_v_message, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_message__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_message__msg, align 8
  %t2 = call i64 @flux_std_runtime_panic(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeTrap() {
fn_entry:
  %t1 = call i64 @flux_std_runtime_trap()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeSetPanicHook(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_agent_name = alloca i64, align 8
  %_v_agent_name__sta = alloca i8*, align 8
  %_v_agent_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_agent_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_agent_name__msg, align 8
  %_v_op_name = alloca i64, align 8
  %_v_op_name__sta = alloca i8*, align 8
  %_v_op_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_op_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_op_name__msg, align 8
  store i64 %in_1, i64* %_v_agent_name, align 8
  store i64 %in_2, i64* %_v_op_name, align 8
  %t1 = add i1 0, 1
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__runtimeStackTrace() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_stack_trace(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__panic(i64 %in_1) {
fn_entry:
  %_v_message = alloca i64, align 8
  %_v_message__sta = alloca i8*, align 8
  %_v_message__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_message__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_message__msg, align 8
  store i64 %in_1, i64* %_v_message, align 8
  %t1_i64 = load i64, i64* %_v_message, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_message__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_message__msg, align 8
  %t2 = call i64 @flux_std_runtime_panic(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__trap() {
fn_entry:
  %t1 = call i64 @flux_std_runtime_trap()
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__setPanicHook(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_agent_name = alloca i64, align 8
  %_v_agent_name__sta = alloca i8*, align 8
  %_v_agent_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_agent_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_agent_name__msg, align 8
  %_v_op_name = alloca i64, align 8
  %_v_op_name__sta = alloca i8*, align 8
  %_v_op_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_op_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_op_name__msg, align 8
  store i64 %in_1, i64* %_v_agent_name, align 8
  store i64 %in_2, i64* %_v_op_name, align 8
  %t1 = add i1 0, 1
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_RuntimeStdLib__stackTrace() {
fn_entry:
  %t1 = call i8* @flux_std_runtime_stack_trace(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t1 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define i32 @main(i32 %_sys_argc, i8** %_sys_argv) {
fn_entry:
  call void @flux_runtime_init_args(i32 %_sys_argc, i8** %_sys_argv)
  %_v_args = alloca i64, align 8
  %_v_args__sta = alloca i8*, align 8
  %_v_args__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_args__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_args__msg, align 8
  %_v_n_args = alloca i64, align 8
  %_v_n_args__sta = alloca i8*, align 8
  %_v_n_args__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_n_args__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_n_args__msg, align 8
  %_v_input_file = alloca i64, align 8
  %_v_input_file__sta = alloca i8*, align 8
  %_v_input_file__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_input_file__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_input_file__msg, align 8
  %_v_extra_args = alloca i64, align 8
  %_v_extra_args__sta = alloca i8*, align 8
  %_v_extra_args__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_extra_args__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_extra_args__msg, align 8
  %_v_target = alloca i64, align 8
  %_v_target__sta = alloca i8*, align 8
  %_v_target__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_target__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_target__msg, align 8
  %_v_output_path = alloca i64, align 8
  %_v_output_path__sta = alloca i8*, align 8
  %_v_output_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_output_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_output_path__msg, align 8
  %_v_flag_version = alloca i64, align 8
  %_v_flag_version__sta = alloca i8*, align 8
  %_v_flag_version__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_flag_version__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_flag_version__msg, align 8
  %_v_flag_no_run = alloca i64, align 8
  %_v_flag_no_run__sta = alloca i8*, align 8
  %_v_flag_no_run__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_flag_no_run__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_flag_no_run__msg, align 8
  %_v_flag_emit_ast = alloca i64, align 8
  %_v_flag_emit_ast__sta = alloca i8*, align 8
  %_v_flag_emit_ast__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_flag_emit_ast__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_flag_emit_ast__msg, align 8
  %_v_flag_emit_fmir = alloca i64, align 8
  %_v_flag_emit_fmir__sta = alloca i8*, align 8
  %_v_flag_emit_fmir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_flag_emit_fmir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_flag_emit_fmir__msg, align 8
  %_v_flag_emit_llvm = alloca i64, align 8
  %_v_flag_emit_llvm__sta = alloca i8*, align 8
  %_v_flag_emit_llvm__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_flag_emit_llvm__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_flag_emit_llvm__msg, align 8
  %_v_flag_emit_wat = alloca i64, align 8
  %_v_flag_emit_wat__sta = alloca i8*, align 8
  %_v_flag_emit_wat__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_flag_emit_wat__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_flag_emit_wat__msg, align 8
  %_v_explain_code = alloca i64, align 8
  %_v_explain_code__sta = alloca i8*, align 8
  %_v_explain_code__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_explain_code__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_explain_code__msg, align 8
  %_v_i = alloca i64, align 8
  %_v_i__sta = alloca i8*, align 8
  %_v_i__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_i__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_i__msg, align 8
  %_v_arg = alloca i64, align 8
  %_v_arg__sta = alloca i8*, align 8
  %_v_arg__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_arg__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_arg__msg, align 8
  %_v_stripping_ext = alloca i64, align 8
  %_v_stripping_ext__sta = alloca i8*, align 8
  %_v_stripping_ext__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_stripping_ext__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_stripping_ext__msg, align 8
  %_v_oplen = alloca i64, align 8
  %_v_oplen__sta = alloca i8*, align 8
  %_v_oplen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_oplen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_oplen__msg, align 8
  %_v_explanation = alloca i64, align 8
  %_v_explanation__sta = alloca i8*, align 8
  %_v_explanation__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_explanation__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_explanation__msg, align 8
  %_v_src_code = alloca i64, align 8
  %_v_src_code__sta = alloca i8*, align 8
  %_v_src_code__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_code__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_code__msg, align 8
  %_v_src_len = alloca i64, align 8
  %_v_src_len__sta = alloca i8*, align 8
  %_v_src_len__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_len__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_len__msg, align 8
  %_v_exp_err = alloca i64, align 8
  %_v_exp_err__sta = alloca i8*, align 8
  %_v_exp_err__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_exp_err__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_exp_err__msg, align 8
  %_v_exp_pref = alloca i64, align 8
  %_v_exp_pref__sta = alloca i8*, align 8
  %_v_exp_pref__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_exp_pref__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_exp_pref__msg, align 8
  %_v_slast = alloca i64, align 8
  %_v_slast__sta = alloca i8*, align 8
  %_v_slast__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_slast__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_slast__msg, align 8
  %_v_elen = alloca i64, align 8
  %_v_elen__sta = alloca i8*, align 8
  %_v_elen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_elen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_elen__msg, align 8
  %_v_c6 = alloca i64, align 8
  %_v_c6__sta = alloca i8*, align 8
  %_v_c6__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c6__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c6__msg, align 8
  %_v_err_hdr = alloca i64, align 8
  %_v_err_hdr__sta = alloca i8*, align 8
  %_v_err_hdr__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_err_hdr__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_err_hdr__msg, align 8
  %_v_err_hint = alloca i64, align 8
  %_v_err_hint__sta = alloca i8*, align 8
  %_v_err_hint__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_err_hint__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_err_hint__msg, align 8
  %_v_in_len = alloca i64, align 8
  %_v_in_len__sta = alloca i8*, align 8
  %_v_in_len__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_in_len__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_in_len__msg, align 8
  %_v_is_compliance = alloca i64, align 8
  %_v_is_compliance__sta = alloca i8*, align 8
  %_v_is_compliance__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_is_compliance__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_is_compliance__msg, align 8
  %_v_ck = alloca i64, align 8
  %_v_ck__sta = alloca i8*, align 8
  %_v_ck__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ck__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ck__msg, align 8
  %_v_is_exemplos = alloca i64, align 8
  %_v_is_exemplos__sta = alloca i8*, align 8
  %_v_is_exemplos__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_is_exemplos__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_is_exemplos__msg, align 8
  %_v_ek = alloca i64, align 8
  %_v_ek__sta = alloca i8*, align 8
  %_v_ek__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ek__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ek__msg, align 8
  %_v_arg_suffix = alloca i64, align 8
  %_v_arg_suffix__sta = alloca i8*, align 8
  %_v_arg_suffix__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_arg_suffix__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_arg_suffix__msg, align 8
  %_v_bi = alloca i64, align 8
  %_v_bi__sta = alloca i8*, align 8
  %_v_bi__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_bi__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_bi__msg, align 8
  %_v_rc = alloca i64, align 8
  %_v_rc__sta = alloca i8*, align 8
  %_v_rc__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_rc__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_rc__msg, align 8
  %_v_ex_names = alloca i64, align 8
  %_v_ex_names__sta = alloca i8*, align 8
  %_v_ex_names__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ex_names__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ex_names__msg, align 8
  %_v_eni = alloca i64, align 8
  %_v_eni__sta = alloca i8*, align 8
  %_v_eni__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_eni__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_eni__msg, align 8
  %_v_enm = alloca i64, align 8
  %_v_enm__sta = alloca i8*, align 8
  %_v_enm__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_enm__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_enm__msg, align 8
  %_v_enmlen = alloca i64, align 8
  %_v_enmlen__sta = alloca i8*, align 8
  %_v_enmlen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_enmlen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_enmlen__msg, align 8
  %_v_ebi = alloca i64, align 8
  %_v_ebi__sta = alloca i8*, align 8
  %_v_ebi__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ebi__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ebi__msg, align 8
  %_v_bin_name = alloca i64, align 8
  %_v_bin_name__sta = alloca i8*, align 8
  %_v_bin_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_bin_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_bin_name__msg, align 8
  %_v_vmr_res = alloca i64, align 8
  %_v_vmr_res__sta = alloca i8*, align 8
  %_v_vmr_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_vmr_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_vmr_res__msg, align 8
  %_v_parse_res = alloca i64, align 8
  %_v_parse_res__sta = alloca i8*, align 8
  %_v_parse_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_parse_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_parse_res__msg, align 8
  %_v_arena = alloca i64, align 8
  %_v_arena__sta = alloca i8*, align 8
  %_v_arena__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_arena__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_arena__msg, align 8
  %_v_root_id = alloca i64, align 8
  %_v_root_id__sta = alloca i8*, align 8
  %_v_root_id__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_root_id__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_root_id__msg, align 8
  %_v_ast_json = alloca i64, align 8
  %_v_ast_json__sta = alloca i8*, align 8
  %_v_ast_json__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ast_json__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ast_json__msg, align 8
  %_v_sem_report = alloca i64, align 8
  %_v_sem_report__sta = alloca i8*, align 8
  %_v_sem_report__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_sem_report__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_sem_report__msg, align 8
  %_v_errors = alloca i64, align 8
  %_v_errors__sta = alloca i8*, align 8
  %_v_errors__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_errors__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_errors__msg, align 8
  %_v_n_err = alloca i64, align 8
  %_v_n_err__sta = alloca i8*, align 8
  %_v_n_err__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_n_err__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_n_err__msg, align 8
  %_v_ei = alloca i64, align 8
  %_v_ei__sta = alloca i8*, align 8
  %_v_ei__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ei__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ei__msg, align 8
  %_v_fmir_mod = alloca i64, align 8
  %_v_fmir_mod__sta = alloca i8*, align 8
  %_v_fmir_mod__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_fmir_mod__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_fmir_mod__msg, align 8
  %_v_fmir_dump = alloca i64, align 8
  %_v_fmir_dump__sta = alloca i8*, align 8
  %_v_fmir_dump__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_fmir_dump__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_fmir_dump__msg, align 8
  %_v_wat_res = alloca i64, align 8
  %_v_wat_res__sta = alloca i8*, align 8
  %_v_wat_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_wat_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_wat_res__msg, align 8
  %_v_options = alloca i64, align 8
  %_v_options__sta = alloca i8*, align 8
  %_v_options__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_options__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_options__msg, align 8
  %_v_comp_res = alloca i64, align 8
  %_v_comp_res__sta = alloca i8*, align 8
  %_v_comp_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_comp_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_comp_res__msg, align 8
  %_v_clang_cmd = alloca i64, align 8
  %_v_clang_cmd__sta = alloca i8*, align 8
  %_v_clang_cmd__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_clang_cmd__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_clang_cmd__msg, align 8
  %_v_cl_rc = alloca i64, align 8
  %_v_cl_rc__sta = alloca i8*, align 8
  %_v_cl_rc__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_cl_rc__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_cl_rc__msg, align 8
  %_v_r_rc = alloca i64, align 8
  %_v_r_rc__sta = alloca i8*, align 8
  %_v_r_rc__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_r_rc__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_r_rc__msg, align 8
  %t1 = call i8* @flux_std_runtime_get_args(i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_args, align 8
  %t2_i64 = load i64, i64* %_v_args, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_args__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_args__msg, align 8
  %t3 = call i64 @flux_list_len(i8* %t2)
  store i64 %t3, i64* %_v_n_args, align 8
  %t6 = load i64, i64* %_v_n_args, align 8
  %t6_vsta = load i8*, i8** %_v_n_args__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_n_args__msg, align 8
  %t7 = add i64 0, 1
  %t8 = icmp slt i64 %t6, %t7
  br i1 %t8, label %ft_0, label %route_arm_5
ft_0:
  %t9 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.40, i32 0, i32 0
  %pr_sn_1 = icmp eq i8* %t9, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t9
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  %t10 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.41, i32 0, i32 0
  %pr_sn_2 = icmp eq i8* %t10, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t10
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  %t11 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.42, i32 0, i32 0
  %pr_sn_3 = icmp eq i8* %t11, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t11
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  %t12 = getelementptr inbounds [55 x i8], [55 x i8]* @.str.43, i32 0, i32 0
  %pr_sn_4 = icmp eq i8* %t12, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t12
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  %t13 = getelementptr inbounds [76 x i8], [76 x i8]* @.str.44, i32 0, i32 0
  %pr_sn_5 = icmp eq i8* %t13, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t13
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  %t14 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.45, i32 0, i32 0
  %pr_sn_6 = icmp eq i8* %t14, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t14
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  %t15 = getelementptr inbounds [44 x i8], [44 x i8]* @.str.46, i32 0, i32 0
  %pr_sn_7 = icmp eq i8* %t15, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t15
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  %t16 = getelementptr inbounds [43 x i8], [43 x i8]* @.str.47, i32 0, i32 0
  %pr_sn_8 = icmp eq i8* %t16, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t16
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  %t17 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.48, i32 0, i32 0
  %pr_sn_9 = icmp eq i8* %t17, null
  %pr_sc_9 = select i1 %pr_sn_9, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t17
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_9)
  call i32 @fflush(i8* null)
  %t18 = getelementptr inbounds [59 x i8], [59 x i8]* @.str.49, i32 0, i32 0
  %pr_sn_10 = icmp eq i8* %t18, null
  %pr_sc_10 = select i1 %pr_sn_10, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t18
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_10)
  call i32 @fflush(i8* null)
  %t19 = getelementptr inbounds [54 x i8], [54 x i8]* @.str.50, i32 0, i32 0
  %pr_sn_11 = icmp eq i8* %t19, null
  %pr_sc_11 = select i1 %pr_sn_11, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t19
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_11)
  call i32 @fflush(i8* null)
  br label %route_end_4
route_arm_5:
  %t21 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_3 = ptrtoint i8* %t21 to i64
  store i64 %st_3, i64* %_v_input_file, align 8
  %t22 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_4 = ptrtoint i8* %t22 to i64
  store i64 %st_4, i64* %_v_extra_args, align 8
  %t23 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.18, i32 0, i32 0
  %st_5 = ptrtoint i8* %t23 to i64
  store i64 %st_5, i64* %_v_target, align 8
  %t24 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.51, i32 0, i32 0
  %st_6 = ptrtoint i8* %t24 to i64
  store i64 %st_6, i64* %_v_output_path, align 8
  %t25 = add i1 0, 0
  %st_b_7 = zext i1 %t25 to i64
  store i64 %st_b_7, i64* %_v_flag_version, align 8
  %t26 = add i1 0, 0
  %st_b_8 = zext i1 %t26 to i64
  store i64 %st_b_8, i64* %_v_flag_no_run, align 8
  %t27 = add i1 0, 0
  %st_b_9 = zext i1 %t27 to i64
  store i64 %st_b_9, i64* %_v_flag_emit_ast, align 8
  %t28 = add i1 0, 0
  %st_b_10 = zext i1 %t28 to i64
  store i64 %st_b_10, i64* %_v_flag_emit_fmir, align 8
  %t29 = add i1 0, 0
  %st_b_11 = zext i1 %t29 to i64
  store i64 %st_b_11, i64* %_v_flag_emit_llvm, align 8
  %t30 = add i1 0, 0
  %st_b_12 = zext i1 %t30 to i64
  store i64 %st_b_12, i64* %_v_flag_emit_wat, align 8
  %t31 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_13 = ptrtoint i8* %t31 to i64
  store i64 %st_13, i64* %_v_explain_code, align 8
  %t32 = add i64 0, 1
  store i64 %t32, i64* %_v_i, align 8
  br label %loop_start_33
loop_start_33:
  %t36 = load i64, i64* %_v_i, align 8
  %t36_vsta = load i8*, i8** %_v_i__sta, align 8
  %t36_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t37 = load i64, i64* %_v_n_args, align 8
  %t37_vsta = load i8*, i8** %_v_n_args__sta, align 8
  %t37_vmsg = load i8*, i8** %_v_n_args__msg, align 8
  %t38 = icmp sgt i64 %t36, %t37
  br i1 %t38, label %ft_1, label %route_arm_35
ft_1:
  br label %loop_end_33
route_arm_35:
  %t40 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t41_i64 = load i64, i64* %_v_args, align 8
  %t41 = inttoptr i64 %t41_i64 to i8*
  %t41_vsta = load i8*, i8** %_v_args__sta, align 8
  %t41_vmsg = load i8*, i8** %_v_args__msg, align 8
  %t42 = load i64, i64* %_v_i, align 8
  %t42_vsta = load i8*, i8** %_v_i__sta, align 8
  %t42_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t43_raw = call i64 @flux_list_get_val(i8* %t41, i64 %t42)
  %t43 = inttoptr i64 %t43_raw to i8*
  %cv_raw_1 = ptrtoint i8* %t43 to i64
  %cv_buf_1 = call i8* @flux_val_to_str(i64 %cv_raw_1)
  %t44 = call i8* @flux_str_concat(i8* %t40, i8* %cv_buf_1)
  %st_15 = ptrtoint i8* %t44 to i64
  store i64 %st_15, i64* %_v_arg, align 8
  %t47_i64 = load i64, i64* %_v_arg, align 8
  %t47 = inttoptr i64 %t47_i64 to i8*
  %t47_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t47_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t48 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.52, i32 0, i32 0
  %t49_cmp = call i32 @flux_str_compare(i8* %t47, i8* %t48)
  %t49 = icmp eq i32 %t49_cmp, 0
  %t50_i64 = load i64, i64* %_v_arg, align 8
  %t50 = inttoptr i64 %t50_i64 to i8*
  %t50_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t50_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t51 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.53, i32 0, i32 0
  %t52_cmp = call i32 @flux_str_compare(i8* %t50, i8* %t51)
  %t52 = icmp eq i32 %t52_cmp, 0
  %t53 = or i1 %t49, %t52
  br i1 %t53, label %ft_2, label %route_arm_46
ft_2:
  %t54 = add i1 0, 1
  %st_b_16 = zext i1 %t54 to i64
  store i64 %st_b_16, i64* %_v_flag_version, align 8
  br label %route_end_45
route_arm_46:
  %t56_i64 = load i64, i64* %_v_arg, align 8
  %t56 = inttoptr i64 %t56_i64 to i8*
  %t56_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t56_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t57 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.54, i32 0, i32 0
  %t58_cmp = call i32 @flux_str_compare(i8* %t56, i8* %t57)
  %t58 = icmp eq i32 %t58_cmp, 0
  br i1 %t58, label %ft_3, label %route_arm_55
ft_3:
  %t59 = load i64, i64* %_v_i, align 8
  %t59_vsta = load i8*, i8** %_v_i__sta, align 8
  %t59_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t60 = add i64 0, 1
  %t61 = add i64 %t59, %t60
  store i64 %t61, i64* %_v_i, align 8
  %t64 = load i64, i64* %_v_i, align 8
  %t64_vsta = load i8*, i8** %_v_i__sta, align 8
  %t64_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t65 = load i64, i64* %_v_n_args, align 8
  %t65_vsta = load i8*, i8** %_v_n_args__sta, align 8
  %t65_vmsg = load i8*, i8** %_v_n_args__msg, align 8
  %t66 = icmp sle i64 %t64, %t65
  br i1 %t66, label %ft_4, label %route_arm_63
ft_4:
  %t67 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t68_i64 = load i64, i64* %_v_args, align 8
  %t68 = inttoptr i64 %t68_i64 to i8*
  %t68_vsta = load i8*, i8** %_v_args__sta, align 8
  %t68_vmsg = load i8*, i8** %_v_args__msg, align 8
  %t69 = load i64, i64* %_v_i, align 8
  %t69_vsta = load i8*, i8** %_v_i__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t70_raw = call i64 @flux_list_get_val(i8* %t68, i64 %t69)
  %t70 = inttoptr i64 %t70_raw to i8*
  %cv_raw_2 = ptrtoint i8* %t70 to i64
  %cv_buf_2 = call i8* @flux_val_to_str(i64 %cv_raw_2)
  %t71 = call i8* @flux_str_concat(i8* %t67, i8* %cv_buf_2)
  %st_18 = ptrtoint i8* %t71 to i64
  store i64 %st_18, i64* %_v_target, align 8
  br label %route_end_62
route_arm_63:
  br label %route_end_62
route_end_62:
  br label %route_end_45
route_arm_55:
  %t74_i64 = load i64, i64* %_v_arg, align 8
  %t74 = inttoptr i64 %t74_i64 to i8*
  %t74_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t74_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t75 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.55, i32 0, i32 0
  %t76_cmp = call i32 @flux_str_compare(i8* %t74, i8* %t75)
  %t76 = icmp eq i32 %t76_cmp, 0
  %t77_i64 = load i64, i64* %_v_arg, align 8
  %t77 = inttoptr i64 %t77_i64 to i8*
  %t77_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t77_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t78 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.56, i32 0, i32 0
  %t79_cmp = call i32 @flux_str_compare(i8* %t77, i8* %t78)
  %t79 = icmp eq i32 %t79_cmp, 0
  %t80 = or i1 %t76, %t79
  br i1 %t80, label %ft_5, label %route_arm_73
ft_5:
  %t81 = load i64, i64* %_v_i, align 8
  %t81_vsta = load i8*, i8** %_v_i__sta, align 8
  %t81_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t82 = add i64 0, 1
  %t83 = add i64 %t81, %t82
  store i64 %t83, i64* %_v_i, align 8
  %t86 = load i64, i64* %_v_i, align 8
  %t86_vsta = load i8*, i8** %_v_i__sta, align 8
  %t86_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t87 = load i64, i64* %_v_n_args, align 8
  %t87_vsta = load i8*, i8** %_v_n_args__sta, align 8
  %t87_vmsg = load i8*, i8** %_v_n_args__msg, align 8
  %t88 = icmp sle i64 %t86, %t87
  br i1 %t88, label %ft_6, label %route_arm_85
ft_6:
  %t89 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t90_i64 = load i64, i64* %_v_args, align 8
  %t90 = inttoptr i64 %t90_i64 to i8*
  %t90_vsta = load i8*, i8** %_v_args__sta, align 8
  %t90_vmsg = load i8*, i8** %_v_args__msg, align 8
  %t91 = load i64, i64* %_v_i, align 8
  %t91_vsta = load i8*, i8** %_v_i__sta, align 8
  %t91_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t92_raw = call i64 @flux_list_get_val(i8* %t90, i64 %t91)
  %t92 = inttoptr i64 %t92_raw to i8*
  %cv_raw_3 = ptrtoint i8* %t92 to i64
  %cv_buf_3 = call i8* @flux_val_to_str(i64 %cv_raw_3)
  %t93 = call i8* @flux_str_concat(i8* %t89, i8* %cv_buf_3)
  %st_20 = ptrtoint i8* %t93 to i64
  store i64 %st_20, i64* %_v_output_path, align 8
  br label %route_end_84
route_arm_85:
  br label %route_end_84
route_end_84:
  br label %route_end_45
route_arm_73:
  %t96_i64 = load i64, i64* %_v_arg, align 8
  %t96 = inttoptr i64 %t96_i64 to i8*
  %t96_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t96_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t97 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.57, i32 0, i32 0
  %t98_cmp = call i32 @flux_str_compare(i8* %t96, i8* %t97)
  %t98 = icmp eq i32 %t98_cmp, 0
  br i1 %t98, label %ft_7, label %route_arm_95
ft_7:
  %t99 = add i1 0, 1
  %st_b_21 = zext i1 %t99 to i64
  store i64 %st_b_21, i64* %_v_flag_emit_ast, align 8
  br label %route_end_45
route_arm_95:
  %t101_i64 = load i64, i64* %_v_arg, align 8
  %t101 = inttoptr i64 %t101_i64 to i8*
  %t101_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t101_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t102 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.58, i32 0, i32 0
  %t103_cmp = call i32 @flux_str_compare(i8* %t101, i8* %t102)
  %t103 = icmp eq i32 %t103_cmp, 0
  br i1 %t103, label %ft_8, label %route_arm_100
ft_8:
  %t104 = add i1 0, 1
  %st_b_22 = zext i1 %t104 to i64
  store i64 %st_b_22, i64* %_v_flag_emit_fmir, align 8
  br label %route_end_45
route_arm_100:
  %t106_i64 = load i64, i64* %_v_arg, align 8
  %t106 = inttoptr i64 %t106_i64 to i8*
  %t106_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t106_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t107 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.59, i32 0, i32 0
  %t108_cmp = call i32 @flux_str_compare(i8* %t106, i8* %t107)
  %t108 = icmp eq i32 %t108_cmp, 0
  br i1 %t108, label %ft_9, label %route_arm_105
ft_9:
  %t109 = add i1 0, 1
  %st_b_23 = zext i1 %t109 to i64
  store i64 %st_b_23, i64* %_v_flag_emit_llvm, align 8
  br label %route_end_45
route_arm_105:
  %t111_i64 = load i64, i64* %_v_arg, align 8
  %t111 = inttoptr i64 %t111_i64 to i8*
  %t111_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t111_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t112 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.60, i32 0, i32 0
  %t113_cmp = call i32 @flux_str_compare(i8* %t111, i8* %t112)
  %t113 = icmp eq i32 %t113_cmp, 0
  br i1 %t113, label %ft_10, label %route_arm_110
ft_10:
  %t114 = add i1 0, 1
  %st_b_24 = zext i1 %t114 to i64
  store i64 %st_b_24, i64* %_v_flag_emit_wat, align 8
  br label %route_end_45
route_arm_110:
  %t116_i64 = load i64, i64* %_v_arg, align 8
  %t116 = inttoptr i64 %t116_i64 to i8*
  %t116_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t116_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t117 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.61, i32 0, i32 0
  %t118_cmp = call i32 @flux_str_compare(i8* %t116, i8* %t117)
  %t118 = icmp eq i32 %t118_cmp, 0
  br i1 %t118, label %ft_11, label %route_arm_115
ft_11:
  %t119 = add i1 0, 1
  %st_b_25 = zext i1 %t119 to i64
  store i64 %st_b_25, i64* %_v_flag_no_run, align 8
  br label %route_end_45
route_arm_115:
  %t121_i64 = load i64, i64* %_v_arg, align 8
  %t121 = inttoptr i64 %t121_i64 to i8*
  %t121_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t121_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t122 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.62, i32 0, i32 0
  %t123_cmp = call i32 @flux_str_compare(i8* %t121, i8* %t122)
  %t123 = icmp eq i32 %t123_cmp, 0
  br i1 %t123, label %ft_12, label %route_arm_120
ft_12:
  %t124 = load i64, i64* %_v_i, align 8
  %t124_vsta = load i8*, i8** %_v_i__sta, align 8
  %t124_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t125 = add i64 0, 1
  %t126 = add i64 %t124, %t125
  store i64 %t126, i64* %_v_i, align 8
  %t129 = load i64, i64* %_v_i, align 8
  %t129_vsta = load i8*, i8** %_v_i__sta, align 8
  %t129_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t130 = load i64, i64* %_v_n_args, align 8
  %t130_vsta = load i8*, i8** %_v_n_args__sta, align 8
  %t130_vmsg = load i8*, i8** %_v_n_args__msg, align 8
  %t131 = icmp sle i64 %t129, %t130
  br i1 %t131, label %ft_13, label %route_arm_128
ft_13:
  %t132 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t133_i64 = load i64, i64* %_v_args, align 8
  %t133 = inttoptr i64 %t133_i64 to i8*
  %t133_vsta = load i8*, i8** %_v_args__sta, align 8
  %t133_vmsg = load i8*, i8** %_v_args__msg, align 8
  %t134 = load i64, i64* %_v_i, align 8
  %t134_vsta = load i8*, i8** %_v_i__sta, align 8
  %t134_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t135_raw = call i64 @flux_list_get_val(i8* %t133, i64 %t134)
  %t135 = inttoptr i64 %t135_raw to i8*
  %cv_raw_4 = ptrtoint i8* %t135 to i64
  %cv_buf_4 = call i8* @flux_val_to_str(i64 %cv_raw_4)
  %t136 = call i8* @flux_str_concat(i8* %t132, i8* %cv_buf_4)
  %st_27 = ptrtoint i8* %t136 to i64
  store i64 %st_27, i64* %_v_explain_code, align 8
  br label %route_end_127
route_arm_128:
  br label %route_end_127
route_end_127:
  br label %route_end_45
route_arm_120:
  %t139_i64 = load i64, i64* %_v_input_file, align 8
  %t139 = inttoptr i64 %t139_i64 to i8*
  %t139_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t139_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t140 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t141_cmp = call i32 @flux_str_compare(i8* %t139, i8* %t140)
  %t141 = icmp ne i32 %t141_cmp, 0
  br i1 %t141, label %ft_14, label %route_arm_138
ft_14:
  %t144_i64 = load i64, i64* %_v_extra_args, align 8
  %t144 = inttoptr i64 %t144_i64 to i8*
  %t144_vsta = load i8*, i8** %_v_extra_args__sta, align 8
  %t144_vmsg = load i8*, i8** %_v_extra_args__msg, align 8
  %t145 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t146_cmp = call i32 @flux_str_compare(i8* %t144, i8* %t145)
  %t146 = icmp eq i32 %t146_cmp, 0
  br i1 %t146, label %ft_15, label %route_arm_143
ft_15:
  %t147 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.63, i32 0, i32 0
  %t148_i64 = load i64, i64* %_v_arg, align 8
  %t148 = inttoptr i64 %t148_i64 to i8*
  %t148_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t148_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t149 = call i8* @flux_str_concat(i8* %t147, i8* %t148)
  %t150 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.63, i32 0, i32 0
  %t151 = call i8* @flux_str_concat(i8* %t149, i8* %t150)
  %st_28 = ptrtoint i8* %t151 to i64
  store i64 %st_28, i64* %_v_extra_args, align 8
  br label %route_end_142
route_arm_143:
  %t153_i64 = load i64, i64* %_v_extra_args, align 8
  %t153 = inttoptr i64 %t153_i64 to i8*
  %t153_vsta = load i8*, i8** %_v_extra_args__sta, align 8
  %t153_vmsg = load i8*, i8** %_v_extra_args__msg, align 8
  %t154 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.64, i32 0, i32 0
  %t155 = call i8* @flux_str_concat(i8* %t153, i8* %t154)
  %t156_i64 = load i64, i64* %_v_arg, align 8
  %t156 = inttoptr i64 %t156_i64 to i8*
  %t156_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t156_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t157 = call i8* @flux_str_concat(i8* %t155, i8* %t156)
  %t158 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.63, i32 0, i32 0
  %t159 = call i8* @flux_str_concat(i8* %t157, i8* %t158)
  %st_29 = ptrtoint i8* %t159 to i64
  store i64 %st_29, i64* %_v_extra_args, align 8
  br label %route_end_142
route_end_142:
  br label %route_end_45
route_arm_138:
  %t161_i64 = load i64, i64* %_v_arg, align 8
  %t161 = inttoptr i64 %t161_i64 to i8*
  %t161_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t161_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t162 = call i64 @flux_str_len(i8* %t161)
  %t163 = add i64 0, 0
  %t164 = icmp sgt i64 %t162, %t163
  %t165_i64 = load i64, i64* %_v_arg, align 8
  %t165 = inttoptr i64 %t165_i64 to i8*
  %t165_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t165_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %t166 = add i64 0, 1
  %t167 = call i8* @flux_str_slice(i8* %t165, i64 %t166, i64 %t166)
  %t168 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.65, i32 0, i32 0
  %t169_cmp = call i32 @flux_str_compare(i8* %t167, i8* %t168)
  %t169 = icmp eq i32 %t169_cmp, 0
  %t170 = and i1 %t164, %t169
  br i1 %t170, label %ft_16, label %route_arm_160
ft_16:
  br label %route_end_45
route_arm_160:
  %t172_i64 = load i64, i64* %_v_arg, align 8
  %t172 = inttoptr i64 %t172_i64 to i8*
  %t172_vsta = load i8*, i8** %_v_arg__sta, align 8
  %t172_vmsg = load i8*, i8** %_v_arg__msg, align 8
  %st_30 = ptrtoint i8* %t172 to i64
  store i64 %st_30, i64* %_v_input_file, align 8
  store i8* %t172_vsta, i8** %_v_input_file__sta, align 8
  store i8* %t172_vmsg, i8** %_v_input_file__msg, align 8
  br label %route_end_45
route_end_45:
  %t173 = load i64, i64* %_v_i, align 8
  %t173_vsta = load i8*, i8** %_v_i__sta, align 8
  %t173_vmsg = load i8*, i8** %_v_i__msg, align 8
  %t174 = add i64 0, 1
  %t175 = add i64 %t173, %t174
  store i64 %t175, i64* %_v_i, align 8
  br label %route_end_34
route_end_34:
  br label %loop_start_33
loop_end_33:
  %t176 = add i1 0, 1
  %st_b_32 = zext i1 %t176 to i64
  store i64 %st_b_32, i64* %_v_stripping_ext, align 8
  br label %loop_start_177
loop_start_177:
  %t180_i64 = load i64, i64* %_v_stripping_ext, align 8
  %t180 = trunc i64 %t180_i64 to i1
  %t180_vsta = load i8*, i8** %_v_stripping_ext__sta, align 8
  %t180_vmsg = load i8*, i8** %_v_stripping_ext__msg, align 8
  %t181 = xor i1 %t180, 1
  br i1 %t181, label %ft_17, label %route_arm_179
ft_17:
  br label %loop_end_177
route_arm_179:
  %t183_i64 = load i64, i64* %_v_output_path, align 8
  %t183 = inttoptr i64 %t183_i64 to i8*
  %t183_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t183_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t184 = call i64 @flux_str_len(i8* %t183)
  store i64 %t184, i64* %_v_oplen, align 8
  %t187 = load i64, i64* %_v_oplen, align 8
  %t187_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t187_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t188 = add i64 0, 4
  %t189 = icmp sgt i64 %t187, %t188
  %t190_i64 = load i64, i64* %_v_output_path, align 8
  %t190 = inttoptr i64 %t190_i64 to i8*
  %t190_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t190_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t191 = load i64, i64* %_v_oplen, align 8
  %t191_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t191_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t192 = add i64 0, 3
  %t193 = sub i64 %t191, %t192
  %t194 = load i64, i64* %_v_oplen, align 8
  %t194_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t194_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t195 = call i8* @flux_str_slice(i8* %t190, i64 %t193, i64 %t194)
  %t196 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.66, i32 0, i32 0
  %t197_cmp = call i32 @flux_str_compare(i8* %t195, i8* %t196)
  %t197 = icmp eq i32 %t197_cmp, 0
  %t198_i64 = load i64, i64* %_v_output_path, align 8
  %t198 = inttoptr i64 %t198_i64 to i8*
  %t198_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t198_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t199 = load i64, i64* %_v_oplen, align 8
  %t199_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t199_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t200 = add i64 0, 3
  %t201 = sub i64 %t199, %t200
  %t202 = load i64, i64* %_v_oplen, align 8
  %t202_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t202_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t203 = call i8* @flux_str_slice(i8* %t198, i64 %t201, i64 %t202)
  %t204 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.67, i32 0, i32 0
  %t205_cmp = call i32 @flux_str_compare(i8* %t203, i8* %t204)
  %t205 = icmp eq i32 %t205_cmp, 0
  %t206 = or i1 %t197, %t205
  %t207 = and i1 %t189, %t206
  br i1 %t207, label %ft_18, label %route_arm_186
ft_18:
  %t208_i64 = load i64, i64* %_v_output_path, align 8
  %t208 = inttoptr i64 %t208_i64 to i8*
  %t208_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t208_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t209 = add i64 0, 1
  %t210 = load i64, i64* %_v_oplen, align 8
  %t210_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t210_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t211 = add i64 0, 4
  %t212 = sub i64 %t210, %t211
  %t213 = call i8* @flux_str_slice(i8* %t208, i64 %t209, i64 %t212)
  %st_34 = ptrtoint i8* %t213 to i64
  store i64 %st_34, i64* %_v_output_path, align 8
  br label %route_end_185
route_arm_186:
  %t215 = load i64, i64* %_v_oplen, align 8
  %t215_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t215_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t216 = add i64 0, 3
  %t217 = icmp sgt i64 %t215, %t216
  %t218_i64 = load i64, i64* %_v_output_path, align 8
  %t218 = inttoptr i64 %t218_i64 to i8*
  %t218_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t218_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t219 = load i64, i64* %_v_oplen, align 8
  %t219_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t219_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t220 = add i64 0, 2
  %t221 = sub i64 %t219, %t220
  %t222 = load i64, i64* %_v_oplen, align 8
  %t222_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t222_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t223 = call i8* @flux_str_slice(i8* %t218, i64 %t221, i64 %t222)
  %t224 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.68, i32 0, i32 0
  %t225_cmp = call i32 @flux_str_compare(i8* %t223, i8* %t224)
  %t225 = icmp eq i32 %t225_cmp, 0
  %t226_i64 = load i64, i64* %_v_output_path, align 8
  %t226 = inttoptr i64 %t226_i64 to i8*
  %t226_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t226_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t227 = load i64, i64* %_v_oplen, align 8
  %t227_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t227_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t228 = add i64 0, 2
  %t229 = sub i64 %t227, %t228
  %t230 = load i64, i64* %_v_oplen, align 8
  %t230_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t230_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t231 = call i8* @flux_str_slice(i8* %t226, i64 %t229, i64 %t230)
  %t232 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.69, i32 0, i32 0
  %t233_cmp = call i32 @flux_str_compare(i8* %t231, i8* %t232)
  %t233 = icmp eq i32 %t233_cmp, 0
  %t234 = or i1 %t225, %t233
  %t235 = and i1 %t217, %t234
  br i1 %t235, label %ft_19, label %route_arm_214
ft_19:
  %t236_i64 = load i64, i64* %_v_output_path, align 8
  %t236 = inttoptr i64 %t236_i64 to i8*
  %t236_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t236_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t237 = add i64 0, 1
  %t238 = load i64, i64* %_v_oplen, align 8
  %t238_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t238_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t239 = add i64 0, 3
  %t240 = sub i64 %t238, %t239
  %t241 = call i8* @flux_str_slice(i8* %t236, i64 %t237, i64 %t240)
  %st_35 = ptrtoint i8* %t241 to i64
  store i64 %st_35, i64* %_v_output_path, align 8
  br label %route_end_185
route_arm_214:
  %t243 = load i64, i64* %_v_oplen, align 8
  %t243_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t243_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t244 = add i64 0, 6
  %t245 = icmp sgt i64 %t243, %t244
  %t246_i64 = load i64, i64* %_v_output_path, align 8
  %t246 = inttoptr i64 %t246_i64 to i8*
  %t246_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t246_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t247 = load i64, i64* %_v_oplen, align 8
  %t247_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t247_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t248 = add i64 0, 5
  %t249 = sub i64 %t247, %t248
  %t250 = load i64, i64* %_v_oplen, align 8
  %t250_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t250_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t251 = call i8* @flux_str_slice(i8* %t246, i64 %t249, i64 %t250)
  %t252 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.70, i32 0, i32 0
  %t253_cmp = call i32 @flux_str_compare(i8* %t251, i8* %t252)
  %t253 = icmp eq i32 %t253_cmp, 0
  %t254_i64 = load i64, i64* %_v_output_path, align 8
  %t254 = inttoptr i64 %t254_i64 to i8*
  %t254_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t254_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t255 = load i64, i64* %_v_oplen, align 8
  %t255_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t255_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t256 = add i64 0, 5
  %t257 = sub i64 %t255, %t256
  %t258 = load i64, i64* %_v_oplen, align 8
  %t258_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t258_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t259 = call i8* @flux_str_slice(i8* %t254, i64 %t257, i64 %t258)
  %t260 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.71, i32 0, i32 0
  %t261_cmp = call i32 @flux_str_compare(i8* %t259, i8* %t260)
  %t261 = icmp eq i32 %t261_cmp, 0
  %t262 = or i1 %t253, %t261
  %t263 = and i1 %t245, %t262
  br i1 %t263, label %ft_20, label %route_arm_242
ft_20:
  %t264_i64 = load i64, i64* %_v_output_path, align 8
  %t264 = inttoptr i64 %t264_i64 to i8*
  %t264_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t264_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t265 = add i64 0, 1
  %t266 = load i64, i64* %_v_oplen, align 8
  %t266_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t266_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t267 = add i64 0, 6
  %t268 = sub i64 %t266, %t267
  %t269 = call i8* @flux_str_slice(i8* %t264, i64 %t265, i64 %t268)
  %st_36 = ptrtoint i8* %t269 to i64
  store i64 %st_36, i64* %_v_output_path, align 8
  br label %route_end_185
route_arm_242:
  %t271 = load i64, i64* %_v_oplen, align 8
  %t271_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t271_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t272 = add i64 0, 4
  %t273 = icmp sgt i64 %t271, %t272
  %t274_i64 = load i64, i64* %_v_output_path, align 8
  %t274 = inttoptr i64 %t274_i64 to i8*
  %t274_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t274_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t275 = load i64, i64* %_v_oplen, align 8
  %t275_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t275_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t276 = add i64 0, 3
  %t277 = sub i64 %t275, %t276
  %t278 = load i64, i64* %_v_oplen, align 8
  %t278_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t278_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t279 = call i8* @flux_str_slice(i8* %t274, i64 %t277, i64 %t278)
  %t280 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.72, i32 0, i32 0
  %t281_cmp = call i32 @flux_str_compare(i8* %t279, i8* %t280)
  %t281 = icmp eq i32 %t281_cmp, 0
  %t282_i64 = load i64, i64* %_v_output_path, align 8
  %t282 = inttoptr i64 %t282_i64 to i8*
  %t282_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t282_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t283 = load i64, i64* %_v_oplen, align 8
  %t283_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t283_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t284 = add i64 0, 3
  %t285 = sub i64 %t283, %t284
  %t286 = load i64, i64* %_v_oplen, align 8
  %t286_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t286_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t287 = call i8* @flux_str_slice(i8* %t282, i64 %t285, i64 %t286)
  %t288 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.73, i32 0, i32 0
  %t289_cmp = call i32 @flux_str_compare(i8* %t287, i8* %t288)
  %t289 = icmp eq i32 %t289_cmp, 0
  %t290 = or i1 %t281, %t289
  %t291 = and i1 %t273, %t290
  br i1 %t291, label %ft_21, label %route_arm_270
ft_21:
  %t292_i64 = load i64, i64* %_v_output_path, align 8
  %t292 = inttoptr i64 %t292_i64 to i8*
  %t292_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t292_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t293 = add i64 0, 1
  %t294 = load i64, i64* %_v_oplen, align 8
  %t294_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t294_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t295 = add i64 0, 4
  %t296 = sub i64 %t294, %t295
  %t297 = call i8* @flux_str_slice(i8* %t292, i64 %t293, i64 %t296)
  %st_37 = ptrtoint i8* %t297 to i64
  store i64 %st_37, i64* %_v_output_path, align 8
  br label %route_end_185
route_arm_270:
  %t299 = load i64, i64* %_v_oplen, align 8
  %t299_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t299_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t300 = add i64 0, 5
  %t301 = icmp sgt i64 %t299, %t300
  %t302_i64 = load i64, i64* %_v_output_path, align 8
  %t302 = inttoptr i64 %t302_i64 to i8*
  %t302_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t302_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t303 = load i64, i64* %_v_oplen, align 8
  %t303_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t303_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t304 = add i64 0, 4
  %t305 = sub i64 %t303, %t304
  %t306 = load i64, i64* %_v_oplen, align 8
  %t306_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t306_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t307 = call i8* @flux_str_slice(i8* %t302, i64 %t305, i64 %t306)
  %t308 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.74, i32 0, i32 0
  %t309_cmp = call i32 @flux_str_compare(i8* %t307, i8* %t308)
  %t309 = icmp eq i32 %t309_cmp, 0
  %t310_i64 = load i64, i64* %_v_output_path, align 8
  %t310 = inttoptr i64 %t310_i64 to i8*
  %t310_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t310_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t311 = load i64, i64* %_v_oplen, align 8
  %t311_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t311_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t312 = add i64 0, 4
  %t313 = sub i64 %t311, %t312
  %t314 = load i64, i64* %_v_oplen, align 8
  %t314_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t314_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t315 = call i8* @flux_str_slice(i8* %t310, i64 %t313, i64 %t314)
  %t316 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.75, i32 0, i32 0
  %t317_cmp = call i32 @flux_str_compare(i8* %t315, i8* %t316)
  %t317 = icmp eq i32 %t317_cmp, 0
  %t318 = or i1 %t309, %t317
  %t319 = and i1 %t301, %t318
  br i1 %t319, label %ft_22, label %route_arm_298
ft_22:
  %t320_i64 = load i64, i64* %_v_output_path, align 8
  %t320 = inttoptr i64 %t320_i64 to i8*
  %t320_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t320_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t321 = add i64 0, 1
  %t322 = load i64, i64* %_v_oplen, align 8
  %t322_vsta = load i8*, i8** %_v_oplen__sta, align 8
  %t322_vmsg = load i8*, i8** %_v_oplen__msg, align 8
  %t323 = add i64 0, 5
  %t324 = sub i64 %t322, %t323
  %t325 = call i8* @flux_str_slice(i8* %t320, i64 %t321, i64 %t324)
  %st_38 = ptrtoint i8* %t325 to i64
  store i64 %st_38, i64* %_v_output_path, align 8
  br label %route_end_185
route_arm_298:
  %t327 = add i1 0, 0
  %st_b_39 = zext i1 %t327 to i64
  store i64 %st_b_39, i64* %_v_stripping_ext, align 8
  br label %route_end_185
route_end_185:
  br label %route_end_178
route_end_178:
  br label %loop_start_177
loop_end_177:
  %t330_i64 = load i64, i64* %_v_flag_version, align 8
  %t330 = trunc i64 %t330_i64 to i1
  %t330_vsta = load i8*, i8** %_v_flag_version__sta, align 8
  %t330_vmsg = load i8*, i8** %_v_flag_version__msg, align 8
  br i1 %t330, label %ft_23, label %route_arm_329
ft_23:
  %t331 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.76, i32 0, i32 0
  %pr_sn_12 = icmp eq i8* %t331, null
  %pr_sc_12 = select i1 %pr_sn_12, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t331
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_12)
  call i32 @fflush(i8* null)
  br label %route_end_328
route_arm_329:
  %t333_i64 = load i64, i64* %_v_explain_code, align 8
  %t333 = inttoptr i64 %t333_i64 to i8*
  %t333_vsta = load i8*, i8** %_v_explain_code__sta, align 8
  %t333_vmsg = load i8*, i8** %_v_explain_code__msg, align 8
  %t334 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t335_cmp = call i32 @flux_str_compare(i8* %t333, i8* %t334)
  %t335 = icmp ne i32 %t335_cmp, 0
  br i1 %t335, label %ft_24, label %route_arm_332
ft_24:
  %t336_i64 = load i64, i64* %_v_explain_code, align 8
  %t336 = inttoptr i64 %t336_i64 to i8*
  %t336_vsta = load i8*, i8** %_v_explain_code__sta, align 8
  %t336_vmsg = load i8*, i8** %_v_explain_code__msg, align 8
  %t337_res = call %flux.result @f_diagnosticExplain(i8* %t336)
  %t337_val = extractvalue %flux.result %t337_res, 1
  %t337 = inttoptr i64 %t337_val to i8*
  %st_40 = ptrtoint i8* %t337 to i64
  store i64 %st_40, i64* %_v_explanation, align 8
  %t338_i64 = load i64, i64* %_v_explanation, align 8
  %t338 = inttoptr i64 %t338_i64 to i8*
  %t338_vsta = load i8*, i8** %_v_explanation__sta, align 8
  %t338_vmsg = load i8*, i8** %_v_explanation__msg, align 8
  %pr_sn_13 = icmp eq i8* %t338, null
  %pr_sc_13 = select i1 %pr_sn_13, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t338
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_13)
  call i32 @fflush(i8* null)
  br label %route_end_328
route_arm_332:
  %t340_i64 = load i64, i64* %_v_input_file, align 8
  %t340 = inttoptr i64 %t340_i64 to i8*
  %t340_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t340_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t341 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t342_cmp = call i32 @flux_str_compare(i8* %t340, i8* %t341)
  %t342 = icmp eq i32 %t342_cmp, 0
  br i1 %t342, label %ft_25, label %route_arm_339
ft_25:
  %t343 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.77, i32 0, i32 0
  %pr_sn_14 = icmp eq i8* %t343, null
  %pr_sc_14 = select i1 %pr_sn_14, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t343
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_14)
  call i32 @fflush(i8* null)
  br label %route_end_328
route_arm_339:
  %t345_i64 = load i64, i64* %_v_input_file, align 8
  %t345 = inttoptr i64 %t345_i64 to i8*
  %t345_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t345_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t346 = call i8* @flux_std_io_read_file(i8* %t345)
  %st_41 = ptrtoint i8* %t346 to i64
  store i64 %st_41, i64* %_v_src_code, align 8
  %t347_i64 = load i64, i64* %_v_src_code, align 8
  %t347 = inttoptr i64 %t347_i64 to i8*
  %t347_vsta = load i8*, i8** %_v_src_code__sta, align 8
  %t347_vmsg = load i8*, i8** %_v_src_code__msg, align 8
  %t348 = call i64 @flux_str_len(i8* %t347)
  store i64 %t348, i64* %_v_src_len, align 8
  %t349 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_43 = ptrtoint i8* %t349 to i64
  store i64 %st_43, i64* %_v_exp_err, align 8
  %t352 = load i64, i64* %_v_src_len, align 8
  %t352_vsta = load i8*, i8** %_v_src_len__sta, align 8
  %t352_vmsg = load i8*, i8** %_v_src_len__msg, align 8
  %t353 = add i64 0, 22
  %t354 = icmp sge i64 %t352, %t353
  br i1 %t354, label %ft_26, label %route_arm_351
ft_26:
  %t355_i64 = load i64, i64* %_v_src_code, align 8
  %t355 = inttoptr i64 %t355_i64 to i8*
  %t355_vsta = load i8*, i8** %_v_src_code__sta, align 8
  %t355_vmsg = load i8*, i8** %_v_src_code__msg, align 8
  %t356 = add i64 0, 1
  %t357 = add i64 0, 17
  %t358 = call i8* @flux_str_slice(i8* %t355, i64 %t356, i64 %t357)
  %st_44 = ptrtoint i8* %t358 to i64
  store i64 %st_44, i64* %_v_exp_pref, align 8
  %t361_i64 = load i64, i64* %_v_exp_pref, align 8
  %t361 = inttoptr i64 %t361_i64 to i8*
  %t361_vsta = load i8*, i8** %_v_exp_pref__sta, align 8
  %t361_vmsg = load i8*, i8** %_v_exp_pref__msg, align 8
  %t362 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.78, i32 0, i32 0
  %t363_cmp = call i32 @flux_str_compare(i8* %t361, i8* %t362)
  %t363 = icmp eq i32 %t363_cmp, 0
  br i1 %t363, label %ft_27, label %route_arm_360
ft_27:
  %t364 = add i64 0, 23
  store i64 %t364, i64* %_v_slast, align 8
  %t367 = load i64, i64* %_v_src_len, align 8
  %t367_vsta = load i8*, i8** %_v_src_len__sta, align 8
  %t367_vmsg = load i8*, i8** %_v_src_len__msg, align 8
  %t368 = add i64 0, 23
  %t369 = icmp slt i64 %t367, %t368
  br i1 %t369, label %ft_28, label %route_arm_366
ft_28:
  %t370 = load i64, i64* %_v_src_len, align 8
  %t370_vsta = load i8*, i8** %_v_src_len__sta, align 8
  %t370_vmsg = load i8*, i8** %_v_src_len__msg, align 8
  store i64 %t370, i64* %_v_slast, align 8
  store i8* %t370_vsta, i8** %_v_slast__sta, align 8
  store i8* %t370_vmsg, i8** %_v_slast__msg, align 8
  br label %route_end_365
route_arm_366:
  br label %route_end_365
route_end_365:
  %t372_i64 = load i64, i64* %_v_src_code, align 8
  %t372 = inttoptr i64 %t372_i64 to i8*
  %t372_vsta = load i8*, i8** %_v_src_code__sta, align 8
  %t372_vmsg = load i8*, i8** %_v_src_code__msg, align 8
  %t373 = add i64 0, 18
  %t374 = load i64, i64* %_v_slast, align 8
  %t374_vsta = load i8*, i8** %_v_slast__sta, align 8
  %t374_vmsg = load i8*, i8** %_v_slast__msg, align 8
  %t375 = call i8* @flux_str_slice(i8* %t372, i64 %t373, i64 %t374)
  %st_47 = ptrtoint i8* %t375 to i64
  store i64 %st_47, i64* %_v_exp_err, align 8
  %t376_i64 = load i64, i64* %_v_exp_err, align 8
  %t376 = inttoptr i64 %t376_i64 to i8*
  %t376_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t376_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t377 = call i64 @flux_str_len(i8* %t376)
  store i64 %t377, i64* %_v_elen, align 8
  %t380 = load i64, i64* %_v_elen, align 8
  %t380_vsta = load i8*, i8** %_v_elen__sta, align 8
  %t380_vmsg = load i8*, i8** %_v_elen__msg, align 8
  %t381 = add i64 0, 6
  %t382 = icmp sge i64 %t380, %t381
  br i1 %t382, label %ft_29, label %route_arm_379
ft_29:
  %t383_i64 = load i64, i64* %_v_exp_err, align 8
  %t383 = inttoptr i64 %t383_i64 to i8*
  %t383_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t383_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t384 = add i64 0, 6
  %t385 = call i8* @flux_str_slice(i8* %t383, i64 %t384, i64 %t384)
  %st_49 = ptrtoint i8* %t385 to i64
  store i64 %st_49, i64* %_v_c6, align 8
  %t388_i64 = load i64, i64* %_v_c6, align 8
  %t388 = inttoptr i64 %t388_i64 to i8*
  %t388_vsta = load i8*, i8** %_v_c6__sta, align 8
  %t388_vmsg = load i8*, i8** %_v_c6__msg, align 8
  %t389 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.79, i32 0, i32 0
  %t390_cmp = call i32 @flux_str_compare(i8* %t388, i8* %t389)
  %t390 = icmp eq i32 %t390_cmp, 0
  %t391_i64 = load i64, i64* %_v_c6, align 8
  %t391 = inttoptr i64 %t391_i64 to i8*
  %t391_vsta = load i8*, i8** %_v_c6__sta, align 8
  %t391_vmsg = load i8*, i8** %_v_c6__msg, align 8
  %t392 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.80, i32 0, i32 0
  %t393_cmp = call i32 @flux_str_compare(i8* %t391, i8* %t392)
  %t393 = icmp eq i32 %t393_cmp, 0
  %t394 = or i1 %t390, %t393
  %t395_i64 = load i64, i64* %_v_c6, align 8
  %t395 = inttoptr i64 %t395_i64 to i8*
  %t395_vsta = load i8*, i8** %_v_c6__sta, align 8
  %t395_vmsg = load i8*, i8** %_v_c6__msg, align 8
  %t396 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.81, i32 0, i32 0
  %t397_cmp = call i32 @flux_str_compare(i8* %t395, i8* %t396)
  %t397 = icmp eq i32 %t397_cmp, 0
  %t398 = or i1 %t394, %t397
  br i1 %t398, label %ft_30, label %route_arm_387
ft_30:
  %t399_i64 = load i64, i64* %_v_exp_err, align 8
  %t399 = inttoptr i64 %t399_i64 to i8*
  %t399_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t399_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t400 = add i64 0, 1
  %t401 = add i64 0, 5
  %t402 = call i8* @flux_str_slice(i8* %t399, i64 %t400, i64 %t401)
  %st_50 = ptrtoint i8* %t402 to i64
  store i64 %st_50, i64* %_v_exp_err, align 8
  br label %route_end_386
route_arm_387:
  br label %route_end_386
route_end_386:
  br label %route_end_378
route_arm_379:
  br label %route_end_378
route_end_378:
  br label %route_end_359
route_arm_360:
  br label %route_end_359
route_end_359:
  br label %route_end_350
route_arm_351:
  br label %route_end_350
route_end_350:
  %t409_i64 = load i64, i64* %_v_exp_err, align 8
  %t409 = inttoptr i64 %t409_i64 to i8*
  %t409_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t409_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t410 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t411_cmp = call i32 @flux_str_compare(i8* %t409, i8* %t410)
  %t411 = icmp ne i32 %t411_cmp, 0
  %t412_i64 = load i64, i64* %_v_exp_err, align 8
  %t412 = inttoptr i64 %t412_i64 to i8*
  %t412_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t412_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t413 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.82, i32 0, i32 0
  %t414_cmp = call i32 @flux_str_compare(i8* %t412, i8* %t413)
  %t414 = icmp ne i32 %t414_cmp, 0
  %t415 = and i1 %t411, %t414
  %t416_i64 = load i64, i64* %_v_exp_err, align 8
  %t416 = inttoptr i64 %t416_i64 to i8*
  %t416_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t416_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t417 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.83, i32 0, i32 0
  %t418_cmp = call i32 @flux_str_compare(i8* %t416, i8* %t417)
  %t418 = icmp ne i32 %t418_cmp, 0
  %t419 = and i1 %t415, %t418
  %t420_i64 = load i64, i64* %_v_exp_err, align 8
  %t420 = inttoptr i64 %t420_i64 to i8*
  %t420_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t420_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t421 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.84, i32 0, i32 0
  %t422_cmp = call i32 @flux_str_compare(i8* %t420, i8* %t421)
  %t422 = icmp ne i32 %t422_cmp, 0
  %t423 = and i1 %t419, %t422
  br i1 %t423, label %ft_31, label %route_arm_408
ft_31:
  %t424_i64 = load i64, i64* %_v_exp_err, align 8
  %t424 = inttoptr i64 %t424_i64 to i8*
  %t424_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t424_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t425_i64 = load i64, i64* %_v_input_file, align 8
  %t425 = inttoptr i64 %t425_i64 to i8*
  %t425_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t425_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t426_res = call %flux.result @f_diagnosticGetHeader(i8* %t424, i8* %t425)
  %t426_val = extractvalue %flux.result %t426_res, 1
  %t426 = inttoptr i64 %t426_val to i8*
  %st_51 = ptrtoint i8* %t426 to i64
  store i64 %st_51, i64* %_v_err_hdr, align 8
  %t427_i64 = load i64, i64* %_v_exp_err, align 8
  %t427 = inttoptr i64 %t427_i64 to i8*
  %t427_vsta = load i8*, i8** %_v_exp_err__sta, align 8
  %t427_vmsg = load i8*, i8** %_v_exp_err__msg, align 8
  %t428_res = call %flux.result @f_diagnosticGetHint(i8* %t427)
  %t428_val = extractvalue %flux.result %t428_res, 1
  %t428 = inttoptr i64 %t428_val to i8*
  %st_52 = ptrtoint i8* %t428 to i64
  store i64 %st_52, i64* %_v_err_hint, align 8
  %t429_i64 = load i64, i64* %_v_err_hdr, align 8
  %t429 = inttoptr i64 %t429_i64 to i8*
  %t429_vsta = load i8*, i8** %_v_err_hdr__sta, align 8
  %t429_vmsg = load i8*, i8** %_v_err_hdr__msg, align 8
  %pr_sn_15 = icmp eq i8* %t429, null
  %pr_sc_15 = select i1 %pr_sn_15, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t429
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_15)
  call i32 @fflush(i8* null)
  %t430 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.85, i32 0, i32 0
  %t431_i64 = load i64, i64* %_v_err_hint, align 8
  %t431 = inttoptr i64 %t431_i64 to i8*
  %t431_vsta = load i8*, i8** %_v_err_hint__sta, align 8
  %t431_vmsg = load i8*, i8** %_v_err_hint__msg, align 8
  %t432 = call i8* @flux_str_concat(i8* %t430, i8* %t431)
  %pr_sn_16 = icmp eq i8* %t432, null
  %pr_sc_16 = select i1 %pr_sn_16, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t432
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_16)
  call i32 @fflush(i8* null)
  %t433 = add i64 0, 1
  %t434 = call i64 @flux_std_os_exit(i64 %t433)
  br label %route_end_407
route_arm_408:
  br label %route_end_407
route_end_407:
  %t436_i64 = load i64, i64* %_v_input_file, align 8
  %t436 = inttoptr i64 %t436_i64 to i8*
  %t436_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t436_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t437 = call i64 @flux_str_len(i8* %t436)
  store i64 %t437, i64* %_v_in_len, align 8
  %t438 = add i1 0, 0
  %st_b_54 = zext i1 %t438 to i64
  store i64 %st_b_54, i64* %_v_is_compliance, align 8
  %t439 = add i64 0, 1
  store i64 %t439, i64* %_v_ck, align 8
  br label %loop_start_440
loop_start_440:
  %t443 = load i64, i64* %_v_ck, align 8
  %t443_vsta = load i8*, i8** %_v_ck__sta, align 8
  %t443_vmsg = load i8*, i8** %_v_ck__msg, align 8
  %t444 = add i64 0, 9
  %t445 = add i64 %t443, %t444
  %t446 = load i64, i64* %_v_in_len, align 8
  %t446_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t446_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t447 = icmp sgt i64 %t445, %t446
  br i1 %t447, label %ft_32, label %route_arm_442
ft_32:
  br label %loop_end_440
route_arm_442:
  %t449_i64 = load i64, i64* %_v_input_file, align 8
  %t449 = inttoptr i64 %t449_i64 to i8*
  %t449_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t449_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t450 = load i64, i64* %_v_ck, align 8
  %t450_vsta = load i8*, i8** %_v_ck__sta, align 8
  %t450_vmsg = load i8*, i8** %_v_ck__msg, align 8
  %t451 = load i64, i64* %_v_ck, align 8
  %t451_vsta = load i8*, i8** %_v_ck__sta, align 8
  %t451_vmsg = load i8*, i8** %_v_ck__msg, align 8
  %t452 = add i64 0, 9
  %t453 = add i64 %t451, %t452
  %t454 = call i8* @flux_str_slice(i8* %t449, i64 %t450, i64 %t453)
  %t455 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.86, i32 0, i32 0
  %t456_cmp = call i32 @flux_str_compare(i8* %t454, i8* %t455)
  %t456 = icmp eq i32 %t456_cmp, 0
  br i1 %t456, label %ft_33, label %route_arm_448
ft_33:
  %t457 = add i1 0, 1
  %st_b_56 = zext i1 %t457 to i64
  store i64 %st_b_56, i64* %_v_is_compliance, align 8
  br label %loop_end_440
route_arm_448:
  %t459 = load i64, i64* %_v_ck, align 8
  %t459_vsta = load i8*, i8** %_v_ck__sta, align 8
  %t459_vmsg = load i8*, i8** %_v_ck__msg, align 8
  %t460 = add i64 0, 1
  %t461 = add i64 %t459, %t460
  store i64 %t461, i64* %_v_ck, align 8
  br label %route_end_441
route_end_441:
  br label %loop_start_440
loop_end_440:
  %t462 = add i1 0, 0
  %st_b_58 = zext i1 %t462 to i64
  store i64 %st_b_58, i64* %_v_is_exemplos, align 8
  %t463 = add i64 0, 1
  store i64 %t463, i64* %_v_ek, align 8
  br label %loop_start_464
loop_start_464:
  %t467 = load i64, i64* %_v_ek, align 8
  %t467_vsta = load i8*, i8** %_v_ek__sta, align 8
  %t467_vmsg = load i8*, i8** %_v_ek__msg, align 8
  %t468 = add i64 0, 7
  %t469 = add i64 %t467, %t468
  %t470 = load i64, i64* %_v_in_len, align 8
  %t470_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t470_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t471 = icmp sgt i64 %t469, %t470
  br i1 %t471, label %ft_34, label %route_arm_466
ft_34:
  br label %loop_end_464
route_arm_466:
  %t473_i64 = load i64, i64* %_v_input_file, align 8
  %t473 = inttoptr i64 %t473_i64 to i8*
  %t473_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t473_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t474 = load i64, i64* %_v_ek, align 8
  %t474_vsta = load i8*, i8** %_v_ek__sta, align 8
  %t474_vmsg = load i8*, i8** %_v_ek__msg, align 8
  %t475 = load i64, i64* %_v_ek, align 8
  %t475_vsta = load i8*, i8** %_v_ek__sta, align 8
  %t475_vmsg = load i8*, i8** %_v_ek__msg, align 8
  %t476 = add i64 0, 7
  %t477 = add i64 %t475, %t476
  %t478 = call i8* @flux_str_slice(i8* %t473, i64 %t474, i64 %t477)
  %t479 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.87, i32 0, i32 0
  %t480_cmp = call i32 @flux_str_compare(i8* %t478, i8* %t479)
  %t480 = icmp eq i32 %t480_cmp, 0
  %t481_i64 = load i64, i64* %_v_input_file, align 8
  %t481 = inttoptr i64 %t481_i64 to i8*
  %t481_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t481_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t482 = load i64, i64* %_v_ek, align 8
  %t482_vsta = load i8*, i8** %_v_ek__sta, align 8
  %t482_vmsg = load i8*, i8** %_v_ek__msg, align 8
  %t483 = load i64, i64* %_v_ek, align 8
  %t483_vsta = load i8*, i8** %_v_ek__sta, align 8
  %t483_vmsg = load i8*, i8** %_v_ek__msg, align 8
  %t484 = add i64 0, 7
  %t485 = add i64 %t483, %t484
  %t486 = call i8* @flux_str_slice(i8* %t481, i64 %t482, i64 %t485)
  %t487 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.88, i32 0, i32 0
  %t488_cmp = call i32 @flux_str_compare(i8* %t486, i8* %t487)
  %t488 = icmp eq i32 %t488_cmp, 0
  %t489 = or i1 %t480, %t488
  br i1 %t489, label %ft_35, label %route_arm_472
ft_35:
  %t490 = add i1 0, 1
  %st_b_60 = zext i1 %t490 to i64
  store i64 %st_b_60, i64* %_v_is_exemplos, align 8
  br label %loop_end_464
route_arm_472:
  %t492 = load i64, i64* %_v_ek, align 8
  %t492_vsta = load i8*, i8** %_v_ek__sta, align 8
  %t492_vmsg = load i8*, i8** %_v_ek__msg, align 8
  %t493 = add i64 0, 1
  %t494 = add i64 %t492, %t493
  store i64 %t494, i64* %_v_ek, align 8
  br label %route_end_465
route_end_465:
  br label %loop_start_464
loop_end_464:
  %t495 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_62 = ptrtoint i8* %t495 to i64
  store i64 %st_62, i64* %_v_arg_suffix, align 8
  %t498_i64 = load i64, i64* %_v_extra_args, align 8
  %t498 = inttoptr i64 %t498_i64 to i8*
  %t498_vsta = load i8*, i8** %_v_extra_args__sta, align 8
  %t498_vmsg = load i8*, i8** %_v_extra_args__msg, align 8
  %t499 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t500_cmp = call i32 @flux_str_compare(i8* %t498, i8* %t499)
  %t500 = icmp ne i32 %t500_cmp, 0
  br i1 %t500, label %ft_36, label %route_arm_497
ft_36:
  %t501 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.81, i32 0, i32 0
  %t502_i64 = load i64, i64* %_v_extra_args, align 8
  %t502 = inttoptr i64 %t502_i64 to i8*
  %t502_vsta = load i8*, i8** %_v_extra_args__sta, align 8
  %t502_vmsg = load i8*, i8** %_v_extra_args__msg, align 8
  %t503 = call i8* @flux_str_concat(i8* %t501, i8* %t502)
  %st_63 = ptrtoint i8* %t503 to i64
  store i64 %st_63, i64* %_v_arg_suffix, align 8
  br label %route_end_496
route_arm_497:
  br label %route_end_496
route_end_496:
  %t507_i64 = load i64, i64* %_v_target, align 8
  %t507 = inttoptr i64 %t507_i64 to i8*
  %t507_vsta = load i8*, i8** %_v_target__sta, align 8
  %t507_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t508 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.18, i32 0, i32 0
  %t509_cmp = call i32 @flux_str_compare(i8* %t507, i8* %t508)
  %t509 = icmp eq i32 %t509_cmp, 0
  %t510_i64 = load i64, i64* %_v_target, align 8
  %t510 = inttoptr i64 %t510_i64 to i8*
  %t510_vsta = load i8*, i8** %_v_target__sta, align 8
  %t510_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t511 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.89, i32 0, i32 0
  %t512_cmp = call i32 @flux_str_compare(i8* %t510, i8* %t511)
  %t512 = icmp eq i32 %t512_cmp, 0
  %t513 = or i1 %t509, %t512
  br i1 %t513, label %ft_37, label %route_arm_506
ft_37:
  %t516_i64 = load i64, i64* %_v_is_compliance, align 8
  %t516 = trunc i64 %t516_i64 to i1
  %t516_vsta = load i8*, i8** %_v_is_compliance__sta, align 8
  %t516_vmsg = load i8*, i8** %_v_is_compliance__msg, align 8
  br i1 %t516, label %ft_38, label %route_arm_515
ft_38:
  %t519 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.90, i32 0, i32 0
  %t520_i64 = call i64 @flux_std_io_file_exists(i8* %t519)
  %t520 = trunc i64 %t520_i64 to i1
  %t521 = load i64, i64* %_v_in_len, align 8
  %t521_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t521_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t522 = add i64 0, 13
  %t523 = icmp sge i64 %t521, %t522
  %t524 = and i1 %t520, %t523
  br i1 %t524, label %ft_39, label %route_arm_518
ft_39:
  %t525 = add i64 0, 1
  store i64 %t525, i64* %_v_bi, align 8
  br label %loop_start_526
loop_start_526:
  %t529 = load i64, i64* %_v_bi, align 8
  %t529_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t529_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t530 = add i64 0, 12
  %t531 = add i64 %t529, %t530
  %t532 = load i64, i64* %_v_in_len, align 8
  %t532_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t532_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t533 = icmp sgt i64 %t531, %t532
  br i1 %t533, label %ft_40, label %route_arm_528
ft_40:
  br label %loop_end_526
route_arm_528:
  %t535_i64 = load i64, i64* %_v_input_file, align 8
  %t535 = inttoptr i64 %t535_i64 to i8*
  %t535_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t535_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t536 = load i64, i64* %_v_bi, align 8
  %t536_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t536_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t537 = load i64, i64* %_v_bi, align 8
  %t537_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t537_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t538 = add i64 0, 12
  %t539 = add i64 %t537, %t538
  %t540 = call i8* @flux_str_slice(i8* %t535, i64 %t536, i64 %t539)
  %t541 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.91, i32 0, i32 0
  %t542_cmp = call i32 @flux_str_compare(i8* %t540, i8* %t541)
  %t542 = icmp eq i32 %t542_cmp, 0
  br i1 %t542, label %ft_41, label %route_arm_534
ft_41:
  %t543 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.92, i32 0, i32 0
  %t544_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t544 = inttoptr i64 %t544_i64 to i8*
  %t544_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t544_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t545 = call i8* @flux_str_concat(i8* %t543, i8* %t544)
  %t546 = call i64 @flux_std_os_exec(i8* %t545)
  store i64 %t546, i64* %_v_rc, align 8
  %t547 = load i64, i64* %_v_rc, align 8
  %t547_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t547_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t548 = call i64 @flux_std_os_exit(i64 %t547)
  br label %route_end_527
route_arm_534:
  %t550 = load i64, i64* %_v_bi, align 8
  %t550_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t550_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t551 = add i64 0, 1
  %t552 = add i64 %t550, %t551
  store i64 %t552, i64* %_v_bi, align 8
  br label %route_end_527
route_end_527:
  br label %loop_start_526
loop_end_526:
  br label %route_end_517
route_arm_518:
  br label %route_end_517
route_end_517:
  %t556 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.93, i32 0, i32 0
  %t557_i64 = call i64 @flux_std_io_file_exists(i8* %t556)
  %t557 = trunc i64 %t557_i64 to i1
  %t558 = load i64, i64* %_v_in_len, align 8
  %t558_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t558_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t559 = add i64 0, 13
  %t560 = icmp sge i64 %t558, %t559
  %t561 = and i1 %t557, %t560
  br i1 %t561, label %ft_42, label %route_arm_555
ft_42:
  %t562 = add i64 0, 1
  store i64 %t562, i64* %_v_bi, align 8
  br label %loop_start_563
loop_start_563:
  %t566 = load i64, i64* %_v_bi, align 8
  %t566_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t566_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t567 = add i64 0, 12
  %t568 = add i64 %t566, %t567
  %t569 = load i64, i64* %_v_in_len, align 8
  %t569_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t569_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t570 = icmp sgt i64 %t568, %t569
  br i1 %t570, label %ft_43, label %route_arm_565
ft_43:
  br label %loop_end_563
route_arm_565:
  %t572_i64 = load i64, i64* %_v_input_file, align 8
  %t572 = inttoptr i64 %t572_i64 to i8*
  %t572_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t572_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t573 = load i64, i64* %_v_bi, align 8
  %t573_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t573_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t574 = load i64, i64* %_v_bi, align 8
  %t574_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t574_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t575 = add i64 0, 12
  %t576 = add i64 %t574, %t575
  %t577 = call i8* @flux_str_slice(i8* %t572, i64 %t573, i64 %t576)
  %t578 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.94, i32 0, i32 0
  %t579_cmp = call i32 @flux_str_compare(i8* %t577, i8* %t578)
  %t579 = icmp eq i32 %t579_cmp, 0
  br i1 %t579, label %ft_44, label %route_arm_571
ft_44:
  %t580 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.95, i32 0, i32 0
  %t581_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t581 = inttoptr i64 %t581_i64 to i8*
  %t581_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t581_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t582 = call i8* @flux_str_concat(i8* %t580, i8* %t581)
  %t583 = call i64 @flux_std_os_exec(i8* %t582)
  store i64 %t583, i64* %_v_rc, align 8
  %t584 = load i64, i64* %_v_rc, align 8
  %t584_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t584_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t585 = call i64 @flux_std_os_exit(i64 %t584)
  br label %route_end_564
route_arm_571:
  %t587 = load i64, i64* %_v_bi, align 8
  %t587_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t587_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t588 = add i64 0, 1
  %t589 = add i64 %t587, %t588
  store i64 %t589, i64* %_v_bi, align 8
  br label %route_end_564
route_end_564:
  br label %loop_start_563
loop_end_563:
  br label %route_end_554
route_arm_555:
  br label %route_end_554
route_end_554:
  %t593 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.96, i32 0, i32 0
  %t594_i64 = call i64 @flux_std_io_file_exists(i8* %t593)
  %t594 = trunc i64 %t594_i64 to i1
  %t595 = load i64, i64* %_v_in_len, align 8
  %t595_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t595_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t596 = add i64 0, 13
  %t597 = icmp sge i64 %t595, %t596
  %t598 = and i1 %t594, %t597
  br i1 %t598, label %ft_45, label %route_arm_592
ft_45:
  %t599 = add i64 0, 1
  store i64 %t599, i64* %_v_bi, align 8
  br label %loop_start_600
loop_start_600:
  %t603 = load i64, i64* %_v_bi, align 8
  %t603_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t603_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t604 = add i64 0, 12
  %t605 = add i64 %t603, %t604
  %t606 = load i64, i64* %_v_in_len, align 8
  %t606_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t606_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t607 = icmp sgt i64 %t605, %t606
  br i1 %t607, label %ft_46, label %route_arm_602
ft_46:
  br label %loop_end_600
route_arm_602:
  %t609_i64 = load i64, i64* %_v_input_file, align 8
  %t609 = inttoptr i64 %t609_i64 to i8*
  %t609_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t609_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t610 = load i64, i64* %_v_bi, align 8
  %t610_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t610_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t611 = load i64, i64* %_v_bi, align 8
  %t611_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t611_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t612 = add i64 0, 12
  %t613 = add i64 %t611, %t612
  %t614 = call i8* @flux_str_slice(i8* %t609, i64 %t610, i64 %t613)
  %t615 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.97, i32 0, i32 0
  %t616_cmp = call i32 @flux_str_compare(i8* %t614, i8* %t615)
  %t616 = icmp eq i32 %t616_cmp, 0
  br i1 %t616, label %ft_47, label %route_arm_608
ft_47:
  %t617 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.98, i32 0, i32 0
  %t618_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t618 = inttoptr i64 %t618_i64 to i8*
  %t618_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t618_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t619 = call i8* @flux_str_concat(i8* %t617, i8* %t618)
  %t620 = call i64 @flux_std_os_exec(i8* %t619)
  store i64 %t620, i64* %_v_rc, align 8
  %t621 = load i64, i64* %_v_rc, align 8
  %t621_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t621_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t622 = call i64 @flux_std_os_exit(i64 %t621)
  br label %route_end_601
route_arm_608:
  %t624 = load i64, i64* %_v_bi, align 8
  %t624_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t624_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t625 = add i64 0, 1
  %t626 = add i64 %t624, %t625
  store i64 %t626, i64* %_v_bi, align 8
  br label %route_end_601
route_end_601:
  br label %loop_start_600
loop_end_600:
  br label %route_end_591
route_arm_592:
  br label %route_end_591
route_end_591:
  %t630 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.99, i32 0, i32 0
  %t631_i64 = call i64 @flux_std_io_file_exists(i8* %t630)
  %t631 = trunc i64 %t631_i64 to i1
  %t632 = load i64, i64* %_v_in_len, align 8
  %t632_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t632_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t633 = add i64 0, 13
  %t634 = icmp sge i64 %t632, %t633
  %t635 = and i1 %t631, %t634
  br i1 %t635, label %ft_48, label %route_arm_629
ft_48:
  %t636 = add i64 0, 1
  store i64 %t636, i64* %_v_bi, align 8
  br label %loop_start_637
loop_start_637:
  %t640 = load i64, i64* %_v_bi, align 8
  %t640_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t640_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t641 = add i64 0, 12
  %t642 = add i64 %t640, %t641
  %t643 = load i64, i64* %_v_in_len, align 8
  %t643_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t643_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t644 = icmp sgt i64 %t642, %t643
  br i1 %t644, label %ft_49, label %route_arm_639
ft_49:
  br label %loop_end_637
route_arm_639:
  %t646_i64 = load i64, i64* %_v_input_file, align 8
  %t646 = inttoptr i64 %t646_i64 to i8*
  %t646_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t646_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t647 = load i64, i64* %_v_bi, align 8
  %t647_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t647_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t648 = load i64, i64* %_v_bi, align 8
  %t648_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t648_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t649 = add i64 0, 12
  %t650 = add i64 %t648, %t649
  %t651 = call i8* @flux_str_slice(i8* %t646, i64 %t647, i64 %t650)
  %t652 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.100, i32 0, i32 0
  %t653_cmp = call i32 @flux_str_compare(i8* %t651, i8* %t652)
  %t653 = icmp eq i32 %t653_cmp, 0
  br i1 %t653, label %ft_50, label %route_arm_645
ft_50:
  %t654 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.101, i32 0, i32 0
  %t655_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t655 = inttoptr i64 %t655_i64 to i8*
  %t655_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t655_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t656 = call i8* @flux_str_concat(i8* %t654, i8* %t655)
  %t657 = call i64 @flux_std_os_exec(i8* %t656)
  store i64 %t657, i64* %_v_rc, align 8
  %t658 = load i64, i64* %_v_rc, align 8
  %t658_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t658_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t659 = call i64 @flux_std_os_exit(i64 %t658)
  br label %route_end_638
route_arm_645:
  %t661 = load i64, i64* %_v_bi, align 8
  %t661_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t661_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t662 = add i64 0, 1
  %t663 = add i64 %t661, %t662
  store i64 %t663, i64* %_v_bi, align 8
  br label %route_end_638
route_end_638:
  br label %loop_start_637
loop_end_637:
  br label %route_end_628
route_arm_629:
  br label %route_end_628
route_end_628:
  %t667 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.102, i32 0, i32 0
  %t668_i64 = call i64 @flux_std_io_file_exists(i8* %t667)
  %t668 = trunc i64 %t668_i64 to i1
  %t669 = load i64, i64* %_v_in_len, align 8
  %t669_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t669_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t670 = add i64 0, 10
  %t671 = icmp sge i64 %t669, %t670
  %t672 = and i1 %t668, %t671
  br i1 %t672, label %ft_51, label %route_arm_666
ft_51:
  %t673 = add i64 0, 1
  store i64 %t673, i64* %_v_bi, align 8
  br label %loop_start_674
loop_start_674:
  %t677 = load i64, i64* %_v_bi, align 8
  %t677_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t677_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t678 = add i64 0, 9
  %t679 = add i64 %t677, %t678
  %t680 = load i64, i64* %_v_in_len, align 8
  %t680_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t680_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t681 = icmp sgt i64 %t679, %t680
  br i1 %t681, label %ft_52, label %route_arm_676
ft_52:
  br label %loop_end_674
route_arm_676:
  %t683_i64 = load i64, i64* %_v_input_file, align 8
  %t683 = inttoptr i64 %t683_i64 to i8*
  %t683_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t683_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t684 = load i64, i64* %_v_bi, align 8
  %t684_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t684_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t685 = load i64, i64* %_v_bi, align 8
  %t685_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t685_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t686 = add i64 0, 9
  %t687 = add i64 %t685, %t686
  %t688 = call i8* @flux_str_slice(i8* %t683, i64 %t684, i64 %t687)
  %t689 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.86, i32 0, i32 0
  %t690_cmp = call i32 @flux_str_compare(i8* %t688, i8* %t689)
  %t690 = icmp eq i32 %t690_cmp, 0
  br i1 %t690, label %ft_53, label %route_arm_682
ft_53:
  %t691 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.103, i32 0, i32 0
  %t692_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t692 = inttoptr i64 %t692_i64 to i8*
  %t692_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t692_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t693 = call i8* @flux_str_concat(i8* %t691, i8* %t692)
  %t694 = call i64 @flux_std_os_exec(i8* %t693)
  store i64 %t694, i64* %_v_rc, align 8
  %t695 = load i64, i64* %_v_rc, align 8
  %t695_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t695_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t696 = call i64 @flux_std_os_exit(i64 %t695)
  br label %route_end_675
route_arm_682:
  %t698 = load i64, i64* %_v_bi, align 8
  %t698_vsta = load i8*, i8** %_v_bi__sta, align 8
  %t698_vmsg = load i8*, i8** %_v_bi__msg, align 8
  %t699 = add i64 0, 1
  %t700 = add i64 %t698, %t699
  store i64 %t700, i64* %_v_bi, align 8
  br label %route_end_675
route_end_675:
  br label %loop_start_674
loop_end_674:
  br label %route_end_665
route_arm_666:
  br label %route_end_665
route_end_665:
  br label %route_end_514
route_arm_515:
  br label %route_end_514
route_end_514:
  %t705_i64 = load i64, i64* %_v_is_exemplos, align 8
  %t705 = trunc i64 %t705_i64 to i1
  %t705_vsta = load i8*, i8** %_v_is_exemplos__sta, align 8
  %t705_vmsg = load i8*, i8** %_v_is_exemplos__msg, align 8
  br i1 %t705, label %ft_54, label %route_arm_704
ft_54:
  %t706 = call i8* @flux_list_create(i64 16)
  %t707 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.104, i32 0, i32 0
  %p_lp_1 = ptrtoint i8* %t707 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_1)
  %t708 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.105, i32 0, i32 0
  %p_lp_2 = ptrtoint i8* %t708 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_2)
  %t709 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.106, i32 0, i32 0
  %p_lp_3 = ptrtoint i8* %t709 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_3)
  %t710 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.107, i32 0, i32 0
  %p_lp_4 = ptrtoint i8* %t710 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_4)
  %t711 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.108, i32 0, i32 0
  %p_lp_5 = ptrtoint i8* %t711 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_5)
  %t712 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.109, i32 0, i32 0
  %p_lp_6 = ptrtoint i8* %t712 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_6)
  %t713 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.110, i32 0, i32 0
  %p_lp_7 = ptrtoint i8* %t713 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_7)
  %t714 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.111, i32 0, i32 0
  %p_lp_8 = ptrtoint i8* %t714 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_8)
  %t715 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.112, i32 0, i32 0
  %p_lp_9 = ptrtoint i8* %t715 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_9)
  %t716 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.113, i32 0, i32 0
  %p_lp_10 = ptrtoint i8* %t716 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_10)
  %t717 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.114, i32 0, i32 0
  %p_lp_11 = ptrtoint i8* %t717 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_11)
  %t718 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.115, i32 0, i32 0
  %p_lp_12 = ptrtoint i8* %t718 to i64
  call void @flux_list_push_tagged(i8* %t706, i64 4, i64 %p_lp_12)
  %st_79 = ptrtoint i8* %t706 to i64
  store i64 %st_79, i64* %_v_ex_names, align 8
  %t719 = add i64 0, 1
  store i64 %t719, i64* %_v_eni, align 8
  br label %loop_start_720
loop_start_720:
  %t723 = load i64, i64* %_v_eni, align 8
  %t723_vsta = load i8*, i8** %_v_eni__sta, align 8
  %t723_vmsg = load i8*, i8** %_v_eni__msg, align 8
  %t724 = add i64 0, 12
  %t725 = icmp sgt i64 %t723, %t724
  br i1 %t725, label %ft_55, label %route_arm_722
ft_55:
  br label %loop_end_720
route_arm_722:
  %t727 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t728_i64 = load i64, i64* %_v_ex_names, align 8
  %t728 = inttoptr i64 %t728_i64 to i8*
  %t728_vsta = load i8*, i8** %_v_ex_names__sta, align 8
  %t728_vmsg = load i8*, i8** %_v_ex_names__msg, align 8
  %t729 = load i64, i64* %_v_eni, align 8
  %t729_vsta = load i8*, i8** %_v_eni__sta, align 8
  %t729_vmsg = load i8*, i8** %_v_eni__msg, align 8
  %t730_raw = call i64 @flux_list_get_val(i8* %t728, i64 %t729)
  %t730 = inttoptr i64 %t730_raw to i8*
  %t731 = call i8* @flux_str_concat(i8* %t727, i8* %t730)
  %st_81 = ptrtoint i8* %t731 to i64
  store i64 %st_81, i64* %_v_enm, align 8
  %t732_i64 = load i64, i64* %_v_enm, align 8
  %t732 = inttoptr i64 %t732_i64 to i8*
  %t732_vsta = load i8*, i8** %_v_enm__sta, align 8
  %t732_vmsg = load i8*, i8** %_v_enm__msg, align 8
  %t733 = call i64 @flux_str_len(i8* %t732)
  store i64 %t733, i64* %_v_enmlen, align 8
  %t734 = add i64 0, 1
  store i64 %t734, i64* %_v_ebi, align 8
  br label %loop_start_735
loop_start_735:
  %t738 = load i64, i64* %_v_ebi, align 8
  %t738_vsta = load i8*, i8** %_v_ebi__sta, align 8
  %t738_vmsg = load i8*, i8** %_v_ebi__msg, align 8
  %t739 = load i64, i64* %_v_enmlen, align 8
  %t739_vsta = load i8*, i8** %_v_enmlen__sta, align 8
  %t739_vmsg = load i8*, i8** %_v_enmlen__msg, align 8
  %t740 = add i64 %t738, %t739
  %t741 = add i64 0, 1
  %t742 = sub i64 %t740, %t741
  %t743 = load i64, i64* %_v_in_len, align 8
  %t743_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t743_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t744 = icmp sgt i64 %t742, %t743
  br i1 %t744, label %ft_56, label %route_arm_737
ft_56:
  br label %loop_end_735
route_arm_737:
  %t746_i64 = load i64, i64* %_v_input_file, align 8
  %t746 = inttoptr i64 %t746_i64 to i8*
  %t746_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t746_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t747 = load i64, i64* %_v_ebi, align 8
  %t747_vsta = load i8*, i8** %_v_ebi__sta, align 8
  %t747_vmsg = load i8*, i8** %_v_ebi__msg, align 8
  %t748 = load i64, i64* %_v_ebi, align 8
  %t748_vsta = load i8*, i8** %_v_ebi__sta, align 8
  %t748_vmsg = load i8*, i8** %_v_ebi__msg, align 8
  %t749 = load i64, i64* %_v_enmlen, align 8
  %t749_vsta = load i8*, i8** %_v_enmlen__sta, align 8
  %t749_vmsg = load i8*, i8** %_v_enmlen__msg, align 8
  %t750 = add i64 %t748, %t749
  %t751 = add i64 0, 1
  %t752 = sub i64 %t750, %t751
  %t753 = call i8* @flux_str_slice(i8* %t746, i64 %t747, i64 %t752)
  %t754_i64 = load i64, i64* %_v_enm, align 8
  %t754 = inttoptr i64 %t754_i64 to i8*
  %t754_vsta = load i8*, i8** %_v_enm__sta, align 8
  %t754_vmsg = load i8*, i8** %_v_enm__msg, align 8
  %t755_cmp = call i32 @flux_str_compare(i8* %t753, i8* %t754)
  %t755 = icmp eq i32 %t755_cmp, 0
  br i1 %t755, label %ft_57, label %route_arm_745
ft_57:
  %t756_i64 = load i64, i64* %_v_enm, align 8
  %t756 = inttoptr i64 %t756_i64 to i8*
  %t756_vsta = load i8*, i8** %_v_enm__sta, align 8
  %t756_vmsg = load i8*, i8** %_v_enm__msg, align 8
  %st_84 = ptrtoint i8* %t756 to i64
  store i64 %st_84, i64* %_v_bin_name, align 8
  store i8* %t756_vsta, i8** %_v_bin_name__sta, align 8
  store i8* %t756_vmsg, i8** %_v_bin_name__msg, align 8
  %t759 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.116, i32 0, i32 0
  %t760_i64 = load i64, i64* %_v_bin_name, align 8
  %t760 = inttoptr i64 %t760_i64 to i8*
  %t760_vsta = load i8*, i8** %_v_bin_name__sta, align 8
  %t760_vmsg = load i8*, i8** %_v_bin_name__msg, align 8
  %t761 = call i8* @flux_str_concat(i8* %t759, i8* %t760)
  %t762 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.66, i32 0, i32 0
  %t763 = call i8* @flux_str_concat(i8* %t761, i8* %t762)
  %t764_i64 = call i64 @flux_std_io_file_exists(i8* %t763)
  %t764 = trunc i64 %t764_i64 to i1
  br i1 %t764, label %ft_58, label %route_arm_758
ft_58:
  %t765 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.117, i32 0, i32 0
  %t766_i64 = load i64, i64* %_v_bin_name, align 8
  %t766 = inttoptr i64 %t766_i64 to i8*
  %t766_vsta = load i8*, i8** %_v_bin_name__sta, align 8
  %t766_vmsg = load i8*, i8** %_v_bin_name__msg, align 8
  %t767 = call i8* @flux_str_concat(i8* %t765, i8* %t766)
  %t768 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.66, i32 0, i32 0
  %t769 = call i8* @flux_str_concat(i8* %t767, i8* %t768)
  %t770_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t770 = inttoptr i64 %t770_i64 to i8*
  %t770_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t770_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t771 = call i8* @flux_str_concat(i8* %t769, i8* %t770)
  %t772 = call i64 @flux_std_os_exec(i8* %t771)
  store i64 %t772, i64* %_v_rc, align 8
  %t773 = load i64, i64* %_v_rc, align 8
  %t773_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t773_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t774 = call i64 @flux_std_os_exit(i64 %t773)
  br label %route_end_757
route_arm_758:
  br label %route_end_757
route_end_757:
  br label %loop_end_735
route_arm_745:
  %t777 = load i64, i64* %_v_ebi, align 8
  %t777_vsta = load i8*, i8** %_v_ebi__sta, align 8
  %t777_vmsg = load i8*, i8** %_v_ebi__msg, align 8
  %t778 = add i64 0, 1
  %t779 = add i64 %t777, %t778
  store i64 %t779, i64* %_v_ebi, align 8
  br label %route_end_736
route_end_736:
  br label %loop_start_735
loop_end_735:
  %t780 = load i64, i64* %_v_eni, align 8
  %t780_vsta = load i8*, i8** %_v_eni__sta, align 8
  %t780_vmsg = load i8*, i8** %_v_eni__msg, align 8
  %t781 = add i64 0, 1
  %t782 = add i64 %t780, %t781
  store i64 %t782, i64* %_v_eni, align 8
  br label %route_end_721
route_end_721:
  br label %loop_start_720
loop_end_720:
  br label %route_end_703
route_arm_704:
  br label %route_end_703
route_end_703:
  br label %route_end_505
route_arm_506:
  br label %route_end_505
route_end_505:
  %t787_i64 = load i64, i64* %_v_target, align 8
  %t787 = inttoptr i64 %t787_i64 to i8*
  %t787_vsta = load i8*, i8** %_v_target__sta, align 8
  %t787_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t788 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.20, i32 0, i32 0
  %t789_cmp = call i32 @flux_str_compare(i8* %t787, i8* %t788)
  %t789 = icmp eq i32 %t789_cmp, 0
  %t790 = load i64, i64* %_v_in_len, align 8
  %t790_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t790_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t791 = add i64 0, 6
  %t792 = icmp sge i64 %t790, %t791
  %t793 = and i1 %t789, %t792
  %t794_i64 = load i64, i64* %_v_input_file, align 8
  %t794 = inttoptr i64 %t794_i64 to i8*
  %t794_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t794_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t795 = load i64, i64* %_v_in_len, align 8
  %t795_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t795_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t796 = add i64 0, 5
  %t797 = sub i64 %t795, %t796
  %t798 = load i64, i64* %_v_in_len, align 8
  %t798_vsta = load i8*, i8** %_v_in_len__sta, align 8
  %t798_vmsg = load i8*, i8** %_v_in_len__msg, align 8
  %t799 = call i8* @flux_str_slice(i8* %t794, i64 %t797, i64 %t798)
  %t800 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.70, i32 0, i32 0
  %t801_cmp = call i32 @flux_str_compare(i8* %t799, i8* %t800)
  %t801 = icmp eq i32 %t801_cmp, 0
  %t802 = and i1 %t793, %t801
  br i1 %t802, label %ft_59, label %route_arm_786
ft_59:
  %t803_i64 = load i64, i64* %_v_input_file, align 8
  %t803 = inttoptr i64 %t803_i64 to i8*
  %t803_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t803_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t804_res = call %flux.result @f_vmrExecuteFile(i8* %t803)
  %t804_val = extractvalue %flux.result %t804_res, 1
  %t804 = inttoptr i64 %t804_val to i8*
  %st_88 = ptrtoint i8* %t804 to i64
  store i64 %st_88, i64* %_v_vmr_res, align 8
  %t807_i64 = load i64, i64* %_v_vmr_res, align 8
  %t807 = inttoptr i64 %t807_i64 to i8*
  %t807_vsta = load i8*, i8** %_v_vmr_res__sta, align 8
  %t807_vmsg = load i8*, i8** %_v_vmr_res__msg, align 8
  %t808 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.118, i32 0, i32 0
  %t809_raw = call i64 @flux_map_get(i8* %t807, i8* %t808)
  %t809 = icmp ne i64 %t809_raw, 0
  %t810 = xor i1 %t809, 1
  br i1 %t810, label %ft_60, label %route_arm_806
ft_60:
  %t811 = add i64 0, 1
  %t812 = call i64 @flux_std_os_exit(i64 %t811)
  br label %route_end_805
route_arm_806:
  %t814 = add i64 0, 0
  %t815 = call i64 @flux_std_os_exit(i64 %t814)
  br label %route_end_805
route_end_805:
  br label %route_end_785
route_arm_786:
  br label %route_end_785
route_end_785:
  %t817_i64 = load i64, i64* %_v_input_file, align 8
  %t817 = inttoptr i64 %t817_i64 to i8*
  %t817_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t817_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t818_res = call %flux.result @f_parseFile(i8* %t817)
  %t818_val = extractvalue %flux.result %t818_res, 1
  %t818 = inttoptr i64 %t818_val to i8*
  %st_89 = ptrtoint i8* %t818 to i64
  store i64 %st_89, i64* %_v_parse_res, align 8
  %t821_i64 = load i64, i64* %_v_parse_res, align 8
  %t821 = inttoptr i64 %t821_i64 to i8*
  %t821_vsta = load i8*, i8** %_v_parse_res__sta, align 8
  %t821_vmsg = load i8*, i8** %_v_parse_res__msg, align 8
  %t822 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.118, i32 0, i32 0
  %t823_raw = call i64 @flux_map_get(i8* %t821, i8* %t822)
  %t823 = icmp ne i64 %t823_raw, 0
  %t824 = xor i1 %t823, 1
  br i1 %t824, label %ft_61, label %route_arm_820
ft_61:
  %t825 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.119, i32 0, i32 0
  %t826_i64 = load i64, i64* %_v_parse_res, align 8
  %t826 = inttoptr i64 %t826_i64 to i8*
  %t826_vsta = load i8*, i8** %_v_parse_res__sta, align 8
  %t826_vmsg = load i8*, i8** %_v_parse_res__msg, align 8
  %t827 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.120, i32 0, i32 0
  %t828_raw = call i64 @flux_map_get(i8* %t826, i8* %t827)
  %t828 = inttoptr i64 %t828_raw to i8*
  %t829 = call i8* @flux_str_concat(i8* %t825, i8* %t828)
  %pr_sn_17 = icmp eq i8* %t829, null
  %pr_sc_17 = select i1 %pr_sn_17, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t829
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_17)
  call i32 @fflush(i8* null)
  %t830 = add i64 0, 1
  %t831 = call i64 @flux_std_os_exit(i64 %t830)
  br label %route_end_819
route_arm_820:
  %t833_i64 = load i64, i64* %_v_parse_res, align 8
  %t833 = inttoptr i64 %t833_i64 to i8*
  %t833_vsta = load i8*, i8** %_v_parse_res__sta, align 8
  %t833_vmsg = load i8*, i8** %_v_parse_res__msg, align 8
  %t834 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.121, i32 0, i32 0
  %t835_raw = call i64 @flux_map_get(i8* %t833, i8* %t834)
  %t835 = inttoptr i64 %t835_raw to i8*
  %st_90 = ptrtoint i8* %t835 to i64
  store i64 %st_90, i64* %_v_arena, align 8
  %t836_i64 = load i64, i64* %_v_parse_res, align 8
  %t836 = inttoptr i64 %t836_i64 to i8*
  %t836_vsta = load i8*, i8** %_v_parse_res__sta, align 8
  %t836_vmsg = load i8*, i8** %_v_parse_res__msg, align 8
  %t837 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.122, i32 0, i32 0
  %t838_raw = call i64 @flux_map_get(i8* %t836, i8* %t837)
  %t838 = add i64 0, %t838_raw
  store i64 %t838, i64* %_v_root_id, align 8
  %t841_i64 = load i64, i64* %_v_flag_emit_ast, align 8
  %t841 = trunc i64 %t841_i64 to i1
  %t841_vsta = load i8*, i8** %_v_flag_emit_ast__sta, align 8
  %t841_vmsg = load i8*, i8** %_v_flag_emit_ast__msg, align 8
  br i1 %t841, label %ft_62, label %route_arm_840
ft_62:
  %t842_i64 = load i64, i64* %_v_parse_res, align 8
  %t842 = inttoptr i64 %t842_i64 to i8*
  %t842_vsta = load i8*, i8** %_v_parse_res__sta, align 8
  %t842_vmsg = load i8*, i8** %_v_parse_res__msg, align 8
  %t843_res = call %flux.result @f_parseDumpAst(i8* %t842)
  %t843_val = extractvalue %flux.result %t843_res, 1
  %t843 = inttoptr i64 %t843_val to i8*
  %st_92 = ptrtoint i8* %t843 to i64
  store i64 %st_92, i64* %_v_ast_json, align 8
  %t844 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.123, i32 0, i32 0
  %t845_i64 = load i64, i64* %_v_input_file, align 8
  %t845 = inttoptr i64 %t845_i64 to i8*
  %t845_vsta = load i8*, i8** %_v_input_file__sta, align 8
  %t845_vmsg = load i8*, i8** %_v_input_file__msg, align 8
  %t846 = call i8* @flux_str_concat(i8* %t844, i8* %t845)
  %t847 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.124, i32 0, i32 0
  %t848 = call i8* @flux_str_concat(i8* %t846, i8* %t847)
  %t849_i64 = load i64, i64* %_v_ast_json, align 8
  %t849 = inttoptr i64 %t849_i64 to i8*
  %t849_vsta = load i8*, i8** %_v_ast_json__sta, align 8
  %t849_vmsg = load i8*, i8** %_v_ast_json__msg, align 8
  %t850 = call i64 @flux_std_io_write_file(i8* %t848, i8* %t849)
  br label %route_end_839
route_arm_840:
  br label %route_end_839
route_end_839:
  %t852_i64 = load i64, i64* %_v_arena, align 8
  %t852 = inttoptr i64 %t852_i64 to i8*
  %t852_vsta = load i8*, i8** %_v_arena__sta, align 8
  %t852_vmsg = load i8*, i8** %_v_arena__msg, align 8
  %t853 = load i64, i64* %_v_root_id, align 8
  %t853_vsta = load i8*, i8** %_v_root_id__sta, align 8
  %t853_vmsg = load i8*, i8** %_v_root_id__msg, align 8
  %t854_res = call %flux.result @f_semanticAnalyze(i8* %t852, i64 %t853)
  %t854_val = extractvalue %flux.result %t854_res, 1
  %t854 = inttoptr i64 %t854_val to i8*
  %st_93 = ptrtoint i8* %t854 to i64
  store i64 %st_93, i64* %_v_sem_report, align 8
  %t857_i64 = load i64, i64* %_v_sem_report, align 8
  %t857 = inttoptr i64 %t857_i64 to i8*
  %t857_vsta = load i8*, i8** %_v_sem_report__sta, align 8
  %t857_vmsg = load i8*, i8** %_v_sem_report__msg, align 8
  %t858 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.118, i32 0, i32 0
  %t859_raw = call i64 @flux_map_get(i8* %t857, i8* %t858)
  %t859 = icmp ne i64 %t859_raw, 0
  %t860 = xor i1 %t859, 1
  br i1 %t860, label %ft_63, label %route_arm_856
ft_63:
  %t861_i64 = load i64, i64* %_v_sem_report, align 8
  %t861 = inttoptr i64 %t861_i64 to i8*
  %t861_vsta = load i8*, i8** %_v_sem_report__sta, align 8
  %t861_vmsg = load i8*, i8** %_v_sem_report__msg, align 8
  %t862 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.125, i32 0, i32 0
  %t863_raw = call i64 @flux_map_get(i8* %t861, i8* %t862)
  %t863 = inttoptr i64 %t863_raw to i8*
  %st_94 = ptrtoint i8* %t863 to i64
  store i64 %st_94, i64* %_v_errors, align 8
  %t864_i64 = load i64, i64* %_v_errors, align 8
  %t864 = inttoptr i64 %t864_i64 to i8*
  %t864_vsta = load i8*, i8** %_v_errors__sta, align 8
  %t864_vmsg = load i8*, i8** %_v_errors__msg, align 8
  %t865 = call i64 @flux_list_len(i8* %t864)
  store i64 %t865, i64* %_v_n_err, align 8
  %t866 = add i64 0, 1
  store i64 %t866, i64* %_v_ei, align 8
  br label %loop_start_867
loop_start_867:
  %t870 = load i64, i64* %_v_ei, align 8
  %t870_vsta = load i8*, i8** %_v_ei__sta, align 8
  %t870_vmsg = load i8*, i8** %_v_ei__msg, align 8
  %t871 = load i64, i64* %_v_n_err, align 8
  %t871_vsta = load i8*, i8** %_v_n_err__sta, align 8
  %t871_vmsg = load i8*, i8** %_v_n_err__msg, align 8
  %t872 = icmp sgt i64 %t870, %t871
  br i1 %t872, label %ft_64, label %route_arm_869
ft_64:
  br label %loop_end_867
route_arm_869:
  %t874 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t875_i64 = load i64, i64* %_v_errors, align 8
  %t875 = inttoptr i64 %t875_i64 to i8*
  %t875_vsta = load i8*, i8** %_v_errors__sta, align 8
  %t875_vmsg = load i8*, i8** %_v_errors__msg, align 8
  %t876 = load i64, i64* %_v_ei, align 8
  %t876_vsta = load i8*, i8** %_v_ei__sta, align 8
  %t876_vmsg = load i8*, i8** %_v_ei__msg, align 8
  %t877_raw = call i64 @flux_list_get_val(i8* %t875, i64 %t876)
  %t877 = inttoptr i64 %t877_raw to i8*
  %cv_raw_5 = ptrtoint i8* %t877 to i64
  %cv_buf_5 = call i8* @flux_val_to_str(i64 %cv_raw_5)
  %t878 = call i8* @flux_str_concat(i8* %t874, i8* %cv_buf_5)
  %pr_sn_18 = icmp eq i8* %t878, null
  %pr_sc_18 = select i1 %pr_sn_18, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t878
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_18)
  call i32 @fflush(i8* null)
  %t879 = load i64, i64* %_v_ei, align 8
  %t879_vsta = load i8*, i8** %_v_ei__sta, align 8
  %t879_vmsg = load i8*, i8** %_v_ei__msg, align 8
  %t880 = add i64 0, 1
  %t881 = add i64 %t879, %t880
  store i64 %t881, i64* %_v_ei, align 8
  br label %route_end_868
route_end_868:
  br label %loop_start_867
loop_end_867:
  %t882 = add i64 0, 1
  %t883 = call i64 @flux_std_os_exit(i64 %t882)
  br label %route_end_855
route_arm_856:
  %t885_i64 = load i64, i64* %_v_arena, align 8
  %t885 = inttoptr i64 %t885_i64 to i8*
  %t885_vsta = load i8*, i8** %_v_arena__sta, align 8
  %t885_vmsg = load i8*, i8** %_v_arena__msg, align 8
  %t886 = load i64, i64* %_v_root_id, align 8
  %t886_vsta = load i8*, i8** %_v_root_id__sta, align 8
  %t886_vmsg = load i8*, i8** %_v_root_id__msg, align 8
  %t887_res = call %flux.result @f_fmirBuildFromAst(i8* %t885, i64 %t886)
  %t887_val = extractvalue %flux.result %t887_res, 1
  %t887 = inttoptr i64 %t887_val to i8*
  %st_98 = ptrtoint i8* %t887 to i64
  store i64 %st_98, i64* %_v_fmir_mod, align 8
  %t890_i64 = load i64, i64* %_v_flag_emit_fmir, align 8
  %t890 = trunc i64 %t890_i64 to i1
  %t890_vsta = load i8*, i8** %_v_flag_emit_fmir__sta, align 8
  %t890_vmsg = load i8*, i8** %_v_flag_emit_fmir__msg, align 8
  br i1 %t890, label %ft_65, label %route_arm_889
ft_65:
  %t891_i64 = load i64, i64* %_v_fmir_mod, align 8
  %t891 = inttoptr i64 %t891_i64 to i8*
  %t891_vsta = load i8*, i8** %_v_fmir_mod__sta, align 8
  %t891_vmsg = load i8*, i8** %_v_fmir_mod__msg, align 8
  %t892_res = call %flux.result @f_fmirDumpText(i8* %t891)
  %t892_val = extractvalue %flux.result %t892_res, 1
  %t892 = inttoptr i64 %t892_val to i8*
  %st_99 = ptrtoint i8* %t892 to i64
  store i64 %st_99, i64* %_v_fmir_dump, align 8
  br label %route_end_888
route_arm_889:
  br label %route_end_888
route_end_888:
  %t896_i64 = load i64, i64* %_v_flag_emit_wat, align 8
  %t896 = trunc i64 %t896_i64 to i1
  %t896_vsta = load i8*, i8** %_v_flag_emit_wat__sta, align 8
  %t896_vmsg = load i8*, i8** %_v_flag_emit_wat__msg, align 8
  %t897_i64 = load i64, i64* %_v_target, align 8
  %t897 = inttoptr i64 %t897_i64 to i8*
  %t897_vsta = load i8*, i8** %_v_target__sta, align 8
  %t897_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t898 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.16, i32 0, i32 0
  %t899_cmp = call i32 @flux_str_compare(i8* %t897, i8* %t898)
  %t899 = icmp ne i32 %t899_cmp, 0
  %t900 = and i1 %t896, %t899
  br i1 %t900, label %ft_66, label %route_arm_895
ft_66:
  %t901_i64 = load i64, i64* %_v_fmir_mod, align 8
  %t901 = inttoptr i64 %t901_i64 to i8*
  %t901_vsta = load i8*, i8** %_v_fmir_mod__sta, align 8
  %t901_vmsg = load i8*, i8** %_v_fmir_mod__msg, align 8
  %t902_i64 = load i64, i64* %_v_output_path, align 8
  %t902 = inttoptr i64 %t902_i64 to i8*
  %t902_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t902_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t903 = add i64 0, 0
  store i64 %t903, i64* %_v_wat_res, align 8
  br label %route_end_894
route_arm_895:
  br label %route_end_894
route_end_894:
  %t905 = call i8* @flux_map_build(i64 0)
  %st_101 = ptrtoint i8* %t905 to i64
  store i64 %st_101, i64* %_v_options, align 8
  %t906 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.126, i32 0, i32 0
  %t907_i64 = load i64, i64* %_v_output_path, align 8
  %t907 = inttoptr i64 %t907_i64 to i8*
  %t907_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t907_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %ms_col_1_i64 = load i64, i64* %_v_options, align 8
  %ms_col_1 = inttoptr i64 %ms_col_1_i64 to i8*
  %p_ms_1 = ptrtoint i8* %t907 to i64
  call i8* @flux_map_set(i8* %ms_col_1, i8* %t906, i64 4, i64 %p_ms_1)
  %t908 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.127, i32 0, i32 0
  %t909_i64 = load i64, i64* %_v_flag_no_run, align 8
  %t909 = trunc i64 %t909_i64 to i1
  %t909_vsta = load i8*, i8** %_v_flag_no_run__sta, align 8
  %t909_vmsg = load i8*, i8** %_v_flag_no_run__msg, align 8
  %ms_col_2_i64 = load i64, i64* %_v_options, align 8
  %ms_col_2 = inttoptr i64 %ms_col_2_i64 to i8*
  %p_ms_b_2 = zext i1 %t909 to i64
  call i8* @flux_map_set(i8* %ms_col_2, i8* %t908, i64 1, i64 %p_ms_b_2)
  %t910_i64 = load i64, i64* %_v_fmir_mod, align 8
  %t910 = inttoptr i64 %t910_i64 to i8*
  %t910_vsta = load i8*, i8** %_v_fmir_mod__sta, align 8
  %t910_vmsg = load i8*, i8** %_v_fmir_mod__msg, align 8
  %t911_i64 = load i64, i64* %_v_target, align 8
  %t911 = inttoptr i64 %t911_i64 to i8*
  %t911_vsta = load i8*, i8** %_v_target__sta, align 8
  %t911_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t912_i64 = load i64, i64* %_v_options, align 8
  %t912 = inttoptr i64 %t912_i64 to i8*
  %t912_vsta = load i8*, i8** %_v_options__sta, align 8
  %t912_vmsg = load i8*, i8** %_v_options__msg, align 8
  %t913_res = call %flux.result @f_backendCompile(i8* %t910, i8* %t911, i8* %t912)
  %t913_val = extractvalue %flux.result %t913_res, 1
  %t913 = inttoptr i64 %t913_val to i8*
  %st_102 = ptrtoint i8* %t913 to i64
  store i64 %st_102, i64* %_v_comp_res, align 8
  %t916_i64 = load i64, i64* %_v_comp_res, align 8
  %t916 = inttoptr i64 %t916_i64 to i8*
  %t916_vsta = load i8*, i8** %_v_comp_res__sta, align 8
  %t916_vmsg = load i8*, i8** %_v_comp_res__msg, align 8
  %t917 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.118, i32 0, i32 0
  %t918_raw = call i64 @flux_map_get(i8* %t916, i8* %t917)
  %t918 = icmp ne i64 %t918_raw, 0
  %t919 = xor i1 %t918, 1
  br i1 %t919, label %ft_67, label %route_arm_915
ft_67:
  %t920 = getelementptr inbounds [30 x i8], [30 x i8]* @.str.128, i32 0, i32 0
  %t921_i64 = load i64, i64* %_v_target, align 8
  %t921 = inttoptr i64 %t921_i64 to i8*
  %t921_vsta = load i8*, i8** %_v_target__sta, align 8
  %t921_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t922 = call i8* @flux_str_concat(i8* %t920, i8* %t921)
  %pr_sn_19 = icmp eq i8* %t922, null
  %pr_sc_19 = select i1 %pr_sn_19, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t922
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_19)
  call i32 @fflush(i8* null)
  %t923 = add i64 0, 1
  %t924 = call i64 @flux_std_os_exit(i64 %t923)
  br label %route_end_914
route_arm_915:
  br label %route_end_914
route_end_914:
  %t928_i64 = load i64, i64* %_v_target, align 8
  %t928 = inttoptr i64 %t928_i64 to i8*
  %t928_vsta = load i8*, i8** %_v_target__sta, align 8
  %t928_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t929 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.15, i32 0, i32 0
  %t930_cmp = call i32 @flux_str_compare(i8* %t928, i8* %t929)
  %t930 = icmp eq i32 %t930_cmp, 0
  %t931_i64 = load i64, i64* %_v_target, align 8
  %t931 = inttoptr i64 %t931_i64 to i8*
  %t931_vsta = load i8*, i8** %_v_target__sta, align 8
  %t931_vmsg = load i8*, i8** %_v_target__msg, align 8
  %t932 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.129, i32 0, i32 0
  %t933_cmp = call i32 @flux_str_compare(i8* %t931, i8* %t932)
  %t933 = icmp eq i32 %t933_cmp, 0
  %t934 = or i1 %t930, %t933
  br i1 %t934, label %ft_68, label %route_arm_927
ft_68:
  %t935 = getelementptr inbounds [65 x i8], [65 x i8]* @.str.130, i32 0, i32 0
  %t936_i64 = load i64, i64* %_v_output_path, align 8
  %t936 = inttoptr i64 %t936_i64 to i8*
  %t936_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t936_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t937 = call i8* @flux_str_concat(i8* %t935, i8* %t936)
  %t938 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.131, i32 0, i32 0
  %t939 = call i8* @flux_str_concat(i8* %t937, i8* %t938)
  %t940_i64 = load i64, i64* %_v_output_path, align 8
  %t940 = inttoptr i64 %t940_i64 to i8*
  %t940_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t940_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t941 = call i8* @flux_str_concat(i8* %t939, i8* %t940)
  %t942 = getelementptr inbounds [66 x i8], [66 x i8]* @.str.132, i32 0, i32 0
  %t943 = call i8* @flux_str_concat(i8* %t941, i8* %t942)
  %st_103 = ptrtoint i8* %t943 to i64
  store i64 %st_103, i64* %_v_clang_cmd, align 8
  %t944_i64 = load i64, i64* %_v_clang_cmd, align 8
  %t944 = inttoptr i64 %t944_i64 to i8*
  %t944_vsta = load i8*, i8** %_v_clang_cmd__sta, align 8
  %t944_vmsg = load i8*, i8** %_v_clang_cmd__msg, align 8
  %t945 = call i64 @flux_std_os_exec(i8* %t944)
  store i64 %t945, i64* %_v_cl_rc, align 8
  %t948 = load i64, i64* %_v_cl_rc, align 8
  %t948_vsta = load i8*, i8** %_v_cl_rc__sta, align 8
  %t948_vmsg = load i8*, i8** %_v_cl_rc__msg, align 8
  %t949 = add i64 0, 0
  %t950 = icmp ne i64 %t948, %t949
  br i1 %t950, label %ft_69, label %route_arm_947
ft_69:
  %t951 = load i64, i64* %_v_cl_rc, align 8
  %t951_vsta = load i8*, i8** %_v_cl_rc__sta, align 8
  %t951_vmsg = load i8*, i8** %_v_cl_rc__msg, align 8
  %t952 = call i64 @flux_std_os_exit(i64 %t951)
  br label %route_end_946
route_arm_947:
  %t954_i64 = load i64, i64* %_v_flag_no_run, align 8
  %t954 = trunc i64 %t954_i64 to i1
  %t954_vsta = load i8*, i8** %_v_flag_no_run__sta, align 8
  %t954_vmsg = load i8*, i8** %_v_flag_no_run__msg, align 8
  %t955 = xor i1 %t954, 1
  br i1 %t955, label %ft_70, label %route_arm_953
ft_70:
  %t956 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.63, i32 0, i32 0
  %t957_i64 = load i64, i64* %_v_output_path, align 8
  %t957 = inttoptr i64 %t957_i64 to i8*
  %t957_vsta = load i8*, i8** %_v_output_path__sta, align 8
  %t957_vmsg = load i8*, i8** %_v_output_path__msg, align 8
  %t958 = call i8* @flux_str_concat(i8* %t956, i8* %t957)
  %t959 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.133, i32 0, i32 0
  %t960 = call i8* @flux_str_concat(i8* %t958, i8* %t959)
  %t961_i64 = load i64, i64* %_v_arg_suffix, align 8
  %t961 = inttoptr i64 %t961_i64 to i8*
  %t961_vsta = load i8*, i8** %_v_arg_suffix__sta, align 8
  %t961_vmsg = load i8*, i8** %_v_arg_suffix__msg, align 8
  %t962 = call i8* @flux_str_concat(i8* %t960, i8* %t961)
  %t963 = call i64 @flux_std_os_exec(i8* %t962)
  store i64 %t963, i64* %_v_r_rc, align 8
  %t964 = load i64, i64* %_v_r_rc, align 8
  %t964_vsta = load i8*, i8** %_v_r_rc__sta, align 8
  %t964_vmsg = load i8*, i8** %_v_r_rc__msg, align 8
  %t965 = call i64 @flux_std_os_exit(i64 %t964)
  br label %route_end_946
route_arm_953:
  br label %route_end_946
route_end_946:
  br label %route_end_926
route_arm_927:
  br label %route_end_926
route_end_926:
  br label %route_end_855
route_end_855:
  br label %route_end_819
route_end_819:
  br label %route_end_328
route_end_328:
  br label %route_end_4
route_end_4:
  ret i32 0
}
