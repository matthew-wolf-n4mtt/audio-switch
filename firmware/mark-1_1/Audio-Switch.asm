; Audio-Switch.asm
; Version: 1.1
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
			;processor PIC16F1938
			;#include <p16f1938.inc>

			list		p=16f1938      ; list directive to define processor
			#include	<p16f1938.inc> ; processor specific variable definitions
			errorlevel -302		;suppress "not in bank 0" message

			__CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF
			__CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_OFF & _STVREN_OFF & _BORV_19 & _LVP_OFF

			#define			LCD_2_LINE 

			extern		DisLName,DisRName,Dis1Name,Dis2Name
			extern		DisInName,DisOutInDiv,DisPortDiv
			extern		LCDinit,LCDaddr
			extern		SerDisLName,SerDisRName,SerDis1Name,SerDis2Name
			extern		SerNewLine,SerOutInDiv,SerDisInName,SerDisPortDiv
			;extern		PortLNameT
			;extern		Del1s


; Manifest Constants -------------------------------------------------
PB_L		equ			H'00'		; PORTA pin for PB_L
PB_R		equ			H'01'		; PORTA pin for PB_R
PB_1		equ			H'02'		; PORTA pin for PB_1
PB_2		equ			H'03'		; PORTA pin for PB_2

INPORTNUM	equ			H'08'		; Number of Input Ports  

EE_L		equ			H'00'		; EEPROM Locations
EE_R		equ			H'01'
EE_1		equ			H'02'
EE_2		equ			H'03'

ReceivedD	equ			H'01'		; Flag status bits
ReceivedL	equ			H'02'
ReceivedR	equ			H'03'
Received1	equ			H'04'
Received2	equ			H'05'

LedBlTo		equ			H'06'		; Back light status bits

LMuxWrAddr	equ	B'10011000'  ; U4 write address
RMuxWrAddr	equ	B'10011100'	 ; U5 write address		
OneMuxWrAddr	equ	B'10011010'  ; U6 write address
TwoMuxWrAddr	equ	B'10011110'  ; U7 write address 

MUX_S1		equ			B'00000001'	; Mux switch commands
MUX_S2		equ			H'02'
MUX_S3		equ			H'04'
MUX_S4		equ			H'08'
MUX_S5		equ			H'10'
MUX_S6		equ			H'20'
MUX_S7		equ			H'40'
MUX_S8		equ			H'80'

Led75		equ		H'DF'			;Back Light levels
Led50		equ		H'80'
Led25		equ		H'40'
Led10		equ		H'20'

LedBLTimeOut	equ		H'01'

#define  FOSC        D'4000000'          ; define FOSC to PICmicro
#define  I2CClock    D'400000'           ; define I2C bite rate
#define  ClockValue  (((FOSC/I2CClock)/4) -1) ; 


; File Registers ------------------------------------------------------
			udata
PortLCount	res			1
PortRCount	res			1
Port1Count	res			1
Port2Count	res			1
Buttons		res			1
PB_State	res			1
;Count		res			1
RXData		res			1
MuxSource	res			1
;MuxSource	res			1
;MuxInput	res			1

Flags		res			1	;byte to store indicator flags
BlFlags		res			1
;I2C_Flags	res			1

TimerCount	res			1
NumThSec	res			1
NumSec		res			1
NumMin		res			1

;SerCharIdx	res			1


; EEPROM Initialization -------------------------------------------------------
DATAEE    	org  		0xF000
			data		H'05',H'04',H'03',H'02'

; Interrput Vector
;			org			0x0004

			
;----------------------------------------------------------------------------------------
STARTUP 	org     	0x0000      ; processor reset vector
 	  		pagesel		Start
			clrf    	PCLATH		
  			goto		Start

;			org		0x0004		;place code at interrupt vector
;InterruptCode
;			retfie	

