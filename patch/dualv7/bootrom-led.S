#define LED_BASE 0x60040000
#define LED_DATA 0
#define LED_TRI 4
#define DELAY_CYCLES 12000000

.section .text.hang, "ax", @progbits
.globl _hang
_hang:
    j _led_main

.section .text.led, "ax", @progbits
.globl _led_main
_led_main:
    csrr a0, mhartid
    bnez a0, _hart_wait
    li t0, LED_BASE
    sw zero, LED_TRI(t0)
    li t1, 0

_led_loop:
    sw t1, LED_DATA(t0)
    addi t1, t1, 1
    andi t1, t1, 7
    li t2, DELAY_CYCLES

_delay_loop:
    addi t2, t2, -1
    bnez t2, _delay_loop
    j _led_loop

_hart_wait:
    wfi
    j _hart_wait
