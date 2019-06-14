;//Author: Xavier Hollingsworth							Date: 10/13/2017
;//Description: This program calculates and displays all of the numbers in a Fibonacci sequence with an integer entered by a user within a certain range.

INCLUDE C:\Irvine\Irvine32.inc


.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode: DWORD

.data
	;//Program information
	programTitle BYTE "Fibonacci Analysis	", 0
	programName BYTE "		Programmed by Xavier Hollingsworth", 0
	getName BYTE "Please enter your name: ", 0
	greeting BYTE "Hello, ", 0
	ec_prompt1 BYTE "Extra-credit Option 2: Do something incredible like change the text color!", 0
	ec_prompt2 BYTE "Extra-credit Option 1: Display the numbers in aligned columns - Numbers are alligned by a tab character.", 0
	goodbyePrompt BYTE "Results certified by Xavier Hollingsworth.", 0
	goodbye BYTE "Goodbye, ", 0
	
	;//Program Instructions
	prompt1 BYTE "Enter the number of Fibonacci terms to be displayed. Give the number as an integer in the range [1 .. 46].", 0
	fibonacciValue DWORD ?
	tabsp   BYTE   9,0    ;prints [tab]

	;//Program Calculations
	fibonacciOne BYTE "1", 0
	fibonacciTwo BYTE "1		1", 0
	num1 DWORD ?
	num2 DWORD ?
	modulus DWORD 5
	temp DWORD ?

	;//Input Validation
	tooHigh BYTE "The number you entered is too high, please enter an integer 46 or below.", 0
	tooLow BYTE "The number you entered is too low, please enter an integer 1 or above.", 0
	
	;//User's name input
	userName BYTE  24 DUP (0)
	userSize DWORD ?


	;//Set text color
	textColor DWORD 2
	bgColor DWORD 0

.code

main PROC
;//Set text and background color
	mov eax, bgColor
	imul eax, 16
	add eax, textColor
	call SetTextColor
;//Program information display
	mov edx, OFFSET programTitle
	call WriteString
	mov edx, OFFSET programName
	call WriteString
	call CrLf
	mov edx, OFFSET ec_prompt1
	call WriteString
	call CrLf
	mov edx, OFFSET ec_prompt2
	call WriteString
	call CrLf

;//Retrieve and display username
	mov edx, OFFSET getName
	call WriteString
	call CrLf
	mov edx, OFFSET userName
	mov ecx, SIZEOF userName
	call ReadString
	mov userSize, eax
	mov edx, OFFSET greeting
	call WriteString
	mov edx, OFFSET userName
	call WriteString 
	call CrLf
	

;//Displays program instructions - asks user for integer input
top:
	mov eax, 0
	mov edx, OFFSET prompt1
	call WriteString
	call CrLf
	call ReadInt
	mov fibonacciValue, eax


	cmp eax, 46
	jg highError
	cmp eax, 1
	jl lowError
	je fibOne
	cmp eax, 2
	je fibTwo
	

	
;//Display Fibonacci Sequence 
	mov ecx, fibonacciValue
	sub ecx, 3
	mov eax, 1
	call WriteDec
	mov  edx, OFFSET tabsp
	call WriteString
	call WriteString
	call WriteDec
	mov edx, OFFSET tabsp
	call WriteString
	call WriteString
	mov num1, eax
	mov eax, 2
	call WriteDec
	mov edx, OFFSET tabsp
	call WriteString
	call WriteString
	mov num2, eax
	

;//Uses temp variable to hold a value and add the two previous numbers
fibSequence:
	add eax, num1
	call WriteDec
	mov edx, OFFSET tabsp
	call WriteString
	call WriteString
	mov temp, eax
	mov eax, num2
	mov num1, eax
	mov eax, temp
	mov num2, eax
	mov edx, ecx
	cdq
	div modulus
	cmp edx, 0
	jne newLine
	call CrLf
newLine:
	mov eax, temp
	loop fibSequence
	jmp theEnd



;//Error messages for user input
highError:
	mov edx, OFFSET tooHigh
	call WriteString
	call CrLf
	jmp top

lowError:
	mov edx, OFFSET tooLow
	call WriteString
	call CrLf
	jmp top

;//Scenarios for user input of 1 or 2	
fibOne:
	mov edx, OFFSET fibonacciOne
	call WriteString
	call CrLf
	jmp theEnd
	
fibTwo:
	mov edx, OFFSET fibonacciTwo
	call WriteString
	call CrLf
	jmp theEnd

;//Displays goodbye prompt
theEnd:
	call CrLf
	mov edx, OFFSET goodbyePrompt
	call WriteString
	call CrlF
	mov edx, OFFSET goodbye
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	call CrLf

	invoke ExitProcess, 0
main endp
end main
