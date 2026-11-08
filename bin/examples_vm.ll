; ModuleID = 'ExamplesVm'
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
@.str.14 = private unnamed_addr constant [42 x i8] c"cmd /c if not exist t_fvmbc mkdir t_fvmbc\00", align 1
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
@.str.32 = private unnamed_addr constant [9 x i8] c"t_fvmbc\5C\00", align 1
@.str.33 = private unnamed_addr constant [7 x i8] c".fvmbc\00", align 1
@.str.34 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.35 = private unnamed_addr constant [14 x i8] c" --target vm \00", align 1
@.str.36 = private unnamed_addr constant [5 x i8] c" -o \00", align 1
@.str.37 = private unnamed_addr constant [13 x i8] c" --no-run < \00", align 1
@.str.38 = private unnamed_addr constant [20 x i8] c" > t_vm_c.tmp 2>&1\22\00", align 1
@.str.39 = private unnamed_addr constant [11 x i8] c"t_vm_c.tmp\00", align 1
@.str.40 = private unnamed_addr constant [10 x i8] c"  [bc]   \00", align 1
@.str.41 = private unnamed_addr constant [5 x i8] c"  | \00", align 1
@.str.42 = private unnamed_addr constant [7 x i8] c"  OK  \00", align 1
@.str.43 = private unnamed_addr constant [17 x i8] c"Sem erro emitido\00", align 1
@.str.44 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.45 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.46 = private unnamed_addr constant [65 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_vm_c.tmp t_canon_list.tmp 2>nul\00", align 1
@.str.47 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.48 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1

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
  %out_stem = alloca i64, align 8
  %fvmbc_file = alloca i64, align 8
  %cmd_vm_c = alloca i64, align 8
  %ec = alloca i64, align 8
  %out_full = alloca i64, align 8
  %out_len = alloca i64, align 8
  %ci = alloca i64, align 8
  %cur_chunk = alloca i64, align 8
  %ch_o = alloca i64, align 8
  %last_line = alloca i64, align 8
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
  %t41 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.14, i32 0, i32 0
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
  %t119_i64 = load i64, i64* %nome, align 8
  %t119 = inttoptr i64 %t119_i64 to i8*
  %t120 = call i64 @flux_str_len(i8* %t119)
  store i64 %t120, i64* %nlen, align 8
  %t121_i64 = load i64, i64* %nome, align 8
  %t121 = inttoptr i64 %t121_i64 to i8*
  %t122 = add i64 0, 1
  %t123 = load i64, i64* %nlen, align 8
  %t124 = add i64 0, 5
  %t125 = sub i64 %t123, %t124
  %t126 = call i8* @flux_str_slice(i8* %t121, i64 %t122, i64 %t125)
  %st_25 = ptrtoint i8* %t126 to i64
  store i64 %st_25, i64* %stem, align 8
  %t127 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.21, i32 0, i32 0
  %st_26 = ptrtoint i8* %t127 to i64
  store i64 %st_26, i64* %stdin_file, align 8
  %t130_i64 = load i64, i64* %nome, align 8
  %t130 = inttoptr i64 %t130_i64 to i8*
  %t131 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.29, i32 0, i32 0
  %t132_cmp = call i32 @flux_str_compare(i8* %t130, i8* %t131)
  %t132 = icmp eq i32 %t132_cmp, 0
  br i1 %t132, label %ft_13, label %route_arm_129
ft_13:
  %t133 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.19, i32 0, i32 0
  %st_27 = ptrtoint i8* %t133 to i64
  store i64 %st_27, i64* %stdin_file, align 8
  br label %route_end_128
route_arm_129:
  %t135_i64 = load i64, i64* %nome, align 8
  %t135 = inttoptr i64 %t135_i64 to i8*
  %t136 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.30, i32 0, i32 0
  %t137_cmp = call i32 @flux_str_compare(i8* %t135, i8* %t136)
  %t137 = icmp eq i32 %t137_cmp, 0
  br i1 %t137, label %ft_14, label %route_arm_134
ft_14:
  %t138 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.15, i32 0, i32 0
  %st_28 = ptrtoint i8* %t138 to i64
  store i64 %st_28, i64* %stdin_file, align 8
  br label %route_end_128
route_arm_134:
  %t140_i64 = load i64, i64* %nome, align 8
  %t140 = inttoptr i64 %t140_i64 to i8*
  %t141 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.31, i32 0, i32 0
  %t142_cmp = call i32 @flux_str_compare(i8* %t140, i8* %t141)
  %t142 = icmp eq i32 %t142_cmp, 0
  br i1 %t142, label %ft_15, label %route_arm_139
ft_15:
  %t143 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.17, i32 0, i32 0
  %st_29 = ptrtoint i8* %t143 to i64
  store i64 %st_29, i64* %stdin_file, align 8
  br label %route_end_128
route_arm_139:
  br label %route_end_128
route_end_128:
  %t145 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.32, i32 0, i32 0
  %t146_i64 = load i64, i64* %stem, align 8
  %t146 = inttoptr i64 %t146_i64 to i8*
  %t147 = call i8* @flux_str_concat(i8* %t145, i8* %t146)
  %st_30 = ptrtoint i8* %t147 to i64
  store i64 %st_30, i64* %out_stem, align 8
  %t148 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.32, i32 0, i32 0
  %t149_i64 = load i64, i64* %stem, align 8
  %t149 = inttoptr i64 %t149_i64 to i8*
  %t150 = call i8* @flux_str_concat(i8* %t148, i8* %t149)
  %t151 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.33, i32 0, i32 0
  %t152 = call i8* @flux_str_concat(i8* %t150, i8* %t151)
  %st_31 = ptrtoint i8* %t152 to i64
  store i64 %st_31, i64* %fvmbc_file, align 8
  %t153 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.34, i32 0, i32 0
  %t154_i64 = load i64, i64* %fluxc_bin, align 8
  %t154 = inttoptr i64 %t154_i64 to i8*
  %t155 = call i8* @flux_str_concat(i8* %t153, i8* %t154)
  %t156 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.35, i32 0, i32 0
  %t157 = call i8* @flux_str_concat(i8* %t155, i8* %t156)
  %t158_i64 = load i64, i64* %filepath, align 8
  %t158 = inttoptr i64 %t158_i64 to i8*
  %t159 = call i8* @flux_str_concat(i8* %t157, i8* %t158)
  %t160 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.36, i32 0, i32 0
  %t161 = call i8* @flux_str_concat(i8* %t159, i8* %t160)
  %t162_i64 = load i64, i64* %out_stem, align 8
  %t162 = inttoptr i64 %t162_i64 to i8*
  %t163 = call i8* @flux_str_concat(i8* %t161, i8* %t162)
  %t164 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.37, i32 0, i32 0
  %t165 = call i8* @flux_str_concat(i8* %t163, i8* %t164)
  %t166_i64 = load i64, i64* %stdin_file, align 8
  %t166 = inttoptr i64 %t166_i64 to i8*
  %t167 = call i8* @flux_str_concat(i8* %t165, i8* %t166)
  %t168 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.38, i32 0, i32 0
  %t169 = call i8* @flux_str_concat(i8* %t167, i8* %t168)
  %st_32 = ptrtoint i8* %t169 to i64
  store i64 %st_32, i64* %cmd_vm_c, align 8
  %t170_i64 = load i64, i64* %cmd_vm_c, align 8
  %t170 = inttoptr i64 %t170_i64 to i8*
  %t171 = call i64 @flux_std_os_exec(i8* %t170)
  store i64 %t171, i64* %ec, align 8
  %t172 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.39, i32 0, i32 0
  %t173 = call i8* @flux_std_io_read_file(i8* %t172)
  %st_34 = ptrtoint i8* %t173 to i64
  store i64 %st_34, i64* %out_full, align 8
  %t174_i64 = load i64, i64* %out_full, align 8
  %t174 = inttoptr i64 %t174_i64 to i8*
  %t175 = call i64 @flux_str_len(i8* %t174)
  store i64 %t175, i64* %out_len, align 8
  %t178 = load i64, i64* %ec, align 8
  %t179 = add i64 0, 0
  %t180 = icmp eq i64 %t178, %t179
  br i1 %t180, label %ft_16, label %route_arm_177
ft_16:
  %t181 = load i64, i64* %acertos, align 8
  %t182 = add i64 0, 1
  %t183 = add i64 %t181, %t182
  store i64 %t183, i64* %acertos, align 8
  %t184 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.40, i32 0, i32 0
  %t185_i64 = load i64, i64* %stem, align 8
  %t185 = inttoptr i64 %t185_i64 to i8*
  %t186 = call i8* @flux_str_concat(i8* %t184, i8* %t185)
  %t187 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.33, i32 0, i32 0
  %t188 = call i8* @flux_str_concat(i8* %t186, i8* %t187)
  %pr_sn_1 = icmp eq i8* %t188, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t188
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  %t189 = add i64 0, 1
  store i64 %t189, i64* %ci, align 8
  %t190 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_38 = ptrtoint i8* %t190 to i64
  store i64 %st_38, i64* %cur_chunk, align 8
  br label %loop_start_191
loop_start_191:
  %t194 = load i64, i64* %ci, align 8
  %t195 = load i64, i64* %out_len, align 8
  %t196 = icmp sgt i64 %t194, %t195
  br i1 %t196, label %ft_17, label %route_arm_193
ft_17:
  br label %loop_end_191
route_arm_193:
  %t198_i64 = load i64, i64* %out_full, align 8
  %t198 = inttoptr i64 %t198_i64 to i8*
  %t199 = load i64, i64* %ci, align 8
  %t200 = load i64, i64* %ci, align 8
  %t201 = call i8* @flux_str_slice(i8* %t198, i64 %t199, i64 %t200)
  %st_39 = ptrtoint i8* %t201 to i64
  store i64 %st_39, i64* %ch_o, align 8
  %t204_i64 = load i64, i64* %ch_o, align 8
  %t204 = inttoptr i64 %t204_i64 to i8*
  %t205 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t206_cmp = call i32 @flux_str_compare(i8* %t204, i8* %t205)
  %t206 = icmp eq i32 %t206_cmp, 0
  br i1 %t206, label %ft_18, label %route_arm_203
ft_18:
  br label %route_end_202
route_arm_203:
  %t208_i64 = load i64, i64* %ch_o, align 8
  %t208 = inttoptr i64 %t208_i64 to i8*
  %t209 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t210_cmp = call i32 @flux_str_compare(i8* %t208, i8* %t209)
  %t210 = icmp eq i32 %t210_cmp, 0
  br i1 %t210, label %ft_19, label %route_arm_207
ft_19:
  %t211 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.41, i32 0, i32 0
  %t212_i64 = load i64, i64* %cur_chunk, align 8
  %t212 = inttoptr i64 %t212_i64 to i8*
  %t213 = call i8* @flux_str_concat(i8* %t211, i8* %t212)
  %pr_sn_2 = icmp eq i8* %t213, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t213
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  %t214 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_40 = ptrtoint i8* %t214 to i64
  store i64 %st_40, i64* %cur_chunk, align 8
  br label %route_end_202
route_arm_207:
  %t216_i64 = load i64, i64* %cur_chunk, align 8
  %t216 = inttoptr i64 %t216_i64 to i8*
  %t217_i64 = load i64, i64* %ch_o, align 8
  %t217 = inttoptr i64 %t217_i64 to i8*
  %t218 = call i8* @flux_str_concat(i8* %t216, i8* %t217)
  %st_41 = ptrtoint i8* %t218 to i64
  store i64 %st_41, i64* %cur_chunk, align 8
  br label %route_end_202
route_end_202:
  %t219 = load i64, i64* %ci, align 8
  %t220 = add i64 0, 1
  %t221 = add i64 %t219, %t220
  store i64 %t221, i64* %ci, align 8
  br label %route_end_192
route_end_192:
  br label %loop_start_191
loop_end_191:
  %t224_i64 = load i64, i64* %cur_chunk, align 8
  %t224 = inttoptr i64 %t224_i64 to i8*
  %t225 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t226_cmp = call i32 @flux_str_compare(i8* %t224, i8* %t225)
  %t226 = icmp ne i32 %t226_cmp, 0
  br i1 %t226, label %ft_20, label %route_arm_223
ft_20:
  %t227 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.41, i32 0, i32 0
  %t228_i64 = load i64, i64* %cur_chunk, align 8
  %t228 = inttoptr i64 %t228_i64 to i8*
  %t229 = call i8* @flux_str_concat(i8* %t227, i8* %t228)
  %pr_sn_3 = icmp eq i8* %t229, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t229
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  br label %route_end_222
route_arm_223:
  br label %route_end_222
route_end_222:
  %t231 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.42, i32 0, i32 0
  %t232_i64 = load i64, i64* %nome, align 8
  %t232 = inttoptr i64 %t232_i64 to i8*
  %t233 = call i8* @flux_str_concat(i8* %t231, i8* %t232)
  %pr_sn_4 = icmp eq i8* %t233, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t233
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  br label %route_end_176
route_arm_177:
  %t235 = load i64, i64* %erros, align 8
  %t236 = add i64 0, 1
  %t237 = add i64 %t235, %t236
  store i64 %t237, i64* %erros, align 8
  %t238 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_44 = ptrtoint i8* %t238 to i64
  store i64 %st_44, i64* %last_line, align 8
  %t239 = add i64 0, 1
  store i64 %t239, i64* %ci, align 8
  %t240 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_46 = ptrtoint i8* %t240 to i64
  store i64 %st_46, i64* %cur_chunk, align 8
  br label %loop_start_241
loop_start_241:
  %t244 = load i64, i64* %ci, align 8
  %t245 = load i64, i64* %out_len, align 8
  %t246 = icmp sgt i64 %t244, %t245
  br i1 %t246, label %ft_21, label %route_arm_243
ft_21:
  br label %loop_end_241
route_arm_243:
  %t248_i64 = load i64, i64* %out_full, align 8
  %t248 = inttoptr i64 %t248_i64 to i8*
  %t249 = load i64, i64* %ci, align 8
  %t250 = load i64, i64* %ci, align 8
  %t251 = call i8* @flux_str_slice(i8* %t248, i64 %t249, i64 %t250)
  %st_47 = ptrtoint i8* %t251 to i64
  store i64 %st_47, i64* %ch_o, align 8
  %t254_i64 = load i64, i64* %ch_o, align 8
  %t254 = inttoptr i64 %t254_i64 to i8*
  %t255 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.27, i32 0, i32 0
  %t256_cmp = call i32 @flux_str_compare(i8* %t254, i8* %t255)
  %t256 = icmp eq i32 %t256_cmp, 0
  br i1 %t256, label %ft_22, label %route_arm_253
ft_22:
  br label %route_end_252
route_arm_253:
  %t258_i64 = load i64, i64* %ch_o, align 8
  %t258 = inttoptr i64 %t258_i64 to i8*
  %t259 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t260_cmp = call i32 @flux_str_compare(i8* %t258, i8* %t259)
  %t260 = icmp eq i32 %t260_cmp, 0
  br i1 %t260, label %ft_23, label %route_arm_257
ft_23:
  %t263_i64 = load i64, i64* %cur_chunk, align 8
  %t263 = inttoptr i64 %t263_i64 to i8*
  %t264 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t265_cmp = call i32 @flux_str_compare(i8* %t263, i8* %t264)
  %t265 = icmp ne i32 %t265_cmp, 0
  br i1 %t265, label %ft_24, label %route_arm_262
ft_24:
  %t266_i64 = load i64, i64* %cur_chunk, align 8
  %t266 = inttoptr i64 %t266_i64 to i8*
  %st_48 = ptrtoint i8* %t266 to i64
  store i64 %st_48, i64* %last_line, align 8
  br label %route_end_261
route_arm_262:
  br label %route_end_261
route_end_261:
  %t268 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_49 = ptrtoint i8* %t268 to i64
  store i64 %st_49, i64* %cur_chunk, align 8
  br label %route_end_252
route_arm_257:
  %t270_i64 = load i64, i64* %cur_chunk, align 8
  %t270 = inttoptr i64 %t270_i64 to i8*
  %t271_i64 = load i64, i64* %ch_o, align 8
  %t271 = inttoptr i64 %t271_i64 to i8*
  %t272 = call i8* @flux_str_concat(i8* %t270, i8* %t271)
  %st_50 = ptrtoint i8* %t272 to i64
  store i64 %st_50, i64* %cur_chunk, align 8
  br label %route_end_252
route_end_252:
  %t273 = load i64, i64* %ci, align 8
  %t274 = add i64 0, 1
  %t275 = add i64 %t273, %t274
  store i64 %t275, i64* %ci, align 8
  br label %route_end_242
route_end_242:
  br label %loop_start_241
loop_end_241:
  %t278_i64 = load i64, i64* %cur_chunk, align 8
  %t278 = inttoptr i64 %t278_i64 to i8*
  %t279 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t280_cmp = call i32 @flux_str_compare(i8* %t278, i8* %t279)
  %t280 = icmp ne i32 %t280_cmp, 0
  br i1 %t280, label %ft_25, label %route_arm_277
ft_25:
  %t281_i64 = load i64, i64* %cur_chunk, align 8
  %t281 = inttoptr i64 %t281_i64 to i8*
  %st_52 = ptrtoint i8* %t281 to i64
  store i64 %st_52, i64* %last_line, align 8
  br label %route_end_276
route_arm_277:
  br label %route_end_276
route_end_276:
  %t285_i64 = load i64, i64* %last_line, align 8
  %t285 = inttoptr i64 %t285_i64 to i8*
  %t286 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t287_cmp = call i32 @flux_str_compare(i8* %t285, i8* %t286)
  %t287 = icmp eq i32 %t287_cmp, 0
  br i1 %t287, label %ft_26, label %route_arm_284
ft_26:
  %t288 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.43, i32 0, i32 0
  %st_53 = ptrtoint i8* %t288 to i64
  store i64 %st_53, i64* %last_line, align 8
  br label %route_end_283
route_arm_284:
  br label %route_end_283
route_end_283:
  %t290 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.44, i32 0, i32 0
  %t291_i64 = load i64, i64* %nome, align 8
  %t291 = inttoptr i64 %t291_i64 to i8*
  %t292 = call i8* @flux_str_concat(i8* %t290, i8* %t291)
  %t293 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.45, i32 0, i32 0
  %t294 = call i8* @flux_str_concat(i8* %t292, i8* %t293)
  %t295_i64 = load i64, i64* %last_line, align 8
  %t295 = inttoptr i64 %t295_i64 to i8*
  %t296 = call i8* @flux_str_concat(i8* %t294, i8* %t295)
  %pr_sn_5 = icmp eq i8* %t296, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t296
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  br label %route_end_176
route_end_176:
  br label %route_end_108
route_arm_109:
  br label %route_end_108
route_end_108:
  %t298 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %st_54 = ptrtoint i8* %t298 to i64
  store i64 %st_54, i64* %cur_fname, align 8
  br label %route_end_99
route_arm_104:
  %t300_i64 = load i64, i64* %cur_fname, align 8
  %t300 = inttoptr i64 %t300_i64 to i8*
  %t301_i64 = load i64, i64* %ch, align 8
  %t301 = inttoptr i64 %t301_i64 to i8*
  %t302 = call i8* @flux_str_concat(i8* %t300, i8* %t301)
  %st_55 = ptrtoint i8* %t302 to i64
  store i64 %st_55, i64* %cur_fname, align 8
  br label %route_end_99
route_end_99:
  %t303 = load i64, i64* %li, align 8
  %t304 = add i64 0, 1
  %t305 = add i64 %t303, %t304
  store i64 %t305, i64* %li, align 8
  br label %route_end_89
route_end_89:
  br label %loop_start_88
loop_end_88:
  %t306 = getelementptr inbounds [65 x i8], [65 x i8]* @.str.46, i32 0, i32 0
  %t307 = call i64 @flux_std_os_exec(i8* %t306)
  %t308 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %pr_sn_6 = icmp eq i8* %t308, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t308
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  %t309 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.22, i32 0, i32 0
  %t310 = load i64, i64* %acertos, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t310)
  %t311 = call i8* @flux_str_concat(i8* %t309, i8* %cv_buf_1)
  %t312 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.47, i32 0, i32 0
  %t313 = call i8* @flux_str_concat(i8* %t311, i8* %t312)
  %t314 = load i64, i64* %erros, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t314)
  %t315 = call i8* @flux_str_concat(i8* %t313, i8* %cv_buf_2)
  %t316 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.48, i32 0, i32 0
  %t317 = call i8* @flux_str_concat(i8* %t315, i8* %t316)
  %pr_sn_7 = icmp eq i8* %t317, null
  %pr_sc_7 = select i1 %pr_sn_7, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t317
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_7)
  call i32 @fflush(i8* null)
  %t320 = load i64, i64* %erros, align 8
  %t321 = add i64 0, 0
  %t322 = icmp eq i64 %t320, %t321
  br i1 %t322, label %ft_27, label %route_arm_319
ft_27:
  %t323 = add i64 0, 0
  %t324 = call i64 @flux_std_os_exit(i64 %t323)
  br label %route_end_318
route_arm_319:
  %t326 = add i64 0, 1
  %t327 = call i64 @flux_std_os_exit(i64 %t326)
  br label %route_end_318
route_end_318:
  ret i32 0
}
