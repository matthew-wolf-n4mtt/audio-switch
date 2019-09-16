; Audio-Switch.asm
; Version: 2.0
; Author:  Matthew J. Wolf
; Date: No idea. Info added 16-SEP-2019
;  
; This file is part of the Audio-Switch-MK2.
; By Matthew J. Wolf <matthew.wolf@speciosus.net>
; Copyright 2019 Matthew J. Wolf
;
; The Audio-Switch is distributed in the hope that
; it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
; the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with the Audio-Switch-MK2.
; If not, see <http://www.gnu.org/licenses/>.
;
			;processor PIC16F1938
			;#include <p16f1938.inc>

			IFDEF		__16F1933
		    list		p=16f1933  
			include		p16f1933.inc	
			ENDIF

			IFDEF		__16F1938
		    list		p=16f1938  
			include		p16f1938.inc	
			ENDIF

			;list		p=16f1938      ; list directive to define processor
			;#include	<p16f1938.inc> ; processor specific variable definitions
			;list		p=16f1933      ; list directive to define processor
			;#include	<p16f1933.inc> ; processor specific variable definitions
			errorlevel -302		;suppress "not in bank 0" message

			__CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF
			__CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_OFF & _STVREN_OFF & _BORV_19 & _LVP_OFF

			#define			LCD_2_LINE 

			extern		DisLName,DisRName,Dis1Name,Dis2Name
			extern		DisInName,DisOutInDiv,DisPortDiv,SerComma
			extern		LCDinit,LCDaddr
			extern		SerDisLName,SerDisRName,SerDis1Name,SerDis2Name
			extern		SerNewLine,SerOutInDiv,SerDisInName,SerDisPortDiv
			extern		SerDisInNum
			;extern		PortLNameT
			;extern		Del1s


; Manifest Constants -------------------------------------------------
PB_L		equ			H'00'		; PORTA pin for PB_L
PB_R		equ			H'01'		; PORTA pin for PB_R
PB_A		equ			H'02'		; PORTA pin for PB_A
PB_B		equ			H'03'		; PORTA pin for PB_B

INPORTNUM	equ			H'08'		; Number of Input Ports  

EE_L		equ			H'00'		; EEPROM Locations
EE_R		equ			H'01'
EE_A		equ			H'02'
EE_B		equ			H'03'

ReceivedP	equ			H'00'
ReceivedS	equ			H'01'		; Flag status bits
ReceivedL	equ			H'02'
ReceivedR	equ			H'03'
ReceivedA	equ			H'04'
ReceivedB	equ			H'05'
ReceivedSS  equ			H'06'
ReceivedI	equ			H'07'

LedBlTo		equ			H'06'		; Back light status bits

LMuxWrAddr	equ	B'10011000'  ; U4 write address
RMuxWrAddr	equ	B'10011100'	 ; U5 write address		
AMuxWrAddr	equ	B'10011010'  ; U6 write address
BMuxWrAddr	equ	B'10011110'  ; U7 write address 

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
PortACount	res			1
PortBCount	res			1
Buttons		res			1
PB_State	res			1
;Count		res			1
RXData		res			1
MuxSource	res			1
;MuxSource	res			1
;MuxInput	res			1

Flags		res			1	;byte to store indicator flags
BlFlags		res			1
RFlags		res			1
CommandFlags  res			1
;I2C_Flags	res			1
TimerCount	res			1
NumThSec	res			1
NumSec		res			1
NumMin		res			1

;SerCharIdx	res			1
;SerBuff		res			D'4'

;temp		res			1

; EEPROM Initialization -------------------------------------------------------
DATAEE    	org  		0xF000
			data		H'00',H'01',H'02',H'03'

