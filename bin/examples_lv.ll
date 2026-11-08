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
@.str.5 = private unnamed_addr constant [16 x i8] c".\5Cbin\5Cfluxc.exe\00", align 1
@.str.6 = private unnamed_addr constant [14 x i8] c"bin\5Cfluxc.exe\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"..\5Cbin\5Cfluxc.exe\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"fluxc.exe\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"fluxc\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"examples\5CCanon\00", align 1
@.str.11 = private unnamed_addr constant [17 x i8] c".\5Cexamples\5CCanon\00", align 1
@.str.12 = private unnamed_addr constant [18 x i8] c"..\5Cexamples\5CCanon\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"Canon\00", align 1
@.str.14 = private unnamed_addr constant [40 x i8] c"cmd /c if not exist t_llvm mkdir t_llvm\00", align 1
@.str.15 = private unnamed_addr constant [34 x i8] c"cmd /c if not exist dbs mkdir dbs\00", align 1
@.str.16 = private unnamed_addr constant [24 x i8] c"t_stdin_interactive.tmp\00", align 1
@.str.17 = private unnamed_addr constant [46 x i8] c"Ana\0A30\0A9.99\0Atrue\0AA\0A2+3i\0A2026-08-28T12:00:00Z\0A\00", align 1
@.str.18 = private unnamed_addr constant [21 x i8] c"t_stdin_contract.tmp\00", align 1
@.str.19 = private unnamed_addr constant [12 x i8] c"andre\0Aluiz\0A\00", align 1
@.str.20 = private unnamed_addr constant [17 x i8] c"t_stdin_dado.tmp\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"dado\0A\00", align 1
@.str.22 = private unnamed_addr constant [18 x i8] c"t_stdin_empty.tmp\00", align 1
@.str.23 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.24 = private unnamed_addr constant [19 x i8] c"cmd /c dir /b /on \00", align 1
@.str.25 = private unnamed_addr constant [27 x i8] c"\5C*.flux > t_canon_list.tmp\00", align 1
@.str.26 = private unnamed_addr constant [17 x i8] c"t_canon_list.tmp\00", align 1
@.str.27 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.28 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.29 = private unnamed_addr constant [2 x i8] c"\5C\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"--- \00", align 1
@.str.31 = private unnamed_addr constant [5 x i8] c" ---\00", align 1
@.str.32 = private unnamed_addr constant [11 x i8] c"input.flux\00", align 1
@.str.33 = private unnamed_addr constant [20 x i8] c"ExampleOfInput.flux\00", align 1
@.str.34 = private unnamed_addr constant [42 x i8] c"ExampleOfUseIoStdLib_IoInputContract.flux\00", align 1
@.str.35 = private unnamed_addr constant [9 x i8] c"DbStdLib\00", align 1
@.str.36 = private unnamed_addr constant [120 x i8] c"cmd /c del /q /f dbs\5Cflux_*.db* dbs\5Cflux_*.kv dbs\5Cflux_*.unqlite dbs\5Cflux_*.duckdb dbs\5Cflux_*.kuzu dbs\5Cflux_*.obx 2>nul\00", align 1
@.str.37 = private unnamed_addr constant [8 x i8] c"t_llvm\5C\00", align 1
@.str.38 = private unnamed_addr constant [4 x i8] c".ll\00", align 1
@.str.39 = private unnamed_addr constant [5 x i8] c".exe\00", align 1
@.str.40 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.41 = private unnamed_addr constant [14 x i8] c" --target lv \00", align 1
@.str.42 = private unnamed_addr constant [5 x i8] c" -o \00", align 1
@.str.43 = private unnamed_addr constant [13 x i8] c" --no-run < \00", align 1
@.str.44 = private unnamed_addr constant [20 x i8] c" > t_lv_c.tmp 2>&1\22\00", align 1
@.str.45 = private unnamed_addr constant [11 x i8] c"t_lv_c.tmp\00", align 1
@.str.46 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.47 = private unnamed_addr constant [13 x i8] c" (LLVM IR): \00", align 1
@.str.48 = private unnamed_addr constant [18 x i8] c" (.ll nao gerado)\00", align 1
@.str.49 = private unnamed_addr constant [10 x i8] c"  [ir]   \00", align 1
@.str.50 = private unnamed_addr constant [49 x i8] c" (clang nao encontrado ou executavel nao gerado)\00", align 1
@.str.51 = private unnamed_addr constant [10 x i8] c"  [exe]  \00", align 1
@.str.52 = private unnamed_addr constant [4 x i8] c" < \00", align 1
@.str.53 = private unnamed_addr constant [18 x i8] c" > t_lv.tmp 2>&1\22\00", align 1
@.str.54 = private unnamed_addr constant [9 x i8] c"t_lv.tmp\00", align 1
@.str.55 = private unnamed_addr constant [5 x i8] c"  | \00", align 1
@.str.56 = private unnamed_addr constant [9 x i8] c"  OK    \00", align 1
@.str.57 = private unnamed_addr constant [12 x i8] c"(exit code \00", align 1
@.str.58 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.59 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.60 = private unnamed_addr constant [74 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_lv_c.tmp t_lv.tmp t_canon_list.tmp 2>nul\00", align 1
@.str.61 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.62 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @flux_runtime_init_args(i32 %argc, i8** %argv)
  %fluxc_bin = alloca i64, align 8
  %canon_dir = alloca i64, align 8
  %list_content = alloca i64, align 8
  %lclen = alloca i64, align 8
  %acertos = alloca i64, align 8
  %erros = alloca i64, align 8
  %cur_fname = alloca i64, align 8
  %li = alloca i64, align 8
  %ch = alloca i64, align 8
  %nome = alloca i64, align 8
  %filepath = alloca i64, align 8
  %nlen = alloca i64, align 8
  %stem = alloca i64, align 8
  %stdin_file = alloca i64, align 8
  %di = alloca i64, align 8
  %out_stem = alloca i64, align 8
  %ll_file = alloca i64, align 8
  %exe_file = alloca i64, align 8
  %cmd_lv_c = alloca i64, align 8
  %rc_c = alloca i64, align 8
  %c_out = alloca i64, align 8
  %c_len = alloca i64, align 8
  %c_last_line = alloca i64, align 8
  %ci = alloca i64, align 8
  %cur_chunk = alloca i64, align 8
  %ch_c = alloca i64, align 8
  %cmd_run = alloca i64, align 8
  %rc_run = alloca i64, align 8
  %r_out = alloca i64, align 8
  %r_len = alloca i64, align 8
  %ch_r = alloca i64, align 8
  %r_last = alloca i64, align 8
  %t1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.5, i32 0, i32 0
  %st_1 = ptrtoint i8* %t1 to i64
  store i64 %st_1, i64* %fluxc_bin, align 8
  %t4 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.5, i32 0, i32 0
  %t5_i64 = call i64 @flux_std_io_file_exists(i8* %t4)
  %t5 = trunc i64 %t5_i64 to i1
  br i1 %t5, label %ft_0, label %route_arm_3
ft_0:
  %t6 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.5, i32 0, i32 0
  %st_2 = ptrtoint i8* %t6 to i64
  store i64 %st_2, i64* %fluxc_bin, align 8
  br label %route_end_2
route_arm_3:
  %t8 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.6, i32 0, i32 0
  %t9_i64 = call i64 @flux_std_io_file_exists(i8* %t8)
  %t9 = trunc i64 %t9_i64 to i1
  br i1 %t9, label %ft_1, label %route_arm_7
ft_1:
  %t10 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.6, i32 0, i32 0
  %st_3 = ptrtoint i8* %t10 to i64
  store i64 %st_3, i64* %fluxc_bin, align 8
  br label %route_end_2
route_arm_7:
  %t12 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.7, i32 0, i32 0
  %t13_i64 = call i64 @flux_std_io_file_exists(i8* %t12)
  %t13 = trunc i64 %t13_i64 to i1
  br i1 %t13, label %ft_2, label %route_arm_11
ft_2:
  %t14 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.7, i32 0, i32 0
  %st_4 = ptrtoint i8* %t14 to i64
  store i64 %st_4, i64* %fluxc_bin, align 8
  br label %route_end_2
route_arm_11:
  %t16 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.8, i32 0, i32 0
  %t17_i64 = call i64 @flux_std_io_file_exists(i8* %t16)
  %t17 = trunc i64 %t17_i64 to i1
  br i1 %t17, label %ft_3, label %route_arm_15
ft_3:
  %t18 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.8, i32 0, i32 0
  %st_5 = ptrtoint i8* %t18 to i64
  store i64 %st_5, i64* %fluxc_bin, align 8
  br label %route_end_2
route_arm_15:
  %t20 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.9, i32 0, i32 0
  %st_6 = ptrtoint i8* %t20 to i64
  store i64 %st_6, i64* %fluxc_bin, align 8
  br label %route_end_2
route_end_2:
  %t21 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.10, i32 0, i32 0
  %st_7 = ptrtoint i8* %t21 to i64
  store i64 %st_7, i64* %canon_dir, align 8
  %t24 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.10, i32 0, i32 0
  %t25_i64 = call i64 @flux_std_io_file_exists(i8* %t24)
  %t25 = trunc i64 %t25_i64 to i1
  br i1 %t25, label %ft_4, label %route_arm_23
ft_4:
  %t26 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.10, i32 0, i32 0
  %st_8 = ptrtoint i8* %t26 to i64
  store i64 %st_8, i64* %canon_dir, align 8
  br label %route_end_22
route_arm_23:
  %t28 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.11, i32 0, i32 0
  %t29_i64 = call i64 @flux_std_io_file_exists(i8* %t28)
  %t29 = trunc i64 %t29_i64 to i1
  br i1 %t29, label %ft_5, label %route_arm_27
ft_5:
  %t30 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.11, i32 0, i32 0
  %st_9 = ptrtoint i8* %t30 to i64
  store i64 %st_9, i64* %canon_dir, align 8
  br label %route_end_22
route_arm_27:
  %t32 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.12, i32 0, i32 0
  %t33_i64 = call i64 @flux_std_io_file_exists(i8* %t32)
  %t33 = trunc i64 %t33_i64 to i1
  br i1 %t33, label %ft_6, label %route_arm_31
ft_6:
  %t34 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.12, i32 0, i32 0
  %st_10 = ptrtoint i8* %t34 to i64
  store i64 %st_10, i64* %canon_dir, align 8
  br label %route_end_22
route_arm_31:
  %t36 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.13, i32 0, i32 0
  %t37_i64 = call i64 @flux_std_io_file_exists(i8* %t36)
  %t37 = trunc i64 %t37_i64 to i1
  br i1 %t37, label %ft_7, label %route_arm_35
ft_7:
  %t38 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.13, i32 0, i32 0
  %st_11 = ptrtoint i8* %t38 to i64
  store i64 %st_11, i64* %canon_dir, align 8
  br label %route_end_22
route_arm_35:
  %t40 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.10, i32 0, i32 0
  %st_12 = ptrtoint i8* %t40 to i64
  store i64 %st_12, i64* %canon_dir, align 8
  br label %route_end_22
route_end_22:
  %t41 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.14, i32 0, i32 0
  %t42 = call i64 @flux_std_os_exec(i8* %t41)
  %t43 = getelementptr inbounds [34 x i8], [34 x i8]* @.str.15, i32 0, i32 0
  %t44 = call i64 @flux_std_os_exec(i8* %t43)
  %t45 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.16, i32 0, i32 0
  %t46 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.17, i32 0, i32 0
  %t47 = call i64 @flux_std_io_write_file(i8* %t45, i8* %t46)
  %t48 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.18, i32 0, i32 0
  %t49 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.19, i32 0, i32 0
  %t50 = call i64 @flux_std_io_write_file(i8* %t48, i8* %t49)
  %t51 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.20, i32 0, i32 0
  %t52 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.21, i32 0, i32 0
  %t53 = call i64 @flux_std_io_write_file(i8* %t51, i8* %t52)
  %t54 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.22, i32 0, i32 0
  %t55 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t56 = call i64 @flux_std_io_write_file(i8* %t54, i8* %t55)
  %t57 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.24, i32 0, i32 0
  %t58_i64 = load i64, i64* %canon_dir, align 8
  %t58 = inttoptr i64 %t58_i64 to i8*
  %t59 = call i8* @flux_str_concat(i8* %t57, i8* %t58)
  %t60 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.25, i32 0, i32 0
  %t61 = call i8* @flux_str_concat(i8* %t59, i8* %t60)
  %t62 = call i64 @flux_std_os_exec(i8* %t61)
  %t63 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.26, i32 0, i32 0
  %t64 = call i8* @flux_std_io_read_file(i8* %t63)
  %st_13 = ptrtoint i8* %t64 to i64
  store i64 %st_13, i64* %list_content, align 8
  %t65_i64 = load i64, i64* %list_content, align 8
  %t65 = inttoptr i64 %t65_i64 to i8*
  %t66 = call i64 @flux_str_len(i8* %t65)
  store i64 %t66, i64* %lclen, align 8
  %t69 = load i64, i64* %lclen, align 8
  %t70 = add i64 0, 0
  %t71 = icmp sgt i64 %t69, %t70
  %t72_i64 = load i64, i64* %list_content, align 8
  %t72 = inttoptr i64 %t72_i64 to i8*
  %t73 = load i64, i64* %lclen, align 8
  %t74 = load i64, i64* %lclen, align 8
  %t75 = call i8* @flux_str_slice(i8* %t72, i64 %t73, i64 %t74)
  %t76 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t77_cmp = call i32 @flux_str_compare(i8* %t75, i8* %t76)
  %t77 = icmp ne i32 %t77_cmp, 0
  %t78 = and i1 %t71, %t77
  br i1 %t78, label %ft_8, label %route_arm_68
ft_8:
  %t79_i64 = load i64, i64* %list_content, align 8
  %t79 = inttoptr i64 %t79_i64 to i8*
  %t80 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t81 = call i8* @flux_str_concat(i8* %t79, i8* %t80)
  %st_15 = ptrtoint i8* %t81 to i64
  store i64 %st_15, i64* %list_content, align 8
  %t82 = load i64, i64* %lclen, align 8
  %t83 = add i64 0, 1
  %t84 = add i64 %t82, %t83
  store i64 %t84, i64* %lclen, align 8
  br label %route_end_67
route_arm_68:
  br label %route_end_67
route_end_67:
  %t86 = add i64 0, 0
  store i64 %t86, i64* %acertos, align 8
  %t87 = add i64 0, 0
  store i64 %t87, i64* %erros, align 8
  %t88 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_19 = ptrtoint i8* %t88 to i64
  store i64 %st_19, i64* %cur_fname, align 8
  %t89 = add i64 0, 1
  store i64 %t89, i64* %li, align 8
  br label %loop_start_90
loop_start_90:
  %t93 = load i64, i64* %li, align 8
  %t94 = load i64, i64* %lclen, align 8
  %t95 = icmp sgt i64 %t93, %t94
  br i1 %t95, label %ft_9, label %route_arm_92
ft_9:
  br label %loop_end_90
route_arm_92:
  %t97_i64 = load i64, i64* %list_content, align 8
  %t97 = inttoptr i64 %t97_i64 to i8*
  %t98 = load i64, i64* %li, align 8
  %t99 = load i64, i64* %li, align 8
  %t100 = call i8* @flux_str_slice(i8* %t97, i64 %t98, i64 %t99)
  %st_21 = ptrtoint i8* %t100 to i64
  store i64 %st_21, i64* %ch, align 8
  %t103_i64 = load i64, i64* %ch, align 8
  %t103 = inttoptr i64 %t103_i64 to i8*
  %t104 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.28, i32 0, i32 0
  %t105_cmp = call i32 @flux_str_compare(i8* %t103, i8* %t104)
  %t105 = icmp eq i32 %t105_cmp, 0
  br i1 %t105, label %ft_10, label %route_arm_102
ft_10:
  br label %route_end_101
route_arm_102:
  %t107_i64 = load i64, i64* %ch, align 8
  %t107 = inttoptr i64 %t107_i64 to i8*
  %t108 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t109_cmp = call i32 @flux_str_compare(i8* %t107, i8* %t108)
  %t109 = icmp eq i32 %t109_cmp, 0
  br i1 %t109, label %ft_11, label %route_arm_106
ft_11:
  %t112_i64 = load i64, i64* %cur_fname, align 8
  %t112 = inttoptr i64 %t112_i64 to i8*
  %t113 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t114_cmp = call i32 @flux_str_compare(i8* %t112, i8* %t113)
  %t114 = icmp ne i32 %t114_cmp, 0
  br i1 %t114, label %ft_12, label %route_arm_111
ft_12:
  %t115_i64 = load i64, i64* %cur_fname, align 8
  %t115 = inttoptr i64 %t115_i64 to i8*
  %st_22 = ptrtoint i8* %t115 to i64
  store i64 %st_22, i64* %nome, align 8
  %t116_i64 = load i64, i64* %canon_dir, align 8
  %t116 = inttoptr i64 %t116_i64 to i8*
  %t117 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.29, i32 0, i32 0
  %t118 = call i8* @flux_str_concat(i8* %t116, i8* %t117)
  %t119_i64 = load i64, i64* %nome, align 8
  %t119 = inttoptr i64 %t119_i64 to i8*
  %t120 = call i8* @flux_str_concat(i8* %t118, i8* %t119)
  %st_23 = ptrtoint i8* %t120 to i64
  store i64 %st_23, i64* %filepath, align 8
  %t121_i64 = load i64, i64* %nome, align 8
  %t121 = inttoptr i64 %t121_i64 to i8*
  %t122 = call i64 @flux_str_len(i8* %t121)
  store i64 %t122, i64* %nlen, align 8
  %t123_i64 = load i64, i64* %nome, align 8
  %t123 = inttoptr i64 %t123_i64 to i8*
  %t124 = add i64 0, 1
  %t125 = load i64, i64* %nlen, align 8
  %t126 = add i64 0, 5
  %t127 = sub i64 %t125, %t126
  %t128 = call i8* @flux_str_slice(i8* %t123, i64 %t124, i64 %t127)
  %st_25 = ptrtoint i8* %t128 to i64
  store i64 %st_25, i64* %stem, align 8
  %t129 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.30, i32 0, i32 0
  %t130_i64 = load i64, i64* %nome, align 8
  %t130 = inttoptr i64 %t130_i64 to i8*
  %t131 = call i8* @flux_str_concat(i8* %t129, i8* %t130)
  %t132 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.31, i32 0, i32 0
  %t133 = call i8* @flux_str_concat(i8* %t131, i8* %t132)
  %pr_sn_1 = icmp eq i8* %t133, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t133
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  %t134 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.22, i32 0, i32 0
  %st_26 = ptrtoint i8* %t134 to i64
  store i64 %st_26, i64* %stdin_file, align 8
  %t137_i64 = load i64, i64* %nome, align 8
  %t137 = inttoptr i64 %t137_i64 to i8*
  %t138 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.32, i32 0, i32 0
  %t139_cmp = call i32 @flux_str_compare(i8* %t137, i8* %t138)
  %t139 = icmp eq i32 %t139_cmp, 0
  br i1 %t139, label %ft_13, label %route_arm_136
ft_13:
  %t140 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.20, i32 0, i32 0
  %st_27 = ptrtoint i8* %t140 to i64
  store i64 %st_27, i64* %stdin_file, align 8
  br label %route_end_135
route_arm_136:
  %t142_i64 = load i64, i64* %nome, align 8
  %t142 = inttoptr i64 %t142_i64 to i8*
  %t143 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.33, i32 0, i32 0
  %t144_cmp = call i32 @flux_str_compare(i8* %t142, i8* %t143)
  %t144 = icmp eq i32 %t144_cmp, 0
  br i1 %t144, label %ft_14, label %route_arm_141
ft_14:
  %t145 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.16, i32 0, i32 0
  %st_28 = ptrtoint i8* %t145 to i64
  store i64 %st_28, i64* %stdin_file, align 8
  br label %route_end_135
route_arm_141:
  %t147_i64 = load i64, i64* %nome, align 8
  %t147 = inttoptr i64 %t147_i64 to i8*
  %t148 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.34, i32 0, i32 0
  %t149_cmp = call i32 @flux_str_compare(i8* %t147, i8* %t148)
  %t149 = icmp eq i32 %t149_cmp, 0
  br i1 %t149, label %ft_15, label %route_arm_146
ft_15:
  %t150 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.18, i32 0, i32 0
  %st_29 = ptrtoint i8* %t150 to i64
  store i64 %st_29, i64* %stdin_file, align 8
  br label %route_end_135
route_arm_146:
  br label %route_end_135
route_end_135:
  %t154 = load i64, i64* %nlen, align 8
  %t155 = add i64 0, 8
  %t156 = icmp sge i64 %t154, %t155
  br i1 %t156, label %ft_16, label %route_arm_153
ft_16:
  %t157 = add i64 0, 1
  store i64 %t157, i64* %di, align 8
  br label %loop_start_158
loop_start_158:
  %t161 = load i64, i64* %di, align 8
  %t162 = add i64 0, 7
  %t163 = add i64 %t161, %t162
  %t164 = load i64, i64* %nlen, align 8
  %t165 = icmp sgt i64 %t163, %t164
  br i1 %t165, label %ft_17, label %route_arm_160
ft_17:
  br label %loop_end_158
route_arm_160:
  %t167_i64 = load i64, i64* %nome, align 8
  %t167 = inttoptr i64 %t167_i64 to i8*
  %t168 = load i64, i64* %di, align 8
  %t169 = load i64, i64* %di, align 8
  %t170 = add i64 0, 7
  %t171 = add i64 %t169, %t170
  %t172 = call i8* @flux_str_slice(i8* %t167, i64 %t168, i64 %t171)
  %t173 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.35, i32 0, i32 0
  %t174_cmp = call i32 @flux_str_compare(i8* %t172, i8* %t173)
  %t174 = icmp eq i32 %t174_cmp, 0
  br i1 %t174, label %ft_18, label %route_arm_166
ft_18:
  %t175 = getelementptr inbounds [120 x i8], [120 x i8]* @.str.36, i32 0, i32 0
  %t176 = call i64 @flux_std_os_exec(i8* %t175)
  br label %loop_end_158
route_arm_166:
  %t178 = load i64, i64* %di, align 8
  %t179 = add i64 0, 1
  %t180 = add i64 %t178, %t179
  store i64 %t180, i64* %di, align 8
  br label %route_end_159
route_end_159:
  br label %loop_start_158
loop_end_158:
  br label %route_end_152
route_arm_153:
  br label %route_end_152
route_end_152:
  %t182 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.37, i32 0, i32 0
  %t183_i64 = load i64, i64* %stem, align 8
  %t183 = inttoptr i64 %t183_i64 to i8*
  %t184 = call i8* @flux_str_concat(i8* %t182, i8* %t183)
  %st_32 = ptrtoint i8* %t184 to i64
  store i64 %st_32, i64* %out_stem, align 8
  %t185 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.37, i32 0, i32 0
  %t186_i64 = load i64, i64* %stem, align 8
  %t186 = inttoptr i64 %t186_i64 to i8*
  %t187 = call i8* @flux_str_concat(i8* %t185, i8* %t186)
  %t188 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.38, i32 0, i32 0
  %t189 = call i8* @flux_str_concat(i8* %t187, i8* %t188)
  %st_33 = ptrtoint i8* %t189 to i64
  store i64 %st_33, i64* %ll_file, align 8
  %t190 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.37, i32 0, i32 0
  %t191_i64 = load i64, i64* %stem, align 8
  %t191 = inttoptr i64 %t191_i64 to i8*
  %t192 = call i8* @flux_str_concat(i8* %t190, i8* %t191)
  %t193 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.39, i32 0, i32 0
  %t194 = call i8* @flux_str_concat(i8* %t192, i8* %t193)
  %st_34 = ptrtoint i8* %t194 to i64
  store i64 %st_34, i64* %exe_file, align 8
  %t195 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.40, i32 0, i32 0
  %t196_i64 = load i64, i64* %fluxc_bin, align 8
  %t196 = inttoptr i64 %t196_i64 to i8*
  %t197 = call i8* @flux_str_concat(i8* %t195, i8* %t196)
  %t198 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.41, i32 0, i32 0
  %t199 = call i8* @flux_str_concat(i8* %t197, i8* %t198)
  %t200_i64 = load i64, i64* %filepath, align 8
  %t200 = inttoptr i64 %t200_i64 to i8*
  %t201 = call i8* @flux_str_concat(i8* %t199, i8* %t200)
  %t202 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.42, i32 0, i32 0
  %t203 = call i8* @flux_str_concat(i8* %t201, i8* %t202)
  %t204_i64 = load i64, i64* %out_stem, align 8
  %t204 = inttoptr i64 %t204_i64 to i8*
  %t205 = call i8* @flux_str_concat(i8* %t203, i8* %t204)
  %t206 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.43, i32 0, i32 0
  %t207 = call i8* @flux_str_concat(i8* %t205, i8* %t206)
  %t208_i64 = load i64, i64* %stdin_file, align 8
  %t208 = inttoptr i64 %t208_i64 to i8*
  %t209 = call i8* @flux_str_concat(i8* %t207, i8* %t208)
  %t210 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.44, i32 0, i32 0
  %t211 = call i8* @flux_str_concat(i8* %t209, i8* %t210)
  %st_35 = ptrtoint i8* %t211 to i64
  store i64 %st_35, i64* %cmd_lv_c, align 8
  %t212_i64 = load i64, i64* %cmd_lv_c, align 8
  %t212 = inttoptr i64 %t212_i64 to i8*
  %t213 = call i64 @flux_std_os_exec(i8* %t212)
  store i64 %t213, i64* %rc_c, align 8
  %t214 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.45, i32 0, i32 0
  %t215 = call i8* @flux_std_io_read_file(i8* %t214)
  %st_37 = ptrtoint i8* %t215 to i64
  store i64 %st_37, i64* %c_out, align 8
  %t216_i64 = load i64, i64* %c_out, align 8
  %t216 = inttoptr i64 %t216_i64 to i8*
  %t217 = call i64 @flux_str_len(i8* %t216)
  store i64 %t217, i64* %c_len, align 8
  %t218 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_39 = ptrtoint i8* %t218 to i64
  store i64 %st_39, i64* %c_last_line, align 8
  %t219 = add i64 0, 1
  store i64 %t219, i64* %ci, align 8
  %t220 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_41 = ptrtoint i8* %t220 to i64
  store i64 %st_41, i64* %cur_chunk, align 8
  br label %loop_start_221
loop_start_221:
  %t224 = load i64, i64* %ci, align 8
  %t225 = load i64, i64* %c_len, align 8
  %t226 = icmp sgt i64 %t224, %t225
  br i1 %t226, label %ft_19, label %route_arm_223
ft_19:
  br label %loop_end_221
route_arm_223:
  %t228_i64 = load i64, i64* %c_out, align 8
  %t228 = inttoptr i64 %t228_i64 to i8*
  %t229 = load i64, i64* %ci, align 8
  %t230 = load i64, i64* %ci, align 8
  %t231 = call i8* @flux_str_slice(i8* %t228, i64 %t229, i64 %t230)
  %st_42 = ptrtoint i8* %t231 to i64
  store i64 %st_42, i64* %ch_c, align 8
  %t234_i64 = load i64, i64* %ch_c, align 8
  %t234 = inttoptr i64 %t234_i64 to i8*
  %t235 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.28, i32 0, i32 0
  %t236_cmp = call i32 @flux_str_compare(i8* %t234, i8* %t235)
  %t236 = icmp eq i32 %t236_cmp, 0
  br i1 %t236, label %ft_20, label %route_arm_233
ft_20:
  br label %route_end_232
route_arm_233:
  %t238_i64 = load i64, i64* %ch_c, align 8
  %t238 = inttoptr i64 %t238_i64 to i8*
  %t239 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t240_cmp = call i32 @flux_str_compare(i8* %t238, i8* %t239)
  %t240 = icmp eq i32 %t240_cmp, 0
  br i1 %t240, label %ft_21, label %route_arm_237
ft_21:
  %t243_i64 = load i64, i64* %cur_chunk, align 8
  %t243 = inttoptr i64 %t243_i64 to i8*
  %t244 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t245_cmp = call i32 @flux_str_compare(i8* %t243, i8* %t244)
  %t245 = icmp ne i32 %t245_cmp, 0
  br i1 %t245, label %ft_22, label %route_arm_242
ft_22:
  %t246_i64 = load i64, i64* %cur_chunk, align 8
  %t246 = inttoptr i64 %t246_i64 to i8*
  %st_43 = ptrtoint i8* %t246 to i64
  store i64 %st_43, i64* %c_last_line, align 8
  br label %route_end_241
route_arm_242:
  br label %route_end_241
route_end_241:
  %t248 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_44 = ptrtoint i8* %t248 to i64
  store i64 %st_44, i64* %cur_chunk, align 8
  br label %route_end_232
route_arm_237:
  %t250_i64 = load i64, i64* %cur_chunk, align 8
  %t250 = inttoptr i64 %t250_i64 to i8*
  %t251_i64 = load i64, i64* %ch_c, align 8
  %t251 = inttoptr i64 %t251_i64 to i8*
  %t252 = call i8* @flux_str_concat(i8* %t250, i8* %t251)
  %st_45 = ptrtoint i8* %t252 to i64
  store i64 %st_45, i64* %cur_chunk, align 8
  br label %route_end_232
route_end_232:
  %t253 = load i64, i64* %ci, align 8
  %t254 = add i64 0, 1
  %t255 = add i64 %t253, %t254
  store i64 %t255, i64* %ci, align 8
  br label %route_end_222
route_end_222:
  br label %loop_start_221
loop_end_221:
  %t258_i64 = load i64, i64* %cur_chunk, align 8
  %t258 = inttoptr i64 %t258_i64 to i8*
  %t259 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t260_cmp = call i32 @flux_str_compare(i8* %t258, i8* %t259)
  %t260 = icmp ne i32 %t260_cmp, 0
  br i1 %t260, label %ft_23, label %route_arm_257
ft_23:
  %t261_i64 = load i64, i64* %cur_chunk, align 8
  %t261 = inttoptr i64 %t261_i64 to i8*
  %st_47 = ptrtoint i8* %t261 to i64
  store i64 %st_47, i64* %c_last_line, align 8
  br label %route_end_256
route_arm_257:
  br label %route_end_256
route_end_256:
  %t265 = load i64, i64* %rc_c, align 8
  %t266 = add i64 0, 0
  %t267 = icmp ne i64 %t265, %t266
  br i1 %t267, label %ft_24, label %route_arm_264
ft_24:
  %t268 = load i64, i64* %erros, align 8
  %t269 = add i64 0, 1
  %t270 = add i64 %t268, %t269
  store i64 %t270, i64* %erros, align 8
  %t271 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.46, i32 0, i32 0
  %t272_i64 = load i64, i64* %nome, align 8
  %t272 = inttoptr i64 %t272_i64 to i8*
  %t273 = call i8* @flux_str_concat(i8* %t271, i8* %t272)
  %t274 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.47, i32 0, i32 0
  %t275 = call i8* @flux_str_concat(i8* %t273, i8* %t274)
  %t276_i64 = load i64, i64* %c_last_line, align 8
  %t276 = inttoptr i64 %t276_i64 to i8*
  %t277 = call i8* @flux_str_concat(i8* %t275, i8* %t276)
  %pr_sn_2 = icmp eq i8* %t277, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t277
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  br label %route_end_263
route_arm_264:
  %t279_i64 = load i64, i64* %ll_file, align 8
  %t279 = inttoptr i64 %t279_i64 to i8*
  %t280_i64 = call i64 @flux_std_io_file_exists(i8* %t279)
  %t280 = trunc i64 %t280_i64 to i1
  %t281 = xor i1 %t280, 1
  br i1 %t281, label %ft_25, label %route_arm_278
ft_25:
  %t282 = load i64, i64* %erros, align 8
  %t283 = add i64 0, 1
  %t284 = add i64 %t282, %t283
  store i64 %t284, i64* %erros, align 8
  %t285 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.46, i32 0, i32 0
  %t286_i64 = load i64, i64* %nome, align 8
  %t286 = inttoptr i64 %t286_i64 to i8*
  %t287 = call i8* @flux_str_concat(i8* %t285, i8* %t286)
  %t288 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.48, i32 0, i32 0
  %t289 = call i8* @flux_str_concat(i8* %t287, i8* %t288)
  %pr_sn_3 = icmp eq i8* %t289, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t289
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  br label %route_end_263
route_arm_278:
  %t291 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.49, i32 0, i32 0
  %t292_i64 = load i64, i64* %stem, align 8
  %t292 = inttoptr i64 %t292_i64 to i8*
  %t293 = call i8* @flux_str_concat(i8* %t291, i8* %t292)
  %t294 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.38, i32 0, i32 0
  %t295 = call i8* @flux_str_concat(i8* %t293, i8* %t294)
  %pr_sn_4 = icmp eq i8* %t295, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t295
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  %t298_i64 = load i64, i64* %exe_file, align 8
  %t298 = inttoptr i64 %t298_i64 to i8*
  %t299_i64 = call i64 @flux_std_io_file_exists(i8* %t298)
  %t299 = trunc i64 %t299_i64 to i1
  %t300 = xor i1 %t299, 1
  br i1 %t300, label %ft_26, label %route_arm_297
ft_26:
  %t301 = load i64, i64* %erros, align 8
  %t302 = add i64 0, 1
  %t303 = add i64 %t301, %t302
  store i64 %t303, i64* %erros, align 8
  %t304 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.46, i32 0, i32 0
  %t305_i64 = load i64, i64* %nome, align 8
  %t305 = inttoptr i64 %t305_i64 to i8*
  %t306 = call i8* @flux_str_concat(i8* %t304, i8* %t305)
  %t307 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.50, i32 0, i32 0
  %t308 = call i8* @flux_str_concat(i8* %t306, i8* %t307)
  %pr_sn_5 = icmp eq i8* %t308, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t308
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  br label %route_end_296
route_arm_297:
  %t310 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.51, i32 0, i32 0
  %t311_i64 = load i64, i64* %stem, align 8
  %t311 = inttoptr i64 %t311_i64 to i8*
  %t312 = call i8* @flux_str_concat(i8* %t310, i8* %t311)
  %t313 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.39, i32 0, i32 0
  %t314 = call i8* @flux_str_concat(i8* %t312, i8* %t313)
  %pr_sn_6 = icmp eq i8* %t314, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t314
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  %t315 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.40, i32 0, i32 0
  %t316_i64 = load i64, i64* %exe_file, align 8
  %t316 = inttoptr i64 %t316_i64 to i8*
  %t317 = call i8* @flux_str_concat(i8* %t315, i8* %t316)
  %t318 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.52, i32 0, i32 0
  %t319 = call i8* @flux_str_concat(i8* %t317, i8* %t318)
  %t320_i64 = load i64, i64* %stdin_file, align 8
  %t320 = inttoptr i64 %t320_i64 to i8*
  %t321 = call i8* @flux_str_concat(i8* %t319, i8* %t320)
  %t322 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.53, i32 0, i32 0
  %t323 = call i8* @flux_str_concat(i8* %t321, i8* %t322)
  %st_51 = ptrtoint i8* %t323 to i64
  store i64 %st_51, i64* %cmd_run, align 8
  %t324_i64 = load i64, i64* %cmd_run, align 8
  %t324 = inttoptr i64 %t324_i64 to i8*
  %t325 = call i64 @flux_std_os_exec(i8* %t324)
  store i64 %t325, i64* %rc_run, align 8
  %t326 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.54, i32 0, i32 0
  %t327 = call i8* @flux_std_io_read_file(i8* %t326)
  %st_53 = ptrtoint i8* %t327 to i64
  store i64 %st_53, i64* %r_out, align 8
  %t328_i64 = load i64, i64* %r_out, align 8
  %t328 = inttoptr i64 %t328_i64 to i8*
  %t329 = call i64 @flux_str_len(i8* %t328)
  store i64 %t329, i64* %r_len, align 8
  %t332 = load i64, i64* %rc_run, align 8
  %t333 = add i64 0, 0
  %t334 = icmp eq i64 %t332, %t333
  br i1 %t334, label %ft_27, label %route_arm_331
ft_27:
  %t335 = load i64, i64* %acertos, align 8
  %t336 = add i64 0, 1
  %t337 = add i64 %t335, %t336
  store i64 %t337, i64* %acertos, align 8
  %t338 = add i64 0, 1
  store i64 %t338, i64* %ci, align 8
  %t339 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_57 = ptrtoint i8* %t339 to i64
  store i64 %st_57, i64* %cur_chunk, align 8
  br label %loop_start_340
loop_start_340:
  %t343 = load i64, i64* %ci, align 8
  %t344 = load i64, i64* %r_len, align 8
  %t345 = icmp sgt i64 %t343, %t344
  br i1 %t345, label %ft_28, label %route_arm_342
ft_28:
  br label %loop_end_340
route_arm_342:
  %t347_i64 = load i64, i64* %r_out, align 8
  %t347 = inttoptr i64 %t347_i64 to i8*
  %t348 = load i64, i64* %ci, align 8
  %t349 = load i64, i64* %ci, align 8
  %t350 = call i8* @flux_str_slice(i8* %t347, i64 %t348, i64 %t349)
  %st_58 = ptrtoint i8* %t350 to i64
  store i64 %st_58, i64* %ch_r, align 8
  %t353_i64 = load i64, i64* %ch_r, align 8
  %t353 = inttoptr i64 %t353_i64 to i8*
  %t354 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.28, i32 0, i32 0
  %t355_cmp = call i32 @flux_str_compare(i8* %t353, i8* %t354)
  %t355 = icmp eq i32 %t355_cmp, 0
  br i1 %t355, label %ft_29, label %route_arm_352
ft_29:
  br label %route_end_351
route_arm_352:
  %t357_i64 = load i64, i64* %ch_r, align 8
  %t357 = inttoptr i64 %t357_i64 to i8*
  %t358 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t359_cmp = call i32 @flux_str_compare(i8* %t357, i8* %t358)
  %t359 = icmp eq i32 %t359_cmp, 0
  br i1 %t359, label %ft_30, label %route_arm_356
ft_30:
  %t360 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.55, i32 0, i32 0
  %t361_i64 = load i64, i64* %cur_chunk, align 8
  %t361 = inttoptr i64 %t361_i64 to i8*
  %t362 = call i8* @flux_str_concat(i8* %t360, i8* %t361)
  %pr_sn_7 = icmp eq i8* %t362, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t362
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  %t363 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_59 = ptrtoint i8* %t363 to i64
  store i64 %st_59, i64* %cur_chunk, align 8
  br label %route_end_351
route_arm_356:
  %t365_i64 = load i64, i64* %cur_chunk, align 8
  %t365 = inttoptr i64 %t365_i64 to i8*
  %t366_i64 = load i64, i64* %ch_r, align 8
  %t366 = inttoptr i64 %t366_i64 to i8*
  %t367 = call i8* @flux_str_concat(i8* %t365, i8* %t366)
  %st_60 = ptrtoint i8* %t367 to i64
  store i64 %st_60, i64* %cur_chunk, align 8
  br label %route_end_351
route_end_351:
  %t368 = load i64, i64* %ci, align 8
  %t369 = add i64 0, 1
  %t370 = add i64 %t368, %t369
  store i64 %t370, i64* %ci, align 8
  br label %route_end_341
route_end_341:
  br label %loop_start_340
loop_end_340:
  %t373_i64 = load i64, i64* %cur_chunk, align 8
  %t373 = inttoptr i64 %t373_i64 to i8*
  %t374 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t375_cmp = call i32 @flux_str_compare(i8* %t373, i8* %t374)
  %t375 = icmp ne i32 %t375_cmp, 0
  br i1 %t375, label %ft_31, label %route_arm_372
ft_31:
  %t376 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.55, i32 0, i32 0
  %t377_i64 = load i64, i64* %cur_chunk, align 8
  %t377 = inttoptr i64 %t377_i64 to i8*
  %t378 = call i8* @flux_str_concat(i8* %t376, i8* %t377)
  %pr_sn_8 = icmp eq i8* %t378, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t378
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  br label %route_end_371
route_arm_372:
  br label %route_end_371
route_end_371:
  %t380 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.56, i32 0, i32 0
  %t381_i64 = load i64, i64* %nome, align 8
  %t381 = inttoptr i64 %t381_i64 to i8*
  %t382 = call i8* @flux_str_concat(i8* %t380, i8* %t381)
  %pr_sn_9 = icmp eq i8* %t382, null
  %pr_sc_9 = select i1 %pr_sn_9, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t382
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_9)
  call i32 @fflush(i8* null)
  br label %route_end_330
