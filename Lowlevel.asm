;Author: Xavier Hollingsworth				Date:11/31/2017
;Description: This program fills an array with 10 user entered integers and
;then displays the integers, their sum, and their average.

INCLUDE C:\Irvine\Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

;-------------------------------------------------------------------------
;getString MACRO
;Displays prompt to user to get keyboard input into memory location.
;Receives:
;Returns: N/A
;Preconditions:
;Registers changed: edx, ecx
;-------------------------------------------------------------------------
getString MACRO promptString, input, maxStringInput
	push edx
	push ecx
	mov edx, promptString
	call WriteString
	mov edx, input
	mov ecx, maxStringInput
	call ReadString
	pop ecx
	pop edx
ENDM

;-------------------------------------------------------------------------
;displayString MACRO
;Displays string stored in memory
;Receives:String address
;Returns: N/A
;Preconditions:String must be passed as offset
;Registers changed: edx
;-------------------------------------------------------------------------
displayString MACRO string
	push edx
	mov edx, string
	call WriteString
	pop edx
ENDM

.data

;//Program strings
tabsp BYTE 9, 0
programTitle BYTE "Low-Level I/O Procedures", 0
programmer BYTE "Programmed by Xavier Hollingsworth", 0
description BYTE "Please provide 10 unsigned decimal integers.", 13, 10
			BYTE "Each number needs to be small enough to fit inside a 32 bit register.", 13, 10
			BYTE "After you have finished inputting the raw numbers I will display a list", 13, 10
			BYTE "of the integers, their sum, and their average value.", 0
numberString BYTE "Please enter an unsigned number: ", 0
invalidString BYTE "ERROR: You did not enter an unsigned number or your number was too big.", 0
tryAgain BYTE "Please try again: ", 0
enteredString BYTE "You entered the following numbers:", 0
sumString BYTE "The sum of these numbers is: ", 0
averageString BYTE "The average is: ", 0
commaString BYTE ", ", 0
farewellString BYTE "Results certified by Xavier Hollingsworth. Thanks for playing! Goodbye.", 0

;//Variables
array DWORD 10 DUP(?)
arrayString BYTE 2 DUP(?)

;//Set text color
textColor DWORD 11
bgColor DWORD 0

.code
main proc
	call changeColor
	push OFFSET programTitle
	push OFFSET programmer
	push OFFSET description
	call introduction
;//Gets numbers from user and stores in array
	push OFFSET array
	push LENGTHOF array
	push OFFSET numberString
	push OFFSET tryAgain
	push OFFSET invalidString
	call getData
;//Displays the integer list
	push OFFSET arrayString
	push OFFSET array
	push LENGTHOF array
	push OFFSET enteredString
	push OFFSET commaString
	call displayList
;//Displays the sum and average
	push OFFSET arrayString
	push OFFSET array
	push LENGTHOF array
	push OFFSET sumString
	push OFFSET averageString
	call sumAverage

;//Displays farewell message
	push OFFSET farewellString
	call farewell
	exit
main endp

;---------------------------------------------------
changeColor PROC
;Sets background and text color
;Receives: Nothing
;Returns: Nothing
;Preconditions: None
;Registers changed: None
;---------------------------------------------------
	mov eax, bgColor
	imul eax, 16
	add eax, textColor
	call setTextColor
	ret
changeColor ENDP

;---------------------------------------------------
introduction PROC
;Introduction for program and programmer
;Receives: Nothing
;Returns: Nothing
;Preconditions: None
;Registers changed: n/a
;---------------------------------------------------
	pushad
	mov ebp, esp
	mov edx, [ebp + 44]
	displayString edx
	call CrLf
	mov edx, [ebp + 40]
	displayString edx
	call CrLf
	call CrLf
	mov edx, [ebp + 36]
	displayString edx
	call CrLf
	call CrLf
	popad
	ret 12
introduction ENDP

;---------------------------------------------------
getData PROC 
;Retrieves user input and checks to make sure it is a valid number
;Receives: [ebp+52] = [array], [ebp+48] = LENGTHOF array, [ebp+44] = numberString, [ebp+40] = tryAgain, [ebp+36] = invalidString
;Returns: Number entered by user
;Preconditions: None
;Registers changed: None
;---------------------------------------------------
	pushad
	mov ebp, esp

	mov esi, [ebp + 52]	;moves [array] to esi
	mov ecx, [ebp + 48]	; moves LENGTHOF array to loop counter

	fillArray:
		mov eax, [ebp + 44] ;numberString
		push [ebp + 44]
		push [ebp + 40]	;tryAgain
		push [ebp + 36]	;invalidString
		call readValue
		pop [esi]	;store converted integer in array
		add esi, 4	;point to next element in array
		loop fillArray

	popad
	ret 20
	


