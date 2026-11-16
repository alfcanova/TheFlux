; ModuleID = 'ExamplesWas'
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
@.str.62 = private unnamed_addr constant [38 x i8] c"cmd /c if not exist t_was mkdir t_was\00", align 1
@.str.63 = private unnamed_addr constant [24 x i8] c"t_stdin_interactive.tmp\00", align 1
@.str.64 = private unnamed_addr constant [46 x i8] c"Ana\0A30\0A9.99\0Atrue\0AA\0A2+3i\0A2026-08-28T12:00:00Z\0A\00", align 1
@.str.65 = private unnamed_addr constant [21 x i8] c"t_stdin_contract.tmp\00", align 1
@.str.66 = private unnamed_addr constant [12 x i8] c"andre\0Aluiz\0A\00", align 1
@.str.67 = private unnamed_addr constant [17 x i8] c"t_stdin_dado.tmp\00", align 1
@.str.68 = private unnamed_addr constant [6 x i8] c"dado\0A\00", align 1
@.str.69 = private unnamed_addr constant [18 x i8] c"t_stdin_empty.tmp\00", align 1
@.str.70 = private unnamed_addr constant [19 x i8] c"cmd /c dir /b /on \00", align 1
@.str.71 = private unnamed_addr constant [27 x i8] c"\5C*.flux > t_canon_list.tmp\00", align 1
@.str.72 = private unnamed_addr constant [17 x i8] c"t_canon_list.tmp\00", align 1
@.str.73 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.74 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.75 = private unnamed_addr constant [2 x i8] c"\5C\00", align 1
@.str.76 = private unnamed_addr constant [11 x i8] c"input.flux\00", align 1
@.str.77 = private unnamed_addr constant [20 x i8] c"ExampleOfInput.flux\00", align 1
@.str.78 = private unnamed_addr constant [42 x i8] c"ExampleOfUseIoStdLib_IoInputContract.flux\00", align 1
@.str.79 = private unnamed_addr constant [7 x i8] c"t_was\5C\00", align 1
@.str.80 = private unnamed_addr constant [6 x i8] c".wasm\00", align 1
@.str.81 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.82 = private unnamed_addr constant [16 x i8] c" --target wasm \00", align 1
@.str.83 = private unnamed_addr constant [5 x i8] c" -o \00", align 1
@.str.84 = private unnamed_addr constant [13 x i8] c" --no-run < \00", align 1
@.str.85 = private unnamed_addr constant [21 x i8] c" > t_was_c.tmp 2>&1\22\00", align 1
@.str.86 = private unnamed_addr constant [12 x i8] c"t_was_c.tmp\00", align 1
@.str.87 = private unnamed_addr constant [17 x i8] c"Sem erro emitido\00", align 1
@.str.88 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.89 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.90 = private unnamed_addr constant [10 x i8] c"  [wasm] \00", align 1
@.str.91 = private unnamed_addr constant [9 x i8] c"  OK    \00", align 1
@.str.92 = private unnamed_addr constant [19 x i8] c": .wasm nao gerado\00", align 1
@.str.93 = private unnamed_addr constant [66 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_was_c.tmp t_canon_list.tmp 2>nul\00", align 1
@.str.94 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.95 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1


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
  %_v_out_stem = alloca i64, align 8
  %_v_out_stem__sta = alloca i8*, align 8
  %_v_out_stem__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_out_stem__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_out_stem__msg, align 8
  %_v_wasm_file = alloca i64, align 8
  %_v_wasm_file__sta = alloca i8*, align 8
  %_v_wasm_file__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_wasm_file__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_wasm_file__msg, align 8
  %_v_cmd_was_c = alloca i64, align 8
  %_v_cmd_was_c__sta = alloca i8*, align 8
  %_v_cmd_was_c__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_cmd_was_c__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_cmd_was_c__msg, align 8
  %_v_rc = alloca i64, align 8
  %_v_rc__sta = alloca i8*, align 8
  %_v_rc__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_rc__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_rc__msg, align 8
  %_v_out_full = alloca i64, align 8
  %_v_out_full__sta = alloca i8*, align 8
  %_v_out_full__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_out_full__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_out_full__msg, align 8
  %_v_out_len = alloca i64, align 8
  %_v_out_len__sta = alloca i8*, align 8
  %_v_out_len__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_out_len__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_out_len__msg, align 8
  %_v_last_line = alloca i64, align 8
  %_v_last_line__sta = alloca i8*, align 8
  %_v_last_line__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_last_line__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_last_line__msg, align 8
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
  %_v_ch_o = alloca i64, align 8
  %_v_ch_o__sta = alloca i8*, align 8
  %_v_ch_o__msg = alloca i8*, align 8
  store i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8** %_v_ch_o__sta, align 8
  store i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0), i8** %_v_ch_o__msg, align 8
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
  %t41 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.62, i32 0, i32 0
  %t42 = call i64 @flux_std_os_exec(i8* %t41)
  %t43 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.63, i32 0, i32 0
  %t44 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.64, i32 0, i32 0
  %t45 = call i64 @flux_std_io_write_file(i8* %t43, i8* %t44)
  %t46 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.65, i32 0, i32 0
  %t47 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.66, i32 0, i32 0
  %t48 = call i64 @flux_std_io_write_file(i8* %t46, i8* %t47)
  %t49 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.67, i32 0, i32 0
  %t50 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.68, i32 0, i32 0
  %t51 = call i64 @flux_std_io_write_file(i8* %t49, i8* %t50)
  %t52 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.69, i32 0, i32 0
  %t53 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t54 = call i64 @flux_std_io_write_file(i8* %t52, i8* %t53)
  %t55 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.70, i32 0, i32 0
  %t56_i64 = load i64, i64* %_v_canon_dir, align 8
  %t56 = inttoptr i64 %t56_i64 to i8*
  %t56_vsta = load i8*, i8** %_v_canon_dir__sta, align 8
  %t56_vmsg = load i8*, i8** %_v_canon_dir__msg, align 8
  %t57 = call i8* @flux_str_concat(i8* %t55, i8* %t56)
  %t58 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.71, i32 0, i32 0
  %t59 = call i8* @flux_str_concat(i8* %t57, i8* %t58)
  %t60 = call i64 @flux_std_os_exec(i8* %t59)
  %t61 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.72, i32 0, i32 0
  %t62 = call i8* @flux_std_io_read_file(i8* %t61)
  %st_13 = ptrtoint i8* %t62 to i64
  store i64 %st_13, i64* %_v_list_content, align 8
  %t63_i64 = load i64, i64* %_v_list_content, align 8
  %t63 = inttoptr i64 %t63_i64 to i8*
  %t63_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t63_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t64 = call i64 @flux_str_len(i8* %t63)
  store i64 %t64, i64* %_v_lclen, align 8
  %t67 = load i64, i64* %_v_lclen, align 8
  %t67_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t67_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t68 = add i64 0, 0
  %t69 = icmp sgt i64 %t67, %t68
  %t70_i64 = load i64, i64* %_v_list_content, align 8
  %t70 = inttoptr i64 %t70_i64 to i8*
  %t70_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t70_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t71 = load i64, i64* %_v_lclen, align 8
  %t71_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t71_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t72 = load i64, i64* %_v_lclen, align 8
  %t72_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t72_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t73 = call i8* @flux_str_slice(i8* %t70, i64 %t71, i64 %t72)
  %t74 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.73, i32 0, i32 0
  %t75_cmp = call i32 @flux_str_compare(i8* %t73, i8* %t74)
  %t75 = icmp ne i32 %t75_cmp, 0
  %t76 = and i1 %t69, %t75
  br i1 %t76, label %ft_8, label %route_arm_66
