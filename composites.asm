;Author: Xavier Hollingsworth
;Course: CS271						Date: 10/26/17
;Description: This program calculates composite numbers

INCLUDE C:\Irvine\Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

;//Program strings
ecString BYTE "Extra-credit option 1: Align the ouput columns.", 0
programTitle BYTE "Composite Numbers", 0
programmer BYTE "by Xavier Hollingsworth", 0
prompt1 BYTE "Enter the number of composite numbers you would like to see. I will accept up to 400 composite numbers", 0
prompt2 BYTE "Enter the number of composites to display from 1 to 400: ", 0
smallError BYTE "The number you entered was too small. Try again.", 0
bigError BYTE "The number you entered was too big. Try again.", 0
goodbyePrompt BYTE "Results certified by Xavier Hollingsworth. Goodbye for now :)", 0
 


;//Variables
tabsp BYTE 9,0
number DWORD ? ;//Value that we are checking to see if it is composite
divisor DWORD ?	;//Value that number is being divided by
userValue DWORD ?	;//Value entered by user

;//Constants
MIN = 1
MAX = 400

;//Set text color
textColor DWORD 11
bgColor DWORD 0

.code

main proc

	call changeColor
	call introduction
	call getUserData
	call showComposites
	call farewell
	exit

main endp

;//Sets the text color to teal and background to black
changeColor PROC
	mov eax, bgColor
	imul eax, 16
	add eax, textColor
	call setTextColor
	ret
changeColor ENDP

;//Displays introductory strings
introduction PROC
	mov edx, OFFSET programTitle
	call WriteString
	mov edx, OFFSET tabsp 
	call WriteString
	mov edx, OFFSET programmer
	call WriteString
	call CrLf
	mov edx, OFFSET ecString
	call WriteString
	call CrLf
	call CrLf
	mov edx, OFFSET prompt1
	call WriteString
	call CrLf
	ret
introduction ENDP

getUserData PROC
	;//Retrieves users input and makes sure it is in the necessary range needed
	numberLoop:
				
				mov edx, OFFSET prompt2
				call ReadInt
				call CrLf
				mov userValue, eax
				cmp eax, MIN
				jb minError
				cmp eax, MAX
				ja maxError
				jmp next
	
	;//Displays an error message if the user entered a value that is too small
	minError:
				mov edx, OFFSET smallError
				call WriteString
				call CrLf
				jmp numberLoop

	;//Displays an error message if the user entered a value that is too big
	maxError:
				mov edx, OFFSET bigError
				call WriteString
				call CrLf
				jmp numberLoop

	next:
		mov ecx, userValue ;//Sets the loop count equal to the value entered by the user
				
		ret

getUserData ENDP

showComposites PROC
	;// First part skips 1, 2, and 3 and gets ready to display integer 4 first
	mov eax, 4
	mov divisor, 2
	mov ebx, divisor
	mov edx, 0
	div ebx
	cmp edx, 0
	je isComposite1


	;//First subroutine that sets the divisor to 2
	top1:
		cmp ecx, 0
		je exitLoop
		mov divisor, 2
		mov ebx, divisor
		mov eax, number
		mov edx, 0
		div ebx
		cmp edx, 0
		je isComposite2
		jmp top2
	;//Second subroutine that increments the divisor so it equals 3 and checks if the number is composite, if not it jumps to top3
	top2:
		inc divisor
		mov eax, number
		cmp eax, divisor
		je incrementNumber ;//If this jump happens it means the number is prime
		mov edx, 0
		mov ebx, divisor
		div ebx
		cmp edx, 0
		je isComposite2
		jmp top3

	;//Subroutine that increments divisor by 2 so it only checks for odd numbers since the number was already checked if it was divisible by an even number (i.e. 2) in top1
	top3:
		add divisor, 2
		mov eax, number
		cmp eax, divisor
		je incrementNumber
		mov edx, 0
		mov ebx, divisor
		div ebx
		cmp edx, 0
		je isComposite2
		jmp top3

	;//displays 4 as the first composite number and then sets up the next composite number 6
	isComposite1:
		mov eax, 4
		call WriteDec
		mov edx, OFFSET tabsp
		call WriteString 
		mov number, 6
		mov eax, number
		loop isComposite2

	;//displays composite numbers, reduces the loop count and increments the number being tested
	isComposite2:
		
		mov eax, number
		call WriteDec
		mov edx, OFFSET tabsp
		call WriteString 
		inc number
		loop top1

	;//increments the number (subroutine used to skip prime numbers)
	incrementNumber:
		inc number
		jmp top1

	;//When it reaches here the loop count = 0 
 	exitLoop:
	mov edx, OFFSET tabsp
	call WriteString
	call CrLf

	ret
showComposites ENDP

;//Displays goodbye prompt
farewell PROC
	call CrLf
	mov edx, OFFSET goodbyePrompt
	call WriteString
	call CrLf
	ret
farewell ENDP

end main