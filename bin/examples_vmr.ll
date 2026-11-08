; ModuleID = 'ExamplesVmr'
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
@.str.10 = private unnamed_addr constant [8 x i8] c"t_fvmbc\00", align 1
@.str.11 = private unnamed_addr constant [11 x i8] c"..\5Ct_fvmbc\00", align 1
@.str.12 = private unnamed_addr constant [42 x i8] c"cmd /c if not exist t_fvmbc mkdir t_fvmbc\00", align 1
@.str.13 = private unnamed_addr constant [24 x i8] c"t_stdin_interactive.tmp\00", align 1
@.str.14 = private unnamed_addr constant [46 x i8] c"Ana\0A30\0A9.99\0Atrue\0AA\0A2+3i\0A2026-08-28T12:00:00Z\0A\00", align 1
@.str.15 = private unnamed_addr constant [21 x i8] c"t_stdin_contract.tmp\00", align 1
@.str.16 = private unnamed_addr constant [12 x i8] c"andre\0Aluiz\0A\00", align 1
@.str.17 = private unnamed_addr constant [17 x i8] c"t_stdin_dado.tmp\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"dado\0A\00", align 1
@.str.19 = private unnamed_addr constant [18 x i8] c"t_stdin_empty.tmp\00", align 1
@.str.20 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.21 = private unnamed_addr constant [19 x i8] c"cmd /c dir /b /on \00", align 1
@.str.22 = private unnamed_addr constant [28 x i8] c"\5C*.fvmbc > t_fvmbc_list.tmp\00", align 1
@.str.23 = private unnamed_addr constant [17 x i8] c"t_fvmbc_list.tmp\00", align 1
@.str.24 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"\0D\00", align 1
@.str.26 = private unnamed_addr constant [2 x i8] c"\5C\00", align 1
@.str.27 = private unnamed_addr constant [12 x i8] c"input.fvmbc\00", align 1
@.str.28 = private unnamed_addr constant [11 x i8] c"input.flux\00", align 1
@.str.29 = private unnamed_addr constant [21 x i8] c"ExampleOfInput.fvmbc\00", align 1
@.str.30 = private unnamed_addr constant [20 x i8] c"ExampleOfInput.flux\00", align 1
@.str.31 = private unnamed_addr constant [43 x i8] c"ExampleOfUseIoStdLib_IoInputContract.fvmbc\00", align 1
@.str.32 = private unnamed_addr constant [42 x i8] c"ExampleOfUseIoStdLib_IoInputContract.flux\00", align 1
@.str.33 = private unnamed_addr constant [26 x i8] c"cmd /c \22set FLUX_CI=1 && \00", align 1
@.str.34 = private unnamed_addr constant [15 x i8] c" --target vmr \00", align 1
@.str.35 = private unnamed_addr constant [4 x i8] c" < \00", align 1
@.str.36 = private unnamed_addr constant [19 x i8] c" > t_vmr.tmp 2>&1\22\00", align 1
@.str.37 = private unnamed_addr constant [10 x i8] c"t_vmr.tmp\00", align 1
@.str.38 = private unnamed_addr constant [5 x i8] c"  | \00", align 1
@.str.39 = private unnamed_addr constant [7 x i8] c"  OK  \00", align 1
@.str.40 = private unnamed_addr constant [17 x i8] c"Sem erro emitido\00", align 1
@.str.41 = private unnamed_addr constant [8 x i8] c"FALHA  \00", align 1
@.str.42 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.43 = private unnamed_addr constant [64 x i8] c"cmd /c del /q /f t_stdin_*.tmp t_vmr.tmp t_fvmbc_list.tmp 2>nul\00", align 1
@.str.44 = private unnamed_addr constant [11 x i8] c" sucesso, \00", align 1
@.str.45 = private unnamed_addr constant [10 x i8] c" falha(s)\00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @flux_runtime_init_args(i32 %argc, i8** %argv)
  %fluxc_bin = alloca i64, align 8
  %fvmbc_dir = alloca i64, align 8
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
  %cmd_vmr = alloca i64, align 8
  %rc = alloca i64, align 8
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
  %t21 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.10, i32 0, i32 0
  %st_7 = ptrtoint i8* %t21 to i64
  store i64 %st_7, i64* %fvmbc_dir, align 8
  %t24 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.10, i32 0, i32 0
  %t25_i64 = call i64 @flux_std_io_file_exists(i8* %t24)
  %t25 = trunc i64 %t25_i64 to i1
  br i1 %t25, label %ft_4, label %route_arm_23
