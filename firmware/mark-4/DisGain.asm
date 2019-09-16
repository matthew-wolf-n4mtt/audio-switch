; DisGain.asm
; Version: 1.0
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
    title		'DisGain - Display Gain lines LCD display'
    subtitle	''
    list		b=4,c=132,n=77,x=Off

; ------------------------------------------------------------------------
;**
;  DisLCD
;  Displayes Gain line on the LCD.
;
;  Uses the LCDlib from the Elmer 160.
;**
;
; N4MTT - 26-March-2016
; $Revision 1.0	$Date: 2016-03-26 01441:00 $


    include		p16f1938.inc
			;include		p16f1933.inc

    global		DisGain,SerMessCommGain
    extern		LCDletr
    extern		SerialSendChar


    udata
GainCharIdx	res			1	; Counter for name char index
GainIdx		res			1

				;dt		"-10dB",0

.DisGain			code

DisGain
    banksel		GainIdx
    movwf		GainIdx
    clrf		GainCharIdx

DisGainS
    bcf			STATUS,Z		; Reset Status reg
    pagesel		Gain0Value
    movf		GainIdx,W
    xorlw		H'00'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain0Value
    pagesel		Gain1ValueT
    movf		GainIdx,W
    xorlw		H'01'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain1ValueT
    pagesel		Gain2ValueT
    movf		GainIdx,W
    xorlw		H'02'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain2ValueT
    pagesel		Gain3ValueT
    movf		GainIdx,W
    xorlw		H'03'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain3ValueT
    pagesel		Gain4ValueT
    movf		GainIdx,W
    xorlw		H'04'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain4ValueT
    pagesel		Gain5ValueT
    movf		GainIdx,W
    xorlw		H'05'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain5ValueT
    pagesel		Gain6ValueT
    movf		GainIdx,W
    xorlw		H'06'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain6ValueT
    pagesel		Gain7ValueT
    movf		GainIdx,W
    xorlw		H'07'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain7ValueT
    pagesel		Gain8ValueT
    movf		GainIdx,W
    xorlw		H'08'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain8ValueT
    pagesel		Gain9ValueT
    movf		GainIdx,W
    xorlw		H'09'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain9ValueT
    pagesel		Gain10ValueT
    movf		GainIdx,W
    xorlw		H'0A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain10ValueT
    pagesel		Gain11ValueT
    movf		GainIdx,W
    xorlw		H'0B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain11ValueT
    pagesel		Gain12ValueT
    movf		GainIdx,W
    xorlw		H'0C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain12ValueT
    pagesel		Gain13ValueT
    movf		GainIdx,W
    xorlw		H'0D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain13ValueT
    pagesel		Gain14ValueT
    movf		GainIdx,W
    xorlw		H'0E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain14ValueT
    pagesel		Gain15ValueT
    movf		GainIdx,W
    xorlw		H'0F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain15ValueT
    pagesel		Gain16ValueT
    movf		GainIdx,W
    xorlw		H'10'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain16ValueT
    pagesel		Gain17ValueT
    movf		GainIdx,W
    xorlw		H'11'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain17ValueT
    pagesel		Gain18ValueT
    movf		GainIdx,W
    xorlw		H'12'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain18ValueT
    pagesel		Gain19ValueT
    movf		GainIdx,W
    xorlw		H'13'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain19ValueT
    pagesel		Gain20ValueT
    movf		GainIdx,W
    xorlw		H'14'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain20ValueT
    pagesel		Gain21ValueT
    movf		GainIdx,W
    xorlw		H'15'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain21ValueT
    pagesel		Gain22ValueT
    movf		GainIdx,W
    xorlw		H'16'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain22ValueT
    pagesel		Gain23ValueT
    movf		GainIdx,W
    xorlw		H'17'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain23ValueT
    pagesel		Gain24ValueT
    movf		GainIdx,W
    xorlw		H'18'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain24ValueT
    pagesel		Gain25ValueT
    movf		GainIdx,W
    xorlw		H'19'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain25ValueT
    pagesel		Gain26ValueT
    movf		GainIdx,W
    xorlw		H'1A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain26ValueT
    pagesel		Gain27ValueT
    movf		GainIdx,W
    xorlw		H'1B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain27ValueT
    pagesel		Gain28ValueT
    movf		GainIdx,W
    xorlw		H'1C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain28ValueT
    pagesel		Gain29ValueT
    movf		GainIdx,W
    xorlw		H'1D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain29ValueT
    pagesel		Gain30ValueT
    movf		GainIdx,W
    xorlw		H'1E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain30ValueT
    pagesel		Gain31ValueT
    movf		GainIdx,W
    xorlw		H'1F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain31ValueT
    pagesel		Gain32ValueT
    movf		GainIdx,W
    xorlw		H'20'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain32ValueT
    pagesel		Gain33ValueT
    movf		GainIdx,W
    xorlw		H'21'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain33ValueT
    pagesel		Gain34ValueT
    movf		GainIdx,W
    xorlw		H'22'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain34ValueT
    pagesel		Gain35ValueT
    movf		GainIdx,W
    xorlw		H'23'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain35ValueT
    pagesel		Gain36ValueT
    movf		GainIdx,W
    xorlw		H'24'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain36ValueT
    pagesel		Gain37ValueT
    movf		GainIdx,W
    xorlw		H'25'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain37ValueT
    pagesel		Gain38ValueT
    movf		GainIdx,W
    xorlw		H'26'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain38ValueT
    pagesel		Gain39ValueT
    movf		GainIdx,W
    xorlw		H'27'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain39ValueT
    pagesel		Gain40ValueT
    movf		GainIdx,W
    xorlw		H'28'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain40ValueT
    pagesel		Gain41ValueT
    movf		GainIdx,W
    xorlw		H'29'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain41ValueT
    pagesel		Gain42ValueT
    movf		GainIdx,W
    xorlw		H'2A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain42ValueT
    pagesel		Gain43ValueT
    movf		GainIdx,W
    xorlw		H'2B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain43ValueT
    pagesel		Gain44ValueT
    movf		GainIdx,W
    xorlw		H'2C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain44ValueT
    pagesel		Gain45ValueT
    movf		GainIdx,W
    xorlw		H'2D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain45ValueT
    pagesel		Gain46ValueT
    movf		GainIdx,W
    xorlw		H'2E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain46ValueT
    pagesel		Gain47ValueT
    movf		GainIdx,W
    xorlw		H'2F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain47ValueT
    pagesel		Gain48ValueT
    movf		GainIdx,W
    xorlw		H'30'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain48ValueT
    pagesel		Gain49ValueT
    movf		GainIdx,W
    xorlw		H'31'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain49ValueT
    pagesel		Gain50ValueT
    movf		GainIdx,W
    xorlw		H'32'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain50ValueT
    pagesel		Gain51ValueT
    movf		GainIdx,W
    xorlw		H'33'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain51ValueT
    pagesel		Gain52ValueT
    movf		GainIdx,W
    xorlw		H'34'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain52ValueT
    pagesel		Gain53ValueT
    movf		GainIdx,W
    xorlw		H'35'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain53ValueT
    pagesel		Gain54ValueT
    movf		GainIdx,W
    xorlw		H'36'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain54ValueT
    pagesel		Gain55ValueT
    movf		GainIdx,W
    xorlw		H'37'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain55ValueT
    pagesel		Gain56ValueT
    movf		GainIdx,W
    xorlw		H'38'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain56ValueT
    pagesel		Gain57ValueT
    movf		GainIdx,W
    xorlw		H'39'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain57ValueT
    pagesel		Gain58ValueT
    movf		GainIdx,W
    xorlw		H'3A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain58ValueT
    pagesel		Gain59ValueT
    movf		GainIdx,W
    xorlw		H'3B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain59ValueT
    pagesel		Gain60ValueT
    movf		GainIdx,W
    xorlw		H'3C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain60ValueT
    pagesel		Gain61ValueT
    movf		GainIdx,W
    xorlw		H'3D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain61ValueT
    pagesel		Gain62ValueT
    movf		GainIdx,W
    xorlw		H'3E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain62ValueT
    pagesel		Gain63ValueT
    movf		GainIdx,W
    xorlw		H'3F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain63ValueT
    pagesel		Gain64ValueT
    movf		GainIdx,W
    xorlw		H'40'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain64ValueT
    pagesel		Gain65ValueT
    movf		GainIdx,W
    xorlw		H'41'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain65ValueT
    pagesel		Gain66ValueT
    movf		GainIdx,W
    xorlw		H'42'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain66ValueT
    pagesel		Gain67ValueT
    movf		GainIdx,W
    xorlw		H'43'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain67ValueT
    pagesel		Gain68ValueT
    movf		GainIdx,W
    xorlw		H'44'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain68ValueT
    pagesel		Gain69ValueT
    movf		GainIdx,W
    xorlw		H'45'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain69ValueT
    pagesel		Gain70ValueT
    movf		GainIdx,W
    xorlw		H'46'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain70ValueT
    pagesel		Gain71ValueT
    movf		GainIdx,W
    xorlw		H'47'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain71ValueT
    pagesel		Gain72ValueT
    movf		GainIdx,W
    xorlw		H'48'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain72ValueT
    pagesel		Gain73ValueT
    movf		GainIdx,W
    xorlw		H'49'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain73ValueT
    pagesel		Gain74ValueT
    movf		GainIdx,W
    xorlw		H'4A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain74ValueT
    pagesel		Gain75ValueT
    movf		GainIdx,W
    xorlw		H'4B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain75ValueT
    pagesel		Gain76ValueT
    movf		GainIdx,W
    xorlw		H'4C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain76ValueT
    pagesel		Gain77ValueT
    movf		GainIdx,W
    xorlw		H'4D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain77ValueT
    pagesel		Gain78ValueT
    movf		GainIdx,W
    xorlw		H'4E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain78ValueT
    pagesel		Gain79ValueT
    movf		GainIdx,W
    xorlw		H'4F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain79ValueT
    pagesel		Gain80ValueT
    movf		GainIdx,W
    xorlw		H'50'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain80ValueT
    pagesel		Gain81ValueT
    movf		GainIdx,W
    xorlw		H'51'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain81ValueT
    pagesel		Gain82ValueT
    movf		GainIdx,W
    xorlw		H'52'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain82ValueT
    pagesel		Gain83ValueT
    movf		GainIdx,W
    xorlw		H'53'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain83ValueT
    pagesel		Gain84ValueT
    movf		GainIdx,W
    xorlw		H'54'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain84ValueT
    pagesel		Gain85ValueT
    movf		GainIdx,W
    xorlw		H'55'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain85ValueT
    pagesel		Gain86ValueT
    movf		GainIdx,W
    xorlw		H'56'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain86ValueT
    pagesel		Gain87ValueT
    movf		GainIdx,W
    xorlw		H'57'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain87ValueT
    pagesel		Gain88ValueT
    movf		GainIdx,W
    xorlw		H'58'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain88ValueT
    pagesel		Gain89ValueT
    movf		GainIdx,W
    xorlw		H'59'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain89ValueT
    pagesel		Gain90ValueT
    movf		GainIdx,W
    xorlw		H'5A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain90ValueT
    pagesel		Gain91ValueT
    movf		GainIdx,W
    xorlw		H'5B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain91ValueT
    pagesel		Gain92ValueT
    movf		GainIdx,W
    xorlw		H'5C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain92ValueT
    pagesel		Gain93ValueT
    movf		GainIdx,W
    xorlw		H'5D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain93ValueT
    pagesel		Gain94ValueT
    movf		GainIdx,W
    xorlw		H'5E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain94ValueT
    pagesel		Gain95ValueT
    movf		GainIdx,W
    xorlw		H'5F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain95ValueT
    pagesel		Gain96ValueT
    movf		GainIdx,W
    xorlw		H'60'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain96ValueT
    pagesel		Gain97ValueT
    movf		GainIdx,W
    xorlw		H'61'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain97ValueT
    pagesel		Gain98ValueT
    movf		GainIdx,W
    xorlw		H'62'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain98ValueT
    pagesel		Gain99ValueT
    movf		GainIdx,W
    xorlw		H'63'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain99ValueT
    pagesel		Gain100ValueT
    movf		GainIdx,W
    xorlw		H'64'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain100ValueT
    pagesel		Gain101ValueT
    movf		GainIdx,W
    xorlw		H'65'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain101ValueT
    pagesel		Gain102ValueT
    movf		GainIdx,W
    xorlw		H'66'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain102ValueT
    pagesel		Gain103ValueT
    movf		GainIdx,W
    xorlw		H'67'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain103ValueT
    pagesel		Gain104ValueT
    movf		GainIdx,W
    xorlw		H'68'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain104ValueT
    pagesel		Gain105ValueT
    movf		GainIdx,W
    xorlw		H'69'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain105ValueT
    pagesel		Gain106ValueT
    movf		GainIdx,W
    xorlw		H'6A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain106ValueT
    pagesel		Gain107ValueT
    movf		GainIdx,W
    xorlw		H'6B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain107ValueT
    pagesel		Gain108ValueT
    movf		GainIdx,W
    xorlw		H'6C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain108ValueT
    pagesel		Gain109ValueT
    movf		GainIdx,W
    xorlw		H'6D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain109ValueT
    pagesel		Gain110ValueT
    movf		GainIdx,W
    xorlw		H'6E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain110ValueT
    pagesel		Gain111ValueT
    movf		GainIdx,W
    xorlw		H'6F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain111ValueT
    pagesel		Gain112ValueT
    movf		GainIdx,W
    xorlw		H'70'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain112ValueT
    pagesel		Gain113ValueT
    movf		GainIdx,W
    xorlw		H'71'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain113ValueT
    pagesel		Gain114ValueT
    movf		GainIdx,W
    xorlw		H'72'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain114ValueT
    pagesel		Gain115ValueT
    movf		GainIdx,W
    xorlw		H'73'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain115ValueT
    pagesel		Gain116ValueT
    movf		GainIdx,W
    xorlw		H'74'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain116ValueT
    pagesel		Gain117ValueT
    movf		GainIdx,W
    xorlw		H'75'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain117ValueT
    pagesel		Gain118ValueT
    movf		GainIdx,W
    xorlw		H'76'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain118ValueT
    pagesel		Gain119ValueT
    movf		GainIdx,W
    xorlw		H'77'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain119ValueT
    pagesel		Gain120ValueT
    movf		GainIdx,W
    xorlw		H'78'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain120ValueT
    pagesel		Gain121ValueT
    movf		GainIdx,W
    xorlw		H'79'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain121ValueT
    pagesel		Gain122ValueT
    movf		GainIdx,W
    xorlw		H'7A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain122ValueT
    pagesel		Gain123ValueT
    movf		GainIdx,W
    xorlw		H'7B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain123ValueT
    pagesel		Gain124ValueT
    movf		GainIdx,W
    xorlw		H'7C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain124ValueT
    pagesel		Gain125ValueT
    movf		GainIdx,W
    xorlw		H'7D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain125ValueT
    pagesel		Gain126ValueT
    movf		GainIdx,W
    xorlw		H'7E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain126ValueT
    pagesel		Gain127ValueT
    movf		GainIdx,W
    xorlw		H'7F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain127ValueT
    pagesel		Gain128ValueT
    movf		GainIdx,W
    xorlw		H'80'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain128ValueT
    pagesel		Gain129ValueT
    movf		GainIdx,W
    xorlw		H'81'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain129ValueT
    pagesel		Gain130ValueT
    movf		GainIdx,W
    xorlw		H'82'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain130ValueT
    pagesel		Gain131ValueT
    movf		GainIdx,W
    xorlw		H'83'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain131ValueT
    pagesel		Gain132ValueT
    movf		GainIdx,W
    xorlw		H'84'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain132ValueT
    pagesel		Gain133ValueT
    movf		GainIdx,W
    xorlw		H'85'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain133ValueT
    pagesel		Gain134ValueT
    movf		GainIdx,W
    xorlw		H'86'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain134ValueT
    pagesel		Gain135ValueT
    movf		GainIdx,W
    xorlw		H'87'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain135ValueT
    pagesel		Gain136ValueT
    movf		GainIdx,W
    xorlw		H'88'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain136ValueT
    pagesel		Gain137ValueT
    movf		GainIdx,W
    xorlw		H'89'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain137ValueT
    pagesel		Gain138ValueT
    movf		GainIdx,W
    xorlw		H'8A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain138ValueT
    pagesel		Gain139ValueT
    movf		GainIdx,W
    xorlw		H'8B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain139ValueT
    pagesel		Gain140ValueT
    movf		GainIdx,W
    xorlw		H'8C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain140ValueT
    pagesel		Gain141ValueT
    movf		GainIdx,W
    xorlw		H'8D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain141ValueT
    pagesel		Gain142ValueT
    movf		GainIdx,W
    xorlw		H'8E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain142ValueT
    pagesel		Gain143ValueT
    movf		GainIdx,W
    xorlw		H'8F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain143ValueT
    pagesel		Gain144ValueT
    movf		GainIdx,W
    xorlw		H'90'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain144ValueT
    pagesel		Gain145ValueT
    movf		GainIdx,W
    xorlw		H'91'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain145ValueT
    pagesel		Gain146ValueT
    movf		GainIdx,W
    xorlw		H'92'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain146ValueT
    pagesel		Gain147ValueT
    movf		GainIdx,W
    xorlw		H'93'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain147ValueT
    pagesel		Gain148ValueT
    movf		GainIdx,W
    xorlw		H'94'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain148ValueT
    pagesel		Gain149ValueT
    movf		GainIdx,W
    xorlw		H'95'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain149ValueT
    pagesel		Gain150ValueT
    movf		GainIdx,W
    xorlw		H'96'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain150ValueT
    pagesel		Gain151ValueT
    movf		GainIdx,W
    xorlw		H'97'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain151ValueT
    pagesel		Gain152ValueT
    movf		GainIdx,W
    xorlw		H'98'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain152ValueT
    pagesel		Gain153ValueT
    movf		GainIdx,W
    xorlw		H'99'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain153ValueT
    pagesel		Gain154ValueT
    movf		GainIdx,W
    xorlw		H'9A'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain154ValueT
    pagesel		Gain155ValueT
    movf		GainIdx,W
    xorlw		H'9B'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain155ValueT
    pagesel		Gain156ValueT
    movf		GainIdx,W
    xorlw		H'9C'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain156ValueT
    pagesel		Gain157ValueT
    movf		GainIdx,W
    xorlw		H'9D'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain157ValueT
    pagesel		Gain158ValueT
    movf		GainIdx,W
    xorlw		H'9E'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain158ValueT
    pagesel		Gain159ValueT
    movf		GainIdx,W
    xorlw		H'9F'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain159ValueT
    pagesel		Gain160ValueT
    movf		GainIdx,W
    xorlw		H'A0'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain160ValueT
    pagesel		Gain161ValueT
    movf		GainIdx,W
    xorlw		H'A1'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain161ValueT
    pagesel		Gain162ValueT
    movf		GainIdx,W
    xorlw		H'A2'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain162ValueT
    pagesel		Gain163ValueT
    movf		GainIdx,W
    xorlw		H'A3'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain163ValueT
    pagesel		Gain164ValueT
    movf		GainIdx,W
    xorlw		H'A4'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain164ValueT
    pagesel		Gain165ValueT
    movf		GainIdx,W
    xorlw		H'A5'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain165ValueT
    pagesel		Gain166ValueT
    movf		GainIdx,W
    xorlw		H'A6'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain166ValueT
    pagesel		Gain167ValueT
    movf		GainIdx,W
    xorlw		H'A7'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain167ValueT
    pagesel		Gain168ValueT
    movf		GainIdx,W
    xorlw		H'A8'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain168ValueT
    pagesel		Gain169ValueT
    movf		GainIdx,W
    xorlw		H'A9'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain169ValueT
    pagesel		Gain170ValueT
    movf		GainIdx,W
    xorlw		H'AA'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain170ValueT
    pagesel		Gain171ValueT
    movf		GainIdx,W
    xorlw		H'AB'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain171ValueT
    pagesel		Gain172ValueT
    movf		GainIdx,W
    xorlw		H'AC'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain172ValueT
    pagesel		Gain173ValueT
    movf		GainIdx,W
    xorlw		H'AD'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain173ValueT
    pagesel		Gain174ValueT
    movf		GainIdx,W
    xorlw		H'AE'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain174ValueT
    pagesel		Gain175ValueT
    movf		GainIdx,W
    xorlw		H'AF'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain175ValueT
    pagesel		Gain176ValueT
    movf		GainIdx,W
    xorlw		H'B0'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain176ValueT
    pagesel		Gain177ValueT
    movf		GainIdx,W
    xorlw		H'B1'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain177ValueT
    pagesel		Gain178ValueT
    movf		GainIdx,W
    xorlw		H'B2'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain178ValueT
    pagesel		Gain179ValueT
    movf		GainIdx,W
    xorlw		H'B3'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain179ValueT
    pagesel		Gain180ValueT
    movf		GainIdx,W
    xorlw		H'B4'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain180ValueT
    pagesel		Gain181ValueT
    movf		GainIdx,W
    xorlw		H'B5'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain181ValueT
    pagesel		Gain182ValueT
    movf		GainIdx,W
    xorlw		H'B6'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain182ValueT
    pagesel		Gain183ValueT
    movf		GainIdx,W
    xorlw		H'B7'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain183ValueT
    pagesel		Gain184ValueT
    movf		GainIdx,W
    xorlw		H'B8'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain184ValueT
    pagesel		Gain185ValueT
    movf		GainIdx,W
    xorlw		H'B9'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain185ValueT
    pagesel		Gain186ValueT
    movf		GainIdx,W
    xorlw		H'BA'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain186ValueT
    pagesel		Gain187ValueT
    movf		GainIdx,W
    xorlw		H'BB'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain187ValueT
    pagesel		Gain188ValueT
    movf		GainIdx,W
    xorlw		H'BC'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain188ValueT
    pagesel		Gain189ValueT
    movf		GainIdx,W
    xorlw		H'BD'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain189ValueT
    pagesel		Gain190ValueT
    movf		GainIdx,W
    xorlw		H'BE'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain190ValueT
    pagesel		Gain191ValueT
    movf		GainIdx,W
    xorlw		H'BF'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain191ValueT
    pagesel		Gain192ValueT
    movf		GainIdx,W
    xorlw		H'C0'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain192ValueT
    pagesel		Gain193ValueT
    movf		GainIdx,W
    xorlw		H'C1'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain193ValueT
    pagesel		Gain194ValueT
    movf		GainIdx,W
    xorlw		H'C2'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain194ValueT
    pagesel		Gain195ValueT
    movf		GainIdx,W
    xorlw		H'C3'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain195ValueT
    pagesel		Gain196ValueT
    movf		GainIdx,W
    xorlw		H'C4'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain196ValueT
    pagesel		Gain197ValueT
    movf		GainIdx,W
    xorlw		H'C5'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain197ValueT
    pagesel		Gain198ValueT
    movf		GainIdx,W
    xorlw		H'C6'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain198ValueT
    pagesel		Gain199ValueT
    movf		GainIdx,W
    xorlw		H'C7'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain199ValueT
    pagesel		Gain200ValueT
    movf		GainIdx,W
    xorlw		H'C8'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain200ValueT
    pagesel		Gain201ValueT
    movf		GainIdx,W
    xorlw		H'C9'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain201ValueT
    pagesel		Gain202ValueT
    movf		GainIdx,W
    xorlw		H'CA'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain202ValueT
    pagesel		Gain203ValueT
    movf		GainIdx,W
    xorlw		H'CB'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain203ValueT
    pagesel		Gain204ValueT
    movf		GainIdx,W
    xorlw		H'CC'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain204ValueT
    pagesel		Gain205ValueT
    movf		GainIdx,W
    xorlw		H'CD'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain205ValueT
    pagesel		Gain206ValueT
    movf		GainIdx,W
    xorlw		H'CE'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain206ValueT
    pagesel		Gain207ValueT
    movf		GainIdx,W
    xorlw		H'CF'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain207ValueT
    pagesel		Gain208ValueT
    movf		GainIdx,W
    xorlw		H'D0'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain208ValueT
    pagesel		Gain209ValueT
    movf		GainIdx,W
    xorlw		H'D1'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain209ValueT
    pagesel		Gain210ValueT
    movf		GainIdx,W
    xorlw		H'D2'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain210ValueT
    pagesel		Gain211ValueT
    movf		GainIdx,W
    xorlw		H'D3'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain211ValueT
    pagesel		Gain212ValueT
    movf		GainIdx,W
    xorlw		H'D4'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain212ValueT
    pagesel		Gain213ValueT
    movf		GainIdx,W
    xorlw		H'D5'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain213ValueT
    pagesel		Gain214ValueT
    movf		GainIdx,W
    xorlw		H'D6'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain214ValueT
    pagesel		Gain215ValueT
    movf		GainIdx,W
    xorlw		H'D7'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain215ValueT
    pagesel		Gain216ValueT
    movf		GainIdx,W
    xorlw		H'D8'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain216ValueT
    pagesel		Gain217ValueT
    movf		GainIdx,W
    xorlw		H'D9'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain217ValueT
    pagesel		Gain218ValueT
    movf		GainIdx,W
    xorlw		H'DA'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain218ValueT
    pagesel		Gain219ValueT
    movf		GainIdx,W
    xorlw		H'DB'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain219ValueT
    pagesel		Gain220ValueT
    movf		GainIdx,W
    xorlw		H'DC'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain220ValueT
    pagesel		Gain221ValueT
    movf		GainIdx,W
    xorlw		H'DD'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain221ValueT
    pagesel		Gain222ValueT
    movf		GainIdx,W
    xorlw		H'DE'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain222ValueT
    pagesel		Gain223ValueT
    movf		GainIdx,W
    xorlw		H'DF'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain223ValueT
    pagesel		Gain224ValueT
    movf		GainIdx,W
    xorlw		H'E0'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain224ValueT
    pagesel		Gain225ValueT
    movf		GainIdx,W
    xorlw		H'E1'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain225ValueT
    pagesel		Gain226ValueT
    movf		GainIdx,W
    xorlw		H'E2'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain226ValueT
    pagesel		Gain227ValueT
    movf		GainIdx,W
    xorlw		H'E3'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain227ValueT
    pagesel		Gain228ValueT
    movf		GainIdx,W
    xorlw		H'E4'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain228ValueT
    pagesel		Gain229ValueT
    movf		GainIdx,W
    xorlw		H'E5'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain229ValueT
    pagesel		Gain230ValueT
    movf		GainIdx,W
    xorlw		H'E6'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain230ValueT
    pagesel		Gain231ValueT
    movf		GainIdx,W
    xorlw		H'E7'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain231ValueT
    pagesel		Gain232ValueT
    movf		GainIdx,W
    xorlw		H'E8'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain232ValueT
    pagesel		Gain233ValueT
    movf		GainIdx,W
    xorlw		H'E9'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain233ValueT
    pagesel		Gain234ValueT
    movf		GainIdx,W
    xorlw		H'EA'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain234ValueT
    pagesel		Gain235ValueT
    movf		GainIdx,W
    xorlw		H'EB'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain235ValueT
    pagesel		Gain236ValueT
    movf		GainIdx,W
    xorlw		H'EC'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain236ValueT
    pagesel		Gain237ValueT
    movf		GainIdx,W
    xorlw		H'ED'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain237ValueT
    pagesel		Gain238ValueT
    movf		GainIdx,W
    xorlw		H'EE'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain238ValueT
    pagesel		Gain239ValueT
    movf		GainIdx,W
    xorlw		H'EF'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain239ValueT
    pagesel		Gain240ValueT
    movf		GainIdx,W
    xorlw		H'F0'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain240ValueT
    pagesel		Gain241ValueT
    movf		GainIdx,W
    xorlw		H'F1'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain241ValueT
    pagesel		Gain242ValueT
    movf		GainIdx,W
    xorlw		H'F2'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain242ValueT
    pagesel		Gain243ValueT
    movf		GainIdx,W
    xorlw		H'F3'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain243ValueT
    pagesel		Gain244ValueT
    movf		GainIdx,W
    xorlw		H'F4'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain244ValueT
    pagesel		Gain245ValueT
    movf		GainIdx,W
    xorlw		H'F5'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain245ValueT
    pagesel		Gain246ValueT
    movf		GainIdx,W
    xorlw		H'F6'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain246ValueT
    pagesel		Gain247ValueT
    movf		GainIdx,W
    xorlw		H'F7'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain247ValueT
    pagesel		Gain248ValueT
    movf		GainIdx,W
    xorlw		H'F8'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain248ValueT
    pagesel		Gain249ValueT
    movf		GainIdx,W
    xorlw		H'F9'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain249ValueT
    pagesel		Gain250ValueT
    movf		GainIdx,W
    xorlw		H'FA'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain250ValueT
    pagesel		Gain251ValueT
    movf		GainIdx,W
    xorlw		H'FB'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain251ValueT
    pagesel		Gain252ValueT
    movf		GainIdx,W
    xorlw		H'FC'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain252ValueT
    pagesel		Gain253ValueT
    movf		GainIdx,W
    xorlw		H'FD'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain253ValueT
    pagesel		Gain254ValueT
    movf		GainIdx,W
    xorlw		H'FE'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain254ValueT
    pagesel		Gain255ValueT
    movf		GainIdx,W
    xorlw		H'FF'
    btfsc		STATUS,Z		 ;Was it Zero?
    goto		Gain255ValueT

    return


