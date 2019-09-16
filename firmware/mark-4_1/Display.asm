; Display.asm
; Version: 4.1
; Author:  Matthew J. Wolf
; Date:    02-MAY-2017, Info added 16-SEP-2019
;  
; This file is part of the Audio-Switch-MK4.
; By Matthew J. Wolf <matthew.wolf@speciosus.net>
; Copyright 2019 Matthew J. Wolf
;
; The Audio-Switch is distributed in the hope that
; it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
; the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with the Audio-Switch-MK4.
; If not, see <http://www.gnu.org/licenses/>.
;
    title	'Display - Display lines on LCD display and serial port'
    subtitle	''
    list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  Display
;  Display line on the LCD and serial port.
;
;  Uses the LCDlib from the Elmer 160.
;**
;
; N4MTT - 26-Nov-2016
; $Revision 4.0	$Date: 2016-03-26 1857:00 $

    include		p16f1938.inc
			;include		p16f1933.inc

    global		Dis1Name,Dis2Name,Dis3Name,Dis4Name
    global		DisInName,DisOutInDiv,DisPortDiv,SerComma
    global		SerDis1Name,SerDis2Name,SerDis3Name,SerDis4Name
    global		SerNewLine,SerOutInDiv,SerDisInName,SerDisPortDiv
    global		SerDisInNum,SerMessEnterComm,SerMessCommPort
    global		SerMessCommIn,SerMessCommEnd,SerialSendChar
    extern		LCDletr

    udata
CharIdx		res			1   ; Counter for name char index
PortIdx		res			1

.Display	code

; Tables for Output port names
PortLNameT
    movlw		high PortLNameTs    ; Pick up high byte of table address
    movwf		PCLATH		    ; And save into PCLATH
    movf		CharIdx,W	    ; Pick up index
    brw					    ; And look up in table
PortLNameTs
    dt			"L",0		    ; Message, terminated with a zero
    return

PortRNameT
    movlw		high PortRNameTs
    movwf		PCLATH
    movf		CharIdx,W
    brw
PortRNameTs
    dt			"R",0
    return

Port1NameT
    movlw		high Port1NameTs
    movwf		PCLATH
    movf		CharIdx,W
    brw
Port1NameTs
    dt			"A",0
    return

Port2NameT
    movlw		high Port2NameTs
    movwf		PCLATH
    movf		CharIdx,W
    brw
Port2NameTs
    dt			"B",0
    return

				    ; Tables for Input port names
Input1NameTs
    brw
    ;dt			"One  ",0
    dt			"9MAIN",0

Input2NameTs
    brw
    ;dt			"Two  ",0
    dt			"91SUB",0

Input3NameTs
    brw
    ;dt			"Three",0
    dt			"K2   ",0

Input4NameTs
    brw
    ;dt			"Four ",0
    ;dt			"746  ",0
    dt			"Kx3  ",0

Input5NameTs
    brw
    ;dt			"Five ",0
    dt			"sMAIN",0

Input6NameTs
    brw
    ;dt			"Six  ",0
    dt			"sdSUB",0

Input7NameTs
    brw
    ;dt			"Seven",0
    dt			"PC L ",0

Input8NameTs
    brw
    ;dt			"Eight",0
    dt			"PC R ",0

Input1NumTs
    brw
    dt			"0",0

Input2NumTs
    brw
    dt			"1",0

Input3NumTs
    brw
    dt			"2",0

Input4NumTs
    brw
    dt			"3",0

Input5NumTs
    brw
    dt			"4",0

Input6NumTs
    brw
    dt			"5",0

Input7NumTs
    brw
    dt			"6",0

Input8NumTs
    brw
    dt			"7",0


					;Subroutines to Display Input names
DisInName
    movwf		PortIdx
    clrf		CharIdx

DisInNameS
    bcf			STATUS,Z	; Reset Status reg
    movf		PortIdx,W
    xorlw		H'00'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input1Name
    movf		PortIdx,W
    xorlw		H'01'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input2NameT
    movf		PortIdx,W
    xorlw		H'02'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input3NameT
    movf		PortIdx,W
    xorlw		H'03'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input4NameT
    movf		PortIdx,W
    xorlw		H'04'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input5NameT
    movf		PortIdx,W
    xorlw		H'05'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input6NameT
    movf		PortIdx,W
    xorlw		H'06'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input7NameT
    movf		PortIdx,W
    xorlw		H'07'
    btfsc		STATUS,Z	; Was it Zero?
    goto		Input8NameT
    xorlw		H'08'
    btfsc		STATUS,Z	; Was it Zero?
    return

    return

Input1Name
    clrf		CharIdx
    bcf			STATUS,Z

Input1NameT
    movf		CharIdx,W
    call		Input1NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input1NameT
    goto 		Input1NameT

