#Lab 2, Part 5

.data
	a: .word 0
	b: .word 0
	c: .word 0
	Str: .asciz "c = "
.text

main:
	addi t0, zero, 5 #i=5
	addi t1, zero, 10 #j=10
	addi sp, sp, -8 #allocate 2 element spots for t0, t1
	sw t0, 4(sp) #store i in stack
	sw t1, 0(sp) #store j in stack
	add t2, zero, t0 #n=i
	jal AddItUp #jump to AddItUp (serves as a call)
	sw t1, a, t3 #store function output as a
	
	lw t0, 4(sp) #load stored i value back in t0
	lw t1, 0(sp) #load stored j value back in t1
	add t2, zero, t1 #n=j
	jal AddItUp #jump back to AddItUp
	sw t1, b, t4 #store output as b
	
	lw t0, 4(sp) #load stored i value back in t0
	lw t1, 0(sp) #load stored j value back in t1
	addi sp, sp, 8
	lw t2, a
	lw t3, b
	add t3, t2, t3 #c=a+b
	sw t3, c, t5
	
	li a7, 4
	la a0, Str
	ecall
	li a7, 1
	lw a0, c
	ecall
	li a7, 10
	ecall

AddItUp:
	addi t0, zero, 0 #i=0
	addi t1, zero, 0 #x=0
	j for

for:
	bge t0, t2, exit #if i>=n, leave for loop
	add t1, t1, t0 #x=x+i
	addi t1, t1, 1 #x=x+1
	addi t0, t0, 1 #i++
	j for
	
exit:
	ret
	