ft_8:
  %t77_i64 = load i64, i64* %_v_list_content, align 8
  %t77 = inttoptr i64 %t77_i64 to i8*
  %t77_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t77_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t78 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.73, i32 0, i32 0
  %t79 = call i8* @flux_str_concat(i8* %t77, i8* %t78)
  %st_15 = ptrtoint i8* %t79 to i64
  store i64 %st_15, i64* %_v_list_content, align 8
  %t80 = load i64, i64* %_v_lclen, align 8
  %t80_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t80_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t81 = add i64 0, 1
  %t82 = add i64 %t80, %t81
  store i64 %t82, i64* %_v_lclen, align 8
  br label %route_end_65
route_arm_66:
  br label %route_end_65
route_end_65:
  %t84 = add i64 0, 0
  store i64 %t84, i64* %_v_acertos, align 8
  %t85 = add i64 0, 0
  store i64 %t85, i64* %_v_erros, align 8
  %t86 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_19 = ptrtoint i8* %t86 to i64
  store i64 %st_19, i64* %_v_cur_fname, align 8
  %t87 = add i64 0, 1
  store i64 %t87, i64* %_v_li, align 8
  br label %loop_start_88
loop_start_88:
  %t91 = load i64, i64* %_v_li, align 8
  %t91_vsta = load i8*, i8** %_v_li__sta, align 8
  %t91_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t92 = load i64, i64* %_v_lclen, align 8
  %t92_vsta = load i8*, i8** %_v_lclen__sta, align 8
  %t92_vmsg = load i8*, i8** %_v_lclen__msg, align 8
  %t93 = icmp sgt i64 %t91, %t92
  br i1 %t93, label %ft_9, label %route_arm_90