;			org			0xF005
;			data		'O','n','e',H'00',H'00'
;			org			0xF00B
;			data		'T','w','o',H'00',H'00'
;			org			0xF011
;			data		'T','h','r','e','e'
;			org			0xF017
;			data		'F','o','u','r',H'00'
;			org			0xF01D
;			data		'F','i','v','e',H'00'
;			org			0xF023
;			data		'S','i','x',H'00',H'00'
;			org			0xF029
;			data		'S','e','v','e','n
;			org			0xF02F
;			data		'E','i','g','h','t'

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
			movwf 		PortACount	; Store Port count

			call 		EEREAD		; Get Port Count from EEPROM
			movwf 		PortBCount	; Store Port count

			call		LCDinit		; Initialize the LCD

			call		LCDLine1	; Display 1st line on LCD
			call		LCDLine2

			movlw		B'00001111'	; Initialize button state as up.
			movwf		PB_State

			call		L_Mux		; Initialize Mux's
			call		R_Mux
			call		A_Mux
			call		B_Mux

			call		init_pwm
			call		init_timer0

Loop	
			call		time_loop		; mantain time counters

			btfsc		BlFlags,LedBlTo ; Dim LCD Backlight when flag is set
			call		LedBlDim
				
			call		PB_L_Count	;Test and Count Button for Port L
 			call		PB_R_Count	;Test and Count Button for Port R
			call		PB_A_Count	;Test and Count Button for Port	1
			call		PB_B_Count	;Test and Count Button for Port	2
		
			banksel		PORTB
			call		LCDLine1	; Display 1st line on LCD
			call		LCDLine2	; Display 2nd line on LCD

			clrf		Flags

			call		ReceiveSerial	;go get received data if possible

			btfsc		Flags,ReceivedS
			call		SerialS

			btfsc		Flags,ReceivedSS
			call		SerialStatusDisplay	

			btfsc		RFlags,ReceivedP
			call		SerialPortDisplay	

			btfsc		RFlags,ReceivedI
			call		SerialInDisplay	

			btfsc		Flags,ReceivedL
			call		SerialL

			btfsc		Flags,ReceivedR
			call		SerialR

			btfsc		Flags,ReceivedA
			call		SerialA

			btfsc		Flags,ReceivedB
			call		SerialB

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
		clrf		RFlags
		clrf		CommandFlags 

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
		btfsc	CommandFlags,ReceivedL
		goto	CommandL

		btfsc	CommandFlags,ReceivedR
		goto	CommandR

		btfsc	CommandFlags,ReceivedA
		goto	CommandA

		btfsc	CommandFlags,ReceivedB
		goto	CommandB

        btfsc   Flags,ReceivedI
        goto	CommandMode	

		bcf		STATUS,Z
		
		movf	RXData,W
		xorlw	0x73			;compare with s		
		btfsc	STATUS,Z
		goto    RecS
		
		movf	RXData,W
		xorlw	0x53			;compare with S		
		btfsc	STATUS,Z
		goto    RecSerStat

		movf	RXData,W
		xorlw	0x50			;compare with P		
		btfsc	STATUS,Z
		goto    RecP

		movf	RXData,W
		xorlw	0x49			;compare with I		
		btfsc	STATUS,Z
		goto    RecIN

		movf	RXData,W
		xorlw	0x6c			;compare with l
		btfsc	STATUS,Z
		goto	RecL

		movf	RXData,W
		xorlw	0x72			;compare with r
		btfsc	STATUS,Z
		goto	RecR

		movf	RXData,W
		xorlw	0x61			;compare with a
		btfsc	STATUS,Z
		goto	RecA

		movf	RXData,W
		xorlw	0x62			;compare with b
		btfsc	STATUS,Z
		goto	RecB

        movf    RXData,W
		xorlw   0x69			;compare with i
		btfsc	STATUS,Z
		goto	RecI

		return

CommandMode
		bcf		STATUS,Z

		movf	RXData,W
		xorlw	0x6c			;compare with l
		btfsc	STATUS,Z
		goto	ComRecL

		movf	RXData,W
		xorlw	0x72			;compare with r
		btfsc	STATUS,Z
		goto	ComRecR

		movf	RXData,W
		xorlw	0x61			;compare with a
		btfsc	STATUS,Z
		goto	ComRecA

		movf	RXData,W
		xorlw	0x62			;compare with b
		btfsc	STATUS,Z
		goto	ComRecB
		
        movf	RXData,W
		xorlw	0x65			;compare with e
		btfsc	STATUS,Z		;exit command mode
		goto	ComRecE	

