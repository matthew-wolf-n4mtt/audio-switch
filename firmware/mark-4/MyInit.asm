; MyInit.asm
; Version: 4.0
; Author:  Matthew J. Wolf
; Date:    26-MAR-2016, Info added 16-SEP-2019
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
    title		'LCDinit - Initialize the LCD display'
    subtitle	'Part of the LCDlib library'
    list		b=4,c=132,n=77,x=Off

;**
;  LCDinit
;
;  Initialize the LCD display.
;
;  LCDinit intializes the LCD.  This routine must be
;  called before any other LCD routines.  The LCD
;  requires significant time between power up and
;  initialization; LCDinit waits this amount of time.
;  In addition, initialization requires sending a
;  series of commands to the LCD, some of which take
;  some time for the LCD controller to process.
;  As a result, LCDinit takes almost a tenth of a
;  second to execute.
;
;  The contents of the W register are ignored by
;  this routine.  The contents of the W register
;  are destroyed on exit.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.31 $ $Date: 2005-03-05 09:50:22-05 $
;  N4MTT - 26-March-16
;  $Revision: 4.0 $ $Date: 2016-03-16 18:12 $
    
    include		"LCDMacs.inc"

    ; Provided Routines
    global		LCDinit		; Initialize the LCD
    ; Required routines
    extern		LCDsend
;   extern		LCDsndI		; Send a command bybble to the LCD
;   extern		Del40us		; Delay 40 usec
    extern		Del2ms		; Delay 1.8 msec

_LCDOV1	udata_ovr
Count	res			1			; Storage for loop counter

LCDLIB	code
; ------------------------------------------------------------------------
; Initialize the LCD
LCDinit:
    ; First, need to wait a long time after power up to
    ; allow time for 44780 to get it's act together
    movlw		020h		; Need >15.1ms after 4.5V
    movwf		Count		; we will wait 65ms (after 2V
    call		Del2ms		; in the case of LF parts)
    decfsz		Count,F		;
    goto		$-2

    ; Initialization begins with sending 0x03 3 times followed
    ; by a 0x02 to define 4 bit data
    ;pagesel		LCDsend
    movlw		H'33'
    call		LCDsend
    movlw		H'32'
    call		LCDsend

    ; Now set up the display the way we want it
    IFDEF		LCD2LINE
    movlw		LCD_FUN_SET | LCD_DL_4 | LCD_2_LINE | LCD_5X10_FONT
    ;pagesel		LCDsend
    call		LCDsend
    ELSE
    movlw		LCD_FUN_SET | LCD_DL_4 | LCD_1_LINE | LCD_5X10_FONT
    ;pagesel		LCDsend
    call		LCDsend
    ENDIF

    ; It seems to help to turn off the display and clear it before
    ; setting the entry mode
    movlw		LCD_DISPLAY | LCD_DISP_OFF	; Display Off
    ;pagesel		LCDsend
    call		LCDsend
    movlw		LCD_DISP_CLEAR	; Display clear
    ;pagesel		LCDsend
    call		LCDsend

    ; Set display to no shift
    movlw		LCD_ENTRY_MODE | LCD_NO_SHIFT | LCD_DIS_INCR
    ;pagesel		LCDsend
    call		LCDsend

    ; Turn on display, cursor, and cursor blinking
    movlw		LCD_DISPLAY | LCD_DISP_ON | LCD_CURS_OFF | LCD_BLINK_OFF
    ;movlw		LCD_DISPLAY | LCD_DISP_ON | LCD_CURS_ON | LCD_BLINK_ON
    ;pagesel		LCDsend
    call		LCDsend

    return

    end
