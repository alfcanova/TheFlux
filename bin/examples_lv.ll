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
  %t362_i64 = load i64, i64* %cur_chunk, align 8
  %t362 = inttoptr i64 %t362_i64 to i8*
  %t363 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t364_cmp = call i32 @flux_str_compare(i8* %t362, i8* %t363)
  %t364 = icmp ne i32 %t364_cmp, 0
  br i1 %t364, label %ft_31, label %route_arm_361
ft_31:
  %t365 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.55, i32 0, i32 0
  %t366_i64 = load i64, i64* %cur_chunk, align 8
  %t366 = inttoptr i64 %t366_i64 to i8*
  %t367 = call i8* @flux_str_concat(i8* %t365, i8* %t366)
  %pr_sn_7 = icmp eq i8* %t367, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t367
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  br label %route_end_360
route_arm_361:
  br label %route_end_360
route_end_360:
  %t369 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_59 = ptrtoint i8* %t369 to i64
  store i64 %st_59, i64* %cur_chunk, align 8
  br label %route_end_351
route_arm_356:
  %t371_i64 = load i64, i64* %cur_chunk, align 8
  %t371 = inttoptr i64 %t371_i64 to i8*
  %t372_i64 = load i64, i64* %ch_r, align 8
  %t372 = inttoptr i64 %t372_i64 to i8*
  %t373 = call i8* @flux_str_concat(i8* %t371, i8* %t372)
  %st_60 = ptrtoint i8* %t373 to i64
  store i64 %st_60, i64* %cur_chunk, align 8
  br label %route_end_351
route_end_351:
  %t374 = load i64, i64* %ci, align 8
  %t375 = add i64 0, 1
  %t376 = add i64 %t374, %t375
  store i64 %t376, i64* %ci, align 8
  br label %route_end_341
route_end_341:
  br label %loop_start_340
loop_end_340:
  %t379_i64 = load i64, i64* %cur_chunk, align 8
  %t379 = inttoptr i64 %t379_i64 to i8*
  %t380 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t381_cmp = call i32 @flux_str_compare(i8* %t379, i8* %t380)
  %t381 = icmp ne i32 %t381_cmp, 0
  br i1 %t381, label %ft_32, label %route_arm_378
ft_32:
  %t382 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.55, i32 0, i32 0
  %t383_i64 = load i64, i64* %cur_chunk, align 8
  %t383 = inttoptr i64 %t383_i64 to i8*
  %t384 = call i8* @flux_str_concat(i8* %t382, i8* %t383)
  %pr_sn_8 = icmp eq i8* %t384, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t384
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  br label %route_end_377
route_arm_378:
  br label %route_end_377
route_end_377:
  %t386 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.56, i32 0, i32 0
  %t387_i64 = load i64, i64* %nome, align 8
  %t387 = inttoptr i64 %t387_i64 to i8*
  %t388 = call i8* @flux_str_concat(i8* %t386, i8* %t387)
  %pr_sn_9 = icmp eq i8* %t388, null
  %pr_sc_9 = select i1 %pr_sn_9, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t388
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_9)
  call i32 @fflush(i8* null)
  br label %route_end_330
route_arm_331:
  %t390 = load i64, i64* %erros, align 8
  %t391 = add i64 0, 1
  %t392 = add i64 %t390, %t391
  store i64 %t392, i64* %erros, align 8
  %t393 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_63 = ptrtoint i8* %t393 to i64
  store i64 %st_63, i64* %r_last, align 8
  %t394 = add i64 0, 1
  store i64 %t394, i64* %ci, align 8
  %t395 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_65 = ptrtoint i8* %t395 to i64
  store i64 %st_65, i64* %cur_chunk, align 8
  br label %loop_start_396
loop_start_396:
  %t399 = load i64, i64* %ci, align 8
  %t400 = load i64, i64* %r_len, align 8
  %t401 = icmp sgt i64 %t399, %t400
  br i1 %t401, label %ft_33, label %route_arm_398
ft_33:
  br label %loop_end_396
