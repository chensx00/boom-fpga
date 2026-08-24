#define UART_BASE 0x60010000
#define UART_TX   4
#define UART_SR   8
#define SR_TX_FULL (1<<3)
#define LEDGPIO   0x60040000
#define DDRSTAT   0x60050000
#define MEM_BASE  0x80000000
#define TEST_WORDS 512
#define DELAY      4000000

.section .text.hang, "ax", @progbits
.globl _hang
_hang:
    j _uart_main

.section .text.led, "ax", @progbits
.globl _uart_main
_uart_main:
    csrr a0, mhartid
    bnez a0, _hart_wait
    la a0, banner
    call _puts
    la a0, uart_ok
    call _puts

    li s0, DDRSTAT
    lw s1, 0(s0)
    la a0, ddrstat_pre
    call _puts
    mv a0, s1
    call _hex32
    la a0, newline
    call _puts

    andi t0, s1, 1
    bnez t0, _mem_test
    la a0, wait_ddr
    call _puts
    li s2, 300

_poll_loop:
    li t2, DELAY
_poll_delay:
    addi t2, t2, -1
    bnez t2, _poll_delay
    la a0, newline
    call _puts
    lw s1, 0(s0)
    mv a0, s1
    call _hex32
    andi t0, s1, 1
    bnez t0, _mem_test
    addi s2, s2, -1
    bnez s2, _poll_loop
    la a0, timeout
    call _puts
    j _heartbeat

_mem_test:
    la a0, mem_start
    call _puts

pat_zero:
    la a0, str_pat0
    call _puts
    li a1, 0
    li a2, 0
    call _mem_pat64_d
    bnez a0, _test_fail
    la a0, str_pass
    call _puts

pat_ff:
    la a0, str_patff
    call _puts
    li a1, -1
    li a2, -1
    call _mem_pat64_d
    bnez a0, _test_fail
    la a0, str_pass
    call _puts

pat_55:
    la a0, str_pat55
    call _puts
    li a1, 0x55555555
    li a2, 0x55555555
    call _mem_pat64_d
    bnez a0, _test_fail
    la a0, str_pass
    call _puts

pat_aa:
    la a0, str_pataa
    call _puts
    li a1, 0xaaaaaaaa
    li a2, 0xaaaaaaaa
    call _mem_pat64_d
    bnez a0, _test_fail
    la a0, str_pass
    call _puts

pat_addr:
    la a0, str_patad
    call _puts
    li s6, 0
    li a7, TEST_WORDS
    li s9, MEM_BASE
_pat_ad_loop:
    slli a5, s6, 3
    add a5, s9, a5
    slli s8, s6, 3
    li t1, 0x5a5a5a5a5a5a5a5a
    xor s8, s8, t1
    sd s8, 0(a5)
    ld t4, 0(a5)
    bne s8, t4, _test_fail
    addi s6, s6, 1
    blt s6, a7, _pat_ad_loop
    la a0, str_pass
    call _puts

_mem_pass_final:
    la a0, mem_pass
    call _puts
    j _heartbeat

_test_fail:
    mv a1, s8
    mv a2, t4
    mv s5, a5
    la a0, str_fail
    call _puts
    la a0, str_addr
    call _puts
    mv a0, s5
    call _hex64
    la a0, str_exp
    call _puts
    mv a0, a1
    call _hex64
    la a0, str_act
    call _puts
    mv a0, a2
    call _hex64
    la a0, newline
    call _puts
    j _heartbeat

_heartbeat:
    li s3, 0
_beat_loop:
    addi s3, s3, 1
    li t2, DELAY
_beat_delay:
    addi t2, t2, -1
    bnez t2, _beat_delay
    andi t0, s3, 7
    li t1, LEDGPIO
    sw zero, 4(t1)
    sw t0, 0(t1)
    j _beat_loop

_hart_wait:
    wfi
    j _hart_wait

# _mem_pat64_d: a1=lo32, a2=hi32 -> 64-bit pattern
# Test all TEST_WORDS words. Returns a0=0 pass, a0=8 fail
_mem_pat64_d:
    mv t6, ra
    slli t0, a2, 32
    or s7, t0, a1
    li a6, 0
    li a7, TEST_WORDS
    li s9, MEM_BASE
_mp_wr:
    slli a5, a6, 3
    add a5, s9, a5
    sd s7, 0(a5)
    addi a6, a6, 1
    blt a6, a7, _mp_wr
    li a6, 0
_mp_rd:
    slli a5, a6, 3
    add a5, s9, a5
    ld a4, 0(a5)
    bne s7, a4, _mp_fail
    addi a6, a6, 1
    blt a6, a7, _mp_rd
    li a0, 0
    jr t6
_mp_fail:
    mv s5, a5
    mv s8, s7
    mv t4, a4
    li a0, 8
    jr t6

_puts:
    lbu t0, 0(a0)
    beqz t0, _puts_done
    addi a0, a0, 1
_tx_wait:
    li t1, UART_BASE
    lw t2, UART_SR(t1)
    andi t2, t2, SR_TX_FULL
    bnez t2, _tx_wait
    sb t0, UART_TX(t1)
    j _puts
_puts_done:
    ret

_hex32:
    mv t5, ra
    srli t0, a0, 28
    call _hex_nibble
    srli t0, a0, 24
    call _hex_nibble
    srli t0, a0, 20
    call _hex_nibble
    srli t0, a0, 16
    call _hex_nibble
    srli t0, a0, 12
    call _hex_nibble
    srli t0, a0, 8
    call _hex_nibble
    srli t0, a0, 4
    call _hex_nibble
    andi t0, a0, 0xf
    call _hex_nibble
    jr t5

_hex64:
    mv t6, ra
    srli t0, a0, 32
    call _hex32
    slli a0, a0, 32
    srli a0, a0, 32
    mv ra, t6
    j _hex32

_hex_nibble:
    andi t0, t0, 0xf
    addi t0, t0, 0x30
    li t3, 0x3a
    blt t0, t3, _hn_done
    addi t0, t0, 39
_hn_done:
    li t1, UART_BASE
_lhn_wait:
    lw t2, UART_SR(t1)
    andi t2, t2, SR_TX_FULL
    bnez t2, _lhn_wait
    sb t0, UART_TX(t1)
    ret

.section .rodata.str, "a", @progbits
.align 4
banner:      .asciz "\r\nDUALV7 022x UART+MEM\r\n"
uart_ok:     .asciz "UART OK\r\n"
ddrstat_pre: .asciz "DDRSTAT=0x"
newline:     .asciz "\r\n"
wait_ddr:    .asciz "WAIT DDR..."
timeout:     .asciz "DDR TIMEOUT\r\n"
mem_start:   .asciz "MEM TEST START\r\n"
str_pat0:    .asciz "PAT 0x00000000  "
str_patff:   .asciz "PAT 0xffffffff  "
str_pat55:   .asciz "PAT 0x55555555  "
str_pataa:   .asciz "PAT 0xaaaaaaaa  "
str_patad:   .asciz "PAT addr^0x5a5a "
str_pass:    .asciz "PASS\r\n"
str_fail:    .asciz "FAIL\r\n"
str_addr:    .asciz " ADDR=0x"
str_exp:     .asciz " EXP=0x"
str_act:     .asciz " ACT=0x"
mem_pass:    .asciz "MEM TEST PASS\r\n"