.Gain_Display		code 

Gain0Value
    clrf		GainCharIdx
    bcf			STATUS,Z

Gain0ValueT
    movf		GainCharIdx,W
    pagesel		Gain0Ts
    call		Gain0Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain0ValueT
    goto		Gain0ValueT

Gain1ValueT
    movf		GainCharIdx,W
    pagesel		Gain1Ts
    call		Gain1Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain1ValueT
    goto		Gain1ValueT

Gain2ValueT
    movf		GainCharIdx,W
    pagesel		Gain2Ts
    call		Gain2Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain2ValueT
    goto		Gain2ValueT

Gain3ValueT
    movf		GainCharIdx,W
    pagesel		Gain3Ts
    call		Gain3Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain3ValueT
    goto		Gain3ValueT

Gain4ValueT
    movf		GainCharIdx,W
    pagesel		Gain4Ts
    call		Gain4Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain4ValueT
    goto		Gain4ValueT

Gain5ValueT
    movf		GainCharIdx,W
    pagesel		Gain5Ts
    call		Gain5Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain5ValueT
    goto		Gain5ValueT

Gain6ValueT
    movf		GainCharIdx,W
    pagesel		Gain6Ts
    call		Gain6Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain6ValueT
    goto		Gain6ValueT

Gain7ValueT
    movf		GainCharIdx,W
    pagesel		Gain7Ts
    call		Gain7Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain7ValueT
    goto		Gain7ValueT