route_arm_331:
  %t384 = load i64, i64* %erros, align 8
  %t385 = add i64 0, 1
  %t386 = add i64 %t384, %t385
  store i64 %t386, i64* %erros, align 8
  %t387 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_63 = ptrtoint i8* %t387 to i64
  store i64 %st_63, i64* %r_last, align 8
  %t388 = add i64 0, 1
  store i64 %t388, i64* %ci, align 8
  %t389 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_65 = ptrtoint i8* %t389 to i64
  store i64 %st_65, i64* %cur_chunk, align 8
  br label %loop_start_390
loop_start_390:
  %t393 = load i64, i64* %ci, align 8
  %t394 = load i64, i64* %r_len, align 8
  %t395 = icmp sgt i64 %t393, %t394
  br i1 %t395, label %ft_32, label %route_arm_392
ft_32:
  br label %loop_end_390
route_arm_392:
  %t397_i64 = load i64, i64* %r_out, align 8
  %t397 = inttoptr i64 %t397_i64 to i8*
  %t398 = load i64, i64* %ci, align 8
  %t399 = load i64, i64* %ci, align 8
  %t400 = call i8* @flux_str_slice(i8* %t397, i64 %t398, i64 %t399)
  %st_66 = ptrtoint i8* %t400 to i64
  store i64 %st_66, i64* %ch_r, align 8
  %t403_i64 = load i64, i64* %ch_r, align 8
  %t403 = inttoptr i64 %t403_i64 to i8*
  %t404 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.28, i32 0, i32 0
  %t405_cmp = call i32 @flux_str_compare(i8* %t403, i8* %t404)
  %t405 = icmp eq i32 %t405_cmp, 0
  br i1 %t405, label %ft_33, label %route_arm_402
ft_33:
  br label %route_end_401
route_arm_402:
  %t407_i64 = load i64, i64* %ch_r, align 8
  %t407 = inttoptr i64 %t407_i64 to i8*
  %t408 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t409_cmp = call i32 @flux_str_compare(i8* %t407, i8* %t408)
  %t409 = icmp eq i32 %t409_cmp, 0
  br i1 %t409, label %ft_34, label %route_arm_406
ft_34:
  %t412_i64 = load i64, i64* %cur_chunk, align 8
  %t412 = inttoptr i64 %t412_i64 to i8*
  %t413 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t414_cmp = call i32 @flux_str_compare(i8* %t412, i8* %t413)
  %t414 = icmp ne i32 %t414_cmp, 0
  br i1 %t414, label %ft_35, label %route_arm_411
ft_35:
  %t415_i64 = load i64, i64* %cur_chunk, align 8
  %t415 = inttoptr i64 %t415_i64 to i8*
  %st_67 = ptrtoint i8* %t415 to i64
  store i64 %st_67, i64* %r_last, align 8
  br label %route_end_410
route_arm_411:
  br label %route_end_410
route_end_410:
  %t417 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_68 = ptrtoint i8* %t417 to i64
  store i64 %st_68, i64* %cur_chunk, align 8
  br label %route_end_401