getData ENDP

;---------------------------------------------------
readValue PROC USES eax ebx
;Checks to see if integer entered is valid input and calls convertNumber
;to convert the string to an integer that fits in a 32-bit register.
;Receives: [ebp + 16] = numberString, [ebp+12] = tryAgain, [ebp+8] = invalidString
;Returns: filled array
;Preconditions: None
;Registers changed: eax, ebx
;---------------------------------------------------
	LOCAL valid:DWORD, number[10]:BYTE
		push esi
		push ecx
		mov eax, [ebp + 16]	;numberString
		lea ebx, number	;moves local variable number into ebx
	L1:
		getString eax, ebx, LENGTHOF number
		mov ebx, [ebp + 8]	;invalidString
		push ebx
		lea eax, valid	;moves local variable valid to eax
		push eax	;pushes valid onto stack
		lea eax, number	;moves local variable number to eax
		push eax	;moves number onto stack
		push LENGTHOF number
		call validation
		pop edx
		mov [ebp + 16], edx	;stores number in [ebp + 16]
		mov eax, valid
		cmp eax, 1
		mov eax, [ebp + 12]
		lea ebx, number
		jne L1

	pop ecx
	pop esi
	ret 8

readValue ENDP
;---------------------------------------------------
validation PROC USES eax ecx edx esi
;Validates that the numbers are not too big and are unsigned (I had the tooBig invalid message working and then I don't know what happened and I can not figure out why it's not working anymore.)
;Receives: [ebp+20] = invalidString, [ebp+16] = valid, [ebp+12] = number, [ebp+8] = LENGTHOF number
;Returns: N/A
;Preconditions: None
;Registers changed: esi, ecx, eax, edx
;---------------------------------------------------
	LOCAL big:DWORD	;local variable used to determine if the number will fit in a 32 bit register
		
		mov esi, [ebp + 12]	;number
		mov ecx, [ebp + 8]	;LENGTHOF number
		cld

	loadStr:	;loads string and makes sure it is in proper ASCII range
		lodsb
		cmp al, 0
		je nullString
		cmp al, 48	;ASCII for 0
		jl invalid	
		cmp al, 57	;ASCII for 9
		ja invalid
		loop loadStr

	invalid:	;displays invalidString
		mov edx, [ebp + 20]	;invalidString
		displayString edx
		call CrLf
		mov edx, 0
		mov edx, [ebp + 16]	;valid = 0
		mov eax, 0
		mov [edx], eax
		jmp value

	nullString:		
		mov edx, [ebp + 8]	;LENGTHOF number
		cmp ecx, edx
		je invalid
		lea eax, big
		mov edx, 0
		mov [eax], edx
		push [ebp + 12]	;number
		push [ebp + 8]	;LENGTHOF number
		lea edx, big
		push edx
		call convertNumber
		mov edx, big
		cmp edx, 1	;if big is true then it displays error message
		je invalid
		mov edx, [ebp + 16]	;valid
		mov eax, 1
		mov [edx], eax
	
	value:
		pop edx
		mov [ebp + 20], edx	;stores number in [ebp+20]
		ret 12	;prevents [ebp+20] from being cleaned up

validation ENDP



;---------------------------------------------------
convertNumber PROC USES  eax ebx ecx edx esi
;Converts a string of digits to an integer number.
;Verifies that the number is not too large for a 32-bit
;register.
;Receives: [ebp+16] = [number], [ebp+12] = LENGTHOF number, [ebp+8] = big
;Returns:Converted inputNumber on top of stack. tooLarge set to 1 if does not fit in 32-bit register
;Preconditions: None
;Registers changed: ebp, esi, ecx, eax, ebx, edx
;---------------------------------------------------
	LOCAL value:DWORD
		mov esi, [ebp + 16]	;number
		mov ecx, [ebp + 12]	;LENGTHOF number
		lea eax, value
		xor ebx, ebx
		mov [eax], ebx
		xor eax, eax
		xor edx, eax	;clears the overflow and carry flags to setup the tooBig
		cld

	L1:
		lodsb
		cmp eax, 0
		je endL
		sub eax, 48	;ASCII code for digit 0
		mov ebx, eax
		mov eax, value
		mov edx, 10
		mul edx
		jc tooBig	;If carry flag is set it will display an error message
		add eax, ebx
		jc tooBig	;If carry flag is set it will display an error message
		mov value, eax	;use local variable value to store digit
		mov eax, 0 
		loop L1

	endL:
		mov eax, value
		mov [ebp + 16], eax	;number = value
		jmp theEnd

	tooBig:	;sets big to true in the case that the user-entered number does not fit into a 32 bit register
		mov ebx, [ebp + 8]	;big
		mov eax, 1
		mov [ebx], eax	;big now = 1 
		mov eax, 0
		mov [ebp + 16], eax	;number

	theEnd:
		ret 8

