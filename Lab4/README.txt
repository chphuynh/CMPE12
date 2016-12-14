###############################
Christopher Huynh -- chphuynh
Lab section: TuTh 2pm-4pm TA: Chandrahas
Due: 11/6/2016
###############################

Title:
Lab 4: Caesar Cipher

Purpose:
Use subroutines to create a cipher.

Procedure:
Create a 2x200 array and print a prompt for whether the user would
like to encrypt or decrypt a string or to exit. Then print a prompt
that asks the user for a number between 1 and 25. Then print a prompt
for the user to input a string. Using row major, store the string
entered in row 0 and encrypt or decrypt the string and store it in
row 1. Print out the array then repeat.

Algorithms and other data:
We used Row Major in incorporating our 2x200 array. In order to
access the array we used the coordinates (Ri, Ci) where Ri is the
row number and Ci is the column number. To calculate the location
of the coordinate, we grab the base address and add this with then
Row number (Ri) times the number of columns and add the column
number (Ci).

What went wrong or what were the challenges?
This was an incredibly difficult lab to complete. There were many
errors in which variables were too far away from the Instructions
that call them. This caused '9-bit' offset errors which made me
have to change up the ordering of variables. The use of the simulator
was fundamental to me debugging the program.

What went wrong or what were the challenges?