Start	
			banksel		OSCCON		; Set Internal Clock for 4MHZ
			movlw		B'01101000'
			movwf		OSCCON

			; wait for osc stablise
			banksel OSCSTAT
			btfss OSCSTAT, HFIOFS 	; HFIOFS: stable (0.5%)
			goto $-1

			banksel		APFCON
			clrf		APFCON		; ALT pins not needed			

			banksel		PORTA		
			clrf		PORTA		; Init PORTA
			banksel		LATA
			clrf		LATA		; No Data Latch
			banksel		ANSELA
			clrf		ANSELA		; All Digital I/O
			banksel		TRISA		
			movlw		B'00001111'	; RA 7 to 4 outputs
			movwf		TRISA		; RA 3 to 0 inputs

			banksel		PORTB		
			clrf		PORTB		; Init PORTB
			banksel		LATB
			clrf		LATB		; No Data Latch
			banksel		ANSELB	
			clrf		ANSELB		; All Digital I/O
			banksel		TRISB		
			clrf 		TRISB		; All output

			banksel		PORTC
			clrf		PORTC		; Init PORTB
			banksel		LATB
			clrf		LATB		; No Data Latch
			banksel		TRISC	
			movlw		B'10111111' ; RC7 input(RX) RC6 output(TX)
			movwf		TRISC
	
			call 		SerialSetup

			call		MuxSetup

			call		I2CSetup
			
			call 		EEREAD		; Get Port Count from EEPROM
			movwf 		PortLCount	; Store Port count

			call 		EEREAD		; Get Port Count from EEPROM
			movwf 		PortRCount	; Store Port count

			call 		EEREAD		; Get Port Count from EEPROM
			movwf 		Port1Count	; Store Port count

			call 		EEREAD		; Get Port Count from EEPROM
			movwf 		Port2Count	; Store Port count

			call		LCDinit		; Initialize the LCD

			call		LCDLine1	; Display 1st line on LCD
			call		LCDLine2

			movlw		B'00001111'	; Initialize button state as up.
			movwf		PB_State

			call		L_Mux		; Initialize Mux's

			call		init_pwm
			call		init_timer0

Loop	
			call		time_loop		; mantain time counters

			btfsc		BlFlags,LedBlTo ; Dim LCD Backlight when flag is set
			call		LedBlDim
				

			;incf		Port2Count,F	; -Handy test to test val of port count
			;movf		Port2Count,W	; Move L Port Count to W
			;xorlw		INPORTNUM		; Is the Port Count equal the 
			;btfsc		STATUS,Z		;  to the max port number 
			;clrf		Port2Count		;  if Yes clear port count
			;bcf		STATUS,Z

			call		PB_L_Count	;Test and Count Button for Port L
 			call		PB_R_Count	;Test and Count Button for Port R
			call		PB_1_Count	;Test and Count Button for Port	1
			call		PB_2_Count	;Test and Count Button for Port	2
		
			banksel		PORTB
			call		LCDLine1	; Display 1st line on LCD
			call		LCDLine2	; Display 2nd line on LCD

			;bcf			Flags,Received2
			clrf		Flags

			call		ReceiveSerial	;go get received data if possible

			btfsc		Flags,ReceivedD
			;call		SerialDisplay
			call		SerialD
			;nop

			btfsc		Flags,ReceivedL
			call		SerialL

			btfsc		Flags,ReceivedR
			call		SerialR

			btfsc		Flags,Received1
			call		Serial1

			btfsc		Flags,Received2
			call		Serial2

			goto 		Loop

; Subroutines ------------------------------------------------------------
SerialSetup

		BANKSEL 	TRISC
		bcf 		TRISC, 6 ; TX pin
		bsf			TRISC,7; RX 

		banksel 	BAUDCON
		bsf 		BAUDCON, BRG16 ; enable 16 bit counter
	
		banksel		SPBRG
		movlw		D'25'			; 9600 at 4MHZ
		movwf		SPBRG
	
		banksel 	TXSTA
		bsf 		TXSTA, TXEN ; enable TX
		bcf 		TXSTA, SYNC ; disable synchronous
		bcf			TXSTA, BRGH

		banksel 	RCSTA
		bsf 		RCSTA, SPEN ; select TX and RX pins
		bcf			RCSTA,	RX9
		bsf 		RCSTA, CREN ; enable RX

		clrf		Flags		;clear all flags

ReceiveSerial
		banksel	PIR1
		btfss	PIR1,RCIF	;check if data
		return			;return if no data

		banksel	RCSTA
		btfsc	RCSTA,OERR	;if overrun error occurred
		goto	ErrSerialOverr	; then go handle error

		banksel	RCSTA
		btfsc	RCSTA,FERR	;if framing error occurred
		goto	ErrSerialFrame	; then go handle error