ft_4:
  %t26 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.10, i32 0, i32 0
  %st_8 = ptrtoint i8* %t26 to i64
  store i64 %st_8, i64* %fvmbc_dir, align 8
  br label %route_end_22
route_arm_23:
  %t28 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.11, i32 0, i32 0
  %t29_i64 = call i64 @flux_std_io_file_exists(i8* %t28)
  %t29 = trunc i64 %t29_i64 to i1
  br i1 %t29, label %ft_5, label %route_arm_27
ft_5:
  %t30 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.11, i32 0, i32 0
  %st_9 = ptrtoint i8* %t30 to i64
  store i64 %st_9, i64* %fvmbc_dir, align 8
  br label %route_end_22
route_arm_27:
  %t32 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.12, i32 0, i32 0
  %t33 = call i64 @flux_std_os_exec(i8* %t32)
  %t34 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.10, i32 0, i32 0
  %st_10 = ptrtoint i8* %t34 to i64
  store i64 %st_10, i64* %fvmbc_dir, align 8
  br label %route_end_22
route_end_22:
  %t35 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.13, i32 0, i32 0
  %t36 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.14, i32 0, i32 0
  %t37 = call i64 @flux_std_io_write_file(i8* %t35, i8* %t36)
  %t38 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.15, i32 0, i32 0
  %t39 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.16, i32 0, i32 0
  %t40 = call i64 @flux_std_io_write_file(i8* %t38, i8* %t39)
  %t41 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.17, i32 0, i32 0
  %t42 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.18, i32 0, i32 0
  %t43 = call i64 @flux_std_io_write_file(i8* %t41, i8* %t42)
  %t44 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.19, i32 0, i32 0
  %t45 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t46 = call i64 @flux_std_io_write_file(i8* %t44, i8* %t45)
  %t47 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.21, i32 0, i32 0
  %t48_i64 = load i64, i64* %fvmbc_dir, align 8
  %t48 = inttoptr i64 %t48_i64 to i8*
  %t49 = call i8* @flux_str_concat(i8* %t47, i8* %t48)
  %t50 = getelementptr inbounds [28 x i8], [28 x i8]* @.str.22, i32 0, i32 0
  %t51 = call i8* @flux_str_concat(i8* %t49, i8* %t50)
  %t52 = call i64 @flux_std_os_exec(i8* %t51)
  %t53 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.23, i32 0, i32 0
  %t54 = call i8* @flux_std_io_read_file(i8* %t53)
  %st_11 = ptrtoint i8* %t54 to i64
  store i64 %st_11, i64* %list_content, align 8
  %t55_i64 = load i64, i64* %list_content, align 8
  %t55 = inttoptr i64 %t55_i64 to i8*
  %t56 = call i64 @flux_str_len(i8* %t55)
  store i64 %t56, i64* %lclen, align 8
  %t59 = load i64, i64* %lclen, align 8
  %t60 = add i64 0, 0
  %t61 = icmp sgt i64 %t59, %t60
  %t62_i64 = load i64, i64* %list_content, align 8
  %t62 = inttoptr i64 %t62_i64 to i8*
  %t63 = load i64, i64* %lclen, align 8
  %t64 = load i64, i64* %lclen, align 8
  %t65 = call i8* @flux_str_slice(i8* %t62, i64 %t63, i64 %t64)
  %t66 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.24, i32 0, i32 0
  %t67_cmp = call i32 @flux_str_compare(i8* %t65, i8* %t66)
  %t67 = icmp ne i32 %t67_cmp, 0
  %t68 = and i1 %t61, %t67
  br i1 %t68, label %ft_6, label %route_arm_58
