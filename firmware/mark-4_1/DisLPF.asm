; DisLPF.asm
; Version: 4.1
; Author:  Matthew J. Wolf
; Date:    31-MAY-2016, Info added 16-SEP-2019
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
    title		'DisLPF - Display LPF lines LCD display'
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
; N4MTT - 23-March-2016
; $Revision 1.0	$Date: 2016-03-26 01441:00 $


    include		p16f1938.inc
			;include		p16f1933.inc

    global		DisLPF,SerMessCommLPF
    extern		LCDletr,SerialSendChar


    udata
LPFCharIdx	res			1		; Counter for name char index
LPFIdx		res			1

.DisLPF			code

DisLPF
    banksel		LPFIdx
    movwf		LPFIdx
    clrf		LPFCharIdx

DisLPFS
    bcf			STATUS,Z		; Reset Status reg
    pagesel		LPF0Freq
    movf		LPFIdx,W
    xorlw		H'00'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF0FreqT
    pagesel		LPF1FreqT
    movf		LPFIdx,W
    xorlw		H'01'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF1FreqT
    pagesel		LPF2FreqT
    movf		LPFIdx,W
    xorlw		H'02'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF2FreqT
    pagesel		LPF3FreqT
    movf		LPFIdx,W
    xorlw		H'03'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF3FreqT
    pagesel		LPF4FreqT
    movf		LPFIdx,W
    xorlw		H'04'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF4FreqT
    pagesel		LPF5FreqT
    movf		LPFIdx,W
    xorlw		H'05'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF5FreqT
    pagesel		LPF6FreqT
    movf		LPFIdx,W
    xorlw		H'06'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF6FreqT
    pagesel		LPF7FreqT
    movf		LPFIdx,W
    xorlw		H'07'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF7FreqT
    pagesel		LPF8FreqT
    movf		LPFIdx,W
    xorlw		H'08'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF8FreqT
    pagesel		LPF9FreqT
    movf		LPFIdx,W
    xorlw		H'09'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF9FreqT
    pagesel		LPF10FreqT
    movf		LPFIdx,W
    xorlw		H'0A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF10FreqT
    pagesel		LPF11FreqT
    movf		LPFIdx,W
    xorlw		H'0B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF11FreqT
    pagesel		LPF12FreqT
    movf		LPFIdx,W
    xorlw		H'0C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF12FreqT
    pagesel		LPF13FreqT
    movf		LPFIdx,W
    xorlw		H'0D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF13FreqT
    pagesel		LPF14FreqT
    movf		LPFIdx,W
    xorlw		H'0E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF14FreqT
    pagesel		LPF15FreqT
    movf		LPFIdx,W
    xorlw		H'0F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF15FreqT
    pagesel		LPF16FreqT
    movf		LPFIdx,W
    xorlw		H'10'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF16FreqT
    pagesel		LPF17FreqT
    movf		LPFIdx,W
    xorlw		H'11'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF17FreqT
    pagesel		LPF18FreqT
    movf		LPFIdx,W
    xorlw		H'12'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF18FreqT
    pagesel		LPF19FreqT
    movf		LPFIdx,W
    xorlw		H'13'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF19FreqT
    pagesel		LPF20FreqT
    movf		LPFIdx,W
    xorlw		H'14'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF20FreqT
    pagesel		LPF21FreqT
    movf		LPFIdx,W
    xorlw		H'15'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF21FreqT
    pagesel		LPF22FreqT
    movf		LPFIdx,W
    xorlw		H'16'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF22FreqT
    pagesel		LPF23FreqT
    movf		LPFIdx,W
    xorlw		H'17'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF23FreqT
    pagesel		LPF24FreqT
    movf		LPFIdx,W
    xorlw		H'18'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF24FreqT
    pagesel		LPF25FreqT
    movf		LPFIdx,W
    xorlw		H'19'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF25FreqT
    pagesel		LPF26FreqT
    movf		LPFIdx,W
    xorlw		H'1A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF26FreqT
    pagesel		LPF27FreqT
    movf		LPFIdx,W
    xorlw		H'1B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF27FreqT
    pagesel		LPF28FreqT
    movf		LPFIdx,W
    xorlw		H'1C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF28FreqT
    pagesel		LPF29FreqT
    movf		LPFIdx,W
    xorlw		H'1D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF29FreqT
    pagesel		LPF30FreqT
    movf		LPFIdx,W
    xorlw		H'1E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF30FreqT
    pagesel		LPF31FreqT
    movf		LPFIdx,W
    xorlw		H'1F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF31FreqT
    pagesel		LPF32FreqT
    movf		LPFIdx,W
    xorlw		H'20'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF32FreqT
    pagesel		LPF33FreqT
    movf		LPFIdx,W
    xorlw		H'21'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF33FreqT
    pagesel		LPF34FreqT
    movf		LPFIdx,W
    xorlw		H'22'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF34FreqT
    pagesel		LPF35FreqT
    movf		LPFIdx,W
    xorlw		H'23'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF35FreqT
    pagesel		LPF36FreqT
    movf		LPFIdx,W
    xorlw		H'24'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF36FreqT
    pagesel		LPF37FreqT
    movf		LPFIdx,W
    xorlw		H'25'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF37FreqT
    pagesel		LPF38FreqT
    movf		LPFIdx,W
    xorlw		H'26'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF38FreqT
    pagesel		LPF39FreqT
    movf		LPFIdx,W
    xorlw		H'27'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF39FreqT
    pagesel		LPF40FreqT
    movf		LPFIdx,W
    xorlw		H'28'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF40FreqT
    pagesel		LPF41FreqT
    movf		LPFIdx,W
    xorlw		H'29'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF41FreqT
    pagesel		LPF42FreqT
    movf		LPFIdx,W
    xorlw		H'2A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF42FreqT
    pagesel		LPF43FreqT
    movf		LPFIdx,W
    xorlw		H'2B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF43FreqT
    pagesel		LPF44FreqT
    movf		LPFIdx,W
    xorlw		H'2C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF44FreqT
    pagesel		LPF45FreqT
    movf		LPFIdx,W
    xorlw		H'2D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF45FreqT
    pagesel		LPF46FreqT
    movf		LPFIdx,W
    xorlw		H'2E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF46FreqT
    pagesel		LPF47FreqT
    movf		LPFIdx,W
    xorlw		H'2F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF47FreqT
    pagesel		LPF48FreqT
    movf		LPFIdx,W
    xorlw		H'30'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF48FreqT
    pagesel		LPF49FreqT
    movf		LPFIdx,W
    xorlw		H'31'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF49FreqT
    pagesel		LPF50FreqT
    movf		LPFIdx,W
    xorlw		H'32'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF50FreqT
    pagesel		LPF51FreqT
    movf		LPFIdx,W
    xorlw		H'33'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF51FreqT
    pagesel		LPF52FreqT
    movf		LPFIdx,W
    xorlw		H'34'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF52FreqT
    pagesel		LPF53FreqT
    movf		LPFIdx,W
    xorlw		H'35'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF53FreqT
    pagesel		LPF54FreqT
    movf		LPFIdx,W
    xorlw		H'36'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF54FreqT
    pagesel		LPF55FreqT
    movf		LPFIdx,W
    xorlw		H'37'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF55FreqT
    pagesel		LPF56FreqT
    movf		LPFIdx,W
    xorlw		H'38'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF56FreqT
    pagesel		LPF57FreqT
    movf		LPFIdx,W
    xorlw		H'39'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF57FreqT
    pagesel		LPF58FreqT
    movf		LPFIdx,W
    xorlw		H'3A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF58FreqT
    pagesel		LPF59FreqT
    movf		LPFIdx,W
    xorlw		H'3B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF59FreqT
    pagesel		LPF60FreqT
    movf		LPFIdx,W
    xorlw		H'3C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF60FreqT
    pagesel		LPF61FreqT
    movf		LPFIdx,W
    xorlw		H'3D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF61FreqT
    pagesel		LPF62FreqT
    movf		LPFIdx,W
    xorlw		H'3E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF62FreqT
    pagesel		LPF63FreqT
    movf		LPFIdx,W
    xorlw		H'3F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF63FreqT
    pagesel		LPF64FreqT
    movf		LPFIdx,W
    xorlw		H'40'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF64FreqT
    pagesel		LPF65FreqT
    movf		LPFIdx,W
    xorlw		H'41'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF65FreqT
    pagesel		LPF66FreqT
    movf		LPFIdx,W
    xorlw		H'42'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF66FreqT
    pagesel		LPF67FreqT
    movf		LPFIdx,W
    xorlw		H'43'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF67FreqT
    pagesel		LPF68FreqT
    movf		LPFIdx,W
    xorlw		H'44'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF68FreqT
    pagesel		LPF69FreqT
    movf		LPFIdx,W
    xorlw		H'45'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF69FreqT
    pagesel		LPF70FreqT
    movf		LPFIdx,W
    xorlw		H'46'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF70FreqT
    pagesel		LPF71FreqT
    movf		LPFIdx,W
    xorlw		H'47'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF71FreqT
    pagesel		LPF72FreqT
    movf		LPFIdx,W
    xorlw		H'48'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF72FreqT
    pagesel		LPF73FreqT
    movf		LPFIdx,W
    xorlw		H'49'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF73FreqT
    pagesel		LPF74FreqT
    movf		LPFIdx,W
    xorlw		H'4A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF74FreqT
    pagesel		LPF75FreqT
    movf		LPFIdx,W
    xorlw		H'4B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF75FreqT
    pagesel		LPF76FreqT
    movf		LPFIdx,W
    xorlw		H'4C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF76FreqT
    pagesel		LPF77FreqT
    movf		LPFIdx,W
    xorlw		H'4D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF77FreqT
    pagesel		LPF78FreqT
    movf		LPFIdx,W
    xorlw		H'4E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF78FreqT
    pagesel		LPF79FreqT
    movf		LPFIdx,W
    xorlw		H'4F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF79FreqT
    pagesel		LPF80FreqT
    movf		LPFIdx,W
    xorlw		H'50'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF80FreqT
    pagesel		LPF81FreqT
    movf		LPFIdx,W
    xorlw		H'51'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF81FreqT
    pagesel		LPF82FreqT
    movf		LPFIdx,W
    xorlw		H'52'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF82FreqT
    pagesel		LPF83FreqT
    movf		LPFIdx,W
    xorlw		H'53'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF83FreqT
    pagesel		LPF84FreqT
    movf		LPFIdx,W
    xorlw		H'54'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF84FreqT
    pagesel		LPF85FreqT
    movf		LPFIdx,W
    xorlw		H'55'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF85FreqT
    pagesel		LPF86FreqT
    movf		LPFIdx,W
    xorlw		H'56'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF86FreqT
    pagesel		LPF87FreqT
    movf		LPFIdx,W
    xorlw		H'57'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF87FreqT
    pagesel		LPF88FreqT
    movf		LPFIdx,W
    xorlw		H'58'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF88FreqT
    pagesel		LPF89FreqT
    movf		LPFIdx,W
    xorlw		H'59'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF89FreqT
    pagesel		LPF90FreqT
    movf		LPFIdx,W
    xorlw		H'5A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF90FreqT
    pagesel		LPF91FreqT
    movf		LPFIdx,W
    xorlw		H'5B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF91FreqT
    pagesel		LPF92FreqT
    movf		LPFIdx,W
    xorlw		H'5C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF92FreqT
    pagesel		LPF93FreqT
    movf		LPFIdx,W
    xorlw		H'5D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF93FreqT
    pagesel		LPF94FreqT
    movf		LPFIdx,W
    xorlw		H'5E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF94FreqT
    pagesel		LPF95FreqT
    movf		LPFIdx,W
    xorlw		H'5F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF95FreqT
    pagesel		LPF96FreqT
    movf		LPFIdx,W
    xorlw		H'60'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF96FreqT
    pagesel		LPF97FreqT
    movf		LPFIdx,W
    xorlw		H'61'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF97FreqT
    pagesel		LPF98FreqT
    movf		LPFIdx,W
    xorlw		H'62'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF98FreqT
    pagesel		LPF99FreqT
    movf		LPFIdx,W
    xorlw		H'63'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF99FreqT
    pagesel		LPF100FreqT
    movf		LPFIdx,W
    xorlw		H'64'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF100FreqT
    pagesel		LPF101FreqT
    movf		LPFIdx,W
    xorlw		H'65'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF101FreqT
    pagesel		LPF102FreqT
    movf		LPFIdx,W
    xorlw		H'66'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF102FreqT
    pagesel		LPF103FreqT
    movf		LPFIdx,W
    xorlw		H'67'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF103FreqT
    pagesel		LPF104FreqT
    movf		LPFIdx,W
    xorlw		H'68'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF104FreqT
    pagesel		LPF105FreqT
    movf		LPFIdx,W
    xorlw		H'69'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF105FreqT
    pagesel		LPF106FreqT
    movf		LPFIdx,W
    xorlw		H'6A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF106FreqT
    pagesel		LPF107FreqT
    movf		LPFIdx,W
    xorlw		H'6B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF107FreqT
    pagesel		LPF108FreqT
    movf		LPFIdx,W
    xorlw		H'6C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF108FreqT
    pagesel		LPF109FreqT
    movf		LPFIdx,W
    xorlw		H'6D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF109FreqT
    pagesel		LPF110FreqT
    movf		LPFIdx,W
    xorlw		H'6E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF110FreqT
    pagesel		LPF111FreqT
    movf		LPFIdx,W
    xorlw		H'6F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF111FreqT
    pagesel		LPF112FreqT
    movf		LPFIdx,W
    xorlw		H'70'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF112FreqT
    pagesel		LPF113FreqT
    movf		LPFIdx,W
    xorlw		H'71'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF113FreqT
    pagesel		LPF114FreqT
    movf		LPFIdx,W
    xorlw		H'72'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF114FreqT
    pagesel		LPF115FreqT
    movf		LPFIdx,W
    xorlw		H'73'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF115FreqT
    pagesel		LPF116FreqT
    movf		LPFIdx,W
    xorlw		H'74'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF116FreqT
    pagesel		LPF117FreqT
    movf		LPFIdx,W
    xorlw		H'75'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF117FreqT
    pagesel		LPF118FreqT
    movf		LPFIdx,W
    xorlw		H'76'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF118FreqT
    pagesel		LPF119FreqT
    movf		LPFIdx,W
    xorlw		H'77'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF119FreqT
    pagesel		LPF120FreqT
    movf		LPFIdx,W
    xorlw		H'78'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF120FreqT
    pagesel		LPF121FreqT
    movf		LPFIdx,W
    xorlw		H'79'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF121FreqT
    pagesel		LPF122FreqT
    movf		LPFIdx,W
    xorlw		H'7A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF122FreqT
    pagesel		LPF123FreqT
    movf		LPFIdx,W
    xorlw		H'7B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF123FreqT
    pagesel		LPF124FreqT
    movf		LPFIdx,W
    xorlw		H'7C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF124FreqT
    pagesel		LPF125FreqT
    movf		LPFIdx,W
    xorlw		H'7D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF125FreqT
    pagesel		LPF126FreqT
    movf		LPFIdx,W
    xorlw		H'7E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF126FreqT
    pagesel		LPF127FreqT
    movf		LPFIdx,W
    xorlw		H'7F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		LPF127FreqT