ReceiveSer1	

		banksel RCREG
		movf	RCREG,W			;get received data
		movwf	RXData

		bcf		STATUS,Z	

		movf	RXData,W
		xorlw	0x64			;compare with d		
		btfsc	STATUS,Z
		goto    RecD
		
		movf	RXData,W
		xorlw	0x6c			;compare with l
		btfsc	STATUS,Z
		goto	RecL

		movf	RXData,W
		xorlw	0x72			;compare with r
		btfsc	STATUS,Z
		goto	RecR

		movf	RXData,W
		xorlw	0x31			;compare with 1
		btfsc	STATUS,Z
		goto	Rec1

		movf	RXData,W
		xorlw	0x32			;compare with 2
		btfsc	STATUS,Z
		goto	Rec2

		return

RecD
		bsf		Flags,ReceivedD  
		return

RecL	bsf		Flags,ReceivedL
		return

RecR		
		bsf		Flags,ReceivedR
		return

Rec1
		bsf		Flags,Received1
		return	

Rec2
		bsf		Flags,Received2
		return				

;error because OERR overrun error bit is set
;can do special error handling here - this code simply clears and continues
ErrSerialOverr
		banksel	RCSTA
		bcf	RCSTA,CREN	;reset the receiver logic
		bsf	RCSTA,CREN	;enable reception again
		return

;error because FERR framing error bit is set
;can do special error handling here - this code simply clears and continues
ErrSerialFrame
		banksel	RCREG
		movf	RCREG,W		;discard received data that has error
		return

SerialD
				call	SerNewLine	
	
		;Display Line1
		call	SerDisLName	 

		call	SerOutInDiv
		
		movlb	H'00'
		movf	PortLCount,W
		call	SerDisInName		; Display Input Name

		call	SerDisPortDiv

		call	SerDisRName	

		call	SerOutInDiv
		
		movlb	H'00'
		movf	PortRCount,W
		call	SerDisInName		; Display Input Name
			
		call	SerNewLine

		;Display Line2
		call	SerDis1Name	 

		call	SerOutInDiv
		
		movlb	H'00'
		movf	Port1Count,W
		call	SerDisInName		; Display Input Name

		call	SerDisPortDiv

		call	SerDis2Name	

		call	SerOutInDiv
		
		movlb	H'00'
		movf	Port2Count,W
		call	SerDisInName		; Display Input Name
			
		call	SerNewLine
		
		call 	SerNewLine		


	

		bcf		Flags,ReceivedD
		return	

		

SerialL
			movlb		H'00'	
			incf		PortLCount,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		PortLCount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortLCount		;  if Yes clear port count

			call		L_Mux			; Change MUX port
		
			call		EEPROM_L_Write		; Write port count to EEPROM

			bcf			Flags,ReceivedL

			return

SerialR
			movlb		H'00'
			incf		PortRCount,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		PortRCount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortRCount		;  if Yes clear port count
		
			call		EEPROM_R_Write		; Write port count to EEPROM

			bcf			Flags,ReceivedR

			return

Serial1
			movlb		H'00'
			incf		Port1Count,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		Port1Count,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		Port1Count		;  if Yes clear port count
		
			call		EEPROM_1_Write		; Write port count to EEPROM

			bcf			Flags,Received1

			return

Serial2
			movlb		H'00'
			incf		Port2Count,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		Port2Count,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		Port2Count		;  if Yes clear port count
		
			call		EEPROM_2_Write		; Write port count to EEPROM

			bcf			Flags,Received2

			return

L_Mux
		call 	i2c_start
		call 	i2c_SendLMuxWrAddr				
		call 	i2c_SendLDataByte
		call	i2c_Stop
		return

MuxSetup
		banksel		PORTA
		bsf			PORTA,4		; U4 Reset High
		bsf			PORTA,5		; U5 Reset High
		bsf			PORTA,6		; U6 Reset High
		bsf			PORTA,7		; U7 Reset High
		return

