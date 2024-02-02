.data
error1: .asciiz "The value you entered is less than zero. This program only works with values greater than or equal to zero.“
msg0: .asciiz "\nPlease input an integer value greater than or equal to 0: “
msg1: .asciiz "Your input: “
msg2: .asciiz "\nThe factorial is: “
msg3: .asciiz "\nWould you like to do this again (Y/N): “

.globl main

.text

main:
loop:	
	la $a0, msg0		#print initial msg
	li $v0, 4
	syscall

	li $v0, 5		#get initial input
	syscall
	
	blt $v0, 0, end1	#if the initial input is less than 0 print the error

	addi $sp, $sp, -4	#change stack pointer location
	sw $v0, ($sp)		#push the value n to stack as argument
	
	move $s0, $v0		#put original argument into $s0
	
	jal factorial		#call factorial. save ra
	
	move $s1, $v0 		#put answer into s1
	
	la $a0, msg1		#print out first message
	li $v0, 4
	syscall
	
	move $a0, $s0		#print original number
	li $v0, 1
	syscall
	 
	la $a0, msg2		#print second message
	li $v0, 4
	syscall
	
	move $a0, $s1		#print answer	
	li $v0, 1
	syscall
	
	la $a0, msg3		#ask if they want to do it again?
	li $v0, 4
	syscall
	
	#li $a0, 20		#allocate space for chars
	li $v0, 12		#read string and store it into v0
	syscall
	
	li $s2, 'Y'		#put capital Y into s2
	
	beq $v0, $s2, loop	#if they typed capital Y go to start again
	

	li $v0, 10		#did not type cap Y, end program
	syscall	
	
factorial:
	addi $sp, $sp, -4	#push return address to stack
	sw $ra, 0($sp)		#^
	
	addi $sp, $sp, -4	#push s0 to stack
	sw $s0, 0($sp)		#^
	
	addi $sp, $sp, -4	#push s1 to stack
	sw $s1, 0($sp)		#^
	
	lw $s0, 12($sp)		#peak the argument n off the stack - do not pop. put in s0
	
	beqz $s0, zero		#if n equals zero so we return 1
	
	addi $s1, $s0, -1	#store n-1 in s1
	
	addi $sp, $sp, -4	#push new argument n-1 to the stack
	sw $s1, 0($sp)		#^
	
	jal factorial		#call factorial, result will be in v0
	
	multu $s0, $v0		#multiply n and result of factorial
	mflo $v0		#put result into v0

endfunction:			
	lw $s1, 0($sp)		#restore s1 back into s1 by popping stack
	addi $sp, $sp, 4
	
	lw $s0, 0($sp)		#restore s0 back into s1 by popping stack
	addi $sp, $sp, 4
	
	lw $ra, 0($sp)		#restore ra back into s1 by popping stack
	addi $sp, $sp, 4
	
	addi $sp, $sp, 4	#discard the argument that us on stack
	
	jr $ra			#return to call point
zero:
	li $v0, 1		#put 1 into v0 for return
	j endfunction		#jump to the end function protocol, same as for normal return

end1:
	la $a0, error1		#print error
	li $v0, 4
	syscall
	
	li $v0, 10		#terminate program
	syscall