ft_9:
  br label %loop_end_88
route_arm_90:
  %t95_i64 = load i64, i64* %_v_list_content, align 8
  %t95 = inttoptr i64 %t95_i64 to i8*
  %t95_vsta = load i8*, i8** %_v_list_content__sta, align 8
  %t95_vmsg = load i8*, i8** %_v_list_content__msg, align 8
  %t96 = load i64, i64* %_v_li, align 8
  %t96_vsta = load i8*, i8** %_v_li__sta, align 8
  %t96_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t97 = load i64, i64* %_v_li, align 8
  %t97_vsta = load i8*, i8** %_v_li__sta, align 8
  %t97_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t98 = call i8* @flux_str_slice(i8* %t95, i64 %t96, i64 %t97)
  %st_21 = ptrtoint i8* %t98 to i64
  store i64 %st_21, i64* %_v_ch, align 8
  %t101_i64 = load i64, i64* %_v_ch, align 8
  %t101 = inttoptr i64 %t101_i64 to i8*
  %t101_vsta = load i8*, i8** %_v_ch__sta, align 8
  %t101_vmsg = load i8*, i8** %_v_ch__msg, align 8
  %t102 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t103_cmp = call i32 @flux_str_compare(i8* %t101, i8* %t102)
  %t103 = icmp eq i32 %t103_cmp, 0
  br i1 %t103, label %ft_10, label %route_arm_100
ft_10:
  br label %route_end_99
route_arm_100:
  %t105_i64 = load i64, i64* %_v_ch, align 8
  %t105 = inttoptr i64 %t105_i64 to i8*
  %t105_vsta = load i8*, i8** %_v_ch__sta, align 8
  %t105_vmsg = load i8*, i8** %_v_ch__msg, align 8
  %t106 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.73, i32 0, i32 0
  %t107_cmp = call i32 @flux_str_compare(i8* %t105, i8* %t106)
  %t107 = icmp eq i32 %t107_cmp, 0
  br i1 %t107, label %ft_11, label %route_arm_104
ft_11:
  %t110_i64 = load i64, i64* %_v_cur_fname, align 8
  %t110 = inttoptr i64 %t110_i64 to i8*
  %t110_vsta = load i8*, i8** %_v_cur_fname__sta, align 8
  %t110_vmsg = load i8*, i8** %_v_cur_fname__msg, align 8
  %t111 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t112_cmp = call i32 @flux_str_compare(i8* %t110, i8* %t111)
  %t112 = icmp ne i32 %t112_cmp, 0
  br i1 %t112, label %ft_12, label %route_arm_109