route_arm_406:
  %t419_i64 = load i64, i64* %cur_chunk, align 8
  %t419 = inttoptr i64 %t419_i64 to i8*
  %t420_i64 = load i64, i64* %ch_r, align 8
  %t420 = inttoptr i64 %t420_i64 to i8*
  %t421 = call i8* @flux_str_concat(i8* %t419, i8* %t420)
  %st_69 = ptrtoint i8* %t421 to i64
  store i64 %st_69, i64* %cur_chunk, align 8
  br label %route_end_401
route_end_401:
  %t422 = load i64, i64* %ci, align 8
  %t423 = add i64 0, 1
  %t424 = add i64 %t422, %t423
  store i64 %t424, i64* %ci, align 8
  br label %route_end_391
route_end_391:
  br label %loop_start_390
loop_end_390:
  %t427_i64 = load i64, i64* %cur_chunk, align 8
  %t427 = inttoptr i64 %t427_i64 to i8*
  %t428 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t429_cmp = call i32 @flux_str_compare(i8* %t427, i8* %t428)
  %t429 = icmp ne i32 %t429_cmp, 0
  br i1 %t429, label %ft_36, label %route_arm_426
ft_36:
  %t430_i64 = load i64, i64* %cur_chunk, align 8
  %t430 = inttoptr i64 %t430_i64 to i8*
  %st_71 = ptrtoint i8* %t430 to i64
  store i64 %st_71, i64* %r_last, align 8
  br label %route_end_425
