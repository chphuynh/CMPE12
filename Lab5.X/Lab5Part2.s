/* Christopher Huynh - chphuynh */
/* Lab 5: Introduction to Uno32 and MIPS - Due: Nov. 20 */
/* Lab section: TuTh 2pm-4pm - TA: Chandrahas */

#include <WProgram.h>
    
/* define all global symbols here */
.global main

.text
.set noreorder

.ent main
main:
    
    andi $t9, $t9, 0x0	     /* Clear t9*/
    addi $t9, $t9, 0x0FF    /* Set t9 to 1111 1111*/
    sw $t9, TRISECLR	    /* Enable LED outputs by clearing bits 0-8 in TRISE */
    sw $t9, PORTECLR	    /* Clear PORT E in case any lights are default on*/
    andi $t9, $t9, 0x0	    /* Clear t9*/
    addi $t9, $t9, 0x001    /* Set t9 to 1*/
    sw $t9, PORTESET	    /* Set LD1 to on*/
    andi $t0, $t0, 0x0	    /* Clear t0 */
    
    mainloop:
    lw $t2, PORTE	/* Load value at PORTE into t2 */
    lw $t3, PORTD	/* Load PORTD into t3*/
    la $t5, PORTE	/* Load address of PORTE */
    
    srl $t3, $t3, 8	    /* Shift right 8 bits */
    andi $a0, $t3, 0x000F   /* Check if SW1-4 are turned on*/
    addi $a0, $a0, 1	    /* Add 1 to make value 1-16*/
    jal mydelay		    /* Jump to delay */
    
    andi $t8, $t8, 0x0	    /* Clear t8 */
    addi $t8, $t8, 0x001    /* Set t8 to 0000 0001*/
    
    andi $t9, $t9, 0x0	    /* Clear t9 */
    addi $t9, $t9, 0x080    /* Set t9 to 1000 0000 */
    
    bgtz $t0, shiftright    /* If reverse flag t0 is 1, jump to shift right */
    nop
	shiftleft:
	    beq $t2, $t9, shiftright	/* If LD8 is on, begin shifting right */
	    nop
	    andi $t0, $t0, 0x0		/* Set flag to 0 */
	    sll $t2, $t2, 1		/* Shift left 1 */
	    sw $t2, 0($t5)		/* Store new bit into PORT E */
   	    b mainloop			/* Restart loop */
	    nop
	shiftright:
	    beq $t2, $t8, shiftleft	/* If LD1 is on, begin shifting left */
	    nop
	    andi $t0, $t0, 0x0		/* Clear reverse flag*/
	    addi $t0, $t0, 0x01		/* Set reverse flag to 1*/
	    srl $t2, $t2, 1		/* Shift right 1 bit */
	    sw $t2, 0($t5)		/* Store new bit into PORT E */
	    b mainloop			/* Restart loop */
	    nop
	    
mydelay:
     andi $t6, $t6, 0x0			/* Clear counter t6 */
     andi $t7, $t7, 0x0			/* Clear t7 */
     addi $t7, $t7, 0x0800		/* Set t7 to base delay of 2048 */
     mul $a0, $a0, $t7			/* Multiply base delay by a0 */
     
     delayloop:
	beq $t6, $a0, exitdelay		/* If counter is equal to a0, exit loop*/
	nop				
	addi $t6, $t6, 1		/* Add 1 to counter */
	b delayloop			/* Restart loop */
	nop
	
    exitdelay:
	jr $ra				/* Jump back to original routine */
    
.end main

.data





