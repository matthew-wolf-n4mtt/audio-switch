		include		"LCDMacs.inc"
;**
;  LCDsnd
;
;  Sends a nybble to the LCD.  Two entry points are provided, LCDsndI to
;  send a command nybble, LCDsndD to send a data nybble.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:22-04 $

	; Provided Routines
		global	LCDsndI		; Send a command nybble to the LCD
		global	LCDsndD		; Send data to the LCD
	; Required routines
		extern	Del450ns	; Delay 450 nsec


LCDLIB	code
; ------------------------------------------------------------------------
	; Send data to the LCD
LCDsndD
		andlw	00fh		; only use low order 4 bits
		iorlw	LCDRS		; Select register
		goto	$+2		; Skip over LCDsndI

; ------------------------------------------------------------------------
	; Send a command nybble to the LCD
LCDsndI
		andlw	00fh		; only use low order 4 bits
							; FALL THROUGH to SendLCD

; ------------------------------------------------------------------------
	; Actually move the data
		movwf	LCDPORT		; Send data to LCDPORT
		iorlw	LCDENB		; Turn on enable bit
		movwf	LCDPORT
		call	Del450ns	; 450ns
		xorlw	LCDENB
		movwf	LCDPORT
		call	Del450ns	; 450ns
		return
		end