Gain8ValueT
    movf		GainCharIdx,W
    pagesel		Gain8Ts
    call		Gain8Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain8ValueT
    goto		Gain8ValueT

Gain9ValueT
    movf		GainCharIdx,W
    pagesel		Gain9Ts
    call		Gain9Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain9ValueT
    goto		Gain9ValueT

Gain10ValueT
    movf		GainCharIdx,W
    pagesel		Gain10Ts
    call		Gain10Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain10ValueT
    goto		Gain10ValueT

Gain11ValueT
    movf		GainCharIdx,W
    pagesel		Gain11Ts
    call		Gain11Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain11ValueT
    goto		Gain11ValueT

Gain12ValueT
    movf		GainCharIdx,W
    pagesel		Gain12Ts
    call		Gain12Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain12ValueT
    goto		Gain12ValueT

Gain13ValueT
    movf		GainCharIdx,W
    pagesel		Gain13Ts
    call		Gain13Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain13ValueT
    goto		Gain13ValueT

Gain14ValueT
    movf		GainCharIdx,W
    pagesel		Gain14Ts
    call		Gain14Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain14ValueT
    goto		Gain14ValueT

Gain15ValueT
    movf		GainCharIdx,W
    pagesel		Gain15Ts
    call		Gain15Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain15ValueT
    goto		Gain15ValueT

