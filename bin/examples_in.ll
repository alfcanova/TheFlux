; ModuleID = 'ExamplesIn'
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
@.str.14 = private unnamed_addr constant [34 x i8] c"cmd /c if not exist dbs mkdir dbs\00", align 1
@.str.15 = private unnamed_addr constant [24 x i8] c"t_stdin_interactive.tmp\00", align 1
@.str.16 = private unnamed_addr constant [46 x i8] c"Ana\0A30\0A9.99\0Atrue\0AA\0A2+3i\0A2026-08-28T12:00:00Z\0A\00", align 1
@.str.17 = private unnamed_addr constant [21 x i8] c"t_stdin_contract.tmp\00", align 1
@.str.18 = private unnamed_addr constant [12 x i8] c"andre\0Aluiz\0A\00", align 1
@.str.19 = private unnamed_addr constant [17 x i8] c"t_stdin_dado.tmp\00", align 1
@.str.20 = private unnamed_addr constant [6 x i8] c"dado\0A\00", align 1
@.str.21 = private unnamed_addr constant [18 x i8] c"t_stdin_empty.tmp\00", align 1
@.str.22 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.23 = private unnamed_addr constant [19 x i8] c"cmd /c dir /b /on \00", align 1
@.str.24 = private unnamed_addr constant [27 x i8] c"\5C*.flux > t_canon_list.tmp\00", align 1
@.str.25 = private unnamed_addr constant [17 x i8] c"t_canon_list.tmp\00", align 1
@.str.26 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.27 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.28 = private unnamed_addr constant [2 x i8] c"\5C\00", align 1
@.str.29 = private unnamed_addr constant [11 x i8] c"input.flux\00", align 1
@.str.30 = private unnamed_addr constant [20 x i8] c"ExampleOfInput.flux\00", align 1
@.str.31 = private unnamed_addr constant [42 x i8] c"ExampleOfUseIoStdLib_IoInputContract.flux\00", align 1
@.str.32 = private unnamed_addr constant [9 x i8] c"DbStdLib\00", align 1
@.str.33 = private unnamed_addr constant [120 x i8] c"cmd /c del /q /f dbs\5Cflux_*.db* dbs\5Cflux_*.kv dbs\5Cflux_*.unqlite dbs\5Cflux_*.duckdb dbs\5Cflux_*.kuzu dbs\5Cflux_*.obx 2>nul\00", align 1
@.str.34 = private unnamed_addr constant [17 x i8] c"#L EXPECT_ERROR:\00", align 1
@.str.35 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c"\09\00", align 1
@.str.37 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.38 = private unnamed_addr constant [14 x i8] c" --target in \00", align 1
@.str.39 = private unnamed_addr constant [4 x i8] c" < \00", align 1
@.str.40 = private unnamed_addr constant [18 x i8] c" > t_in.tmp 2>&1\22\00", align 1
@.str.41 = private unnamed_addr constant [9 x i8] c"t_in.tmp\00", align 1
@.str.42 = private unnamed_addr constant [17 x i8] c"Sem erro emitido\00", align 1
@.str.43 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str.44 = private unnamed_addr constant [4 x i8] c" - \00", align 1
@.str.45 = private unnamed_addr constant [6 x i8] c"Dica:\00", align 1
@.str.46 = private unnamed_addr constant [5 x i8] c"  | \00", align 1
@.str.47 = private unnamed_addr constant [7 x i8] c"  OK  \00", align 1
@.str.48 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.49 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.50 = private unnamed_addr constant [63 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_in.tmp t_canon_list.tmp 2>nul\00", align 1
@.str.51 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.52 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1

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
  %stdin_file = alloca i64, align 8
  %nlen = alloca i64, align 8
  %di = alloca i64, align 8
  %expected_code = alloca i64, align 8
  %tag_err = alloca i64, align 8
  %tag_len = alloca i64, align 8
  %src_content = alloca i64, align 8
  %slen = alloca i64, align 8
  %si = alloca i64, align 8
  %ri = alloca i64, align 8
  %tok = alloca i64, align 8
  %cmd_in = alloca i64, align 8
  %ec = alloca i64, align 8
  %out_full = alloca i64, align 8
  %out_len = alloca i64, align 8
  %last_line = alloca i64, align 8
  %ci = alloca i64, align 8
  %cur_chunk = alloca i64, align 8
  %ch_out = alloca i64, align 8
  %error_msg = alloca i64, align 8
  %match_code = alloca i64, align 8
  %match_dica = alloca i64, align 8
  %code_needle = alloca i64, align 8
  %cn_len = alloca i64, align 8
  %msi = alloca i64, align 8
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
  %t41 = getelementptr inbounds [34 x i8], [34 x i8]* @.str.14, i32 0, i32 0
  %t42 = call i64 @flux_std_os_exec(i8* %t41)
  %t43 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.15, i32 0, i32 0
  %t44 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.16, i32 0, i32 0
  %t45 = call i64 @flux_std_io_write_file(i8* %t43, i8* %t44)
  %t46 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.17, i32 0, i32 0
  %t47 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.18, i32 0, i32 0
  %t48 = call i64 @flux_std_io_write_file(i8* %t46, i8* %t47)
  %t49 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.19, i32 0, i32 0
  %t50 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.20, i32 0, i32 0
  %t51 = call i64 @flux_std_io_write_file(i8* %t49, i8* %t50)
  %t52 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.21, i32 0, i32 0
  %t53 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t54 = call i64 @flux_std_io_write_file(i8* %t52, i8* %t53)
  %t55 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.23, i32 0, i32 0
  %t56_i64 = load i64, i64* %canon_dir, align 8
  %t56 = inttoptr i64 %t56_i64 to i8*
  %t57 = call i8* @flux_str_concat(i8* %t55, i8* %t56)
  %t58 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.24, i32 0, i32 0
  %t59 = call i8* @flux_str_concat(i8* %t57, i8* %t58)
  %t60 = call i64 @flux_std_os_exec(i8* %t59)
  %t61 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.25, i32 0, i32 0
  %t62 = call i8* @flux_std_io_read_file(i8* %t61)
  %st_13 = ptrtoint i8* %t62 to i64
  store i64 %st_13, i64* %list_content, align 8
  %t63_i64 = load i64, i64* %list_content, align 8
  %t63 = inttoptr i64 %t63_i64 to i8*
  %t64 = call i64 @flux_str_len(i8* %t63)
  store i64 %t64, i64* %lclen, align 8
  %t67 = load i64, i64* %lclen, align 8
  %t68 = add i64 0, 0
  %t69 = icmp sgt i64 %t67, %t68
  %t70_i64 = load i64, i64* %list_content, align 8
  %t70 = inttoptr i64 %t70_i64 to i8*
  %t71 = load i64, i64* %lclen, align 8
  %t72 = load i64, i64* %lclen, align 8
  %t73 = call i8* @flux_str_slice(i8* %t70, i64 %t71, i64 %t72)
  %t74 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t75_cmp = call i32 @flux_str_compare(i8* %t73, i8* %t74)
  %t75 = icmp ne i32 %t75_cmp, 0
  %t76 = and i1 %t69, %t75
  br i1 %t76, label %ft_8, label %route_arm_66
ft_8:
  %t77_i64 = load i64, i64* %list_content, align 8
  %t77 = inttoptr i64 %t77_i64 to i8*
  %t78 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t79 = call i8* @flux_str_concat(i8* %t77, i8* %t78)
  %st_15 = ptrtoint i8* %t79 to i64
  store i64 %st_15, i64* %list_content, align 8
  %t80 = load i64, i64* %lclen, align 8
  %t81 = add i64 0, 1
  %t82 = add i64 %t80, %t81
  store i64 %t82, i64* %lclen, align 8
  br label %route_end_65
route_arm_66:
  br label %route_end_65
route_end_65:
  %t84 = add i64 0, 0
  store i64 %t84, i64* %acertos, align 8
  %t85 = add i64 0, 0
  store i64 %t85, i64* %erros, align 8
  %t86 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_19 = ptrtoint i8* %t86 to i64
  store i64 %st_19, i64* %cur_fname, align 8
  %t87 = add i64 0, 1
  store i64 %t87, i64* %li, align 8
  br label %loop_start_88
loop_start_88:
  %t91 = load i64, i64* %li, align 8
  %t92 = load i64, i64* %lclen, align 8
  %t93 = icmp sgt i64 %t91, %t92
  br i1 %t93, label %ft_9, label %route_arm_90
ft_9:
  br label %loop_end_88
route_arm_90:
  %t95_i64 = load i64, i64* %list_content, align 8
  %t95 = inttoptr i64 %t95_i64 to i8*
  %t96 = load i64, i64* %li, align 8
  %t97 = load i64, i64* %li, align 8
  %t98 = call i8* @flux_str_slice(i8* %t95, i64 %t96, i64 %t97)
  %st_21 = ptrtoint i8* %t98 to i64
  store i64 %st_21, i64* %ch, align 8
  %t101_i64 = load i64, i64* %ch, align 8
  %t101 = inttoptr i64 %t101_i64 to i8*
  %t102 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t103_cmp = call i32 @flux_str_compare(i8* %t101, i8* %t102)
  %t103 = icmp eq i32 %t103_cmp, 0
  br i1 %t103, label %ft_10, label %route_arm_100
ft_10:
  br label %route_end_99
route_arm_100:
  %t105_i64 = load i64, i64* %ch, align 8
  %t105 = inttoptr i64 %t105_i64 to i8*
  %t106 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t107_cmp = call i32 @flux_str_compare(i8* %t105, i8* %t106)
  %t107 = icmp eq i32 %t107_cmp, 0
  br i1 %t107, label %ft_11, label %route_arm_104
ft_11:
  %t110_i64 = load i64, i64* %cur_fname, align 8
  %t110 = inttoptr i64 %t110_i64 to i8*
  %t111 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t112_cmp = call i32 @flux_str_compare(i8* %t110, i8* %t111)
  %t112 = icmp ne i32 %t112_cmp, 0
  br i1 %t112, label %ft_12, label %route_arm_109
ft_12:
  %t113_i64 = load i64, i64* %cur_fname, align 8
  %t113 = inttoptr i64 %t113_i64 to i8*
  %st_22 = ptrtoint i8* %t113 to i64
  store i64 %st_22, i64* %nome, align 8
  %t114_i64 = load i64, i64* %canon_dir, align 8
  %t114 = inttoptr i64 %t114_i64 to i8*
  %t115 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.28, i32 0, i32 0
  %t116 = call i8* @flux_str_concat(i8* %t114, i8* %t115)
  %t117_i64 = load i64, i64* %nome, align 8
  %t117 = inttoptr i64 %t117_i64 to i8*
  %t118 = call i8* @flux_str_concat(i8* %t116, i8* %t117)
  %st_23 = ptrtoint i8* %t118 to i64
  store i64 %st_23, i64* %filepath, align 8
  %t119 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.21, i32 0, i32 0
  %st_24 = ptrtoint i8* %t119 to i64
  store i64 %st_24, i64* %stdin_file, align 8
  %t122_i64 = load i64, i64* %nome, align 8
  %t122 = inttoptr i64 %t122_i64 to i8*
  %t123 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.29, i32 0, i32 0
  %t124_cmp = call i32 @flux_str_compare(i8* %t122, i8* %t123)
  %t124 = icmp eq i32 %t124_cmp, 0
  br i1 %t124, label %ft_13, label %route_arm_121
ft_13:
  %t125 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.19, i32 0, i32 0
  %st_25 = ptrtoint i8* %t125 to i64
  store i64 %st_25, i64* %stdin_file, align 8
  br label %route_end_120
route_arm_121:
  %t127_i64 = load i64, i64* %nome, align 8
  %t127 = inttoptr i64 %t127_i64 to i8*
  %t128 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.30, i32 0, i32 0
  %t129_cmp = call i32 @flux_str_compare(i8* %t127, i8* %t128)
  %t129 = icmp eq i32 %t129_cmp, 0
  br i1 %t129, label %ft_14, label %route_arm_126
ft_14:
  %t130 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.15, i32 0, i32 0
  %st_26 = ptrtoint i8* %t130 to i64
  store i64 %st_26, i64* %stdin_file, align 8
  br label %route_end_120
route_arm_126:
  %t132_i64 = load i64, i64* %nome, align 8
  %t132 = inttoptr i64 %t132_i64 to i8*
  %t133 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.31, i32 0, i32 0
  %t134_cmp = call i32 @flux_str_compare(i8* %t132, i8* %t133)
  %t134 = icmp eq i32 %t134_cmp, 0
  br i1 %t134, label %ft_15, label %route_arm_131
ft_15:
  %t135 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.17, i32 0, i32 0
  %st_27 = ptrtoint i8* %t135 to i64
  store i64 %st_27, i64* %stdin_file, align 8
  br label %route_end_120
route_arm_131:
  br label %route_end_120
route_end_120:
  %t137_i64 = load i64, i64* %nome, align 8
  %t137 = inttoptr i64 %t137_i64 to i8*
  %t138 = call i64 @flux_str_len(i8* %t137)
  store i64 %t138, i64* %nlen, align 8
  %t141 = load i64, i64* %nlen, align 8
  %t142 = add i64 0, 8
  %t143 = icmp sge i64 %t141, %t142
  br i1 %t143, label %ft_16, label %route_arm_140
ft_16:
  %t144 = add i64 0, 1
  store i64 %t144, i64* %di, align 8
  br label %loop_start_145
loop_start_145:
  %t148 = load i64, i64* %di, align 8
  %t149 = add i64 0, 7
  %t150 = add i64 %t148, %t149
  %t151 = load i64, i64* %nlen, align 8
  %t152 = icmp sgt i64 %t150, %t151
  br i1 %t152, label %ft_17, label %route_arm_147
ft_17:
  br label %loop_end_145
route_arm_147:
  %t154_i64 = load i64, i64* %nome, align 8
  %t154 = inttoptr i64 %t154_i64 to i8*
  %t155 = load i64, i64* %di, align 8
  %t156 = load i64, i64* %di, align 8
  %t157 = add i64 0, 7
  %t158 = add i64 %t156, %t157
  %t159 = call i8* @flux_str_slice(i8* %t154, i64 %t155, i64 %t158)
  %t160 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.32, i32 0, i32 0
  %t161_cmp = call i32 @flux_str_compare(i8* %t159, i8* %t160)
  %t161 = icmp eq i32 %t161_cmp, 0
  br i1 %t161, label %ft_18, label %route_arm_153
ft_18:
  %t162 = getelementptr inbounds [120 x i8], [120 x i8]* @.str.33, i32 0, i32 0
  %t163 = call i64 @flux_std_os_exec(i8* %t162)
  br label %loop_end_145
route_arm_153:
  %t165 = load i64, i64* %di, align 8
  %t166 = add i64 0, 1
  %t167 = add i64 %t165, %t166
  store i64 %t167, i64* %di, align 8
  br label %route_end_146
route_end_146:
  br label %loop_start_145
loop_end_145:
  br label %route_end_139
route_arm_140:
  br label %route_end_139
route_end_139:
  %t169 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_31 = ptrtoint i8* %t169 to i64
  store i64 %st_31, i64* %expected_code, align 8
  %t170 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.34, i32 0, i32 0
  %st_32 = ptrtoint i8* %t170 to i64
  store i64 %st_32, i64* %tag_err, align 8
  %t171_i64 = load i64, i64* %tag_err, align 8
  %t171 = inttoptr i64 %t171_i64 to i8*
  %t172 = call i64 @flux_str_len(i8* %t171)
  store i64 %t172, i64* %tag_len, align 8
  %t173_i64 = load i64, i64* %filepath, align 8
  %t173 = inttoptr i64 %t173_i64 to i8*
  %t174 = call i8* @flux_std_io_read_file(i8* %t173)
  %st_34 = ptrtoint i8* %t174 to i64
  store i64 %st_34, i64* %src_content, align 8
  %t175_i64 = load i64, i64* %src_content, align 8
  %t175 = inttoptr i64 %t175_i64 to i8*
  %t176 = call i64 @flux_str_len(i8* %t175)
  store i64 %t176, i64* %slen, align 8
  %t179 = load i64, i64* %slen, align 8
  %t180 = load i64, i64* %tag_len, align 8
  %t181 = icmp sge i64 %t179, %t180
  br i1 %t181, label %ft_19, label %route_arm_178
ft_19:
  %t182 = add i64 0, 1
  store i64 %t182, i64* %si, align 8
  br label %loop_start_183
loop_start_183:
  %t186 = load i64, i64* %si, align 8
  %t187 = load i64, i64* %tag_len, align 8
  %t188 = add i64 %t186, %t187
  %t189 = add i64 0, 1
  %t190 = sub i64 %t188, %t189
  %t191 = load i64, i64* %slen, align 8
  %t192 = icmp sgt i64 %t190, %t191
  br i1 %t192, label %ft_20, label %route_arm_185
ft_20:
  br label %loop_end_183
route_arm_185:
  %t194_i64 = load i64, i64* %src_content, align 8
  %t194 = inttoptr i64 %t194_i64 to i8*
  %t195 = load i64, i64* %si, align 8
  %t196 = load i64, i64* %si, align 8
  %t197 = load i64, i64* %tag_len, align 8
  %t198 = add i64 %t196, %t197
  %t199 = add i64 0, 1
  %t200 = sub i64 %t198, %t199
  %t201 = call i8* @flux_str_slice(i8* %t194, i64 %t195, i64 %t200)
  %t202_i64 = load i64, i64* %tag_err, align 8
  %t202 = inttoptr i64 %t202_i64 to i8*
  %t203_cmp = call i32 @flux_str_compare(i8* %t201, i8* %t202)
  %t203 = icmp eq i32 %t203_cmp, 0
  br i1 %t203, label %ft_21, label %route_arm_193
ft_21:
  %t204 = load i64, i64* %si, align 8
  %t205 = load i64, i64* %tag_len, align 8
  %t206 = add i64 %t204, %t205
  store i64 %t206, i64* %ri, align 8
  br label %loop_start_207
loop_start_207:
  %t210 = load i64, i64* %ri, align 8
  %t211 = load i64, i64* %slen, align 8
  %t212 = icmp sgt i64 %t210, %t211
  br i1 %t212, label %ft_22, label %route_arm_209
ft_22:
  br label %loop_end_207
route_arm_209:
  %t214_i64 = load i64, i64* %src_content, align 8
  %t214 = inttoptr i64 %t214_i64 to i8*
  %t215 = load i64, i64* %ri, align 8
  %t216 = load i64, i64* %ri, align 8
  %t217 = call i8* @flux_str_slice(i8* %t214, i64 %t215, i64 %t216)
  %t218 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.35, i32 0, i32 0
  %t219_cmp = call i32 @flux_str_compare(i8* %t217, i8* %t218)
  %t219 = icmp eq i32 %t219_cmp, 0
  %t220_i64 = load i64, i64* %src_content, align 8
  %t220 = inttoptr i64 %t220_i64 to i8*
  %t221 = load i64, i64* %ri, align 8
  %t222 = load i64, i64* %ri, align 8
  %t223 = call i8* @flux_str_slice(i8* %t220, i64 %t221, i64 %t222)
  %t224 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.36, i32 0, i32 0
  %t225_cmp = call i32 @flux_str_compare(i8* %t223, i8* %t224)
  %t225 = icmp eq i32 %t225_cmp, 0
  %t226 = or i1 %t219, %t225
  br i1 %t226, label %ft_23, label %route_arm_213
ft_23:
  %t227 = load i64, i64* %ri, align 8
  %t228 = add i64 0, 1
  %t229 = add i64 %t227, %t228
  store i64 %t229, i64* %ri, align 8
  br label %route_end_208
route_arm_213:
  br label %loop_end_207
route_end_208:
  br label %loop_start_207
loop_end_207:
  %t231 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_39 = ptrtoint i8* %t231 to i64
  store i64 %st_39, i64* %tok, align 8
  br label %loop_start_232
loop_start_232:
  %t235 = load i64, i64* %ri, align 8
  %t236 = load i64, i64* %slen, align 8
  %t237 = icmp sgt i64 %t235, %t236
  br i1 %t237, label %ft_24, label %route_arm_234
ft_24:
  br label %loop_end_232
route_arm_234:
  %t239_i64 = load i64, i64* %src_content, align 8
  %t239 = inttoptr i64 %t239_i64 to i8*
  %t240 = load i64, i64* %ri, align 8
  %t241 = load i64, i64* %ri, align 8
  %t242 = call i8* @flux_str_slice(i8* %t239, i64 %t240, i64 %t241)
  %t243 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.35, i32 0, i32 0
  %t244_cmp = call i32 @flux_str_compare(i8* %t242, i8* %t243)
  %t244 = icmp eq i32 %t244_cmp, 0
  %t245_i64 = load i64, i64* %src_content, align 8
  %t245 = inttoptr i64 %t245_i64 to i8*
  %t246 = load i64, i64* %ri, align 8
  %t247 = load i64, i64* %ri, align 8
  %t248 = call i8* @flux_str_slice(i8* %t245, i64 %t246, i64 %t247)
  %t249 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.36, i32 0, i32 0
  %t250_cmp = call i32 @flux_str_compare(i8* %t248, i8* %t249)
  %t250 = icmp eq i32 %t250_cmp, 0
  %t251 = or i1 %t244, %t250
  %t252_i64 = load i64, i64* %src_content, align 8
  %t252 = inttoptr i64 %t252_i64 to i8*
  %t253 = load i64, i64* %ri, align 8
  %t254 = load i64, i64* %ri, align 8
  %t255 = call i8* @flux_str_slice(i8* %t252, i64 %t253, i64 %t254)
  %t256 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t257_cmp = call i32 @flux_str_compare(i8* %t255, i8* %t256)
  %t257 = icmp eq i32 %t257_cmp, 0
  %t258 = or i1 %t251, %t257
  %t259_i64 = load i64, i64* %src_content, align 8
  %t259 = inttoptr i64 %t259_i64 to i8*
  %t260 = load i64, i64* %ri, align 8
  %t261 = load i64, i64* %ri, align 8
  %t262 = call i8* @flux_str_slice(i8* %t259, i64 %t260, i64 %t261)
  %t263 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t264_cmp = call i32 @flux_str_compare(i8* %t262, i8* %t263)
  %t264 = icmp eq i32 %t264_cmp, 0
  %t265 = or i1 %t258, %t264
  br i1 %t265, label %ft_25, label %route_arm_238
ft_25:
  br label %loop_end_232
route_arm_238:
  %t267_i64 = load i64, i64* %tok, align 8
  %t267 = inttoptr i64 %t267_i64 to i8*
  %t268_i64 = load i64, i64* %src_content, align 8
  %t268 = inttoptr i64 %t268_i64 to i8*
  %t269 = load i64, i64* %ri, align 8
  %t270 = load i64, i64* %ri, align 8
  %t271 = call i8* @flux_str_slice(i8* %t268, i64 %t269, i64 %t270)
  %t272 = call i8* @flux_str_concat(i8* %t267, i8* %t271)
  %st_40 = ptrtoint i8* %t272 to i64
  store i64 %st_40, i64* %tok, align 8
  %t273 = load i64, i64* %ri, align 8
  %t274 = add i64 0, 1
  %t275 = add i64 %t273, %t274
  store i64 %t275, i64* %ri, align 8
  br label %route_end_233
route_end_233:
  br label %loop_start_232
loop_end_232:
  %t276_i64 = load i64, i64* %tok, align 8
  %t276 = inttoptr i64 %t276_i64 to i8*
  %st_42 = ptrtoint i8* %t276 to i64
  store i64 %st_42, i64* %expected_code, align 8
  br label %loop_end_183
route_arm_193:
  %t278 = load i64, i64* %si, align 8
  %t279 = add i64 0, 1
  %t280 = add i64 %t278, %t279
  store i64 %t280, i64* %si, align 8
  br label %route_end_184
route_end_184:
  br label %loop_start_183
loop_end_183:
  br label %route_end_177
route_arm_178:
  br label %route_end_177
route_end_177:
  %t282 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.37, i32 0, i32 0
  %t283_i64 = load i64, i64* %fluxc_bin, align 8
  %t283 = inttoptr i64 %t283_i64 to i8*
  %t284 = call i8* @flux_str_concat(i8* %t282, i8* %t283)
  %t285 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.38, i32 0, i32 0
  %t286 = call i8* @flux_str_concat(i8* %t284, i8* %t285)
  %t287_i64 = load i64, i64* %filepath, align 8
  %t287 = inttoptr i64 %t287_i64 to i8*
  %t288 = call i8* @flux_str_concat(i8* %t286, i8* %t287)
  %t289 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.39, i32 0, i32 0
  %t290 = call i8* @flux_str_concat(i8* %t288, i8* %t289)
  %t291_i64 = load i64, i64* %stdin_file, align 8
  %t291 = inttoptr i64 %t291_i64 to i8*
  %t292 = call i8* @flux_str_concat(i8* %t290, i8* %t291)
  %t293 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.40, i32 0, i32 0
  %t294 = call i8* @flux_str_concat(i8* %t292, i8* %t293)
  %st_44 = ptrtoint i8* %t294 to i64
  store i64 %st_44, i64* %cmd_in, align 8
  %t295_i64 = load i64, i64* %cmd_in, align 8
  %t295 = inttoptr i64 %t295_i64 to i8*
  %t296 = call i64 @flux_std_os_exec(i8* %t295)
  store i64 %t296, i64* %ec, align 8
  %t297 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.41, i32 0, i32 0
  %t298 = call i8* @flux_std_io_read_file(i8* %t297)
  %st_46 = ptrtoint i8* %t298 to i64
  store i64 %st_46, i64* %out_full, align 8
  %t299_i64 = load i64, i64* %out_full, align 8
  %t299 = inttoptr i64 %t299_i64 to i8*
  %t300 = call i64 @flux_str_len(i8* %t299)
  store i64 %t300, i64* %out_len, align 8
  %t301 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_48 = ptrtoint i8* %t301 to i64
  store i64 %st_48, i64* %last_line, align 8
  %t302 = add i64 0, 1
  store i64 %t302, i64* %ci, align 8
  %t303 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_50 = ptrtoint i8* %t303 to i64
  store i64 %st_50, i64* %cur_chunk, align 8
  br label %loop_start_304
loop_start_304:
  %t307 = load i64, i64* %ci, align 8
  %t308 = load i64, i64* %out_len, align 8
  %t309 = icmp sgt i64 %t307, %t308
  br i1 %t309, label %ft_26, label %route_arm_306
ft_26:
  br label %loop_end_304
route_arm_306:
  %t311_i64 = load i64, i64* %out_full, align 8
  %t311 = inttoptr i64 %t311_i64 to i8*
  %t312 = load i64, i64* %ci, align 8
  %t313 = load i64, i64* %ci, align 8
  %t314 = call i8* @flux_str_slice(i8* %t311, i64 %t312, i64 %t313)
  %st_51 = ptrtoint i8* %t314 to i64
  store i64 %st_51, i64* %ch_out, align 8
  %t317_i64 = load i64, i64* %ch_out, align 8
  %t317 = inttoptr i64 %t317_i64 to i8*
  %t318 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t319_cmp = call i32 @flux_str_compare(i8* %t317, i8* %t318)
  %t319 = icmp eq i32 %t319_cmp, 0
  br i1 %t319, label %ft_27, label %route_arm_316
ft_27:
  br label %route_end_315
route_arm_316:
  %t321_i64 = load i64, i64* %ch_out, align 8
  %t321 = inttoptr i64 %t321_i64 to i8*
  %t322 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t323_cmp = call i32 @flux_str_compare(i8* %t321, i8* %t322)
  %t323 = icmp eq i32 %t323_cmp, 0
  br i1 %t323, label %ft_28, label %route_arm_320
ft_28:
  %t326_i64 = load i64, i64* %cur_chunk, align 8
  %t326 = inttoptr i64 %t326_i64 to i8*
  %t327 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t328_cmp = call i32 @flux_str_compare(i8* %t326, i8* %t327)
  %t328 = icmp ne i32 %t328_cmp, 0
  br i1 %t328, label %ft_29, label %route_arm_325
ft_29:
  %t329_i64 = load i64, i64* %cur_chunk, align 8
  %t329 = inttoptr i64 %t329_i64 to i8*
  %st_52 = ptrtoint i8* %t329 to i64
  store i64 %st_52, i64* %last_line, align 8
  br label %route_end_324
route_arm_325:
  br label %route_end_324
route_end_324:
  %t331 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_53 = ptrtoint i8* %t331 to i64
  store i64 %st_53, i64* %cur_chunk, align 8
  br label %route_end_315
route_arm_320:
  %t333_i64 = load i64, i64* %cur_chunk, align 8
  %t333 = inttoptr i64 %t333_i64 to i8*
  %t334_i64 = load i64, i64* %ch_out, align 8
  %t334 = inttoptr i64 %t334_i64 to i8*
  %t335 = call i8* @flux_str_concat(i8* %t333, i8* %t334)
  %st_54 = ptrtoint i8* %t335 to i64
  store i64 %st_54, i64* %cur_chunk, align 8
  br label %route_end_315
route_end_315:
  %t336 = load i64, i64* %ci, align 8
  %t337 = add i64 0, 1
  %t338 = add i64 %t336, %t337
  store i64 %t338, i64* %ci, align 8
  br label %route_end_305
route_end_305:
  br label %loop_start_304
loop_end_304:
  %t341_i64 = load i64, i64* %cur_chunk, align 8
  %t341 = inttoptr i64 %t341_i64 to i8*
  %t342 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t343_cmp = call i32 @flux_str_compare(i8* %t341, i8* %t342)
  %t343 = icmp ne i32 %t343_cmp, 0
  br i1 %t343, label %ft_30, label %route_arm_340
ft_30:
  %t344_i64 = load i64, i64* %cur_chunk, align 8
  %t344 = inttoptr i64 %t344_i64 to i8*
  %st_56 = ptrtoint i8* %t344 to i64
  store i64 %st_56, i64* %last_line, align 8
  br label %route_end_339
route_arm_340:
  br label %route_end_339
route_end_339:
  %t346_i64 = load i64, i64* %last_line, align 8
  %t346 = inttoptr i64 %t346_i64 to i8*
  %st_57 = ptrtoint i8* %t346 to i64
  store i64 %st_57, i64* %error_msg, align 8
  %t349_i64 = load i64, i64* %error_msg, align 8
  %t349 = inttoptr i64 %t349_i64 to i8*
  %t350 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t351_cmp = call i32 @flux_str_compare(i8* %t349, i8* %t350)
  %t351 = icmp eq i32 %t351_cmp, 0
  br i1 %t351, label %ft_31, label %route_arm_348
ft_31:
  %t352 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.42, i32 0, i32 0
  %st_58 = ptrtoint i8* %t352 to i64
  store i64 %st_58, i64* %error_msg, align 8
  br label %route_end_347
route_arm_348:
  br label %route_end_347
route_end_347:
  %t356_i64 = load i64, i64* %expected_code, align 8
  %t356 = inttoptr i64 %t356_i64 to i8*
  %t357 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t358_cmp = call i32 @flux_str_compare(i8* %t356, i8* %t357)
  %t358 = icmp ne i32 %t358_cmp, 0
  br i1 %t358, label %ft_32, label %route_arm_355
ft_32:
  %t359 = add i1 0, 0
  %st_b_59 = zext i1 %t359 to i64
  store i64 %st_b_59, i64* %match_code, align 8
  %t360 = add i1 0, 0
  %st_b_60 = zext i1 %t360 to i64
  store i64 %st_b_60, i64* %match_dica, align 8
  %t361 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.43, i32 0, i32 0
  %t362_i64 = load i64, i64* %expected_code, align 8
  %t362 = inttoptr i64 %t362_i64 to i8*
  %t363 = call i8* @flux_str_concat(i8* %t361, i8* %t362)
  %t364 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.44, i32 0, i32 0
  %t365 = call i8* @flux_str_concat(i8* %t363, i8* %t364)
  %st_61 = ptrtoint i8* %t365 to i64
  store i64 %st_61, i64* %code_needle, align 8
  %t366_i64 = load i64, i64* %code_needle, align 8
  %t366 = inttoptr i64 %t366_i64 to i8*
  %t367 = call i64 @flux_str_len(i8* %t366)
  store i64 %t367, i64* %cn_len, align 8
  %t370 = load i64, i64* %out_len, align 8
  %t371 = load i64, i64* %cn_len, align 8
  %t372 = icmp sge i64 %t370, %t371
  br i1 %t372, label %ft_33, label %route_arm_369
ft_33:
  %t373 = add i64 0, 1
  store i64 %t373, i64* %msi, align 8
  br label %loop_start_374
loop_start_374:
  %t377 = load i64, i64* %msi, align 8
  %t378 = load i64, i64* %cn_len, align 8
  %t379 = add i64 %t377, %t378
  %t380 = add i64 0, 1
  %t381 = sub i64 %t379, %t380
  %t382 = load i64, i64* %out_len, align 8
  %t383 = icmp sgt i64 %t381, %t382
  br i1 %t383, label %ft_34, label %route_arm_376
ft_34:
  br label %loop_end_374
route_arm_376:
  %t385_i64 = load i64, i64* %out_full, align 8
  %t385 = inttoptr i64 %t385_i64 to i8*
  %t386 = load i64, i64* %msi, align 8
  %t387 = load i64, i64* %msi, align 8
  %t388 = load i64, i64* %cn_len, align 8
  %t389 = add i64 %t387, %t388
  %t390 = add i64 0, 1
  %t391 = sub i64 %t389, %t390
  %t392 = call i8* @flux_str_slice(i8* %t385, i64 %t386, i64 %t391)
  %t393_i64 = load i64, i64* %code_needle, align 8
  %t393 = inttoptr i64 %t393_i64 to i8*
  %t394_cmp = call i32 @flux_str_compare(i8* %t392, i8* %t393)
  %t394 = icmp eq i32 %t394_cmp, 0
  br i1 %t394, label %ft_35, label %route_arm_384
ft_35:
  %t395 = add i1 0, 1
  %st_b_64 = zext i1 %t395 to i64
  store i64 %st_b_64, i64* %match_code, align 8
  br label %loop_end_374
route_arm_384:
  %t397 = load i64, i64* %msi, align 8
  %t398 = add i64 0, 1
  %t399 = add i64 %t397, %t398
  store i64 %t399, i64* %msi, align 8
  br label %route_end_375
route_end_375:
  br label %loop_start_374
loop_end_374:
  br label %route_end_368
route_arm_369:
  br label %route_end_368
route_end_368:
  %t403 = load i64, i64* %out_len, align 8
  %t404 = add i64 0, 5
  %t405 = icmp sge i64 %t403, %t404
  br i1 %t405, label %ft_36, label %route_arm_402
ft_36:
  %t406 = add i64 0, 1
  store i64 %t406, i64* %msi, align 8
  br label %loop_start_407
loop_start_407:
  %t410 = load i64, i64* %msi, align 8
  %t411 = add i64 0, 4
  %t412 = add i64 %t410, %t411
  %t413 = load i64, i64* %out_len, align 8
  %t414 = icmp sgt i64 %t412, %t413
  br i1 %t414, label %ft_37, label %route_arm_409
ft_37:
  br label %loop_end_407
route_arm_409:
  %t416_i64 = load i64, i64* %out_full, align 8
  %t416 = inttoptr i64 %t416_i64 to i8*
  %t417 = load i64, i64* %msi, align 8
  %t418 = load i64, i64* %msi, align 8
  %t419 = add i64 0, 4
  %t420 = add i64 %t418, %t419
  %t421 = call i8* @flux_str_slice(i8* %t416, i64 %t417, i64 %t420)
  %t422 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.45, i32 0, i32 0
  %t423_cmp = call i32 @flux_str_compare(i8* %t421, i8* %t422)
  %t423 = icmp eq i32 %t423_cmp, 0
  br i1 %t423, label %ft_38, label %route_arm_415
ft_38:
  %t424 = add i1 0, 1
  %st_b_67 = zext i1 %t424 to i64
  store i64 %st_b_67, i64* %match_dica, align 8
  br label %loop_end_407
route_arm_415:
  %t426 = load i64, i64* %msi, align 8
  %t427 = add i64 0, 1
  %t428 = add i64 %t426, %t427
  store i64 %t428, i64* %msi, align 8
  br label %route_end_408
route_end_408:
  br label %loop_start_407
loop_end_407:
  br label %route_end_401
route_arm_402:
  br label %route_end_401
route_end_401:
  %t432 = load i64, i64* %ec, align 8
  %t433 = add i64 0, 0
  %t434 = icmp ne i64 %t432, %t433
  %t435_i64 = load i64, i64* %match_code, align 8
  %t435 = trunc i64 %t435_i64 to i1
  %t436 = and i1 %t434, %t435
  %t437_i64 = load i64, i64* %match_dica, align 8
  %t437 = trunc i64 %t437_i64 to i1
  %t438 = and i1 %t436, %t437
  br i1 %t438, label %ft_39, label %route_arm_431
ft_39:
  %t439 = load i64, i64* %acertos, align 8
  %t440 = add i64 0, 1
  %t441 = add i64 %t439, %t440
  store i64 %t441, i64* %acertos, align 8
  %t442 = add i64 0, 1
  store i64 %t442, i64* %ci, align 8
  %t443 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_71 = ptrtoint i8* %t443 to i64
  store i64 %st_71, i64* %cur_chunk, align 8
  br label %loop_start_444
loop_start_444:
  %t447 = load i64, i64* %ci, align 8
  %t448 = load i64, i64* %out_len, align 8
  %t449 = icmp sgt i64 %t447, %t448
  br i1 %t449, label %ft_40, label %route_arm_446
ft_40:
  br label %loop_end_444
route_arm_446:
  %t451_i64 = load i64, i64* %out_full, align 8
  %t451 = inttoptr i64 %t451_i64 to i8*
  %t452 = load i64, i64* %ci, align 8
  %t453 = load i64, i64* %ci, align 8
  %t454 = call i8* @flux_str_slice(i8* %t451, i64 %t452, i64 %t453)
  %st_72 = ptrtoint i8* %t454 to i64
  store i64 %st_72, i64* %ch_out, align 8
  %t457_i64 = load i64, i64* %ch_out, align 8
  %t457 = inttoptr i64 %t457_i64 to i8*
  %t458 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t459_cmp = call i32 @flux_str_compare(i8* %t457, i8* %t458)
  %t459 = icmp eq i32 %t459_cmp, 0
  br i1 %t459, label %ft_41, label %route_arm_456
ft_41:
  br label %route_end_455
route_arm_456:
  %t461_i64 = load i64, i64* %ch_out, align 8
  %t461 = inttoptr i64 %t461_i64 to i8*
  %t462 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t463_cmp = call i32 @flux_str_compare(i8* %t461, i8* %t462)
  %t463 = icmp eq i32 %t463_cmp, 0
  br i1 %t463, label %ft_42, label %route_arm_460
ft_42:
  %t466_i64 = load i64, i64* %cur_chunk, align 8
  %t466 = inttoptr i64 %t466_i64 to i8*
  %t467 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t468_cmp = call i32 @flux_str_compare(i8* %t466, i8* %t467)
  %t468 = icmp ne i32 %t468_cmp, 0
  br i1 %t468, label %ft_43, label %route_arm_465
ft_43:
  %t469 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.46, i32 0, i32 0
  %t470_i64 = load i64, i64* %cur_chunk, align 8
  %t470 = inttoptr i64 %t470_i64 to i8*
  %t471 = call i8* @flux_str_concat(i8* %t469, i8* %t470)
  %pr_sn_1 = icmp eq i8* %t471, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t471
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  br label %route_end_464
route_arm_465:
  br label %route_end_464
route_end_464:
  %t473 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_73 = ptrtoint i8* %t473 to i64
  store i64 %st_73, i64* %cur_chunk, align 8
  br label %route_end_455
route_arm_460:
  %t475_i64 = load i64, i64* %cur_chunk, align 8
  %t475 = inttoptr i64 %t475_i64 to i8*
  %t476_i64 = load i64, i64* %ch_out, align 8
  %t476 = inttoptr i64 %t476_i64 to i8*
  %t477 = call i8* @flux_str_concat(i8* %t475, i8* %t476)
  %st_74 = ptrtoint i8* %t477 to i64
  store i64 %st_74, i64* %cur_chunk, align 8
  br label %route_end_455
route_end_455:
  %t478 = load i64, i64* %ci, align 8
  %t479 = add i64 0, 1
  %t480 = add i64 %t478, %t479
  store i64 %t480, i64* %ci, align 8
  br label %route_end_445
route_end_445:
  br label %loop_start_444
loop_end_444:
  %t483_i64 = load i64, i64* %cur_chunk, align 8
  %t483 = inttoptr i64 %t483_i64 to i8*
  %t484 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t485_cmp = call i32 @flux_str_compare(i8* %t483, i8* %t484)
  %t485 = icmp ne i32 %t485_cmp, 0
  br i1 %t485, label %ft_44, label %route_arm_482
ft_44:
  %t486 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.46, i32 0, i32 0
  %t487_i64 = load i64, i64* %cur_chunk, align 8
  %t487 = inttoptr i64 %t487_i64 to i8*
  %t488 = call i8* @flux_str_concat(i8* %t486, i8* %t487)
  %pr_sn_2 = icmp eq i8* %t488, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t488
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  br label %route_end_481
route_arm_482:
  br label %route_end_481
route_end_481:
  %t490 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.47, i32 0, i32 0
  %t491_i64 = load i64, i64* %nome, align 8
  %t491 = inttoptr i64 %t491_i64 to i8*
  %t492 = call i8* @flux_str_concat(i8* %t490, i8* %t491)
  %pr_sn_3 = icmp eq i8* %t492, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t492
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  br label %route_end_430
route_arm_431:
  %t494 = load i64, i64* %erros, align 8
  %t495 = add i64 0, 1
  %t496 = add i64 %t494, %t495
  store i64 %t496, i64* %erros, align 8
  %t497 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.48, i32 0, i32 0
  %t498_i64 = load i64, i64* %nome, align 8
  %t498 = inttoptr i64 %t498_i64 to i8*
  %t499 = call i8* @flux_str_concat(i8* %t497, i8* %t498)
  %t500 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.49, i32 0, i32 0
  %t501 = call i8* @flux_str_concat(i8* %t499, i8* %t500)
  %t502_i64 = load i64, i64* %error_msg, align 8
  %t502 = inttoptr i64 %t502_i64 to i8*
  %t503 = call i8* @flux_str_concat(i8* %t501, i8* %t502)
  %pr_sn_4 = icmp eq i8* %t503, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t503
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  br label %route_end_430
route_end_430:
  br label %route_end_354
route_arm_355:
  %t507 = load i64, i64* %ec, align 8
  %t508 = add i64 0, 0
  %t509 = icmp eq i64 %t507, %t508
  br i1 %t509, label %ft_45, label %route_arm_506
ft_45:
  %t510 = load i64, i64* %acertos, align 8
  %t511 = add i64 0, 1
  %t512 = add i64 %t510, %t511
  store i64 %t512, i64* %acertos, align 8
  %t513 = add i64 0, 1
  store i64 %t513, i64* %ci, align 8
  %t514 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_79 = ptrtoint i8* %t514 to i64
  store i64 %st_79, i64* %cur_chunk, align 8
  br label %loop_start_515
loop_start_515:
  %t518 = load i64, i64* %ci, align 8
  %t519 = load i64, i64* %out_len, align 8
  %t520 = icmp sgt i64 %t518, %t519
  br i1 %t520, label %ft_46, label %route_arm_517
ft_46:
  br label %loop_end_515
route_arm_517:
  %t522_i64 = load i64, i64* %out_full, align 8
  %t522 = inttoptr i64 %t522_i64 to i8*
  %t523 = load i64, i64* %ci, align 8
  %t524 = load i64, i64* %ci, align 8
  %t525 = call i8* @flux_str_slice(i8* %t522, i64 %t523, i64 %t524)
  %st_80 = ptrtoint i8* %t525 to i64
  store i64 %st_80, i64* %ch_out, align 8
  %t528_i64 = load i64, i64* %ch_out, align 8
  %t528 = inttoptr i64 %t528_i64 to i8*
  %t529 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t530_cmp = call i32 @flux_str_compare(i8* %t528, i8* %t529)
  %t530 = icmp eq i32 %t530_cmp, 0
  br i1 %t530, label %ft_47, label %route_arm_527
ft_47:
  br label %route_end_526
route_arm_527:
  %t532_i64 = load i64, i64* %ch_out, align 8
  %t532 = inttoptr i64 %t532_i64 to i8*
  %t533 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t534_cmp = call i32 @flux_str_compare(i8* %t532, i8* %t533)
  %t534 = icmp eq i32 %t534_cmp, 0
  br i1 %t534, label %ft_48, label %route_arm_531
ft_48:
  %t537_i64 = load i64, i64* %cur_chunk, align 8
  %t537 = inttoptr i64 %t537_i64 to i8*
  %t538 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t539_cmp = call i32 @flux_str_compare(i8* %t537, i8* %t538)
  %t539 = icmp ne i32 %t539_cmp, 0
  br i1 %t539, label %ft_49, label %route_arm_536
ft_49:
  %t540 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.46, i32 0, i32 0
  %t541_i64 = load i64, i64* %cur_chunk, align 8
  %t541 = inttoptr i64 %t541_i64 to i8*
  %t542 = call i8* @flux_str_concat(i8* %t540, i8* %t541)
  %pr_sn_5 = icmp eq i8* %t542, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t542
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  br label %route_end_535
route_arm_536:
  br label %route_end_535
route_end_535:
  %t544 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_81 = ptrtoint i8* %t544 to i64
  store i64 %st_81, i64* %cur_chunk, align 8
  br label %route_end_526
route_arm_531:
  %t546_i64 = load i64, i64* %cur_chunk, align 8
  %t546 = inttoptr i64 %t546_i64 to i8*
  %t547_i64 = load i64, i64* %ch_out, align 8
  %t547 = inttoptr i64 %t547_i64 to i8*
  %t548 = call i8* @flux_str_concat(i8* %t546, i8* %t547)
  %st_82 = ptrtoint i8* %t548 to i64
  store i64 %st_82, i64* %cur_chunk, align 8
  br label %route_end_526
route_end_526:
  %t549 = load i64, i64* %ci, align 8
  %t550 = add i64 0, 1
  %t551 = add i64 %t549, %t550
  store i64 %t551, i64* %ci, align 8
  br label %route_end_516
route_end_516:
  br label %loop_start_515
loop_end_515:
  %t554_i64 = load i64, i64* %cur_chunk, align 8
  %t554 = inttoptr i64 %t554_i64 to i8*
  %t555 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t556_cmp = call i32 @flux_str_compare(i8* %t554, i8* %t555)
  %t556 = icmp ne i32 %t556_cmp, 0
  br i1 %t556, label %ft_50, label %route_arm_553
ft_50:
  %t557 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.46, i32 0, i32 0
  %t558_i64 = load i64, i64* %cur_chunk, align 8
  %t558 = inttoptr i64 %t558_i64 to i8*
  %t559 = call i8* @flux_str_concat(i8* %t557, i8* %t558)
  %pr_sn_6 = icmp eq i8* %t559, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t559
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  br label %route_end_552
route_arm_553:
  br label %route_end_552
route_end_552:
  %t561 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.47, i32 0, i32 0
  %t562_i64 = load i64, i64* %nome, align 8
  %t562 = inttoptr i64 %t562_i64 to i8*
  %t563 = call i8* @flux_str_concat(i8* %t561, i8* %t562)
  %pr_sn_7 = icmp eq i8* %t563, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t563
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  br label %route_end_505
route_arm_506:
  %t565 = load i64, i64* %erros, align 8
  %t566 = add i64 0, 1
  %t567 = add i64 %t565, %t566
  store i64 %t567, i64* %erros, align 8
  %t568 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.48, i32 0, i32 0
  %t569_i64 = load i64, i64* %nome, align 8
  %t569 = inttoptr i64 %t569_i64 to i8*
  %t570 = call i8* @flux_str_concat(i8* %t568, i8* %t569)
  %t571 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.49, i32 0, i32 0
  %t572 = call i8* @flux_str_concat(i8* %t570, i8* %t571)
  %t573_i64 = load i64, i64* %error_msg, align 8
  %t573 = inttoptr i64 %t573_i64 to i8*
  %t574 = call i8* @flux_str_concat(i8* %t572, i8* %t573)
  %pr_sn_8 = icmp eq i8* %t574, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t574
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  br label %route_end_505
route_end_505:
  br label %route_end_354
route_end_354:
  br label %route_end_108
route_arm_109:
  br label %route_end_108
route_end_108:
  %t576 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_85 = ptrtoint i8* %t576 to i64
  store i64 %st_85, i64* %cur_fname, align 8
  br label %route_end_99
route_arm_104:
  %t578_i64 = load i64, i64* %cur_fname, align 8
  %t578 = inttoptr i64 %t578_i64 to i8*
  %t579_i64 = load i64, i64* %ch, align 8
  %t579 = inttoptr i64 %t579_i64 to i8*
  %t580 = call i8* @flux_str_concat(i8* %t578, i8* %t579)
  %st_86 = ptrtoint i8* %t580 to i64
  store i64 %st_86, i64* %cur_fname, align 8
  br label %route_end_99
route_end_99:
  %t581 = load i64, i64* %li, align 8
  %t582 = add i64 0, 1
  %t583 = add i64 %t581, %t582
  store i64 %t583, i64* %li, align 8
  br label %route_end_89
route_end_89:
  br label %loop_start_88
loop_end_88:
  %t584 = getelementptr inbounds [63 x i8], [63 x i8]* @.str.50, i32 0, i32 0
  %t585 = call i64 @flux_std_os_exec(i8* %t584)
  %t586 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %pr_sn_9 = icmp eq i8* %t586, null
  %pr_sc_9 = select i1 %pr_sn_9, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t586
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_9)
  call i32 @fflush(i8* null)
  %t587 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t588 = load i64, i64* %acertos, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t588)
  %t589 = call i8* @flux_str_concat(i8* %t587, i8* %cv_buf_1)
  %t590 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.51, i32 0, i32 0
  %t591 = call i8* @flux_str_concat(i8* %t589, i8* %t590)
  %t592 = load i64, i64* %erros, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t592)
  %t593 = call i8* @flux_str_concat(i8* %t591, i8* %cv_buf_2)
  %t594 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.52, i32 0, i32 0
  %t595 = call i8* @flux_str_concat(i8* %t593, i8* %t594)
  %pr_sn_10 = icmp eq i8* %t595, null
  %pr_sc_10 = select i1 %pr_sn_10, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t595
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_10)
  call i32 @fflush(i8* null)
  %t598 = load i64, i64* %erros, align 8
  %t599 = add i64 0, 0
  %t600 = icmp eq i64 %t598, %t599
  br i1 %t600, label %ft_51, label %route_arm_597
ft_51:
  %t601 = add i64 0, 0
  %t602 = call i64 @flux_std_os_exit(i64 %t601)
  br label %route_end_596
route_arm_597:
  %t604 = add i64 0, 1
  %t605 = call i64 @flux_std_os_exit(i64 %t604)
  br label %route_end_596
route_end_596:
  ret i32 0
}