CommandL
		bcf		STATUS,Z

		movf	RXData,W
		xorlw	0x30			;compare with 0
		btfsc	STATUS,Z
		goto	CommandL0

		movf	RXData,W
		xorlw	0x31			;compare with 1
		btfsc	STATUS,Z
		goto	CommandL1

		movf	RXData,W
		xorlw	0x32			;compare with 2
		btfsc	STATUS,Z
		goto	CommandL2

		movf	RXData,W
		xorlw	0x33			;compare with 3
		btfsc	STATUS,Z
		goto	CommandL3

		movf	RXData,W
		xorlw	0x34			;compare with 4
		btfsc	STATUS,Z
		goto	CommandL4

		movf	RXData,W
		xorlw	0x35			;compare with 5
		btfsc	STATUS,Z
		goto	CommandL5

		movf	RXData,W
		xorlw	0x36			;compare with 6
		btfsc	STATUS,Z
		goto	CommandL6

		movf	RXData,W
		xorlw	0x37			;compare with 7
		btfsc	STATUS,Z
		goto	CommandL7

		movf	RXData,W
		xorlw	0x65			;compare with e
		btfsc	STATUS,Z
		goto    CommandLExit

		return

CommandR
		bcf		STATUS,Z

		movf	RXData,W
		xorlw	0x30			;compare with 0
		btfsc	STATUS,Z
		goto	CommandR0

		movf	RXData,W
		xorlw	0x31			;compare with 1
		btfsc	STATUS,Z
		goto	CommandR1

		movf	RXData,W
		xorlw	0x32			;compare with 2
		btfsc	STATUS,Z
		goto	CommandR2

		movf	RXData,W
		xorlw	0x33			;compare with 3
		btfsc	STATUS,Z
		goto	CommandR3

		movf	RXData,W
		xorlw	0x34			;compare with 4
		btfsc	STATUS,Z
		goto	CommandR4

		movf	RXData,W
		xorlw	0x35			;compare with 5
		btfsc	STATUS,Z
		goto	CommandR5

		movf	RXData,W
		xorlw	0x36			;compare with 6
		btfsc	STATUS,Z
		goto	CommandR6

		movf	RXData,W
		xorlw	0x37			;compare with 7
		btfsc	STATUS,Z
		goto	CommandR7

		movf	RXData,W
		xorlw	0x65			;compare with e
		btfsc	STATUS,Z
		goto    CommandRExit

		return

CommandA
		bcf		STATUS,Z

		movf	RXData,W
		xorlw	0x30			;compare with 0
		btfsc	STATUS,Z
		goto	CommandA0

		movf	RXData,W
		xorlw	0x31			;compare with 1
		btfsc	STATUS,Z
		goto	CommandA1

		movf	RXData,W
		xorlw	0x32			;compare with 2
		btfsc	STATUS,Z
		goto	CommandA2

		movf	RXData,W
		xorlw	0x33			;compare with 3
		btfsc	STATUS,Z
		goto	CommandA3

		movf	RXData,W
		xorlw	0x34			;compare with 4
		btfsc	STATUS,Z
		goto	CommandA4

		movf	RXData,W
		xorlw	0x35			;compare with 5
		btfsc	STATUS,Z
		goto	CommandA5

		movf	RXData,W
		xorlw	0x36			;compare with 6
		btfsc	STATUS,Z
		goto	CommandA6

		movf	RXData,W
		xorlw	0x37			;compare with 7
		btfsc	STATUS,Z
		goto	CommandA7

		movf	RXData,W
		xorlw	0x65			;compare with e
		btfsc	STATUS,Z
		goto    CommandAExit

		return

