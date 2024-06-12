; List of hardware ports:
LCD_CONTROL .equ $00
LCD_DATA .equ $01
KEY_INPUT .equ $04
KEY_FLAG .equ $08
UART_DATA .equ $0c ;check it
UART_CONTROL_STATUS .equ $0d

; List of constants
BIT0 .equ $01
BIT1 .equ $02
BIT2 .equ $04
BIT3 .equ $08
BIT4 .equ $10
BIT5 .equ $20
BIT6 .equ $40
BIT7 .equ $80
CLEAR_DISPLAY .equ $01

; List of flag addresses
IS_BOOT_ON_BUTTON .equ $f000

; Main Program
	.org $0000
	ld sp,$ffff
	call delay_1s
	ld a, (IS_BOOT_ON_BUTTON)
	cp $11
	jp z, restart_on_button_main
	ld a, $11
	ld (IS_BOOT_ON_BUTTON),a
	call lcd_init
	ld hl,starting_message
	call message_to_lcd
	call delay_1s

	call show_welcome_page
	jp loop_main
restart_on_button_main:	
	call show_input_page
loop_main: jp loop_main
exit_main:	halt

; List of messages -- Kit mode
msg:	.db "Hello World!", $00
starting_message:		.db "Loading...",$00
welcome_message_upper:	.db "* Z80 EduBoard *",$00
welcome_message_lower:	.db "IGEE (ex INELEC)",$00
input_message_upper:	.db "Z80 >",$00
serial_mode_message_upper .db "Serial"
show_input_page:
	;This subroutine displays the "Z80 >" on LCD
	;Input: none
	;Output: none
	;Subroutine calls: message_to_lcd | instruction_to_lcd | 
	;Registers modified: none
	push af
	ld a, CLEAR_DISPLAY
	call instruction_to_lcd
	ld hl, input_message_upper
	call message_to_lcd
	pop af
	ret

delay_1s:	
	;This subroutine adds a delay of 1 second on 2.45MHz clock. 
  	;Input: none.
	;Output: none.
	;Subroutine calls: none.
	;Registers modified: none.
	push af
	push bc
	push de
	ld b,$08
delay_1s_outer:
	ld de,$2191
delay_1s_inner:
	dec de
	ld a,d
	or e
	jp nz,delay_1s_inner
	dec b
	jp nz,delay_1s_outer
	pop de
	pop bc
	pop af	
	ret

delay_ms:	
	;This subroutine adds a delay of 1ms * C.
  	;Input: number of milli-seconds delay in register C.
	;Output: none.
	;Subroutine calls: none.
	;Register modified: none.
	push af
	push bc
	push de
	ld e,$01
	ld b,$01
	ld a,$00
delay_ms_multiply:
	add a,e
	ld b,a
	dec c
	jp nz,delay_ms_multiply
delay_ms_outer:
	ld d,$6e
delay_ms_inner:
	dec d
	jp nz,delay_ms_inner
	dec b
	jp nz,delay_ms_outer
	pop de
	pop bc
	pop af
	ret

lcd_init:
	;This subroutine initialzes the lcd.
  	;Input: none.
	;Output: none.
	;Subroutine calls: delay_ms.
	;Registers modified: none;
	push af
	push bc
	push de
	push hl
	ld a,$38 ; funciton set
	call instruction_to_lcd
	ld a,$0f ; display on
	call instruction_to_lcd
	ld a,$06 ; entry-mode set
	call instruction_to_lcd
	ld a,$01 ; clear display
	call instruction_to_lcd
	pop hl
	pop de	
	pop bc
	pop af
	ret 

data_to_lcd:	;This subroutine sends data to lcd
		;Input: data in register A
		;Output: none
		;Subroutine calls: none
		;Registers modified: none
		push af
		push bc
		push de
		push hl
		call check_busy_flag		
		out (LCD_DATA),a
		pop hl
		pop de
		pop bc
		pop af
		ret

instruction_to_lcd:	;This subroutine sends control word to lcd
			;Input: control word in register A
			;Output: none
			;Subroutine calls: none
			;Registers modified: none
			push af
			call check_busy_flag
			out (LCD_CONTROL), a
			pop af
			ret

check_busy_flag:;This subroutine checks the LCD's busy flag
		;Input: none
		;Output: none
		;Subroutine calls: none
		;Registers modified: none
		push af
busy:		in a, (LCD_CONTROL)
		and BIT7
		cp BIT7
		jp z, busy
		pop af
		ret

show_welcome_page:	;This subroutine displays the welcome message "Z80 EduBoard v1.0\nSeyf El Islam Bennoune"
					;Input:
					;Output:
					;Subroutine calls:
					;Registers modified:
					push af	
					push hl
					ld a,CLEAR_DISPLAY
					call instruction_to_lcd
					ld a, %10000000 ;ddram=$00
					call instruction_to_lcd
					ld hl,welcome_message_upper
					call message_to_lcd
					ld a, %11000000 ;ddram=$40
					call instruction_to_lcd
					ld hl, welcome_message_lower
					call message_to_lcd
					pop hl
					pop af
					ret
					
message_to_lcd:	;This subroutine sends whole message to lcd
				;Input: message first letter address in register pair HL
				;Output: none
				;Subroutine calls: 
				;Registers modified: none
				push af
				push hl
loop_message_to_lcd:				ld a, (hl)
				cp $00
				jp z, skip_message_to_lcd
				call data_to_lcd
				inc hl
				jp loop_message_to_lcd
skip_message_to_lcd:	pop hl
						pop af	
						ret
multiply:	;This subroutine multiplies two 8-bit numbers.	
		;Input: multiplier in register B, multiplicand in register C.
		;Output: result in register A.
		;Subroutine calls: none.
		;Registers modified: register A;


hex_to_ascii:	;This subroutine converts a given hex number to its ascii code.	
		;Input: ...
		;Output: ...
		;Subroutine calls: ...
		;Registers modified: ...


hex_to_bcd:	;This subroutine converts a hex to its decimal representation.	
		;Input: ...
		;Output: ...
		;Subroutine calls: ...
		;Registers modified: ...

uart_init: 	;This subroutine initializes the intel 8251a usart
			;Input: ...
			;Output: ...
			;Subroutine calls: ...
			;Registers modified: ...
			
	.org $7fff
	.db $00
.end
