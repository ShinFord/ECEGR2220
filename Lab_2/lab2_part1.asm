#Lab 2, Part 1

.data
	Z: .word 0
	Str: .asciz "Z = "
.text

main:
	li t0, 15 # int A=15
	li t1, 10 # int B=10
	li t2, 5  # int C=5
	li t3, 2  # int D=2
	li t4, 18 # int E=18
	li t5, -3 # int F=-3
	
	sub t1, t0, t1 # B=A-B
	mul t3, t2, t3 # D=C*D
	sub t5, t4, t5 # F=E-F
	div t2, t0, t2 # C=A/C
	
	add t0, t1, t3 # A=B+D=(A-B)+(C*D)
	sub t1, t5, t2 # B=F-C=(E-F)-(A/C)
	add t0, t0, t1 # A=A+B=(A-B)+(C*D)+(E-F)-(A/C)
	sw  t0,  Z, t6 # Store value of A in Z using temp. register
	
	li a7, 4
	la a0, Str
	ecall
	li a7, 1
	lw a0, Z
	ecall
	li a7, 10
	ecall