ft_6:
  %t69_i64 = load i64, i64* %list_content, align 8
  %t69 = inttoptr i64 %t69_i64 to i8*
  %t70 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.24, i32 0, i32 0
  %t71 = call i8* @flux_str_concat(i8* %t69, i8* %t70)
  %st_13 = ptrtoint i8* %t71 to i64
  store i64 %st_13, i64* %list_content, align 8
  %t72 = load i64, i64* %lclen, align 8
  %t73 = add i64 0, 1
  %t74 = add i64 %t72, %t73
  store i64 %t74, i64* %lclen, align 8
  br label %route_end_57
route_arm_58:
  br label %route_end_57
route_end_57:
  %t76 = add i64 0, 0
  store i64 %t76, i64* %acertos, align 8
  %t77 = add i64 0, 0
  store i64 %t77, i64* %erros, align 8
  %t78 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_17 = ptrtoint i8* %t78 to i64
  store i64 %st_17, i64* %cur_fname, align 8
  %t79 = add i64 0, 1
  store i64 %t79, i64* %li, align 8
  br label %loop_start_80
loop_start_80:
  %t83 = load i64, i64* %li, align 8
  %t84 = load i64, i64* %lclen, align 8
  %t85 = icmp sgt i64 %t83, %t84
  br i1 %t85, label %ft_7, label %route_arm_82
ft_7:
  br label %loop_end_80
route_arm_82:
  %t87_i64 = load i64, i64* %list_content, align 8
  %t87 = inttoptr i64 %t87_i64 to i8*
  %t88 = load i64, i64* %li, align 8
  %t89 = load i64, i64* %li, align 8
  %t90 = call i8* @flux_str_slice(i8* %t87, i64 %t88, i64 %t89)
  %st_19 = ptrtoint i8* %t90 to i64
  store i64 %st_19, i64* %ch, align 8
  %t93_i64 = load i64, i64* %ch, align 8
  %t93 = inttoptr i64 %t93_i64 to i8*
  %t94 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.25, i32 0, i32 0
  %t95_cmp = call i32 @flux_str_compare(i8* %t93, i8* %t94)
  %t95 = icmp eq i32 %t95_cmp, 0
  br i1 %t95, label %ft_8, label %route_arm_92
ft_8:
  br label %route_end_91
route_arm_92:
  %t97_i64 = load i64, i64* %ch, align 8
  %t97 = inttoptr i64 %t97_i64 to i8*
  %t98 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.24, i32 0, i32 0
  %t99_cmp = call i32 @flux_str_compare(i8* %t97, i8* %t98)
  %t99 = icmp eq i32 %t99_cmp, 0
  br i1 %t99, label %ft_9, label %route_arm_96
ft_9:
  %t102_i64 = load i64, i64* %cur_fname, align 8
  %t102 = inttoptr i64 %t102_i64 to i8*
  %t103 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t104_cmp = call i32 @flux_str_compare(i8* %t102, i8* %t103)
  %t104 = icmp ne i32 %t104_cmp, 0
  br i1 %t104, label %ft_10, label %route_arm_101