Gain16ValueT
    movf		GainCharIdx,W
    pagesel		Gain16Ts
    call		Gain16Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain16ValueT
    goto		Gain16ValueT

Gain17ValueT
    movf		GainCharIdx,W
    pagesel		Gain17Ts
    call		Gain17Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain17ValueT
    goto		Gain17ValueT

Gain18ValueT
    movf		GainCharIdx,W
    pagesel		Gain18Ts
    call		Gain18Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain18ValueT
    goto		Gain18ValueT

Gain19ValueT
    movf		GainCharIdx,W
    pagesel		Gain19Ts
    call		Gain19Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain19ValueT
    goto		Gain19ValueT

Gain20ValueT
    movf		GainCharIdx,W
    pagesel		Gain20Ts
    call		Gain20Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain20ValueT
    goto		Gain20ValueT

Gain21ValueT
    movf		GainCharIdx,W
    pagesel		Gain21Ts
    call		Gain21Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain21ValueT
    goto		Gain21ValueT

Gain22ValueT
    movf		GainCharIdx,W
    pagesel		Gain22Ts
    call		Gain22Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain22ValueT
    goto		Gain22ValueT

Gain23ValueT
    movf		GainCharIdx,W
    pagesel		Gain23Ts
    call		Gain23Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain23ValueT
    goto		Gain23ValueT

Gain24ValueT
    movf		GainCharIdx,W
    pagesel		Gain24Ts
    call		Gain24Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain24ValueT
    goto		Gain24ValueT

Gain25ValueT
    movf		GainCharIdx,W
    pagesel		Gain25Ts
    call		Gain25Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain25ValueT
    goto		Gain25ValueT

Gain26ValueT
    movf		GainCharIdx,W
    pagesel		Gain26Ts
    call		Gain26Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain26ValueT
    goto		Gain26ValueT

Gain27ValueT
    movf		GainCharIdx,W
    pagesel		Gain27Ts
    call		Gain27Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain27ValueT
    goto		Gain27ValueT

Gain28ValueT
    movf		GainCharIdx,W
    pagesel		Gain28Ts
    call		Gain28Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain28ValueT
    goto		Gain28ValueT

Gain29ValueT
    movf		GainCharIdx,W
    pagesel		Gain29Ts
    call		Gain29Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain29ValueT
    goto		Gain29ValueT

Gain30ValueT
    movf		GainCharIdx,W
    pagesel		Gain30Ts
    call		Gain30Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain30ValueT
    goto		Gain30ValueT

Gain31ValueT
    movf		GainCharIdx,W
    pagesel		Gain31Ts
    call		Gain31Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain31ValueT
    goto		Gain31ValueT

Gain32ValueT
    movf		GainCharIdx,W
    pagesel		Gain32Ts
    call		Gain32Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain32ValueT
    goto		Gain32ValueT

Gain33ValueT
    movf		GainCharIdx,W
    pagesel		Gain33Ts
    call		Gain33Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain33ValueT
    goto		Gain33ValueT

Gain34ValueT
    movf		GainCharIdx,W
    pagesel		Gain34Ts
    call		Gain34Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain34ValueT
    goto		Gain34ValueT

Gain35ValueT
    movf		GainCharIdx,W
    pagesel		Gain35Ts
    call		Gain35Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain35ValueT
    goto		Gain35ValueT

Gain36ValueT
    movf		GainCharIdx,W
    pagesel		Gain36Ts
    call		Gain36Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain36ValueT
    goto		Gain36ValueT

Gain37ValueT
    movf		GainCharIdx,W
    pagesel		Gain37Ts
    call		Gain37Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain37ValueT
    goto		Gain37ValueT

Gain38ValueT
    movf		GainCharIdx,W
    pagesel		Gain38Ts
    call		Gain38Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain38ValueT
    goto		Gain38ValueT

Gain39ValueT
    movf		GainCharIdx,W
    pagesel		Gain39Ts
    call		Gain39Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain39ValueT
    goto		Gain39ValueT

Gain40ValueT
    movf		GainCharIdx,W
    pagesel		Gain40Ts
    call		Gain40Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain40ValueT
    goto		Gain40ValueT

Gain41ValueT
    movf		GainCharIdx,W
    pagesel		Gain41Ts
    call		Gain41Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain41ValueT
    goto		Gain41ValueT

Gain42ValueT
    movf		GainCharIdx,W
    pagesel		Gain42Ts
    call		Gain42Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain42ValueT
    goto		Gain42ValueT

Gain43ValueT
    movf		GainCharIdx,W
    pagesel		Gain43Ts
    call		Gain43Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain43ValueT
    goto		Gain43ValueT

Gain44ValueT
    movf		GainCharIdx,W
    pagesel		Gain44Ts
    call		Gain44Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain44ValueT
    goto		Gain44ValueT

Gain45ValueT
    movf		GainCharIdx,W
    pagesel		Gain45Ts
    call		Gain45Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain45ValueT
    goto		Gain45ValueT

Gain46ValueT
    movf		GainCharIdx,W
    pagesel		Gain46Ts
    call		Gain46Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain46ValueT
    goto		Gain46ValueT

Gain47ValueT
    movf		GainCharIdx,W
    pagesel		Gain47Ts
    call		Gain47Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain47ValueT
    goto		Gain47ValueT

Gain48ValueT
    movf		GainCharIdx,W
    pagesel		Gain48Ts
    call		Gain48Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain48ValueT
    goto		Gain48ValueT

Gain49ValueT
    movf		GainCharIdx,W
    pagesel		Gain49Ts
    call		Gain49Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain49ValueT
    goto		Gain49ValueT

Gain50ValueT
    movf		GainCharIdx,W
    pagesel		Gain50Ts
    call		Gain50Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain50ValueT
    goto		Gain50ValueT

Gain51ValueT
    movf		GainCharIdx,W
    pagesel		Gain51Ts
    call		Gain51Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain51ValueT
    goto		Gain51ValueT

Gain52ValueT
    movf		GainCharIdx,W
    pagesel		Gain52Ts
    call		Gain52Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain52ValueT
    goto		Gain52ValueT

Gain53ValueT
    movf		GainCharIdx,W
    pagesel		Gain53Ts
    call		Gain53Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain53ValueT
    goto		Gain53ValueT

Gain54ValueT
    movf		GainCharIdx,W
    pagesel		Gain54Ts
    call		Gain54Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain54ValueT
    goto		Gain54ValueT

Gain55ValueT
    movf		GainCharIdx,W
    pagesel		Gain55Ts
    call		Gain55Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain55ValueT
    goto		Gain55ValueT

Gain56ValueT
    movf		GainCharIdx,W
    pagesel		Gain56Ts
    call		Gain56Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain56ValueT
    goto		Gain56ValueT

Gain57ValueT
    movf		GainCharIdx,W
    pagesel		Gain57Ts
    call		Gain57Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain57ValueT
    goto		Gain57ValueT

Gain58ValueT
    movf		GainCharIdx,W
    pagesel		Gain58Ts
    call		Gain58Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain58ValueT
    goto		Gain58ValueT

Gain59ValueT
    movf		GainCharIdx,W
    pagesel		Gain59Ts
    call		Gain59Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain59ValueT
    goto		Gain59ValueT

Gain60ValueT
    movf		GainCharIdx,W
    pagesel		Gain60Ts
    call		Gain60Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain60ValueT
    goto		Gain60ValueT

Gain61ValueT
    movf		GainCharIdx,W
    pagesel		Gain61Ts
    call		Gain61Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain61ValueT
    goto		Gain61ValueT

Gain62ValueT
    movf		GainCharIdx,W
    pagesel		Gain62Ts
    call		Gain62Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain62ValueT
    goto		Gain62ValueT

Gain63ValueT
    movf		GainCharIdx,W
    pagesel		Gain63Ts
    call		Gain63Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain63ValueT
    goto		Gain63ValueT

Gain64ValueT
    movf		GainCharIdx,W
    pagesel		Gain64Ts
    call		Gain64Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain64ValueT
    goto		Gain64ValueT

Gain65ValueT
    movf		GainCharIdx,W
    pagesel		Gain65Ts
    call		Gain65Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain65ValueT
    goto		Gain65ValueT

Gain66ValueT
    movf		GainCharIdx,W
    pagesel		Gain66Ts
    call		Gain66Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain66ValueT
    goto		Gain66ValueT

Gain67ValueT
    movf		GainCharIdx,W
    pagesel		Gain67Ts
    call		Gain67Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain67ValueT
    goto		Gain67ValueT

Gain68ValueT
    movf		GainCharIdx,W
    pagesel		Gain68Ts
    call		Gain68Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain68ValueT
    goto		Gain68ValueT

Gain69ValueT
    movf		GainCharIdx,W
    pagesel		Gain69Ts
    call		Gain69Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain69ValueT
    goto		Gain69ValueT

Gain70ValueT
    movf		GainCharIdx,W
    pagesel		Gain70Ts
    call		Gain70Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain70ValueT
    goto		Gain70ValueT

Gain71ValueT
    movf		GainCharIdx,W
    pagesel		Gain71Ts
    call		Gain71Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain71ValueT
    goto		Gain71ValueT

Gain72ValueT
    movf		GainCharIdx,W
    pagesel		Gain72Ts
    call		Gain72Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain72ValueT
    goto		Gain72ValueT

Gain73ValueT
    movf		GainCharIdx,W
    pagesel		Gain73Ts
    call		Gain73Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain73ValueT
    goto		Gain73ValueT

Gain74ValueT
    movf		GainCharIdx,W
    pagesel		Gain74Ts
    call		Gain74Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain74ValueT
    goto		Gain74ValueT

Gain75ValueT
    movf		GainCharIdx,W
    pagesel		Gain75Ts
    call		Gain75Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain75ValueT
    goto		Gain75ValueT

Gain76ValueT
    movf		GainCharIdx,W
    pagesel		Gain76Ts
    call		Gain76Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain76ValueT
    goto		Gain76ValueT

Gain77ValueT
    movf		GainCharIdx,W
    pagesel		Gain77Ts
    call		Gain77Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain77ValueT
    goto		Gain77ValueT

Gain78ValueT
    movf		GainCharIdx,W
    pagesel		Gain78Ts
    call		Gain78Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain78ValueT
    goto		Gain78ValueT

Gain79ValueT
    movf		GainCharIdx,W
    pagesel		Gain79Ts
    call		Gain79Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain79ValueT
    goto		Gain79ValueT

Gain80ValueT
    movf		GainCharIdx,W
    pagesel		Gain80Ts
    call		Gain80Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain80ValueT
    goto		Gain80ValueT