ft_12:
  %t113_i64 = load i64, i64* %_v_cur_fname, align 8
  %t113 = inttoptr i64 %t113_i64 to i8*
  %t113_vsta = load i8*, i8** %_v_cur_fname__sta, align 8
  %t113_vmsg = load i8*, i8** %_v_cur_fname__msg, align 8
  %st_22 = ptrtoint i8* %t113 to i64
  store i64 %st_22, i64* %_v_nome, align 8
  store i8* %t113_vsta, i8** %_v_nome__sta, align 8
  store i8* %t113_vmsg, i8** %_v_nome__msg, align 8
  %t114_i64 = load i64, i64* %_v_canon_dir, align 8
  %t114 = inttoptr i64 %t114_i64 to i8*
  %t114_vsta = load i8*, i8** %_v_canon_dir__sta, align 8
  %t114_vmsg = load i8*, i8** %_v_canon_dir__msg, align 8
  %t115 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.75, i32 0, i32 0
  %t116 = call i8* @flux_str_concat(i8* %t114, i8* %t115)
  %t117_i64 = load i64, i64* %_v_nome, align 8
  %t117 = inttoptr i64 %t117_i64 to i8*
  %t117_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t117_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t118 = call i8* @flux_str_concat(i8* %t116, i8* %t117)
  %st_23 = ptrtoint i8* %t118 to i64
  store i64 %st_23, i64* %_v_filepath, align 8
  %t119_i64 = load i64, i64* %_v_nome, align 8
  %t119 = inttoptr i64 %t119_i64 to i8*
  %t119_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t119_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t120 = call i64 @flux_str_len(i8* %t119)
  store i64 %t120, i64* %_v_nlen, align 8
  %t121_i64 = load i64, i64* %_v_nome, align 8
  %t121 = inttoptr i64 %t121_i64 to i8*
  %t121_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t121_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t122 = add i64 0, 1
  %t123 = load i64, i64* %_v_nlen, align 8
  %t123_vsta = load i8*, i8** %_v_nlen__sta, align 8
  %t123_vmsg = load i8*, i8** %_v_nlen__msg, align 8
  %t124 = add i64 0, 5
  %t125 = sub i64 %t123, %t124
  %t126 = call i8* @flux_str_slice(i8* %t121, i64 %t122, i64 %t125)
  %st_25 = ptrtoint i8* %t126 to i64
  store i64 %st_25, i64* %_v_stem, align 8
  %t127 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.69, i32 0, i32 0
  %st_26 = ptrtoint i8* %t127 to i64
  store i64 %st_26, i64* %_v_stdin_file, align 8
  %t130_i64 = load i64, i64* %_v_nome, align 8
  %t130 = inttoptr i64 %t130_i64 to i8*
  %t130_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t130_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t131 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.76, i32 0, i32 0
  %t132_cmp = call i32 @flux_str_compare(i8* %t130, i8* %t131)
  %t132 = icmp eq i32 %t132_cmp, 0
  br i1 %t132, label %ft_13, label %route_arm_129
ft_13:
  %t133 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.67, i32 0, i32 0
  %st_27 = ptrtoint i8* %t133 to i64
  store i64 %st_27, i64* %_v_stdin_file, align 8
  br label %route_end_128
route_arm_129:
  %t135_i64 = load i64, i64* %_v_nome, align 8
  %t135 = inttoptr i64 %t135_i64 to i8*
  %t135_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t135_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t136 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.77, i32 0, i32 0
  %t137_cmp = call i32 @flux_str_compare(i8* %t135, i8* %t136)
  %t137 = icmp eq i32 %t137_cmp, 0
  br i1 %t137, label %ft_14, label %route_arm_134
ft_14:
  %t138 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.63, i32 0, i32 0
  %st_28 = ptrtoint i8* %t138 to i64
  store i64 %st_28, i64* %_v_stdin_file, align 8
  br label %route_end_128
route_arm_134:
  %t140_i64 = load i64, i64* %_v_nome, align 8
  %t140 = inttoptr i64 %t140_i64 to i8*
  %t140_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t140_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t141 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.78, i32 0, i32 0
  %t142_cmp = call i32 @flux_str_compare(i8* %t140, i8* %t141)
  %t142 = icmp eq i32 %t142_cmp, 0
  br i1 %t142, label %ft_15, label %route_arm_139
ft_15:
  %t143 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.65, i32 0, i32 0
  %st_29 = ptrtoint i8* %t143 to i64
  store i64 %st_29, i64* %_v_stdin_file, align 8
  br label %route_end_128
route_arm_139:
  br label %route_end_128
