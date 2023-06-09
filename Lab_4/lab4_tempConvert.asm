.data
	userInput: .asciz "Input Fahrenheit: "
	celsiusOut: .asciz "Celsius value is: "
	kelvinOut: .asciz "Kelvin value is: "
	returnLine: .asciz "\r\n "
	CtoK: .float 273.15
	Fsub: .float 32.0
	Fmult: .float 5.0
	Fdiv: .float 9.0
	Cout: .float 0.0
	Kout: .float 0.0
.text

main:
	flw ft1, CtoK, t0
	flw ft2, Fsub, t0
	flw ft3, Fmult, t0
	flw ft4, Fdiv, t0
	
	li a7,4
	la a0, userInput
	ecall
	li a7, 6
	ecall
	fmv.s ft5, fa0
	
	jal cConvert
	fmv.s fa0, ft5
	li a7, 4
	la a0, celsiusOut
	ecall
	li a7, 2
	ecall
	li a7, 4
	la a0, returnLine
	ecall
	
	jal kConvert
	fmv.s fa0, ft5
	li a7, 4
	la a0, kelvinOut
	ecall
	li a7, 2
	ecall
	li a7, 4
	la a0, returnLine
	
	li a7, 10
	ecall
	
	
cConvert:
	fsub.s ft5, ft5, ft2
	fmul.s ft5, ft5, ft3
	fdiv.s ft5, ft5, ft4
	fsw ft5, Cout, t0
	ret

kConvert:
	fadd.s ft5, ft5, ft1
	fsw ft5, Kout, t0
	ret