Gain81ValueT
    movf		GainCharIdx,W
    pagesel		Gain81Ts
    call		Gain81Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain81ValueT
    goto		Gain81ValueT

Gain82ValueT
    movf		GainCharIdx,W
    pagesel		Gain82Ts
    call		Gain82Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain82ValueT
    goto		Gain82ValueT

Gain83ValueT
    movf		GainCharIdx,W
    pagesel		Gain83Ts
    call		Gain83Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain83ValueT
    goto		Gain83ValueT

Gain84ValueT
    movf		GainCharIdx,W
    pagesel		Gain84Ts
    call		Gain84Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain84ValueT
    goto		Gain84ValueT

Gain85ValueT
    movf		GainCharIdx,W
    pagesel		Gain85Ts
    call		Gain85Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain85ValueT
    goto		Gain85ValueT

Gain86ValueT
    movf		GainCharIdx,W
    pagesel		Gain86Ts
    call		Gain86Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain86ValueT
    goto		Gain86ValueT

Gain87ValueT
    movf		GainCharIdx,W
    pagesel		Gain87Ts
    call		Gain87Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain87ValueT
    goto		Gain87ValueT

Gain88ValueT
    movf		GainCharIdx,W
    pagesel		Gain88Ts
    call		Gain88Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain88ValueT
    goto		Gain88ValueT

Gain89ValueT
    movf		GainCharIdx,W
    pagesel		Gain89Ts
    call		Gain89Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain89ValueT
    goto		Gain89ValueT

Gain90ValueT
    movf		GainCharIdx,W
    pagesel		Gain90Ts
    call		Gain90Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain90ValueT
    goto		Gain90ValueT

Gain91ValueT
    movf		GainCharIdx,W
    pagesel		Gain91Ts
    call		Gain91Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain91ValueT
    goto		Gain91ValueT

Gain92ValueT
    movf		GainCharIdx,W
    pagesel		Gain92Ts
    call		Gain92Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain92ValueT
    goto		Gain92ValueT

Gain93ValueT
    movf		GainCharIdx,W
    pagesel		Gain93Ts
    call		Gain93Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain93ValueT
    goto		Gain93ValueT

Gain94ValueT
    movf		GainCharIdx,W
    pagesel		Gain94Ts
    call		Gain94Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain94ValueT
    goto		Gain94ValueT

Gain95ValueT
    movf		GainCharIdx,W
    pagesel		Gain95Ts
    call		Gain95Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain95ValueT
    goto		Gain95ValueT

Gain96ValueT
    movf		GainCharIdx,W
    pagesel		Gain96Ts
    call		Gain96Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain96ValueT
    goto		Gain96ValueT

Gain97ValueT
    movf		GainCharIdx,W
    pagesel		Gain97Ts
    call		Gain97Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain97ValueT
    goto		Gain97ValueT

Gain98ValueT
    movf		GainCharIdx,W
    pagesel		Gain98Ts
    call		Gain98Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain98ValueT
    goto		Gain98ValueT

Gain99ValueT
    movf		GainCharIdx,W
    pagesel		Gain99Ts
    call		Gain99Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain99ValueT
    goto		Gain99ValueT

Gain100ValueT
    movf		GainCharIdx,W
    pagesel		Gain100Ts
    call		Gain100Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain100ValueT
    goto		Gain100ValueT

Gain101ValueT
    movf		GainCharIdx,W
    pagesel		Gain101Ts
    call		Gain101Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain101ValueT
    goto		Gain101ValueT

Gain102ValueT
    movf		GainCharIdx,W
    pagesel		Gain102Ts
    call		Gain102Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain102ValueT
    goto		Gain102ValueT

Gain103ValueT
    movf		GainCharIdx,W
    pagesel		Gain103Ts
    call		Gain103Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain103ValueT
    goto		Gain103ValueT

Gain104ValueT
    movf		GainCharIdx,W
    pagesel		Gain104Ts
    call		Gain104Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain104ValueT
    goto		Gain104ValueT

Gain105ValueT
    movf		GainCharIdx,W
    pagesel		Gain105Ts
    call		Gain105Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain105ValueT
    goto		Gain105ValueT

Gain106ValueT
    movf		GainCharIdx,W
    pagesel		Gain106Ts
    call		Gain106Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain106ValueT
    goto		Gain106ValueT

Gain107ValueT
    movf		GainCharIdx,W
    pagesel		Gain107Ts
    call		Gain107Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain107ValueT
    goto		Gain107ValueT

Gain108ValueT
    movf		GainCharIdx,W
    pagesel		Gain108Ts
    call		Gain108Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain108ValueT
    goto		Gain108ValueT

Gain109ValueT
    movf		GainCharIdx,W
    pagesel		Gain109Ts
    call		Gain109Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain109ValueT
    goto		Gain109ValueT

Gain110ValueT
    movf		GainCharIdx,W
    pagesel		Gain110Ts
    call		Gain110Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain110ValueT
    goto		Gain110ValueT

Gain111ValueT
    movf		GainCharIdx,W
    pagesel		Gain111Ts
    call		Gain111Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain111ValueT
    goto		Gain111ValueT

Gain112ValueT
    movf		GainCharIdx,W
    pagesel		Gain112Ts
    call		Gain112Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain112ValueT
    goto		Gain112ValueT

Gain113ValueT
    movf		GainCharIdx,W
    pagesel		Gain113Ts
    call		Gain113Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain113ValueT
    goto		Gain113ValueT

Gain114ValueT
    movf		GainCharIdx,W
    pagesel		Gain114Ts
    call		Gain114Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain114ValueT
    goto		Gain114ValueT

Gain115ValueT
    movf		GainCharIdx,W
    pagesel		Gain115Ts
    call		Gain115Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain115ValueT
    goto		Gain115ValueT

Gain116ValueT
    movf		GainCharIdx,W
    pagesel		Gain116Ts
    call		Gain116Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain116ValueT
    goto		Gain116ValueT

Gain117ValueT
    movf		GainCharIdx,W
    pagesel		Gain117Ts
    call		Gain117Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain117ValueT
    goto		Gain117ValueT

Gain118ValueT
    movf		GainCharIdx,W
    pagesel		Gain118Ts
    call		Gain118Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain118ValueT
    goto		Gain118ValueT

Gain119ValueT
    movf		GainCharIdx,W
    pagesel		Gain119Ts
    call		Gain119Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain119ValueT
    goto		Gain119ValueT

Gain120ValueT
    movf		GainCharIdx,W
    pagesel		Gain120Ts
    call		Gain120Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain120ValueT
    goto		Gain120ValueT

Gain121ValueT
    movf		GainCharIdx,W
    pagesel		Gain121Ts
    call		Gain121Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain121ValueT
    goto		Gain121ValueT

Gain122ValueT
    movf		GainCharIdx,W
    pagesel		Gain122Ts
    call		Gain122Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain122ValueT
    goto		Gain122ValueT

Gain123ValueT
    movf		GainCharIdx,W
    pagesel		Gain123Ts
    call		Gain123Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain123ValueT
    goto		Gain123ValueT

Gain124ValueT
    movf		GainCharIdx,W
    pagesel		Gain124Ts
    call		Gain124Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain124ValueT
    goto		Gain124ValueT

Gain125ValueT
    movf		GainCharIdx,W
    pagesel		Gain125Ts
    call		Gain125Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain125ValueT
    goto		Gain125ValueT

.Gain_Display1		code 
		
Gain126ValueT
    banksel		GainCharIdx
    movf		GainCharIdx,W
    pagesel		Gain126Ts
    call		Gain126Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain126ValueT
    goto		Gain126ValueT

Gain127ValueT
    movf		GainCharIdx,W
    pagesel		Gain127Ts
    call		Gain127Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain127ValueT
    goto		Gain127ValueT

Gain128ValueT
    movf		GainCharIdx,W
    pagesel		Gain128Ts
    call		Gain128Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain128ValueT
    goto		Gain128ValueT

Gain129ValueT
    movf		GainCharIdx,W
    pagesel		Gain129Ts
    call		Gain129Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain129ValueT
    goto		Gain129ValueT

Gain130ValueT
    movf		GainCharIdx,W
    pagesel		Gain130Ts
    call		Gain130Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain130ValueT
    goto		Gain130ValueT

Gain131ValueT
    movf		GainCharIdx,W
    pagesel		Gain131Ts
    call		Gain131Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain131ValueT
    goto		Gain131ValueT

Gain132ValueT
    movf		GainCharIdx,W
    pagesel		Gain132Ts
    call		Gain132Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain132ValueT
    goto		Gain132ValueT

Gain133ValueT
    movf		GainCharIdx,W
    pagesel		Gain133Ts
    call		Gain133Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain133ValueT
    goto		Gain133ValueT

Gain134ValueT
    movf		GainCharIdx,W
    pagesel		Gain134Ts
    call		Gain134Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain134ValueT
    goto		Gain134ValueT

Gain135ValueT
    movf		GainCharIdx,W
    pagesel		Gain135Ts
    call		Gain135Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain135ValueT
    goto		Gain135ValueT

Gain136ValueT
    movf		GainCharIdx,W
    pagesel		Gain136Ts
    call		Gain136Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain136ValueT
    goto		Gain136ValueT

Gain137ValueT
    movf		GainCharIdx,W
    pagesel		Gain137Ts
    call		Gain137Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain137ValueT
    goto		Gain137ValueT

Gain138ValueT
    movf		GainCharIdx,W
    pagesel		Gain138Ts
    call		Gain138Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain138ValueT
    goto		Gain138ValueT

Gain139ValueT
    movf		GainCharIdx,W
    pagesel		Gain139Ts
    call		Gain139Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain139ValueT
    goto		Gain139ValueT

Gain140ValueT
    movf		GainCharIdx,W
    pagesel		Gain140Ts
    call		Gain140Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain140ValueT
    goto		Gain140ValueT

Gain141ValueT
    movf		GainCharIdx,W
    pagesel		Gain141Ts
    call		Gain141Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain141ValueT
    goto		Gain141ValueT

Gain142ValueT
    movf		GainCharIdx,W
    pagesel		Gain142Ts
    call		Gain142Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain142ValueT
    goto		Gain142ValueT

Gain143ValueT
    movf		GainCharIdx,W
    pagesel		Gain143Ts
    call		Gain143Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain143ValueT
    goto		Gain143ValueT

Gain144ValueT
    movf		GainCharIdx,W
    pagesel		Gain144Ts
    call		Gain144Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain144ValueT
    goto		Gain144ValueT

Gain145ValueT
    movf		GainCharIdx,W
    pagesel		Gain145Ts
    call		Gain145Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain145ValueT
    goto		Gain145ValueT

Gain146ValueT
    movf		GainCharIdx,W
    pagesel		Gain146Ts
    call		Gain146Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain146ValueT
    goto		Gain146ValueT

Gain147ValueT
    movf		GainCharIdx,W
    pagesel		Gain147Ts
    call		Gain147Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain147ValueT
    goto		Gain147ValueT