CommandB
		bcf		STATUS,Z

		movf	RXData,W
		xorlw	0x30			;compare with 0
		btfsc	STATUS,Z
		goto	CommandB0

		movf	RXData,W
		xorlw	0x31			;compare with 1
		btfsc	STATUS,Z
		goto	CommandB1

		movf	RXData,W
		xorlw	0x32			;compare with 2
		btfsc	STATUS,Z
		goto	CommandB2

		movf	RXData,W
		xorlw	0x33			;compare with 3
		btfsc	STATUS,Z
		goto	CommandB3

		movf	RXData,W
		xorlw	0x34			;compare with 4
		btfsc	STATUS,Z
		goto	CommandB4

		movf	RXData,W
		xorlw	0x35			;compare with 5
		btfsc	STATUS,Z
		goto	CommandB5

		movf	RXData,W
		xorlw	0x36			;compare with 6
		btfsc	STATUS,Z
		goto	CommandB6

		movf	RXData,W
		xorlw	0x37			;compare with 7
		btfsc	STATUS,Z
		goto	CommandB7

		movf	RXData,W
		xorlw	0x65			;compare with e
		btfsc	STATUS,Z
		goto    CommandBExit

		return

RecS
		bsf		Flags,ReceivedS
		return

RecSerStat
		bsf		Flags,ReceivedSS
		return
RecP
		bsf		RFlags,ReceivedP
		return

RecIN
		bsf		RFlags,ReceivedI
		return

RecL	bsf		Flags,ReceivedL
		return

RecR		
		bsf		Flags,ReceivedR
		return

RecA
		bsf		Flags,ReceivedA
		return	

RecB
		bsf		Flags,ReceivedB
		return	

RecI
        bsf		Flags,ReceivedI
        return

ComRecL
		bsf		CommandFlags,ReceivedL
		return		

ComRecR
		bsf		CommandFlags,ReceivedR
		return

ComRecA
		bsf		CommandFlags,ReceivedA
		return

ComRecB
		bsf		CommandFlags,ReceivedB	
		return


ComRecE
       	bcf		Flags,ReceivedI
        return

CommandL0
		movlb	H'00'
		movlw	0x07
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL1
		movlb	H'00'
		movlw	0x00
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL2
		movlb	H'00'
		movlw	0x01
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL3
		movlb	H'00'
		movlw	0x02
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL4
		movlb	H'00'
		movlw	0x03
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL5
		movlb	H'00'
		movlw	0x04
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL6
		movlb	H'00'
		movlw	0x05
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandL7
		movlb	H'00'
		movlw	0x06
		movwf	PortLCount
		call	SerialL

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedL				

		return

CommandLExit
		bcf		Flags,ReceivedI
		bcf		CommandFlags,ReceivedL
		return

CommandR0
		movlb	H'00'
		movlw	0x07
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR1
		movlb	H'00'
		movlw	0x00
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR2
		movlb	H'00'
		movlw	0x01
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR3
		movlb	H'00'
		movlw	0x02
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR4
		movlb	H'00'
		movlw	0x03
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR5
		movlb	H'00'
		movlw	0x04
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR6
		movlb	H'00'
		movlw	0x05
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandR7
		movlb	H'00'
		movlw	0x06
		movwf	PortRCount
		call	SerialR

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedR				

		return

CommandRExit
		bcf		Flags,ReceivedI
		bcf		CommandFlags,ReceivedR
		return

CommandA0
		movlb	H'00'
		movlw	0x07
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA1
		movlb	H'00'
		movlw	0x00
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA2
		movlb	H'00'
		movlw	0x01
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA3
		movlb	H'00'
		movlw	0x02
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA4
		movlb	H'00'
		movlw	0x03
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA5
		movlb	H'00'
		movlw	0x04
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA6
		movlb	H'00'
		movlw	0x05
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandA7
		movlb	H'00'
		movlw	0x06
		movwf	PortACount
		call	SerialA

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedA				

		return

CommandAExit
		bcf		Flags,ReceivedI
		bcf		CommandFlags,ReceivedA
		return

CommandB0
		movlb	H'00'
		movlw	0x07
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB1
		movlb	H'00'
		movlw	0x00
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB2
		movlb	H'00'
		movlw	0x01
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB3
		movlb	H'00'
		movlw	0x02
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB4
		movlb	H'00'
		movlw	0x03
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB5
		movlb	H'00'
		movlw	0x04
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB6
		movlb	H'00'
		movlw	0x05
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandB7
		movlb	H'00'
		movlw	0x06
		movwf	PortBCount
		call	SerialB

		bcf 	Flags,ReceivedI
		bcf 	CommandFlags,ReceivedB				

		return