route_end_128:
  %t145 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.79, i32 0, i32 0
  %t146_i64 = load i64, i64* %_v_stem, align 8
  %t146 = inttoptr i64 %t146_i64 to i8*
  %t146_vsta = load i8*, i8** %_v_stem__sta, align 8
  %t146_vmsg = load i8*, i8** %_v_stem__msg, align 8
  %t147 = call i8* @flux_str_concat(i8* %t145, i8* %t146)
  %st_30 = ptrtoint i8* %t147 to i64
  store i64 %st_30, i64* %_v_out_stem, align 8
  %t148 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.79, i32 0, i32 0
  %t149_i64 = load i64, i64* %_v_stem, align 8
  %t149 = inttoptr i64 %t149_i64 to i8*
  %t149_vsta = load i8*, i8** %_v_stem__sta, align 8
  %t149_vmsg = load i8*, i8** %_v_stem__msg, align 8
  %t150 = call i8* @flux_str_concat(i8* %t148, i8* %t149)
  %t151 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.80, i32 0, i32 0
  %t152 = call i8* @flux_str_concat(i8* %t150, i8* %t151)
  %st_31 = ptrtoint i8* %t152 to i64
  store i64 %st_31, i64* %_v_wasm_file, align 8
  %t153 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.81, i32 0, i32 0
  %t154_i64 = load i64, i64* %_v_fluxc_bin, align 8
  %t154 = inttoptr i64 %t154_i64 to i8*
  %t154_vsta = load i8*, i8** %_v_fluxc_bin__sta, align 8
  %t154_vmsg = load i8*, i8** %_v_fluxc_bin__msg, align 8
  %t155 = call i8* @flux_str_concat(i8* %t153, i8* %t154)
  %t156 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.82, i32 0, i32 0
  %t157 = call i8* @flux_str_concat(i8* %t155, i8* %t156)
  %t158_i64 = load i64, i64* %_v_filepath, align 8
  %t158 = inttoptr i64 %t158_i64 to i8*
  %t158_vsta = load i8*, i8** %_v_filepath__sta, align 8
  %t158_vmsg = load i8*, i8** %_v_filepath__msg, align 8
  %t159 = call i8* @flux_str_concat(i8* %t157, i8* %t158)
  %t160 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.83, i32 0, i32 0
  %t161 = call i8* @flux_str_concat(i8* %t159, i8* %t160)
  %t162_i64 = load i64, i64* %_v_out_stem, align 8
  %t162 = inttoptr i64 %t162_i64 to i8*
  %t162_vsta = load i8*, i8** %_v_out_stem__sta, align 8
  %t162_vmsg = load i8*, i8** %_v_out_stem__msg, align 8
  %t163 = call i8* @flux_str_concat(i8* %t161, i8* %t162)
  %t164 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.84, i32 0, i32 0
  %t165 = call i8* @flux_str_concat(i8* %t163, i8* %t164)
  %t166_i64 = load i64, i64* %_v_stdin_file, align 8
  %t166 = inttoptr i64 %t166_i64 to i8*
  %t166_vsta = load i8*, i8** %_v_stdin_file__sta, align 8
  %t166_vmsg = load i8*, i8** %_v_stdin_file__msg, align 8
  %t167 = call i8* @flux_str_concat(i8* %t165, i8* %t166)
  %t168 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.85, i32 0, i32 0
  %t169 = call i8* @flux_str_concat(i8* %t167, i8* %t168)
  %st_32 = ptrtoint i8* %t169 to i64
  store i64 %st_32, i64* %_v_cmd_was_c, align 8
  %t170_i64 = load i64, i64* %_v_cmd_was_c, align 8
  %t170 = inttoptr i64 %t170_i64 to i8*
  %t170_vsta = load i8*, i8** %_v_cmd_was_c__sta, align 8
  %t170_vmsg = load i8*, i8** %_v_cmd_was_c__msg, align 8
  %t171 = call i64 @flux_std_os_exec(i8* %t170)
  store i64 %t171, i64* %_v_rc, align 8
  %t172 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.86, i32 0, i32 0
  %t173 = call i8* @flux_std_io_read_file(i8* %t172)
  %st_34 = ptrtoint i8* %t173 to i64
  store i64 %st_34, i64* %_v_out_full, align 8
  %t174_i64 = load i64, i64* %_v_out_full, align 8
  %t174 = inttoptr i64 %t174_i64 to i8*
  %t174_vsta = load i8*, i8** %_v_out_full__sta, align 8
  %t174_vmsg = load i8*, i8** %_v_out_full__msg, align 8
  %t175 = call i64 @flux_str_len(i8* %t174)
  store i64 %t175, i64* %_v_out_len, align 8
  %t178 = load i64, i64* %_v_rc, align 8
  %t178_vsta = load i8*, i8** %_v_rc__sta, align 8
  %t178_vmsg = load i8*, i8** %_v_rc__msg, align 8
  %t179 = add i64 0, 0
  %t180 = icmp ne i64 %t178, %t179
  br i1 %t180, label %ft_16, label %route_arm_177
ft_16:
  %t181 = load i64, i64* %_v_erros, align 8
  %t181_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t181_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t182 = add i64 0, 1
  %t183 = add i64 %t181, %t182
  store i64 %t183, i64* %_v_erros, align 8
  %t184 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_37 = ptrtoint i8* %t184 to i64
  store i64 %st_37, i64* %_v_last_line, align 8
  %t185 = add i64 0, 1
  store i64 %t185, i64* %_v_ci, align 8
  %t186 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_39 = ptrtoint i8* %t186 to i64
  store i64 %st_39, i64* %_v_cur_chunk, align 8
  br label %loop_start_187