ft_10:
  %t105_i64 = load i64, i64* %cur_fname, align 8
  %t105 = inttoptr i64 %t105_i64 to i8*
  %st_20 = ptrtoint i8* %t105 to i64
  store i64 %st_20, i64* %nome, align 8
  %t106_i64 = load i64, i64* %fvmbc_dir, align 8
  %t106 = inttoptr i64 %t106_i64 to i8*
  %t107 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.26, i32 0, i32 0
  %t108 = call i8* @flux_str_concat(i8* %t106, i8* %t107)
  %t109_i64 = load i64, i64* %nome, align 8
  %t109 = inttoptr i64 %t109_i64 to i8*
  %t110 = call i8* @flux_str_concat(i8* %t108, i8* %t109)
  %st_21 = ptrtoint i8* %t110 to i64
  store i64 %st_21, i64* %filepath, align 8
  %t111 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.19, i32 0, i32 0
  %st_22 = ptrtoint i8* %t111 to i64
  store i64 %st_22, i64* %stdin_file, align 8
  %t114_i64 = load i64, i64* %nome, align 8
  %t114 = inttoptr i64 %t114_i64 to i8*
  %t115 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.27, i32 0, i32 0
  %t116_cmp = call i32 @flux_str_compare(i8* %t114, i8* %t115)
  %t116 = icmp eq i32 %t116_cmp, 0
  %t117_i64 = load i64, i64* %nome, align 8
  %t117 = inttoptr i64 %t117_i64 to i8*
  %t118 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.28, i32 0, i32 0
  %t119_cmp = call i32 @flux_str_compare(i8* %t117, i8* %t118)
  %t119 = icmp eq i32 %t119_cmp, 0
  %t120 = or i1 %t116, %t119
  br i1 %t120, label %ft_11, label %route_arm_113
ft_11:
  %t121 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.17, i32 0, i32 0
  %st_23 = ptrtoint i8* %t121 to i64
  store i64 %st_23, i64* %stdin_file, align 8
  br label %route_end_112
route_arm_113:
  %t123_i64 = load i64, i64* %nome, align 8
  %t123 = inttoptr i64 %t123_i64 to i8*
  %t124 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.29, i32 0, i32 0
  %t125_cmp = call i32 @flux_str_compare(i8* %t123, i8* %t124)
  %t125 = icmp eq i32 %t125_cmp, 0
  %t126_i64 = load i64, i64* %nome, align 8
  %t126 = inttoptr i64 %t126_i64 to i8*
  %t127 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.30, i32 0, i32 0
  %t128_cmp = call i32 @flux_str_compare(i8* %t126, i8* %t127)
  %t128 = icmp eq i32 %t128_cmp, 0
  %t129 = or i1 %t125, %t128
  br i1 %t129, label %ft_12, label %route_arm_122
ft_12:
  %t130 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.13, i32 0, i32 0
  %st_24 = ptrtoint i8* %t130 to i64
  store i64 %st_24, i64* %stdin_file, align 8
  br label %route_end_112
route_arm_122:
  %t132_i64 = load i64, i64* %nome, align 8
  %t132 = inttoptr i64 %t132_i64 to i8*
  %t133 = getelementptr inbounds [43 x i8], [43 x i8]* @.str.31, i32 0, i32 0
  %t134_cmp = call i32 @flux_str_compare(i8* %t132, i8* %t133)
  %t134 = icmp eq i32 %t134_cmp, 0
  %t135_i64 = load i64, i64* %nome, align 8
  %t135 = inttoptr i64 %t135_i64 to i8*
  %t136 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.32, i32 0, i32 0
  %t137_cmp = call i32 @flux_str_compare(i8* %t135, i8* %t136)
  %t137 = icmp eq i32 %t137_cmp, 0
  %t138 = or i1 %t134, %t137
  br i1 %t138, label %ft_13, label %route_arm_131
ft_13:
  %t139 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.15, i32 0, i32 0
  %st_25 = ptrtoint i8* %t139 to i64
  store i64 %st_25, i64* %stdin_file, align 8
  br label %route_end_112
route_arm_131:
  br label %route_end_112