.DisLPF_FreqT		code

LPF0Freq
    clrf		LPFCharIdx
    bcf			STATUS,Z

LPF0FreqT
    movf		LPFCharIdx,W
    pagesel		LPF0Ts
    call		LPF0Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF0FreqT
    goto		LPF0FreqT

LPF1FreqT
    movf		LPFCharIdx,W
    pagesel		LPF1Ts
    call		LPF1Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF1FreqT
    goto		LPF1FreqT

LPF2FreqT
    movf		LPFCharIdx,W
    pagesel		LPF2Ts
    call		LPF2Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF2FreqT
    goto		LPF2FreqT

LPF3FreqT
    movf		LPFCharIdx,W
    pagesel		LPF3Ts
    call		LPF3Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF3FreqT
    goto		LPF3FreqT

LPF4FreqT
    movf		LPFCharIdx,W
    pagesel		LPF4Ts
    call		LPF4Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF4FreqT
    goto		LPF4FreqT

LPF5FreqT
    movf		LPFCharIdx,W
    pagesel		LPF5Ts
    call		LPF5Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF5FreqT
    goto		LPF5FreqT

LPF6FreqT
    movf		LPFCharIdx,W
    pagesel		LPF6Ts
    call		LPF6Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF6FreqT
    goto		LPF6FreqT

LPF7FreqT
    movf		LPFCharIdx,W
    pagesel		LPF7Ts
    call		LPF7Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF7FreqT
    goto		LPF7FreqT

LPF8FreqT
    movf		LPFCharIdx,W
    pagesel		LPF8Ts
    call		LPF8Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF8FreqT
    goto		LPF8FreqT

LPF9FreqT
    movf		LPFCharIdx,W
    pagesel		LPF9Ts
    call		LPF9Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF9FreqT
    goto		LPF9FreqT

LPF10FreqT
    movf		LPFCharIdx,W
    pagesel		LPF10Ts
    call		LPF10Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF10FreqT
    goto		LPF10FreqT

LPF11FreqT
    movf		LPFCharIdx,W
    pagesel		LPF11Ts
    call		LPF11Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF11FreqT
    goto		LPF11FreqT

LPF12FreqT
    movf		LPFCharIdx,W
    pagesel		LPF12Ts
    call		LPF12Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF12FreqT
    goto		LPF12FreqT

LPF13FreqT
    movf		LPFCharIdx,W
    pagesel		LPF13Ts
    call		LPF13Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF13FreqT
    goto		LPF13FreqT

LPF14FreqT
    movf		LPFCharIdx,W
    pagesel		LPF14Ts
    call		LPF14Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF14FreqT
    goto		LPF14FreqT

LPF15FreqT
    movf		LPFCharIdx,W
    pagesel		LPF15Ts
    call		LPF15Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF15FreqT
    goto		LPF15FreqT

LPF16FreqT
    movf		LPFCharIdx,W
    pagesel		LPF16Ts
    call		LPF16Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF16FreqT
    goto		LPF16FreqT

LPF17FreqT
    movf		LPFCharIdx,W
    pagesel		LPF17Ts
    call		LPF17Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF17FreqT
    goto		LPF17FreqT

LPF18FreqT
    movf		LPFCharIdx,W
    pagesel		LPF18Ts
    call		LPF18Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF18FreqT
    goto		LPF18FreqT

LPF19FreqT
    movf		LPFCharIdx,W
    pagesel		LPF19Ts
    call		LPF19Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF19FreqT
    goto		LPF19FreqT

LPF20FreqT
    movf		LPFCharIdx,W
    pagesel		LPF20Ts
    call		LPF20Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF20FreqT
    goto		LPF20FreqT

LPF21FreqT
    movf		LPFCharIdx,W
    pagesel		LPF21Ts
    call		LPF21Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF21FreqT
    goto		LPF21FreqT

LPF22FreqT
    movf		LPFCharIdx,W
    pagesel		LPF22Ts
    call		LPF22Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF22FreqT
    goto		LPF22FreqT

LPF23FreqT
    movf		LPFCharIdx,W
    pagesel		LPF23Ts
    call		LPF23Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF23FreqT
    goto		LPF23FreqT

LPF24FreqT
    movf		LPFCharIdx,W
    pagesel		LPF24Ts
    call		LPF24Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF24FreqT
    goto		LPF24FreqT

LPF25FreqT
    movf		LPFCharIdx,W
    pagesel		LPF25Ts
    call		LPF25Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF25FreqT
    goto		LPF25FreqT

LPF26FreqT
    movf		LPFCharIdx,W
    pagesel		LPF26Ts
    call		LPF26Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF26FreqT
    goto		LPF26FreqT

LPF27FreqT
    movf		LPFCharIdx,W
    pagesel		LPF27Ts
    call		LPF27Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF27FreqT
    goto		LPF27FreqT

LPF28FreqT
    movf		LPFCharIdx,W
    pagesel		LPF28Ts
    call		LPF28Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF28FreqT
    goto		LPF28FreqT

LPF29FreqT
    movf		LPFCharIdx,W
    pagesel		LPF29Ts
    call		LPF29Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF29FreqT
    goto		LPF29FreqT

LPF30FreqT
    movf		LPFCharIdx,W
    pagesel		LPF30Ts
    call		LPF30Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF30FreqT
    goto		LPF30FreqT

LPF31FreqT
    movf		LPFCharIdx,W
    pagesel		LPF31Ts
    call		LPF31Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF31FreqT
    goto		LPF31FreqT

LPF32FreqT
    movf		LPFCharIdx,W
    pagesel		LPF32Ts
    call		LPF32Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF32FreqT
    goto		LPF32FreqT

LPF33FreqT
    movf		LPFCharIdx,W
    pagesel		LPF33Ts
    call		LPF33Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF33FreqT
    goto		LPF33FreqT

LPF34FreqT
    movf		LPFCharIdx,W
    pagesel		LPF34Ts
    call		LPF34Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF34FreqT
    goto		LPF34FreqT

LPF35FreqT
    movf		LPFCharIdx,W
    pagesel		LPF35Ts
    call		LPF35Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF35FreqT
    goto		LPF35FreqT

LPF36FreqT
    movf		LPFCharIdx,W
    pagesel		LPF36Ts
    call		LPF36Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF36FreqT
    goto		LPF36FreqT

LPF37FreqT
    movf		LPFCharIdx,W
    pagesel		LPF37Ts
    call		LPF37Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF37FreqT
    goto		LPF37FreqT

LPF38FreqT
    movf		LPFCharIdx,W
    pagesel		LPF38Ts
    call		LPF38Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF38FreqT
    goto		LPF38FreqT

LPF39FreqT
    movf		LPFCharIdx,W
    pagesel		LPF39Ts
    call		LPF39Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF39FreqT
    goto		LPF39FreqT

LPF40FreqT
    movf		LPFCharIdx,W
    pagesel		LPF40Ts
    call		LPF40Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF40FreqT
    goto		LPF40FreqT

