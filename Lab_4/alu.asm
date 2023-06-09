.data
.text

main:
	li t0, 0x11223344
	li t1, 0x01234567
	
	#add_sub
	add s0, t0, t1
	sub s1, t0, t1
	
	#shift
	addi t2, zero, 1
	sll a0, t0, t2
	addi t2, zero, 2
	sll a1, t0, t2
	addi t2, zero, 3
	sll a2, t0, t2
	
	addi t2, zero, 1
	srl a3, t0, t2
	addi t2, zero, 2
	srl a4, t0, t2
	addi t2, zero, 3
	srl a5, t0, t2
	
	#and_or
	and a6, t0, t1
	or a7, t0, t1
	
	#addi
	addi s2, t0, 0x00000123
	
	#shifti
	slli s3, t0, 3
	srli s4, t0, 3
	
	#andi_ori
	andi s5, t0, 0x00000123
	ori s6, t0, 0x00000123
	
	li t0, 0x12345678
	li t1, 0x12345678
	sub s7, t0, t1