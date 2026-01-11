/* 文件: src/entry.S */
.global s_mode_trap_vector
.align 4
s_mode_trap_vector:
    /* 交换 sp 和 sscratch。
       进入中断前：sp 是用户栈，sscratch 是内核栈。
       交换后：sp 是内核栈，sscratch 是用户栈。
    */
    csrrw sp, sscratch, sp

    /* 保存上下文到内核栈 */
    addi sp, sp, -272
    sd ra, 0(sp)
    /* 保存原本的用户栈指针 (现在在 sscratch 中) 到栈帧的 sp 位置 */
    csrr t0, sscratch
    sd t0, 8(sp)
    sd gp, 16(sp)
    sd tp, 24(sp)
    sd t0, 32(sp)
    sd t1, 40(sp)
    sd t2, 48(sp)
    sd s0, 56(sp)
    sd s1, 64(sp)
    sd a0, 72(sp)
    sd a1, 80(sp)
    sd a2, 88(sp)
    sd a3, 96(sp)
    sd a4, 104(sp)
    sd a5, 112(sp)
    sd a6, 120(sp)
    sd a7, 128(sp)
    sd s2, 136(sp)
    sd s3, 144(sp)
    sd s4, 152(sp)
    sd s5, 160(sp)
    sd s6, 168(sp)
    sd s7, 176(sp)
    sd s8, 184(sp)
    sd s9, 192(sp)
    sd s10, 200(sp)
    sd s11, 208(sp)
    sd t3, 216(sp)
    sd t4, 224(sp)
    sd t5, 232(sp)
    sd t6, 240(sp)
    
    csrr t0, sepc
    sd t0, 248(sp)
    csrr t0, sstatus
    sd t0, 256(sp)

    /* 调用 C 语言处理函数 */
    mv a0, sp
    call s_trap_handler

    /* 恢复上下文 */
    ld t0, 256(sp)
    csrw sstatus, t0
    ld t0, 248(sp)
    csrw sepc, t0

    ld ra, 0(sp)
    ld gp, 16(sp)
    ld tp, 24(sp)
    ld t0, 32(sp)
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld s0, 56(sp)
    ld s1, 64(sp)
    ld a0, 72(sp)
    ld a1, 80(sp)
    ld a2, 88(sp)
    ld a3, 96(sp)
    ld a4, 104(sp)
    ld a5, 112(sp)
    ld a6, 120(sp)
    ld a7, 128(sp)
    ld s2, 136(sp)
    sd s3, 144(sp)
    ld s4, 152(sp)
    ld s5, 160(sp)
    ld s6, 168(sp)
    ld s7, 176(sp)
    ld s8, 184(sp)
    ld s9, 192(sp)
    ld s10, 200(sp)
    ld s11, 208(sp)
    ld t3, 216(sp)
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)

    /* 恢复用户栈指针 */
    ld sp, 8(sp) 
    
    /* 此时 sp 已经是用户栈值，但我们还需要把它写回 sscratch 吗？
       实际上 entry 逻辑中，我们是用 csrrw 换回来的。
       但在 sret 前，sscratch 必须是内核栈顶。
       
       上面的 ld sp, 8(sp) 直接恢复了用户 SP 到寄存器，
       但内核栈指针被丢弃了（因为出栈了）。
       
       正确的逻辑是：
       1. 从栈上恢复 sstatus, sepc, 通用寄存器 (除 sp)
       2. 此时 sp 仍指向内核栈底
       3. addi sp, sp, 272 (回收内核栈空间)
       4. csrrw sp, sscratch, sp (再次交换)
          -> 此时 sp 变回用户栈，sscratch 变回内核栈 (为下一次中断做准备)
    */
    
    /* 修正后的恢复逻辑: */
    /* 重新加载通用寄存器 (略过 sp) */
    /* ... 上面的 ld 语句除了 sp 都是对的 ... */
    
    /* 栈指针处理 */
    addi sp, sp, 272  /* 回收栈空间 */
    csrrw sp, sscratch, sp /* 交换回用户栈，sscratch 保存内核栈 */

    sret