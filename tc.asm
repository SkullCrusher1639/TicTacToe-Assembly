.model small
.stack 100h
.386

.data
	board db "123",
			 "456",
		     "789",
	
	str_welcome db "Welcome to TicTacToe written in Assembly",10,13,
					"The game is played with 2 players",10,13,
					"1st player has symbol X and 2nd player has symbol O",10,13,
					"Let's Start",10,13,10,13,"$"
	str_Tie db 10,13,"Its a tie, Great Game BTW$"
	str_turn1 db "Its Player "
	current_symbol db "X"
	str_turn2 db " Turn",10,13,"$"
	str_place db "Enter number to select position: $"
	str_err db 10,13,"Invalid Input",10,13,"$"
	turn_count db 0	  
.code 
main proc
	mov ax,@data
	mov ds,ax
	mov es,ax
	
	mov dx,offset str_welcome
	call print_str
	
	;initial board printing
	call print_board
	mov cx,9
board_disp:	
	call new_line
	; players turn
	mov dx, offset str_turn1
	call print_str
	
	; take input of position
	call input_position
	mov bl,al
	call new_line
	call new_line
	call set_symbol
	
	; print board with symbols
	call print_board
	call change_symbol
	; loop until board is filled i,e 9 times
	loop board_disp
	; if its a tie
	mov dx, offset str_Tie
	call print_str
	jmp exit
	
exit:
mov ah,4ch
int 21h
main endp


; prints the whole board of the game
print_board proc
	push cx
	mov si, offset board
	mov cx,3
row:call print_line
	loop row
	pop cx
	ret
print_board endp


; prints each row of the board
print_line proc
	mov dl,[si]
	call print_char
	inc si
	
	mov dl,' '
	call print_char
	mov dl,'|'
	call print_char
	mov dl,' '
	call print_char
	
	mov dl,[si]
	call print_char
	inc si
	
	mov dl,' '
	call print_char
	mov dl,'|'
	call print_char
	mov dl,' '
	call print_char
	
	mov dl,[si]
	call print_char
	inc si
	
	call new_line
	ret
print_line endp


; changes current player i.e current symbol
change_symbol proc
	cmp current_symbol,"X"
	je change_to_o
	mov current_symbol,"X"
	jmp changed
change_to_o:
	mov current_symbol,"O"
changed:
	ret
change_symbol endp


; set symbol on selected area
set_symbol proc
	push si
	mov bh,0
	mov si, offset board
	add si,bx
	mov bl,current_symbol
	mov [si],bl
	pop si
	ret
set_symbol endp


; moves to newline
new_line proc
	mov dl,10
	call print_char
	
	mov dl,13
	call print_char
	ret
new_line endp


; prints any character in dl
print_char proc
	mov ah,02
	int 21h
	ret
print_char endp


; prints string with offset in dx
print_str proc
	mov ah,09
	int 21h
	ret
print_str endp


; takes character input for position
input_position proc
	push si
	jmp input_start
input_err:
	mov dx, offset str_err
	mov ah,09
	int 21h
input_start:
	mov dx, offset str_place
	call print_str
	mov ah,01
	int 21h
	sub al,48
	cmp al,9
	ja input_err
	dec al
	lea si, board
	mov ah,0
	add si,ax
	mov ah,[si]
	cmp ah,'O'
	jge input_err
	pop si
	ret
input_position endp
end main
	