LPF41FreqT
    movf		LPFCharIdx,W
    pagesel		LPF41Ts
    call		LPF41Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF41FreqT
    goto		LPF41FreqT

LPF42FreqT
    movf		LPFCharIdx,W
    pagesel		LPF42Ts
    call		LPF42Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF42FreqT
    goto		LPF42FreqT

LPF43FreqT
    movf		LPFCharIdx,W
    pagesel		LPF43Ts
    call		LPF43Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF43FreqT
    goto		LPF43FreqT

LPF44FreqT
    movf		LPFCharIdx,W
    pagesel		LPF44Ts
    call		LPF44Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF44FreqT
    goto		LPF44FreqT

LPF45FreqT
    movf		LPFCharIdx,W
    pagesel		LPF45Ts
    call		LPF45Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF45FreqT
    goto		LPF45FreqT

LPF46FreqT
    movf		LPFCharIdx,W
    pagesel		LPF46Ts
    call		LPF46Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF46FreqT
    goto		LPF46FreqT

LPF47FreqT
    movf		LPFCharIdx,W
    pagesel		LPF47Ts
    call		LPF47Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF47FreqT
    goto		LPF47FreqT

LPF48FreqT
    movf		LPFCharIdx,W
    pagesel		LPF48Ts
    call		LPF48Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF48FreqT
    goto		LPF48FreqT

LPF49FreqT
    movf		LPFCharIdx,W
    pagesel		LPF49Ts
    call		LPF49Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF49FreqT
    goto		LPF49FreqT

LPF50FreqT
    movf		LPFCharIdx,W
    pagesel		LPF50Ts
    call		LPF50Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF50FreqT
    goto		LPF50FreqT

LPF51FreqT
    movf		LPFCharIdx,W
    pagesel		LPF51Ts
    call		LPF51Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF51FreqT
    goto		LPF51FreqT

LPF52FreqT
    movf		LPFCharIdx,W
    pagesel		LPF52Ts
    call		LPF52Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF52FreqT
    goto		LPF52FreqT

LPF53FreqT
    movf		LPFCharIdx,W
    pagesel		LPF53Ts
    call		LPF53Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF53FreqT
    goto		LPF53FreqT

LPF54FreqT
    movf		LPFCharIdx,W
    pagesel		LPF54Ts
    call		LPF54Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF54FreqT
    goto		LPF54FreqT

LPF55FreqT
    movf		LPFCharIdx,W
    pagesel		LPF55Ts
    call		LPF55Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF55FreqT
    goto		LPF55FreqT

LPF56FreqT
    movf		LPFCharIdx,W
    pagesel		LPF56Ts
    call		LPF56Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF56FreqT
    goto		LPF56FreqT

LPF57FreqT
    movf		LPFCharIdx,W
    pagesel		LPF57Ts
    call		LPF57Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF57FreqT
    goto		LPF57FreqT

LPF58FreqT
    movf		LPFCharIdx,W
    pagesel		LPF58Ts
    call		LPF58Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF58FreqT
    goto		LPF58FreqT

LPF59FreqT
    movf		LPFCharIdx,W
    pagesel		LPF59Ts
    call		LPF59Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF59FreqT
    goto		LPF59FreqT

LPF60FreqT
    movf		LPFCharIdx,W
    pagesel		LPF60Ts
    call		LPF60Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF60FreqT
    goto		LPF60FreqT

LPF61FreqT
    movf		LPFCharIdx,W
    pagesel		LPF61Ts
    call		LPF61Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF61FreqT
    goto		LPF61FreqT

LPF62FreqT
    movf		LPFCharIdx,W
    pagesel		LPF62Ts
    call		LPF62Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF62FreqT
    goto		LPF62FreqT

LPF63FreqT
    movf		LPFCharIdx,W
    pagesel		LPF63Ts
    call		LPF63Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF63FreqT
    goto		LPF63FreqT

LPF64FreqT
    movf		LPFCharIdx,W
    pagesel		LPF64Ts
    call		LPF64Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF64FreqT
    goto		LPF64FreqT

LPF65FreqT
    movf		LPFCharIdx,W
    pagesel		LPF65Ts
    call		LPF65Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF65FreqT
    goto		LPF65FreqT

LPF66FreqT
    movf		LPFCharIdx,W
    pagesel		LPF66Ts
    call		LPF66Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF66FreqT
    goto		LPF66FreqT

LPF67FreqT
    movf		LPFCharIdx,W
    pagesel		LPF67Ts
    call		LPF67Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF67FreqT
    goto		LPF67FreqT

LPF68FreqT
    movf		LPFCharIdx,W
    pagesel		LPF68Ts
    call		LPF68Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF68FreqT
    goto		LPF68FreqT

LPF69FreqT
    movf		LPFCharIdx,W
    pagesel		LPF69Ts
    call		LPF69Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF69FreqT
    goto		LPF69FreqT

LPF70FreqT
    movf		LPFCharIdx,W
    pagesel		LPF70Ts
    call		LPF70Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF70FreqT
    goto		LPF70FreqT

LPF71FreqT
    movf		LPFCharIdx,W
    pagesel		LPF71Ts
    call		LPF71Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF71FreqT
    goto		LPF71FreqT

LPF72FreqT
    movf		LPFCharIdx,W
    pagesel		LPF72Ts
    call		LPF72Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF72FreqT
    goto		LPF72FreqT

LPF73FreqT
    movf		LPFCharIdx,W
    pagesel		LPF73Ts
    call		LPF73Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF73FreqT
    goto		LPF73FreqT

LPF74FreqT
    movf		LPFCharIdx,W
    pagesel		LPF74Ts
    call		LPF74Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF74FreqT
    goto		LPF74FreqT

