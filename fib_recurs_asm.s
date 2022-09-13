.globl   fib_recurs_asm
    .p2align 2
	.type    fib_recurs_asm,%function

fib_recurs_asm:

check_condition: 	// We will check if x0 is less than 20
	cmp		x0, #20
	ble		condition2
	mov		x0, #-1
	b		end_label

condition2: 		// We will check if x0 is greater than 0
	cmp		x0, #0
	bge		base_condition1
	mov 	x0, #-1
	b		end_label

base_condition1:	// Base condition: If x0 is less than 2 (ie 1 or 0) return itself
	cmp		x0, #2
	bge		loop
	br 		x30

loop:
	// I have drawn it out on paper how it should work, so I find it difficult to explain it in words, but I gave my best.

	sub sp, sp, #32			// We initialized the stack pointer
	str x30, [sp, #32]
	str x0, [sp, #24]		// We will store x30, and x0 as we will need this value to get n-1 and n-2

	// We will subtract 1 from n and pass it to back to itself until it meets the base condition
	sub x0, x0, #1
	bl fib_recurs_asm

	// Now we have the result of (fib_recursive (n - 1) ) so we will store it on the stack
	str x0, [sp, #8]
	ldr x0, [sp, #24]	// We will load the old value and calculate n - 2 then pass it to calculate fib_recursive(n-2)
	sub x0, x0, #2
	bl fib_recurs_asm

	//	We will load the result of fib_rec(n-1) to x10 and add it to the result of fib_rec(n-2)
	ldr x10, [sp, #8]
	add x0, x0, x10

	// Load back to old return address
	ldr x30, [sp, #32]
	add sp, sp, #32

end_label:	// Now we can return x0
	br		x30
