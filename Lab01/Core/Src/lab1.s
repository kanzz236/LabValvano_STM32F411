.syntax unified
.cpu cortex-m4
.thumb

.equ RCC_AHB1ENR_R, 0x40023830
.equ GPIOA_BASE   , 0x40020000
.equ GPIOA_MODER_R, 0x40020000
.equ GPIOA_IDR_R  , 0x40020010

.equ GPIOC_BASE   , 0x40020800
.equ GPIOC_MODER_R, 0x40020800
.equ GPIOC_ODR_R  , 0x40020814

.global Lab1
.text

Lab1:

    @ 1. Bat clock cho GPIOA va GPIOC
    LDR R1, =RCC_AHB1ENR_R
    LDR R0, [R1]
    ORR.w R0, R0, #0x05   @ 0101
    STR R0, [R1]

    NOP
    NOP
    NOP

    @ 2. Cau hinh input (PA0, PA1, PA2)
    LDR R1, =GPIOA_MODER_R
    LDR R0, [R1]
    BIC.w R0, R0, #0x3F
    STR R0, [R1]

    @ 3. Cau hinh output (PC13)
    LDR R1, =GPIOC_MODER_R
    LDR R0, [R1]
    BIC.w R0, R0, #(3 << 26)
    ORR.w R0, R0, #(1 << 26)
    STR R0, [R1]

loop:
    LDR R1, =GPIOA_IDR_R
    LDR R0, [R1]
    AND.w R0, R0, #0x07         @ 0111
    MOV R2, R0

    AND.w R3, R2, #0x01         @ lay Key0
    AND.w R4, R2, #0x02         @ lay Key1
    LSR R4, R4, #1              @ dich phai Key1 về bit 0
    AND.w R5, R2, #0x04         @ lay Key2
    LSR R5, R5, #2              @ dich phai Key2 về bit 0

    EOR R3, R3, R4              @ Key0 XOR Key1
    EOR R3, R3, R5              @ Key0 XOR Key1 XOR Key2

    LDR R1, =GPIOC_ODR_R
    LDR R0, [R1]
    BIC.w R0, R0, #(1 << 13)    @ clear bit 13
    LSL R3, R3, #13             @ dich trai 13 bit
    ORR.w R0, R0, R3
    STR R0, [R1]
    B   loop
