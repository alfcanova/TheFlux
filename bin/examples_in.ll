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
@.str.37 = private unnamed_addr constant [3 x i8] c"RT\00", align 1
@.str.38 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.39 = private unnamed_addr constant [14 x i8] c" --target in \00", align 1
@.str.40 = private unnamed_addr constant [4 x i8] c" < \00", align 1
@.str.41 = private unnamed_addr constant [18 x i8] c" > t_in.tmp 2>&1\22\00", align 1
@.str.42 = private unnamed_addr constant [9 x i8] c"t_in.tmp\00", align 1
@.str.43 = private unnamed_addr constant [17 x i8] c"Sem erro emitido\00", align 1
@.str.44 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str.45 = private unnamed_addr constant [4 x i8] c" - \00", align 1
@.str.46 = private unnamed_addr constant [6 x i8] c"Dica:\00", align 1
@.str.47 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.48 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.49 = private unnamed_addr constant [5 x i8] c"  | \00", align 1
@.str.50 = private unnamed_addr constant [7 x i8] c"  OK  \00", align 1
@.str.51 = private unnamed_addr constant [63 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_in.tmp t_canon_list.tmp 2>nul\00", align 1
@.str.52 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.53 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1

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
  %t279_i64 = load i64, i64* %expected_code, align 8
  %t279 = inttoptr i64 %t279_i64 to i8*
  %t280 = call i64 @flux_str_len(i8* %t279)
  %t281 = add i64 0, 2
  %t282 = icmp sge i64 %t280, %t281
  %t283_i64 = load i64, i64* %expected_code, align 8
  %t283 = inttoptr i64 %t283_i64 to i8*
  %t284 = add i64 0, 1
  %t285 = add i64 0, 2
  %t286 = call i8* @flux_str_slice(i8* %t283, i64 %t284, i64 %t285)
  %t287 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.37, i32 0, i32 0
  %t288_cmp = call i32 @flux_str_compare(i8* %t286, i8* %t287)
  %t288 = icmp eq i32 %t288_cmp, 0
  %t289 = and i1 %t282, %t288
  br i1 %t289, label %ft_26, label %route_arm_278
ft_26:
  %t290 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_43 = ptrtoint i8* %t290 to i64
  store i64 %st_43, i64* %expected_code, align 8
  br label %route_end_277
route_arm_278:
  br label %route_end_277
route_end_277:
  br label %loop_end_183
route_arm_193:
  %t293 = load i64, i64* %si, align 8
  %t294 = add i64 0, 1
  %t295 = add i64 %t293, %t294
  store i64 %t295, i64* %si, align 8
  br label %route_end_184
route_end_184:
  br label %loop_start_183
loop_end_183:
  br label %route_end_177
route_arm_178:
  br label %route_end_177
route_end_177:
  %t297 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.38, i32 0, i32 0
  %t298_i64 = load i64, i64* %fluxc_bin, align 8
  %t298 = inttoptr i64 %t298_i64 to i8*
  %t299 = call i8* @flux_str_concat(i8* %t297, i8* %t298)
  %t300 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.39, i32 0, i32 0
  %t301 = call i8* @flux_str_concat(i8* %t299, i8* %t300)
  %t302_i64 = load i64, i64* %filepath, align 8
  %t302 = inttoptr i64 %t302_i64 to i8*
  %t303 = call i8* @flux_str_concat(i8* %t301, i8* %t302)
  %t304 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.40, i32 0, i32 0
  %t305 = call i8* @flux_str_concat(i8* %t303, i8* %t304)
  %t306_i64 = load i64, i64* %stdin_file, align 8
  %t306 = inttoptr i64 %t306_i64 to i8*
  %t307 = call i8* @flux_str_concat(i8* %t305, i8* %t306)
  %t308 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.41, i32 0, i32 0
  %t309 = call i8* @flux_str_concat(i8* %t307, i8* %t308)
  %st_45 = ptrtoint i8* %t309 to i64
  store i64 %st_45, i64* %cmd_in, align 8
  %t310_i64 = load i64, i64* %cmd_in, align 8
  %t310 = inttoptr i64 %t310_i64 to i8*
  %t311 = call i64 @flux_std_os_exec(i8* %t310)
  store i64 %t311, i64* %ec, align 8
  %t312 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.42, i32 0, i32 0
  %t313 = call i8* @flux_std_io_read_file(i8* %t312)
  %st_47 = ptrtoint i8* %t313 to i64
  store i64 %st_47, i64* %out_full, align 8
  %t314_i64 = load i64, i64* %out_full, align 8
  %t314 = inttoptr i64 %t314_i64 to i8*
  %t315 = call i64 @flux_str_len(i8* %t314)
  store i64 %t315, i64* %out_len, align 8
  %t316 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_49 = ptrtoint i8* %t316 to i64
  store i64 %st_49, i64* %last_line, align 8
  %t317 = add i64 0, 1
  store i64 %t317, i64* %ci, align 8
  %t318 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_51 = ptrtoint i8* %t318 to i64
  store i64 %st_51, i64* %cur_chunk, align 8
  br label %loop_start_319
loop_start_319:
  %t322 = load i64, i64* %ci, align 8
  %t323 = load i64, i64* %out_len, align 8
  %t324 = icmp sgt i64 %t322, %t323
  br i1 %t324, label %ft_27, label %route_arm_321
ft_27:
  br label %loop_end_319
route_arm_321:
  %t326_i64 = load i64, i64* %out_full, align 8
  %t326 = inttoptr i64 %t326_i64 to i8*
  %t327 = load i64, i64* %ci, align 8
  %t328 = load i64, i64* %ci, align 8
  %t329 = call i8* @flux_str_slice(i8* %t326, i64 %t327, i64 %t328)
  %st_52 = ptrtoint i8* %t329 to i64
  store i64 %st_52, i64* %ch_out, align 8
  %t332_i64 = load i64, i64* %ch_out, align 8
  %t332 = inttoptr i64 %t332_i64 to i8*
  %t333 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t334_cmp = call i32 @flux_str_compare(i8* %t332, i8* %t333)
  %t334 = icmp eq i32 %t334_cmp, 0
  br i1 %t334, label %ft_28, label %route_arm_331
ft_28:
  br label %route_end_330
route_arm_331:
  %t336_i64 = load i64, i64* %ch_out, align 8
  %t336 = inttoptr i64 %t336_i64 to i8*
  %t337 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t338_cmp = call i32 @flux_str_compare(i8* %t336, i8* %t337)
  %t338 = icmp eq i32 %t338_cmp, 0
  br i1 %t338, label %ft_29, label %route_arm_335
ft_29:
  %t341_i64 = load i64, i64* %cur_chunk, align 8
  %t341 = inttoptr i64 %t341_i64 to i8*
  %t342 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t343_cmp = call i32 @flux_str_compare(i8* %t341, i8* %t342)
  %t343 = icmp ne i32 %t343_cmp, 0
  br i1 %t343, label %ft_30, label %route_arm_340
ft_30:
  %t344_i64 = load i64, i64* %cur_chunk, align 8
  %t344 = inttoptr i64 %t344_i64 to i8*
  %st_53 = ptrtoint i8* %t344 to i64
  store i64 %st_53, i64* %last_line, align 8
  br label %route_end_339
route_arm_340:
  br label %route_end_339
route_end_339:
  %t346 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_54 = ptrtoint i8* %t346 to i64
  store i64 %st_54, i64* %cur_chunk, align 8
  br label %route_end_330
route_arm_335:
  %t348_i64 = load i64, i64* %cur_chunk, align 8
  %t348 = inttoptr i64 %t348_i64 to i8*
  %t349_i64 = load i64, i64* %ch_out, align 8
  %t349 = inttoptr i64 %t349_i64 to i8*
  %t350 = call i8* @flux_str_concat(i8* %t348, i8* %t349)
  %st_55 = ptrtoint i8* %t350 to i64
  store i64 %st_55, i64* %cur_chunk, align 8
  br label %route_end_330
route_end_330:
  %t351 = load i64, i64* %ci, align 8
  %t352 = add i64 0, 1
  %t353 = add i64 %t351, %t352
  store i64 %t353, i64* %ci, align 8
  br label %route_end_320
route_end_320:
  br label %loop_start_319
loop_end_319:
  %t356_i64 = load i64, i64* %cur_chunk, align 8
  %t356 = inttoptr i64 %t356_i64 to i8*
  %t357 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t358_cmp = call i32 @flux_str_compare(i8* %t356, i8* %t357)
  %t358 = icmp ne i32 %t358_cmp, 0
  br i1 %t358, label %ft_31, label %route_arm_355
ft_31:
  %t359_i64 = load i64, i64* %cur_chunk, align 8
  %t359 = inttoptr i64 %t359_i64 to i8*
  %st_57 = ptrtoint i8* %t359 to i64
  store i64 %st_57, i64* %last_line, align 8
  br label %route_end_354
route_arm_355:
  br label %route_end_354
route_end_354:
  %t361_i64 = load i64, i64* %last_line, align 8
  %t361 = inttoptr i64 %t361_i64 to i8*
  %st_58 = ptrtoint i8* %t361 to i64
  store i64 %st_58, i64* %error_msg, align 8
  %t364_i64 = load i64, i64* %error_msg, align 8
  %t364 = inttoptr i64 %t364_i64 to i8*
  %t365 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t366_cmp = call i32 @flux_str_compare(i8* %t364, i8* %t365)
  %t366 = icmp eq i32 %t366_cmp, 0
  br i1 %t366, label %ft_32, label %route_arm_363
ft_32:
  %t367 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.43, i32 0, i32 0
  %st_59 = ptrtoint i8* %t367 to i64
  store i64 %st_59, i64* %error_msg, align 8
  br label %route_end_362
route_arm_363:
  br label %route_end_362
route_end_362:
  %t371_i64 = load i64, i64* %expected_code, align 8
  %t371 = inttoptr i64 %t371_i64 to i8*
  %t372 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t373_cmp = call i32 @flux_str_compare(i8* %t371, i8* %t372)
  %t373 = icmp ne i32 %t373_cmp, 0
  br i1 %t373, label %ft_33, label %route_arm_370
ft_33:
  %t374 = add i1 0, 0
  %st_b_60 = zext i1 %t374 to i64
  store i64 %st_b_60, i64* %match_code, align 8
  %t375 = add i1 0, 0
  %st_b_61 = zext i1 %t375 to i64
  store i64 %st_b_61, i64* %match_dica, align 8
  %t376 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.44, i32 0, i32 0
  %t377_i64 = load i64, i64* %expected_code, align 8
  %t377 = inttoptr i64 %t377_i64 to i8*
  %t378 = call i8* @flux_str_concat(i8* %t376, i8* %t377)
  %t379 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.45, i32 0, i32 0
  %t380 = call i8* @flux_str_concat(i8* %t378, i8* %t379)
  %st_62 = ptrtoint i8* %t380 to i64
  store i64 %st_62, i64* %code_needle, align 8
  %t381_i64 = load i64, i64* %code_needle, align 8
  %t381 = inttoptr i64 %t381_i64 to i8*
  %t382 = call i64 @flux_str_len(i8* %t381)
  store i64 %t382, i64* %cn_len, align 8
  %t385 = load i64, i64* %out_len, align 8
  %t386 = load i64, i64* %cn_len, align 8
  %t387 = icmp sge i64 %t385, %t386
  br i1 %t387, label %ft_34, label %route_arm_384
ft_34:
  %t388 = add i64 0, 1
  store i64 %t388, i64* %msi, align 8
  br label %loop_start_389
loop_start_389:
  %t392 = load i64, i64* %msi, align 8
  %t393 = load i64, i64* %cn_len, align 8
  %t394 = add i64 %t392, %t393
  %t395 = add i64 0, 1
  %t396 = sub i64 %t394, %t395
  %t397 = load i64, i64* %out_len, align 8
  %t398 = icmp sgt i64 %t396, %t397
  br i1 %t398, label %ft_35, label %route_arm_391
ft_35:
  br label %loop_end_389
route_arm_391:
  %t400_i64 = load i64, i64* %out_full, align 8
  %t400 = inttoptr i64 %t400_i64 to i8*
  %t401 = load i64, i64* %msi, align 8
  %t402 = load i64, i64* %msi, align 8
  %t403 = load i64, i64* %cn_len, align 8
  %t404 = add i64 %t402, %t403
  %t405 = add i64 0, 1
  %t406 = sub i64 %t404, %t405
  %t407 = call i8* @flux_str_slice(i8* %t400, i64 %t401, i64 %t406)
  %t408_i64 = load i64, i64* %code_needle, align 8
  %t408 = inttoptr i64 %t408_i64 to i8*
  %t409_cmp = call i32 @flux_str_compare(i8* %t407, i8* %t408)
  %t409 = icmp eq i32 %t409_cmp, 0
  br i1 %t409, label %ft_36, label %route_arm_399
ft_36:
  %t410 = add i1 0, 1
  %st_b_65 = zext i1 %t410 to i64
  store i64 %st_b_65, i64* %match_code, align 8
  br label %loop_end_389
route_arm_399:
  %t412 = load i64, i64* %msi, align 8
  %t413 = add i64 0, 1
  %t414 = add i64 %t412, %t413
  store i64 %t414, i64* %msi, align 8
  br label %route_end_390
route_end_390:
  br label %loop_start_389
loop_end_389:
  br label %route_end_383
route_arm_384:
  br label %route_end_383
route_end_383:
  %t418 = load i64, i64* %out_len, align 8
  %t419 = add i64 0, 5
  %t420 = icmp sge i64 %t418, %t419
  br i1 %t420, label %ft_37, label %route_arm_417
ft_37:
  %t421 = add i64 0, 1
  store i64 %t421, i64* %msi, align 8
  br label %loop_start_422
loop_start_422:
  %t425 = load i64, i64* %msi, align 8
  %t426 = add i64 0, 4
  %t427 = add i64 %t425, %t426
  %t428 = load i64, i64* %out_len, align 8
  %t429 = icmp sgt i64 %t427, %t428
  br i1 %t429, label %ft_38, label %route_arm_424
ft_38:
  br label %loop_end_422
route_arm_424:
  %t431_i64 = load i64, i64* %out_full, align 8
  %t431 = inttoptr i64 %t431_i64 to i8*
  %t432 = load i64, i64* %msi, align 8
  %t433 = load i64, i64* %msi, align 8
  %t434 = add i64 0, 4
  %t435 = add i64 %t433, %t434
  %t436 = call i8* @flux_str_slice(i8* %t431, i64 %t432, i64 %t435)
  %t437 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.46, i32 0, i32 0
  %t438_cmp = call i32 @flux_str_compare(i8* %t436, i8* %t437)
  %t438 = icmp eq i32 %t438_cmp, 0
  br i1 %t438, label %ft_39, label %route_arm_430
ft_39:
  %t439 = add i1 0, 1
  %st_b_68 = zext i1 %t439 to i64
  store i64 %st_b_68, i64* %match_dica, align 8
  br label %loop_end_422
route_arm_430:
  %t441 = load i64, i64* %msi, align 8
  %t442 = add i64 0, 1
  %t443 = add i64 %t441, %t442
  store i64 %t443, i64* %msi, align 8
  br label %route_end_423
route_end_423:
  br label %loop_start_422
loop_end_422:
  br label %route_end_416
route_arm_417:
  br label %route_end_416
route_end_416:
  %t447 = load i64, i64* %ec, align 8
  %t448 = add i64 0, 0
  %t449 = icmp ne i64 %t447, %t448
  %t450_i64 = load i64, i64* %match_code, align 8
  %t450 = trunc i64 %t450_i64 to i1
  %t451 = and i1 %t449, %t450
  %t452_i64 = load i64, i64* %match_dica, align 8
  %t452 = trunc i64 %t452_i64 to i1
  %t453 = and i1 %t451, %t452
  br i1 %t453, label %ft_40, label %route_arm_446
ft_40:
  %t454 = load i64, i64* %erros, align 8
  %t455 = add i64 0, 1
  %t456 = add i64 %t454, %t455
  store i64 %t456, i64* %erros, align 8
  %t457 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.47, i32 0, i32 0
  %t458_i64 = load i64, i64* %nome, align 8
  %t458 = inttoptr i64 %t458_i64 to i8*
  %t459 = call i8* @flux_str_concat(i8* %t457, i8* %t458)
  %t460 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.48, i32 0, i32 0
  %t461 = call i8* @flux_str_concat(i8* %t459, i8* %t460)
  %t462_i64 = load i64, i64* %error_msg, align 8
  %t462 = inttoptr i64 %t462_i64 to i8*
  %t463 = call i8* @flux_str_concat(i8* %t461, i8* %t462)
  %pr_sn_1 = icmp eq i8* %t463, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t463
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  br label %route_end_445
route_arm_446:
  %t465 = load i64, i64* %erros, align 8
  %t466 = add i64 0, 1
  %t467 = add i64 %t465, %t466
  store i64 %t467, i64* %erros, align 8
  %t468 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.47, i32 0, i32 0
  %t469_i64 = load i64, i64* %nome, align 8
  %t469 = inttoptr i64 %t469_i64 to i8*
  %t470 = call i8* @flux_str_concat(i8* %t468, i8* %t469)
  %t471 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.48, i32 0, i32 0
  %t472 = call i8* @flux_str_concat(i8* %t470, i8* %t471)
  %t473_i64 = load i64, i64* %error_msg, align 8
  %t473 = inttoptr i64 %t473_i64 to i8*
  %t474 = call i8* @flux_str_concat(i8* %t472, i8* %t473)
  %pr_sn_2 = icmp eq i8* %t474, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t474
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  br label %route_end_445
route_end_445:
  br label %route_end_369
route_arm_370:
  %t478 = load i64, i64* %ec, align 8
  %t479 = add i64 0, 0
  %t480 = icmp eq i64 %t478, %t479
  br i1 %t480, label %ft_41, label %route_arm_477
ft_41:
  %t481 = load i64, i64* %acertos, align 8
  %t482 = add i64 0, 1
  %t483 = add i64 %t481, %t482
  store i64 %t483, i64* %acertos, align 8
  %t484 = add i64 0, 1
  store i64 %t484, i64* %ci, align 8
  %t485 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_74 = ptrtoint i8* %t485 to i64
  store i64 %st_74, i64* %cur_chunk, align 8
  br label %loop_start_486
loop_start_486:
  %t489 = load i64, i64* %ci, align 8
  %t490 = load i64, i64* %out_len, align 8
  %t491 = icmp sgt i64 %t489, %t490
  br i1 %t491, label %ft_42, label %route_arm_488
ft_42:
  br label %loop_end_486
route_arm_488:
  %t493_i64 = load i64, i64* %out_full, align 8
  %t493 = inttoptr i64 %t493_i64 to i8*
  %t494 = load i64, i64* %ci, align 8
  %t495 = load i64, i64* %ci, align 8
  %t496 = call i8* @flux_str_slice(i8* %t493, i64 %t494, i64 %t495)
  %st_75 = ptrtoint i8* %t496 to i64
  store i64 %st_75, i64* %ch_out, align 8
  %t499_i64 = load i64, i64* %ch_out, align 8
  %t499 = inttoptr i64 %t499_i64 to i8*
  %t500 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t501_cmp = call i32 @flux_str_compare(i8* %t499, i8* %t500)
  %t501 = icmp eq i32 %t501_cmp, 0
  br i1 %t501, label %ft_43, label %route_arm_498
ft_43:
  br label %route_end_497
route_arm_498:
  %t503_i64 = load i64, i64* %ch_out, align 8
  %t503 = inttoptr i64 %t503_i64 to i8*
  %t504 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t505_cmp = call i32 @flux_str_compare(i8* %t503, i8* %t504)
  %t505 = icmp eq i32 %t505_cmp, 0
  br i1 %t505, label %ft_44, label %route_arm_502
ft_44:
  %t506 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.49, i32 0, i32 0
  %t507_i64 = load i64, i64* %cur_chunk, align 8
  %t507 = inttoptr i64 %t507_i64 to i8*
  %t508 = call i8* @flux_str_concat(i8* %t506, i8* %t507)
  %pr_sn_3 = icmp eq i8* %t508, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t508
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  %t509 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_76 = ptrtoint i8* %t509 to i64
  store i64 %st_76, i64* %cur_chunk, align 8
  br label %route_end_497
route_arm_502:
  %t511_i64 = load i64, i64* %cur_chunk, align 8
  %t511 = inttoptr i64 %t511_i64 to i8*
  %t512_i64 = load i64, i64* %ch_out, align 8
  %t512 = inttoptr i64 %t512_i64 to i8*
  %t513 = call i8* @flux_str_concat(i8* %t511, i8* %t512)
  %st_77 = ptrtoint i8* %t513 to i64
  store i64 %st_77, i64* %cur_chunk, align 8
  br label %route_end_497
route_end_497:
  %t514 = load i64, i64* %ci, align 8
  %t515 = add i64 0, 1
  %t516 = add i64 %t514, %t515
  store i64 %t516, i64* %ci, align 8
  br label %route_end_487
route_end_487:
  br label %loop_start_486
loop_end_486:
  %t519_i64 = load i64, i64* %cur_chunk, align 8
  %t519 = inttoptr i64 %t519_i64 to i8*
  %t520 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t521_cmp = call i32 @flux_str_compare(i8* %t519, i8* %t520)
  %t521 = icmp ne i32 %t521_cmp, 0
  br i1 %t521, label %ft_45, label %route_arm_518
ft_45:
  %t522 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.49, i32 0, i32 0
  %t523_i64 = load i64, i64* %cur_chunk, align 8
  %t523 = inttoptr i64 %t523_i64 to i8*
  %t524 = call i8* @flux_str_concat(i8* %t522, i8* %t523)
  %pr_sn_4 = icmp eq i8* %t524, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t524
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  br label %route_end_517
route_arm_518:
  br label %route_end_517
route_end_517:
  %t526 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.50, i32 0, i32 0
  %t527_i64 = load i64, i64* %nome, align 8
  %t527 = inttoptr i64 %t527_i64 to i8*
  %t528 = call i8* @flux_str_concat(i8* %t526, i8* %t527)
  %pr_sn_5 = icmp eq i8* %t528, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t528
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  br label %route_end_476
route_arm_477:
  %t530 = load i64, i64* %erros, align 8
  %t531 = add i64 0, 1
  %t532 = add i64 %t530, %t531
  store i64 %t532, i64* %erros, align 8
  %t533 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.47, i32 0, i32 0
  %t534_i64 = load i64, i64* %nome, align 8
  %t534 = inttoptr i64 %t534_i64 to i8*
  %t535 = call i8* @flux_str_concat(i8* %t533, i8* %t534)
  %t536 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.48, i32 0, i32 0
  %t537 = call i8* @flux_str_concat(i8* %t535, i8* %t536)
  %t538_i64 = load i64, i64* %error_msg, align 8
  %t538 = inttoptr i64 %t538_i64 to i8*
  %t539 = call i8* @flux_str_concat(i8* %t537, i8* %t538)
  %pr_sn_6 = icmp eq i8* %t539, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t539
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  br label %route_end_476
route_end_476:
  br label %route_end_369
route_end_369:
  br label %route_end_108
route_arm_109:
  br label %route_end_108
route_end_108:
  %t541 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_80 = ptrtoint i8* %t541 to i64
  store i64 %st_80, i64* %cur_fname, align 8
  br label %route_end_99
route_arm_104:
  %t543_i64 = load i64, i64* %cur_fname, align 8
  %t543 = inttoptr i64 %t543_i64 to i8*
  %t544_i64 = load i64, i64* %ch, align 8
  %t544 = inttoptr i64 %t544_i64 to i8*
  %t545 = call i8* @flux_str_concat(i8* %t543, i8* %t544)
  %st_81 = ptrtoint i8* %t545 to i64
  store i64 %st_81, i64* %cur_fname, align 8
  br label %route_end_99
route_end_99:
  %t546 = load i64, i64* %li, align 8
  %t547 = add i64 0, 1
  %t548 = add i64 %t546, %t547
  store i64 %t548, i64* %li, align 8
  br label %route_end_89
route_end_89:
  br label %loop_start_88
loop_end_88:
  %t549 = getelementptr inbounds [63 x i8], [63 x i8]* @.str.51, i32 0, i32 0
  %t550 = call i64 @flux_std_os_exec(i8* %t549)
  %t551 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %pr_sn_7 = icmp eq i8* %t551, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t551
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  %t552 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t553 = load i64, i64* %acertos, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t553)
  %t554 = call i8* @flux_str_concat(i8* %t552, i8* %cv_buf_1)
  %t555 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.52, i32 0, i32 0
  %t556 = call i8* @flux_str_concat(i8* %t554, i8* %t555)
  %t557 = load i64, i64* %erros, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t557)
  %t558 = call i8* @flux_str_concat(i8* %t556, i8* %cv_buf_2)
  %t559 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.53, i32 0, i32 0
  %t560 = call i8* @flux_str_concat(i8* %t558, i8* %t559)
  %pr_sn_8 = icmp eq i8* %t560, null
  %pr_sc_8 = select i1 %pr_sn_8, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t560
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_8)
  call i32 @fflush(i8* null)
  %t563 = load i64, i64* %erros, align 8
  %t564 = add i64 0, 0
  %t565 = icmp eq i64 %t563, %t564
  br i1 %t565, label %ft_46, label %route_arm_562
ft_46:
  %t566 = add i64 0, 0
  %t567 = call i64 @flux_std_os_exit(i64 %t566)
  br label %route_end_561
route_arm_562:
  %t569 = add i64 0, 1
  %t570 = call i64 @flux_std_os_exit(i64 %t569)
  br label %route_end_561
route_end_561:
  ret i32 0
}