route_end_112:
  %t141 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.33, i32 0, i32 0
  %t142_i64 = load i64, i64* %fluxc_bin, align 8
  %t142 = inttoptr i64 %t142_i64 to i8*
  %t143 = call i8* @flux_str_concat(i8* %t141, i8* %t142)
  %t144 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.34, i32 0, i32 0
  %t145 = call i8* @flux_str_concat(i8* %t143, i8* %t144)
  %t146_i64 = load i64, i64* %filepath, align 8
  %t146 = inttoptr i64 %t146_i64 to i8*
  %t147 = call i8* @flux_str_concat(i8* %t145, i8* %t146)
  %t148 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.35, i32 0, i32 0
  %t149 = call i8* @flux_str_concat(i8* %t147, i8* %t148)
  %t150_i64 = load i64, i64* %stdin_file, align 8
  %t150 = inttoptr i64 %t150_i64 to i8*
  %t151 = call i8* @flux_str_concat(i8* %t149, i8* %t150)
  %t152 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.36, i32 0, i32 0
  %t153 = call i8* @flux_str_concat(i8* %t151, i8* %t152)
  %st_26 = ptrtoint i8* %t153 to i64
  store i64 %st_26, i64* %cmd_vmr, align 8
  %t154_i64 = load i64, i64* %cmd_vmr, align 8
  %t154 = inttoptr i64 %t154_i64 to i8*
  %t155 = call i64 @flux_std_os_exec(i8* %t154)
  store i64 %t155, i64* %rc, align 8
  %t156 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.37, i32 0, i32 0
  %t157 = call i8* @flux_std_io_read_file(i8* %t156)
  %st_28 = ptrtoint i8* %t157 to i64
  store i64 %st_28, i64* %out_full, align 8
  %t158_i64 = load i64, i64* %out_full, align 8
  %t158 = inttoptr i64 %t158_i64 to i8*
  %t159 = call i64 @flux_str_len(i8* %t158)
  store i64 %t159, i64* %out_len, align 8
  %t162 = load i64, i64* %rc, align 8
  %t163 = add i64 0, 0
  %t164 = icmp eq i64 %t162, %t163
  br i1 %t164, label %ft_14, label %route_arm_161
ft_14:
  %t165 = load i64, i64* %acertos, align 8
  %t166 = add i64 0, 1
  %t167 = add i64 %t165, %t166
  store i64 %t167, i64* %acertos, align 8
  %t168 = add i64 0, 1
  store i64 %t168, i64* %ci, align 8
  %t169 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_32 = ptrtoint i8* %t169 to i64
  store i64 %st_32, i64* %cur_chunk, align 8
  br label %loop_start_170
loop_start_170:
  %t173 = load i64, i64* %ci, align 8
  %t174 = load i64, i64* %out_len, align 8
  %t175 = icmp sgt i64 %t173, %t174
  br i1 %t175, label %ft_15, label %route_arm_172
ft_15:
  br label %loop_end_170
route_arm_172:
  %t177_i64 = load i64, i64* %out_full, align 8
  %t177 = inttoptr i64 %t177_i64 to i8*
  %t178 = load i64, i64* %ci, align 8
  %t179 = load i64, i64* %ci, align 8
  %t180 = call i8* @flux_str_slice(i8* %t177, i64 %t178, i64 %t179)
  %st_33 = ptrtoint i8* %t180 to i64
  store i64 %st_33, i64* %ch_o, align 8
  %t183_i64 = load i64, i64* %ch_o, align 8
  %t183 = inttoptr i64 %t183_i64 to i8*
  %t184 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.25, i32 0, i32 0
  %t185_cmp = call i32 @flux_str_compare(i8* %t183, i8* %t184)
  %t185 = icmp eq i32 %t185_cmp, 0
  br i1 %t185, label %ft_16, label %route_arm_182
ft_16:
  br label %route_end_181
route_arm_182:
  %t187_i64 = load i64, i64* %ch_o, align 8
  %t187 = inttoptr i64 %t187_i64 to i8*
  %t188 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.24, i32 0, i32 0
  %t189_cmp = call i32 @flux_str_compare(i8* %t187, i8* %t188)
  %t189 = icmp eq i32 %t189_cmp, 0
  br i1 %t189, label %ft_17, label %route_arm_186
