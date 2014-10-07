SEGMENT .bss	
	_x resd	1

SEGMENT .text		
	global main
	extern scan_int, print_endofline, print_int

main:
	push _x
	call scan_int
	add esp,4
		
	push dword [_x]
	call print_int
	add esp,4
	call print_endofline