Input2NameT
    movf		CharIdx,W
    call		Input2NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input2NameT
    goto 		Input2NameT

Input3NameT
    movf		CharIdx,W
    call		Input3NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input3NameT
    goto 		Input3NameT

Input4NameT
    movf		CharIdx,W
    call		Input4NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input4NameT
    goto 		Input4NameT

Input5NameT
    movf		CharIdx,W
    call		Input5NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input5NameT
    goto 		Input5NameT

Input6NameT
    movf		CharIdx,W
    call		Input6NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input6NameT
    goto 		Input6NameT

Input7NameT
    movf		CharIdx,W
    call		Input7NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input7NameT
    goto 		Input7NameT

Input8NameT
    movf		CharIdx,W
    call		Input8NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Input8NameT
    goto 		Input8NameT


					;Subroutines to Display Output Names
Dis1Name
    clrf 		CharIdx
DisLNameS
    call 		PortLNameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return				; Yes, exit
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		DisLNameS
    goto		DisLNameS

Dis2Name
    clrf 		CharIdx
DisRNameS
    call 		PortRNameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return				; Yes, exit
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		DisRNameS
    goto		DisRNameS

Dis3Name
    clrf 		CharIdx
Dis1NameS
    call 		Port1NameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return				; Yes, exit
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Dis1NameS
    goto		Dis1NameS

Dis4Name
    clrf 		CharIdx
Dis2NameS
    call 		Port2NameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return				; Yes, exit
    pagesel		LCDletr
    call		LCDletr		; Display Chr on LCD
    incf		CharIdx,F	; Point to the next char
    pagesel		Dis2NameS
    goto		Dis2NameS

					; Subroutines to Display Dividers
DisOutInDiv
    bcf			STATUS,Z	; Reset Status reg
    movlw		":"		; Set W to In Out Div
    pagesel		LCDletr
    call		LCDletr		; Send Char to LCD
    return

DisPortDiv
    movlw		"|"		; Set W to Port Div
    pagesel		LCDletr
    call		LCDletr		; Send Char to LCD
    movlw		"|"		; Set W to Port Div
    pagesel		LCDletr
    call		LCDletr		; Send Char to LCD
    return

SerialSendChar
    banksel		PIR1
    btfss 		PIR1, TXIF
    goto $-1
    banksel		TXREG
    movwf 		TXREG
    return

SerNewLine
    movlw		0x0A		; Line Feed
    pagesel		SerialSendChar
    call		SerialSendChar

    movlw		0x0D		; Carriage Return
    pagesel		SerialSendChar
    call		SerialSendChar

    return

SerDis1Name
    banksel		CharIdx
    clrf		CharIdx

SerDisLNameS
    bcf			STATUS,Z
    pagesel		PortLNameT
    call 		PortLNameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerDisLNameS

SerDis2Name
    banksel		CharIdx
    clrf		CharIdx

SerDisRNameS
    bcf			STATUS,Z
    pagesel		PortRNameT
    call 		PortRNameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerDisRNameS

SerDis3Name
    banksel		CharIdx
    clrf		CharIdx

SerDis3NameS
    bcf			STATUS,Z
    pagesel		Port1NameT
    call 		Port1NameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerDis3NameS

SerDis4Name
    banksel		CharIdx
    clrf		CharIdx

SerDis4NameS
    bcf			STATUS,Z
    pagesel		Port2NameT
    call 		Port2NameT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerDis4NameS

SerOutInDiv
    movlw		":"
    pagesel		SerialSendChar
    call 		SerialSendChar
    return

SerDisPortDiv
    movlw		"|"		; Set W to Port Div
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Char
    movlw		"|"		; Set W to Port Div
    call		SerialSendChar	; Send Char
    return

SerComma
    movlw		","		; Send in/out div
    pagesel		SerialSendChar
    call 		SerialSendChar
    return

EndSerialDisplay
    return

SerDisInName
    banksel		PortIdx
    movwf		PortIdx
    clrf		CharIdx

SerDisInNameS
    bcf			STATUS,Z	; Reset Status reg
    movf		PortIdx,W
    xorlw		H'00'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput1Name
    movf		PortIdx,W
    xorlw		H'01'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput2NameT
    movf		PortIdx,W
    xorlw		H'02'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput3NameT
    movf		PortIdx,W
    xorlw		H'03'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput4NameT
    movf		PortIdx,W
    xorlw		H'04'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput5NameT
    movf		PortIdx,W
    xorlw		H'05'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput6NameT
    movf		PortIdx,W
    xorlw		H'06'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput7NameT
    movf		PortIdx,W
    xorlw		H'07'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput8NameT
    xorlw		H'08'
    btfsc		STATUS,Z	; Was it Zero?
    return

    return

