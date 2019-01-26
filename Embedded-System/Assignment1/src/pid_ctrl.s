 	.syntax unified
 	.cpu cortex-m3
 	.thumb
 	.align 2
 	.global	pid_ctrl
 	.thumb_func
@  EE2024 Assignment 1: pid_ctrl(int en, int st) assembly language function
@  CK Tham, ECE, NUS, 2017
pid_ctrl:
@ PUSH the registers you modify, e.g. R2, R3, R4 and R5*, to the stack
@ * this is just an example; the actual registers you use may be different
@ (this will be explained in lectures)
	PUSH	{R2-R5}

@  Write PID controller function in assembly language here
@  Currently, nothing is done and this function returns straightaway

@ POP the registers you modify, e.g. R2, R3, R4 and R5*, from the stack
@ * this is just an example; the actual registers you use may be different
@ (this will be explained in lectures)
	POP	{R2-R5}
 	BX	LR
