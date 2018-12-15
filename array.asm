#Array
#Created 05/12/18
#By Zrus & Diana Sensei

.data
	msg_dev:	.asciiz		"Created by Zrus & Diana.S\n"
	size:		.space		4
	arr: 		.word 		0:1000
	prime_arr:	.word		0:1000
	msg_askSize: 	.asciiz 	"Enter size of array: "	
	msg_askElm:	.asciiz		"Enter number: "
	msg_space: 	.asciiz 	" "
	msg_newLine: 	.asciiz 	"\n"
	msg_varA1:	.asciiz		"a["
	msg_varA2:	.asciiz		"] = "
	msg_askOpt:	.asciiz		"Choose: "
	msg_opt1:	.asciiz		"1. Output array.\n"
	msg_opt2:	.asciiz		"2. Sum of array.\n"
	msg_opt3:	.asciiz		"3. Primes in array.\n"
	msg_opt4:	.asciiz		"4. Max of array.\n"
	msg_opt5:	.asciiz		"5. Find element.\n"
	msg_opt6:	.asciiz		"6. Exit.\n"
	msg_exit:	.asciiz		"Program finished.\n"

#Rules:
#Parameters: $a0, $a1, $a2.
#Local var: register $t and $s.
#Return value store at: $v0, $v1.
#Detail:
#	+ $a0, $t0: store address of array.
#	+ $a1, $t1: store size of array.
#	+ $a2: store choice of user.
#	+ $t2, $s2 (, $a2): use to check conditions.

.text
.globl main
main:					#Print info of developer.
	la	$a0, msg_dev
	li	$v0, 4
	syscall

input_size_func:			#Input size of the array, loop while user enter inconsonant number.
	la	$a0, msg_askSize	#Ask user for input size.
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a1, $v0

	slt	$t0, $0, $a1		#If not suitable, ask user input again.
	beq	$t0, 0, input_size_func

	la	$a0, arr		#Prepare data for next action.
	sb	$a1, size

	add	$t0, $a0, $0
	add	$t1, $a1, $0

input_elm_func:				#Input elements base on size n.
	beq	$t1, 0, menu_func	#Loop til i = size.

	la	$a0, msg_varA1		#Enter elements.
	li	$v0, 4
	syscall
	sub	$s0, $a1, $t1		#Print 'a[i]'.
	move	$a0, $s0
	li	$v0, 1
	syscall
	la	$a0, msg_varA2
	li	$v0, 4
	syscall
	li 	$v0, 5			#Scan.
	syscall
	sw 	$v0, ($t0)		#Store in array.
	subi 	$t1, $t1, 1
	addi 	$t0, $t0, 4

	j	input_elm_func

menu_func:				#Menu, ask user to choose action needed.
	la	$a0, msg_newLine
	li	$v0, 4
	syscall
	la	$a0, msg_opt1		#Output array.
	li	$v0, 4
	syscall
	la	$a0, msg_opt2		#Sum of array.
	li	$v0, 4
	syscall
	la	$a0, msg_opt3		#Primes.
	li	$v0, 4
	syscall
	la	$a0, msg_opt4		#Print max in array.
	li	$v0, 4
	syscall
	la	$a0, msg_opt5		#Return entered value in array.
	li	$v0, 4
	syscall
	la	$a0, msg_opt6		#End program.
	li	$v0, 4
	syscall
	la	$a0, msg_newLine
	li	$v0, 4
	syscall
	la	$a0, msg_askOpt
	li	$v0, 4
	syscall
	li	$v0, 5			#Get choice.
	syscall
	move	$s0, $v0

	slti	$t0, $s0, 1		#If choice is not suitable, ask user choose again.
	bne	$t0, $0, menu_func
	addi	$t0, $0, 6
	slt	$t0, $t0, $s0 
	bne	$t0, $0, menu_func

	add	$a2, $s0, $0		#Store the choice.

	move	$a0, $0
	move	$a1, $0

switch:
case_1:					#Output array.
	addi	$t2, $a2, -1		#Check choice.
	bne	$t2, $0, case_2		#If not equal to 1 go to case 2.
	la	$a0, arr		#Prepare data.
	lb	$a1, size
	jal	output_func		#Call output and store $ra.
	j	menu_func		#Back to menu_func to choose needed action again.

case_2:					#Return sum of elements.
	addi	$t2, $a2, -2		#Check choice.
	bne	$t2, $0, case_3		#If not equal to 2 go to case 3.
	la	$a0, arr		#Prepare data.
	lb	$a1, size
	jal	sum_func		#Call sum_func and store $ra.
	move	$a0, $v0		#Print returned value from sum_func.
	li	$v0, 1
	syscall
	la	$a0, msg_newLine
	li	$v0, 4
	syscall
	j	menu_func

case_3:					#Return array of primes exist in main array.
	addi	$t2, $a2, -3		#Check choice.
	bne	$t2, $0, case_4		#If not equal to 3 go to case 4.
	la	$a0, arr		#Prepare.
	lb	$a1, size
	jal	primes_func		#Call primes_func and store $ra.
	move	$a0, $v0		#Get returned value from primes_func to print out primes array.
	move	$a1, $v1
	jal	output_func		#Print primes array.
	j	menu_func