I2CSetup
		banksel		SSPCON1
		movlw		B'00101000'
		movwf		SSPCON1	; Master mode, SSP enable

		banksel	SSPSTAT
		movlw		B'10000000' ;slew rate off
		movwf	SSPSTAT

		
		banksel	SSPADD
		movlw   ClockValue             ; read selected baud rate 
		movlw	H'FF'
		movwf   SSPADD                 ; initialize I2C baud rate
		
		banksel		TRISC
		bsf			TRISC,3 	;Set RC3/SCL to input
		bsf			TRISC,4		;Set RC4/SDA to Input		

		return

i2c_start	;i2c start
		banksel 	SSPCON2            	; select SFR bank
		bsf     	SSPCON2,SEN        	; initiate I2C bus start condition			

		btfsc		SSPCON2,SEN			; Test start bit state
		goto		$-1					; module is busy. 
		banksel		PIR1
		bcf 		PIR1,SSPIF

		return

i2c_SendLMuxWrAddr
		banksel		SSPBUF
		movlw		LMuxWrAddr			; Slave Address
		movwf		SSPBUF				; write is i2c buss
		btfsc		SSPSTAT,R_NOT_W		;Wait r_w clear at 9th (ACk) clock
		goto		$-1

		banksel 	SSPCON2                  ; select SFR bank
		btfss   	SSPCON2,ACKSTAT		; wait for the ACK from Slave 
		goto 		$+1

		banksel		SSPCON2				;idle check
		movf		SSPCON2,w			; get copy
		andlw		0x1F				; Maks out non-status
		btfss		STATUS,Z			; test for zero state
		goto		$-3	

		return

i2c_SendLDataByte
		movlb		H'00'
		movf		PortLCount,W	
		call		Mux_Port_Num       ; DATA Byte returned to W
		
		banksel		SSPBUF
		;movlw		B'11111111'				; Word address
		movwf		SSPBUF				; write is i2c buss
		btfsc		SSPSTAT,R_NOT_W		;Wait r_w clear at 9th (ACk) clock
		goto		$-1		

		banksel		SSPCON2				; idle check
		movf		SSPCON2,w			; get copy
		andlw		0x1F				; Maks out non-status
		btfss		STATUS,Z			; test for zero state
		goto		$-3					; bus is busy. test again
		
		return

i2c_Stop
		banksel		SSPCON2                  ; select SFR bank
		bsf     	SSPCON2,PEN              ; initiate I2C bus stop condition
		btfsc		SSPCON2,PEN
		goto		$-1

		return		

Mux_Port_Num						; Get then Mux connand 
		movwf		MuxSource

		bcf			STATUS,Z		
		movf		MuxSource,W
		xorlw		H'00'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS1
		movf		MuxSource,W
		xorlw		H'01'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS2
		movf		MuxSource,W
		xorlw		H'02'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS3
		movf		MuxSource,W
		xorlw		H'03'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS4
		movf		MuxSource,W
		xorlw		H'04'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS5
		movf		MuxSource,W
		xorlw		H'05'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS6
		movf		MuxSource,W
		xorlw		H'06'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS7
		movf		MuxSource,W
		xorlw		H'07'
		btfsc		STATUS,Z		; Was it Zero?
		goto		MUXS8
		return

MUXS1
		movlw		MUX_S1
		return
MUXS2
		movlw		MUX_S2
		return
MUXS3
		movlw		MUX_S3
		return
MUXS4
		movlw		MUX_S4
		return
MUXS5
		movlw		MUX_S5
		return
MUXS6
		movlw		MUX_S6
		return
MUXS7
		movlw		MUX_S7
		return
MUXS8
		movlw		MUX_S8
		return


;Read From EEPROM
EEREAD		
			banksel		EEADRL
			bcf			EECON1,CFGS		; Deselect Config Space
			bcf			EECON1,EEPGD	; Point to DATA memory
			bsf			EECON1,RD		; EEPROM Read
			movf		EEDATL,W		; Move EEPROM Data to W
			incf		EEADRL			; Increment to the next EEPROM location
			movlb		0x00			; move to bank 0
			return 			

;Init Display LCD Line 1
LCDLine1
			movlw		H'00'			; Move cursor the 1th line.
			call 		LCDaddr			

			call		DisLName		; Display L port Name

			call		DisOutInDiv		; Disp Out In Divider
			
			movf		PortLCount,W
		    call		DisInName		; Display Input Name

			call		DisPortDiv		; Display Port Divider

			call		DisRName		; Display R port Name
			
			call		DisOutInDiv		; Disp Out In Divider

			movf		PortRCount,W	; Move Port Indix to W
		    call		DisInName		; Display Input Name
			
			return

