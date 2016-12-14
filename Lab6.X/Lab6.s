/* Christopher Huynh - chphuynh */
/* Lab 6: Decimal to Binary Converter Redux - Due: Nov. 20 */
/* Lab section: TuTh 2pm-4pm - TA: Chandrahas */
    
#include <WProgram.h>

#include <xc.h>
/* define all global symbols here */
.global main
.global read
.text
.set noreorder

.ent main
main:
    /* this code blocks sets up the ability to print, do not alter it */
   ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)

    
    
    LA $a0,WelcomeMessage
    JAL puts
    NOP
    
    
    /* your code goes underneath this */
    and $t0, $t0, 0x0				/* Clears t0 to hold address of string */
    and $t1, $t1, 0x0		    		/* Clears t1 to hold parsed string bit */
    and $t2, $t2, 0x0				/* Clears t2 to be used as int */
    and $t3, $t3, 0x0				/* Clears t3 to be used as output */
    and $t4, $t4, 0x0				/* Clears t4 to be used as parse counter */
    and $t5, $t5, 0x0				/* Clears t5 to be used as negative flag */
    and $t6, $t6, 0x0				/* Clears t6 to be used as mask */
    
    parseString:
	la $t0, inNumericString			/* Load address of input */
	add $t0, $t0, $t4			/* Add counter to address */
	lb $t1, 0($t0)				/* Load new address */
	beq $t1, $zero, convertString		/* If NULL, start converting string */
	nop					
	lb $t8, negative			/* Load ascii for '-' */
	beq $t1, $t8, setFlag			/* If input is '-' set negative flag */
	nop
	lb $t8, ten				/* Load the value 10 */
	mul $t2, $t2, $t8			/* Multiply int by 10 */
	lb $t8, offset				/* Load ascii offset for numbers */
	sub $t1, $t1, $t8			/* Subtract offset from input bit */
	add $t2, $t2, $t1			/* Add input bit to int */
	b parseString				/* Loop */
	    add $t4, $t4, 1			/* Increment counter */
	    
    setFlag:
	and $t5, $t5, 0x0			/* Clears flag */
	add $t5, $t5, 1				/* Set flag to 1 */
	b parseString				/* Return to loop */
	    add $t4, $t4, 1			/* Increment counter */
	
    makeNegative:
	sub $t2, $zero, $t2			/* Subtract int from zero to make negative */
	and $t5, $t5, 0x0			/* Reset flag */
	b convertString				/* Continue converting int to string */
	nop
	
    convertString:
	bgtz $t5, makeNegative			/* If flag, then make int negative */
	nop
	and $t6, $t6, 0x0			/* Clear t6 */
	add $t6, $t6, 0x80000000		/* Set t6 to mask 1 bit at bit 32 */
	and $t4, $t4, 0x0			/* Reset counter */
	
	loop:
	    la $t0, outBinaryString		/* Load address of outstring */
	    add $t8, $t0, $t4			/* Add counter to address and store in temp */
	    lb $t8, 0($t8)			/* Load bit at location */
	    beq $t8, $zero, done		/* If NULL, we are done converting */
	    nop
	    and $t7, $t2, $t6			/* AND the mask and int */
	    beq $t7, $t6, printOne		/* If 1, print one */
	    nop
	    b printZero				/* Else, print zero */
	    nop

    printOne:
	la $t0, outBinaryString			/* Load address of out string */
	add $t0, $t0, $t4			/* Add counter to address */
	lb $t3, stringOne			/* Load the ascii value for '1' */
	sb $t3, 0($t0)				/* Store ascii value at location of address + counter */
	b continue				/* Continue loop */
	nop
    
    printZero:
	la $t0, outBinaryString			/* Load address of out string */
	add $t0, $t0, $t4			/* Add counter to address */
	lb $t3, stringZero			/* Load the ascii value for '0' */
	sb $t3, 0($t0)				/* Store ascii value at location of address + counter */
	b continue				/* Continue loop */
	nop
	
    continue:
	add $t4, $t4, 1				/* Increment counter */
	srl $t6, $t6, 1				/* Shift bit for mask right */
	b loop					/* Return to loop */
	nop
    
    done:
    /* your code goes above this */
    
    LA $a0,DecimalMessage
    JAL puts
    NOP
    LA $a0,inNumericString
    JAL puts
    NOP
    
    LA $a0,BinaryMessage
    JAL puts
    NOP
    LA $a0,outBinaryString
    JAL puts
    NOP
    
    

    
    

endProgram:
    J endProgram
    NOP
.end main




.data
WelcomeMessage: .asciiz "Welcome to the converter\n"
DecimalMessage: .asciiz "The decimal number is: "
BinaryMessage: .asciiz "The decimal number is: "
    
inNumericString: .asciiz "-10000" 
outBinaryString: .asciiz "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
    
negative: .byte 45
offset: .byte 48 
ten: .byte 10
stringOne: .byte 49
stringZero: .byte 48





