CLK EQU P0.1
DQ  EQU P0.2
RST EQU P0.0

ORG 0000h
	ljmp start

ORG 0100h
start:

	;read temp
	clr RST
	clr DQ
	clr CLK
	mov A, #0AAh
	lcall command
	lcall read

	;read TH
	clr RST
	clr DQ
	clr CLK
	mov A, #0A1h
	lcall command
	lcall read

	;write TH
	clr RST
	clr DQ
	clr CLK
	mov A, #001h
	lcall command
	lcall write

	;read TL
	clr RST
	clr DQ
	clr CLK
	mov A, #0A2h
	lcall command
	lcall read

	;write TL
	clr RST
	clr DQ
	clr CLK
	mov A, #002h
	lcall command
	lcall write

	ljmp start

command:
	mov R0, #8d
	setb CLK
	setb RST

send:
	clr CLK
	rrc A
	mov DQ, C
	setb CLK
	DJNZ R0, send
	ret

read:
	mov R7, #0d
	mov R0, #8d
	clr A
	clr C

read_while:
	rrc A
	clr CLK
	jnb DQ, read_next
	setb A.7

read_next:
	setb CLK
	clr C
	DJNZ R0, read_while

	mov R6,A
	clr CLK
	jb DQ, sign
	ret

sign:
	mov R7,#1d
	ret

write:
	mov R0, #8d
	mov A, R6
	setb CLK
	setb RST

write_while:
	clr CLK
	rrc A
	mov DQ, C
	setb CLK
	DJNZ R0, write_while
	clr C
	mov A,R7
	jnb A.0,else
	clr CLK
	setb DQ
	setb CLK

else:
	clr CLK
	clr DQ
	setb CLK
	ret

END