Gain148ValueT
    movf		GainCharIdx,W
    pagesel		Gain148Ts
    call		Gain148Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain148ValueT
    goto		Gain148ValueT

Gain149ValueT
    movf		GainCharIdx,W
    pagesel		Gain149Ts
    call		Gain149Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain149ValueT
    goto		Gain149ValueT

Gain150ValueT
    movf		GainCharIdx,W
    pagesel		Gain150Ts
    call		Gain150Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain150ValueT
    goto		Gain150ValueT

Gain151ValueT
    movf		GainCharIdx,W
    pagesel		Gain151Ts
    call		Gain151Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain151ValueT
    goto		Gain151ValueT

Gain152ValueT
    movf		GainCharIdx,W
    pagesel		Gain152Ts
    call		Gain152Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain152ValueT
    goto		Gain152ValueT

Gain153ValueT
    movf		GainCharIdx,W
    pagesel		Gain153Ts
    call		Gain153Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain153ValueT
    goto		Gain153ValueT

Gain154ValueT
    movf		GainCharIdx,W
    pagesel		Gain154Ts
    call		Gain154Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain154ValueT
    goto		Gain154ValueT

Gain155ValueT
    movf		GainCharIdx,W
    pagesel		Gain155Ts
    call		Gain155Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain155ValueT
    goto		Gain155ValueT

Gain156ValueT
    movf		GainCharIdx,W
    pagesel		Gain156Ts
    call		Gain156Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain156ValueT
    goto		Gain156ValueT

Gain157ValueT
    movf		GainCharIdx,W
    pagesel		Gain157Ts
    call		Gain157Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain157ValueT
    goto		Gain157ValueT

Gain158ValueT
    movf		GainCharIdx,W
    pagesel		Gain158Ts
    call		Gain158Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain158ValueT
    goto		Gain158ValueT

Gain159ValueT
    movf		GainCharIdx,W
    pagesel		Gain159Ts
    call		Gain159Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain159ValueT
    goto		Gain159ValueT

Gain160ValueT
    movf		GainCharIdx,W
    pagesel		Gain160Ts
    call		Gain160Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain160ValueT
    goto		Gain160ValueT

Gain161ValueT
    movf		GainCharIdx,W
    pagesel		Gain161Ts
    call		Gain161Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain161ValueT
    goto		Gain161ValueT

Gain162ValueT
    movf		GainCharIdx,W
    pagesel		Gain162Ts
    call		Gain162Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain162ValueT
    goto		Gain162ValueT

Gain163ValueT
    movf		GainCharIdx,W
    pagesel		Gain163Ts
    call		Gain163Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain163ValueT
    goto		Gain163ValueT

Gain164ValueT
    movf		GainCharIdx,W
    pagesel		Gain164Ts
    call		Gain164Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain164ValueT
    goto		Gain164ValueT

Gain165ValueT
    movf		GainCharIdx,W
    pagesel		Gain165Ts
    call		Gain165Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain165ValueT
    goto		Gain165ValueT

Gain166ValueT
    movf		GainCharIdx,W
    pagesel		Gain166Ts
    call		Gain166Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain166ValueT
    goto		Gain166ValueT

Gain167ValueT
    movf		GainCharIdx,W
    pagesel		Gain167Ts
    call		Gain167Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain167ValueT
    goto		Gain167ValueT

Gain168ValueT
    movf		GainCharIdx,W
    pagesel		Gain168Ts
    call		Gain168Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain168ValueT
    goto		Gain168ValueT

Gain169ValueT
    movf		GainCharIdx,W
    pagesel		Gain169Ts
    call		Gain169Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain169ValueT
    goto		Gain169ValueT

Gain170ValueT
    movf		GainCharIdx,W
    pagesel		Gain170Ts
    call		Gain170Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain170ValueT
    goto		Gain170ValueT

Gain171ValueT
    movf		GainCharIdx,W
    pagesel		Gain171Ts
    call		Gain171Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain171ValueT
    goto		Gain171ValueT

Gain172ValueT
    movf		GainCharIdx,W
    pagesel		Gain172Ts
    call		Gain172Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain172ValueT
    goto		Gain172ValueT

Gain173ValueT
    movf		GainCharIdx,W
    pagesel		Gain173Ts
    call		Gain173Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain173ValueT
    goto		Gain173ValueT

Gain174ValueT
    movf		GainCharIdx,W
    pagesel		Gain174Ts
    call		Gain174Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain174ValueT
    goto		Gain174ValueT

Gain175ValueT
    movf		GainCharIdx,W
    pagesel		Gain175Ts
    call		Gain175Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain175ValueT
    goto		Gain175ValueT

Gain176ValueT
    movf		GainCharIdx,W
    pagesel		Gain176Ts
    call		Gain176Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain176ValueT
    goto		Gain176ValueT

Gain177ValueT
    movf		GainCharIdx,W
    pagesel		Gain177Ts
    call		Gain177Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain177ValueT
    goto		Gain177ValueT

Gain178ValueT
    movf		GainCharIdx,W
    pagesel		Gain178Ts
    call		Gain178Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain178ValueT
    goto		Gain178ValueT

Gain179ValueT
    movf		GainCharIdx,W
    pagesel		Gain179Ts
    call		Gain179Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain179ValueT
    goto		Gain179ValueT

Gain180ValueT
    movf		GainCharIdx,W
    pagesel		Gain180Ts
    call		Gain180Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain180ValueT
    goto		Gain180ValueT

Gain181ValueT
    movf		GainCharIdx,W
    pagesel		Gain181Ts
    call		Gain181Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain181ValueT
    goto		Gain181ValueT

Gain182ValueT
    movf		GainCharIdx,W
    pagesel		Gain182Ts
    call		Gain182Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain182ValueT
    goto		Gain182ValueT

Gain183ValueT
    movf		GainCharIdx,W
    pagesel		Gain183Ts
    call		Gain183Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain183ValueT
    goto		Gain183ValueT

Gain184ValueT
    movf		GainCharIdx,W
    pagesel		Gain184Ts
    call		Gain184Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain184ValueT
    goto		Gain184ValueT

Gain185ValueT
    movf		GainCharIdx,W
    pagesel		Gain185Ts
    call		Gain185Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain185ValueT
    goto		Gain185ValueT

Gain186ValueT
    movf		GainCharIdx,W
    pagesel		Gain186Ts
    call		Gain186Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain186ValueT
    goto		Gain186ValueT

Gain187ValueT
    movf		GainCharIdx,W
    pagesel		Gain187Ts
    call		Gain187Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain187ValueT
    goto		Gain187ValueT

Gain188ValueT
    movf		GainCharIdx,W
    pagesel		Gain188Ts
    call		Gain188Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain188ValueT
    goto		Gain188ValueT

Gain189ValueT
    movf		GainCharIdx,W
    pagesel		Gain189Ts
    call		Gain189Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain189ValueT
    goto		Gain189ValueT

Gain190ValueT
    movf		GainCharIdx,W
    pagesel		Gain190Ts
    call		Gain190Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain190ValueT
    goto		Gain190ValueT

Gain191ValueT
    movf		GainCharIdx,W
    pagesel		Gain191Ts
    call		Gain191Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain191ValueT
    goto		Gain191ValueT

Gain192ValueT
    movf		GainCharIdx,W
    pagesel		Gain192Ts
    call		Gain192Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain192ValueT
    goto		Gain192ValueT

Gain193ValueT
    movf		GainCharIdx,W
    pagesel		Gain193Ts
    call		Gain193Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain193ValueT
    goto		Gain193ValueT

Gain194ValueT
    movf		GainCharIdx,W
    pagesel		Gain194Ts
    call		Gain194Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain194ValueT
    goto		Gain194ValueT

Gain195ValueT
    movf		GainCharIdx,W
    pagesel		Gain195Ts
    call		Gain195Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain195ValueT
    goto		Gain195ValueT

Gain196ValueT
    movf		GainCharIdx,W
    pagesel		Gain196Ts
    call		Gain196Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain196ValueT
    goto		Gain196ValueT

Gain197ValueT
    movf		GainCharIdx,W
    pagesel		Gain197Ts
    call		Gain197Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain197ValueT
    goto		Gain197ValueT

Gain198ValueT
    movf		GainCharIdx,W
    pagesel		Gain198Ts
    call		Gain198Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain198ValueT
    goto		Gain198ValueT

Gain199ValueT
    movf		GainCharIdx,W
    pagesel		Gain199Ts
    call		Gain199Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain199ValueT
    goto		Gain199ValueT

Gain200ValueT
    movf		GainCharIdx,W
    pagesel		Gain200Ts
    call		Gain200Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain200ValueT
    goto		Gain200ValueT

Gain201ValueT
    movf		GainCharIdx,W
    pagesel		Gain201Ts
    call		Gain201Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain201ValueT
    goto		Gain201ValueT

Gain202ValueT
    movf		GainCharIdx,W
    pagesel		Gain202Ts
    call		Gain202Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain202ValueT
    goto		Gain202ValueT

Gain203ValueT
    movf		GainCharIdx,W
    pagesel		Gain203Ts
    call		Gain203Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain203ValueT
    goto		Gain203ValueT

Gain204ValueT
    movf		GainCharIdx,W
    pagesel		Gain204Ts
    call		Gain204Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain204ValueT
    goto		Gain204ValueT

Gain205ValueT
    movf		GainCharIdx,W
    pagesel		Gain205Ts
    call		Gain205Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain205ValueT
    goto		Gain205ValueT

Gain206ValueT
    movf		GainCharIdx,W
    pagesel		Gain206Ts
    call		Gain206Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain206ValueT
    goto		Gain206ValueT

Gain207ValueT
    movf		GainCharIdx,W
    pagesel		Gain207Ts
    call		Gain207Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain207ValueT
    goto		Gain207ValueT

Gain208ValueT
    movf		GainCharIdx,W
    pagesel		Gain208Ts
    call		Gain208Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain208ValueT
    goto		Gain208ValueT

Gain209ValueT
    movf		GainCharIdx,W
    pagesel		Gain209Ts
    call		Gain209Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain209ValueT
    goto		Gain209ValueT

Gain210ValueT
    movf		GainCharIdx,W
    pagesel		Gain210Ts
    call		Gain210Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain210ValueT
    goto		Gain210ValueT

Gain211ValueT
    movf		GainCharIdx,W
    pagesel		Gain211Ts
    call		Gain211Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain211ValueT
    goto		Gain211ValueT

Gain212ValueT
    movf		GainCharIdx,W
    pagesel		Gain212Ts
    call		Gain212Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain212ValueT
    goto		Gain212ValueT

Gain213ValueT
    movf		GainCharIdx,W
    pagesel		Gain213Ts
    call		Gain213Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain213ValueT
    goto		Gain213ValueT

Gain214ValueT
    movf		GainCharIdx,W
    pagesel		Gain214Ts
    call		Gain214Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain214ValueT
    goto		Gain214ValueT

