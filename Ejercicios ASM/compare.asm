section .bss	
	_x resd	1
	_par resd 1
	_impar resd 1

section .text		
	global main
	extern scan_int, print_endofline, print_int

main:


	mov dword[_par],2
	mov dword[_impar],1
	push _x
	call scan_int
	add esp,4
	mov ecx,2

	mov eax,2
	mov edx,0
	div dword[_x]
	test edx,0
	jnz impar
		
	push dword [_par]
	call print_int
	add esp,4
	jmp end

impar:
	push dword [_impar]
	call print_int
	add esp,4

end:
	call print_endofline

	ret

