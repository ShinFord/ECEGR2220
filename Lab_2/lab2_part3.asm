#Lab 2, Part 3

.data
	Z: .word 2
	i: .word 0
	Str1: .asciz "Z = "
	Str2: .asciz " i = "
.text

main:
	lw t0, Z #t0=Z=2
	lw t1, i #t1=i=0
	addi t2, zero, 20 #t2=20
	addi t3, zero, 100 #t3=100
	addi t4, zero, 1 #t4=1
	jal for
	sw t0, Z, t5
	sw t1, i, t6
	li a7, 4
	la a0, Str1
	ecall
	li a7, 1
	lw a0, Z
	ecall
	li a7, 4
	la a0, Str2
	ecall
	li a7, 1
	lw a0, i
	ecall
	li a7, 10
	ecall
	
	
for:
	bgt t1, t2, do #if i>20, leave for loop (go to do)
	addi t1, t1, 2 #each loop, i=i+2
	addi t0, t0, 1 #each loop, Z++
	j for #Weeeeeee I love loops!!!!! So fun!!!!! 
	
do:
	addi t0, t0, 1 #each loop, Z++
	bge t0, t3, while #once Z>=100, leave do loop (go to while)
	#since do loop checks condition after inside is finished, going the test after the incrememnt
	j do

while:
	blez t1, exit #once i <= 0, leave while loop (go to exit)
	sub t0, t0, t4 #each loop, Z--
	sub t1, t1, t4 #each loop, i--
	#since while loop checks at the beginning of the process, test is before increment
	j while

exit: ret