section .bss	
	_x resd	1

section .data
	_par db 2
	_impar db 1
section .text		
	global main
	extern scan_int, print_endofline, print_int

main:
	push _x
	call scan_int
	add esp,4


		
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