Gain215ValueT
    movf		GainCharIdx,W
    pagesel		Gain215Ts
    call		Gain215Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain215ValueT
    goto		Gain215ValueT

Gain216ValueT
    movf		GainCharIdx,W
    pagesel		Gain216Ts
    call		Gain216Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain216ValueT
    goto		Gain216ValueT

Gain217ValueT
    movf		GainCharIdx,W
    pagesel		Gain217Ts
    call		Gain217Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain217ValueT
    goto		Gain217ValueT

Gain218ValueT
    movf		GainCharIdx,W
    pagesel		Gain218Ts
    call		Gain218Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain218ValueT
    goto		Gain218ValueT

Gain219ValueT
    movf		GainCharIdx,W
    pagesel		Gain219Ts
    call		Gain219Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain219ValueT
    goto		Gain219ValueT

Gain220ValueT
    movf		GainCharIdx,W
    pagesel		Gain220Ts
    call		Gain220Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain220ValueT
    goto		Gain220ValueT

Gain221ValueT
    movf		GainCharIdx,W
    pagesel		Gain221Ts
    call		Gain221Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain221ValueT
    goto		Gain221ValueT

Gain222ValueT
    movf		GainCharIdx,W
    pagesel		Gain222Ts
    call		Gain222Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain222ValueT
    goto		Gain222ValueT

Gain223ValueT
    movf		GainCharIdx,W
    pagesel		Gain223Ts
    call		Gain223Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain223ValueT
    goto		Gain223ValueT

Gain224ValueT
    movf		GainCharIdx,W
    pagesel		Gain224Ts
    call		Gain224Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain224ValueT
    goto		Gain224ValueT

Gain225ValueT
    movf		GainCharIdx,W
    pagesel		Gain225Ts
    call		Gain225Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain225ValueT
    goto		Gain225ValueT

Gain226ValueT
    movf		GainCharIdx,W
    pagesel		Gain226Ts
    call		Gain226Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain226ValueT
    goto		Gain226ValueT

Gain227ValueT
    movf		GainCharIdx,W
    pagesel		Gain227Ts
    call		Gain227Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain227ValueT
    goto		Gain227ValueT

Gain228ValueT
    movf		GainCharIdx,W
    pagesel		Gain228Ts
    call		Gain228Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain228ValueT
    goto		Gain228ValueT

Gain229ValueT
    movf		GainCharIdx,W
    pagesel		Gain229Ts
    call		Gain229Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain229ValueT
    goto		Gain229ValueT

Gain230ValueT
    movf		GainCharIdx,W
    pagesel		Gain230Ts
    call		Gain230Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain230ValueT
    goto		Gain230ValueT

Gain231ValueT
    movf		GainCharIdx,W
    pagesel		Gain231Ts
    call		Gain231Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain231ValueT
    goto		Gain231ValueT

Gain232ValueT
    movf		GainCharIdx,W
    pagesel		Gain232Ts
    call		Gain232Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain232ValueT
    goto		Gain232ValueT

Gain233ValueT
    movf		GainCharIdx,W
    pagesel		Gain233Ts
    call		Gain233Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain233ValueT
    goto		Gain233ValueT

Gain234ValueT
    movf		GainCharIdx,W
    pagesel		Gain234Ts
    call		Gain234Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain234ValueT
    goto		Gain234ValueT

Gain235ValueT
    movf		GainCharIdx,W
    pagesel		Gain235Ts
    call		Gain235Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain235ValueT
    goto		Gain235ValueT

Gain236ValueT
    movf		GainCharIdx,W
    pagesel		Gain236Ts
    call		Gain236Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain236ValueT
    goto		Gain236ValueT

Gain237ValueT
    movf		GainCharIdx,W
    pagesel		Gain237Ts
    call		Gain237Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain237ValueT
    goto		Gain237ValueT

Gain238ValueT
    movf		GainCharIdx,W
    pagesel		Gain238Ts
    call		Gain238Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain238ValueT
    goto		Gain238ValueT

Gain239ValueT
    movf		GainCharIdx,W
    pagesel		Gain239Ts
    call		Gain239Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain239ValueT
    goto		Gain239ValueT

Gain240ValueT
    movf		GainCharIdx,W
    pagesel		Gain240Ts
    call		Gain240Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain240ValueT
    goto		Gain240ValueT

Gain241ValueT
    movf		GainCharIdx,W
    pagesel		Gain241Ts
    call		Gain241Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain241ValueT
    goto		Gain241ValueT

Gain242ValueT
    movf		GainCharIdx,W
    pagesel		Gain242Ts
    call		Gain242Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain242ValueT
    goto		Gain242ValueT

Gain243ValueT
    movf		GainCharIdx,W
    pagesel		Gain243Ts
    call		Gain243Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain243ValueT
    goto		Gain243ValueT

Gain244ValueT
    movf		GainCharIdx,W
    pagesel		Gain244Ts
    call		Gain244Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain244ValueT
    goto		Gain244ValueT

Gain245ValueT
    movf		GainCharIdx,W
    pagesel		Gain245Ts
    call		Gain245Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain245ValueT
    goto		Gain245ValueT

Gain246ValueT
    movf		GainCharIdx,W
    pagesel		Gain246Ts
    call		Gain246Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain246ValueT
    goto		Gain246ValueT

Gain247ValueT
    movf		GainCharIdx,W
    pagesel		Gain247Ts
    call		Gain247Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain247ValueT
    goto		Gain247ValueT

Gain248ValueT
    movf		GainCharIdx,W
    pagesel		Gain248Ts
    call		Gain248Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain248ValueT
    goto		Gain248ValueT

Gain249ValueT
    movf		GainCharIdx,W
    pagesel		Gain249Ts
    call		Gain249Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain249ValueT
    goto		Gain249ValueT

Gain250ValueT
    movf		GainCharIdx,W
    pagesel		Gain250Ts
    call		Gain250Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain250ValueT
    goto		Gain250ValueT

Gain251ValueT
    movf		GainCharIdx,W
    pagesel		Gain251Ts
    call		Gain251Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain251ValueT
    goto		Gain251ValueT

Gain252ValueT
    movf		GainCharIdx,W
    pagesel		Gain252Ts
    call		Gain252Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain252ValueT
    goto		Gain252ValueT

Gain253ValueT
    movf		GainCharIdx,W
    pagesel		Gain253Ts
    call		Gain253Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain253ValueT
    goto		Gain253ValueT

Gain254ValueT
    movf		GainCharIdx,W
    pagesel		Gain254Ts
    call		Gain254Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain254ValueT
    goto		Gain254ValueT

Gain255ValueT
    movf		GainCharIdx,W
    pagesel		Gain255Ts
    call		Gain255Ts
    xorlw		H'00'			; Test to see if char is Zero
    btfsc		STATUS,Z		; Was it Zero?
    return	
    pagesel		LCDletr
    call		LCDletr			; Display Chr on LCD
    banksel		GainCharIdx
    incf		GainCharIdx,F		; Point to the next char
    pagesel		Gain255ValueT
    goto		Gain255ValueT

.Gain_Strings	code

Gain0Ts		brw
    dt		"0    ",0
Gain1Ts		brw
    dt		"1    ",0
Gain2Ts		brw
    dt		"2    ",0
Gain3Ts		brw
    dt		"3    ",0
Gain4Ts		brw
    dt		"4    ",0
Gain5Ts		brw
    dt		"5    ",0
Gain6Ts		brw
    dt		"6    ",0
Gain7Ts		brw
    dt		"7    ",0
Gain8Ts		brw
    dt		"8    ",0
Gain9Ts		brw
    dt		"9    ",0
Gain10Ts	brw
    dt		"10   ",0
Gain11Ts	brw
    dt		"11   ",0
Gain12Ts	brw
    dt		"12   ",0
Gain13Ts	brw
    dt		"13   ",0
Gain14Ts	brw
    dt		"14   ",0
Gain15Ts	brw
    dt		"15   ",0
Gain16Ts	brw
    dt		"16   ",0
Gain17Ts	brw
    dt		"17   ",0
Gain18Ts	brw
    dt		"18   ",0
Gain19Ts	brw
    dt		"19   ",0
Gain20Ts	brw
    dt		"20   ",0
Gain21Ts	brw
    dt		"21   ",0
Gain22Ts	brw
    dt		"22   ",0
Gain23Ts	brw
    dt		"23   ",0
Gain24Ts	brw
    dt		"24   ",0
Gain25Ts	brw
    dt		"25   ",0
Gain26Ts	brw
    dt		"26   ",0
Gain27Ts	brw
    dt		"27   ",0
Gain28Ts	brw
    dt		"28   ",0
Gain29Ts	brw
    dt		"29   ",0
Gain30Ts	brw
    dt		"30   ",0
Gain31Ts	brw
    dt		"31   ",0
Gain32Ts	brw
    dt		"32   ",0
Gain33Ts	brw
    dt		"33   ",0
Gain34Ts	brw
    dt		"34   ",0
Gain35Ts	brw
    dt		"35   ",0
Gain36Ts	brw
    dt		"36   ",0
Gain37Ts	brw
    dt		"37   ",0
Gain38Ts	brw
    dt		"38   ",0
Gain39Ts	brw
    dt		"39   ",0
Gain40Ts	brw
    dt		"40   ",0
Gain41Ts	brw
    dt		"41   ",0
Gain42Ts	brw
    dt		"42   ",0
Gain43Ts	brw
    dt		"43   ",0
Gain44Ts	brw
    dt		"44   ",0
Gain45Ts	brw
    dt		"45   ",0
Gain46Ts	brw
    dt		"46   ",0
Gain47Ts	brw
    dt		"47   ",0
Gain48Ts	brw
    dt		"48   ",0
Gain49Ts	brw
    dt		"49   ",0
Gain50Ts	brw
    dt		"50   ",0
Gain51Ts	brw
    dt		"51   ",0
Gain52Ts	brw
    dt		"52   ",0
Gain53Ts	brw
    dt		"53   ",0
Gain54Ts	brw
    dt		"54   ",0
Gain55Ts	brw
    dt		"55   ",0
Gain56Ts	brw
    dt		"56   ",0
Gain57Ts	brw
    dt		"57   ",0
Gain58Ts	brw
    dt		"58   ",0
Gain59Ts	brw
    dt		"59   ",0
Gain60Ts	brw
    dt		"60   ",0
Gain61Ts	brw
    dt		"61   ",0
Gain62Ts	brw
    dt		"62   ",0
Gain63Ts	brw
    dt		"63   ",0
Gain64Ts	brw
    dt		"64   ",0
Gain65Ts	brw
    dt		"65   ",0
Gain66Ts	brw
    dt		"66   ",0
Gain67Ts	brw
    dt		"67   ",0
Gain68Ts	brw
    dt		"68   ",0
Gain69Ts	brw
    dt		"69   ",0
Gain70Ts	brw
    dt		"70   ",0
Gain71Ts	brw
    dt		"71   ",0
Gain72Ts	brw
    dt		"72   ",0
Gain73Ts	brw
    dt		"73   ",0