ft_17:
  %t190 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.38, i32 0, i32 0
  %t191_i64 = load i64, i64* %cur_chunk, align 8
  %t191 = inttoptr i64 %t191_i64 to i8*
  %t192 = call i8* @flux_str_concat(i8* %t190, i8* %t191)
  %pr_sn_1 = icmp eq i8* %t192, null
  %pr_sc_1 = select i1 %pr_sn_1, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t192
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_1)
  call i32 @fflush(i8* null)
  %t193 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_34 = ptrtoint i8* %t193 to i64
  store i64 %st_34, i64* %cur_chunk, align 8
  br label %route_end_181
route_arm_186:
  %t195_i64 = load i64, i64* %cur_chunk, align 8
  %t195 = inttoptr i64 %t195_i64 to i8*
  %t196_i64 = load i64, i64* %ch_o, align 8
  %t196 = inttoptr i64 %t196_i64 to i8*
  %t197 = call i8* @flux_str_concat(i8* %t195, i8* %t196)
  %st_35 = ptrtoint i8* %t197 to i64
  store i64 %st_35, i64* %cur_chunk, align 8
  br label %route_end_181
route_end_181:
  %t198 = load i64, i64* %ci, align 8
  %t199 = add i64 0, 1
  %t200 = add i64 %t198, %t199
  store i64 %t200, i64* %ci, align 8
  br label %route_end_171
route_end_171:
  br label %loop_start_170
loop_end_170:
  %t203_i64 = load i64, i64* %cur_chunk, align 8
  %t203 = inttoptr i64 %t203_i64 to i8*
  %t204 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t205_cmp = call i32 @flux_str_compare(i8* %t203, i8* %t204)
  %t205 = icmp ne i32 %t205_cmp, 0
  br i1 %t205, label %ft_18, label %route_arm_202
ft_18:
  %t206 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.38, i32 0, i32 0
  %t207_i64 = load i64, i64* %cur_chunk, align 8
  %t207 = inttoptr i64 %t207_i64 to i8*
  %t208 = call i8* @flux_str_concat(i8* %t206, i8* %t207)
  %pr_sn_2 = icmp eq i8* %t208, null
  %pr_sc_2 = select i1 %pr_sn_2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t208
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_2)
  call i32 @fflush(i8* null)
  br label %route_end_201
route_arm_202:
  br label %route_end_201
route_end_201:
  %t210 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.39, i32 0, i32 0
  %t211_i64 = load i64, i64* %nome, align 8
  %t211 = inttoptr i64 %t211_i64 to i8*
  %t212 = call i8* @flux_str_concat(i8* %t210, i8* %t211)
  %pr_sn_3 = icmp eq i8* %t212, null
  %pr_sc_3 = select i1 %pr_sn_3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t212
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_3)
  call i32 @fflush(i8* null)
  br label %route_end_160
route_arm_161:
  %t214 = load i64, i64* %erros, align 8
  %t215 = add i64 0, 1
  %t216 = add i64 %t214, %t215
  store i64 %t216, i64* %erros, align 8
  %t217 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_38 = ptrtoint i8* %t217 to i64
  store i64 %st_38, i64* %last_line, align 8
  %t218 = add i64 0, 1
  store i64 %t218, i64* %ci, align 8
  %t219 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_40 = ptrtoint i8* %t219 to i64
  store i64 %st_40, i64* %cur_chunk, align 8
  br label %loop_start_220
loop_start_220:
  %t223 = load i64, i64* %ci, align 8
  %t224 = load i64, i64* %out_len, align 8
  %t225 = icmp sgt i64 %t223, %t224
  br i1 %t225, label %ft_19, label %route_arm_222
ft_19:
  br label %loop_end_220