loop_start_187:
  %t190 = load i64, i64* %_v_ci, align 8
  %t190_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t190_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t191 = load i64, i64* %_v_out_len, align 8
  %t191_vsta = load i8*, i8** %_v_out_len__sta, align 8
  %t191_vmsg = load i8*, i8** %_v_out_len__msg, align 8
  %t192 = icmp sgt i64 %t190, %t191
  br i1 %t192, label %ft_17, label %route_arm_189
ft_17:
  br label %loop_end_187
route_arm_189:
  %t194_i64 = load i64, i64* %_v_out_full, align 8
  %t194 = inttoptr i64 %t194_i64 to i8*
  %t194_vsta = load i8*, i8** %_v_out_full__sta, align 8
  %t194_vmsg = load i8*, i8** %_v_out_full__msg, align 8
  %t195 = load i64, i64* %_v_ci, align 8
  %t195_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t195_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t196 = load i64, i64* %_v_ci, align 8
  %t196_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t196_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t197 = call i8* @flux_str_slice(i8* %t194, i64 %t195, i64 %t196)
  %st_40 = ptrtoint i8* %t197 to i64
  store i64 %st_40, i64* %_v_ch_o, align 8
  %t200_i64 = load i64, i64* %_v_ch_o, align 8
  %t200 = inttoptr i64 %t200_i64 to i8*
  %t200_vsta = load i8*, i8** %_v_ch_o__sta, align 8
  %t200_vmsg = load i8*, i8** %_v_ch_o__msg, align 8
  %t201 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i32 0, i32 0
  %t202_cmp = call i32 @flux_str_compare(i8* %t200, i8* %t201)
  %t202 = icmp eq i32 %t202_cmp, 0
  br i1 %t202, label %ft_18, label %route_arm_199
ft_18:
  br label %route_end_198
route_arm_199:
  %t204_i64 = load i64, i64* %_v_ch_o, align 8
  %t204 = inttoptr i64 %t204_i64 to i8*
  %t204_vsta = load i8*, i8** %_v_ch_o__sta, align 8
  %t204_vmsg = load i8*, i8** %_v_ch_o__msg, align 8
  %t205 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.73, i32 0, i32 0
  %t206_cmp = call i32 @flux_str_compare(i8* %t204, i8* %t205)
  %t206 = icmp eq i32 %t206_cmp, 0
  br i1 %t206, label %ft_19, label %route_arm_203
ft_19:
  %t209_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t209 = inttoptr i64 %t209_i64 to i8*
  %t209_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t209_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t210 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t211_cmp = call i32 @flux_str_compare(i8* %t209, i8* %t210)
  %t211 = icmp ne i32 %t211_cmp, 0
  br i1 %t211, label %ft_20, label %route_arm_208
ft_20:
  %t212_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t212 = inttoptr i64 %t212_i64 to i8*
  %t212_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t212_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %st_41 = ptrtoint i8* %t212 to i64
  store i64 %st_41, i64* %_v_last_line, align 8
  store i8* %t212_vsta, i8** %_v_last_line__sta, align 8
  store i8* %t212_vmsg, i8** %_v_last_line__msg, align 8
  br label %route_end_207
route_arm_208:
  br label %route_end_207
route_end_207:
  %t214 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_42 = ptrtoint i8* %t214 to i64
  store i64 %st_42, i64* %_v_cur_chunk, align 8
  br label %route_end_198
route_arm_203:
  %t216_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t216 = inttoptr i64 %t216_i64 to i8*
  %t216_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t216_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t217_i64 = load i64, i64* %_v_ch_o, align 8
  %t217 = inttoptr i64 %t217_i64 to i8*
  %t217_vsta = load i8*, i8** %_v_ch_o__sta, align 8
  %t217_vmsg = load i8*, i8** %_v_ch_o__msg, align 8
  %t218 = call i8* @flux_str_concat(i8* %t216, i8* %t217)
  %st_43 = ptrtoint i8* %t218 to i64
  store i64 %st_43, i64* %_v_cur_chunk, align 8
  br label %route_end_198
route_end_198:
  %t219 = load i64, i64* %_v_ci, align 8
  %t219_vsta = load i8*, i8** %_v_ci__sta, align 8
  %t219_vmsg = load i8*, i8** %_v_ci__msg, align 8
  %t220 = add i64 0, 1
  %t221 = add i64 %t219, %t220
  store i64 %t221, i64* %_v_ci, align 8
  br label %route_end_188
route_end_188:
  br label %loop_start_187