LPF75FreqT
    movf		LPFCharIdx,W
    pagesel		LPF75Ts
    call		LPF75Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF75FreqT
    goto		LPF75FreqT

LPF76FreqT
    movf		LPFCharIdx,W
    pagesel		LPF76Ts
    call		LPF76Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF76FreqT
    goto		LPF76FreqT

LPF77FreqT
    movf		LPFCharIdx,W
    pagesel		LPF77Ts
    call		LPF77Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF77FreqT
    goto		LPF77FreqT

LPF78FreqT
    movf		LPFCharIdx,W
    pagesel		LPF78Ts
    call		LPF78Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF78FreqT
    goto		LPF78FreqT

LPF79FreqT
    movf		LPFCharIdx,W
    pagesel		LPF79Ts
    call		LPF79Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF79FreqT
    goto		LPF79FreqT

LPF80FreqT
    movf		LPFCharIdx,W
    pagesel		LPF80Ts
    call		LPF80Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF80FreqT
    goto		LPF80FreqT

LPF81FreqT
    movf		LPFCharIdx,W
    pagesel		LPF81Ts
    call		LPF81Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF81FreqT
    goto		LPF81FreqT

LPF82FreqT
    movf		LPFCharIdx,W
    pagesel		LPF82Ts
    call		LPF82Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF82FreqT
    goto		LPF82FreqT

LPF83FreqT
    movf		LPFCharIdx,W
    pagesel		LPF83Ts
    call		LPF83Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF83FreqT
    goto		LPF83FreqT

LPF84FreqT
    movf		LPFCharIdx,W
    pagesel		LPF84Ts
    call		LPF84Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF84FreqT
    goto		LPF84FreqT

LPF85FreqT
    movf		LPFCharIdx,W
    pagesel		LPF85Ts
    call		LPF85Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF85FreqT
    goto		LPF85FreqT

LPF86FreqT
    movf		LPFCharIdx,W
    pagesel		LPF86Ts
    call		LPF86Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF86FreqT
    goto		LPF86FreqT

LPF87FreqT
    movf		LPFCharIdx,W
    pagesel		LPF87Ts
    call		LPF87Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF87FreqT
    goto		LPF87FreqT

LPF88FreqT
    movf		LPFCharIdx,W
    pagesel		LPF88Ts
    call		LPF88Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF88FreqT
    goto		LPF88FreqT

LPF89FreqT
    movf		LPFCharIdx,W
    pagesel		LPF89Ts
    call		LPF89Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF89FreqT
    goto		LPF89FreqT

LPF90FreqT
    movf		LPFCharIdx,W
    pagesel		LPF90Ts
    call		LPF90Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF90FreqT
    goto		LPF90FreqT

LPF91FreqT
    movf		LPFCharIdx,W
    pagesel		LPF91Ts
    call		LPF91Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF91FreqT
    goto		LPF91FreqT

LPF92FreqT
    movf		LPFCharIdx,W
    pagesel		LPF92Ts
    call		LPF92Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF92FreqT
    goto		LPF92FreqT

LPF93FreqT
    movf		LPFCharIdx,W
    pagesel		LPF93Ts
    call		LPF93Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF93FreqT
    goto		LPF93FreqT

LPF94FreqT
    movf		LPFCharIdx,W
    pagesel		LPF94Ts
    call		LPF94Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF94FreqT
    goto		LPF94FreqT

LPF95FreqT
    movf		LPFCharIdx,W
    pagesel		LPF95Ts
    call		LPF95Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF95FreqT
    goto		LPF95FreqT

LPF96FreqT
    movf		LPFCharIdx,W
    pagesel		LPF96Ts
    call		LPF96Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF96FreqT
    goto		LPF96FreqT

LPF97FreqT
    movf		LPFCharIdx,W
    pagesel		LPF97Ts
    call		LPF97Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF97FreqT
    goto		LPF97FreqT

LPF98FreqT
    movf		LPFCharIdx,W
    pagesel		LPF98Ts
    call		LPF98Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF98FreqT
    goto		LPF98FreqT

LPF99FreqT
    movf		LPFCharIdx,W
    pagesel		LPF99Ts
    call		LPF99Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF99FreqT
    goto		LPF99FreqT

LPF100FreqT
    movf		LPFCharIdx,W
    pagesel		LPF100Ts
    call		LPF100Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF100FreqT
    goto		LPF100FreqT

LPF101FreqT
    movf		LPFCharIdx,W
    pagesel		LPF101Ts
    call		LPF101Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF101FreqT
    goto		LPF101FreqT

LPF102FreqT
    movf		LPFCharIdx,W
    pagesel		LPF102Ts
    call		LPF102Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF102FreqT
    goto		LPF102FreqT

LPF103FreqT
    movf		LPFCharIdx,W
    pagesel		LPF103Ts
    call		LPF103Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF103FreqT
    goto		LPF103FreqT

LPF104FreqT
    movf		LPFCharIdx,W
    pagesel		LPF104Ts
    call		LPF104Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF104FreqT
    goto		LPF104FreqT

LPF105FreqT
    movf		LPFCharIdx,W
    pagesel		LPF105Ts
    call		LPF105Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF105FreqT
    goto		LPF105FreqT

LPF106FreqT
    movf		LPFCharIdx,W
    pagesel		LPF106Ts
    call		LPF106Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF106FreqT
    goto		LPF106FreqT

LPF107FreqT
    movf		LPFCharIdx,W
    pagesel		LPF107Ts
    call		LPF107Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF107FreqT
    goto		LPF107FreqT

LPF108FreqT
    movf		LPFCharIdx,W
    pagesel		LPF108Ts
    call		LPF108Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF108FreqT
    goto		LPF108FreqT

LPF109FreqT
    movf		LPFCharIdx,W
    pagesel		LPF109Ts
    call		LPF109Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF109FreqT
    goto		LPF109FreqT

LPF110FreqT
    movf		LPFCharIdx,W
    pagesel		LPF110Ts
    call		LPF110Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF110FreqT
    goto		LPF110FreqT

LPF111FreqT
    movf		LPFCharIdx,W
    pagesel		LPF111Ts
    call		LPF111Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF111FreqT
    goto		LPF111FreqT

LPF112FreqT
    movf		LPFCharIdx,W
    pagesel		LPF112Ts
    call		LPF112Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF112FreqT
    goto		LPF112FreqT

LPF113FreqT
    movf		LPFCharIdx,W
    pagesel		LPF113Ts
    call		LPF113Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF113FreqT
    goto		LPF113FreqT

LPF114FreqT
    movf		LPFCharIdx,W
    pagesel		LPF114Ts
    call		LPF114Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF114FreqT
    goto		LPF114FreqT

LPF115FreqT
    movf		LPFCharIdx,W
    pagesel		LPF115Ts
    call		LPF115Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF115FreqT
    goto		LPF115FreqT

LPF116FreqT
    movf		LPFCharIdx,W
    pagesel		LPF116Ts
    call		LPF116Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF116FreqT
    goto		LPF116FreqT

LPF117FreqT
    movf		LPFCharIdx,W
    pagesel		LPF117Ts
    call		LPF117Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF117FreqT
    goto		LPF117FreqT

LPF118FreqT
    movf		LPFCharIdx,W
    pagesel		LPF118Ts
    call		LPF118Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF118FreqT
    goto		LPF118FreqT

LPF119FreqT
    movf		LPFCharIdx,W
    pagesel		LPF119Ts
    call		LPF119Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF119FreqT
    goto		LPF119FreqT

LPF120FreqT
    movf		LPFCharIdx,W
    pagesel		LPF120Ts
    call		LPF120Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF120FreqT
    goto		LPF120FreqT

LPF121FreqT
    movf		LPFCharIdx,W
    pagesel		LPF121Ts
    call		LPF121Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF121FreqT
    goto		LPF121FreqT

LPF122FreqT
    movf		LPFCharIdx,W
    pagesel		LPF122Ts
    call		LPF122Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF122FreqT
    goto		LPF122FreqT

LPF123FreqT
    movf		LPFCharIdx,W
    pagesel		LPF123Ts
    call		LPF123Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF123FreqT
    goto		LPF123FreqT

LPF124FreqT
    movf		LPFCharIdx,W
    pagesel		LPF124Ts
    call		LPF124Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF124FreqT
    goto		LPF124FreqT

LPF125FreqT
    movf		LPFCharIdx,W
    pagesel		LPF125Ts
    call		LPF125Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF125FreqT
    goto		LPF125FreqT

LPF126FreqT
    movf		LPFCharIdx,W
    pagesel		LPF126Ts
    call		LPF126Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF126FreqT
    goto		LPF126FreqT

LPF127FreqT
    movf		LPFCharIdx,W
    pagesel		LPF127Ts
    call		LPF127Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		LPFCharIdx
    incf		LPFCharIdx,F		; Point to the next char
    pagesel		LPF127FreqT
    goto		LPF127FreqT
    

.DisLPF_Strings		code
LPF0Ts		brw
    dt		"1.000",0
LPF1Ts		brw
    dt		"1.011",0
LPF2Ts		brw
    dt		"1.023",0
LPF3Ts		brw
    dt		"1.035",0
LPF4Ts		brw
    dt		"1.047",0
LPF5Ts		brw
    dt		"1.060",0
LPF6Ts		brw
    dt		"1.073",0
LPF7Ts		brw
    dt		"1.087",0
LPF8Ts		brw
    dt		"1.100",0
LPF9Ts		brw
    dt		"1.114",0
LPF10Ts		brw
    dt		"1.129",0
LPF11Ts		brw
    dt		"1.143",0
LPF12Ts		brw
    dt		"1.158",0
LPF13Ts		brw
    dt		"1.174",0
LPF14Ts		brw
    dt		"1.190",0
LPF15Ts		brw
    dt		"1.206",0
LPF16Ts	    	brw
    dt		"1.223",0
LPF17Ts		brw
    dt		"1.206",0
LPF18Ts		brw
    dt		"1.259",0
LPF19Ts		brw
    dt		"1.277",0
LPF20Ts		brw
    dt		"1.296",0
LPF21Ts		brw
    dt		"1.315",0
LPF22Ts		brw
    dt		"1.335",0
LPF23Ts		brw
    dt		"1.356",0
LPF24Ts		brw
    dt		"1.378",0
LPF25Ts		brw
    dt		"1.400",0
LPF26Ts		brw
    dt		"1.422",0
LPF27Ts		brw
    dt		"1.446",0
LPF28Ts		brw
    dt		"1.470",0
LPF29Ts		brw
    dt		"1.495",0
LPF30Ts		brw
    dt		"1.521",0
LPF31Ts		brw
    dt		"1.548",0
LPF32Ts		brw
    dt		"1.576",0
LPF33Ts		brw
    dt		"1.605",0
LPF34Ts		brw
    dt		"1.635",0
LPF35Ts		brw
    dt		"1.666",0
LPF36Ts		brw
    dt		"1.699",0
LPF37Ts		brw
    dt		"1.732",0
LPF38Ts		brw
    dt		"1.767",0
LPF39Ts		brw
    dt		"1.804",0
LPF40Ts		brw
    dt		"1.842",0
LPF41Ts		brw
    dt		"1.881",0
LPF42Ts		brw
    dt		"1.923",0
LPF43Ts		brw
    dt		"1.966",0
LPF44Ts		brw
    dt		"2.011",0
LPF45Ts		brw
    dt		"2.058",0
LPF46Ts		brw
    dt		"2.108",0
LPF47Ts		brw
    dt		"2.160",0
LPF48Ts		brw
    dt		"2.215",0
LPF49Ts		brw
    dt		"2.272",0
LPF50Ts		brw
    dt		"2.333",0
LPF51Ts		brw
    dt		"2.397",0
LPF52Ts		brw
    dt		"2.464",0
LPF53Ts		brw
    dt		"2.536",0
LPF54Ts		brw
    dt		"2.611",0
LPF55Ts		brw
    dt		"2.692",0
LPF56Ts		brw
    dt		"2.777",0
LPF57Ts		brw
    dt		"2.868",0
LPF58Ts		brw
    dt		"2.966",0
LPF59Ts		brw
    dt		"3.070",0
LPF60Ts		brw
    dt		"3.181",0
LPF61Ts		brw
    dt		"3.301",0
LPF62Ts		brw
    dt		"3.431",0
LPF63Ts		brw
    dt		"3.571",0
LPF64Ts		brw
    dt		"3.571",0
LPF65Ts		brw
    dt		"3.620",0
LPF66Ts		brw
    dt		"3.671",0
LPF67Ts		brw
    dt		"3.723",0
LPF68Ts		brw
    dt		"3.777",0
LPF69Ts		brw
    dt		"3.832",0
LPF70Ts		brw
    dt		"3.888",0
LPF71Ts		brw
    dt		"3.947",0
LPF72Ts		brw
    dt		"4.007",0
LPF73Ts		brw
    dt		"4.069",0
LPF74Ts		brw
    dt		"4.133",0
LPF75Ts		brw
    dt		"4.200",0
LPF76Ts		brw
    dt		"4.268",0
LPF77Ts		brw
    dt		"4.338",0
LPF78Ts		brw
    dt		"4.411",0
LPF79Ts		brw
    dt		"4.487",0
LPF80Ts		brw
    dt		"4.565",0
LPF81Ts		brw
    dt		"4.646",0
LPF82Ts		brw
    dt		"4.729",0
LPF83Ts		brw
    dt		"4.816",0
LPF84Ts		brw
    dt		"4.906",0
LPF85Ts		brw
    dt		"5.000",0
LPF86Ts		brw
    dt		"5.097",0
LPF87Ts		brw
    dt		"5.198",0
LPF88Ts		brw
    dt		"5.303",0
LPF89Ts		brw
    dt		"5.412",0
LPF90Ts		brw
    dt		"5.526",0
LPF91Ts		brw
    dt		"5.645",0
LPF92Ts		brw
    dt		"5.769",0
LPF93Ts		brw
    dt		"5.898",0
LPF94Ts		brw
    dt		"6.034",0
LPF95Ts		brw
    dt		"6.176",0
LPF96Ts		brw
    dt		"6.325",0
LPF97Ts		brw
    dt		"6.481",0
LPF98Ts		brw
    dt		"6.645",0
LPF99Ts		brw
    dt		"6.818",0
LPF100Ts	brw
    dt		"7.008",0
LPF101Ts	brw
    dt		"7.191",0
LPF102Ts	brw
    dt		"7.394",0
LPF103Ts	brw
    dt		"7.608",0
LPF104Ts	brw
    dt		"7.835",0
LPF105Ts	brw
    dt		"8.076",0
LPF106Ts	brw
    dt		"8.333",0
LPF107Ts	brw
    dt		"8.606",0
LPF108Ts	brw
    dt		"8.898",0
LPF109Ts	brw
    dt		"9.210",0
LPF110Ts	brw
    dt		"9.545",0
LPF111Ts	brw
    dt		"9.905",0
LPF112Ts	brw
    dt		"10.29",0
LPF113Ts	brw
    dt		"10.71",0
LPF114Ts	brw
    dt		"11.17",0
LPF115Ts	brw
    dt		"11.67",0
LPF116Ts	brw
    dt		"12.21",0
LPF117Ts	brw
    dt		"12.08",0
LPF118Ts	brw
    dt		"13.46",0
LPF119Ts	brw
    dt		"14.19",0
LPF120Ts	brw
    dt		"15.00",0
LPF121Ts	brw
    dt		"15.91",0
LPF122Ts	brw
    dt		"16.94",0
LPF123Ts	brw
    dt		"18.10",0
LPF124Ts	brw
    dt		"19.44",0
LPF125Ts	brw
    dt		"21.00",0
LPF126Ts	brw
    dt		"22.83",0
LPF127Ts	brw
    dt		"25.00",0
    
    
.SerLPFMess	code
	
SerMessCommLPF
    banksel		LPFCharIdx
    clrf		LPFCharIdx
	
    bcf			STATUS,Z
    pagesel		SerMessCommLPFT
    call 		SerMessCommLPFT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		LPFCharIdx
    incf		LPFCharIdx,F
    goto		SerMessCommLPF
    
SerMessCommLPFT
    ;banksel		CharIdx
    movf		LPFCharIdx,W
    pagesel		SerMessCommLPFTs
    call		SerMessCommLPFTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		LPFCharIdx
    incf		LPFCharIdx,F	; Point to the next char
    pagesel		SerMessCommLPFT
    goto 		SerMessCommLPFT
    
SerMessCommLPFTs
    brw
    dt			"Low Pass Filter ",0       

		        end
