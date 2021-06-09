start:		mov A, #0
loop:		mov p4,A
			call wait
			inc A
			jmp loop

wait:	mov R5, #0FFh
wait1:	mov R6, #0FFh
wait2:	mov R7, #07h
wait3:	djnz R7, wait3
		djnz R6, wait2
		djnz R5, wait1
		ret

	