route_arm_222:
  %t227_i64 = load i64, i64* %out_full, align 8
  %t227 = inttoptr i64 %t227_i64 to i8*
  %t228 = load i64, i64* %ci, align 8
  %t229 = load i64, i64* %ci, align 8
  %t230 = call i8* @flux_str_slice(i8* %t227, i64 %t228, i64 %t229)
  %st_41 = ptrtoint i8* %t230 to i64
  store i64 %st_41, i64* %ch_o, align 8
  %t233_i64 = load i64, i64* %ch_o, align 8
  %t233 = inttoptr i64 %t233_i64 to i8*
  %t234 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.25, i32 0, i32 0
  %t235_cmp = call i32 @flux_str_compare(i8* %t233, i8* %t234)
  %t235 = icmp eq i32 %t235_cmp, 0
  br i1 %t235, label %ft_20, label %route_arm_232
ft_20:
  br label %route_end_231
route_arm_232:
  %t237_i64 = load i64, i64* %ch_o, align 8
  %t237 = inttoptr i64 %t237_i64 to i8*
  %t238 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.24, i32 0, i32 0
  %t239_cmp = call i32 @flux_str_compare(i8* %t237, i8* %t238)
  %t239 = icmp eq i32 %t239_cmp, 0
  br i1 %t239, label %ft_21, label %route_arm_236
ft_21:
  %t242_i64 = load i64, i64* %cur_chunk, align 8
  %t242 = inttoptr i64 %t242_i64 to i8*
  %t243 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t244_cmp = call i32 @flux_str_compare(i8* %t242, i8* %t243)
  %t244 = icmp ne i32 %t244_cmp, 0
  br i1 %t244, label %ft_22, label %route_arm_241
ft_22:
  %t245_i64 = load i64, i64* %cur_chunk, align 8
  %t245 = inttoptr i64 %t245_i64 to i8*
  %st_42 = ptrtoint i8* %t245 to i64
  store i64 %st_42, i64* %last_line, align 8
  br label %route_end_240
route_arm_241:
  br label %route_end_240
route_end_240:
  %t247 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_43 = ptrtoint i8* %t247 to i64
  store i64 %st_43, i64* %cur_chunk, align 8
  br label %route_end_231
route_arm_236:
  %t249_i64 = load i64, i64* %cur_chunk, align 8
  %t249 = inttoptr i64 %t249_i64 to i8*
  %t250_i64 = load i64, i64* %ch_o, align 8
  %t250 = inttoptr i64 %t250_i64 to i8*
  %t251 = call i8* @flux_str_concat(i8* %t249, i8* %t250)
  %st_44 = ptrtoint i8* %t251 to i64
  store i64 %st_44, i64* %cur_chunk, align 8
  br label %route_end_231
route_end_231:
  %t252 = load i64, i64* %ci, align 8
  %t253 = add i64 0, 1
  %t254 = add i64 %t252, %t253
  store i64 %t254, i64* %ci, align 8
  br label %route_end_221
route_end_221:
  br label %loop_start_220
loop_end_220:
  %t257_i64 = load i64, i64* %cur_chunk, align 8
  %t257 = inttoptr i64 %t257_i64 to i8*
  %t258 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t259_cmp = call i32 @flux_str_compare(i8* %t257, i8* %t258)
  %t259 = icmp ne i32 %t259_cmp, 0
  br i1 %t259, label %ft_23, label %route_arm_256
ft_23:
  %t260_i64 = load i64, i64* %cur_chunk, align 8
  %t260 = inttoptr i64 %t260_i64 to i8*
  %st_46 = ptrtoint i8* %t260 to i64
  store i64 %st_46, i64* %last_line, align 8
  br label %route_end_255
route_arm_256:
  br label %route_end_255
route_end_255:
  %t264_i64 = load i64, i64* %last_line, align 8
  %t264 = inttoptr i64 %t264_i64 to i8*
  %t265 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t266_cmp = call i32 @flux_str_compare(i8* %t264, i8* %t265)
  %t266 = icmp eq i32 %t266_cmp, 0
  br i1 %t266, label %ft_24, label %route_arm_263
ft_24:
  %t267 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.40, i32 0, i32 0
  %st_47 = ptrtoint i8* %t267 to i64
  store i64 %st_47, i64* %last_line, align 8
  br label %route_end_262