loop_end_187:
  %t224_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t224 = inttoptr i64 %t224_i64 to i8*
  %t224_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t224_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %t225 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t226_cmp = call i32 @flux_str_compare(i8* %t224, i8* %t225)
  %t226 = icmp ne i32 %t226_cmp, 0
  br i1 %t226, label %ft_21, label %route_arm_223
ft_21:
  %t227_i64 = load i64, i64* %_v_cur_chunk, align 8
  %t227 = inttoptr i64 %t227_i64 to i8*
  %t227_vsta = load i8*, i8** %_v_cur_chunk__sta, align 8
  %t227_vmsg = load i8*, i8** %_v_cur_chunk__msg, align 8
  %st_45 = ptrtoint i8* %t227 to i64
  store i64 %st_45, i64* %_v_last_line, align 8
  store i8* %t227_vsta, i8** %_v_last_line__sta, align 8
  store i8* %t227_vmsg, i8** %_v_last_line__msg, align 8
  br label %route_end_222
route_arm_223:
  br label %route_end_222
route_end_222:
  %t231_i64 = load i64, i64* %_v_last_line, align 8
  %t231 = inttoptr i64 %t231_i64 to i8*
  %t231_vsta = load i8*, i8** %_v_last_line__sta, align 8
  %t231_vmsg = load i8*, i8** %_v_last_line__msg, align 8
  %t232 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t233_cmp = call i32 @flux_str_compare(i8* %t231, i8* %t232)
  %t233 = icmp eq i32 %t233_cmp, 0
  br i1 %t233, label %ft_22, label %route_arm_230
ft_22:
  %t234 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.87, i32 0, i32 0
  %st_46 = ptrtoint i8* %t234 to i64
  store i64 %st_46, i64* %_v_last_line, align 8
  br label %route_end_229
route_arm_230:
  br label %route_end_229
route_end_229:
  %t236 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.88, i32 0, i32 0
  %t237_i64 = load i64, i64* %_v_nome, align 8
  %t237 = inttoptr i64 %t237_i64 to i8*
  %t237_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t237_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t238 = call i8* @flux_str_concat(i8* %t236, i8* %t237)
  %t239 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.89, i32 0, i32 0
  %t240 = call i8* @flux_str_concat(i8* %t238, i8* %t239)
  %t241_i64 = load i64, i64* %_v_last_line, align 8
  %t241 = inttoptr i64 %t241_i64 to i8*
  %t241_vsta = load i8*, i8** %_v_last_line__sta, align 8
  %t241_vmsg = load i8*, i8** %_v_last_line__msg, align 8
  %t242 = call i8* @flux_str_concat(i8* %t240, i8* %t241)
  %pr_sn_1 = icmp eq i8* %t242, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t242
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  br label %route_end_176
route_arm_177:
  %t246_i64 = load i64, i64* %_v_wasm_file, align 8
  %t246 = inttoptr i64 %t246_i64 to i8*
  %t246_vsta = load i8*, i8** %_v_wasm_file__sta, align 8
  %t246_vmsg = load i8*, i8** %_v_wasm_file__msg, align 8
  %t247_i64 = call i64 @flux_std_io_file_exists(i8* %t246)
  %t247 = trunc i64 %t247_i64 to i1
  br i1 %t247, label %ft_23, label %route_arm_245
ft_23:
  %t248 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.90, i32 0, i32 0
  %t249_i64 = load i64, i64* %_v_stem, align 8
  %t249 = inttoptr i64 %t249_i64 to i8*
  %t249_vsta = load i8*, i8** %_v_stem__sta, align 8
  %t249_vmsg = load i8*, i8** %_v_stem__msg, align 8
  %t250 = call i8* @flux_str_concat(i8* %t248, i8* %t249)
  %t251 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.80, i32 0, i32 0
  %t252 = call i8* @flux_str_concat(i8* %t250, i8* %t251)
  %pr_sn_2 = icmp eq i8* %t252, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t252
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  %t253 = load i64, i64* %_v_acertos, align 8
  %t253_vsta = load i8*, i8** %_v_acertos__sta, align 8
  %t253_vmsg = load i8*, i8** %_v_acertos__msg, align 8
  %t254 = add i64 0, 1
  %t255 = add i64 %t253, %t254
  store i64 %t255, i64* %_v_acertos, align 8
  %t256 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.91, i32 0, i32 0
  %t257_i64 = load i64, i64* %_v_nome, align 8
  %t257 = inttoptr i64 %t257_i64 to i8*
  %t257_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t257_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t258 = call i8* @flux_str_concat(i8* %t256, i8* %t257)
  %pr_sn_3 = icmp eq i8* %t258, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t258
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  br label %route_end_244
route_arm_245:
  %t260 = load i64, i64* %_v_erros, align 8
  %t260_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t260_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t261 = add i64 0, 1
  %t262 = add i64 %t260, %t261
  store i64 %t262, i64* %_v_erros, align 8
  %t263 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.88, i32 0, i32 0
  %t264_i64 = load i64, i64* %_v_nome, align 8
  %t264 = inttoptr i64 %t264_i64 to i8*
  %t264_vsta = load i8*, i8** %_v_nome__sta, align 8
  %t264_vmsg = load i8*, i8** %_v_nome__msg, align 8
  %t265 = call i8* @flux_str_concat(i8* %t263, i8* %t264)
  %t266 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.92, i32 0, i32 0
  %t267 = call i8* @flux_str_concat(i8* %t265, i8* %t266)
  %pr_sn_4 = icmp eq i8* %t267, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t267
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  br label %route_end_244
route_end_244:
  br label %route_end_176
