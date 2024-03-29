		title		'LCDaddr - Set the LCD display address'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  LCDaddr
;
;  Set the LCD display address.
;
;  This function sets the display address for the next character
;  to be displayed on the LCD.  The caller passes in the address
;  in the W register.
;
;  For the PIC-EL 16 character display, the ninth character is
;  at address 32 (decimal).  For most other 2 line displays, the
;  first character of the second line is at address 64.
;
;  The contents of the W register are destroyed.
;
;**
;  WB8RCR - 13-Nov-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:16-04 $

	include		"LCDMacs.inc"

	; Provided Routines
		global		LCDaddr
	; Required routines
		extern		LCDsend
		extern		Del2ms

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address
_LCDOV1	udata_ovr
Addr	res			1

LCDLIB	code
LCDaddr:
		iorlw		LCD_SET_DDRAM ;  OR in command byte
		pagesel		LCDsend
		call		LCDsend	;  Send to LCD
		pagesel		Del2ms		
		call		Del2ms
		return

		end