route_arm_263:
  br label %route_end_262
route_end_262:
  %t269 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.41, i32 0, i32 0
  %t270_i64 = load i64, i64* %nome, align 8
  %t270 = inttoptr i64 %t270_i64 to i8*
  %t271 = call i8* @flux_str_concat(i8* %t269, i8* %t270)
  %t272 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.42, i32 0, i32 0
  %t273 = call i8* @flux_str_concat(i8* %t271, i8* %t272)
  %t274_i64 = load i64, i64* %last_line, align 8
  %t274 = inttoptr i64 %t274_i64 to i8*
  %t275 = call i8* @flux_str_concat(i8* %t273, i8* %t274)
  %pr_sn_4 = icmp eq i8* %t275, null
  %pr_sc_4 = select i1 %pr_sn_4, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t275
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_4)
  call i32 @fflush(i8* null)
  br label %route_end_160
route_end_160:
  br label %route_end_100
route_arm_101:
  br label %route_end_100
route_end_100:
  %t277 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %st_48 = ptrtoint i8* %t277 to i64
  store i64 %st_48, i64* %cur_fname, align 8
  br label %route_end_91
route_arm_96:
  %t279_i64 = load i64, i64* %cur_fname, align 8
  %t279 = inttoptr i64 %t279_i64 to i8*
  %t280_i64 = load i64, i64* %ch, align 8
  %t280 = inttoptr i64 %t280_i64 to i8*
  %t281 = call i8* @flux_str_concat(i8* %t279, i8* %t280)
  %st_49 = ptrtoint i8* %t281 to i64
  store i64 %st_49, i64* %cur_fname, align 8
  br label %route_end_91
route_end_91:
  %t282 = load i64, i64* %li, align 8
  %t283 = add i64 0, 1
  %t284 = add i64 %t282, %t283
  store i64 %t284, i64* %li, align 8
  br label %route_end_81
route_end_81:
  br label %loop_start_80
loop_end_80:
  %t285 = getelementptr inbounds [64 x i8], [64 x i8]* @.str.43, i32 0, i32 0
  %t286 = call i64 @flux_std_os_exec(i8* %t285)
  %t287 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %pr_sn_5 = icmp eq i8* %t287, null
  %pr_sc_5 = select i1 %pr_sn_5, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t287
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_5)
  call i32 @fflush(i8* null)
  %t288 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.20, i32 0, i32 0
  %t289 = load i64, i64* %acertos, align 8
  %cv_buf_1 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_1, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t289)
  %t290 = call i8* @flux_str_concat(i8* %t288, i8* %cv_buf_1)
  %t291 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.44, i32 0, i32 0
  %t292 = call i8* @flux_str_concat(i8* %t290, i8* %t291)
  %t293 = load i64, i64* %erros, align 8
  %cv_buf_2 = call i8* @malloc(i64 32)
  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_2, i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 %t293)
  %t294 = call i8* @flux_str_concat(i8* %t292, i8* %cv_buf_2)
  %t295 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.45, i32 0, i32 0
  %t296 = call i8* @flux_str_concat(i8* %t294, i8* %t295)
  %pr_sn_6 = icmp eq i8* %t296, null
  %pr_sc_6 = select i1 %pr_sn_6, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0), i8* %t296
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_str, i32 0, i32 0), i8* %pr_sc_6)
  call i32 @fflush(i8* null)
  %t299 = load i64, i64* %erros, align 8
  %t300 = add i64 0, 0
  %t301 = icmp eq i64 %t299, %t300
  br i1 %t301, label %ft_25, label %route_arm_298
ft_25:
  %t302 = add i64 0, 0
  %t303 = call i64 @flux_std_os_exit(i64 %t302)
  br label %route_end_297
route_arm_298:
  %t305 = add i64 0, 1
  %t306 = call i64 @flux_std_os_exit(i64 %t305)
  br label %route_end_297
route_end_297:
  ret i32 0
}
