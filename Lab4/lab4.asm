; Christopher Huynh - chphuynh
; Lab 4: Caesar Cipher - Due: Nov. 5
; Lab section: TuTh 2pm-4pm - TA: Chandrahas

		.ORIG x3000
		
		LEA R0, WELCOME	;Prints Welcome Message
		PUTS

START		LEA R0, CHOICE	;Prints Choice Message
		PUTS

		AND R0, R0, #0	;Input
		AND R1, R1, #0	;Encrypt/Decrypt flag
		AND R2, R2, #0	;Multiply Counter
		AND R3, R3, #0	;Cipher Number
		AND R4, R4, #0	;Temp variiable
		AND R5, R5, #0  ;temp variable
		AND R6, R6, #0	;temp vairable
		AND R7, R7, #0	;temp variable

INPUTCHOICE	GETC		;Gets character input
		OUT
		
CHECKENCRYPT	LD R5, ECHAR	;Loads ASCII for 'E'
		AND R6, R6, #0	;Resets Temp
		ADD R6, R0, R5	;Compares input with 'E'
		BRz ENCRYPTFLAG	;If 'E' entered, toggle encryption 

CHECKDECRYPT	LD R5, DCHAR	;Loads ASCII for 'D'
		AND R6, R6, #0	;Resets Temp
		ADD R6, R0, R5	;Compares input with 'D'
		BRz DECRYPTFLAG	;If 'D' entered, toggle decryption

CHECKEXIT	LD R5, XCHAR	;Loads ASCII for 'X'
		AND R6, R6, #0	;Resets Temp
		ADD R6, R0, R5	;Compares input with 'X'
		BRz EXIT	;If 'X' entered, exit program
		BRnp INPUTCHOICE

ENCRYPTFLAG	AND R1, R1, #0 ;Set Encryption Flag to 1
		ADD R1, R1, #1
		BR SETUPCIPHER
		
DECRYPTFLAG	AND R1, R1, #0	;Set Encryption Flag to 0
		BR SETUPCIPHER

SETUPCIPHER	LEA R0, CIPHER	;Print CIPHER message
		PUTS

INPUTCIPHER	GETC		;Retrieve user input
		OUT

CHECKCIPHERLF	LD R5, LFCHAR	;Load ASCII for 'LF'
		AND R6, R6, #0	;Reset Temp
		ADD R6, R0, R5	;Check if input is 'LF'
		BRz SETUPMESSAGE	;If input is 'LF', ask for user to input message

SETUPMULTIPLY	LD R5, NUMBEROFFSET	;Loads the number offset for ASCII numbers
		ADD R0, R0, R5		;Subtract offset from input
		AND R2, R2, #0		;Reset Multiply counter
		AND R5, R5, #0		;Reset temp
		ADD R5, R5, R3		;Set temp to current cipher value

MULTIPLYCIPH	ADD R2, R2, #1		;Add 1 to Multiply counter
		ADD R3, R3, R5		;Add original cipher value to current cipher value
		AND R6, R6, #0		;Reset temp
		ADD R6, R6, #-9		;Set temp to -9
		ADD R6, R2, R6		;Check if multiply counter has looped 10 times
		BRn MULTIPLYCIPH	;If not, repeat loop

ADDCIPHER	ADD R3, R3, R0		;Add input to cipher value
		BR INPUTCIPHER		;Ask for next input

SETUPMESSAGE	LEA R0, INPUTSTRING
		PUTS
		AND R5, R5, #0
		ST R5, RI
		ST R5, CI

INPUTMESSAGE	GETC
		OUT

CHECKMESSAGELF	LD R5, LFCHAR
		AND R6, R6, #0
		ADD R6, R0, R5
		BRz PRINTRESULT

INPUTARRAY	AND R5, R5, #0		;Sets R5 to 0
		JSR STORE
		AND R5, R5, #0		;Reset Temps
		ADD R5, R3, R5		;Check Encryption Flag
		BRz DECRYPTINPUT	;If 0, Decrypt
		BRp ENCRYPTINPUT	;If 1, Encrypt

DECRYPTINPUT	JSR DECRYPT
		ADD R4, R4, #1
		BR INPUTMESSAGE

ENCRYPTINPUT	JSR ENCRYPT
		ADD R4, R4, #1
		BR INPUTMESSAGE

PRINTRESULT	LEA R0, OUPUTSTRING	;Load OUTPUTSTRING
		PUTS			;Prints R0
		AND R5, R5, #0		;Reset temp
		ST R5, CI		;Set Ci to 0
		ST R4, RI		;Set Ri to 0
		LD R4, CI		;Load Ci into R4
		LD R5, RI		;Load Ri into R5
		JSR PRINT		;Jump to Print subroutine
		BR START

EXIT		LEA R0, GOODBYE
		PUTS

		HALT

CI		.FILL #0
RI		.FILL #0
DCHAR		.FILL #-68
ECHAR		.FILL #-69
XCHAR		.FILL #-88
LFCHAR		.FILL #-10
NUMBEROFFSET	.FILL #-48