Gain74Ts	brw
    dt		"74   ",0
Gain75Ts	brw
    dt		"75   ",0
Gain76Ts	brw
    dt		"76   ",0
Gain77Ts	brw
    dt		"77   ",0
Gain78Ts	brw
    dt		"78   ",0
Gain79Ts	brw
    dt		"79   ",0
Gain80Ts	brw
    dt		"80   ",0
Gain81Ts	brw
    dt		"81   ",0
Gain82Ts	brw
    dt		"82   ",0
Gain83Ts	brw
    dt		"83   ",0
Gain84Ts	brw
    dt		"84   ",0
Gain85Ts	brw
    dt		"85   ",0
Gain86Ts	brw
    dt		"86   ",0
Gain87Ts	brw
    dt		"87   ",0
Gain88Ts	brw
    dt		"88   ",0
Gain89Ts	brw
    dt		"89   ",0
Gain90Ts	brw
    dt		"90   ",0
Gain91Ts	brw
    dt		"91   ",0
Gain92Ts	brw
    dt		"92   ",0
Gain93Ts	brw
    dt		"93   ",0
Gain94Ts	brw
    dt		"94   ",0
Gain95Ts	brw
    dt		"95   ",0
Gain96Ts	brw
    dt		"96   ",0
Gain97Ts	brw
    dt		"97   ",0
Gain98Ts	brw
    dt		"98   ",0
Gain99Ts	brw
    dt		"99   ",0
Gain100Ts	brw
    dt		"100  ",0
Gain101Ts	brw
    dt		"101  ",0
Gain102Ts	brw
    dt		"102  ",0
Gain103Ts	brw
    dt		"103  ",0
Gain104Ts	brw
    dt		"104  ",0
Gain105Ts	brw
    dt		"105  ",0
Gain106Ts	brw
    dt		"106  ",0
Gain107Ts	brw
    dt		"107  ",0
Gain108Ts	brw
    dt		"108  ",0
Gain109Ts	brw
    dt		"109  ",0
Gain110Ts	brw
    dt		"110  ",0
Gain111Ts	brw
    dt		"111  ",0
Gain112Ts	brw
    dt		"112  ",0
Gain113Ts	brw
    dt		"113  ",0
Gain114Ts	brw
    dt		"114  ",0
Gain115Ts	brw
    dt		"115  ",0
Gain116Ts	brw
    dt		"116  ",0
Gain117Ts	brw
    dt		"117  ",0
Gain118Ts	brw
    dt		"118  ",0
Gain119Ts	brw
    dt		"119  ",0
Gain120Ts	brw
    dt		"120  ",0
Gain121Ts	brw
    dt		"121  ",0
Gain122Ts	brw
    dt		"122  ",0
Gain123Ts	brw
    dt		"123  ",0
Gain124Ts	brw
    dt		"124  ",0
Gain125Ts	brw
    dt		"125  ",0
Gain126Ts	brw
    dt		"126  ",0
Gain127Ts	brw
    dt		"127  ",0
Gain128Ts	brw
    dt		"128  ",0
Gain129Ts	brw
    dt		"129  ",0
Gain130Ts	brw
    dt		"130  ",0
Gain131Ts	brw
    dt		"131  ",0
Gain132Ts	brw
    dt		"132  ",0
Gain133Ts	brw
    dt		"133  ",0
Gain134Ts	brw
    dt		"134  ",0
Gain135Ts	brw
    dt		"135  ",0
Gain136Ts	brw
    dt		"136  ",0
Gain137Ts	brw
    dt		"137  ",0
Gain138Ts	brw
    dt		"138  ",0
Gain139Ts	brw
    dt		"139  ",0
Gain140Ts	brw
    dt		"140  ",0
Gain141Ts	brw
    dt		"141  ",0
Gain142Ts	brw
    dt		"142  ",0
Gain143Ts	brw
    dt		"143  ",0
Gain144Ts	brw
    dt		"144  ",0
Gain145Ts	brw
    dt		"145  ",0
Gain146Ts	brw
    dt		"146  ",0
Gain147Ts	brw
    dt		"147  ",0
Gain148Ts	brw
    dt		"148  ",0
Gain149Ts	brw
    dt		"149  ",0
Gain150Ts	brw
    dt		"150  ",0
Gain151Ts	brw
    dt		"151  ",0
Gain152Ts	brw
    dt		"152  ",0
Gain153Ts	brw
    dt		"153  ",0
Gain154Ts	brw
    dt		"154  ",0
Gain155Ts	brw
    dt		"155  ",0
Gain156Ts	brw
    dt		"156  ",0
Gain157Ts	brw
    dt		"157  ",0
Gain158Ts	brw
    dt		"158  ",0
Gain159Ts	brw
    dt		"159  ",0
Gain160Ts	brw
    dt		"160  ",0
Gain161Ts	brw
    dt		"161  ",0
Gain162Ts	brw
    dt		"162  ",0
Gain163Ts	brw
    dt		"163  ",0
Gain164Ts	brw
    dt		"164  ",0
Gain165Ts	brw
    dt		"165  ",0
Gain166Ts	brw
    dt		"166  ",0
Gain167Ts	brw
    dt		"167  ",0
Gain168Ts	brw
    dt		"168  ",0
Gain169Ts	brw
    dt		"169  ",0
Gain170Ts	brw
    dt		"170  ",0
Gain171Ts	brw
    dt		"171  ",0
Gain172Ts	brw
    dt		"172  ",0
Gain173Ts	brw
    dt		"173  ",0
Gain174Ts	brw
    dt		"174  ",0
Gain175Ts	brw
    dt		"175  ",0
Gain176Ts	brw
    dt		"176  ",0
Gain177Ts	brw
    dt		"177  ",0
Gain178Ts	brw
    dt		"178  ",0
Gain179Ts	brw
    dt		"179  ",0
Gain180Ts	brw
    dt		"180  ",0
Gain181Ts	brw
    dt		"181  ",0
Gain182Ts	brw
    dt		"182  ",0
Gain183Ts	brw
    dt		"183  ",0
Gain184Ts	brw
    dt		"184  ",0
Gain185Ts	brw
    dt		"185  ",0
Gain186Ts	brw
    dt		"186  ",0
Gain187Ts	brw
    dt		"187  ",0
Gain188Ts	brw
    dt		"188  ",0
Gain189Ts	brw
    dt		"189  ",0
Gain190Ts	brw
    dt		"190  ",0
Gain191Ts	brw
    dt		"191  ",0
Gain192Ts	brw
    dt		"192  ",0
Gain193Ts	brw
    dt		"193  ",0
Gain194Ts	brw
    dt		"194  ",0
Gain195Ts	brw
    dt		"195  ",0
Gain196Ts	brw
    dt		"196  ",0
Gain197Ts	brw
    dt		"197  ",0
Gain198Ts	brw
    dt		"198  ",0
Gain199Ts	brw
    dt		"199  ",0
Gain200Ts	brw
    dt		"200  ",0
Gain201Ts	brw
    dt		"201  ",0
Gain202Ts	brw
    dt		"202  ",0
Gain203Ts	brw
    dt		"203  ",0
Gain204Ts	brw
    dt		"204  ",0
Gain205Ts	brw
    dt		"205  ",0
Gain206Ts	brw
    dt		"206  ",0
Gain207Ts	brw
    dt		"207  ",0
Gain208Ts	brw
    dt		"208  ",0
Gain209Ts	brw
    dt		"209  ",0
Gain210Ts	brw
    dt		"210  ",0
Gain211Ts	brw
    dt		"211  ",0
Gain212Ts	brw
    dt		"212  ",0
Gain213Ts	brw
    dt		"213  ",0
Gain214Ts	brw
    dt		"214  ",0
Gain215Ts	brw
    dt		"215  ",0
Gain216Ts	brw
    dt		"216  ",0
Gain217Ts	brw
    dt		"217  ",0
Gain218Ts	brw
    dt		"218  ",0
Gain219Ts	brw
    dt		"219  ",0
Gain220Ts	brw
    dt		"220  ",0
Gain221Ts	brw
    dt		"221  ",0
Gain222Ts	brw
    dt		"222  ",0
Gain223Ts	brw
    dt		"223  ",0
Gain224Ts	brw
    dt		"224  ",0
Gain225Ts	brw
    dt		"225  ",0
Gain226Ts	brw
    dt		"226  ",0
Gain227Ts	brw
    dt		"227  ",0
Gain228Ts	brw
    dt		"228  ",0
Gain229Ts	brw
    dt		"229  ",0
Gain230Ts	brw
    dt		"230  ",0
Gain231Ts	brw
    dt		"231  ",0
Gain232Ts	brw
    dt		"232  ",0
Gain233Ts	brw
    dt		"233  ",0
Gain234Ts	brw
    dt		"234  ",0
Gain235Ts	brw
    dt		"235  ",0
Gain236Ts	brw
    dt		"236  ",0
Gain237Ts	brw
    dt		"237  ",0
Gain238Ts	brw
    dt		"238  ",0
Gain239Ts	brw
    dt		"239  ",0
Gain240Ts	brw
    dt		"240  ",0
Gain241Ts	brw
    dt		"241  ",0
Gain242Ts	brw
    dt		"242  ",0
Gain243Ts	brw
    dt		"243  ",0
Gain244Ts	brw
    dt		"244  ",0
Gain245Ts	brw
    dt		"245  ",0
Gain246Ts	brw
    dt		"246  ",0
Gain247Ts	brw
    dt		"247  ",0
Gain248Ts	brw
    dt		"248  ",0
Gain249Ts	brw
    dt		"249  ",0
Gain250Ts	brw
    dt		"250  ",0
Gain251Ts	brw
    dt		"251  ",0
Gain252Ts	brw
    dt		"252  ",0
Gain253Ts	brw
    dt		"253  ",0
Gain254Ts	brw
    dt		"254  ",0
Gain255Ts	brw
    dt		"255  ",0
    
.SerGainMess	code
	
SerMessCommGain
    banksel		GainCharIdx
    clrf		GainCharIdx
	
    bcf			STATUS,Z
    pagesel		SerMessCommGainT
    call 		SerMessCommGainT	; Get Port Name Char
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return

    pagesel		SerialSendChar
    call		SerialSendChar

    banksel		GainCharIdx
    incf		GainCharIdx,F
    goto		SerMessCommGain
    
SerMessCommGainT
    ;banksel		CharIdx
    movf		GainCharIdx,W
    pagesel		SerMessCommGainTs
    call		SerMessCommGainTs
    xorlw		H'00'		; Test to see if char is Zero
    btfsc		STATUS,Z	; Was it Zero?
    return
    pagesel		SerialSendChar
    call		SerialSendChar	; Send Chr
    banksel		GainCharIdx
    incf		GainCharIdx,F	; Point to the next char
    pagesel		SerMessCommGainT
    goto 		SerMessCommGainT
    
SerMessCommGainTs
    brw
    dt			"Gain ",0    

    end

