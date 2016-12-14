; Christopher Huynh - chphuynh
; Lab 3: Decimal Converter - Due: Oct. 22
; Lab section: TuTh 2pm-4pm - TA: Chandrahas

		.ORIG x3000
	
		LEA R0, WELCOME 	;Prints Welcome message
		PUTS
	
START		LEA R0, ENTER		;Prints Enter message
		PUTS
	
					;Clears all registers
		AND R0, R0, #0		;R0 holds input
		AND R1, R1, #0		;R1 holds int
		AND R2, R2, #0		;R2 holds multiply counter
		AND R3, R3, #0		;R3 holds Flag
		AND R4, R4, #0		;R4 holds mask counter
		AND R5, R5, #0		;R5 holds temp variable
		AND R6, R6, #0		;R6 holds temp variable
		AND R7, R7, #0		;R7 holds temp variable
		ST R0, INT		;Sets INT to 0, INT holds backup int
		BR INLOOP

INLOOP		GETC			;Input character into R0
		OUT			;Print input onto screen
		BR CHECKLF

CHECKLF		AND R6, R6, #0		;Clears registers
		AND R5, R5, #0
		ADD R5, R5, #-10	;Checks if input is ASCII for newline	
		ADD R6, R0, R5
		BRz CHECKFLAG

CHECKNEG	AND R5, R5, #0		;Clears registers
		ADD R5, R5, #-15	;Set R5 to #45 which is ASCII for '-'
		ADD R5, R5, #-15
		ADD R5, R5, #-15
		AND R6, R6, #0
		ADD R6, R0, R5		;Check if input is '-'
		BRz FLAG

CHECKX		AND R5, R5, #0		;Reset register
		ADD R5, R5, #-16	;Add 88 for ASCII of 'X'
		ADD R5, R5, #-16
		ADD R5, R5, #-16
		ADD R5, R5, #-16
		ADD R5, R5, #-16
		ADD R5, R5, #-8
		AND R6, R6, #0
		ADD R6, R0, R5		;Check if input is 'X'
		BRz GOODBYE		;End program

SETUPINPUT	ADD R0, R0, #-16	;Subtract 48 from input
		ADD R0, R0, #-16	;Gets real number of digit
		ADD R0, R0, #-16
		AND R2, R2, #0
		LD R1, INT		:Load current INT from memory
		AND R5, R5, #0
		BR MULTIPLY

MULTIPLY	ADD R2, R2, #1		;Add to counter
		ADD R5, R5, R1		;Add INT to register, this simmulates multiplying
		AND R6, R6, #0
		ADD R6, R6, #-10	;Check if loop ran 10 times
		AND R7, R7, #0
		ADD R7, R6, R2		 
		BRnp MULTIPLY		;If loop ran less than 10, loop
		BRz ADDINPUT		;else move to ADDINPUT

ADDINPUT	ADD R5, R5, R0		;Adds digit to INT x 10
		ST R5, INT		;Stores new value in INT
		BR INLOOP		;Return to input

FLAG		AND R3, R3, #0		;Set Flag to 1 even if FLAG label
		ADD R3, R3, #1		;is returned to multiple times
		BR INLOOP

CHECKFLAG	AND R5, R5, #0
		ADD R5, R5, #-1		;If flag is 1, invert INT
		ADD R5, R5, R3
		BRz INVERT

		AND R4, R4, #0		;Reset mask counter
		LD R1, INT		;Load INT into R1

SETUPMASK	AND R6, R6, #0		;Reset registers
		AND R7, R7, #0

MASKPTR		LEA R5, MASK		;Load address of Mask
		ADD R5, R5, R4		;Add counter to Mask to shift address pointer
		LDR R5, R5, 0		;Load value at address pointer
		AND R6, R6, #0
		AND R0, R0, #0
		AND R6, R1, R5		;SUM AND MASK
		BRz ZERO		;Print zero
		BRnp ONE		;Print one

ZERO		AND R0, R0, #0		;Reset register
		ADD R0, R0, #15		;Add 48 for ASCII '0'
		ADD R0, R0, #15
		ADD R0, R0, #15
		ADD R0, R0, #3
		OUT			;Print '0'
		BR MASKCOUNTER		;Increment counter

ONE		AND R0, R0, #0		;Reset register
		ADD R0, R0, #15		;Add 49 for ASCII '1'
		ADD R0, R0, #15
		ADD R0, R0, #15
		ADD R0, R0, #4
		OUT			;Print '1'
		BR MASKCOUNTER		;Increment counter

MASKCOUNTER	ADD R4, R4, #1		;Increment mask counter by 1
		AND R7, R7, #0
		ADD R7, R4, #-16	;Check if MASKPTR looped 16 times
		BRzp START		;If it did ask for input again
		BRn SETUPMASK		;Else loop MASKPTR

INVERT		LD R1, INT		;Load INT into R1
		NOT R1, R1		;Flip R1
		ADD R1, R1, #1		;Add 1
		ST R1, INT		;Store new value into INT
		BR SETUPMASK		;Begin MASK-ing

GOODBYE		LEA R0, BYE		;Load goodbye message
		PUTS			;Print goodbye message

		HALT

INT	.BLKW 16
WELCOME	.STRINGZ "Welcome to the conversion program"
ENTER	.STRINGZ "\nEnter a decimal number or X to quit:\n"
THANK	.STRINGZ "\nThanks, here it is in binary\n"
BYE	.STRINGZ "\nBye. Have a great day."

MASK	.FILL x8000
	.FILL x4000
	.FILL x2000
	.FILL x1000
	.FILL x0800
	.FILL x0400
	.FILL x0200
	.FILL x0100
	.FILL x0080
	.FILL x0040
	.FILL x0020
	.FILL x0010
	.FILL x0008
	.FILL x0004
	.FILL x0002
	.FILL x0001

.END