route_end_176:
  br label %route_end_108
route_arm_109:
  br label %route_end_108
route_end_108:
  %t269 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %st_49 = ptrtoint i8* %t269 to i64
  store i64 %st_49, i64* %_v_cur_fname, align 8
  br label %route_end_99
route_arm_104:
  %t271_i64 = load i64, i64* %_v_cur_fname, align 8
  %t271 = inttoptr i64 %t271_i64 to i8*
  %t271_vsta = load i8*, i8** %_v_cur_fname__sta, align 8
  %t271_vmsg = load i8*, i8** %_v_cur_fname__msg, align 8
  %t272_i64 = load i64, i64* %_v_ch, align 8
  %t272 = inttoptr i64 %t272_i64 to i8*
  %t272_vsta = load i8*, i8** %_v_ch__sta, align 8
  %t272_vmsg = load i8*, i8** %_v_ch__msg, align 8
  %t273 = call i8* @flux_str_concat(i8* %t271, i8* %t272)
  %st_50 = ptrtoint i8* %t273 to i64
  store i64 %st_50, i64* %_v_cur_fname, align 8
  br label %route_end_99
route_end_99:
  %t274 = load i64, i64* %_v_li, align 8
  %t274_vsta = load i8*, i8** %_v_li__sta, align 8
  %t274_vmsg = load i8*, i8** %_v_li__msg, align 8
  %t275 = add i64 0, 1
  %t276 = add i64 %t274, %t275
  store i64 %t276, i64* %_v_li, align 8
  br label %route_end_89
route_end_89:
  br label %loop_start_88
loop_end_88:
  %t277 = getelementptr inbounds [66 x i8], [66 x i8]* @.str.93, i32 0, i32 0
  %t278 = call i64 @flux_std_os_exec(i8* %t277)
  %t279 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %pr_sn_5 = icmp eq i8* %t279, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t279
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  %t280 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.21, i32 0, i32 0
  %t281 = load i64, i64* %_v_acertos, align 8
  %t281_vsta = load i8*, i8** %_v_acertos__sta, align 8
  %t281_vmsg = load i8*, i8** %_v_acertos__msg, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t281)
  %t282 = call i8* @flux_str_concat(i8* %t280, i8* %cv_buf_1)
  %t283 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.94, i32 0, i32 0
  %t284 = call i8* @flux_str_concat(i8* %t282, i8* %t283)
  %t285 = load i64, i64* %_v_erros, align 8
  %t285_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t285_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t285)
  %t286 = call i8* @flux_str_concat(i8* %t284, i8* %cv_buf_2)
  %t287 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.95, i32 0, i32 0
  %t288 = call i8* @flux_str_concat(i8* %t286, i8* %t287)
  %pr_sn_6 = icmp eq i8* %t288, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t288
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  %t291 = load i64, i64* %_v_erros, align 8
  %t291_vsta = load i8*, i8** %_v_erros__sta, align 8
  %t291_vmsg = load i8*, i8** %_v_erros__msg, align 8
  %t292 = add i64 0, 0
  %t293 = icmp eq i64 %t291, %t292
  br i1 %t293, label %ft_24, label %route_arm_290
ft_24:
  %t294 = add i64 0, 0
  %t295 = call i64 @flux_std_os_exit(i64 %t294)
  br label %route_end_289
route_arm_290:
  %t297 = add i64 0, 1
  %t298 = call i64 @flux_std_os_exit(i64 %t297)
  br label %route_end_289
route_end_289:
  ret i32 0
}
