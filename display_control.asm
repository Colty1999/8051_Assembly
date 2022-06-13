;program przesyla dane umieszczone pod adresem 70h w pamiecie wewnetrznej danych
;presylanie odbywa sie w trybie 4 bitowym
	RS 	EQU 	P3.7	;0- instrukcje 	1- dane
	RW 	EQU 	P3.6	;0- zapis	1-odczyt
	E 	EQU 	P3.5	;odczyt danych nastepuje na zboczu opadajacym pojawiajacym sie na wejsiu E
	DANE 	EQU 	70h	;adres spod ktorego dane sa przesylane do wyswietlacza
	X	EQU	71h	;adres wspolrzednej w osi X
	Y	EQU	72h	;adres wspolrzednej w osi Y	

org 0000h
	ljmp 	start

org 0100h
init_db: 	DB 01h, 02h, 06h, 0Eh, 02h, 80h, 00h

org 0150h
text_to_write: DB ' Podstawy Techniki Mikroprocesorowej '

start:	mov 	DPTR, 	#init_db
	clr 	RW
	clr 	RS
	setb 	E
	mov 	P3, 	#00100010b
	clr 	E
	setb 	E
init:	clr 	A
	movc 	A, 	@A+DPTR
	jz 	next
	inc 	DPTR
	mov 	dane, 	A
	LCALL 	send_data
	jmp 	init
	
next:
	mov DPTR, #text_to_write
	
	mov B, #80h
	mov A, #00h
	lcall display
	mov B, #81h
	mov A, #01h
	lcall display
	mov B, #82h
	mov A, #02h
	lcall display
	mov B, #83h
	mov A, #03h
	lcall display
	mov B, #84h
	mov A, #04h
	lcall display
	mov B, #85h
	mov A, #05h
	lcall display
	mov B, #86h
	mov A, #06h
	lcall display
	mov B, #87h
	mov A, #07h
	lcall display
	mov B, #88h
	mov A, #08h
	lcall display
	mov B, #89h
	mov A, #09h
	lcall display
	mov B, #8Ah
	mov A, #0Ah
	lcall display
	mov B, #8Bh
	mov A, #0Bh
	lcall display
	mov B, #8Ch
	mov A, #0Ch
	lcall display
	mov B, #8Dh
	mov A, #0Dh
	lcall display
	mov B, #8Eh
	mov A, #0Eh
	lcall display
	mov B, #8Fh
	mov A, #0Fh
	lcall display
	

loop:	ljmp 	loop

				;procedura wysylajaca do wyswietlacz dwa polbajty: najpierw starszy potem mlodszy

display:
	clr RS
	clr RW
	setb E
	mov dane, B
	LCALL send_data
	clr E
	setb RS
	movc A,	@A+DPTR
	mov dane, A
	LCALL send_data
	clr RS
	RET
	
send_data:
	push 	ACC
	mov 	A, 	#0F0h
	anl 	P3, 	A
	anl 	A, 	dane
	swap 	A
	setb 	E
	orl 	P3, 	A
	clr 	E
	mov 	A, 	#0F0h
	anl 	P3, 	A
	swap 	A
	anl 	A, 	dane
	setb 	E
	orl 	P3, 	A
	clr 	E
	pop 	ACC
	RET
END
