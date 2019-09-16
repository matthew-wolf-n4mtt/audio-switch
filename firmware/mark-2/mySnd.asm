; mySnd.asm
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
		include		"LCDMacs.inc"
;**
;  LCDsnd
;
;  Sends a nybble to the LCD.  Two entry points are provided, LCDsndI to
;  send a command nybble, LCDsndD to send a data nybble.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.31 $ $Date: 2005-03-05 09:51:30-05 $

	; Provided Routines
		global	LCDsndI		; Send a command nybble to the LCD
		global	LCDsndD		; Send data to the LCD
	; Required routines
		extern	Del450ns	; Delay 450 nsec


LCDENB	equ			H'04'	; LCD enable bit number in PORTB
LCDRS	equ			H'40'	; LCD register select bit in PORTB

LCDLIB	code
; ------------------------------------------------------------------------
	; Send data to the LCD
LCDsndD:
		andlw	00fh		; only use low order 4 bits
		iorlw	LCDRS		; Select register
		goto	$+2			; Skip over LCDsndI

; ------------------------------------------------------------------------
	; Send a command nybble to the LCD
LCDsndI:
		andlw	00fh		; only use low order 4 bits
							; FALL THROUGH to SendLCD

; ------------------------------------------------------------------------
	; Actually move the data
		movwf	PORTB		; Send data to PORTB
		bsf		PORTB,LCDENB	; turn on enable bit
		call	Del450ns	; 450ns
		nop
		bcf		PORTB,LCDENB	; clear enable bit
		call	Del450ns	; 450ns
		nop
		return
		end