route_arm_426:
  br label %route_end_425
route_end_425:
  %t434_i64 = load i64, i64* %r_last, align 8
  %t434 = inttoptr i64 %t434_i64 to i8*
  %t435 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t436_cmp = call i32 @flux_str_compare(i8* %t434, i8* %t435)
  %t436 = icmp eq i32 %t436_cmp, 0
  br i1 %t436, label %ft_37, label %route_arm_433
ft_37:
  %t437 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.57, i32 0, i32 0
  %t438 = load i64, i64* %rc_run, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t438)
  %t439 = call i8* @flux_str_concat(i8* %t437, i8* %cv_buf_1)
  %t440 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.58, i32 0, i32 0
  %t441 = call i8* @flux_str_concat(i8* %t439, i8* %t440)
  %st_72 = ptrtoint i8* %t441 to i64
  store i64 %st_72, i64* %r_last, align 8
  br label %route_end_432
route_arm_433:
  br label %route_end_432
route_end_432:
  %t443 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.46, i32 0, i32 0
  %t444_i64 = load i64, i64* %nome, align 8
  %t444 = inttoptr i64 %t444_i64 to i8*
  %t445 = call i8* @flux_str_concat(i8* %t443, i8* %t444)
  %t446 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.59, i32 0, i32 0
  %t447 = call i8* @flux_str_concat(i8* %t445, i8* %t446)
  %t448_i64 = load i64, i64* %r_last, align 8
  %t448 = inttoptr i64 %t448_i64 to i8*
  %t449 = call i8* @flux_str_concat(i8* %t447, i8* %t448)
  %pr_sn_10 = icmp eq i8* %t449, null
  %pr_sc_10 = select i1 %pr_sn_10, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t449
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_10)
  call i32 @fflush(i8* null)
  br label %route_end_330
