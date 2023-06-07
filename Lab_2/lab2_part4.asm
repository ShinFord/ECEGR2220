#Lab 2, Part 4

.data
	A: .word 0,0,0,0,0
	B: .word 1,2,4,8,16
.text

main:
	la t0, A
	la t1, B
	addi t2, zero, 0 #i=0
	addi t3, zero, 5 #t3=5
	jal for
	li a7, 10
	ecall
	
for:
	bge t2, t3, middle #if i>=5, leave for loop
	lw t4, 0(t1) #set t4 to B[i]
	addi t4, t4, -1 #t4=t4-1
	sw t4, 0(t0) #set A[i] to t4
	addi t1, t1, 4 #offset by 1 place
	addi t0, t0, 4 #offset by 1 place
	addi t2, t2, 1 #each loop, i++
	j for

middle:
	addi t2, t2, -1 #i--
	addi t0, t0, -4
	addi t1, t1, -4
	j while

while:
	bltz t2, exit #once i<0, leave while loop
	addi t2, t2, -1 #each loop, i--
	lw t5, 0(t0) #set t5 to A[i]
	lw t6, 0(t1) #set t6 to B[i]
	add t5, t5, t6 #t5=A[i]+B[i]
	slli t5, t5, 1 #t5=t5*2
	sw t5, 0(t0) #A[i]=t5
	addi t0, t0, -4
	addi t1, t1, -4
	j while

exit:   
	ret
	
	
	