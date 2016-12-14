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
    
    mainloop:
    lw $t2, PORTD	    /* Load value at PORTD into t2 */
    lw $t3, PORTD	    /* Load value at PORTD into t3 */
    lw $t4, PORTF	    /* Load value at PORTF into t4 */
    la $t5, PORTE	    /* Load address of PORTE */
			    /* SW 1-4 in PORT D in bit 8, 9, 10, 11 */
    srl $t2, $t2, 8	    /* Shift right 8 bits to make LD1, LD2, LD3, LD4 turn on */
    andi $t6, $t2, 0x000F   /* AND 0000 1111 to check if bits 1, 2, 3, 4 are on */
    sw $t6, 0($t5)	    /* Store the 1 bits of PORT D in PORT E to turn on corresponding LD */
			    /* BTN 1 in PORT F in bit 1 */
    sll $t4, $t4, 3	    /* Shift left 3 bits to make LD5 turn on */
    andi $t7, $t4, 0x0010   /* AND bit 5 to see if BTN1 is on */
    sw $t7, 0($t5)	    /* Store the 1 bit in PORT E */
			    /* BTN 2-4 in PORT D in bit 5, 6, 7 */
    andi $t3, $t3, 0x00E0   /* AND the value 1110 0000 which checks if bits 5, 6, 7 in PORT D are 1 */
    sw $t3, 0($t5)	    /* Store the 1 bits of PORT D in PORT E to turn on LD6, LD7, LD8 */

    b mainloop		    /* Restart loop */
    nop
    
.end main

.data