;Int Display LCD Line 2
LCDLine2
			movlw		H'40'			; Move cursor the 2nd line.
			call 		LCDaddr			

			call		Dis1Name		; Display L port Name

			call		DisOutInDiv		; Disp Out In Divider

			movf		Port1Count,W	; Move Port Indix to W
		    call		DisInName		; Display Input Name

			call		DisPortDiv		; Display Port Divider

			call		Dis2Name		; Display R port Name
			
			call		DisOutInDiv		; Disp Out In Divider

			movf		Port2Count,W	; Move Port Indix to W
		    call		DisInName		; Display Input Name

			return

PB_L_Count
			banksel		PORTA
			movf		PORTA,W			; Get inputs
			movwf		Buttons
			
			; Check button state
			btfss		PB_State,PB_L		; Was button down?
			goto		PB_L_wasDown		; Yes
PB_L_wasUp
			btfsc		Buttons,PB_L		; Is button still up?
			return							; Was up and still up, do nothing
			bcf			PB_State,PB_L		; Was up, remember now down
			return
PB_L_wasDown
			btfss		Buttons,PB_L		; If it is still down
			return							; Was down and still down, do nothing
			bsf			PB_State,PB_L		; remember released
			

			incf		PortLCount,F		; Button was down and now it's up,
											; we need to increment the counter
	
			bcf			STATUS,Z
			movf		PortLCount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortLCount		;  if Yes clear port count

			call		L_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight
		
			call		EEPROM_L_Write		; Write port count to EEPROM

			return

PB_R_Count
			banksel		PORTA
			movf		PORTA,W 		; Get Inputs
			movwf		Buttons
			
			; Check button state
			btfss		PB_State,PB_R		; Was button down?
			goto		PB_R_wasDown		; Yes
PB_R_wasUp
			btfsc		Buttons,PB_R		; Is button still up?
			return							; Was up and still up, do nothing
			bcf			PB_State,PB_R		; Was up, remember now down
			return
PB_R_wasDown
			btfss		Buttons,PB_R		; If it is still down
			return							; Was down and still down, do nothing
			bsf			PB_State,PB_R		; remember released
			
			incf		PortRCount,F		; Button was down and now it's up,
											; we need to increment the counter

			bcf			STATUS,Z
			movf		PortRCount,W	;  Move R Port Count to W
			xorlw		INPORTNUM		;  Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortRCount		;  if Yes clear port count

			;call		R_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight

			call		EEPROM_R_Write		; Write port count to EEPROM
											
			return							

PB_1_Count
			banksel		PORTA
			movf		PORTA,W				; Get inputs
			movwf		Buttons
			
			; Check button state
			btfss		PB_State,PB_1		; Was button down?
			goto		PB_1_wasDown		; Yes
PB_1_wasUp
			btfsc		Buttons,PB_1		; Is button still up?
			return							; Was up and still up, do nothing
			bcf			PB_State,PB_1		; Was up, remember now down
			return
PB_1_wasDown
			btfss		Buttons,PB_1		; If it is still down
			return							; Was down and still down, do nothing
			bsf			PB_State,PB_1		; remember released

			incf		Port1Count,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		Port1Count,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		Port1Count		;  if Yes clear port count

			;call		1_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight

			call		EEPROM_1_Write		; Write port count to EEPROM

			return

PB_2_Count
			banksel		PORTA
			movf		PORTA,W				; Get inputs
			movwf		Buttons
			
			; Check button state
			btfss		PB_State,PB_2		; Was button down?
			goto		PB_2_wasDown		; Yes
PB_2_wasUp
			btfsc		Buttons,PB_2		; Is button still up?
			return							; Was up and still up, do nothing
			bcf			PB_State,PB_2		; Was up, remember now down
			return
PB_2_wasDown
			btfss		Buttons,PB_2		; If it is still down
			return							; Was down and still down, do nothing
			bsf			PB_State,PB_2		; remember released

			incf		Port2Count,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		Port2Count,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		Port2Count		;  if Yes clear port count

			
			;call		2_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight

			call		EEPROM_2_Write		; Write port count to EEPROM

			return