SerInput1Name
    banksel		CharIdx
    clrf		CharIdx
    bcf			STATUS,Z

SerInput1NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input1NameTs
    call		Input1NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput1NameT
    goto 		SerInput1NameT

SerInput2NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input2NameTs
    call		Input2NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput2NameT
    goto 		SerInput2NameT

SerInput3NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input3NameTs
    call		Input3NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput3NameT
    goto 		SerInput3NameT

SerInput4NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input4NameTs
    call		Input4NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput4NameT
    goto 		SerInput4NameT

SerInput5NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input5NameTs
    call		Input5NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput5NameT
    goto 		SerInput5NameT

SerInput6NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input6NameTs
    call		Input6NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput6NameT
    goto 		SerInput6NameT

SerInput7NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input7NameTs
    call		Input7NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send ChrD
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput7NameT
    goto 		SerInput7NameT

SerInput8NameT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input8NameTs
    call		Input8NameTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput8NameT
    goto 		SerInput8NameT

SerDisInNum
    banksel		PortIdx
    movwf		PortIdx
    clrf		CharIdx

SerDisInNumS
    bcf			STATUS,Z	; Reset Status reg
    movf		PortIdx,W
    xorlw		H'00'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput1Num
    movf		PortIdx,W
    xorlw		H'01'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput2NumT
    movf		PortIdx,W
    xorlw		H'02'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput3NumT
    movf		PortIdx,W
    xorlw		H'03'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput4NumT
    movf		PortIdx,W
    xorlw		H'04'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput5NumT
    movf		PortIdx,W
    xorlw		H'05'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput6NumT
    movf		PortIdx,W
    xorlw		H'06'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput7NumT
    movf		PortIdx,W
    xorlw		H'07'
    btfsc		STATUS,Z	; Was it Zero?
    goto		SerInput8NumT
    xorlw		H'08'
    btfsc		STATUS,Z	; Was it Zero?
    return

    return

SerInput1Num
    banksel		CharIdx
    clrf		CharIdx
    bcf			STATUS,Z

SerInput1NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input1NumTs
    call		Input1NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput1NumT
    goto 		SerInput1NumT

SerInput2NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input2NumTs
    call		Input2NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput2NumT
    goto 		SerInput2NumT

SerInput3NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input3NumTs
    call		Input3NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput3NumT
    goto 		SerInput3NumT

SerInput4NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input4NumTs
    call		Input4NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput4NumT
    goto 		SerInput4NumT

SerInput5NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input5NumTs
    call		Input5NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput5NumT
    goto 		SerInput5NumT

SerInput6NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		Input6NumTs
    call		Input6NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput6NumT
    goto 		SerInput6NumT

SerInput7NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		SerInput7NumT
    call		Input7NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send ChrD
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput7NumT
    goto 		SerInput7NumT

SerInput8NumT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		SerInput8NumT
    call		Input8NumTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerInput8NumT
    goto 		SerInput8NumT

SerMessEnterComm
    banksel		CharIdx
    clrf		CharIdx

    bcf			STATUS,Z
    pagesel		EnterCommT
    call 		EnterCommT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerMessEnterComm

EnterCommT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		EnterCommTs
    call		EnterCommTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		EnterCommT
    goto 		EnterCommT

EnterCommTs
    brw
    dt			"Command Mode: ",0

SerMessCommPort
    banksel		CharIdx
    clrf		CharIdx

    bcf			STATUS,Z
    pagesel		SerMessCommPortT
    call 		SerMessCommPortT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerMessCommPort

SerMessCommPortT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		SerMessCommPortTs
    call		SerMessCommPortTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerMessCommPortT
    goto 		SerMessCommPortT

SerMessCommPortTs
    brw
    dt			"Output ",0

SerMessCommIn
    banksel		CharIdx
    clrf		CharIdx

    bcf			STATUS,Z
    pagesel		SerMessCommInT
    call 		SerMessCommInT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerMessCommIn

SerMessCommInT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		SerMessCommInTs
    call		SerMessCommInTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerMessCommInT
    goto 		SerMessCommInT

SerMessCommInTs
    brw
    dt			" connected to ",0

SerMessCommEnd
    banksel		CharIdx
    clrf		CharIdx

    bcf			STATUS,Z
    pagesel		SerMessCommEndT
    call 		SerMessCommEndT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		CharIdx
    incf		CharIdx,F
    goto		SerMessCommEnd

SerMessCommEndT
    ;banksel		CharIdx
    movf		CharIdx,W
    pagesel		SerMessCommEndTs
    call		SerMessCommEndTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		CharIdx
    incf		CharIdx,F	; Point to the next char
    pagesel		SerMessCommEndT
    goto 		SerMessCommEndT

SerMessCommEndTs
    brw
    dt			" - Bad Input Port",0

    end

