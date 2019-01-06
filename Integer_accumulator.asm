;//Author: Xavier Hollingsworth
;//Course: CS271							Date: 10/17/2017
;//Description: This program counts and displays the sum and average of valid user entered numbers (negative numbers only).

INCLUDE C:\Irvine\Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

.data

;//Program strings
programmerName BYTE "by Xavier Hollingsworth", 0
programTitle BYTE "Welcome to the Integer Accumulator " ,0
userNamePrompt BYTE "What is your name?", 0
helloString BYTE "Hello, ", 0
userPrompt1 BYTE "Please enter numbers in [-100, -1]. ", 0
userPrompt2 BYTE "Enter a non-negative number when you are finished to see the results.", 0
enterNumberString BYTE "Enter number: ", 0
countString BYTE "You entered ", 0
countString2 BYTE " valid numbers.", 0
sumString BYTE "The sum of your valid numbers is ", 0
averageString BYTE "The rounded average is ", 0
thankyouString BYTE "Thank you for playing the Integer Accumulator. Have a nice day, ", 0
ecprompt3 BYTE "Extra-credit option 3: Do something astoundingly creative like set the color scheme to homebrew (everybody's favorite).", 0

;//User Name Input
userName BYTE  24 DUP (0)
userSize DWORD ?


;//No negative numbers entered message
noEntryString BYTE "You did not enter a negative integer. I guess you don't want to play my game :(", 0

;//Set Text Color
textColor DWORD 2
bgColor DWORD 0

;//Variables
count DWORD 1
sum DWORD 0
tabsp BYTE 9,0
average DWORD 0
remainder DWORD ?

;//Constants
MIN = -100
MAX = -1

.code
main PROC

;//Set text and background color to homebrew scheme :)
mov eax, bgColor
imul eax, 16
add eax, textColor
call setTextColor

;//Display program information
mov edx, OFFSET programTitle
call WriteString
mov edx, OFFSET programmerName
call WriteString
call CrLf
mov edx, OFFSET ecprompt3
call WriteString
call CrLf

;//Retrieve and display the user's name and prompt
mov edx, OFFSET userNamePrompt
call WriteString
mov edx, OFFSET tabsp
call WriteString
mov edx, OFFSET userName
mov ecx, SIZEOF userName
call ReadString
call CrLf
mov userSize, eax
mov edx, OFFSET helloString
call WriteString
mov edx, OFFSET userName
call WriteString
call CrLf

;//Displays program instructions - asks user for integer input
mov eax, 0
mov edx, OFFSET userPrompt1
call WriteString
call CrLf
mov edx, OFFSET userPrompt2
call WriteString
call CrLf

	
;//Loop designed to allow user to keep entering number
getNumbers:
	mov eax, count
	add eax, 1
	mov count, eax
	mov edx, OFFSET enterNumberString
	call WriteString
	call ReadInt
	cmp eax, MIN
	jl summation
	cmp eax, MAX
	jg summation
	add eax, sum
	mov sum, eax
	loop getNumbers

;//Function to accumulate the numbers entered (sum)
summation:
	;//Test to see if a negative number was entered, jumps to unique message if no valid integers were input
	mov eax, count
	sub  eax, 2
	jz noEntry
	mov eax, sum
	call CrLf

	;//Displays the number of negative integers entered
	mov edx, OFFSET countString
	call WriteString
	mov eax, count
	sub eax, 2
	call WriteDec
	mov edx, OFFSET countString2
	call WriteString
	call CrLf

	;//Displays sum
	mov edx, OFFSET sumString
	call WriteString
	mov eax, sum
	call WriteInt
	call CrLf	

	;//Displays and calculates average
	mov edx, OFFSET averageString
	call WriteString
	mov eax, 0
	mov eax, sum
	cdq
	mov ebx, count
	sub ebx, 2
	idiv ebx
	mov average, eax
	call WriteInt
	call CrLf
	jmp theEnd



;//Displays unique message when user doesn't enter any negative integers
noEntry:
	mov edx, OFFSET noEntryString
	call WriteString

;//Displays goodbye message
theEnd:
	call CrLf
	mov edx, OFFSET thankYouString
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	call CrLf
	
	invoke ExitProcess,0

main endp
end main