convertNumber ENDP


;---------------------------------------------------
displayList PROC 
;Displays the array of numbers
;Receives:[ebp + 52] = arrayString, [ebp+48] = [array], [ebp+44] = LENGTHOF array, [ebp+40] = enteredString, [ebp+36] = commaString
;Returns:List of array 
;Preconditions: None
;Registers changed: n/a
;---------------------------------------------------
		pushad
		mov ebp, esp
		call CrLf
		mov edx, [ebp + 40]	;enteredString
		displayString edx
		call CrLf
		mov esi, [ebp + 48]	;[array]
		mov ecx, [ebp + 44]	;LENGTHOF array
		mov ebx, 1	;set to 1 to prevent comma on last element in list
	print:
		mov eax, [esi]
		push [ebp + 52]
		push eax
		call WriteValue
		add esi, 4
		cmp ebx, ecx	;LENGTHOF array
		je theEnd
		mov edx, [ebp + 36]	;commaString
		displayString edx
		loop print
	theEnd:
		
		call CrLf
		popad
		ret 16

displayList ENDP

;---------------------------------------------------
WriteValue PROC 
;Writes an integer to the console. Also converts it to a character and stores it in arrayString
;Receives: [ebp + 40] = arrayString, [ebp + 36] = array
;Returns: None
;Preconditions: Array element pass on stack and arrayString
;Registers changed:
;---------------------------------------------------
	pushad
	mov ebp, esp
	mov eax, [ebp + 36]
	mov ebx, 10
	cdq
	div ebx
	cmp eax, 0
	jne L1
	jmp theEnd

	L1:
		push [ebp + 40]
		push eax
		call WriteValue	;recursive looping for integers with more than one number
	theEnd:	;converts digit to string
		add dl, 48
		mov edi, [ebp + 40]
		mov [edi], dl	;adds 4 to the element to set it to a character
		displayString [ebp + 40]
	popad
	ret 8

WriteValue ENDP


;---------------------------------------------------
sumAverage PROC 
;Displays the sum and average of the list
;Receives: [ebp+52] = arrayString, [ebp+48] = array, [ebp+44] = LENGTHOF array, [ebp+40] = sumString, [ebp+36] = averageString
;Returns:
;Preconditions: None
;Registers changed:n/a
;---------------------------------------------------
		pushad
		mov ebp, esp
	
		mov edx, [ebp + 40]	;sumString
		displayString edx
		mov esi, [ebp + 48]	;array
		mov ecx, 10
		mov eax, 0
	
	sum:
		add eax, [esi]	;adds element to eax, eax is being used as sum
		add esi, 4	;points to next element in array
		loop sum	;loops until it runs through all 10 digits
		
		push [ebp + 52]
		push eax
		call WriteDec
		call CrLf
		call CrLf

		;//calculate and display average
		mov edx, [ebp + 36]	;averageString
		displayString edx
		cdq
		mov ebx, [ebp + 44]	;LENGTHOF array
		div ebx	;divides eax(sum) by the number of elements in array
	
		push [ebp + 52]
		push eax
		call WriteValue
		call CrLf
		call CrLf
		pop eax
		pop [ebp + 52]

	popad
	ret 16
sumAverage ENDP



;---------------------------------------------------
farewell PROC
;Displays farewell message
;Receives: Farewell string [ebp + 36]
;Returns: N/A
;Preconditions: None
;Registers changed: edx
;---------------------------------------------------
	pushad
	mov ebp, esp
	mov edx, [ebp + 36]
	call WriteString
	call CrLf
	popad
	ret 4

farewell ENDP

end main