EEPROM_L_Write
			movlb		H'00'
			movf		PortLCount,W			

			banksel		EEADRL
			
			movwf		EEDATL

			movlw		EE_L				; Set the EEPROM address
			movwf		EEADRL

			bcf			EECON1,CFGS			; Deselect Config Space
			bcf			EECON1,EEPGD		; Point to DATA memory
			bsf			EECON1,WREN			; Enable EEPROM write
			bcf			INTCON, GIE			; Disable Interutps			
			movlw		H'55'				; -Start of Required Sequence	
			movwf		EECON2				; Write 0x55
			movlw		H'AA'				;
			movwf		EECON2				; Write 0XAA
			bsf			EECON1, WR			; Set WR bit to write
											; -End of Required Sequence
			bsf			INTCON, GIE			; Enable Interutps
			bcf			EECON1,WREN			; Disable EEPROM write
			btfsc		EECON1,WR			; Wait for write to complete
			goto		$-2					; Finshed
			
            return			

EEPROM_R_Write
			movlb		H'00'
			movf		PortRCount,W			

			banksel		EEADRL
			
			movwf		EEDATL

			movlw		EE_R				; Set the EEPROM address
			movwf		EEADRL

			bcf			EECON1,CFGS			; Deselect Config Space
			bcf			EECON1,EEPGD		; Point to DATA memory
			bsf			EECON1,WREN			; Enable EEPROM write
			bcf			INTCON, GIE			; Disable Interutps			
			movlw		H'55'				; -Start of Required Sequence	
			movwf		EECON2				; Write 0x55
			movlw		H'AA'				;
			movwf		EECON2				; Write 0XAA
			bsf			EECON1, WR			; Set WR bit to write
											; -End of Required Sequence
			bsf			INTCON, GIE			; Enable Interutps
			bcf			EECON1,WREN			; Disable EEPROM write
			btfsc		EECON1,WR			; Wait for write to complete
			goto		$-2					; Finshed
			
            return			

EEPROM_1_Write
			movlb		H'00'
			movf		Port1Count,W			

			banksel		EEADRL
			
			movwf		EEDATL

			movlw		EE_1				; Set the EEPROM address
			movwf		EEADRL

			bcf			EECON1,CFGS			; Deselect Config Space
			bcf			EECON1,EEPGD		; Point to DATA memory
			bsf			EECON1,WREN			; Enable EEPROM write
			bcf			INTCON, GIE			; Disable Interutps			
			movlw		H'55'				; -Start of Required Sequence	
			movwf		EECON2				; Write 0x55
			movlw		H'AA'				;
			movwf		EECON2				; Write 0XAA
			bsf			EECON1, WR			; Set WR bit to write
											; -End of Required Sequence
			bsf			INTCON, GIE			; Enable Interutps
			bcf			EECON1,WREN			; Disable EEPROM write
			btfsc		EECON1,WR			; Wait for write to complete
			goto		$-2					; Finshed
			
            return			

EEPROM_2_Write
			movlb		H'00'
			movf		Port2Count,W			

			banksel		EEADRL
			
			movwf		EEDATL

			movlw		EE_2				; Set the EEPROM address
			movwf		EEADRL

			bcf			EECON1,CFGS			; Deselect Config Space
 			bcf			EECON1,EEPGD		; Point to DATA memory
			bsf			EECON1,WREN			; Enable EEPROM write
			bcf			INTCON, GIE			; Disable Interutps			
			movlw		H'55'				; -Start of Required Sequence	
			movwf		EECON2				; Write 0x55
			movlw		H'AA'				;
			movwf		EECON2				; Write 0XAA
			bsf			EECON1, WR			; Set WR bit to write
											; -End of Required Sequence
			bsf			INTCON, GIE			; Enable Interutps
			bcf			EECON1,WREN			; Disable EEPROM write
			btfsc		EECON1,WR			; Wait for write to complete
			goto		$-2					; Finshed
			
            return		

