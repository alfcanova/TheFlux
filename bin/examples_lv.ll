; ModuleID = 'ExamplesLv'
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
@.str.40 = private unnamed_addr constant [8 x i8] c"windows\00", align 1
@.str.41 = private unnamed_addr constant [6 x i8] c"linux\00", align 1
@.str.42 = private unnamed_addr constant [7 x i8] c"darwin\00", align 1
@.str.43 = private unnamed_addr constant [10 x i8] c"Platform=\00", align 1
@.str.44 = private unnamed_addr constant [8 x i8] c"; Arch=\00", align 1
@.str.45 = private unnamed_addr constant [10 x i8] c"; Family=\00", align 1
@.str.46 = private unnamed_addr constant [8 x i8] c"; Host=\00", align 1
@.str.47 = private unnamed_addr constant [5 x i8] c"PID=\00", align 1
@.str.48 = private unnamed_addr constant [7 x i8] c"; CWD=\00", align 1
@.str.49 = private unnamed_addr constant [6 x i8] c"User=\00", align 1
@.str.50 = private unnamed_addr constant [8 x i8] c"; CPUs=\00", align 1
@.str.51 = private unnamed_addr constant [12 x i8] c"; TotalMem=\00", align 1
@.str.52 = private unnamed_addr constant [3 x i8] c"GB\00", align 1
@.str.53 = private unnamed_addr constant [16 x i8] c".\5Cbin\5Cfluxc.exe\00", align 1
@.str.54 = private unnamed_addr constant [14 x i8] c"bin\5Cfluxc.exe\00", align 1
@.str.55 = private unnamed_addr constant [17 x i8] c"..\5Cbin\5Cfluxc.exe\00", align 1
@.str.56 = private unnamed_addr constant [10 x i8] c"fluxc.exe\00", align 1
@.str.57 = private unnamed_addr constant [6 x i8] c"fluxc\00", align 1
@.str.58 = private unnamed_addr constant [15 x i8] c"examples\5CCanon\00", align 1
@.str.59 = private unnamed_addr constant [17 x i8] c".\5Cexamples\5CCanon\00", align 1
@.str.60 = private unnamed_addr constant [18 x i8] c"..\5Cexamples\5CCanon\00", align 1
@.str.61 = private unnamed_addr constant [6 x i8] c"Canon\00", align 1
@.str.62 = private unnamed_addr constant [40 x i8] c"cmd /c if not exist t_llvm mkdir t_llvm\00", align 1
@.str.63 = private unnamed_addr constant [34 x i8] c"cmd /c if not exist dbs mkdir dbs\00", align 1
@.str.64 = private unnamed_addr constant [24 x i8] c"t_stdin_interactive.tmp\00", align 1
@.str.65 = private unnamed_addr constant [46 x i8] c"Ana\0A30\0A9.99\0Atrue\0AA\0A2+3i\0A2026-08-28T12:00:00Z\0A\00", align 1
@.str.66 = private unnamed_addr constant [21 x i8] c"t_stdin_contract.tmp\00", align 1
@.str.67 = private unnamed_addr constant [12 x i8] c"andre\0Aluiz\0A\00", align 1
@.str.68 = private unnamed_addr constant [17 x i8] c"t_stdin_dado.tmp\00", align 1
@.str.69 = private unnamed_addr constant [6 x i8] c"dado\0A\00", align 1
@.str.70 = private unnamed_addr constant [18 x i8] c"t_stdin_empty.tmp\00", align 1
@.str.71 = private unnamed_addr constant [19 x i8] c"cmd /c dir /b /on \00", align 1
@.str.72 = private unnamed_addr constant [27 x i8] c"\5C*.flux > t_canon_list.tmp\00", align 1
@.str.73 = private unnamed_addr constant [17 x i8] c"t_canon_list.tmp\00", align 1
@.str.74 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.75 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.76 = private unnamed_addr constant [2 x i8] c"\5C\00", align 1
@.str.77 = private unnamed_addr constant [11 x i8] c"input.flux\00", align 1
@.str.78 = private unnamed_addr constant [20 x i8] c"ExampleOfInput.flux\00", align 1
@.str.79 = private unnamed_addr constant [42 x i8] c"ExampleOfUseIoStdLib_IoInputContract.flux\00", align 1
@.str.80 = private unnamed_addr constant [9 x i8] c"DbStdLib\00", align 1
@.str.81 = private unnamed_addr constant [120 x i8] c"cmd /c del /q /f dbs\5Cflux_*.db* dbs\5Cflux_*.kv dbs\5Cflux_*.unqlite dbs\5Cflux_*.duckdb dbs\5Cflux_*.kuzu dbs\5Cflux_*.obx 2>nul\00", align 1
@.str.82 = private unnamed_addr constant [8 x i8] c"t_llvm\5C\00", align 1
@.str.83 = private unnamed_addr constant [4 x i8] c".ll\00", align 1
@.str.84 = private unnamed_addr constant [5 x i8] c".exe\00", align 1
@.str.85 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.86 = private unnamed_addr constant [14 x i8] c" --target lv \00", align 1
@.str.87 = private unnamed_addr constant [5 x i8] c" -o \00", align 1
@.str.88 = private unnamed_addr constant [13 x i8] c" --no-run < \00", align 1
@.str.89 = private unnamed_addr constant [20 x i8] c" > t_lv_c.tmp 2>&1\22\00", align 1
@.str.90 = private unnamed_addr constant [11 x i8] c"t_lv_c.tmp\00", align 1
@.str.91 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.92 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.93 = private unnamed_addr constant [18 x i8] c" (.ll nao gerado)\00", align 1
@.str.94 = private unnamed_addr constant [49 x i8] c" (clang nao encontrado ou executavel nao gerado)\00", align 1
@.str.95 = private unnamed_addr constant [4 x i8] c" < \00", align 1
@.str.96 = private unnamed_addr constant [18 x i8] c" > t_lv.tmp 2>&1\22\00", align 1
@.str.97 = private unnamed_addr constant [9 x i8] c"t_lv.tmp\00", align 1
@.str.98 = private unnamed_addr constant [5 x i8] c"  | \00", align 1
@.str.99 = private unnamed_addr constant [7 x i8] c"  OK  \00", align 1
@.str.100 = private unnamed_addr constant [12 x i8] c"(exit code \00", align 1
@.str.101 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.102 = private unnamed_addr constant [74 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_lv_c.tmp t_lv.tmp t_canon_list.tmp 2>nul\00", align 1
@.str.103 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.104 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1


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

define %flux.result @uf_IoStdLib__echo(i64 %in_1) {
fn_entry:
  %_v_text = alloca i64, align 8
  %_v_text__sta = alloca i8*, align 8
  %_v_text__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_text__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_text__msg, align 8
  store i64 %in_1, i64* %_v_text, align 8
  %t1_i64 = load i64, i64* %_v_text, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_text__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_text__msg, align 8
  %pr_sn_1 = icmp eq i8* %t1, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t1
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  %t2_i64 = load i64, i64* %_v_text, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_text__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_text__msg, align 8
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__printLn(i64 %in_1) {
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
  %pr_praw_1 = ptrtoint i8* %t1 to i64
  call void @flux_val_print(i64 %pr_praw_1)
  call i32 @fflush(i8* null)
  %t2_i64 = load i64, i64* %_v_value, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_value__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__printLine(i64 %in_1) {
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
  %pr_praw_1 = ptrtoint i8* %t1 to i64
  call void @flux_val_print(i64 %pr_praw_1)
  call i32 @fflush(i8* null)
  %t2_i64 = load i64, i64* %_v_value, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_value__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__printErr(i64 %in_1) {
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
  %t2 = add i64 0, 0
  %t3_i64 = load i64, i64* %_v_value, align 8
  %t3 = inttoptr i64 %t3_i64 to i8*
  %t3_vsta = load i8*, i8** %_v_value__sta, align 8
  %t3_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t3 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readLn(i64 %in_1) {
fn_entry:
  %_v_prompt = alloca i64, align 8
  %_v_prompt__sta = alloca i8*, align 8
  %_v_prompt__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_prompt__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_prompt__msg, align 8
  %_v_line = alloca i64, align 8
  %_v_line__sta = alloca i8*, align 8
  %_v_line__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_line__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_line__msg, align 8
  store i64 %in_1, i64* %_v_prompt, align 8
  %t1_i64 = load i64, i64* %_v_prompt, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_prompt__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_prompt__msg, align 8
  %t2 = call i8* @flux_runtime_input_string(i8* %t1, i8* null)
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_line, align 8
  %t3_i64 = load i64, i64* %_v_line, align 8
  %t3 = inttoptr i64 %t3_i64 to i8*
  %t3_vsta = load i8*, i8** %_v_line__sta, align 8
  %t3_vmsg = load i8*, i8** %_v_line__msg, align 8
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t3 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readLine(i64 %in_1) {
fn_entry:
  %_v_prompt = alloca i64, align 8
  %_v_prompt__sta = alloca i8*, align 8
  %_v_prompt__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_prompt__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_prompt__msg, align 8
  %_v_line = alloca i64, align 8
  %_v_line__sta = alloca i8*, align 8
  %_v_line__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_line__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_line__msg, align 8
  store i64 %in_1, i64* %_v_prompt, align 8
  %t1_i64 = load i64, i64* %_v_prompt, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_prompt__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_prompt__msg, align 8
  %t2 = call i8* @flux_runtime_input_string(i8* %t1, i8* null)
  %st_1 = ptrtoint i8* %t2 to i64
  store i64 %st_1, i64* %_v_line, align 8
  %t3_i64 = load i64, i64* %_v_line, align 8
  %t3 = inttoptr i64 %t3_i64 to i8*
  %t3_vsta = load i8*, i8** %_v_line__sta, align 8
  %t3_vmsg = load i8*, i8** %_v_line__msg, align 8
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t3 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readFile(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = call i8* @flux_std_io_read_file(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__writeFile(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_content = alloca i64, align 8
  %_v_content__sta = alloca i8*, align 8
  %_v_content__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_content__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_content__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_content, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_content, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_content__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_content__msg, align 8
  %t3 = call i64 @flux_std_io_write_file(i8* %t1, i8* %t2)
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__appendFile(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_content = alloca i64, align 8
  %_v_content__sta = alloca i8*, align 8
  %_v_content__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_content__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_content__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_content, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_content, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_content__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_content__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__deleteFile(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = call i64 @flux_std_io_delete_file(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__copyFile(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src = alloca i64, align 8
  %_v_src__sta = alloca i8*, align 8
  %_v_src__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src__msg, align 8
  %_v_dst = alloca i64, align 8
  %_v_dst__sta = alloca i8*, align 8
  %_v_dst__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst__msg, align 8
  store i64 %in_1, i64* %_v_src, align 8
  store i64 %in_2, i64* %_v_dst, align 8
  %t1_i64 = load i64, i64* %_v_src, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__moveFile(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src = alloca i64, align 8
  %_v_src__sta = alloca i8*, align 8
  %_v_src__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src__msg, align 8
  %_v_dst = alloca i64, align 8
  %_v_dst__sta = alloca i8*, align 8
  %_v_dst__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst__msg, align 8
  store i64 %in_1, i64* %_v_src, align 8
  store i64 %in_2, i64* %_v_dst, align 8
  %t1_i64 = load i64, i64* %_v_src, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__fileExists(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = call i64 @flux_std_io_file_exists(i8* %t1)
  %t2 = trunc i64 %t2_i64 to i1
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__fileSize(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__fileIsEmpty(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_sz = alloca i64, align 8
  %_v_sz__sta = alloca i8*, align 8
  %_v_sz__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_sz__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_sz__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  store i64 %t2, i64* %_v_sz, align 8
  %t3 = load i64, i64* %_v_sz, align 8
  %t3_vsta = load i8*, i8** %_v_sz__sta, align 8
  %t3_vmsg = load i8*, i8** %_v_sz__msg, align 8
  %t4 = add i64 0, 0
  %t5 = icmp eq i64 %t3, %t4
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t5 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t6, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readLines(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__writeLines(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_lines = alloca i64, align 8
  %_v_lines__sta = alloca i8*, align 8
  %_v_lines__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_lines__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_lines__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_lines, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_lines, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_lines__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_lines__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__appendLines(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_lines = alloca i64, align 8
  %_v_lines__sta = alloca i8*, align 8
  %_v_lines__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_lines__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_lines__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_lines, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_lines, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_lines__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_lines__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__dirExists(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = call i64 @flux_std_io_dir_exists(i8* %t1)
  %t2 = trunc i64 %t2_i64 to i1
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = zext i1 %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__createDir(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__removeDir(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__listDir(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = call i8* @flux_std_io_list_dir(i8* %t1, i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__pathBaseName(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = call i8* @flux_std_io_path_base_name(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__pathDirName(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = call i8* @flux_std_io_path_dir_name(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__pathExtension(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__pathJoin(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_dir = alloca i64, align 8
  %_v_dir__sta = alloca i8*, align 8
  %_v_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dir__msg, align 8
  %_v_file = alloca i64, align 8
  %_v_file__sta = alloca i8*, align 8
  %_v_file__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_file__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_file__msg, align 8
  store i64 %in_1, i64* %_v_dir, align 8
  store i64 %in_2, i64* %_v_file, align 8
  %t1_i64 = load i64, i64* %_v_dir, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_dir__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_dir__msg, align 8
  %t2_i64 = load i64, i64* %_v_file, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_file__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_file__msg, align 8
  %t3 = call i8* @flux_std_io_path_join(i8* %t1, i8* %t2)
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t3 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readBinaryFile(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__writeBinaryFile(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_content = alloca i64, align 8
  %_v_content__sta = alloca i8*, align 8
  %_v_content__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_content__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_content__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_content, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_content, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_content__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_content__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readHexFile(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = call i8* @flux_std_io_read_hex_file(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__writeHexFile(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_hex_content = alloca i64, align 8
  %_v_hex_content__sta = alloca i8*, align 8
  %_v_hex_content__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_hex_content__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_hex_content__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_hex_content, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_hex_content, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_hex_content__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_hex_content__msg, align 8
  %t3 = call i8* @flux_std_io_write_hex_file(i8* %t1, i8* %t2)
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t3 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__readBase64File(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__writeBase64File(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  %_v_b64_content = alloca i64, align 8
  %_v_b64_content__sta = alloca i8*, align 8
  %_v_b64_content__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_b64_content__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_b64_content__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  store i64 %in_2, i64* %_v_b64_content, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_b64_content, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_b64_content__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_b64_content__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveZip(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_zip = alloca i64, align 8
  %_v_dst_zip__sta = alloca i8*, align 8
  %_v_dst_zip__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_zip__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_zip__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_zip, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_zip, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_zip__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_zip__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveUnzip(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_zip = alloca i64, align 8
  %_v_src_zip__sta = alloca i8*, align 8
  %_v_src_zip__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_zip__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_zip__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_zip, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_zip, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_zip__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_zip__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveTar(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_tar = alloca i64, align 8
  %_v_dst_tar__sta = alloca i8*, align 8
  %_v_dst_tar__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_tar__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_tar__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_tar, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_tar, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_tar__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_tar__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractTar(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_tar = alloca i64, align 8
  %_v_src_tar__sta = alloca i8*, align 8
  %_v_src_tar__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_tar__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_tar__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_tar, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_tar, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_tar__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_tar__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveTarGz(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_targz = alloca i64, align 8
  %_v_dst_targz__sta = alloca i8*, align 8
  %_v_dst_targz__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_targz__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_targz__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_targz, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_targz, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_targz__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_targz__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractTarGz(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_targz = alloca i64, align 8
  %_v_src_targz__sta = alloca i8*, align 8
  %_v_src_targz__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_targz__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_targz__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_targz, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_targz, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_targz__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_targz__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveTarBz2(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_tarbz2 = alloca i64, align 8
  %_v_dst_tarbz2__sta = alloca i8*, align 8
  %_v_dst_tarbz2__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_tarbz2__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_tarbz2__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_tarbz2, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_tarbz2, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_tarbz2__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_tarbz2__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractTarBz2(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_tarbz2 = alloca i64, align 8
  %_v_src_tarbz2__sta = alloca i8*, align 8
  %_v_src_tarbz2__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_tarbz2__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_tarbz2__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_tarbz2, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_tarbz2, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_tarbz2__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_tarbz2__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveTarXz(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_tarxz = alloca i64, align 8
  %_v_dst_tarxz__sta = alloca i8*, align 8
  %_v_dst_tarxz__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_tarxz__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_tarxz__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_tarxz, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_tarxz, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_tarxz__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_tarxz__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractTarXz(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_tarxz = alloca i64, align 8
  %_v_src_tarxz__sta = alloca i8*, align 8
  %_v_src_tarxz__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_tarxz__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_tarxz__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_tarxz, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_tarxz, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_tarxz__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_tarxz__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveTarZst(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_tarzst = alloca i64, align 8
  %_v_dst_tarzst__sta = alloca i8*, align 8
  %_v_dst_tarzst__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_tarzst__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_tarzst__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_tarzst, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_tarzst, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_tarzst__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_tarzst__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractTarZst(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_tarzst = alloca i64, align 8
  %_v_src_tarzst__sta = alloca i8*, align 8
  %_v_src_tarzst__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_tarzst__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_tarzst__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_tarzst, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_tarzst, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_tarzst__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_tarzst__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveCreate7z(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_path = alloca i64, align 8
  %_v_src_path__sta = alloca i8*, align 8
  %_v_src_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_path__msg, align 8
  %_v_dst_7z = alloca i64, align 8
  %_v_dst_7z__sta = alloca i8*, align 8
  %_v_dst_7z__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_7z__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_7z__msg, align 8
  store i64 %in_1, i64* %_v_src_path, align 8
  store i64 %in_2, i64* %_v_dst_7z, align 8
  %t1_i64 = load i64, i64* %_v_src_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_7z, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_7z__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_7z__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtract7z(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_7z = alloca i64, align 8
  %_v_src_7z__sta = alloca i8*, align 8
  %_v_src_7z__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_7z__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_7z__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_7z, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_7z, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_7z__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_7z__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractRar(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_src_rar = alloca i64, align 8
  %_v_src_rar__sta = alloca i8*, align 8
  %_v_src_rar__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_src_rar__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_src_rar__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_src_rar, align 8
  store i64 %in_2, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_src_rar, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_src_rar__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_src_rar__msg, align 8
  %t2_i64 = load i64, i64* %_v_dst_dir, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveListFiles(i64 %in_1) {
fn_entry:
  %_v_archive_path = alloca i64, align 8
  %_v_archive_path__sta = alloca i8*, align 8
  %_v_archive_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_archive_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_archive_path__msg, align 8
  store i64 %in_1, i64* %_v_archive_path, align 8
  %t1_i64 = load i64, i64* %_v_archive_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_archive_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_archive_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveExtractFile(i64 %in_1, i64 %in_2, i64 %in_3) {
fn_entry:
  %_v_archive_path = alloca i64, align 8
  %_v_archive_path__sta = alloca i8*, align 8
  %_v_archive_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_archive_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_archive_path__msg, align 8
  %_v_entry_name = alloca i64, align 8
  %_v_entry_name__sta = alloca i8*, align 8
  %_v_entry_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_entry_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_entry_name__msg, align 8
  %_v_dst_dir = alloca i64, align 8
  %_v_dst_dir__sta = alloca i8*, align 8
  %_v_dst_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_dst_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_dst_dir__msg, align 8
  store i64 %in_1, i64* %_v_archive_path, align 8
  store i64 %in_2, i64* %_v_entry_name, align 8
  store i64 %in_3, i64* %_v_dst_dir, align 8
  %t1_i64 = load i64, i64* %_v_archive_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_archive_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_archive_path__msg, align 8
  %t2_i64 = load i64, i64* %_v_entry_name, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_entry_name__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_entry_name__msg, align 8
  %t3_i64 = load i64, i64* %_v_dst_dir, align 8
  %t3 = inttoptr i64 %t3_i64 to i8*
  %t3_vsta = load i8*, i8** %_v_dst_dir__sta, align 8
  %t3_vmsg = load i8*, i8** %_v_dst_dir__msg, align 8
  %t4 = add i64 0, 0
  %t5 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t4, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t5, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveIsArchive(i64 %in_1) {
fn_entry:
  %_v_file_path = alloca i64, align 8
  %_v_file_path__sta = alloca i8*, align 8
  %_v_file_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_file_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_file_path__msg, align 8
  store i64 %in_1, i64* %_v_file_path, align 8
  %t1_i64 = load i64, i64* %_v_file_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_file_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_file_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_IoStdLib__archiveDetectFormat(i64 %in_1) {
fn_entry:
  %_v_file_path = alloca i64, align 8
  %_v_file_path__sta = alloca i8*, align 8
  %_v_file_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_file_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_file_path__msg, align 8
  store i64 %in_1, i64* %_v_file_path, align 8
  %t1_i64 = load i64, i64* %_v_file_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_file_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_file_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osGetEnv(i64 %in_1) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osGetEnvOrDefault(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  %_v_default_value = alloca i64, align 8
  %_v_default_value__sta = alloca i8*, align 8
  %_v_default_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_default_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_default_value__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  store i64 %in_2, i64* %_v_default_value, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2_i64 = load i64, i64* %_v_default_value, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_default_value__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_default_value__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osSetEnv(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  store i64 %in_2, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2_i64 = load i64, i64* %_v_value, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_value__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osHasEnv(i64 %in_1) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osUnsetEnv(i64 %in_1) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osListEnv() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__getEnv(i64 %in_1) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__getEnvOrDefault(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  %_v_default_value = alloca i64, align 8
  %_v_default_value__sta = alloca i8*, align 8
  %_v_default_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_default_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_default_value__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  store i64 %in_2, i64* %_v_default_value, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2_i64 = load i64, i64* %_v_default_value, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_default_value__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_default_value__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__setEnv(i64 %in_1, i64 %in_2) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  %_v_value = alloca i64, align 8
  %_v_value__sta = alloca i8*, align 8
  %_v_value__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_value__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_value__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  store i64 %in_2, i64* %_v_value, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2_i64 = load i64, i64* %_v_value, align 8
  %t2 = inttoptr i64 %t2_i64 to i8*
  %t2_vsta = load i8*, i8** %_v_value__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_value__msg, align 8
  %t3 = add i64 0, 0
  %t4 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t3, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t4, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__hasEnv(i64 %in_1) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__unsetEnv(i64 %in_1) {
fn_entry:
  %_v_name = alloca i64, align 8
  %_v_name__sta = alloca i8*, align 8
  %_v_name__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_name__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_name__msg, align 8
  store i64 %in_1, i64* %_v_name, align 8
  %t1_i64 = load i64, i64* %_v_name, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_name__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_name__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__listEnv() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osPlatform() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osArch() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osFamily() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osHostname() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osLineSeparator() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osPathSeparator() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osDirSeparator() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osIsWindows() {
fn_entry:
  %_v_p = alloca i64, align 8
  %_v_p__sta = alloca i8*, align 8
  %_v_p__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_p__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_p__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_p, align 8
  %t2 = load i64, i64* %_v_p, align 8
  %t2_vsta = load i8*, i8** %_v_p__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_p__msg, align 8
  %t3 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.40, i32 0, i32 0
  %cmp_p1_1 = inttoptr i64 %t2 to i8*
  %t4_cmp = call i32 @flux_str_compare(i8* %cmp_p1_1, i8* %t3)
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

define %flux.result @uf_OsStdLib__osIsLinux() {
fn_entry:
  %_v_p = alloca i64, align 8
  %_v_p__sta = alloca i8*, align 8
  %_v_p__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_p__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_p__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_p, align 8
  %t2 = load i64, i64* %_v_p, align 8
  %t2_vsta = load i8*, i8** %_v_p__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_p__msg, align 8
  %t3 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.41, i32 0, i32 0
  %cmp_p1_1 = inttoptr i64 %t2 to i8*
  %t4_cmp = call i32 @flux_str_compare(i8* %cmp_p1_1, i8* %t3)
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

define %flux.result @uf_OsStdLib__osIsDarwin() {
fn_entry:
  %_v_p = alloca i64, align 8
  %_v_p__sta = alloca i8*, align 8
  %_v_p__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_p__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_p__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_p, align 8
  %t2 = load i64, i64* %_v_p, align 8
  %t2_vsta = load i8*, i8** %_v_p__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_p__msg, align 8
  %t3 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.42, i32 0, i32 0
  %cmp_p1_1 = inttoptr i64 %t2 to i8*
  %t4_cmp = call i32 @flux_str_compare(i8* %cmp_p1_1, i8* %t3)
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

define %flux.result @uf_OsStdLib__osInfoSummary() {
fn_entry:
  %_v_p = alloca i64, align 8
  %_v_p__sta = alloca i8*, align 8
  %_v_p__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_p__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_p__msg, align 8
  %_v_a = alloca i64, align 8
  %_v_a__sta = alloca i8*, align 8
  %_v_a__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_a__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_a__msg, align 8
  %_v_f = alloca i64, align 8
  %_v_f__sta = alloca i8*, align 8
  %_v_f__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_f__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_f__msg, align 8
  %_v_h = alloca i64, align 8
  %_v_h__sta = alloca i8*, align 8
  %_v_h__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_h__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_h__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_p, align 8
  %t2 = add i64 0, 0
  store i64 %t2, i64* %_v_a, align 8
  %t3 = add i64 0, 0
  store i64 %t3, i64* %_v_f, align 8
  %t4 = add i64 0, 0
  store i64 %t4, i64* %_v_h, align 8
  %t5 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.43, i32 0, i32 0
  %t6 = load i64, i64* %_v_p, align 8
  %t6_vsta = load i8*, i8** %_v_p__sta, align 8
  %t6_vmsg = load i8*, i8** %_v_p__msg, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t6)
  %t7 = call i8* @flux_str_concat(i8* %t5, i8* %cv_buf_1)
  %t8 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.44, i32 0, i32 0
  %t9 = call i8* @flux_str_concat(i8* %t7, i8* %t8)
  %t10 = load i64, i64* %_v_a, align 8
  %t10_vsta = load i8*, i8** %_v_a__sta, align 8
  %t10_vmsg = load i8*, i8** %_v_a__msg, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t10)
  %t11 = call i8* @flux_str_concat(i8* %t9, i8* %cv_buf_2)
  %t12 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.45, i32 0, i32 0
  %t13 = call i8* @flux_str_concat(i8* %t11, i8* %t12)
  %t14 = load i64, i64* %_v_f, align 8
  %t14_vsta = load i8*, i8** %_v_f__sta, align 8
  %t14_vmsg = load i8*, i8** %_v_f__msg, align 8
  %cv_buf_3 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_3, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t14)
  %t15 = call i8* @flux_str_concat(i8* %t13, i8* %cv_buf_3)
  %t16 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.46, i32 0, i32 0
  %t17 = call i8* @flux_str_concat(i8* %t15, i8* %t16)
  %t18 = load i64, i64* %_v_h, align 8
  %t18_vsta = load i8*, i8** %_v_h__sta, align 8
  %t18_vmsg = load i8*, i8** %_v_h__msg, align 8
  %cv_buf_4 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_4, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t18)
  %t19 = call i8* @flux_str_concat(i8* %t17, i8* %cv_buf_4)
  %t20 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t19 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t20, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__platform() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__arch() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__family() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__hostname() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__lineSeparator() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__pathSeparator() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__dirSeparator() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osGetPid() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osGetParentPid() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osCwd() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osChdir(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osExec(i64 %in_1) {
fn_entry:
  %_v_command = alloca i64, align 8
  %_v_command__sta = alloca i8*, align 8
  %_v_command__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_command__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_command__msg, align 8
  store i64 %in_1, i64* %_v_command, align 8
  %t1_i64 = load i64, i64* %_v_command, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_command__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_command__msg, align 8
  %t2 = call i64 @flux_std_os_exec(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osExecOutput(i64 %in_1) {
fn_entry:
  %_v_command = alloca i64, align 8
  %_v_command__sta = alloca i8*, align 8
  %_v_command__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_command__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_command__msg, align 8
  store i64 %in_1, i64* %_v_command, align 8
  %t1_i64 = load i64, i64* %_v_command, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_command__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_command__msg, align 8
  %t2 = call i8* @flux_std_os_exec_output(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osSleep(i64 %in_1) {
fn_entry:
  %_v_milliseconds = alloca i64, align 8
  %_v_milliseconds__sta = alloca i8*, align 8
  %_v_milliseconds__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_milliseconds__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_milliseconds__msg, align 8
  store i64 %in_1, i64* %_v_milliseconds, align 8
  %t1 = load i64, i64* %_v_milliseconds, align 8
  %t1_vsta = load i8*, i8** %_v_milliseconds__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_milliseconds__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osProcessSummary() {
fn_entry:
  %_v_p = alloca i64, align 8
  %_v_p__sta = alloca i8*, align 8
  %_v_p__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_p__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_p__msg, align 8
  %_v_c = alloca i64, align 8
  %_v_c__sta = alloca i8*, align 8
  %_v_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_p, align 8
  %t2 = add i64 0, 0
  store i64 %t2, i64* %_v_c, align 8
  %t3 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.47, i32 0, i32 0
  %t4 = load i64, i64* %_v_p, align 8
  %t4_vsta = load i8*, i8** %_v_p__sta, align 8
  %t4_vmsg = load i8*, i8** %_v_p__msg, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t4)
  %t5 = call i8* @flux_str_concat(i8* %t3, i8* %cv_buf_1)
  %t6 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.48, i32 0, i32 0
  %t7 = call i8* @flux_str_concat(i8* %t5, i8* %t6)
  %t8 = load i64, i64* %_v_c, align 8
  %t8_vsta = load i8*, i8** %_v_c__sta, align 8
  %t8_vmsg = load i8*, i8** %_v_c__msg, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t8)
  %t9 = call i8* @flux_str_concat(i8* %t7, i8* %cv_buf_2)
  %t10 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t9 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t10, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__getPid() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__getParentPid() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__cwd() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__chdir(i64 %in_1) {
fn_entry:
  %_v_path = alloca i64, align 8
  %_v_path__sta = alloca i8*, align 8
  %_v_path__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_path__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_path__msg, align 8
  store i64 %in_1, i64* %_v_path, align 8
  %t1_i64 = load i64, i64* %_v_path, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_path__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_path__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__exec(i64 %in_1) {
fn_entry:
  %_v_command = alloca i64, align 8
  %_v_command__sta = alloca i8*, align 8
  %_v_command__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_command__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_command__msg, align 8
  store i64 %in_1, i64* %_v_command, align 8
  %t1_i64 = load i64, i64* %_v_command, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_command__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_command__msg, align 8
  %t2 = call i64 @flux_std_os_exec(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__execOutput(i64 %in_1) {
fn_entry:
  %_v_command = alloca i64, align 8
  %_v_command__sta = alloca i8*, align 8
  %_v_command__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_command__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_command__msg, align 8
  store i64 %in_1, i64* %_v_command, align 8
  %t1_i64 = load i64, i64* %_v_command, align 8
  %t1 = inttoptr i64 %t1_i64 to i8*
  %t1_vsta = load i8*, i8** %_v_command__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_command__msg, align 8
  %t2 = call i8* @flux_std_os_exec_output(i8* %t1)
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t2 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__sleep(i64 %in_1) {
fn_entry:
  %_v_milliseconds = alloca i64, align 8
  %_v_milliseconds__sta = alloca i8*, align 8
  %_v_milliseconds__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_milliseconds__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_milliseconds__msg, align 8
  store i64 %in_1, i64* %_v_milliseconds, align 8
  %t1 = load i64, i64* %_v_milliseconds, align 8
  %t1_vsta = load i8*, i8** %_v_milliseconds__sta, align 8
  %t1_vmsg = load i8*, i8** %_v_milliseconds__msg, align 8
  %t2 = add i64 0, 0
  %t3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t2, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t3, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osUserName() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osHomeDir() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osTempDir() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osCpuCount() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osUptime() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osMemoryTotal() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osMemoryFree() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osMemoryTotalMb() {
fn_entry:
  %_v_m = alloca i64, align 8
  %_v_m__sta = alloca i8*, align 8
  %_v_m__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_m__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_m__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_m, align 8
  %t2 = load i64, i64* %_v_m, align 8
  %t2_vsta = load i8*, i8** %_v_m__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_m__msg, align 8
  %t3 = add i64 0, 1048576
  %t4_dz = icmp eq i64 %t3, 0
  %t4_sd = select i1 %t4_dz, i64 1, i64 %t3
  %t4_qt = sdiv i64 %t2, %t4_sd
  %t4 = select i1 %t4_dz, i64 0, i64 %t4_qt
  %t4_dsta = select i1 %t4_dz, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0)
  store i64 %t4, i64* %_v_res, align 8
  store i8* %t4_dsta, i8** %_v_res__sta, align 8
  %t5 = load i64, i64* %_v_res, align 8
  %t5_vsta = load i8*, i8** %_v_res__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t5, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t6, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osMemoryTotalGb() {
fn_entry:
  %_v_m = alloca i64, align 8
  %_v_m__sta = alloca i8*, align 8
  %_v_m__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_m__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_m__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_m, align 8
  %t2 = load i64, i64* %_v_m, align 8
  %t2_vsta = load i8*, i8** %_v_m__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_m__msg, align 8
  %t3 = add i64 0, 1073741824
  %t4_dz = icmp eq i64 %t3, 0
  %t4_sd = select i1 %t4_dz, i64 1, i64 %t3
  %t4_qt = sdiv i64 %t2, %t4_sd
  %t4 = select i1 %t4_dz, i64 0, i64 %t4_qt
  %t4_dsta = select i1 %t4_dz, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0)
  store i64 %t4, i64* %_v_res, align 8
  store i8* %t4_dsta, i8** %_v_res__sta, align 8
  %t5 = load i64, i64* %_v_res, align 8
  %t5_vsta = load i8*, i8** %_v_res__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t5, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t6, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osMemoryFreeMb() {
fn_entry:
  %_v_m = alloca i64, align 8
  %_v_m__sta = alloca i8*, align 8
  %_v_m__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_m__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_m__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_m, align 8
  %t2 = load i64, i64* %_v_m, align 8
  %t2_vsta = load i8*, i8** %_v_m__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_m__msg, align 8
  %t3 = add i64 0, 1048576
  %t4_dz = icmp eq i64 %t3, 0
  %t4_sd = select i1 %t4_dz, i64 1, i64 %t3
  %t4_qt = sdiv i64 %t2, %t4_sd
  %t4 = select i1 %t4_dz, i64 0, i64 %t4_qt
  %t4_dsta = select i1 %t4_dz, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0)
  store i64 %t4, i64* %_v_res, align 8
  store i8* %t4_dsta, i8** %_v_res__sta, align 8
  %t5 = load i64, i64* %_v_res, align 8
  %t5_vsta = load i8*, i8** %_v_res__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t5, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t6, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osMemoryFreeGb() {
fn_entry:
  %_v_m = alloca i64, align 8
  %_v_m__sta = alloca i8*, align 8
  %_v_m__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_m__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_m__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_m, align 8
  %t2 = load i64, i64* %_v_m, align 8
  %t2_vsta = load i8*, i8** %_v_m__sta, align 8
  %t2_vmsg = load i8*, i8** %_v_m__msg, align 8
  %t3 = add i64 0, 1073741824
  %t4_dz = icmp eq i64 %t3, 0
  %t4_sd = select i1 %t4_dz, i64 1, i64 %t3
  %t4_qt = sdiv i64 %t2, %t4_sd
  %t4 = select i1 %t4_dz, i64 0, i64 %t4_qt
  %t4_dsta = select i1 %t4_dz, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0)
  store i64 %t4, i64* %_v_res, align 8
  store i8* %t4_dsta, i8** %_v_res__sta, align 8
  %t5 = load i64, i64* %_v_res, align 8
  %t5_vsta = load i8*, i8** %_v_res__sta, align 8
  %t5_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t6 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t5, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t6, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__osSystemSummary() {
fn_entry:
  %_v_u = alloca i64, align 8
  %_v_u__sta = alloca i8*, align 8
  %_v_u__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_u__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_u__msg, align 8
  %_v_c = alloca i64, align 8
  %_v_c__sta = alloca i8*, align 8
  %_v_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c__msg, align 8
  %_v_m = alloca i64, align 8
  %_v_m__sta = alloca i8*, align 8
  %_v_m__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_m__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_m__msg, align 8
  %_v_g = alloca i64, align 8
  %_v_g__sta = alloca i8*, align 8
  %_v_g__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_g__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_g__msg, align 8
  %_v_res = alloca i64, align 8
  %_v_res__sta = alloca i8*, align 8
  %_v_res__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_res__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_res__msg, align 8
  %t1 = add i64 0, 0
  store i64 %t1, i64* %_v_u, align 8
  %t2 = add i64 0, 0
  store i64 %t2, i64* %_v_c, align 8
  %t3 = add i64 0, 0
  store i64 %t3, i64* %_v_m, align 8
  %t4 = load i64, i64* %_v_m, align 8
  %t4_vsta = load i8*, i8** %_v_m__sta, align 8
  %t4_vmsg = load i8*, i8** %_v_m__msg, align 8
  %t5 = add i64 0, 1073741824
  %t6_dz = icmp eq i64 %t5, 0
  %t6_sd = select i1 %t6_dz, i64 1, i64 %t5
  %t6_qt = sdiv i64 %t4, %t6_sd
  %t6 = select i1 %t6_dz, i64 0, i64 %t6_qt
  %t6_dsta = select i1 %t6_dz, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0)
  store i64 %t6, i64* %_v_g, align 8
  store i8* %t6_dsta, i8** %_v_g__sta, align 8
  %t7 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.49, i32 0, i32 0
  %t8 = load i64, i64* %_v_u, align 8
  %t8_vsta = load i8*, i8** %_v_u__sta, align 8
  %t8_vmsg = load i8*, i8** %_v_u__msg, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t8)
  %t9 = call i8* @flux_str_concat(i8* %t7, i8* %cv_buf_1)
  %t10 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.50, i32 0, i32 0
  %t11 = call i8* @flux_str_concat(i8* %t9, i8* %t10)
  %t12 = load i64, i64* %_v_c, align 8
  %t12_vsta = load i8*, i8** %_v_c__sta, align 8
  %t12_vmsg = load i8*, i8** %_v_c__msg, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t12)
  %t13 = call i8* @flux_str_concat(i8* %t11, i8* %cv_buf_2)
  %t14 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.51, i32 0, i32 0
  %t15 = call i8* @flux_str_concat(i8* %t13, i8* %t14)
  %t16 = load i64, i64* %_v_g, align 8
  %t16_vsta = load i8*, i8** %_v_g__sta, align 8
  %t16_vmsg = load i8*, i8** %_v_g__msg, align 8
  %cv_buf_3 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_3, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t16)
  %t17 = call i8* @flux_str_concat(i8* %t15, i8* %cv_buf_3)
  %t18 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.52, i32 0, i32 0
  %t19 = call i8* @flux_str_concat(i8* %t17, i8* %t18)
  %st_5 = ptrtoint i8* %t19 to i64
  store i64 %st_5, i64* %_v_res, align 8
  %t20_i64 = load i64, i64* %_v_res, align 8
  %t20 = inttoptr i64 %t20_i64 to i8*
  %t20_vsta = load i8*, i8** %_v_res__sta, align 8
  %t20_vmsg = load i8*, i8** %_v_res__msg, align 8
  %t21 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_vi_1 = ptrtoint i8* %t20 to i64
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %em_vi_1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t21, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__userName() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__homeDir() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__tempDir() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__cpuCount() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__uptime() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__memoryTotal() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define %flux.result @uf_OsStdLib__memoryFree() {
fn_entry:
  %t1 = add i64 0, 0
  %t2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %em_sta_1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.3, i32 0, i32 0
  %em_r0_1 = insertvalue %flux.result undef, i8* %em_sta_1, 0
  %em_r1_1 = insertvalue %flux.result %em_r0_1, i64 %t1, 1
  %em_r2_1 = insertvalue %flux.result %em_r1_1, double 0.0, 2
  %em_r3_1 = insertvalue %flux.result %em_r2_1, i8* %t2, 3
  ret %flux.result %em_r3_1
}

define i32 @main(i32 %_sys_argc, i8** %_sys_argv) {
fn_entry:
  call void @flux_runtime_init_args(i32 %_sys_argc, i8** %_sys_argv)
  %_v_fluxc_bin = alloca i64, align 8
  %_v_fluxc_bin__sta = alloca i8*, align 8
  %_v_fluxc_bin__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_fluxc_bin__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_fluxc_bin__msg, align 8
  %_v_canon_dir = alloca i64, align 8
  %_v_canon_dir__sta = alloca i8*, align 8
  %_v_canon_dir__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_canon_dir__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_canon_dir__msg, align 8
  %_v_list_content = alloca i64, align 8
  %_v_list_content__sta = alloca i8*, align 8
  %_v_list_content__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_list_content__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_list_content__msg, align 8
  %_v_lclen = alloca i64, align 8
  %_v_lclen__sta = alloca i8*, align 8
  %_v_lclen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_lclen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_lclen__msg, align 8
  %_v_acertos = alloca i64, align 8
  %_v_acertos__sta = alloca i8*, align 8
  %_v_acertos__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_acertos__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_acertos__msg, align 8
  %_v_erros = alloca i64, align 8
  %_v_erros__sta = alloca i8*, align 8
  %_v_erros__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_erros__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_erros__msg, align 8
  %_v_cur_fname = alloca i64, align 8
  %_v_cur_fname__sta = alloca i8*, align 8
  %_v_cur_fname__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_cur_fname__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_cur_fname__msg, align 8
  %_v_li = alloca i64, align 8
  %_v_li__sta = alloca i8*, align 8
  %_v_li__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_li__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_li__msg, align 8
  %_v_ch = alloca i64, align 8
  %_v_ch__sta = alloca i8*, align 8
  %_v_ch__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ch__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ch__msg, align 8
  %_v_nome = alloca i64, align 8
  %_v_nome__sta = alloca i8*, align 8
  %_v_nome__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_nome__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_nome__msg, align 8
  %_v_filepath = alloca i64, align 8
  %_v_filepath__sta = alloca i8*, align 8
  %_v_filepath__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_filepath__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_filepath__msg, align 8
  %_v_nlen = alloca i64, align 8
  %_v_nlen__sta = alloca i8*, align 8
  %_v_nlen__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_nlen__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_nlen__msg, align 8
  %_v_stem = alloca i64, align 8
  %_v_stem__sta = alloca i8*, align 8
  %_v_stem__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_stem__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_stem__msg, align 8
  %_v_stdin_file = alloca i64, align 8
  %_v_stdin_file__sta = alloca i8*, align 8
  %_v_stdin_file__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_stdin_file__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_stdin_file__msg, align 8
  %_v_di = alloca i64, align 8
  %_v_di__sta = alloca i8*, align 8
  %_v_di__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_di__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_di__msg, align 8
  %_v_out_stem = alloca i64, align 8
  %_v_out_stem__sta = alloca i8*, align 8
  %_v_out_stem__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_out_stem__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_out_stem__msg, align 8
  %_v_ll_file = alloca i64, align 8
  %_v_ll_file__sta = alloca i8*, align 8
  %_v_ll_file__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ll_file__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ll_file__msg, align 8
  %_v_exe_file = alloca i64, align 8
  %_v_exe_file__sta = alloca i8*, align 8
  %_v_exe_file__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_exe_file__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_exe_file__msg, align 8
  %_v_cmd_lv_c = alloca i64, align 8
  %_v_cmd_lv_c__sta = alloca i8*, align 8
  %_v_cmd_lv_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_cmd_lv_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_cmd_lv_c__msg, align 8
  %_v_rc_c = alloca i64, align 8
  %_v_rc_c__sta = alloca i8*, align 8
  %_v_rc_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_rc_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_rc_c__msg, align 8
  %_v_c_out = alloca i64, align 8
  %_v_c_out__sta = alloca i8*, align 8
  %_v_c_out__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c_out__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c_out__msg, align 8
  %_v_c_len = alloca i64, align 8
  %_v_c_len__sta = alloca i8*, align 8
  %_v_c_len__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c_len__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c_len__msg, align 8
  %_v_c_last_line = alloca i64, align 8
  %_v_c_last_line__sta = alloca i8*, align 8
  %_v_c_last_line__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_c_last_line__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_c_last_line__msg, align 8
  %_v_ci = alloca i64, align 8
  %_v_ci__sta = alloca i8*, align 8
  %_v_ci__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ci__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ci__msg, align 8
  %_v_cur_chunk = alloca i64, align 8
  %_v_cur_chunk__sta = alloca i8*, align 8
  %_v_cur_chunk__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_cur_chunk__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_cur_chunk__msg, align 8
  %_v_ch_c = alloca i64, align 8
  %_v_ch_c__sta = alloca i8*, align 8
  %_v_ch_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ch_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ch_c__msg, align 8
  %_v_cmd_run = alloca i64, align 8
  %_v_cmd_run__sta = alloca i8*, align 8
  %_v_cmd_run__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_cmd_run__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_cmd_run__msg, align 8
  %_v_rc_run = alloca i64, align 8
  %_v_rc_run__sta = alloca i8*, align 8
  %_v_rc_run__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_rc_run__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_rc_run__msg, align 8
  %_v_r_out = alloca i64, align 8
  %_v_r_out__sta = alloca i8*, align 8
  %_v_r_out__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_r_out__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_r_out__msg, align 8
  %_v_r_len = alloca i64, align 8
  %_v_r_len__sta = alloca i8*, align 8
  %_v_r_len__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_r_len__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_r_len__msg, align 8
  %_v_ch_r = alloca i64, align 8
  %_v_ch_r__sta = alloca i8*, align 8
  %_v_ch_r__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ch_r__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ch_r__msg, align 8
  %_v_r_last = alloca i64, align 8
  %_v_r_last__sta = alloca i8*, align 8
  %_v_r_last__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_r_last__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_r_last__msg, align 8
  %t1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.53, i32 0, i32 0
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %_v_fluxc_bin, align 8
  %t4 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.53, i32 0, i32 0
  %t5_i64 = call i64 @flux_std_io_file_exists(i8* %t4)
  %t5 = trunc i64 %t5_i64 to i1
  br i1 %t5, label %ft_0, label %route_arm_3
ft_0:
  %t6 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.53, i32 0, i32 0
  %st_2 = ptrtoint i8* %t6 to i64
  store i64 %st_2, i64* %_v_fluxc_bin, align 8
  br label %route_end_2
route_arm_3:
  %t8 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.54, i32 0, i32 0
  %t9_i64 = call i64 @flux_std_io_file_exists(i8* %t8)
  %t9 = trunc i64 %t9_i64 to i1
  br i1 %t9, label %ft_1, label %route_arm_7
ft_1:
  %t10 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.54, i32 0, i32 0
  %st_3 = ptrtoint i8* %t10 to i64
  store i64 %st_3, i64* %_v_fluxc_bin, align 8
  br label %route_end_2
route_arm_7:
  %t12 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.55, i32 0, i32 0
  %t13_i64 = call i64 @flux_std_io_file_exists(i8* %t12)
  %t13 = trunc i64 %t13_i64 to i1
  br i1 %t13, label %ft_2, label %route_arm_11
ft_2:
  %t14 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.55, i32 0, i32 0
  %st_4 = ptrtoint i8* %t14 to i64
  store i64 %st_4, i64* %_v_fluxc_bin, align 8
  br label %route_end_2
route_arm_11:
  %t16 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.56, i32 0, i32 0
  %t17_i64 = call i64 @flux_std_io_file_exists(i8* %t16)
  %t17 = trunc i64 %t17_i64 to i1
  br i1 %t17, label %ft_3, label %route_arm_15
ft_3:
  %t18 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.56, i32 0, i32 0
  %st_5 = ptrtoint i8* %t18 to i64
  store i64 %st_5, i64* %_v_fluxc_bin, align 8
  br label %route_end_2
route_arm_15:
  %t20 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.57, i32 0, i32 0
  %st_6 = ptrtoint i8* %t20 to i64
  store i64 %st_6, i64* %_v_fluxc_bin, align 8
  br label %route_end_2
route_end_2:
  %t21 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.58, i32 0, i32 0
  %st_7 = ptrtoint i8* %t21 to i64
  store i64 %st_7, i64* %_v_canon_dir, align 8
  %t24 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.58, i32 0, i32 0
  %t25_i64 = call i64 @flux_std_io_file_exists(i8* %t24)
  %t25 = trunc i64 %t25_i64 to i1
  br i1 %t25, label %ft_4, label %route_arm_23
ft_4:
  %t26 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.58, i32 0, i32 0
  %st_8 = ptrtoint i8* %t26 to i64
  store i64 %st_8, i64* %_v_canon_dir, align 8
  br label %route_end_22
route_arm_23:
  %t28 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.59, i32 0, i32 0
  %t29_i64 = call i64 @flux_std_io_file_exists(i8* %t28)
  %t29 = trunc i64 %t29_i64 to i1
  br i1 %t29, label %ft_5, label %route_arm_27
ft_5:
  %t30 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.59, i32 0, i32 0
  %st_9 = ptrtoint i8* %t30 to i64
  store i64 %st_9, i64* %_v_canon_dir, align 8
  br label %route_end_22
route_arm_27:
  %t32 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.60, i32 0, i32 0
  %t33_i64 = call i64 @flux_std_io_file_exists(i8* %t32)
  %t33 = trunc i64 %t33_i64 to i1
  br i1 %t33, label %ft_6, label %route_arm_31
ft_6:
  %t34 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.60, i32 0, i32 0
  %st_10 = ptrtoint i8* %t34 to i64
  store i64 %st_10, i64* %_v_canon_dir, align 8
  br label %route_end_22
route_arm_31:
  %t36 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.61, i32 0, i32 0
  %t37_i64 = call i64 @flux_std_io_file_exists(i8* %t36)
  %t37 = trunc i64 %t37_i64 to i1
  br i1 %t37, label %ft_7, label %route_arm_35
ft_7:
  %t38 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.61, i32 0, i32 0
  %st_11 = ptrtoint i8* %t38 to i64
  store i64 %st_11, i64* %_v_canon_dir, align 8
  br label %route_end_22
route_arm_35:
  %t40 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.58, i32 0, i32 0
  %st_12 = ptrtoint i8* %t40 to i64
  store i64 %st_12, i64* %_v_canon_dir, align 8
  br label %route_end_22
route_end_22:
  %t41 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.62, i32 0, i32 0
  %t42 = call i64 @flux_std_os_exec(i8* %t41)
  %t43 = getelementptr inbounds [34 x i8], [34 x i8]* @.str.63, i32 0, i32 0
  %t44 = call i64 @flux_std_os_exec(i8* %t43)
  %t45 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.64, i32 0, i32 0
  %t46 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.65, i32 0, i32 0
  %t47 = call i64 @flux_std_io_write_file(i8* %t45, i8* %t46)
  %t48 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.66, i32 0, i32 0
  %t49 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.67, i32 0, i32 0
  %t50 = call i64 @flux_std_io_write_file(i8* %t48, i8* %t49)
  %t51 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.68, i32 0, i32 0
  %t52 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.69, i32 0, i32 0
  %t53 = call i64 @flux_std_io_write_file(i8* %t51, i8* %t52)
  %t54 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.70, i32 0, i32 0
  %t55 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t56 = call i64 @flux_std_io_write_file(i8* %t54, i8* %t55)
  %t57 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.71, i32 0, i32 0
  %t58_i64 = load i64, i64* %_v_canon_dir, align 8
  %t58 = inttoptr i64 %t58_i64 to i8*
  %t58_vsta = load i8*, i8** %_v_canon_dir__sta, align 8
  %t58_vmsg = load i8*, i8** %_v_canon_dir__msg, align 8
  %t59 = call i8* @flux_str_concat(i8* %t57, i8* %t58)
  %t60 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.72, i32 0, i32 0
  %t61 = call i8* @flux_str_concat(i8* %t59, i8* %t60)
  %t62 = call i64 @flux_std_os_exec(i8* %t61)
  %t63 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.73, i32 0, i32 0
  %t64 = call i8* @flux_std_io_read_file(i8* %t63)
  %st_13 = ptrtoint i8* %t64 to i64
  store i64 %st_13, i64* %_v_list_content, align 8
  %t65_i64 = load i64, i64* %_v_list_content, align 8
  %t65 = inttoptr i64 %t65_i64 to i8*
  %t65_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t65_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t66 = call i64 @flux_str_len(i8* %t65)
  store i64 %t66, i64* %_v_lclen, align 8
  %t69 = load i64, i64* %_v_lclen, align 8
  %t69_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t69_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t70 = add i64 0, 0
  %t71 = icmp sgt i64 %t69, %t70
  %t72_i64 = load i64, i64* %_v_list_content, align 8
  %t72 = inttoptr i64 %t72_i64 to i8*
  %t72_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t72_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t73 = load i64, i64* %_v_lclen, align 8
  %t73_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t73_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t74 = load i64, i64* %_v_lclen, align 8
  %t74_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t74_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t75 = call i8* @flux_str_slice(i8* %t72, i64 %t73, i64 %t74)
  %t76 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t77_cmp = call i32 @flux_str_compare(i8* %t75, i8* %t76)
  %t77 = icmp ne i32 %t77_cmp, 0
  %t78 = and i1 %t71, %t77
  br i1 %t78, label %ft_8, label %route_arm_68
ft_8:
  %t79_i64 = load i64, i64* %_v_list_content, align 8
  %t79 = inttoptr i64 %t79_i64 to i8*
  %t79_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t79_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t80 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t81 = call i8* @flux_str_concat(i8* %t79, i8* %t80)
  %st_15 = ptrtoint i8* %t81 to i64
  store i64 %st_15, i64* %_v_list_content, align 8
  %t82 = load i64, i64* %_v_lclen, align 8
  %t82_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t82_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t83 = add i64 0, 1
  %t84 = add i64 %t82, %t83
  store i64 %t84, i64* %_v_lclen, align 8
  br label %route_end_67
route_arm_68:
  br label %route_end_67
route_end_67:
  %t86 = add i64 0, 0
  store i64 %t86, i64* %_v_acertos, align 8
  %t87 = add i64 0, 0
  store i64 %t87, i64* %_v_erros, align 8
  %t88 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_19 = ptrtoint i8* %t88 to i64
  store i64 %st_19, i64* %_v_cur_fname, align 8
  %t89 = add i64 0, 1
  store i64 %t89, i64* %_v_li, align 8
  br label %loop_start_90
loop_start_90:
  %t93 = load i64, i64* %_v_li, align 8
  %t93_vsta = load i8*, i8** %_v_li__sta, align 8
  %t93_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t94 = load i64, i64* %_v_lclen, align 8
  %t94_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t94_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t95 = icmp sgt i64 %t93, %t94
  br i1 %t95, label %ft_9, label %route_arm_92
ft_9:
  br label %loop_end_90
route_arm_92:
  %t97_i64 = load i64, i64* %_v_list_content, align 8
  %t97 = inttoptr i64 %t97_i64 to i8*
  %t97_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t97_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t98 = load i64, i64* %_v_li, align 8
  %t98_vsta = load i8*, i8** %_v_li__sta, align 8
  %t98_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t99 = load i64, i64* %_v_li, align 8
  %t99_vsta = load i8*, i8** %_v_li__sta, align 8
  %t99_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t100 = call i8* @flux_str_slice(i8* %t97, i64 %t98, i64 %t99)
  %st_21 = ptrtoint i8* %t100 to i64
  store i64 %st_21, i64* %_v_ch, align 8
  %t103_i64 = load i64, i64* %_v_ch, align 8
  %t103 = inttoptr i64 %t103_i64 to i8*
  %t103_vsta = load i8*, i8** %_v_ch__sta, align 8
  %t103_vmsg = load i8*, i8** %_v_ch__msg, align 8
  %t104 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.75, i32 0, i32 0
  %t105_cmp = call i32 @flux_str_compare(i8* %t103, i8* %t104)
  %t105 = icmp eq i32 %t105_cmp, 0
  br i1 %t105, label %ft_10, label %route_arm_102
ft_10:
  br label %route_end_101
route_arm_102:
  %t107_i64 = load i64, i64* %_v_ch, align 8
  %t107 = inttoptr i64 %t107_i64 to i8*
  %t107_vsta = load i8*, i8** %_v_ch__sta, align 8
  %t107_vmsg = load i8*, i8** %_v_ch__msg, align 8
  %t108 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t109_cmp = call i32 @flux_str_compare(i8* %t107, i8* %t108)
  %t109 = icmp eq i32 %t109_cmp, 0
  br i1 %t109, label %ft_11, label %route_arm_106
ft_11:
  %t112_i64 = load i64, i64* %_v_cur_fname, align 8
  %t112 = inttoptr i64 %t112_i64 to i8*
  %t112_vsta = load i8*, i8** %_v_cur_fname__sta, align 8
  %t112_vmsg = load i8*, i8** %_v_cur_fname__msg, align 8
  %t113 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t114_cmp = call i32 @flux_str_compare(i8* %t112, i8* %t113)
  %t114 = icmp ne i32 %t114_cmp, 0
  br i1 %t114, label %ft_12, label %route_arm_111
ft_12:
  %t115_i64 = load i64, i64* %_v_cur_fname, align 8
  %t115 = inttoptr i64 %t115_i64 to i8*
  %t115_vsta = load i8*, i8** %_v_cur_fname__sta, align 8
  %t115_vmsg = load i8*, i8** %_v_cur_fname__msg, align 8
  %st_22 = ptrtoint i8* %t115 to i64
  store i64 %st_22, i64* %_v_nome, align 8
  store i8* %t115_vsta, i8** %_v_nome__sta, align 8
  store i8* %t115_vmsg, i8** %_v_nome__msg, align 8
  %t116_i64 = load i64, i64* %_v_canon_dir, align 8
  %t116 = inttoptr i64 %t116_i64 to i8*
  %t116_vsta = load i8*, i8** %_v_canon_dir__sta, align 8
  %t116_vmsg = load i8*, i8** %_v_canon_dir__msg, align 8
  %t117 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.76, i32 0, i32 0
  %t118 = call i8* @flux_str_concat(i8* %t116, i8* %t117)
  %t119_i64 = load i64, i64* %_v_nome, align 8
  %t119 = inttoptr i64 %t119_i64 to i8*
  %t119_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t119_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t120 = call i8* @flux_str_concat(i8* %t118, i8* %t119)
  %st_23 = ptrtoint i8* %t120 to i64
  store i64 %st_23, i64* %_v_filepath, align 8
  %t121_i64 = load i64, i64* %_v_nome, align 8
  %t121 = inttoptr i64 %t121_i64 to i8*
  %t121_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t121_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t122 = call i64 @flux_str_len(i8* %t121)
  store i64 %t122, i64* %_v_nlen, align 8
  %t123_i64 = load i64, i64* %_v_nome, align 8
  %t123 = inttoptr i64 %t123_i64 to i8*
  %t123_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t123_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t124 = add i64 0, 1
  %t125 = load i64, i64* %_v_nlen, align 8
  %t125_vsta = load i8*, i8** %_v_nlen__sta, align 8
  %t125_vmsg = load i8*, i8** %_v_nlen__msg, align 8
  %t126 = add i64 0, 5
  %t127 = sub i64 %t125, %t126
  %t128 = call i8* @flux_str_slice(i8* %t123, i64 %t124, i64 %t127)
  %st_25 = ptrtoint i8* %t128 to i64
  store i64 %st_25, i64* %_v_stem, align 8
  %t129 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.70, i32 0, i32 0
  %st_26 = ptrtoint i8* %t129 to i64
  store i64 %st_26, i64* %_v_stdin_file, align 8
  %t132_i64 = load i64, i64* %_v_nome, align 8
  %t132 = inttoptr i64 %t132_i64 to i8*
  %t132_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t132_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t133 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.77, i32 0, i32 0
  %t134_cmp = call i32 @flux_str_compare(i8* %t132, i8* %t133)
  %t134 = icmp eq i32 %t134_cmp, 0
  br i1 %t134, label %ft_13, label %route_arm_131
ft_13:
  %t135 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.68, i32 0, i32 0
  %st_27 = ptrtoint i8* %t135 to i64
  store i64 %st_27, i64* %_v_stdin_file, align 8
  br label %route_end_130
route_arm_131:
  %t137_i64 = load i64, i64* %_v_nome, align 8
  %t137 = inttoptr i64 %t137_i64 to i8*
  %t137_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t137_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t138 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.78, i32 0, i32 0
  %t139_cmp = call i32 @flux_str_compare(i8* %t137, i8* %t138)
  %t139 = icmp eq i32 %t139_cmp, 0
  br i1 %t139, label %ft_14, label %route_arm_136
ft_14:
  %t140 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.64, i32 0, i32 0
  %st_28 = ptrtoint i8* %t140 to i64
  store i64 %st_28, i64* %_v_stdin_file, align 8
  br label %route_end_130
route_arm_136:
  %t142_i64 = load i64, i64* %_v_nome, align 8
  %t142 = inttoptr i64 %t142_i64 to i8*
  %t142_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t142_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t143 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.79, i32 0, i32 0
  %t144_cmp = call i32 @flux_str_compare(i8* %t142, i8* %t143)
  %t144 = icmp eq i32 %t144_cmp, 0
  br i1 %t144, label %ft_15, label %route_arm_141
ft_15:
  %t145 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.66, i32 0, i32 0
  %st_29 = ptrtoint i8* %t145 to i64
  store i64 %st_29, i64* %_v_stdin_file, align 8
  br label %route_end_130
route_arm_141:
  br label %route_end_130
route_end_130:
  %t149 = load i64, i64* %_v_nlen, align 8
  %t149_vsta = load i8*, i8** %_v_nlen__sta, align 8
  %t149_vmsg = load i8*, i8** %_v_nlen__msg, align 8
  %t150 = add i64 0, 8
  %t151 = icmp sge i64 %t149, %t150
  br i1 %t151, label %ft_16, label %route_arm_148
ft_16:
  %t152 = add i64 0, 1
  store i64 %t152, i64* %_v_di, align 8
  br label %loop_start_153
loop_start_153:
  %t156 = load i64, i64* %_v_di, align 8
  %t156_vsta = load i8*, i8** %_v_di__sta, align 8
  %t156_vmsg = load i8*, i8** %_v_di__msg, align 8
  %t157 = add i64 0, 7
  %t158 = add i64 %t156, %t157
  %t159 = load i64, i64* %_v_nlen, align 8
  %t159_vsta = load i8*, i8** %_v_nlen__sta, align 8
  %t159_vmsg = load i8*, i8** %_v_nlen__msg, align 8
  %t160 = icmp sgt i64 %t158, %t159
  br i1 %t160, label %ft_17, label %route_arm_155
ft_17:
  br label %loop_end_153
route_arm_155:
  %t162_i64 = load i64, i64* %_v_nome, align 8
  %t162 = inttoptr i64 %t162_i64 to i8*
  %t162_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t162_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t163 = load i64, i64* %_v_di, align 8
  %t163_vsta = load i8*, i8** %_v_di__sta, align 8
  %t163_vmsg = load i8*, i8** %_v_di__msg, align 8
  %t164 = load i64, i64* %_v_di, align 8
  %t164_vsta = load i8*, i8** %_v_di__sta, align 8
  %t164_vmsg = load i8*, i8** %_v_di__msg, align 8
  %t165 = add i64 0, 7
  %t166 = add i64 %t164, %t165
  %t167 = call i8* @flux_str_slice(i8* %t162, i64 %t163, i64 %t166)
  %t168 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.80, i32 0, i32 0
  %t169_cmp = call i32 @flux_str_compare(i8* %t167, i8* %t168)
  %t169 = icmp eq i32 %t169_cmp, 0
  br i1 %t169, label %ft_18, label %route_arm_161
ft_18:
  %t170 = getelementptr inbounds [120 x i8], [120 x i8]* @.str.81, i32 0, i32 0
  %t171 = call i64 @flux_std_os_exec(i8* %t170)
  br label %loop_end_153
route_arm_161:
  %t173 = load i64, i64* %_v_di, align 8
  %t173_vsta = load i8*, i8** %_v_di__sta, align 8
  %t173_vmsg = load i8*, i8** %_v_di__msg, align 8
  %t174 = add i64 0, 1
  %t175 = add i64 %t173, %t174
  store i64 %t175, i64* %_v_di, align 8
  br label %route_end_154
route_end_154:
  br label %loop_start_153
loop_end_153:
  br label %route_end_147
route_arm_148:
  br label %route_end_147
route_end_147:
  %t177 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.82, i32 0, i32 0
  %t178_i64 = load i64, i64* %_v_stem, align 8
  %t178 = inttoptr i64 %t178_i64 to i8*
  %t178_vsta = load i8*, i8** %_v_stem__sta, align 8
  %t178_vmsg = load i8*, i8** %_v_stem__msg, align 8
  %t179 = call i8* @flux_str_concat(i8* %t177, i8* %t178)
  %st_32 = ptrtoint i8* %t179 to i64
  store i64 %st_32, i64* %_v_out_stem, align 8
  %t180 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.82, i32 0, i32 0
  %t181_i64 = load i64, i64* %_v_stem, align 8
  %t181 = inttoptr i64 %t181_i64 to i8*
  %t181_vsta = load i8*, i8** %_v_stem__sta, align 8
  %t181_vmsg = load i8*, i8** %_v_stem__msg, align 8
  %t182 = call i8* @flux_str_concat(i8* %t180, i8* %t181)
  %t183 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.83, i32 0, i32 0
  %t184 = call i8* @flux_str_concat(i8* %t182, i8* %t183)
  %st_33 = ptrtoint i8* %t184 to i64
  store i64 %st_33, i64* %_v_ll_file, align 8
  %t185 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.82, i32 0, i32 0
  %t186_i64 = load i64, i64* %_v_stem, align 8
  %t186 = inttoptr i64 %t186_i64 to i8*
  %t186_vsta = load i8*, i8** %_v_stem__sta, align 8
  %t186_vmsg = load i8*, i8** %_v_stem__msg, align 8
  %t187 = call i8* @flux_str_concat(i8* %t185, i8* %t186)
  %t188 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.84, i32 0, i32 0
  %t189 = call i8* @flux_str_concat(i8* %t187, i8* %t188)
  %st_34 = ptrtoint i8* %t189 to i64
  store i64 %st_34, i64* %_v_exe_file, align 8
  %t190 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.85, i32 0, i32 0
  %t191_i64 = load i64, i64* %_v_fluxc_bin, align 8
  %t191 = inttoptr i64 %t191_i64 to i8*
  %t191_vsta = load i8*, i8** %_v_fluxc_bin__sta, align 8
  %t191_vmsg = load i8*, i8** %_v_fluxc_bin__msg, align 8
  %t192 = call i8* @flux_str_concat(i8* %t190, i8* %t191)
  %t193 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.86, i32 0, i32 0
  %t194 = call i8* @flux_str_concat(i8* %t192, i8* %t193)
  %t195_i64 = load i64, i64* %_v_filepath, align 8
  %t195 = inttoptr i64 %t195_i64 to i8*
  %t195_vsta = load i8*, i8** %_v_filepath__sta, align 8
  %t195_vmsg = load i8*, i8** %_v_filepath__msg, align 8
  %t196 = call i8* @flux_str_concat(i8* %t194, i8* %t195)
  %t197 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.87, i32 0, i32 0
  %t198 = call i8* @flux_str_concat(i8* %t196, i8* %t197)
  %t199_i64 = load i64, i64* %_v_out_stem, align 8
  %t199 = inttoptr i64 %t199_i64 to i8*
  %t199_vsta = load i8*, i8** %_v_out_stem__sta, align 8
  %t199_vmsg = load i8*, i8** %_v_out_stem__msg, align 8
  %t200 = call i8* @flux_str_concat(i8* %t198, i8* %t199)
  %t201 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.88, i32 0, i32 0
  %t202 = call i8* @flux_str_concat(i8* %t200, i8* %t201)
  %t203_i64 = load i64, i64* %_v_stdin_file, align 8
  %t203 = inttoptr i64 %t203_i64 to i8*
  %t203_vsta = load i8*, i8** %_v_stdin_file__sta, align 8
  %t203_vmsg = load i8*, i8** %_v_stdin_file__msg, align 8
  %t204 = call i8* @flux_str_concat(i8* %t202, i8* %t203)
  %t205 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.89, i32 0, i32 0
  %t206 = call i8* @flux_str_concat(i8* %t204, i8* %t205)
  %st_35 = ptrtoint i8* %t206 to i64
  store i64 %st_35, i64* %_v_cmd_lv_c, align 8
  %t207_i64 = load i64, i64* %_v_cmd_lv_c, align 8
  %t207 = inttoptr i64 %t207_i64 to i8*
  %t207_vsta = load i8*, i8** %_v_cmd_lv_c__sta, align 8
  %t207_vmsg = load i8*, i8** %_v_cmd_lv_c__msg, align 8
  %t208 = call i64 @flux_std_os_exec(i8* %t207)
  store i64 %t208, i64* %_v_rc_c, align 8
  %t209 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.90, i32 0, i32 0
  %t210 = call i8* @flux_std_io_read_file(i8* %t209)
  %st_37 = ptrtoint i8* %t210 to i64
  store i64 %st_37, i64* %_v_c_out, align 8
  %t211_i64 = load i64, i64* %_v_c_out, align 8
  %t211 = inttoptr i64 %t211_i64 to i8*
  %t211_vsta = load i8*, i8** %_v_c_out__sta, align 8
  %t211_vmsg = load i8*, i8** %_v_c_out__msg, align 8
  %t212 = call i64 @flux_str_len(i8* %t211)
  store i64 %t212, i64* %_v_c_len, align 8
  %t213 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_39 = ptrtoint i8* %t213 to i64
  store i64 %st_39, i64* %_v_c_last_line, align 8
  %t214 = add i64 0, 1
  store i64 %t214, i64* %_v_ci, align 8
  %t215 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_41 = ptrtoint i8* %t215 to i64
  store i64 %st_41, i64* %_v_cur_chunk, align 8
  br label %loop_start_216
loop_start_216:
  %t219 = load i64, i64* %_v_ci, align 8
  %t219_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t219_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t220 = load i64, i64* %_v_c_len, align 8
  %t220_vsta = load i8*, i8** %_v_c_len__sta, align 8
  %t220_vmsg = load i8*, i8** %_v_c_len__msg, align 8
  %t221 = icmp sgt i64 %t219, %t220
  br i1 %t221, label %ft_19, label %route_arm_218
ft_19:
  br label %loop_end_216
route_arm_218:
  %t223_i64 = load i64, i64* %_v_c_out, align 8
  %t223 = inttoptr i64 %t223_i64 to i8*
  %t223_vsta = load i8*, i8** %_v_c_out__sta, align 8
  %t223_vmsg = load i8*, i8** %_v_c_out__msg, align 8
  %t224 = load i64, i64* %_v_ci, align 8
  %t224_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t224_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t225 = load i64, i64* %_v_ci, align 8
  %t225_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t225_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t226 = call i8* @flux_str_slice(i8* %t223, i64 %t224, i64 %t225)
  %st_42 = ptrtoint i8* %t226 to i64
  store i64 %st_42, i64* %_v_ch_c, align 8
  %t229_i64 = load i64, i64* %_v_ch_c, align 8
  %t229 = inttoptr i64 %t229_i64 to i8*
  %t229_vsta = load i8*, i8** %_v_ch_c__sta, align 8
  %t229_vmsg = load i8*, i8** %_v_ch_c__msg, align 8
  %t230 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.75, i32 0, i32 0
  %t231_cmp = call i32 @flux_str_compare(i8* %t229, i8* %t230)
  %t231 = icmp eq i32 %t231_cmp, 0
  br i1 %t231, label %ft_20, label %route_arm_228
ft_20:
  br label %route_end_227
route_arm_228:
  %t233_i64 = load i64, i64* %_v_ch_c, align 8
  %t233 = inttoptr i64 %t233_i64 to i8*
  %t233_vsta = load i8*, i8** %_v_ch_c__sta, align 8
  %t233_vmsg = load i8*, i8** %_v_ch_c__msg, align 8
  %t234 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t235_cmp = call i32 @flux_str_compare(i8* %t233, i8* %t234)
  %t235 = icmp eq i32 %t235_cmp, 0
  br i1 %t235, label %ft_21, label %route_arm_232
ft_21:
  %t238_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t238 = inttoptr i64 %t238_i64 to i8*
  %t238_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t238_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t239 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t240_cmp = call i32 @flux_str_compare(i8* %t238, i8* %t239)
  %t240 = icmp ne i32 %t240_cmp, 0
  br i1 %t240, label %ft_22, label %route_arm_237
ft_22:
  %t241_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t241 = inttoptr i64 %t241_i64 to i8*
  %t241_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t241_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %st_43 = ptrtoint i8* %t241 to i64
  store i64 %st_43, i64* %_v_c_last_line, align 8
  store i8* %t241_vsta, i8** %_v_c_last_line__sta, align 8
  store i8* %t241_vmsg, i8** %_v_c_last_line__msg, align 8
  br label %route_end_236
route_arm_237:
  br label %route_end_236
route_end_236:
  %t243 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_44 = ptrtoint i8* %t243 to i64
  store i64 %st_44, i64* %_v_cur_chunk, align 8
  br label %route_end_227
route_arm_232:
  %t245_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t245 = inttoptr i64 %t245_i64 to i8*
  %t245_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t245_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t246_i64 = load i64, i64* %_v_ch_c, align 8
  %t246 = inttoptr i64 %t246_i64 to i8*
  %t246_vsta = load i8*, i8** %_v_ch_c__sta, align 8
  %t246_vmsg = load i8*, i8** %_v_ch_c__msg, align 8
  %t247 = call i8* @flux_str_concat(i8* %t245, i8* %t246)
  %st_45 = ptrtoint i8* %t247 to i64
  store i64 %st_45, i64* %_v_cur_chunk, align 8
  br label %route_end_227
route_end_227:
  %t248 = load i64, i64* %_v_ci, align 8
  %t248_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t248_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t249 = add i64 0, 1
  %t250 = add i64 %t248, %t249
  store i64 %t250, i64* %_v_ci, align 8
  br label %route_end_217
route_end_217:
  br label %loop_start_216
loop_end_216:
  %t253_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t253 = inttoptr i64 %t253_i64 to i8*
  %t253_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t253_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t254 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t255_cmp = call i32 @flux_str_compare(i8* %t253, i8* %t254)
  %t255 = icmp ne i32 %t255_cmp, 0
  br i1 %t255, label %ft_23, label %route_arm_252
ft_23:
  %t256_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t256 = inttoptr i64 %t256_i64 to i8*
  %t256_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t256_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %st_47 = ptrtoint i8* %t256 to i64
  store i64 %st_47, i64* %_v_c_last_line, align 8
  store i8* %t256_vsta, i8** %_v_c_last_line__sta, align 8
  store i8* %t256_vmsg, i8** %_v_c_last_line__msg, align 8
  br label %route_end_251
route_arm_252:
  br label %route_end_251
route_end_251:
  %t260 = load i64, i64* %_v_rc_c, align 8
  %t260_vsta = load i8*, i8** %_v_rc_c__sta, align 8
  %t260_vmsg = load i8*, i8** %_v_rc_c__msg, align 8
  %t261 = add i64 0, 0
  %t262 = icmp ne i64 %t260, %t261
  br i1 %t262, label %ft_24, label %route_arm_259
ft_24:
  %t263 = load i64, i64* %_v_erros, align 8
  %t263_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t263_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t264 = add i64 0, 1
  %t265 = add i64 %t263, %t264
  store i64 %t265, i64* %_v_erros, align 8
  %t266 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.91, i32 0, i32 0
  %t267_i64 = load i64, i64* %_v_nome, align 8
  %t267 = inttoptr i64 %t267_i64 to i8*
  %t267_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t267_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t268 = call i8* @flux_str_concat(i8* %t266, i8* %t267)
  %t269 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.92, i32 0, i32 0
  %t270 = call i8* @flux_str_concat(i8* %t268, i8* %t269)
  %t271_i64 = load i64, i64* %_v_c_last_line, align 8
  %t271 = inttoptr i64 %t271_i64 to i8*
  %t271_vsta = load i8*, i8** %_v_c_last_line__sta, align 8
  %t271_vmsg = load i8*, i8** %_v_c_last_line__msg, align 8
  %t272 = call i8* @flux_str_concat(i8* %t270, i8* %t271)
  %pr_sn_1 = icmp eq i8* %t272, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t272
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  br label %route_end_258
route_arm_259:
  %t274_i64 = load i64, i64* %_v_ll_file, align 8
  %t274 = inttoptr i64 %t274_i64 to i8*
  %t274_vsta = load i8*, i8** %_v_ll_file__sta, align 8
  %t274_vmsg = load i8*, i8** %_v_ll_file__msg, align 8
  %t275_i64 = call i64 @flux_std_io_file_exists(i8* %t274)
  %t275 = trunc i64 %t275_i64 to i1
  %t276 = xor i1 %t275, 1
  br i1 %t276, label %ft_25, label %route_arm_273
ft_25:
  %t277 = load i64, i64* %_v_erros, align 8
  %t277_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t277_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t278 = add i64 0, 1
  %t279 = add i64 %t277, %t278
  store i64 %t279, i64* %_v_erros, align 8
  %t280 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.91, i32 0, i32 0
  %t281_i64 = load i64, i64* %_v_nome, align 8
  %t281 = inttoptr i64 %t281_i64 to i8*
  %t281_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t281_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t282 = call i8* @flux_str_concat(i8* %t280, i8* %t281)
  %t283 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.93, i32 0, i32 0
  %t284 = call i8* @flux_str_concat(i8* %t282, i8* %t283)
  %pr_sn_2 = icmp eq i8* %t284, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t284
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  br label %route_end_258
route_arm_273:
  %t288_i64 = load i64, i64* %_v_exe_file, align 8
  %t288 = inttoptr i64 %t288_i64 to i8*
  %t288_vsta = load i8*, i8** %_v_exe_file__sta, align 8
  %t288_vmsg = load i8*, i8** %_v_exe_file__msg, align 8
  %t289_i64 = call i64 @flux_std_io_file_exists(i8* %t288)
  %t289 = trunc i64 %t289_i64 to i1
  %t290 = xor i1 %t289, 1
  br i1 %t290, label %ft_26, label %route_arm_287
ft_26:
  %t291 = load i64, i64* %_v_erros, align 8
  %t291_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t291_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t292 = add i64 0, 1
  %t293 = add i64 %t291, %t292
  store i64 %t293, i64* %_v_erros, align 8
  %t294 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.91, i32 0, i32 0
  %t295_i64 = load i64, i64* %_v_nome, align 8
  %t295 = inttoptr i64 %t295_i64 to i8*
  %t295_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t295_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t296 = call i8* @flux_str_concat(i8* %t294, i8* %t295)
  %t297 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.94, i32 0, i32 0
  %t298 = call i8* @flux_str_concat(i8* %t296, i8* %t297)
  %pr_sn_3 = icmp eq i8* %t298, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t298
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  br label %route_end_286
route_arm_287:
  %t300 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.85, i32 0, i32 0
  %t301_i64 = load i64, i64* %_v_exe_file, align 8
  %t301 = inttoptr i64 %t301_i64 to i8*
  %t301_vsta = load i8*, i8** %_v_exe_file__sta, align 8
  %t301_vmsg = load i8*, i8** %_v_exe_file__msg, align 8
  %t302 = call i8* @flux_str_concat(i8* %t300, i8* %t301)
  %t303 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.95, i32 0, i32 0
  %t304 = call i8* @flux_str_concat(i8* %t302, i8* %t303)
  %t305_i64 = load i64, i64* %_v_stdin_file, align 8
  %t305 = inttoptr i64 %t305_i64 to i8*
  %t305_vsta = load i8*, i8** %_v_stdin_file__sta, align 8
  %t305_vmsg = load i8*, i8** %_v_stdin_file__msg, align 8
  %t306 = call i8* @flux_str_concat(i8* %t304, i8* %t305)
  %t307 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.96, i32 0, i32 0
  %t308 = call i8* @flux_str_concat(i8* %t306, i8* %t307)
  %st_51 = ptrtoint i8* %t308 to i64
  store i64 %st_51, i64* %_v_cmd_run, align 8
  %t309_i64 = load i64, i64* %_v_cmd_run, align 8
  %t309 = inttoptr i64 %t309_i64 to i8*
  %t309_vsta = load i8*, i8** %_v_cmd_run__sta, align 8
  %t309_vmsg = load i8*, i8** %_v_cmd_run__msg, align 8
  %t310 = call i64 @flux_std_os_exec(i8* %t309)
  store i64 %t310, i64* %_v_rc_run, align 8
  %t311 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.97, i32 0, i32 0
  %t312 = call i8* @flux_std_io_read_file(i8* %t311)
  %st_53 = ptrtoint i8* %t312 to i64
  store i64 %st_53, i64* %_v_r_out, align 8
  %t313_i64 = load i64, i64* %_v_r_out, align 8
  %t313 = inttoptr i64 %t313_i64 to i8*
  %t313_vsta = load i8*, i8** %_v_r_out__sta, align 8
  %t313_vmsg = load i8*, i8** %_v_r_out__msg, align 8
  %t314 = call i64 @flux_str_len(i8* %t313)
  store i64 %t314, i64* %_v_r_len, align 8
  %t317 = load i64, i64* %_v_rc_run, align 8
  %t317_vsta = load i8*, i8** %_v_rc_run__sta, align 8
  %t317_vmsg = load i8*, i8** %_v_rc_run__msg, align 8
  %t318 = add i64 0, 0
  %t319 = icmp eq i64 %t317, %t318
  br i1 %t319, label %ft_27, label %route_arm_316
ft_27:
  %t320 = load i64, i64* %_v_acertos, align 8
  %t320_vsta = load i8*, i8** %_v_acertos__sta, align 8
  %t320_vmsg = load i8*, i8** %_v_acertos__msg, align 8
  %t321 = add i64 0, 1
  %t322 = add i64 %t320, %t321
  store i64 %t322, i64* %_v_acertos, align 8
  %t323 = add i64 0, 1
  store i64 %t323, i64* %_v_ci, align 8
  %t324 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_57 = ptrtoint i8* %t324 to i64
  store i64 %st_57, i64* %_v_cur_chunk, align 8
  br label %loop_start_325
loop_start_325:
  %t328 = load i64, i64* %_v_ci, align 8
  %t328_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t328_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t329 = load i64, i64* %_v_r_len, align 8
  %t329_vsta = load i8*, i8** %_v_r_len__sta, align 8
  %t329_vmsg = load i8*, i8** %_v_r_len__msg, align 8
  %t330 = icmp sgt i64 %t328, %t329
  br i1 %t330, label %ft_28, label %route_arm_327
ft_28:
  br label %loop_end_325
route_arm_327:
  %t332_i64 = load i64, i64* %_v_r_out, align 8
  %t332 = inttoptr i64 %t332_i64 to i8*
  %t332_vsta = load i8*, i8** %_v_r_out__sta, align 8
  %t332_vmsg = load i8*, i8** %_v_r_out__msg, align 8
  %t333 = load i64, i64* %_v_ci, align 8
  %t333_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t333_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t334 = load i64, i64* %_v_ci, align 8
  %t334_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t334_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t335 = call i8* @flux_str_slice(i8* %t332, i64 %t333, i64 %t334)
  %st_58 = ptrtoint i8* %t335 to i64
  store i64 %st_58, i64* %_v_ch_r, align 8
  %t338_i64 = load i64, i64* %_v_ch_r, align 8
  %t338 = inttoptr i64 %t338_i64 to i8*
  %t338_vsta = load i8*, i8** %_v_ch_r__sta, align 8
  %t338_vmsg = load i8*, i8** %_v_ch_r__msg, align 8
  %t339 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.75, i32 0, i32 0
  %t340_cmp = call i32 @flux_str_compare(i8* %t338, i8* %t339)
  %t340 = icmp eq i32 %t340_cmp, 0
  br i1 %t340, label %ft_29, label %route_arm_337
ft_29:
  br label %route_end_336
route_arm_337:
  %t342_i64 = load i64, i64* %_v_ch_r, align 8
  %t342 = inttoptr i64 %t342_i64 to i8*
  %t342_vsta = load i8*, i8** %_v_ch_r__sta, align 8
  %t342_vmsg = load i8*, i8** %_v_ch_r__msg, align 8
  %t343 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t344_cmp = call i32 @flux_str_compare(i8* %t342, i8* %t343)
  %t344 = icmp eq i32 %t344_cmp, 0
  br i1 %t344, label %ft_30, label %route_arm_341
ft_30:
  %t345 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.98, i32 0, i32 0
  %t346_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t346 = inttoptr i64 %t346_i64 to i8*
  %t346_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t346_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t347 = call i8* @flux_str_concat(i8* %t345, i8* %t346)
  %pr_sn_4 = icmp eq i8* %t347, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t347
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  %t348 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_59 = ptrtoint i8* %t348 to i64
  store i64 %st_59, i64* %_v_cur_chunk, align 8
  br label %route_end_336
route_arm_341:
  %t350_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t350 = inttoptr i64 %t350_i64 to i8*
  %t350_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t350_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t351_i64 = load i64, i64* %_v_ch_r, align 8
  %t351 = inttoptr i64 %t351_i64 to i8*
  %t351_vsta = load i8*, i8** %_v_ch_r__sta, align 8
  %t351_vmsg = load i8*, i8** %_v_ch_r__msg, align 8
  %t352 = call i8* @flux_str_concat(i8* %t350, i8* %t351)
  %st_60 = ptrtoint i8* %t352 to i64
  store i64 %st_60, i64* %_v_cur_chunk, align 8
  br label %route_end_336
route_end_336:
  %t353 = load i64, i64* %_v_ci, align 8
  %t353_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t353_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t354 = add i64 0, 1
  %t355 = add i64 %t353, %t354
  store i64 %t355, i64* %_v_ci, align 8
  br label %route_end_326
route_end_326:
  br label %loop_start_325
loop_end_325:
  %t358_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t358 = inttoptr i64 %t358_i64 to i8*
  %t358_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t358_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t359 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t360_cmp = call i32 @flux_str_compare(i8* %t358, i8* %t359)
  %t360 = icmp ne i32 %t360_cmp, 0
  br i1 %t360, label %ft_31, label %route_arm_357
ft_31:
  %t361 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.98, i32 0, i32 0
  %t362_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t362 = inttoptr i64 %t362_i64 to i8*
  %t362_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t362_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t363 = call i8* @flux_str_concat(i8* %t361, i8* %t362)
  %pr_sn_5 = icmp eq i8* %t363, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t363
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  br label %route_end_356
route_arm_357:
  br label %route_end_356
route_end_356:
  %t365 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.99, i32 0, i32 0
  %t366_i64 = load i64, i64* %_v_nome, align 8
  %t366 = inttoptr i64 %t366_i64 to i8*
  %t366_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t366_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t367 = call i8* @flux_str_concat(i8* %t365, i8* %t366)
  %pr_sn_6 = icmp eq i8* %t367, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t367
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  br label %route_end_315
route_arm_316:
  %t369 = load i64, i64* %_v_erros, align 8
  %t369_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t369_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t370 = add i64 0, 1
  %t371 = add i64 %t369, %t370
  store i64 %t371, i64* %_v_erros, align 8
  %t372 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_63 = ptrtoint i8* %t372 to i64
  store i64 %st_63, i64* %_v_r_last, align 8
  %t373 = add i64 0, 1
  store i64 %t373, i64* %_v_ci, align 8
  %t374 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_65 = ptrtoint i8* %t374 to i64
  store i64 %st_65, i64* %_v_cur_chunk, align 8
  br label %loop_start_375
loop_start_375:
  %t378 = load i64, i64* %_v_ci, align 8
  %t378_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t378_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t379 = load i64, i64* %_v_r_len, align 8
  %t379_vsta = load i8*, i8** %_v_r_len__sta, align 8
  %t379_vmsg = load i8*, i8** %_v_r_len__msg, align 8
  %t380 = icmp sgt i64 %t378, %t379
  br i1 %t380, label %ft_32, label %route_arm_377
ft_32:
  br label %loop_end_375
route_arm_377:
  %t382_i64 = load i64, i64* %_v_r_out, align 8
  %t382 = inttoptr i64 %t382_i64 to i8*
  %t382_vsta = load i8*, i8** %_v_r_out__sta, align 8
  %t382_vmsg = load i8*, i8** %_v_r_out__msg, align 8
  %t383 = load i64, i64* %_v_ci, align 8
  %t383_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t383_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t384 = load i64, i64* %_v_ci, align 8
  %t384_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t384_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t385 = call i8* @flux_str_slice(i8* %t382, i64 %t383, i64 %t384)
  %st_66 = ptrtoint i8* %t385 to i64
  store i64 %st_66, i64* %_v_ch_r, align 8
  %t388_i64 = load i64, i64* %_v_ch_r, align 8
  %t388 = inttoptr i64 %t388_i64 to i8*
  %t388_vsta = load i8*, i8** %_v_ch_r__sta, align 8
  %t388_vmsg = load i8*, i8** %_v_ch_r__msg, align 8
  %t389 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.75, i32 0, i32 0
  %t390_cmp = call i32 @flux_str_compare(i8* %t388, i8* %t389)
  %t390 = icmp eq i32 %t390_cmp, 0
  br i1 %t390, label %ft_33, label %route_arm_387
ft_33:
  br label %route_end_386
route_arm_387:
  %t392_i64 = load i64, i64* %_v_ch_r, align 8
  %t392 = inttoptr i64 %t392_i64 to i8*
  %t392_vsta = load i8*, i8** %_v_ch_r__sta, align 8
  %t392_vmsg = load i8*, i8** %_v_ch_r__msg, align 8
  %t393 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t394_cmp = call i32 @flux_str_compare(i8* %t392, i8* %t393)
  %t394 = icmp eq i32 %t394_cmp, 0
  br i1 %t394, label %ft_34, label %route_arm_391
ft_34:
  %t397_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t397 = inttoptr i64 %t397_i64 to i8*
  %t397_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t397_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t398 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t399_cmp = call i32 @flux_str_compare(i8* %t397, i8* %t398)
  %t399 = icmp ne i32 %t399_cmp, 0
  br i1 %t399, label %ft_35, label %route_arm_396
ft_35:
  %t400_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t400 = inttoptr i64 %t400_i64 to i8*
  %t400_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t400_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %st_67 = ptrtoint i8* %t400 to i64
  store i64 %st_67, i64* %_v_r_last, align 8
  store i8* %t400_vsta, i8** %_v_r_last__sta, align 8
  store i8* %t400_vmsg, i8** %_v_r_last__msg, align 8
  br label %route_end_395
route_arm_396:
  br label %route_end_395
route_end_395:
  %t402 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_68 = ptrtoint i8* %t402 to i64
  store i64 %st_68, i64* %_v_cur_chunk, align 8
  br label %route_end_386
route_arm_391:
  %t404_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t404 = inttoptr i64 %t404_i64 to i8*
  %t404_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t404_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t405_i64 = load i64, i64* %_v_ch_r, align 8
  %t405 = inttoptr i64 %t405_i64 to i8*
  %t405_vsta = load i8*, i8** %_v_ch_r__sta, align 8
  %t405_vmsg = load i8*, i8** %_v_ch_r__msg, align 8
  %t406 = call i8* @flux_str_concat(i8* %t404, i8* %t405)
  %st_69 = ptrtoint i8* %t406 to i64
  store i64 %st_69, i64* %_v_cur_chunk, align 8
  br label %route_end_386
route_end_386:
  %t407 = load i64, i64* %_v_ci, align 8
  %t407_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t407_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t408 = add i64 0, 1
  %t409 = add i64 %t407, %t408
  store i64 %t409, i64* %_v_ci, align 8
  br label %route_end_376
route_end_376:
  br label %loop_start_375
loop_end_375:
  %t412_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t412 = inttoptr i64 %t412_i64 to i8*
  %t412_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t412_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t413 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t414_cmp = call i32 @flux_str_compare(i8* %t412, i8* %t413)
  %t414 = icmp ne i32 %t414_cmp, 0
  br i1 %t414, label %ft_36, label %route_arm_411
ft_36:
  %t415_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t415 = inttoptr i64 %t415_i64 to i8*
  %t415_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t415_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %st_71 = ptrtoint i8* %t415 to i64
  store i64 %st_71, i64* %_v_r_last, align 8
  store i8* %t415_vsta, i8** %_v_r_last__sta, align 8
  store i8* %t415_vmsg, i8** %_v_r_last__msg, align 8
  br label %route_end_410
route_arm_411:
  br label %route_end_410
route_end_410:
  %t419_i64 = load i64, i64* %_v_r_last, align 8
  %t419 = inttoptr i64 %t419_i64 to i8*
  %t419_vsta = load i8*, i8** %_v_r_last__sta, align 8
  %t419_vmsg = load i8*, i8** %_v_r_last__msg, align 8
  %t420 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t421_cmp = call i32 @flux_str_compare(i8* %t419, i8* %t420)
  %t421 = icmp eq i32 %t421_cmp, 0
  br i1 %t421, label %ft_37, label %route_arm_418
ft_37:
  %t422 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.100, i32 0, i32 0
  %t423 = load i64, i64* %_v_rc_run, align 8
  %t423_vsta = load i8*, i8** %_v_rc_run__sta, align 8
  %t423_vmsg = load i8*, i8** %_v_rc_run__msg, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t423)
  %t424 = call i8* @flux_str_concat(i8* %t422, i8* %cv_buf_1)
  %t425 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.101, i32 0, i32 0
  %t426 = call i8* @flux_str_concat(i8* %t424, i8* %t425)
  %st_72 = ptrtoint i8* %t426 to i64
  store i64 %st_72, i64* %_v_r_last, align 8
  br label %route_end_417
route_arm_418:
  br label %route_end_417
route_end_417:
  %t428 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.91, i32 0, i32 0
  %t429_i64 = load i64, i64* %_v_nome, align 8
  %t429 = inttoptr i64 %t429_i64 to i8*
  %t429_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t429_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t430 = call i8* @flux_str_concat(i8* %t428, i8* %t429)
  %t431 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.92, i32 0, i32 0
  %t432 = call i8* @flux_str_concat(i8* %t430, i8* %t431)
  %t433_i64 = load i64, i64* %_v_r_last, align 8
  %t433 = inttoptr i64 %t433_i64 to i8*
  %t433_vsta = load i8*, i8** %_v_r_last__sta, align 8
  %t433_vmsg = load i8*, i8** %_v_r_last__msg, align 8
  %t434 = call i8* @flux_str_concat(i8* %t432, i8* %t433)
  %pr_sn_7 = icmp eq i8* %t434, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t434
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  br label %route_end_315
route_end_315:
  br label %route_end_286
route_end_286:
  br label %route_end_258
route_end_258:
  br label %route_end_110
route_arm_111:
  br label %route_end_110
route_end_110:
  %t436 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_73 = ptrtoint i8* %t436 to i64
  store i64 %st_73, i64* %_v_cur_fname, align 8
  br label %route_end_101
route_arm_106:
  %t438_i64 = load i64, i64* %_v_cur_fname, align 8
  %t438 = inttoptr i64 %t438_i64 to i8*
  %t438_vsta = load i8*, i8** %_v_cur_fname__sta, align 8
  %t438_vmsg = load i8*, i8** %_v_cur_fname__msg, align 8
  %t439_i64 = load i64, i64* %_v_ch, align 8
  %t439 = inttoptr i64 %t439_i64 to i8*
  %t439_vsta = load i8*, i8** %_v_ch__sta, align 8
  %t439_vmsg = load i8*, i8** %_v_ch__msg, align 8
  %t440 = call i8* @flux_str_concat(i8* %t438, i8* %t439)
  %st_74 = ptrtoint i8* %t440 to i64
  store i64 %st_74, i64* %_v_cur_fname, align 8
  br label %route_end_101
route_end_101:
  %t441 = load i64, i64* %_v_li, align 8
  %t441_vsta = load i8*, i8** %_v_li__sta, align 8
  %t441_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t442 = add i64 0, 1
  %t443 = add i64 %t441, %t442
  store i64 %t443, i64* %_v_li, align 8
  br label %route_end_91
route_end_91:
  br label %loop_start_90
loop_end_90:
  %t444 = getelementptr inbounds [74 x i8], [74 x i8]* @.str.102, i32 0, i32 0
  %t445 = call i64 @flux_std_os_exec(i8* %t444)
  %t446 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %pr_sn_8 = icmp eq i8* %t446, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t446
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  %t447 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t448 = load i64, i64* %_v_acertos, align 8
  %t448_vsta = load i8*, i8** %_v_acertos__sta, align 8
  %t448_vmsg = load i8*, i8** %_v_acertos__msg, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t448)
  %t449 = call i8* @flux_str_concat(i8* %t447, i8* %cv_buf_2)
  %t450 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.103, i32 0, i32 0
  %t451 = call i8* @flux_str_concat(i8* %t449, i8* %t450)
  %t452 = load i64, i64* %_v_erros, align 8
  %t452_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t452_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %cv_buf_3 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_3, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t452)
  %t453 = call i8* @flux_str_concat(i8* %t451, i8* %cv_buf_3)
  %t454 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.104, i32 0, i32 0
  %t455 = call i8* @flux_str_concat(i8* %t453, i8* %t454)
  %pr_sn_9 = icmp eq i8* %t455, null
  %pr_sc_9 = select i1 %pr_sn_9, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t455
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_9)
  call i32 @fflush(i8* null)
  %t458 = load i64, i64* %_v_erros, align 8
  %t458_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t458_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t459 = add i64 0, 0
  %t460 = icmp eq i64 %t458, %t459
  br i1 %t460, label %ft_38, label %route_arm_457
ft_38:
  %t461 = add i64 0, 0
  %t462 = call i64 @flux_std_os_exit(i64 %t461)
  br label %route_end_456
route_arm_457:
  %t464 = add i64 0, 1
  %t465 = call i64 @flux_std_os_exit(i64 %t464)
  br label %route_end_456
route_end_456:
  ret i32 0
}
