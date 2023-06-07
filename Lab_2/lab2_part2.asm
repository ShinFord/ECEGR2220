#Lab 2 Part 2

.data
	A: .word 15
	B: .word 15
	C: .word 10
	Z: .word 0
	Str: .asciz "Z = "
.text

main:
	lw s1, A
	lw s2, B
	lw s3, C
	lw s4, Z
	jal maths
	sw s4, Z, t3
	li a7, 4
	la a0, Str
	ecall
	li a7, 1
	lw a0, Z
	ecall
	li a7, 10
	ecall
	
maths:
	blt s1, s2, zIsOne #if A<B, branch to zIsOne
	bgt s1, s2, zIsTwo #if A>B, branch to zIsTwo
	j zIsThree #if A=B, branch to zIsThree
	
	zIsOne:
	addi t0, t0, 5
	bleu s3, t0, case3 #if C=<5, branch to case3
	addi s4, s4, 1
	j cases
	
	zIsTwo:
	addi s4, s4, 2
	j cases
	
	zIsThree:
	addi t0, s3, 1 #t0=C+1
	addi t1, t1, 7
	beq t0, t1, case2 #if t0=C+1=7, branch to case2
	addi s4, s4, 3
	
	cases:
	addi t0, zero, 1
	addi t1, zero, 2
	addi t2, zero, 3
	beq s4, t0, case1 #this logic can be cut down immensely if I were
	beq s4, t1, case2 #to just set s4 to the corresponding negative value
	beq s4, t2, case3 #but this is more in the spirit of the origical code.
	j default
	
	case1:
	addi s4, zero, -1
	ret
	
	case2:
	addi s4, zero, -2
	ret
	
	case3:
	addi s4, zero, -3
	ret
	
	default:
	addi s4, zero, 0
	ret