route_arm_398:
  %t403_i64 = load i64, i64* %r_out, align 8
  %t403 = inttoptr i64 %t403_i64 to i8*
  %t404 = load i64, i64* %ci, align 8
  %t405 = load i64, i64* %ci, align 8
  %t406 = call i8* @flux_str_slice(i8* %t403, i64 %t404, i64 %t405)
  %st_66 = ptrtoint i8* %t406 to i64
  store i64 %st_66, i64* %ch_r, align 8
  %t409_i64 = load i64, i64* %ch_r, align 8
  %t409 = inttoptr i64 %t409_i64 to i8*
  %t410 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.28, i32 0, i32 0
  %t411_cmp = call i32 @flux_str_compare(i8* %t409, i8* %t410)
  %t411 = icmp eq i32 %t411_cmp, 0
  br i1 %t411, label %ft_34, label %route_arm_408
ft_34:
  br label %route_end_407
route_arm_408:
  %t413_i64 = load i64, i64* %ch_r, align 8
  %t413 = inttoptr i64 %t413_i64 to i8*
  %t414 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t415_cmp = call i32 @flux_str_compare(i8* %t413, i8* %t414)
  %t415 = icmp eq i32 %t415_cmp, 0
  br i1 %t415, label %ft_35, label %route_arm_412
ft_35:
  %t418_i64 = load i64, i64* %cur_chunk, align 8
  %t418 = inttoptr i64 %t418_i64 to i8*
  %t419 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t420_cmp = call i32 @flux_str_compare(i8* %t418, i8* %t419)
  %t420 = icmp ne i32 %t420_cmp, 0
  br i1 %t420, label %ft_36, label %route_arm_417
ft_36:
  %t421_i64 = load i64, i64* %cur_chunk, align 8
  %t421 = inttoptr i64 %t421_i64 to i8*
  %st_67 = ptrtoint i8* %t421 to i64
  store i64 %st_67, i64* %r_last, align 8
  br label %route_end_416
route_arm_417:
  br label %route_end_416
route_end_416:
  %t423 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_68 = ptrtoint i8* %t423 to i64
  store i64 %st_68, i64* %cur_chunk, align 8
  br label %route_end_407
route_arm_412:
  %t425_i64 = load i64, i64* %cur_chunk, align 8
  %t425 = inttoptr i64 %t425_i64 to i8*
  %t426_i64 = load i64, i64* %ch_r, align 8
  %t426 = inttoptr i64 %t426_i64 to i8*
  %t427 = call i8* @flux_str_concat(i8* %t425, i8* %t426)
  %st_69 = ptrtoint i8* %t427 to i64
  store i64 %st_69, i64* %cur_chunk, align 8
  br label %route_end_407
route_end_407:
  %t428 = load i64, i64* %ci, align 8
  %t429 = add i64 0, 1
  %t430 = add i64 %t428, %t429
  store i64 %t430, i64* %ci, align 8
  br label %route_end_397
route_end_397:
  br label %loop_start_396
loop_end_396:
  %t433_i64 = load i64, i64* %cur_chunk, align 8
  %t433 = inttoptr i64 %t433_i64 to i8*
  %t434 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t435_cmp = call i32 @flux_str_compare(i8* %t433, i8* %t434)
  %t435 = icmp ne i32 %t435_cmp, 0
  br i1 %t435, label %ft_37, label %route_arm_432
ft_37:
  %t436_i64 = load i64, i64* %cur_chunk, align 8
  %t436 = inttoptr i64 %t436_i64 to i8*
  %st_71 = ptrtoint i8* %t436 to i64
  store i64 %st_71, i64* %r_last, align 8
  br label %route_end_431
route_arm_432:
  br label %route_end_431
route_end_431:
  %t440_i64 = load i64, i64* %r_last, align 8
  %t440 = inttoptr i64 %t440_i64 to i8*
  %t441 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t442_cmp = call i32 @flux_str_compare(i8* %t440, i8* %t441)
  %t442 = icmp eq i32 %t442_cmp, 0
  br i1 %t442, label %ft_38, label %route_arm_439
