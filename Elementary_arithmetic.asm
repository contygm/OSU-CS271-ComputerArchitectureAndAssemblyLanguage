;//Author: Xavier Hollingsworth
;//Course: CS271							Date: 9/03/2017
;//Description: This program takes 2 integers input from the user and calculates the sum, difference, product, quotient, and remainder.

INCLUDE C:\Irvine\Irvine32.inc


.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode: DWORD

.data
	programTitle BYTE "Elementary Arithmetic	", 0
	programName BYTE "		by Xavier Hollingsworth", 0
	instructions BYTE "Enter 2 numbers, and I will show you the sum, difference, product, quotient, and remaineder.", 0
	prompt1 BYTE "First number: ", 0
	prompt2 BYTE "Second number: ", 0
	goodbyePrompt BYTE "Impressed? Goodbye.", 0
	warningPrompt BYTE "The second number must be less than the first!", 0
	loopbackPrompt BYTE "Enter '1' to run the program again. Otherwise enter any other integer to quit.", 0
	ec1Prompt BYTE "**EC1: Program repeats until user chooses to quit by entering any integer other than one.", 0
	ec2Prompt BYTE "**EC2: Program verifies second number is less than the first number.", 0

	value1 DWORD ?
	value2 DWORD ?

	equalsString BYTE " = ", 0
	sum DWORD ?
	sumString BYTE " + ", 0
	difference DWORD ?
	differenceString BYTE " - ", 0
	product DWORD ?
	productString BYTE " * ", 0
	quotient DWORD ?
	quotientString BYTE " / ", 0
	remainder DWORD ?
	remainderString BYTE " remainder ", 0

.code

main PROC
;//Program information display
	mov edx, OFFSET programTitle
	call WriteString
	mov edx, OFFSET programName
	call WriteString
	call CrLf
	mov edx, OFFSET ec1Prompt
	call WriteString
	call CrLf
	mov edx, oFFSET ec2Prompt
	call WriteString
	call CrLf
	call CrLf



;//Introduction : Gets the first and second integer from the user and jumps if the second number is not less than the first

	mov edx, OFFSET instructions
	call WriteString
	call CrLf
	call CrLf

top : ;//gets 2 integers from user

	mov edx, OFFSET prompt1	;//gets first number
	call WriteString
	call ReadInt
	mov value1, eax

	mov edx, OFFSET prompt2	;//gets second number
	call WriteString
	call ReadInt
	mov value2, eax

;//Compares first number to second and jumps to warning if second number is greater
	mov eax, value2
	cmp eax, value1
	jge Warning
	jl Calculate

Warning : ;//Displays warning message
	mov edx, OFFSET warningPrompt
	call WriteString
	call CrLf
	jmp top


Calculate : ;//Calculates elementary arithemetic

;//Calculate sum
	mov eax, value1
	add eax, value2
	mov sum, eax
;//Calculate difference
	mov eax, value1
	sub eax, value2
	mov difference, eax
;// Calculate product
	mov eax, value1
	mov ebx, value2
	mul ebx
	mov product, eax
;//Calculate quotient
	mov edx, 0
	mov eax, value1
	mov ebx, value2
	div ebx
	mov quotient, eax
	mov remainder, edx

;//Display the results

;//Sum results
	mov eax, value1
	call WriteDec
	mov edx, OFFSET sumString
	call WriteString
	mov eax, value2
	call WriteDec
	mov edx, OFFSET equalsString
	call WriteString
	mov eax, sum
	call WriteDec
	call CrLf
;//Difference results
	mov eax, value1
	call WriteDec
	mov edx, OFFSET differenceString
	call WriteString
	mov eax, value2
	call WriteDec
	mov edx, OFFSET equalsString
	call WriteString
	mov eax, difference
	call WriteDec
	call CrLf
;//Product results
	mov eax, value1
	call WriteDec
	mov edx, OFFSET productString
	call WriteString
	mov eax, value2
	call WriteDec
	mov edx, OFFSET equalsString
	call WriteString
	mov eax, product
	call WriteDec
	call CrLf
;//Quotient results
	mov eax, value1
	call WriteDec
	mov edx, OFFSET quotientString
	call WriteString
	mov eax, value2
	call WriteDec
	mov edx, OFFSET equalsString
	call WriteString
	mov eax, quotient
	call WriteDec
	mov edx, OFFSET remainderString
	call WriteString
	mov eax, remainder
	call WriteDec
	call CrLf

	jmp LoopBack




LoopBack : ;//Gives user ability to decide whether to run program again or quit. If user enters 1 it loops back.
	mov edx, OFFSET loopbackPrompt
	call WriteString
	call ReadInt
	cmp eax, 1
	je top

;//Say goodbye
	mov edx, OFFSET goodbyePrompt
	call WriteString
	call CrLF
	exit




INVOKE ExitProcess, 0
main ENDP
END main