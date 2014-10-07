SEGMENT .bss	
	_x resd	1
	_end resd 1
	_size resd 1

SEGMENT .data
	msg db      "Hello, world!",0xa 
	len equ     $ - msg             

SEGMENT .text		
	global main
	extern print_int, print_endofline

main:
	mov dword[_end],0xa
	mov dword[_size],2

	mov dword [_x],8	
	mov eax,8
	add eax,'0'
	mov dword[_x],eax


	mov     edx,_size
    mov     ecx,_x 
    mov     ebx,1   
    mov     eax,4   
    int     0x80    