ft_38:
  %t443 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.57, i32 0, i32 0
  %t444 = load i64, i64* %rc_run, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t444)
  %t445 = call i8* @flux_str_concat(i8* %t443, i8* %cv_buf_1)
  %t446 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.58, i32 0, i32 0
  %t447 = call i8* @flux_str_concat(i8* %t445, i8* %t446)
  %st_72 = ptrtoint i8* %t447 to i64
  store i64 %st_72, i64* %r_last, align 8
  br label %route_end_438
route_arm_439:
  br label %route_end_438
route_end_438:
  %t449 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.46, i32 0, i32 0
  %t450_i64 = load i64, i64* %nome, align 8
  %t450 = inttoptr i64 %t450_i64 to i8*
  %t451 = call i8* @flux_str_concat(i8* %t449, i8* %t450)
  %t452 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.59, i32 0, i32 0
  %t453 = call i8* @flux_str_concat(i8* %t451, i8* %t452)
  %t454_i64 = load i64, i64* %r_last, align 8
  %t454 = inttoptr i64 %t454_i64 to i8*
  %t455 = call i8* @flux_str_concat(i8* %t453, i8* %t454)
  %pr_sn_10 = icmp eq i8* %t455, null
  %pr_sc_10 = select i1 %pr_sn_10, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t455
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
  %t457 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %st_73 = ptrtoint i8* %t457 to i64
  store i64 %st_73, i64* %cur_fname, align 8
  br label %route_end_101
route_arm_106:
  %t459_i64 = load i64, i64* %cur_fname, align 8
  %t459 = inttoptr i64 %t459_i64 to i8*
  %t460_i64 = load i64, i64* %ch, align 8
  %t460 = inttoptr i64 %t460_i64 to i8*
  %t461 = call i8* @flux_str_concat(i8* %t459, i8* %t460)
  %st_74 = ptrtoint i8* %t461 to i64
  store i64 %st_74, i64* %cur_fname, align 8
  br label %route_end_101
route_end_101:
  %t462 = load i64, i64* %li, align 8
  %t463 = add i64 0, 1
  %t464 = add i64 %t462, %t463
  store i64 %t464, i64* %li, align 8
  br label %route_end_91
route_end_91:
  br label %loop_start_90
loop_end_90:
  %t465 = getelementptr inbounds [74 x i8], [74 x i8]* @.str.60, i32 0, i32 0
  %t466 = call i64 @flux_std_os_exec(i8* %t465)
  %t467 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %pr_sn_11 = icmp eq i8* %t467, null
  %pr_sc_11 = select i1 %pr_sn_11, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t467
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_11)
  call i32 @fflush(i8* null)
  %t468 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.23, i32 0, i32 0
  %t469 = load i64, i64* %acertos, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t469)
  %t470 = call i8* @flux_str_concat(i8* %t468, i8* %cv_buf_2)
  %t471 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.61, i32 0, i32 0
  %t472 = call i8* @flux_str_concat(i8* %t470, i8* %t471)
  %t473 = load i64, i64* %erros, align 8
  %cv_buf_3 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_3, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t473)
  %t474 = call i8* @flux_str_concat(i8* %t472, i8* %cv_buf_3)
  %t475 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.62, i32 0, i32 0
  %t476 = call i8* @flux_str_concat(i8* %t474, i8* %t475)
  %pr_sn_12 = icmp eq i8* %t476, null
  %pr_sc_12 = select i1 %pr_sn_12, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t476
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_12)
  call i32 @fflush(i8* null)
  %t479 = load i64, i64* %erros, align 8
  %t480 = add i64 0, 0
  %t481 = icmp eq i64 %t479, %t480
  br i1 %t481, label %ft_39, label %route_arm_478
ft_39:
  %t482 = add i64 0, 0
  %t483 = call i64 @flux_std_os_exit(i64 %t482)
  br label %route_end_477
route_arm_478:
  %t485 = add i64 0, 1
  %t486 = call i64 @flux_std_os_exit(i64 %t485)
  br label %route_end_477
route_end_477:
  ret i32 0
}
