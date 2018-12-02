#Quick sort
#Created 12/01/2018
#By Zrus & Reigne


.data
	arr: 		.word 		1000
	msg_askSize: 	.asciiz 	"Enter size of array: "	
	msg_arr:	.asciiz		"Array: "
	msg_space: 	.asciiz 	" "
	msg_newLine: 	.asciiz 	"\n"
	msg_varA1:	.asciiz		"a["
	msg_varA2:	.asciiz		"] = "
	msg_output:	.asciiz		"1. Output array."
	msg_sumarr:	.asciiz		"2. Sum of array."
	msg_primes:	.asciiz		"3. Primes in array."
	msg_findMax:	.asciiz		"4. Max of array."
	msg_findX:	.asciiz		"5. Find element."
	msg_exit:	.asciiz		"6. Exit."

.text


inputSize:
	la 	$a0, msg_askSize 		#Ask user to enter size of array.
	li 	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	move 	$s0, $v0 		#Size of array is saved to $s0.
	
	slt	$t0, $0, $s0
	beq	$t0, $0, inputSize
	
	move 	$s1, $s0 		#Save value of $s0 to $s1 to do not change value of $s0.	
	move	$s2, $s0		#Same to $s1
	la 	$t0, arr		#Save address of arr to $t0 to handle.
	

inputLoop:
	beq 	$s1, 0, doSth
	
	la	$a0, msg_varA1
	li	$v0, 4
	syscall
	sub	$t1, $s0, $s1
	move	$a0, $t1
	li	$v0, 1
	syscall
	la	$a0, msg_varA2
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	sw 	$v0, ($t0)
	subi 	$s1, $s1, 1
	addi 	$t0, $t0, 4

	b inputLoop


doSth:
	la 	$a0, msg_newLine
	li 	$v0, 4
	syscall
	la	$t0, arr


outputLoop:
	beq	$s2, 0, doSthelse

	lw 	$t2, ($t0)
	move	$a0, $t2
	li	$v0, 1
	syscall
	la	$a0, msg_space
	li 	$v0, 4
	syscall
	subi	$s2, $s2, 1
	addi	$t0, $t0, 4

	b outputLoop


doSthelse:
