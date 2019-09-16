; Myletr.asm
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
			title		'LCDletr, LCDdig - Display letter or digit'
			subtitle	'Part of the Lesson 17 replacement LCDlib library'
			list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  MyLetr - Send a digit to the LCD.
;
;  LCDdig sends a digit to the LCD.  The digit
;  will be entered at the current DDRAM postion.
;  The digit is provided in the lower four bits
;  of the W register.  If the lower four bits of the
;  W register contains a value higher than 9, a
;  trash character will be displayed. The
;  contents of the W register are destroyed on
;  exit.
;
;**
;  WB8RCR - 2-Aug-05
;  $Revision: 1.8 $ $Date: 2005-08-09 21:04:00-04 $

			include		"LCDMacs.inc"

	; Provided Routines
			global		LCDdig,LCDletr
	; Required routines
			extern		LCDsndD
			extern		Del40us

			udata
SaveLetr	res			1			; Storage for letter

MYLIB		code
LCDdig:
			andlw		00fh
			iorlw		030h		; note falls thru
 
LCDletr:
			movwf		SaveLetr	; save off the letter
			swapf		SaveLetr,W	; Swap bytes
			call		LCDsndD

			movfw		SaveLetr	; get it
			call		LCDsndD

			call		Del40us		; delay a while	
			return

			end
