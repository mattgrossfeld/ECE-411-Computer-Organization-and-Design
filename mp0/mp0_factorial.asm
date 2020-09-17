;	This code gets the factorial of 5. 
;	It uses R1 to hold the initial number we want a factorial of.
;	R3 holds the final value (the factorial)
ORIGIN 4x0000
	
SEGMENT  CodeSegment:
	;; R0 is assumed to contain zero, because of the construction
	;; of the register file.  (After reset, all registers contain
	;; zero.)

	LDR  R1, R0, NUMBER	; R1 <= number we want factorial of (5)
	LDR  R2, R0, ONE	; R2 <= 1
	LDR  R3, R0, NEG_ONE  	; R3 <= -1
	LDR  R6, R0, ZERO	; R6 <= 0

LOOP1:	; big loop for computing the factorial.
	AND R5, R5, R6		; R5 <= 0
	ADD R5, R5, R1		; R5 = R1 (the number we are getting factorial of.)
	AND R4, R4, R6		; R4 <= -1

; MULT loop will increment the value in R4 so that we can get the product.
; R5 is decremented so we can properly get the value.
MULT:	;Multiplication loop
	ADD R4, R4, R2		; R4 <= R4 + 1
	ADD R5, R5, R3		; R4 <= R4 + (-1)
	BRp MULT
;Clear R2 to store the product.
	AND R2, R2, R6		; R2 <= 0.
	ADD R2, R2, R4		; R2 <= R2 + R4
	ADD R1, R1, R3		; R1 <= R1 + R3
	BRp LOOP1		; Loop until done.

HALT:				   ; Infinite loop to keep the processor
	BRnzp HALT		  ; from trying to execute the data below.
						; Your own programs should also make use
						; of an infinite loop at the end.
NUMBER:		DATA2 4x0005
ONE:		DATA2 4x0001
NEG_ONE:	DATA2 4xFFFF
ZERO:		DATA2 4x0000
