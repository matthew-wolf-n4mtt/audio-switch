; DisLCD.asm
; Version: 1.0
; Author:  Matthew J. Wolf
; Date: No idea. Info added 16-SEP-2019
;  
; This file is part of the Audio-Switch.
; By Matthew J. Wolf <matthew.wolf@speciosus.net>
; Copyright 2019 Matthew J. Wolf
;
; The Audio-Switch is distributed in the hope that
; it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
; the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with the Audio-Switch.
; If not, see <http://www.gnu.org/licenses/>.
;
		title		'DisLCD - Display lines LCD display'
		subtitle	''
		list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  DisLCD
;  Displayes line on the LCD.
;
;  Uses the LCDlib from the Elmer 160.
;**
;
; N4MTT - 01-Nov-2010
; $Revision 1.0	$Date: 2010-11-01 01012:00 $


			include		p16f1938.inc

			global		DisLName,DisRName,Dis1Name,Dis2Name
			global		DisInName,DisOutInDiv,DisPortDiv
			extern		LCDletr

			udata
CharIdx		res			1		; Counter for name char index
PortIdx		res			1
CHAR		res			1

				code

; Tables for Output port names
PortLNameT		movlw		high PortLNameTs	; Pick up high byte of table address
				movwf		PCLATH				; And save into PCLATH
				movf		CharIdx,W			; Pick up index
				brw								; And look up in table
PortLNameTs		dt			"L  ",0				; Message, terminated with a zero
				return

PortRNameT		movlw		high PortRNameTs
				movwf		PCLATH
				movf		CharIdx,W
				brw
PortRNameTs		dt			"R  ",0
				return

Port1NameT		movlw		high Port1NameTs
				movwf		PCLATH
				movf		CharIdx,W
				brw
Port1NameTs		dt			"ONE",0
				return

Port2NameT		movlw		high Port2NameTs
				movwf		PCLATH
				movf		CharIdx,W
				brw
Port2NameTs		dt			"TWO",0
				return				

; Tables for Input port names	
Input1NameTs	brw
				dt			"One",0

Input2NameTs	brw
				dt			"Two",0

Input3NameTs	brw
				dt			"The",0

Input4NameTs	brw
				dt			"For",0

Input5NameTs	brw
				dt			"Fiv",0

Input6NameTs	brw
				dt			"Six",0

Input7NameTs	brw
				dt			"Sev",0

Input8NameTs	brw
				dt			"Eig",0

;Subroutines to Display Input names	
DisInName		movwf		PortIdx
				clrf		CharIdx

DisInNameS		bcf			STATUS,Z		; Reset Status reg
				movf		PortIdx,W
				xorlw		H'00'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input1Name
				movf		PortIdx,W
				xorlw		H'01'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input2NameT
				movf		PortIdx,W
				xorlw		H'02'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input3NameT
				movf		PortIdx,W
				xorlw		H'03'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input4NameT	
				movf		PortIdx,W	
				xorlw		H'04'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input5NameT
				movf		PortIdx,W	
				xorlw		H'05'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input6NameT
				movf		PortIdx,W	
				xorlw		H'06'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input7NameT
				movf		PortIdx,W	
				xorlw		H'07'
				btfsc		STATUS,Z		; Was it Zero?
				goto		Input8NameT	
				xorlw		H'08'
				btfsc		STATUS,Z		; Was it Zero?
				return

				return
	
Input1Name		clrf		CharIdx
				bcf			STATUS,Z

Input1NameT		movf		CharIdx,W		
				call		Input1NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input1NameT
			
Input2NameT		movf		CharIdx,W		
				call		Input2NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input2NameT

Input3NameT		movf		CharIdx,W		
				call		Input3NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input3NameT

Input4NameT		movf		CharIdx,W		
				call		Input4NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input4NameT

Input5NameT		movf		CharIdx,W		
				call		Input5NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input5NameT

Input6NameT		movf		CharIdx,W		
				call		Input6NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input6NameT

Input7NameT		movf		CharIdx,W		
				call		Input7NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input7NameT

Input8NameT		movf		CharIdx,W		
				call		Input8NameTs		
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return					
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto 		Input8NameT



;Subroutines to Display Output Names
DisLName		clrf 		CharIdx
DisLNameS
				call 		PortLNameT		; Get Port Name Char
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return						; Yes, exit
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto		DisLNameS

DisRName		clrf 		CharIdx
DisRNameS
				call 		PortRNameT		; Get Port Name Char
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return						; Yes, exit
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto		DisRNameS

Dis1Name		clrf 		CharIdx
Dis1NameS
				call 		Port1NameT		; Get Port Name Char
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return						; Yes, exit
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto		Dis1NameS

Dis2Name		clrf 		CharIdx
Dis2NameS
				call 		Port2NameT		; Get Port Name Char
				xorlw		H'00'			; Test to see if char is Zero
				btfsc		STATUS,Z		; Was it Zero?
				return						; Yes, exit
				call		LCDletr			; Display Chr on LCD
				incf		CharIdx,F		; Point to the next char
				goto		Dis2NameS
				
;Subroutines to Display Dividers
DisOutInDiv		bcf			STATUS,Z		; Reset Status reg
				movlw		":"				; Set W to In Out Div
				call		LCDletr			; Send Char to LCD
				return


DisPortDiv		movlw		"|"				; Set W to Port Div
				call		LCDletr			; Send Char to LCD
				movlw		"|"				; Set W to Port Div
				call		LCDletr			; Send Char to LCD
				return

				end

