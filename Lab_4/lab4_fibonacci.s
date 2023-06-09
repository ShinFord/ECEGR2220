.data
	aIn: .word 3
	bIn: .word 10
	cIn: .word 20
.text

main:
	lw t0, aIn
	lw t1, bIn
	lw t2, cIn
	addi a1, zero, 0
	
	addi sp, sp, -8
	sw ra, 4(sp)
	sw t0, 0(sp)
	addi t3, t0, 0
	jal fibo
	sw a1, aIn, t5
	addi a1, zero, 0
	lw ra, 4(sp)
	lw t0, 0(sp)
	addi sp, sp, 8
	
	addi sp, sp, -8
	sw ra, 4(sp)
	sw t1, 0(sp)
	addi t3, t1, 0
	jal fibo
	sw a1, bIn, t5
	addi a1, zero, 0
	lw ra, 4(sp)
	lw t1, 0(sp)
	addi sp, sp, 8
	
	addi sp, sp, -8
	sw ra, 4(sp)
	sw t2, 0(sp)
	addi t3, t2, 0
	jal fibo
	sw a1, cIn, t5
	addi a1, zero, 0
	lw ra, 4(sp)
	lw t2, 0(sp)
	addi sp, sp, 8
	
	li a7, 10
	ecall
	
fibo:
	addi t6, zero, 1
	ble t3, t6, equalOne
	addi sp, sp, -8
	sw ra, 4(sp)
	sw t3, 0(sp)
	addi t3, t3, -1
	jal fibo
	lw t3, 0(sp)
	sw t3, 0(sp)
	addi t3, t3, -2
	jal fibo
	lw ra, 4(sp)
	lw t3, 0(sp)
	addi sp, sp, 8
	ret
	
equalOne:
	blez t3, equalZero
	addi a1, a1, 1
	ret
	
equalZero:
	addi a1, a1, 0
	ret