route_end_330:
  br label %route_end_296
route_end_296:
  br label %route_end_263
route_end_263:
  br label %route_end_110
route_arm_111:
  br label %route_end_110
route_end_110:
  %t451 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_73 = ptrtoint i8* %t451 to i64
  store i64 %st_73, i64* %cur_fname, align 8
  br label %route_end_101
route_arm_106:
  %t453_i64 = load i64, i64* %cur_fname, align 8
  %t453 = inttoptr i64 %t453_i64 to i8*
  %t454_i64 = load i64, i64* %ch, align 8
  %t454 = inttoptr i64 %t454_i64 to i8*
  %t455 = call i8* @flux_str_concat(i8* %t453, i8* %t454)
  %st_74 = ptrtoint i8* %t455 to i64
  store i64 %st_74, i64* %cur_fname, align 8
  br label %route_end_101
route_end_101:
  %t456 = load i64, i64* %li, align 8
  %t457 = add i64 0, 1
  %t458 = add i64 %t456, %t457
  store i64 %t458, i64* %li, align 8
  br label %route_end_91
route_end_91:
  br label %loop_start_90
loop_end_90:
  %t459 = getelementptr inbounds [74 x i8], [74 x i8]* @.str.60, i32 0, i32 0
  %t460 = call i64 @flux_std_os_exec(i8* %t459)
  %t461 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %pr_sn_11 = icmp eq i8* %t461, null
  %pr_sc_11 = select i1 %pr_sn_11, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t461
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_11)
  call i32 @fflush(i8* null)
  %t462 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t463 = load i64, i64* %acertos, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t463)
  %t464 = call i8* @flux_str_concat(i8* %t462, i8* %cv_buf_2)
  %t465 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.61, i32 0, i32 0
  %t466 = call i8* @flux_str_concat(i8* %t464, i8* %t465)
  %t467 = load i64, i64* %erros, align 8
  %cv_buf_3 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_3, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t467)
  %t468 = call i8* @flux_str_concat(i8* %t466, i8* %cv_buf_3)
  %t469 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.62, i32 0, i32 0
  %t470 = call i8* @flux_str_concat(i8* %t468, i8* %t469)
  %pr_sn_12 = icmp eq i8* %t470, null
  %pr_sc_12 = select i1 %pr_sn_12, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t470
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_12)
  call i32 @fflush(i8* null)
  %t473 = load i64, i64* %erros, align 8
  %t474 = add i64 0, 0
  %t475 = icmp eq i64 %t473, %t474
  br i1 %t475, label %ft_38, label %route_arm_472
ft_38:
  %t476 = add i64 0, 0
  %t477 = call i64 @flux_std_os_exit(i64 %t476)
  br label %route_end_471
route_arm_472:
  %t479 = add i64 0, 1
  %t480 = call i64 @flux_std_os_exit(i64 %t479)
  br label %route_end_471
route_end_471:
  ret i32 0
}
