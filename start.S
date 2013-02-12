.syntax unified
.thumb
.text

.global _start
.global Reset_Handler
.global Default_Handler

.extern __text_end__
.extern __data_beg__
.extern __data_end__
.extern __bss_beg__
.extern __bss_end__
.extern __ctors_start__
.extern __ctors_end__
.extern main

.macro IRQ handler
.word \handler
.weak \handler
.set \handler, Default_Handler
.endm

_start:
	.word __stack_end__
	.word Reset_Handler
	IRQ NMI_Handler
	IRQ HardFault_Handler
	IRQ MemManage_Handler
	IRQ BusFault_Handler
	IRQ UsageFault_Handler
	.word 0
	.word 0
	.word 0
	.word 0
	IRQ SVC_Handler
	IRQ DebugMon_Handler
	.word 0
	IRQ PendSV_Handler
	IRQ SysTick_Handler

	IRQ WWDG_IRQHandler
	IRQ PVD_IRQHandler
	IRQ TAMP_STAMP_IRQHandler
	IRQ RTC_WKUP_IRQHandler
	IRQ FLASH_IRQHandler
	IRQ RCC_IRQHandler
	IRQ EXTI0_IRQHandler
	IRQ EXTI1_IRQHandler
	IRQ EXTI2_IRQHandler
	IRQ EXTI3_IRQHandler
	IRQ DMA1_Stream0_IRQHandler
	IRQ DMA1_Stream1_IRQHandler
	IRQ DMA1_Stream2_IRQHandler
	IRQ DMA1_Stream3_IRQHandler
	IRQ DMA1_Stream4_IRQHandler
	IRQ DMA1_Stream5_IRQHandler
	IRQ DMA1_Stream6_IRQHandler
	IRQ ADC_IRQHandler


	.thumb_func
Default_Handler:
	bx lr


	.thumb_func
Reset_Handler:
copy_data:
	ldr r1, DATA_BEG
	ldr r2, TEXT_END
	ldr r3, DATA_END
	subs r3, r3, r1
	beq zero_bss
copy_data_loop:
	ldrb r4, [r2], #1
	strb r4, [r1], #1
	subs r3, r3, #1
	bgt copy_data_loop
zero_bss:
	ldr r1, BSS_ENG
	ldr r3, BSS_END
	subs r3, r3, r1
	beq call_ctors
	mov r2, #0
zero_bss_loop:
	strb r2, [r1], #1
	subs r3, r3, #1
	bgt zero_bss_loop
call_ctors:
	ldr r0, CTORS_BEG
	ldr r1, CTORS_END
	subs r1, r1, r0
	beq call_main
ctors_loop:
	ldr r2, [r0], #4
	push {r0, r1}
	blx r2
	pop {r0, r1}
	subs r1, r1, #4
	bgt ctors_loop
call_main:
	mov r0, #0
	mov r1, #0
	bl main


	/* main() should never return so this should never be reached.
	   If it is, do nothing. Processor should probbaly be put into sleep mode. */
	b

	.align 4
TEST_END:
	.word __text_end__
DATA_BEG:
	.word __data_beg__
DATA_END:
	.word __data_end__
BSS_BEG:
	.word __bss_beg__
BSS_END:
	.word __bss_end__
CTORS_BEG:
	.word __ctors_start__
CTORS_END:
	.word __ctors_end__

	.bss
	.align 4
__dso_handle:
	.word
	.global __dso_handle
	.weak __dso_handle



	.end