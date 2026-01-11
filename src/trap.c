/* 文件: src/trap.c */
#include "printk.h"
#include "asm/csr.h"

// 定义保存现场的结构体，与栈结构对应
struct pt_regs {
    unsigned long ra;
    unsigned long sp;
    unsigned long gp;
    unsigned long tp;
    unsigned long t0;
    unsigned long t1;
    unsigned long t2;
    unsigned long s0;
    unsigned long s1;
    unsigned long a0;
    unsigned long a1;
    unsigned long a2;
    unsigned long a3;
    unsigned long a4;
    unsigned long a5;
    unsigned long a6;
    unsigned long a7;
    unsigned long s2;
    unsigned long s3;
    unsigned long s4;
    unsigned long s5;
    unsigned long s6;
    unsigned long s7;
    unsigned long s8;
    unsigned long s9;
    unsigned long s10;
    unsigned long s11;
    unsigned long t3;
    unsigned long t4;
    unsigned long t5;
    unsigned long t6;
    unsigned long sepc;
    unsigned long sstatus;
};

void s_trap_handler(struct pt_regs *regs)
{
    unsigned long scause = read_csr(scause);

    // 判断是否为 User ECALL (异常号 8)
    if (scause == 8) {
        // 获取系统调用号，题目要求放在 s7 中
        unsigned long syscall_num = regs->s7;

        // 假设系统调用号为 10 (你可以自定义)
        if (syscall_num == 10) {
            printk("[Syscall] 学号: 2023307220918 姓名: Yuxianze\n"); // 请替换为你的信息
            
            // 设置返回值 a0 为班级号
            regs->a0 = 3; 

            // 系统调用返回后，PC 需要指向下一条指令 (+4字节)
            regs->sepc += 4;
        } else {
            printk("Unknown syscall: %d\n", syscall_num);
            while(1);
        }
    } else {
        printk("Unexpected trap scause: %lx\n", scause);
        while(1);
    }
}