CommandBExit
		bcf		Flags,ReceivedI
		bcf		CommandFlags,ReceivedB
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

SerialS
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
		movf	PortACount,W
		call	SerDisInName		; Display Input Name

		call	SerDisPortDiv

		call	SerDis2Name	

		call	SerOutInDiv
		
		movlb	H'00'
		movf	PortBCount,W
		call	SerDisInName		; Display Input Name
			
		call	SerNewLine
		
		call 	SerNewLine		


	

		bcf		Flags,ReceivedS
		return	

SerialStatusDisplay
		call	SerNewLine

		movlb	H'00'
        movlw	H'00'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
		movf	PortLCount,W
		call	SerDisInName		; Display Input Name

		call	SerComma

		movlb	H'00'
        movlw	H'01'
		call 	SerDisInNum

		call	SerOutInDiv
		
		movlb	H'00'
		movf	PortRCount,W
		call	SerDisInName		; Display Input Name

		call	SerComma

		movlb	H'00'
        movlw	H'02'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
		movf	PortACount,W
		call	SerDisInName		; Display Input Name

		call 	SerComma

		movlb	H'00'
        movlw	H'03'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
		movf	PortBCount,W
		call	SerDisInName		; Display Input Name

		call	SerNewLine
		
 		bcf		Flags,ReceivedSS
		return

SerialPortDisplay
		call	SerNewLine

		movlb	H'00'
        movlw	H'00'
		call 	SerDisInNum

		call	SerOutInDiv

		call	SerDisLName

		call 	SerComma

		movlb	H'00'
        movlw	H'01'
		call 	SerDisInNum	

		call	SerOutInDiv	

		call	SerDisRName

		call 	SerComma

		movlb	H'00'
        movlw	H'02'
		call 	SerDisInNum	

		call	SerOutInDiv

		call	SerDis1Name

		call 	SerComma

		movlb	H'00'
        movlw	H'03'
		call 	SerDisInNum	

		call	SerOutInDiv

		call	SerDis2Name

		call	SerNewLine

		bcf		RFlags,ReceivedP
		return

SerialInDisplay
		call	SerNewLine

		movlb	H'00'
        movlw	H'00'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'00'
		call	SerDisInName		; Display Input Name

		call	SerComma

		movlb	H'00'
        movlw	H'01'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'01'
		call	SerDisInName		; Display Input Name
		
		call	SerComma

		movlb	H'00'
        movlw	H'02'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'02'
		call	SerDisInName		; Display Input Name
		
		call	SerComma
		
		movlb	H'00'
        movlw	H'03'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'03'
		call	SerDisInName		; Display Input Name
		
		call	SerComma
							
		movlb	H'00'
        movlw	H'04'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'04'
		call	SerDisInName		; Display Input Name
		
		call	SerComma
		
		movlb	H'00'
        movlw	H'05'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'05'
		call	SerDisInName		; Display Input Name
		
		call	SerComma
		
		movlb	H'00'
        movlw	H'06'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'06'
		call	SerDisInName		; Display Input Name
		
		call	SerComma
		
		movlb	H'00'
        movlw	H'07'
		call 	SerDisInNum

		call	SerOutInDiv

		movlb	H'00'
        movlw	H'07'
		call	SerDisInName		; Display Input Name
		
		call	SerNewLine
		

		bcf		RFlags,ReceivedI
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

			call		R_Mux			; Change MUX port
		
			call		EEPROM_R_Write		; Write port count to EEPROM

			bcf			Flags,ReceivedR

			return

SerialA
			movlb		H'00'
			incf		PortACount,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		PortACount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortACount		;  if Yes clear port count

			call		A_Mux			; Change MUX port
		
			call		EEPROM_A_Write		; Write port count to EEPROM

			bcf			Flags,ReceivedA

			return

SerialB
			movlb		H'00'
			incf		PortBCount,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		PortBCount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortBCount		;  if Yes clear port count
		
			call		B_Mux			; Change MUX port

			call		EEPROM_B_Write		; Write port count to EEPROM

			bcf			Flags,ReceivedB

			return

L_Mux
		call 	i2c_start
		call 	i2c_SendLMuxWrAddr				
		call 	i2c_SendLDataByte
		call	i2c_Stop
		return