case_4:					#Return max value in array.
	addi	$t2, $a2, -4		#Check choice.
	bne	$t2, $0, case_5
	la	$a0, arr
	lb	$a1, size
	jal	find_max_func		#Call find_max_func
	move	$a0, $v0
	li	$v0, 1
	syscall				#Print out value returned.
	la	$a0, msg_newLine
	li	$v0, 4
	syscall
	j	menu_func

case_5:					#Return index of element needed.
	addi	$t2, $a2, -5
	bne	$t2, $0, case_6		
	la	$a0, msg_askElm		#Ask user the value needed.
	li	$v0, 4
	syscall
	li	$v0, 5			#Get that value.
	syscall
	move	$a2, $v0
	la	$a0, arr
	lb	$a1, size
	jal	find_elm_func
	move	$a0, $v0
	li	$v0, 1
	syscall				#Print out the index of the value entered (if exist).
	la	$a0, msg_newLine
	li	$v0, 4
	syscall
	j	menu_func

case_6:					#End program.
	j	exit_func

output_func:				#Prepare data.
	add	$t0, $a0, $0
	add	$t1, $a1, $0

output:					#Loop til end of array.
	beq	$t1, 0, stop_output

	lw 	$s0, ($t0)		#Load each element from array to print.
	move	$a0, $s0
	li	$v0, 1
	syscall
	la	$a0, msg_space
	li 	$v0, 4
	syscall
	subi	$t1, $t1, 1		#Increase index.
	addi	$t0, $t0, 4

	j	output

stop_output:
	la	$a0, msg_newLine
	li	$v0, 4
	syscall
	jr	$ra			#Go back to next step at case 1.

sum_func:				#Prepare data.
	add	$t0, $a0, $0
	add	$t1, $a1, $0
	add	$v0, $0, $0

sum:
	beq	$t1, 0, stop_sum	#Loop til end of array.
	
	lw	$s0, ($t0)
	add	$v0, $v0, $s0		#Add to $v0 as sum of array.

	subi	$t1, $t1, 1
	addi	$t0, $t0, 4

	j	sum			#Loop.

stop_sum:
	jr	$ra			#Back to case 2.

primes_func:
	add	$t0, $a0, $0
	add	$t1, $a1, $0
	la	$s0, prime_arr
	addi	$s1, $0, 0
	addi	$t2, $0, 2

primes:
	beq	$t1, 0, stop_check

	lw	$t3, ($t0)

	subi	$t1, $t1, 1
	addi	$t0, $t0, 4
	
	slti	$t4, $t3, 2
	bne	$t4, 0, not_prime

	div	$t3, $t2
	mflo	$t4

check_prime:
	beq	$t4, 1, is_prime
	
	div	$t3, $t4
	mfhi	$t5
	beq	$t5, 0, not_prime
	subi	$t4, $t4, 1
	j	check_prime

is_prime:
	sw	$t3, ($s0)
	addi	$s1, $s1, 1
	addi	$s0, $s0, 4

not_prime:
	j	primes

stop_check:
	la	$v0, prime_arr
	add	$v1, $s1, $0
	jr	$ra

find_max_func:
	add	$t0, $a0, $0		#Prepare data.
	add	$t1, $a1, $0

	lw	$s0, ($t0)		#Get first element in array as max value.
	add	$v0, $s0, $0
	subi	$t1, $t1, 1		#Index start from 1.
	addi	$t0, $t0, 4

find_max:
	beq	$t1, 0, stop_find_max	#Start check form element 1 (a[1]), for max as a[0].
	
	lw	$s0, ($t0)
	subi	$t1, $t1, 1
	addi	$t0, $t0, 4
	slt	$s1, $v0, $s0
	bne	$s1, $0, change_max	#If max < a[i], change max to a[i].
	b 	find_max

change_max:
	add	$v0, $s0, $0
	j	find_max

stop_find_max:
	jr	$ra

find_elm_func:
	add	$t0, $a0, $0		#Prepare data.
	add	$t1, $a1, $0
	add	$t2, $a2, $0

find_elm:
	beq	$t1, 0, stop_find_elm	#Loop til end of array.

	lw	$s0, ($t0)
	beq	$t2, $s0, stop_find_elm	#If the value entered is equal to a[i], stop find.
	subi	$t1, $t1, 1
	addi	$t0, $t0, 4
	j	find_elm

stop_find_elm:
	beq	$t1, 0, not_found	#If index == 0 (know as end of array) is know as the value does not exist in array, jump to not found.
	sub	$t1, $a1, $t1
	add	$v0, $t1, $0
	jr	$ra			#Back to next step at case 5 to print out index of value.

not_found:				#If not found, return -1.
	addi	$v0, $0, -1
	jr	$ra

exit_func:
	la	$a0, msg_exit		#Finish program.
	li	$v0, 4
	syscall
	li	$v0, 10
	syscall
