SEGMENT .bss	
	_x resd	1


SEGMENT .text		
	global main
	extern print_int	
	
main:
	
	mov dword [_x],8	
	push dword [_x]
	call print_int
	add esp,4
	call print_endofline