R_Mux
		call 	i2c_start
		call 	i2c_SendRMuxWrAddr				
		call 	i2c_SendRDataByte
		call	i2c_Stop
		return

A_Mux
		call 	i2c_start
		call 	i2c_SendAMuxWrAddr				
		call 	i2c_SendADataByte
		call	i2c_Stop
		return

B_Mux
		call 	i2c_start
		call 	i2c_SendBMuxWrAddr				
		call 	i2c_SendBDataByte
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

i2c_SendRMuxWrAddr
		banksel		SSPBUF
		movlw		RMuxWrAddr			; Slave Address
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

i2c_SendRDataByte
		movlb		H'00'
		movf		PortRCount,W	
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

i2c_SendAMuxWrAddr
		banksel		SSPBUF
		movlw		AMuxWrAddr			; Slave Address
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

i2c_SendADataByte
		movlb		H'00'
		movf		PortACount,W	
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

i2c_SendBMuxWrAddr
		banksel		SSPBUF
		movlw		BMuxWrAddr			; Slave Address
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

i2c_SendBDataByte
		movlb		H'00'
		movf		PortBCount,W	
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

			movf		PortACount,W	; Move Port Indix to W
		    call		DisInName		; Display Input Name

			call		DisPortDiv		; Display Port Divider

			call		Dis2Name		; Display R port Name
			
			call		DisOutInDiv		; Disp Out In Divider

			movf		PortBCount,W	; Move Port Indix to W
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

			call		R_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight

			call		EEPROM_R_Write		; Write port count to EEPROM
											
			return							

PB_A_Count
			banksel		PORTA
			movf		PORTA,W				; Get inputs
			movwf		Buttons
			
			; Check button state
			btfss		PB_State,PB_A		; Was button down?
			goto		PB_A_wasDown		; Yes
PB_A_wasUp
			btfsc		Buttons,PB_A		; Is button still up?
			return							; Was up and still up, do nothing
			bcf			PB_State,PB_A		; Was up, remember now down
			return
PB_A_wasDown
			btfss		Buttons,PB_A		; If it is still down
			return							; Was down and still down, do nothing
			bsf			PB_State,PB_A		; remember released

			incf		PortACount,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		PortACount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortACount		;  if Yes clear port count

			call		A_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight

			call		EEPROM_A_Write		; Write port count to EEPROM

			return

PB_B_Count
			banksel		PORTA
			movf		PORTA,W				; Get inputs
			movwf		Buttons
			
			; Check button state
			btfss		PB_State,PB_B		; Was button down?
			goto		PB_B_wasDown		; Yes
PB_B_wasUp
			btfsc		Buttons,PB_B		; Is button still up?
			return							; Was up and still up, do nothing
			bcf			PB_State,PB_B		; Was up, remember now down
			return
PB_B_wasDown
			btfss		Buttons,PB_B		; If it is still down
			return							; Was down and still down, do nothing
			bsf			PB_State,PB_B		; remember released

			incf		PortBCount,F		; Button was down and now it's up,
											; we need to increment the counter
			bcf			STATUS,Z
			movf		PortBCount,W	; Move L Port Count to W
			xorlw		INPORTNUM		; Is the Port Count equal the 
			btfsc		STATUS,Z		;  to the max port number 
			clrf		PortBCount		;  if Yes clear port count

			
			call		B_Mux			; Change MUX port
			call		FullBackLight	; Restore LCD Backlight

			call		EEPROM_B_Write		; Write port count to EEPROM

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

EEPROM_A_Write
			movlb		H'00'
			movf		PortACount,W			

			banksel		EEADRL
			
			movwf		EEDATL

			movlw		EE_A				; Set the EEPROM address
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

EEPROM_B_Write
			movlb		H'00'
			movf		PortBCount,W			

			banksel		EEADRL
			
			movwf		EEDATL

			movlw		EE_B				; Set the EEPROM address
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
			;movlw		B'11111111'	; 100%
			movlw		H'DF'
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
			;movlw		B'11111111'	; 100%
			movlw		H'DF'
			movwf		CCPR1L	

			return

			end