WELCOME 	.STRINGz "Hello, welcome to my Caesar Cipher program"
GOODBYE		.STRINGz "\nGoodbye!!"
CHOICE		.STRINGz "\nDo you want to (E)ncrypt or (D)ecrypt or e(X)it?\n"
CIPHER		.STRINGz "\nWhat is the cipher (1-25)?\n"
INPUTSTRING	.STRINGz "What is the string (up to 200 characters)?\n"
OUPUTSTRING	.STRINGz "Here is your string and the result"
ENCRYPTED	.STRINGz "\n<Encrypted> "
DECRYPTED	.STRINGz "\n<Decrypted> "

NUMBER200	.FILL #199
RETSAVE		.BLKW 1

;STORE subroutine
STORE		ADD R5, R5, #0	;Checks R5 which holds Ri coordinate
		BRp RI200	;If Ri cooridinate is 1, add 200 to go to next row major

STOREVAR	LEA R6, ARRAY	;Load Address of ARRAY
		ADD R6, R6, R5	;Add Ri x #of Rows
		ADD R6, R6, R4	;Add Ci
		STR R0, R6, #0	;Store input at address Base Address + (Ri, Ci)
		BR BACKTOINPUT		

RI200		LD R5, NUMBER200 ;Sets R5 to 200			
		BR STOREVAR

BACKTOINPUT	RET		;Return to address stored in R7

;ENCRYPT subroutine
ENCRYPT		ST R7, RETSAVE	;Store R7 in RETSAVE
		AND R2, R2, #0	;Reset to be used as temp
		AND R6, R6, #0	;Reset to be used as temp
		AND R7, R7, #0	;Reset to be used as temp
		
CHECKCAPITAL	LD R2, CAPLETTER	;Load ASCII lower bound for capital letter
		ADD R6, R0, R2		;Check if input is higher than bound
		BRn BACKTOOTHER		;If not, do not alter input

CHECKCAPBOUND	LD R2, CAPBOUND		;Load ASCII upper bound for capital letter
		AND R6, R6, #0		;Reset temp
		ADD R6, R0, R2		;Check if lower than bound
		BRnz ISCAPITAL		;If lower, alter letter

CHECKLOWER	LD R2, LOWLETTER 	;Load ASCII lower bound for lowercase letters
		AND R6, R6, #0		;Reset temp
		ADD R6, R0, R2		;Check if higher than bound
		BRn BACKTOOTHER		;if not, do not alter input

CHECKLOWBOUND	LD R2, LOWBOUND		;Load ASCII upper bound for lowercase letters
		AND R6, R6, #0		;Reset temp
		ADD R6, R0, R2		;Check if higher than bound
		BRnz ISLOWER		;if so, it is a lowercase letter
		BRp BACKTOOTHER		;if not, do not alter input

ISCAPITAL	ADD R0, R0, R3		;Add cipher number to input
		LD R2, CAPBOUND		;Load ASCII upper bound for capital letter
		AND R6, R6, #0		;Reset temp
		ADD R6, R2, R0		;Check if encrypted input is over bound
		BRp FIXBOUND		;If so, fix the input
		BRnz BACKTOOTHER	;If not, return to original routine

ISLOWER		ADD R0, R0, R3		;Add cipher number to input
		LD R2, LOWBOUND		;Load ASCII upper bound for lower letter
		AND R6, R6, #0		;Reset temp
		ADD R6, R2, R0		;Check if encrypted input is over bound
		BRp FIXBOUND		;If so, fix the input
		BRnz BACKTOOTHER	;If not, return to original routine

FIXBOUND	LD R2, LETTER		;Load letter offset
		ADD R0, R0, R2		;Add offset to input	
		BR BACKTOOTHER		

BACKTOOTHER	AND R5, R5, #0
		ADD R5, R5, #1
		JSR STORE
		ST R4, MAXCHAR

FINISHENCRYPT	LD R7, RETSAVE
		RET

;DECRYPT subroutine
DECRYPT		ST R7, RETSAVE	;Store R7 in RETSAVE
		AND R2, R2, #0	;Reset to be used as temp
		AND R6, R6, #0	;Reset to be used as temp
		AND R7, R7, #0	;Reset to be used as temp
		
CHECKDCAPITAL	LD R2, CAPLETTER	;Load ASCII lower bound for capital letter
		ADD R6, R0, R2		;Check if input is higher than bound
		BRn BACKTODOTHER	;If not, do not alter input

CHECKDCAPBOUND	LD R2, CAPBOUND		;Load ASCII upper bound for capital letter
		AND R6, R6, #0		;Reset temp
		ADD R6, R0, R2		;Check if lower than bound
		BRnz ISDCAPITAL		;If lower, alter letter

CHECKDLOWER	LD R2, LOWLETTER 	;Load ASCII lower bound for lowercase letters
		AND R6, R6, #0		;Reset temp
		ADD R6, R0, R2		;Check if higher than bound
		BRn BACKTODOTHER	;if not, do not alter input