;init CCP1_________________________________________________________
init_pwm
			banksel		PR2			; Timer Period
			movlw		B'11111110' ; 10 bit 245.10 hrez
			movwf		PR2


			banksel		T2CON
			movlw		B'00000111'
			movwf		T2CON

			banksel		CCPR1L
			movlw		B'11111111'	; 100%
			movwf		CCPR1L

			banksel		CCP1CON
			movlw		B'00111100'
			movwf		CCP1CON
			
			banksel		TRISC
			bcf			TRISC,RC2		; Make C2 output, CCP1

			return


;Init Timer0______________________________________
init_timer0
			banksel		CPSCON0
			bcf			CPSCON0,T0XCS

			banksel		OPTION_REG

			bcf			OPTION_REG,TMR0CS	; Fosc/4
			bcf			OPTION_REG,PSA		; Use Prescaler
			bsf			OPTION_REG,PS0		; 1:256 Prescaler
			bsf			OPTION_REG,PS1
			bsf			OPTION_REG,PS2

			banksel		CCPR1L
			movlw		H'FF'
			movwf		CCPR1L

			banksel		TMR0
			clrf		TMR0

			movlb		H'00'	
		
			clrf		Flags
			clrf		TimerCount
			clrf		NumThSec
			clrf		NumSec
			clrf		NumMin

			return

;time stuff ______________________________________________________________
time_loop
			banksel		INTCON
			btfss		INTCON,TMR0IF	; Did the timer overflow?
			goto		$+3
			bcf			INTCON,TMR0IF		; Reset overflow flag
			movlb		H'00'
			incf		TimerCount		; Yes, inc counter.
		
			movlb		H'00'
			
			bcf			STATUS,Z
			movf		TimerCount,W
			xorlw		H'FF'			; Around 1 tenth sec. not exsact(fudge)
			btfss		STATUS,Z
			goto		$+3
			incf		NumThSec
			clrf		TimerCount

			bcf			STATUS,Z
			movf		NumThSec,W
			;xorlw		H'57'			; Around 1 sec. not exsact(fudge)
			xorlw		H'01'
			btfss		STATUS,Z
			goto		$+3
			incf		NumSec
			clrf		NumThSec

			bcf			STATUS,Z
			movf		NumSec,W
			;xorlw		H'60' ;d96
			xorlw		H'3C' ;d60		
			btfss		STATUS,Z
			goto		$+3
			incf		NumMin
			clrf		NumSec

			;bcf			STATUS,Z
			;movf		NumMin,W
			;xorlw		LedBLTimeOut
			;btfsc		STATUS,Z
			;bsf			BlFlags,LedBlTo
			
			banksel		H'00'
			bcf			STATUS,Z
			movf		NumMin,W
			xorlw		LedBLTimeOut
			btfsc		STATUS,Z			
			bsf			BlFlags,LedBlTo

			return
;_________________________________________________________________

LedBlDim
			bcf			STATUS,Z

			movlb		H'00'
			movf		NumMin,W
			xorlw		LedBLTimeOut + 1
			btfss		STATUS,Z
			goto		$+5
			movlw		Led75
			banksel		CCPR1L
			movwf		CCPR1L
			goto		EndLedB1Dim			

			movlb		H'00'
			movf		NumMin,W
			xorlw		LedBLTimeOut + 2
			btfss		STATUS,Z
			goto		$+5
			movlw		Led50
			banksel		CCPR1L
			movwf		CCPR1L			
			goto		EndLedB1Dim	

			movlb		H'00'
			movf		NumMin,W
			xorlw		LedBLTimeOut + 3
			btfss		STATUS,Z
			goto		$+5
			movlw		Led25
			banksel		CCPR1L
			movwf		CCPR1L
			goto		EndLedB1Dim	

			movlb		H'00'
			movf		NumMin,W
			xorlw		LedBLTimeOut + 4
			btfss		STATUS,Z
			goto		$+5
			movlw		Led10
			banksel		CCPR1L
			movwf		CCPR1L
			goto		EndLedB1Dim	
			
EndLedB1Dim	
			return

	
FullBackLight
			movlb		H'00'
			bcf			BlFlags,LedBlTo	; clear timeout flag
			clrf		NumMin			; clear timeout counter
	
			banksel		CCPR1L		; enabled full backlight
			movlw		B'11111111'	; 100%
			movwf		CCPR1L	

			return

			end
