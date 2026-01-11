/* 文件: src/user_app.S */

/* 放在自定义段中 */
.section .zhangsan, "ax"
.global user_entry

user_entry:
    /* 1. 发起系统调用 */
    li s7, 10   /* 系统调用号，与 trap.c 中对应 */
    ecall

    /* 2. 系统调用返回，a0 中存放班级号 (例如 1) */
    /* 显示结果：这里直接向 UART 数据寄存器写字符 */
    /* 将数字转换为 ASCII 码: '0' + a0 */
    li t0, 0x30
    add a0, a0, t0  /* 假设班级号 < 10 */
    
    /* UART 数据寄存器地址 (QEMU virt) */
    li t1, 0x10000000 
    sb a0, 0(t1)
    
    /* 打印换行 */
    li t2, 10
    sb t2, 0(t1)

    /* 死循环停止 */
loop:
    j loop