CHECKDLOWBOUND	LD R2, LOWBOUND		;Load ASCII upper bound for lowercase letters
		AND R6, R6, #0		;Reset temp
		ADD R6, R0, R2		;Check if higher than bound
		BRnz ISDLOWER		;if so, it is a lowercase letter
		BRp BACKTODOTHER	;if not, do not alter input

ISDCAPITAL	NOT R3, R3		;Invert Cipher number
		ADD R3, R3, #1		;Add 1 to make it negative
		ADD R0, R0, R3		;Add cipher number to input
		LD R2, CAPBOUND		;Load ASCII upper bound for capital letter
		AND R6, R6, #0		;Reset temp
		ADD R6, R2, R0		;Check if encrypted input is over bound
		BRp FIXDBOUND		;If so, fix the input
		BRnz BACKTODOTHER	;If not, return to original routine

ISDLOWER	NOT R3, R3		;Invert Cipher number
		ADD R3, R3, #1		;Add 1 to make it negative
		ADD R0, R0, R3		;Add cipher number to input
		LD R2, LOWBOUND		;Load ASCII upper bound for lower letter
		AND R6, R6, #0		;Reset temp
		ADD R6, R2, R0		;Check if encrypted input is over bound
		BRp FIXBOUND		;If so, fix the input
		BRnz BACKTODOTHER	;If not, return to original routine

FIXDBOUND	LD R2, LETTER		;Load letter offset
		ADD R0, R0, R2		;Add offset to input	
		BR BACKTODOTHER		

BACKTODOTHER	AND R5, R5, #0
		ADD R5, R5, #1
		JSR STORE
		ST R4, MAXCHAR
		BR FINISHDECRYPT

FINISHDECRYPT	LD R7, RETSAVE
		RET

;Load Subroutine
;Assumes R4 holds Ci, and R5 holds Ri
LOAD		ADD R5, R5, #0	;Checks R5 which holds Ri coordinate
		BRp ORI200	;If Ri cooridinate is 1, add 200 to go to next row major

LOADVAR		LEA R6, ARRAY	;Load Address of ARRAY
		ADD R6, R6, R5	;Add Ri x #of Rows
		ADD R6, R6, R4	;Add Ci
		LDR R0, R6, #0	;Load input at address Base Address + (Ri, Ci)
		BR BACKTOOUTPUT		

ORI200		LD R5, NUMBER200 ;Sets R5 to 200			
		BR LOADVAR

BACKTOOUTPUT	RET		;Return to address stored in R7

;Print Subroutine
;Assumes R4 contains Ci, R5 contains Ri, and R2 contains maximum characters
PRINT		ST R7, RETSAVE		;Stores R7 to RETSAVE
		LD R2, MAXCHAR		;Load maxchar into R2
		NOT R2, R2		;Invert R2
		ADD R1, R1, #0		;Sees what the value in R1 is
		BRp WASENCRYPT		;If 1, then command was to encrypt

WASDECRYPT	LEA R0, ENCRYPTED	;Print ENCRYPTED message
		PUTS
		BR LOADEORIG

WASENCRYPT	LEA R0, DECRYPTED	;Print DECRYPTED message
		PUTS
		BR LOADDORIG

LOADEORIG	AND R5, R5, #0
		JSR LOAD		;Jump to load subroutine
		OUT			;Print R0
		ADD R4, R4, #1		;Increment Ci
		AND R6, R6, #0		;Reset Temp
		ADD R6, R4, R2		;Compare if Ci has reached maximum char
		BRn LOADEORIG		;If not loop

		LEA R0, DECRYPTED	;Prints DECRYPTED message
		PUTS
		AND R4, R4, #0		;Reset Ci
		AND R5, R5, #0		;Reset Ri
		ADD R5, R5, #1		;Set Ri to 1
		BR LOADCIPHER

LOADDORIG	AND R5, R5, #0
		JSR LOAD		;Jump to load subroutine
		OUT			;Print R0
		ADD R4, R4, #1		;Increment Ci
		AND R6, R6, #0		;Reset Temp
		ADD R6, R4, R2		;Compare if Ci has reached maximum char
		BRn LOADDORIG		;If not loop
		
		LEA R0, ENCRYPTED	;Prints ENCRYPTED message
		PUTS
		AND R4, R4, #0		;Reset Ci
		AND R5, R5, #0		;Reset Ri
		ADD R5, R5, #1		;Set Ri to 1
		BR LOADCIPHER

LOADCIPHER	AND R5, R5, #1
		JSR LOAD		;Jump to LOAD subroutine
		OUT			
		ADD R4, R4, #1		;Increment Ci
		AND R6, R6, #0		;Reset Temp
		ADD R6, R4, R2		;Compare if Ci has reached maximum char
		BRn LOADCIPHER	;If not loop
		BR FINISH		;If so Finish
		
FINISH		LD R7, RETSAVE
		RET

MAXCHAR		.BLKW 1
LETTER		.FILL #-26
CAPLETTER	.FILL #-65
CAPBOUND	.FILL #-90
LOWLETTER	.FILL #-97
LOWBOUND	.FILL #-122
ARRAY		.BLKW 400

		.END