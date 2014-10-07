SEGMENT .bss	
	_x resd	1
	_y resd	1
	_z resd	1

SEGMENT .text		
	global main
	extern scan_int, print_endofline, print_int

main:
	push _x
	push _y
	call scan_int
	add esp,4
		
	call scan_int
	add esp,4

	mov eax,0
	add eax,dword[_x]
	add eax,dword[_y]
	mov dword[_z],eax
	
	push dword [_z]
	call print_int
	add esp,4
	
	call print_endofline

