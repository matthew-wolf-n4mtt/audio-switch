; Audio-Switch.asm
; Version: 4.0
; Author:  Matthew J. Wolf
; Date:    15-APR-2016, Info added 16-SEP-2019
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

; UART is 9600 Baud, 8 bits, no flow control, 1 stop bit, 9600-8-n-1.

; Serial Commands
; ---------------
; ==Input / Output
; 1 - Left Toggle Port Input
; 2 - Right Toggle Port Input
; 3 - A Port Toggle Input
; 4 - B Port Toggle Port Input
; s - Input Status (LCD Display Format)
; S - Serial Status Display
; O - Out Ports Labels
; I - IN Ports Labels
;
; ==Gain
; -Shifted key is UP
; -Unshifted key is Down
; %/5 - Left Port Gain
; ^/6 - Right Port Gain
; &/7 - A Port Gain
; $/4 - B Port Gain
; Out or Progam Memory- Status (LCD Display Format)
; G - Serial Gain Display (Not Printable Characters)
;
; ==Low Pass
; -Shifted key is UP
; -Unshifted key is Down
; (/9 - Left LPF Cutoff
; )/0 - Right LPF Cutoff
; _/- - A LPF Cutoff
; +/= - B LPF Cutoff
; Out or Progam Memory - Status (LCD Display Format)
; F - Serial LPF Display (Not Printable Characters)
;
; Command modes
; ------------
; ==Input / Output
; c	  - Input / Output Commands
; l,r,a,b - Select Output
; 0-7     - Select Input
; Example: cl3 - Connect output to input 3.
;
; == Gain Commands
; g       - Gain Commands
; l,r,a,b - Select Output
; One bit - Hex Base Value for Pot Value.
; Example: gr] - Set the gain of output R to a value of 93, 0x53
;
; == Low Pass Filter Commands
; F       - Gain Commands
; l,r,a,b - Select Output
; One bit - Hex Base Value for Pot Value.
; Example: gr] - Set the gain of output R to a value of 93, 0x53
;

    processor PIC16F1938
    #include <p16f1938.inc>

    ;list	p=16f1933       ; list directive to define processor
    errorlevel -302		; suppress "not in bank 0" message

    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF
    __CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_OFF & _STVREN_OFF & _BORV_19 & _LVP_OFF

    #define			LCD_2_LINE

    extern		DisLName,DisRName,Dis1Name,Dis2Name
    extern		DisInName,DisOutInDiv,DisPortDiv,SerComma
    extern		LCDinit,LCDaddr,LCDletr
    extern		SerDisLName,SerDisRName,SerDis1Name,SerDis2Name
    extern		SerNewLine,SerOutInDiv,SerDisInName,SerDisPortDiv
    extern		SerDisInNum, SerMessEnterComm,SerMessCommPort
    extern		SerMessCommIn,SerMessCommEnd,SerialSendChar
    extern		DisGain,DisLPF,SerMessCommGain,SerMessCommLPF
    extern		Del2ms,Del40us

; Manifest Constants -------------------------------------------------
PB_L		equ	H'00'	; PORTA pin for PB_L
PB_R		equ	H'01'	; PORTA pin for PB_R
PB_A		equ	H'02'	; PORTA pin for PB_A
PB_B		equ	H'03'	; PORTA pin for PB_B

PB_GAIN		equ	H'04'	; Button State Flags
PB_LPF		equ	H'05'
PB_UP	    	equ	H'06'
PB_DOWN		equ	H'07'

PB_GAIN_BIT	equ	H'00'	; PORTC pin for GAIN and UP
PB_LPF_BIT	equ	H'01'	; PORTC pin for LFP and DOWN

PB_UP_BIT	equ	H'00'	; PORTC pin for GAIN and UP
PB_DOWN_BIT	equ	H'01'	; PORTC pin for LFP and DOWN

INPORTNUM	equ	H'08'	; Number of Input Ports
POTMAX		equ	H'FF'	; Maximum Potentiometer Value
POTMIN		equ	H'00'	; Minimum Potentiometer	Value
LPFMAX		equ	D'127'	; Maximum MAX270 LPF Value
LPFMIN		equ	H'00'	; Minimun MAX270 LPF Value

EE_L		equ	H'00'	; EEPROM Locations
EE_R		equ	H'01'
EE_A		equ	H'02'
EE_B		equ	H'03'

EE_L_POT	equ	H'04'
EE_R_POT	equ	H'05'
EE_A_POT	equ	H'06'
EE_B_POT	equ	H'07'

EE_L_LPF	equ	H'08'
EE_R_LPF	equ	H'09'
EE_A_LPF	equ	H'0A'
EE_B_LPF	equ	H'0B'

ReceivedL	equ	H'00'	; Serial command mode status flag bits.
ReceivedR	equ	H'01'
ReceivedA	equ	H'02'
ReceivedB	equ	H'03'
ReceivedC	equ	H'04'
ReceivedG	equ	H'05'
ReceivedF	equ	H'06'

Received_Gain_L	equ	H'00'	; Gain LPF Serial command mode status flag bits.
Received_Gain_R	equ	H'01'
Received_Gain_A	equ	H'02'
Received_Gain_B	equ	H'03'
Received_LPF_L	equ	H'04'
Received_LPF_R	equ	H'05'
Received_LPF_A	equ	H'06'
Received_LPF_B	equ	H'07'

GainLoop	equ	H'06'	; Gain and LPF status flag bits.
LPFLoop		equ	H'07'
GainLPF_UP	equ	H'02'
GainLPF_DOWN	equ	H'03'

LedBlTo		equ	H'06'	; Back light status bit.

I2CMultAddr	equ	B'11100000' ; Last bit 0 selects write operation.

I2CMultNoBus	equ	B'00000000' ; PCA9547 Commands to connect to
I2CMultBus0	equ	B'11111000' ; I2C busses.
I2CMultBus1	equ	B'11111001'
I2CMultBus2	equ	B'11111010'
I2CMultBus3	equ	B'11111011'
I2CMultBus4	equ	B'11111100'
I2CMultBus5	equ	B'00001101'

I2CTopSwitchAddr    equ B'01101010' ; The MAX4584 and MAX4586 use the same
I2CBottomSwitchAddr equ B'01101110' ; two I2C addresses

Switch_Top     equ	B'00000001' ; MAX4584 Selects which MAX4586 to use.
Switch_Bottom  equ	B'00000010' ; Commands select what to connect to COM1.

Switch_1	equ	B'00000001' ; MAX4586 commands to select what
Switch_2	equ	B'00000010' ; terminal to use.
Switch_3	equ	B'00000100'
Switch_4	equ	B'00001000'

;PCF857 I2C IO For MAX270 Adjustible Low Pass Filter
;1 - MAX270 7 bit input for cutoff freq - (P0-P6)
;2 - MAX270 #1 Chip-Select (CS) - P0
;  - MAX270 #2 Chip-Select (CS) - P1
;  - MAX270 #1 Shutdown (SHDN)  - P2
;  - MAX270 #2 Shutdown (SHDN)  - P3
;  - MAX270 Write Control (WR)  - P4
;  - MAX270 Filter Address (A0) - P5
Pcf8574_W1_Addr	equ	B'01000110' ; PCF857 Addresses
Pcf8574_W2_Addr equ	B'01001110' ; Last bit 0 selects write operation.
Pcf8574_R1_Addr equ	B'01000111' ; Last bit 1 selects read operation.
Pcf8574_R2_Addr equ	B'01001111'

;DS103Z-10 10k i2c Potentiometer
; 1 - Channels L and R
; 2 - Channels 1 and 2
; Prototype: 1 is Channel 1 and 2
Ds103_W1_Addr	equ	B'01011110' ; DS103 Addresses
Ds103_W2_Addr	equ	B'01011100' ; Last bit 0 selects write operation.

                                    ; DS103 Commands
Ds103_Both_Pots_cmd equ B'10101011' ; Same value bouth pots.
Ds103_Pot0_cmd  equ	B'10101001' ; Set pot 0 or different values for each pot.
Ds103_Pot1_cmd  equ	B'10101010' ; Set only pot 1 value.

;Led75		equ		H'DF'			;Back Light levels
;Led50		equ		H'80'
;Led25		equ		H'40'
;Led10		equ		H'20'

Led75		equ	H'80' 	; Back Light levels (percent)
Led50		equ	H'40'
Led25		equ	H'20'
Led10		equ	H'10'

LedBLTimeOut	equ	H'01'	; ???? What is this ?????

#define  FOSC        D'4000000'          ; define FOSC to PICmicro
#define  I2CClock    D'400000'           ; define I2C bite rate
#define  ClockValue  (((FOSC/I2CClock)/4) -1) ; ????


; File Registers ------------------------------------------------------
    udata
PortLCount	res	1	; Which input that is connected to the out port.
PortRCount	res	1
PortACount	res	1
PortBCount	res	1

Buttons		res	1	; State file registers.
PB_State	res	1

RXData		res	1	; UART RX Data

MuxSource	res	1	; Used for Mux Chip Commands

Flags		res	1	; Bytes to store state flags.
BlFlags		res	1
CommandFlags	res	1

TimerCount	res	1	; Backlight timer file registers.
NumThSec	res	1
NumSec		res	1
NumMin		res	1

Pcf8574_Data	res	1	; Buffer of PCF8574 data.

Pot_L_Value	res	1	; Digital potentiometer values.
Pot_R_Value	res	1
Pot_A_Value	res	1
Pot_B_Value	res	1

LPF_L_Value	res	1	; The LPF is selected.
LPF_R_Value	res	1
LPF_A_Value	res	1
LPF_B_Value	res	1

Gain_LPF_Flags	res	1	; Gain LPF state flags.
GainLPFCom_Flags res	1

Save		res	1	; Temp Buffers
Address		res	1
Temp		res	1
Test		res	1
Reverse		res	1

; EEPROM Initialization -------------------------------------------------------
DATAEE    	org  		0xF000
    data	H'00',H'01',H'02',H'03' ; Output
    data	H'7E',H'7E',H'7E',H'7E' ; Pot Values
    data	H'7F',H'7F',H'7F',H'7F' ; LPF Values

;		org		0xF005
;   data		'O','n','e',H'00',H'00'
;		org		0xF00B
;   data		'T','w','o',H'00',H'00'
;		org		0xF011
;   data		'T','h','r','e','e'
;		org		0xF017
;   data		'F','o','u','r',H'00'
;		org		0xF01D
;   data		'F','i','v','e',H'00'
;		org		0xF023
;   data		'S','i','x',H'00',H'00'
;		org		0xF029
;   data		'S','e','v','e','n
;		org		0xF02F
;   data		'E','i','g','h','t'

;-------------------------------------------------------------------------------
STARTUP 	org     	0x0000			; processor reset vector
    pagesel	Start
    clrf    	PCLATH
    goto	Start

;		org		0x0004		; place code at interrupt vector
;InterruptCode
;		retfie

Start
    banksel	OSCCON		; Set Internal Clock for 4MHZ
    movlw	B'01101000'
    movwf	OSCCON

    banksel	OSCSTAT		; wait for osc stablise
    btfss	OSCSTAT, HFIOFS	; HFIOFS: stable (0.5%)
    goto $-1

    banksel	APFCON
    clrf	APFCON		; ALT pins not needed

    banksel	PORTA
    clrf	PORTA		; Init PORTA
    banksel	LATA
    clrf	LATA		; No Data Latch
    banksel	ANSELA
    clrf	ANSELA		; All Digital I/O
    banksel	TRISA
    movlw	B'00001111'	; RA 7 to 4 outputs
    movwf	TRISA		; RA 3 to 0 inputs

    banksel	PORTB
    clrf	PORTB		; Init PORTB
    banksel	LATB
    clrf	LATB		; No Data Latch
    banksel	ANSELB
    clrf	ANSELB		; All Digital I/O
    banksel	TRISB
    clrf 	TRISB		; All output

    banksel	PORTC
    clrf	PORTC		; Init PORTC
    banksel	LATC
    clrf	LATC		; No Data Latch
    banksel	TRISC
    movlw	B'10111111'	; RC7 input(RX) RC6 output(TX)
    movwf	TRISC		; RC0 (POT/UP) RC1 (LPF/DOWN) input

    pagesel	SerialSetup
    call 	SerialSetup

    ;pagesel	SerialStartupBanner
    ;call	SerialStartupBanner

    pagesel	I2CMultiResetHigh
    call	I2CMultiResetHigh

    pagesel	I2CSetup
    call	I2CSetup

    pagesel	EEREAD
    call 	EEREAD		; Get Port Count from EEPROM
    banksel	PortLCount
    movwf 	PortLCount	; Store Port count

    call 	EEREAD		; Get Port Count from EEPROM
    banksel	PortRCount
    movwf 	PortRCount	; Store Port count

    call 	EEREAD		; Get Port Count from EEPROM
    banksel	PortACount
    movwf 	PortACount	; Store Port count

    call 	EEREAD		; Get Port Count from EEPROM
    banksel	PortBCount
    movwf 	PortBCount	; Store Port count

    call 	EEREAD		; Get Pot Value from EEPROM
    banksel	Pot_L_Value
    movwf 	Pot_L_Value	; Store Potentiometer Value

    call 	EEREAD		; Get Pot Value from EEPROM
    banksel	Pot_R_Value
    movwf 	Pot_R_Value	; Store Potentiometer Value

    call 	EEREAD		; Get Pot Value from EEPROM
    banksel	Pot_A_Value
    movwf 	Pot_A_Value	; Store Potentiometer Value

    call 	EEREAD		; Get Pot Value from EEPROM
    banksel	Pot_B_Value
    movwf 	Pot_B_Value	; Store Potentiometer Value

    call 	EEREAD		; Get LPF Value from EEPROM
    banksel	LPF_L_Value
    movwf 	LPF_L_Value	; Store Potentiometer Value

    call 	EEREAD		; Get LPF Value from EEPROM
    banksel	LPF_R_Value
    movwf 	LPF_R_Value	; Store Potentiometer Value

    call 	EEREAD		; Get LPF Value from EEPROM
    banksel	LPF_A_Value
    movwf 	LPF_A_Value	; Store Potentiometer Value

    call 	EEREAD		; Get LPF Value from EEPROM
    banksel	LPF_B_Value	; Store Potentiometer Value
    movwf 	LPF_B_Value

    ; DS1803 at init is 0
    ; Is is Max gain from
    ; VCA. Need to restore
    ; value from EE before
    ; enableing MAX270

    banksel	Pcf8574_Data	; Intitialize the two PCF8574
    movlw	H'00'           ; Used for the MAX270
    movwf	Pcf8574_Data	; Low Pass Filters
    movlw	Pcf8574_W1_Addr	; SHDN MAX270 Low on bouth PCF8574
    pagesel	Update_Pcf8574	; SHDN low shut downs MAX270
    call	Update_Pcf8574

    banksel	Pcf8574_Data
    movlw	H'00'
    movwf	Pcf8574_Data
    movlw	Pcf8574_W2_Addr
    pagesel	Update_Pcf8574
    call	Update_Pcf8574

    ;pagesel	Update_L_Pot ; uses values grabbed
    ;call	Update_L_Pot ; from EEPROM
    ;call	Update_R_Pot
    ;call	Update_1_Pot
    ;call	Update_2_Pot

    pagesel	Init_Max270
    call	Init_Max270


    pagesel	LCDinit
    call	LCDinit		; Initialize the LCD

    pagesel	LCDLine1
    call	LCDLine1	; Display 1st line on LCD
    pagesel	LCDLine2
    call	LCDLine2

    banksel	PB_State
    movlw	B'11111111'	; Initialize button state as up.
    movwf	PB_State

    banksel	Gain_LPF_Flags
    clrf	Gain_LPF_Flags

    pagesel	L_Mux
    call	L_Mux		; Initialize Mux's
    pagesel	R_Mux
    call	R_Mux
    pagesel	A_Mux
    call	A_Mux
    pagesel	B_Mux
    call	B_Mux

    pagesel	init_pwm
    call	init_pwm
    pagesel	init_timer0
    call	init_timer0

Loop
    pagesel	Loop

    pagesel	BackLightSubs
    call	BackLightSubs

    pagesel	PB_L_Poll
    call	PB_L_Poll	; Test and Count Button for Port L
    call	PB_R_Poll	; Test and Count Button for Port R
    call	PB_A_Poll	; Test and Count Button for Port 1
    call	PB_B_Poll	; Test and Count Button for Port 2

    pagesel	PB_GAIN_Poll
    call	PB_GAIN_Poll	; Test for Gain Button
    pagesel	PB_LPF_Poll
    call	PB_LPF_Poll	; Test for LPF Button

    pagesel	LCDLine1
    call	LCDLine1	; Display 1st line on LCD
    pagesel	LCDLine2
    call	LCDLine2	; Display 2nd line on LCD

    pagesel	ReceiveSerial
    call	ReceiveSerial	; Get received data if possible

    pagesel	Gain_Loop
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,GainLoop
    goto	Gain_Loop

    pagesel	LPF_Loop
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,LPFLoop
    goto	LPF_Loop

    pagesel	Loop
    goto 	Loop

Gain_Loop
    pagesel	Gain_Loop
    pagesel	BackLightSubs
    call	BackLightSubs

    pagesel	LCDLine1_Gain
    call	LCDLine1_Gain	; Display 1st Gain line on LCD
    pagesel	LCDLine2_Gain
    call	LCDLine2_Gain	; Display 2nd Gain line on LCD


    pagesel	PB_GAIN_Poll
    call	PB_GAIN_Poll

    pagesel	Gain_LPF_Poll_LRAB_PB
    call	Gain_LPF_Poll_LRAB_PB

    banksel	Gain_LPF_Flags

    pagesel	Gain_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_L
    call	Gain_Adjust_Loop

    pagesel	Gain_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_R
    call	Gain_Adjust_Loop

    pagesel	Gain_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_A
    call	Gain_Adjust_Loop

    pagesel	Gain_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_B
    call	Gain_Adjust_Loop

    pagesel	ReceiveSerial
    call	ReceiveSerial	; Get received data if possible

    banksel	Gain_LPF_Flags
    pagesel	Loop
    btfss	Gain_LPF_Flags,GainLoop	; If in Loop; exit loop
    goto	Loop

    pagesel	Gain_Loop
    goto	Gain_Loop

LPF_Loop
    pagesel	LPF_Loop

    pagesel	BackLightSubs
    call	BackLightSubs

    pagesel	LCDLine1_LPF
    call	LCDLine1_LPF	; Display 1st LPF line on LCD
    pagesel	LCDLine2_LPF
    call	LCDLine2_LPF	; Display 2nd LPF line on LCD

    pagesel	PB_LPF_Poll
    call	PB_LPF_Poll

    pagesel	Gain_LPF_Poll_LRAB_PB
    call	Gain_LPF_Poll_LRAB_PB

    banksel	Gain_LPF_Flags

    pagesel	LPF_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_L
    call	LPF_Adjust_Loop

    pagesel	LPF_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_R
    call	LPF_Adjust_Loop

    pagesel	LPF_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_A
    call	LPF_Adjust_Loop

    pagesel	LPF_Adjust_Loop
    btfsc	Gain_LPF_Flags,PB_B
    call	LPF_Adjust_Loop

    pagesel	ReceiveSerial
    call	ReceiveSerial	; Get received data if possible

    banksel	Gain_LPF_Flags
    pagesel	Loop
    btfss	Gain_LPF_Flags,LPFLoop	; If in Loop; exit loop
    goto	Loop

    pagesel	LPF_Loop
    goto	LPF_Loop

; Subroutines ------------------------------------------------------------
SerialSetup

    banksel 	TRISC
    bcf 	TRISC,6		; TX pin
    bsf		TRISC,7		; RX

    banksel 	BAUDCON
    bsf 	BAUDCON, BRG16	; enable 16 bit counter

    banksel	SPBRG
    movlw	D'25'		; 9600 at 4MHZ with 16 bit counter
    movwf	SPBRG

    banksel 	TXSTA
    bsf 	TXSTA, TXEN	; enable TX
    bcf 	TXSTA, SYNC	; disable synchronous
    bcf		TXSTA, BRGH

    banksel 	RCSTA
    bsf 	RCSTA, SPEN	; select TX and RX pins
    bcf		RCSTA,	RX9
    bsf 	RCSTA, CREN	; enable RX

    banksel	Flags
    clrf	Flags		; clear all flags
    clrf	CommandFlags
    clrf	GainLPFCom_Flags

ReceiveSerial
    banksel	PIR1
    btfss	PIR1,RCIF	; check if data
    return			; return if no data

    banksel	RCSTA

    pagesel	ErrSerialOverr
    btfsc	RCSTA,OERR	; if overrun error occurred
    goto	ErrSerialOverr	; then go handle error

    banksel	RCSTA
    pagesel	ErrSerialFrame
    btfsc	RCSTA,FERR	; if framing error occurred
    goto	ErrSerialFrame	; then go handle error

ReceiveSer1
    banksel	RCREG
    movf	RCREG,W		; get received data
    banksel	RXData
    movwf	RXData

    banksel	CommandFlags

    pagesel	CommandL
    btfsc	CommandFlags,ReceivedL
    goto	CommandL

    pagesel	CommandR
    btfsc	CommandFlags,ReceivedR
    goto	CommandR

    btfsc	CommandFlags,ReceivedA
    goto	CommandA

    btfsc	CommandFlags,ReceivedB
    goto	CommandB

    pagesel	CommandMode
    btfsc	CommandFlags,ReceivedC
    goto	CommandMode

    pagesel	GainCommandMode
    btfsc	CommandFlags,ReceivedG
    goto	GainCommandMode

    pagesel	LPFCommandMode
    btfsc	CommandFlags,ReceivedF
    goto	LPFCommandMode

    banksel	GainLPFCom_Flags

    pagesel	GainCommandL
    btfsc	GainLPFCom_Flags,Received_Gain_L
    goto	GainCommandL

    pagesel	GainCommandR
    btfsc	GainLPFCom_Flags,Received_Gain_R
    goto	GainCommandR

    pagesel	GainCommandA
    btfsc	GainLPFCom_Flags,Received_Gain_A
    goto	GainCommandA

    pagesel	GainCommandB
    btfsc	GainLPFCom_Flags,Received_Gain_B
    goto	GainCommandB

    pagesel	LPFCommandL
    btfsc	GainLPFCom_Flags,Received_LPF_L
    goto	LPFCommandL

    pagesel	LPFCommandR
    btfsc	GainLPFCom_Flags,Received_LPF_R
    goto	LPFCommandR

    pagesel	LPFCommandA
    btfsc	GainLPFCom_Flags,Received_LPF_A
    goto	LPFCommandA

    pagesel	LPFCommandB
    btfsc	GainLPFCom_Flags,Received_LPF_B
    goto	LPFCommandB

    pagesel	RecS
    bcf		STATUS,Z

    banksel	RXData

    movf	RXData,W
    xorlw	0x73		;compare with s
    btfsc	STATUS,Z
    goto	RecS

    movf	RXData,W
    xorlw	0x53		;compare with S
    btfsc	STATUS,Z
    goto	RecSerStat

    movf	RXData,W
    xorlw	0x4F		;compare with O
    btfsc	STATUS,Z
    goto	RecO

    movf	RXData,W
    xorlw	0x49		;compare with I
    btfsc	STATUS,Z
    goto	RecIN

    movf	RXData,W
    xorlw	0x63		;compare with c
    btfsc	STATUS,Z
    goto	RecC

    movf	RXData,W
    xorlw	0x31		;compare with 1
    btfsc	STATUS,Z
    goto	RecL

    movf	RXData,W
    xorlw	0x32		;compare with 2
    btfsc	STATUS,Z
    goto	RecR

    movf	RXData,W
    xorlw	0x33		;compare with 3
    btfsc	STATUS,Z
    goto	RecA

    movf	RXData,W
    xorlw	0x34		;compare with 4
    btfsc	STATUS,Z
    goto	RecB

    movf	RXData,W
    xorlw	0x25		;compare with %
    btfsc	STATUS,Z
    goto	RecPSIGN

    movf	RXData,W
    xorlw	0x35		;compare with 5
    btfsc	STATUS,Z
    goto	Rec5

    movf	RXData,W
    xorlw	0x5E		;compare with ^
    btfsc	STATUS,Z
    goto	RecCAR

    movf	RXData,W
    xorlw	0x36		;compare with 6
    btfsc	STATUS,Z
    goto	Rec6

    movf	RXData,W
    xorlw	0x26		;compare with &
    btfsc	STATUS,Z
    goto	RecADD

    movf	RXData,W
    xorlw	0x37		;compare with 7
    btfsc	STATUS,Z
    goto	Rec7

    movf	RXData,W
    xorlw	0x2A		;compare with *
    btfsc	STATUS,Z
    goto	RecSTA

    movf	RXData,W
    xorlw	0x38		;compare with 8
    btfsc	STATUS,Z
    goto	Rec8

    movf	RXData,W
    xorlw	0x28		;compare with (
    btfsc	STATUS,Z
    goto	RecOPENB

    movf	RXData,W
    xorlw	0x39		;compare with 9
    btfsc	STATUS,Z
    goto	Rec9

    movf	RXData,W
    xorlw	0x29		;compare with )
    btfsc	STATUS,Z
    goto	RecCLOSEB

    movf	RXData,W
    xorlw	0x30		;compare with 0
    btfsc	STATUS,Z
    goto	Rec0

    movf	RXData,W
    xorlw	0x5F		;compare with _
    btfsc	STATUS,Z
    goto	RecUNDER

    movf	RXData,W
    xorlw	0x2D		;compare with -
    btfsc	STATUS,Z
    goto	RecMI

    movf	RXData,W
    xorlw	0x2B		;compare with +
    btfsc	STATUS,Z
    goto	RecPL

    movf	RXData,W
    xorlw	0x3D		;compare with =
    btfsc	STATUS,Z
    goto	RecEQ

    movf	RXData,W
    xorlw	0x47		;compare with G
    btfsc	STATUS,Z
    goto	RecG

    movf	RXData,W
    xorlw	0x67		;compare with g
    btfsc	STATUS,Z
    goto	RecLowerG

    movf	RXData,W
    xorlw	0x46		;compare with F
    btfsc	STATUS,Z
    goto	RecF

    movf	RXData,W
    xorlw	0x66		;compare with f
    btfsc	STATUS,Z
    goto	RecLowerF

    return

RecS
    pagesel	SerialS
    call	SerialS
    return

RecSerStat
    pagesel	SerialStatusDisplay
    call	SerialStatusDisplay
    return
RecO
    pagesel	SerialPortDisplay
    call	SerialPortDisplay
    return

RecIN
    pagesel	SerialInDisplay
    call	SerialInDisplay
    return

RecL
    pagesel	IncL
    call	IncL
    return

RecR
    pagesel	IncR
    call	IncR
    return

RecA
    pagesel	IncA
    call	IncA
    return

RecB
    pagesel	IncB
    call	IncB
    return

RecC
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedC
    return
RecPSIGN
    pagesel	Inc_Gain_L
    call	Inc_Gain_L
    return
Rec5
    pagesel	Dec_Gain_L
    call	Dec_Gain_L
    return
RecCAR
    pagesel	Inc_Gain_R
    call	Inc_Gain_R
    return
Rec6
    pagesel	Dec_Gain_R
    call	Dec_Gain_R
    return
RecADD
    pagesel	Inc_Gain_A
    call	Inc_Gain_A
    return
Rec7
    pagesel	Dec_Gain_A
    call	Dec_Gain_A
    return
RecSTA
    pagesel	Inc_Gain_B
    call	Inc_Gain_B
    return
Rec8
    pagesel	Dec_Gain_B
    call	Dec_Gain_B
    return
RecOPENB
    pagesel	Inc_LPF_L
    call	Inc_LPF_L
    return
Rec9
    pagesel	Dec_LPF_L
    call	Dec_LPF_L
    return
RecCLOSEB
    pagesel	Inc_LPF_R
    call	Inc_LPF_R
    return
Rec0
    pagesel	Dec_LPF_R
    call	Dec_LPF_R
    return
RecUNDER
    pagesel	Inc_LPF_A
    call	Inc_LPF_A
    return
RecMI
    pagesel	Dec_LPF_A
    call	Dec_LPF_A
    return
RecPL
    pagesel	Inc_LPF_B
    call	Inc_LPF_B
    return
RecEQ
    pagesel	Dec_LPF_B
    call	Dec_LPF_B
    return
RecG
    pagesel	SerialGainStatusDisplay
    call	SerialGainStatusDisplay
    return
RecF
    pagesel	SerialLPFStatusDisplay
    call	SerialLPFStatusDisplay
    return

RecLowerG
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedG
    return
RecLowerF
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedF
    return

ComRecL
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedL
    bcf		CommandFlags,ReceivedC
    return

ComRecR
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedR
    bcf		CommandFlags,ReceivedC
    return

ComRecA
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedA
    bcf		CommandFlags,ReceivedC
    return

ComRecB
    banksel	CommandFlags
    bsf		CommandFlags,ReceivedB
    bcf		CommandFlags,ReceivedC
    return

GainComRecL
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_Gain_L
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedG
    return

GainComRecR
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_Gain_R
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedG
    return

GainComRecA
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_Gain_A
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedG
    return

GainComRecB
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_Gain_B
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedG
    return

LPFComRecL
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_LPF_L
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedF
    return

LPFComRecR
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_LPF_R
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedF
    return

LPFComRecA
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_LPF_A
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedF
    return

LPFComRecB
    banksel	GainLPFCom_Flags
    bsf		GainLPFCom_Flags,Received_LPF_B
    banksel	CommandFlags
    bcf		CommandFlags,ReceivedF
    return

CommandMode
    pagesel	SerNewLine
    call	SerNewLine

    pagesel	SerMessEnterComm
    call	SerMessEnterComm

    pagesel	ComRecL
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x6c		;compare with l
    btfsc	STATUS,Z
    goto	ComRecL

    movf	RXData,W
    xorlw	0x72		;compare with r
    btfsc	STATUS,Z
    goto	ComRecR

    movf	RXData,W
    xorlw	0x61		;compare with a
    btfsc	STATUS,Z
    goto	ComRecA

    movf	RXData,W
    xorlw	0x62		;compare with b
    btfsc	STATUS,Z
    goto	ComRecB


GainCommandMode
    pagesel	SerNewLine
    call	SerNewLine

    pagesel	SerMessEnterComm
    call	SerMessEnterComm

    pagesel	GainComRecL
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x6c		;compare with l
    btfsc	STATUS,Z
    goto	GainComRecL

    movf	RXData,W
    xorlw	0x72		;compare with r
    btfsc	STATUS,Z
    goto	GainComRecR

    movf	RXData,W
    xorlw	0x61		;compare with a
    btfsc	STATUS,Z
    goto	GainComRecA

    movf	RXData,W
    xorlw	0x62		;compare with b
    btfsc	STATUS,Z
    goto	GainComRecB

LPFCommandMode
    pagesel	SerNewLine
    call	SerNewLine

    pagesel	SerMessEnterComm
    call	SerMessEnterComm

    pagesel	LPFComRecL
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x6c		;compare with l
    btfsc	STATUS,Z
    goto	LPFComRecL

    movf	RXData,W
    xorlw	0x72		;compare with r
    btfsc	STATUS,Z
    goto	LPFComRecR

    movf	RXData,W
    xorlw	0x61		;compare with a
    btfsc	STATUS,Z
    goto	LPFComRecA

    movf	RXData,W
    xorlw	0x62		;compare with b
    btfsc	STATUS,Z
    goto	LPFComRecB

CommandL
    pagesel	SerMessCommPort
    call	SerMessCommPort

    pagesel	SerDisLName
    call	SerDisLName

    pagesel	CommandL0
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x30		;compare with 0
    btfsc	STATUS,Z
    goto	CommandL0

    movf	RXData,W
    xorlw	0x31		;compare with 1
    btfsc	STATUS,Z
    goto	CommandL1

    movf	RXData,W
    xorlw	0x32		;compare with 2
    btfsc	STATUS,Z
    goto	CommandL2

    movf	RXData,W
    xorlw	0x33		;compare with 3
    btfsc	STATUS,Z
    goto	CommandL3

    movf	RXData,W
    xorlw	0x34		;compare with 4
    btfsc	STATUS,Z
    goto	CommandL4

    movf	RXData,W
    xorlw	0x35		;compare with 5
    btfsc	STATUS,Z
    goto	CommandL5

    movf	RXData,W
    xorlw	0x36		;compare with 6
    btfsc	STATUS,Z
    goto	CommandL6

    movf	RXData,W
    xorlw	0x37		;compare with 7
    btfsc	STATUS,Z
    goto	CommandL7

    pagesel	SerCommEnd
    call	SerCommEnd

    return

CommandR
    pagesel	SerMessCommPort
    call	SerMessCommPort

    pagesel	SerDisRName
    call	SerDisRName

    pagesel	CommandR0
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x30		;compare with 0
    btfsc	STATUS,Z
    goto	CommandR0

    movf	RXData,W
    xorlw	0x31		;compare with 1
    btfsc	STATUS,Z
    goto	CommandR1

    movf	RXData,W
    xorlw	0x32		;compare with 2
    btfsc	STATUS,Z
    goto	CommandR2

    movf	RXData,W
    xorlw	0x33		;compare with 3
    btfsc	STATUS,Z
    goto	CommandR3

    movf	RXData,W
    xorlw	0x34		;compare with 4
    btfsc	STATUS,Z
    goto	CommandR4

    movf	RXData,W
    xorlw	0x35		;compare with 5
    btfsc	STATUS,Z
    goto	CommandR5

    movf	RXData,W
    xorlw	0x36		;compare with 6
    btfsc	STATUS,Z
    goto	CommandR6

    movf	RXData,W
    xorlw	0x37		;compare with 7
    btfsc	STATUS,Z
    goto	CommandR7

    pagesel	SerCommEnd
    call	SerCommEnd

    return

CommandA
    pagesel	SerMessCommPort
    call	SerMessCommPort

    pagesel	SerDis1Name
    call	SerDis1Name

    pagesel	CommandA0
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x30		;compare with 0
    btfsc	STATUS,Z
    goto	CommandA0

    movf	RXData,W
    xorlw	0x31		;compare with 1
    btfsc	STATUS,Z
    goto	CommandA1

    movf	RXData,W
    xorlw	0x32		;compare with 2
    btfsc	STATUS,Z
    goto	CommandA2

    movf	RXData,W
    xorlw	0x33		;compare with 3
    btfsc	STATUS,Z
    goto	CommandA3

    movf	RXData,W
    xorlw	0x34		;compare with 4
    btfsc	STATUS,Z
    goto	CommandA4

    movf	RXData,W
    xorlw	0x35		;compare with 5
    btfsc	STATUS,Z
    goto	CommandA5

    movf	RXData,W
    xorlw	0x36		;compare with 6
    btfsc	STATUS,Z
    goto	CommandA6

    movf	RXData,W
    xorlw	0x37		;compare with 7
    btfsc	STATUS,Z
    goto	CommandA7

    pagesel	SerCommEnd
    call	SerCommEnd

    return

CommandB
    pagesel	SerMessCommPort
    call	SerMessCommPort

    pagesel	SerDis2Name
    call	SerDis2Name

    pagesel	CommandB0
    banksel	RXData
    bcf		STATUS,Z

    movf	RXData,W
    xorlw	0x30		;compare with 0
    btfsc	STATUS,Z
    goto	CommandB0

    movf	RXData,W
    xorlw	0x31		;compare with 1
    btfsc	STATUS,Z
    goto	CommandB1

    movf	RXData,W
    xorlw	0x32		;compare with 2
    btfsc	STATUS,Z
    goto	CommandB2

    movf	RXData,W
    xorlw	0x33		;compare with 3
    btfsc	STATUS,Z
    goto	CommandB3

    movf	RXData,W
    xorlw	0x34		;compare with 4
    btfsc	STATUS,Z
    goto	CommandB4

    movf	RXData,W
    xorlw	0x35		;compare with 5
    btfsc	STATUS,Z
    goto	CommandB5

    movf	RXData,W
    xorlw	0x36		;compare with 6
    btfsc	STATUS,Z
    goto	CommandB6

    movf	RXData,W
    xorlw	0x37		;compare with 7
    btfsc	STATUS,Z
    goto	CommandB7

    pagesel	SerCommEnd
    call	SerCommEnd

    return

GainCommandL
    pagesel	SerMessCommGain
    call	SerMessCommGain

    pagesel	SerDisLName
    call	SerDisLName

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W

    banksel	Pot_L_Value
    movwf	Pot_L_Value
    decf	Pot_L_Value

    pagesel	Inc_Gain_L
    call	Inc_Gain_L

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	Pot_L_Value
    movf	Pot_L_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedG
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_Gain_L

    return

GainCommandR
    pagesel	SerMessCommGain
    call	SerMessCommGain

    pagesel	SerDisRName
    call	SerDisRName

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W

    banksel	Pot_R_Value
    movwf	Pot_R_Value
    decf	Pot_R_Value

    pagesel	Inc_Gain_R
    call	Inc_Gain_R

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	Pot_R_Value
    movf	Pot_R_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedG
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_Gain_R
    return

GainCommandA
    pagesel	SerMessCommGain
    call	SerMessCommGain

    pagesel	SerDis1Name
    call	SerDis1Name

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W

    banksel	Pot_A_Value
    movwf	Pot_A_Value
    decf	Pot_A_Value

    pagesel	Inc_Gain_A
    call	Inc_Gain_A

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	Pot_A_Value
    movf	Pot_A_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedG
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_Gain_A
    return

GainCommandB
    pagesel	SerMessCommGain
    call	SerMessCommGain

    pagesel	SerDis2Name
    call	SerDis2Name

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W

    banksel	Pot_B_Value
    movwf	Pot_B_Value
    decf	Pot_B_Value

    pagesel	Inc_Gain_B
    call	Inc_Gain_B

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	Pot_B_Value
    movf	Pot_B_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedG
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_Gain_B
    return

LPFCommandL
    pagesel	SerMessCommLPF
    call	SerMessCommLPF

    pagesel	SerDisLName
    call	SerDisLName

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W

    banksel	LPF_L_Value
    movwf	LPF_L_Value
    decf	LPF_L_Value

    pagesel	Inc_LPF_L
    call	Inc_LPF_L

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	LPF_L_Value
    movf	LPF_L_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedF
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_LPF_L

    return

LPFCommandR
    pagesel	SerMessCommLPF
    call	SerMessCommLPF

    pagesel	SerDisRName
    call	SerDisRName

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W
    banksel	LPF_R_Value
    movwf	LPF_R_Value
    decf	LPF_R_Value

    pagesel	Inc_LPF_R
    call	Inc_LPF_R

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	LPF_R_Value
    movf	LPF_R_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedF
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_LPF_R

    return

LPFCommandA
    pagesel	SerMessCommLPF
    call	SerMessCommLPF

    pagesel	SerDis1Name
    call	SerDis1Name

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W
    banksel	LPF_A_Value
    movwf	LPF_A_Value
    decf	LPF_A_Value

    pagesel	Inc_LPF_A
    call	Inc_LPF_A

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	LPF_A_Value
    movf	LPF_A_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedF
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_LPF_A

    return

LPFCommandB
    pagesel	SerMessCommLPF
    call	SerMessCommLPF

    pagesel	SerDis2Name
    call	SerDis2Name

    pagesel	SerOutInDiv
    call	SerOutInDiv

    banksel	RXData
    movf	RXData,W
    banksel	LPF_B_Value
    movwf	LPF_B_Value
    decf	LPF_B_Value

    pagesel	Inc_LPF_B
    call	Inc_LPF_B

    movlw	" "
    pagesel	SerialSendChar
    call	SerialSendChar

    banksel	LPF_B_Value
    movf	LPF_B_Value,W
    pagesel	SerialSendChar
    call	SerialSendChar

    pagesel	SerNewLine
    call	SerNewLine

    banksel	Flags
    bcf 	Flags,ReceivedF
    banksel	GainLPFCom_Flags
    bcf 	GainLPFCom_Flags,Received_LPF_B

    return

SerCommEnd
    banksel	CommandFlags
    clrf	CommandFlags

    pagesel	SerMessCommEnd
    call	SerMessCommEnd

    pagesel	SerNewLine
    call	SerNewLine
    return

CommandL0
    movlw	H'0'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x07
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL1
    movlw	H'1'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x00
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL2
    movlw	H'2'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x01
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL3
    movlw	H'3'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x02
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL4
    movlw	H'4'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x03
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL5
    movlw	H'5'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x04
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL6
    movlw	H'6'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x05
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

CommandL7
    movlw	H'7'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortLCount
    movlw	0x06
    movwf	PortLCount
    pagesel	Command_L
    call	Command_L
    return

Command_L
    pagesel	IncL
    call	IncL
    banksel	Flags
    bcf 	Flags,ReceivedC
    bcf 	CommandFlags,ReceivedL
    return

CommandR0
    movlw	H'0'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x07
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR1
    movlw	H'1'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x00
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR2
    movlw	H'2'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x01
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR3
    movlw	H'3'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x02
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR4
    movlw	H'4'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x03
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR5
    movlw	H'5'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x04
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR6
    movlw	H'6'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x05
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

CommandR7
    movlw	H'7'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortRCount
    movlw	0x06
    movwf	PortRCount
    pagesel	Command_R
    call	Command_R
    return

Command_R
    pagesel	IncR
    call	IncR
    banksel	Flags
    bcf 	Flags,ReceivedC
    bcf 	CommandFlags,ReceivedR
    return

CommandA0
    movlw	H'0'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x07
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA1
    movlw	H'1'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x00
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA2
    movlw	H'2'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x01
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA3
    movlw	H'3'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x02
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA4
    movlw	H'4'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x03
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA5
    movlw	H'5'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x04
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA6
    movlw	H'6'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x05
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

CommandA7
    movlw	H'7'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortACount
    movlw	0x06
    movwf	PortACount
    pagesel	Command_A
    call	Command_A
    return

Command_A
    pagesel	IncA
    call	IncA
    banksel	Flags
    bcf 	Flags,ReceivedC
    bcf 	CommandFlags,ReceivedA
    return

CommandB0
    movlw	H'0'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x07
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB1
    movlw	H'1'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x00
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB2
    movlw	H'2'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x01
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB3
    movlw	H'3'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x02
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB4
    movlw	H'4'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x03
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB5
    movlw	H'5'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x04
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB6
    movlw	H'6'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x05
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

CommandB7
    movlw	H'7'
    pagesel	SerCommDis
    call	SerCommDis

    banksel	PortBCount
    movlw	0x06
    movwf	PortBCount
    pagesel	Command_B
    call	Command_B
    return

Command_B
    pagesel	IncB
    call	IncB
    banksel	Flags
    bcf 	Flags,ReceivedC
    bcf 	CommandFlags,ReceivedB
    return

SerCommDis
    banksel	Save
    movwf	Save

    pagesel	SerMessCommIn
    call	SerMessCommIn

    banksel	Save
    movfw	Save

    pagesel	SerDisInName
    call	SerDisInName

    pagesel	SerNewLine
    call	SerNewLine
    return

;error because OERR overrun error bit is set
;can do special error handling here - this code simply clears and continues
ErrSerialOverr
    ;banksel	RCSTA
    bcf		RCSTA,CREN	;reset the receiver logic
    bsf		RCSTA,CREN	;enable reception again
    return

;error because FERR framing error bit is set
;can do special error handling here - this code simply clears and continues
ErrSerialFrame
    banksel	RCREG
    movf	RCREG,W		;discard received data that has error
    return

SerialS
    pagesel	SerNewLine
    call	SerNewLine

				;Display Line1
    call	SerDisLName

    call	SerOutInDiv

    banksel	PortLCount
    movf	PortLCount,W
    call	SerDisInName	; Display Input Name

    call	SerDisPortDiv

    call	SerDisRName

    call	SerOutInDiv

    banksel	PortRCount
    movf	PortRCount,W
    call	SerDisInName	; Display Input Name

    call	SerNewLine

				;Display Line2
    call	SerDis1Name

    call	SerOutInDiv

    banksel	PortACount
    movf	PortACount,W
    call	SerDisInName	; Display Input Name

    call	SerDisPortDiv

    call	SerDis2Name

    call	SerOutInDiv

    banksel	PortBCount
    movf	PortBCount,W
    call	SerDisInName	; Display Input Name

    call	SerNewLine

    call 	SerNewLine

    return

SerialStatusDisplay
    pagesel	SerNewLine
    call	SerNewLine

    movlw	"S"
    call	SerialSendChar
    call	SerComma

    movlw	H'00'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	PortLCount
    movf	PortLCount,W
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'01'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	PortRCount
    movf	PortRCount,W
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'02'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	PortACount
    movf	PortACount,W
    call	SerDisInName	; Display Input Name

    call 	SerComma

    movlw	H'03'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	PortBCount
    movf	PortBCount,W
    call	SerDisInName	; Display Input Name

    call 	SerComma

    call	SerNewLine

    return

SerialPortDisplay
    pagesel	SerNewLine
    call	SerNewLine

    movlw	"O"
    call	SerialSendChar
    call	SerComma

    movlw	H'00'
    call 	SerDisInNum

    call	SerOutInDiv

    call	SerDisLName

    call 	SerComma

    movlw	H'01'
    call 	SerDisInNum

    call	SerOutInDiv

    call	SerDisRName

    call 	SerComma

    movlw	H'02'
    call 	SerDisInNum

    call	SerOutInDiv

    call	SerDis1Name

    call 	SerComma

    movlw	H'03'
    call 	SerDisInNum

    call	SerOutInDiv

    call	SerDis2Name

    call 	SerComma

    call	SerNewLine

    return

SerialInDisplay
    pagesel	SerNewLine
    call	SerNewLine

    movlw	"I"
    call	SerialSendChar
    call	SerComma

    movlw	H'00'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'00'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'01'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'01'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'02'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'02'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'03'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'03'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'04'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'04'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'05'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'05'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'06'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'06'
    call	SerDisInName	; Display Input Name

    call	SerComma

    movlw	H'07'
    call 	SerDisInNum

    call	SerOutInDiv

    movlw	H'07'
    call	SerDisInName	; Display Input Name

    call	SerComma

    call	SerNewLine

    return

IncL
    banksel	PortLCount
    incf	PortLCount,F	; Button was down and now it's up,
				; we need to increment the counter
    bcf		STATUS,Z
    movf	PortLCount,W	; Move L Port Count to W
    xorlw	INPORTNUM	; Is the Port Count equal the
    btfsc	STATUS,Z	;  to the max port number
    clrf	PortLCount	;  if Yes clear port count

    pagesel	L_Mux
    call	L_Mux		; Change MUX port

    pagesel	EEPROM_L_Write
    call	EEPROM_L_Write	; Write port count to EEPROM

    return

IncR
    banksel	PortRCount
    incf	PortRCount,F	; Button was down and now it's up,
				; we need to increment the counter
    bcf		STATUS,Z
    movf	PortRCount,W	; Move L Port Count to W
    xorlw	INPORTNUM	; Is the Port Count equal the
    btfsc	STATUS,Z	;  to the max port number
    clrf	PortRCount	;  if Yes clear port count

    pagesel	R_Mux
    call	R_Mux		; Change MUX port

    pagesel	EEPROM_R_Write
    call	EEPROM_R_Write	; Write port count to EEPROM

    return

IncA
    banksel	PortACount
    incf	PortACount,F	; Button was down and now it's up,
				; we need to increment the counter
    bcf		STATUS,Z
    movf	PortACount,W	; Move L Port Count to W
    xorlw	INPORTNUM	; Is the Port Count equal the
    btfsc	STATUS,Z	;  to the max port number
    clrf	PortACount	;  if Yes clear port count

    pagesel	A_Mux
    call	A_Mux		; Change MUX port

    pagesel	EEPROM_A_Write
    call	EEPROM_A_Write	; Write port count to EEPROM

    return

IncB
    banksel	PortBCount
    incf	PortBCount,F	; Button was down and now it's up,
				; we need to increment the counter
    bcf		STATUS,Z
    movf	PortBCount,W	; Move L Port Count to W
    xorlw	INPORTNUM	; Is the Port Count equal the
    btfsc	STATUS,Z	;  to the max port number
    clrf	PortBCount	;  if Yes clear port count

    pagesel	B_Mux
    call	B_Mux		; Change MUX port

    pagesel	EEPROM_B_Write
    call	EEPROM_B_Write	; Write port count to EEPROM

    return

L_Mux
    movlw	I2CMultBus0
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'00'
    pagesel	i2c_FirstSwitch
    call	i2c_FirstSwitch

    movlw	I2CMultBus1
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'00'
    pagesel	i2c_SecondSwitch
    call	i2c_SecondSwitch

    return

R_Mux
    movlw	I2CMultBus0
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'01'
    pagesel	i2c_FirstSwitch
    call	i2c_FirstSwitch

    movlw	I2CMultBus2
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'01'
    pagesel	i2c_SecondSwitch
    call	i2c_SecondSwitch

    return

A_Mux
    movlw	I2CMultBus3
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'02'
    pagesel	i2c_FirstSwitch
    call	i2c_FirstSwitch

    movlw	I2CMultBus4
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'02'
    pagesel	i2c_SecondSwitch
    call	i2c_SecondSwitch

    return

B_Mux
    movlw	I2CMultBus3
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'03'
    pagesel	i2c_FirstSwitch
    call	i2c_FirstSwitch

    movlw	I2CMultBus5
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    movlw	H'03'
    pagesel	i2c_SecondSwitch
    call	i2c_SecondSwitch

    return

i2c_SendMultBusCommand
    banksel	Save
    movwf	Save		; Save i2c command

    pagesel	i2c_Start
    call 	i2c_Start

    pagesel	i2c_SendMultAddr
    call	i2c_SendMultAddr

    banksel	Save
    movfw	Save
    nop
    pagesel	i2c_SendMultBus
    call	i2c_SendMultBus

    pagesel	i2c_Stop
    call	i2c_Stop

    return

i2c_SendMultBus
    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    return

i2c_FirstSwitch
    banksel	Test
    movwf	Test		; Save output number

    pagesel	i2c_Start
    call	i2c_Start

    banksel	Test
    movf	Test
    pagesel	Get_FirstSwitchAddr
    call	Get_FirstSwitchAddr ; I2C address returned in W
    pagesel	i2c_FirstSwitch

    banksel	SSPBUF		; Send I2C address
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel	SSPCON2		; select SFR bank
    btfss	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    banksel	Test
    movfw	Test

    bcf		STATUS,Z		    ; Get the Filter Number
    pagesel	Get_1_First
    movf	Test,W
    xorlw	H'00'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_1_First
    pagesel	Get_2_First
    movf	Test,W
    xorlw	H'01'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_2_First
    pagesel	Get_3_First
    movf	Test,W
    xorlw	H'02'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_3_First
    pagesel	Get_4_First
    movf	Test,W
    xorlw	H'03'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_4_First

    return

Get_1_First
    banksel	PortLCount
    movfw	PortLCount
    goto	i2c_First_Switch_Data
Get_2_First
    banksel	PortRCount
    movfw	PortRCount
    goto	i2c_First_Switch_Data
Get_3_First
    banksel	PortACount
    movfw	PortACount
    goto	i2c_First_Switch_Data
Get_4_First
    banksel	PortBCount
    movfw	PortBCount
    goto	i2c_First_Switch_Data

i2c_First_Switch_Data
    pagesel	Get_FirstSwitchCmd
    call	Get_FirstSwitchCmd
    pagesel	i2c_First_Switch_Data

    banksel	SSPBUF		; Send I2C address
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel	SSPCON2		; select SFR bank
    btfss	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    pagesel	i2c_Stop
    call	i2c_Stop

    return

Get_FirstSwitchAddr
    brw
    dt	I2CTopSwitchAddr,I2CBottomSwitchAddr,I2CTopSwitchAddr,I2CBottomSwitchAddr

Get_FirstSwitchCmd
    brw
    dt	Switch_Top,Switch_Top,Switch_Top,Switch_Top
    dt	Switch_Bottom,Switch_Bottom,Switch_Bottom,Switch_Bottom

i2c_SecondSwitch
    banksel	Test
    movwf	Test		; Save output number

    bcf		STATUS,Z		    ; Get the Filter Number
    pagesel	Get_1_Second
    movf	Test,W
    xorlw	H'00'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_1_Second
    pagesel	Get_2_Second
    movf	Test,W
    xorlw	H'01'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_2_Second
    pagesel	Get_3_Second
    movf	Test,W
    xorlw	H'02'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_3_Second
    pagesel	Get_4_Second
    movf	Test,W
    xorlw	H'03'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_4_Second

    return

Get_1_Second
    banksel	PortLCount
    movfw	PortLCount
    movwf	Test
    goto	i2c_Second_Switch_Addr
Get_2_Second
    banksel	PortRCount
    movfw	PortRCount
    movwf	Test
    goto	i2c_Second_Switch_Addr
Get_3_Second
    banksel	PortACount
    movfw	PortACount
    movwf	Test
    goto	i2c_Second_Switch_Addr
Get_4_Second
    banksel	PortBCount
    movfw	PortBCount
    movwf	Test
    goto	i2c_Second_Switch_Addr

i2c_Second_Switch_Addr
    pagesel	i2c_Start
    call	i2c_Start

    banksel	Test
    movf	Test

    pagesel	Get_SecondSwitchAddr
    call	Get_SecondSwitchAddr ; I2C address returned in W
    pagesel	i2c_Second_Switch_Addr

    banksel	SSPBUF		; Send I2C address
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel	SSPCON2		; select SFR bank
    btfss	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    banksel	Test
    movfw	Test

    pagesel	Get_SecondSwitchCmd
    call	Get_SecondSwitchCmd
    pagesel	i2c_Second_Switch_Addr

    banksel	SSPBUF		; Send I2C address
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel	SSPCON2		; select SFR bank
    btfss	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    pagesel	i2c_Stop
    call	i2c_Stop

    return

Get_SecondSwitchAddr
    brw
    dt	I2CTopSwitchAddr,I2CTopSwitchAddr,I2CTopSwitchAddr,I2CTopSwitchAddr
    dt	I2CBottomSwitchAddr,I2CBottomSwitchAddr,I2CBottomSwitchAddr,I2CBottomSwitchAddr

Get_SecondSwitchCmd
    brw
    dt	Switch_1,Switch_2,Switch_3,Switch_4
    dt	Switch_1,Switch_2,Switch_3,Switch_4

I2CMultiResetHigh
    banksel	PORTA
    bsf		PORTA,4		; U8 Reset High
    return

I2CSetup
    banksel	SSPCON1
    movlw	B'00101000'
    movwf	SSPCON1		; Master mode, SSP enable

    banksel	SSPSTAT
    movlw	B'10000000'	; slew rate off
    movwf	SSPSTAT


    banksel	SSPADD
    movlw	ClockValue	; read selected baud rate
    movlw	H'FF'		;  !!!!! two movlw
    movwf	SSPADD		; initialize I2C baud rate

    banksel	TRISC
    bsf		TRISC,3 	; Set RC3/SCL to input
    bsf		TRISC,4		; Set RC4/SDA to input

    return

i2c_Start
    banksel 	SSPCON2         ; select SFR bank
    bsf     	SSPCON2,SEN     ; initiate I2C bus start condition

    btfsc	SSPCON2,SEN	; Test start bit state
    goto	$-1		; module is busy.
    banksel	PIR1
    bcf 	PIR1,SSPIF

    return

i2c_Stop
    banksel	SSPCON2		; select SFR bank
    bsf		SSPCON2,PEN	; initiate I2C bus stop condition
    btfsc	SSPCON2,PEN
    goto	$-1

    return

i2c_SendMultAddr
    banksel	SSPBUF
    movlw	I2CMultAddr	; Slave Address
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel	SSPCON2		; select SFR bank
    btfss	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    return

;Read From EEPROM
EEREAD
    banksel	EEADRL
    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,RD	; EEPROM Read
    movf	EEDATL,W	; Move EEPROM Data to W
    incf	EEADRL		; Increment to the next EEPROM location
    return

;Init Display LCD Line 1
LCDLine1
    movlw	H'00'		; Move cursor the 1th line.
    pagesel	LCDaddr
    call 	LCDaddr

    pagesel	DisLName
    call	DisLName	; Display L port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	PortLCount
    movf	PortLCount,W
    pagesel	DisInName
    call	DisInName	; Display Input Name

    pagesel	DisPortDiv
    call	DisPortDiv	; Display Port Divider

    pagesel	DisRName
    call	DisRName	; Display R port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	PortRCount
    movf	PortRCount,W	; Move Port Indix to W
    pagesel	DisInName
    call	DisInName	; Display Input Name

    return

;Int Display LCD Line 2
LCDLine2
    movlw	H'40'		; Move cursor the 2nd line.
    pagesel	LCDaddr
    call 	LCDaddr

    pagesel	Dis1Name
    call	Dis1Name	; Display L port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	PortACount
    movf	PortACount,W	; Move Port Indix to W
    pagesel	DisInName
    call	DisInName	; Display Input Name

    pagesel	DisPortDiv
    call	DisPortDiv	; Display Port Divider

    pagesel	Dis2Name
    call	Dis2Name	; Display R port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	PortBCount
    movf	PortBCount,W	; Move Port Indix to W
    pagesel	DisInName
    call	DisInName	; Display Input Name

    return

PB_L_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

				; Check button state
    btfss	PB_State,PB_L	; Was button down?
    goto	PB_L_wasDown	; Yes

PB_L_wasUp
    btfsc	Buttons,PB_L	; Is button still up?
    return			; Was up and still up, do nothing
    bcf		PB_State,PB_L	; Was up, remember now down
    return

PB_L_wasDown
    btfss	Buttons,PB_L	; If it is still down
    return			; Was down and still down, do nothing
    bsf		PB_State,PB_L	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    pagesel	IncL
    call	IncL

    return

PB_R_Poll
    banksel	PORTA
    movf	PORTA,W 	; Get Inputs
    banksel	Buttons
    movwf	Buttons

				; Check button state
    btfss	PB_State,PB_R	; Was button down?
    goto	PB_R_wasDown	; Yes

PB_R_wasUp
    btfsc	Buttons,PB_R	; Is button still up?
    return			; Was up and still up, do nothing
    bcf		PB_State,PB_R	; Was up, remember now down
    return

PB_R_wasDown
    btfss	Buttons,PB_R	; If it is still down
    return			; Was down and still down, do nothing
    bsf		PB_State,PB_R	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    pagesel	IncR
    call	IncR
    return

PB_A_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

				; Check button state
    btfss	PB_State,PB_A	; Was button down?
    goto	PB_A_wasDown	; Yes

PB_A_wasUp
    btfsc	Buttons,PB_A	; Is button still up?
    return			; Was up and still up, do nothing
    bcf		PB_State,PB_A	; Was up, remember now down
    return

PB_A_wasDown
    btfss	Buttons,PB_A	; If it is still down
    return			; Was down and still down, do nothing
    bsf		PB_State,PB_A	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    pagesel	IncA
    call	IncA
    return

PB_B_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

				; Check button state
    btfss	PB_State,PB_B	; Was button down?
    goto	PB_B_wasDown	; Yes

PB_B_wasUp
    btfsc	Buttons,PB_B	; Is button still up?
    return			; Was up and still up, do nothing
    bcf		PB_State,PB_B	; Was up, remember now down
    return

PB_B_wasDown
    btfss	Buttons,PB_B	; If it is still down
    return			; Was down and still down, do nothing
    bsf		PB_State,PB_B	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    pagesel	IncB
    call	IncB

    return

.Audio_switch1			code
EEPROM_L_Write
    banksel	PortLCount
    movf	PortLCount,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_L		; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_R_Write
    banksel	PortRCount
    movf	PortRCount,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_R		; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_A_Write
    banksel	PortACount
    movf	PortACount,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_A		; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_B_Write
    banksel	PortBCount
    movf	PortBCount,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_B		; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

;.Audio_switch1			code

;init CCP1_________________________________________________________
init_pwm
    banksel	PR2		; Timer Period
    movlw	B'11111110'	; 10 bit 245.10 hrez
    movwf	PR2

    banksel	T2CON
    movlw	B'00000111'
    movwf	T2CON

    banksel	CCPR1L
    movlw	H'80'
    movwf	CCPR1L

    banksel	CCP1CON
    movlw	B'00111100'
    movwf	CCP1CON

    banksel	TRISC
    bcf		TRISC,RC2	; Make C2 output, CCP1

    return

;Init Timer0______________________________________
init_timer0
    banksel	CPSCON0
    bcf		CPSCON0,T0XCS

    banksel	OPTION_REG

    bcf		OPTION_REG,TMR0CS   ; Fosc/4 - Internal clock
    bcf		OPTION_REG,PSA	 ; Use Prescaler for Timer0
    bsf		OPTION_REG,PS0	 ; 1:256 Prescaler
    bsf		OPTION_REG,PS1
    bsf		OPTION_REG,PS2

    banksel	CCPR1L
    movlw	H'FF'
    movwf	CCPR1L

    banksel	TMR0
    clrf	TMR0

    banksel	Flags
    clrf	Flags
    clrf	TimerCount
    clrf	NumThSec
    clrf	NumSec
    clrf	NumMin

    return

BackLightSubs
    pagesel	time_loop
    call	time_loop	; Mantain time counters

    banksel	BlFlags
    btfsc	BlFlags,LedBlTo ; Dim LCD Backlight when flag is set
    pagesel	LedBlDim
    call	LedBlDim
    return

    ;time stuff ______________________________________________________________
time_loop
    banksel	INTCON
    btfss	INTCON,TMR0IF	; Did the timer overflow?
    goto	$+2
    bcf		INTCON,TMR0IF	; Reset overflow flag

    banksel	TimerCount
    incf	TimerCount	; Yes, inc counter.

    banksel	TimerCount
    bcf		STATUS,Z
    movf	TimerCount,W
    xorlw	H'FF'		; Around 1 tenth sec. not exact (fudge)
    btfss	STATUS,Z
    goto	$+3
    incf	NumThSec
    clrf	TimerCount

    bcf		STATUS,Z
    movf	NumThSec,W
    ;xorlw	H'57'		; Around 1 sec. not exact (fudge)
    xorlw	H'01'
    btfss	STATUS,Z
    goto	$+3
    incf	NumSec
    clrf	NumThSec

    bcf		STATUS,Z
    movf	NumSec,W
    ;xorlw	H'60'		; d96
    xorlw	H'3C'		; d60
    btfss	STATUS,Z
    goto	$+3
    incf	NumMin
    clrf	NumSec

    banksel	NumMin
    bcf		STATUS,Z
    movf	NumMin,W
    xorlw	LedBLTimeOut
    btfsc	STATUS,Z
    banksel	BlFlags
    bsf		BlFlags,LedBlTo

    return
;_________________________________________________________________
LedBlDim
    bcf		STATUS,Z

    banksel	NumMin
    movf	NumMin,W
    xorlw	LedBLTimeOut + 1
    btfss	STATUS,Z
    goto	$+5
    movlw	Led75
    banksel	CCPR1L
    movwf	CCPR1L
    goto	EndLedB1Dim

    banksel	NumMin
    movf	NumMin,W
    xorlw	LedBLTimeOut + 2
    btfss	STATUS,Z
    goto	$+5
    movlw	Led50
    banksel	CCPR1L
    movwf	CCPR1L
    goto	EndLedB1Dim

    banksel	NumMin
    movf	NumMin,W
    xorlw	LedBLTimeOut + 3
    btfss	STATUS,Z
    goto	$+5
    movlw	Led25
    banksel	CCPR1L
    movwf	CCPR1L
    goto	EndLedB1Dim

    banksel	NumMin
    movf	NumMin,W
    xorlw	LedBLTimeOut + 4
    btfss	STATUS,Z
    goto	$+5
    movlw	Led10
    banksel	CCPR1L
    movwf	CCPR1L
    goto	EndLedB1Dim

EndLedB1Dim
    return


FullBackLight
    banksel	BlFlags		;!!Assuming FS BlFlags and NumMin in same bank!
    bcf		BlFlags,LedBlTo	; clear timeout flag
    clrf	NumMin		; clear timeout counter

    banksel	CCPR1L		; enabled full backlight
    ;movlw	B'11111111'	; 100%
    movlw	H'DF'
    movwf	CCPR1L

    return

Update_Pcf8574
    banksel	Address			; Save I2C address.
    movwf	Address

    movlw	I2CMultNoBus
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    pagesel	i2c_Send8574_Addr
    call	i2c_Send8574_Addr

    pagesel	i2c_Pcf8574_Write_Data
    call	i2c_Pcf8574_Write_Data

    return

i2c_Send8574_Addr
    pagesel	i2c_Start
    call	i2c_Start

    banksel	Address
    movf	Address,W

    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto 	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    return

i2c_Pcf8574_Write_Data
    ; Behaves like a shift register.
    ; The first write places data into an internal holding register,
    ; and subsequent writes force the holding register to the output pins.
    banksel	Pcf8574_Data
    movf	Pcf8574_Data,W

    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto 	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    ; 2nd write
    banksel	Pcf8574_Data
    movf	Pcf8574_Data,W

    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto 	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    pagesel	i2c_Stop
    call	i2c_Stop

    return

;HERE!!
Update_Pot
    banksel	Test
    movwf	Test		; Save output number

    movlw	I2CMultNoBus
    pagesel	i2c_SendMultBusCommand
    call	i2c_SendMultBusCommand

    pagesel	i2c_Start
    call	i2c_Start

    banksel	Test
    movfw	Test

    pagesel	Get_Pot_Address
    call	Get_Pot_Address

    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto 	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    banksel	Test
    movfw	Test

    pagesel	Get_Pot_Command
    call	Get_Pot_Command

    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto 	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    banksel	Test
    movfw	Test

    bcf		STATUS,Z		    ; Get the Filter Number
    pagesel	Get_Gain_1
    movf	Test,W
    xorlw	H'00'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_Gain_1
    pagesel	Get_Gain_2
    movf	Test,W
    xorlw	H'01'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_Gain_2
    pagesel	Get_Gain_3
    movf	Test,W
    xorlw	H'02'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_Gain_3
    pagesel	Get_Gain_4
    movf	Test,W
    xorlw	H'03'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_Gain_4

    return

Get_Gain_1
    banksel	Pot_L_Value
    movfw	Pot_L_Value
    goto	i2c_Gain_Data
Get_Gain_2
    banksel	Pot_R_Value
    movfw	Pot_R_Value
    goto	i2c_Gain_Data
Get_Gain_3
    banksel	Pot_A_Value
    movfw	Pot_A_Value
    goto	i2c_Gain_Data
Get_Gain_4
    banksel	Pot_B_Value
    movfw	Pot_B_Value
    goto	i2c_Gain_Data

i2c_Gain_Data
    banksel	SSPBUF
    movwf	SSPBUF		; write is i2c buss
    btfsc	SSPSTAT,R_NOT_W	; Wait r_w clear at 9th (ACk) clock
    goto	$-1

    banksel 	SSPCON2         ; select SFR bank
    btfss   	SSPCON2,ACKSTAT	; wait for the ACK from Slave
    goto 	$+1

    banksel	SSPCON2		; idle check
    movf	SSPCON2,w	; get copy
    andlw	0x1F		; Maks out non-status
    btfss	STATUS,Z	; test for zero state
    goto	$-3

    pagesel	i2c_Stop
    call	i2c_Stop

    return

Get_Pot_Address
    brw
    dt	Ds103_W1_Addr,Ds103_W1_Addr,Ds103_W2_Addr,Ds103_W1_Addr

Get_Pot_Command
    brw
    dt	Ds103_Pot0_cmd,Ds103_Pot1_cmd,Ds103_Pot0_cmd,Ds103_Pot1_cmd

PB_GAIN_Poll
    banksel	PORTC
    movf	PORTC,W		 ; Get inputs
    banksel	Buttons
    movwf	Buttons

    ;pagesel	PB_GAIN_wasDown
    banksel	PB_State	 ; Check button state
    btfss	PB_State,PB_GAIN ; Was button down?
    goto	PB_GAIN_wasDown	 ; Yes

PB_GAIN_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_GAIN_BIT ; Is button still up?
    return			 ; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_GAIN ; Was up, remember now down
    return

PB_GAIN_wasDown
    banksel	Buttons
    btfss	Buttons,PB_GAIN_BIT ; If it is still down
    return			 ; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_GAIN ; remember released

    pagesel	FullBackLight
    call	FullBackLight	 ; Restore LCD Backlight

    banksel	Gain_LPF_Flags

    btfss	Gain_LPF_Flags,GainLoop	; Skip if ON; go if off
    goto	$+3

    btfsc	Gain_LPF_Flags,GainLoop	; Skip if OFF; go if on
    goto	$+3

    bsf		Gain_LPF_Flags,GainLoop
    return

    bcf		Gain_LPF_Flags,GainLoop
    return

LCDLine1_Gain
    pagesel	LCDaddr
    movlw	H'00'		; Move cursor the 1th line.
    call 	LCDaddr

    pagesel	DisLName
    call	DisLName	; Display L port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	Pot_L_Value
    movf	Pot_L_Value,W
    pagesel	DisGain
    call	DisGain		; Display Gain Value

    pagesel	DisPortDiv1_Gain_LPF ; Display Port Divider
    call	DisPortDiv1_Gain_LPF

    pagesel	DisRName
    call	DisRName	; Display R port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	Pot_R_Value
    movf	Pot_R_Value,W
    pagesel	DisGain
    call	DisGain		; Display Gain Value

    return

LCDLine2_Gain
    pagesel	LCDaddr
    movlw	H'40'		; Move cursor the 1th line.
    call 	LCDaddr

    pagesel	Dis1Name
    call	Dis1Name	; Display L port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	Pot_A_Value
    movf	Pot_A_Value,W
    pagesel	DisGain
    call	DisGain		; Display Gain Value

    pagesel	DisPortDiv2_Gain_LPF ; Display Port Divider
    call	DisPortDiv2_Gain_LPF

    pagesel	Dis2Name
    call	Dis2Name	; Display R port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	Pot_B_Value
    movf	Pot_B_Value,W
    pagesel	DisGain
    call	DisGain		; Display Gain Value

    return

PB_LPF_Poll
    banksel	PORTC
    movf	PORTC,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	; Check button state
    btfss	PB_State,PB_LPF	; Was button down?
    goto	PB_LPF_wasDown	; Yes

PB_LPF_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_LPF_BIT  ; Is button still up?
    return			; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_LPF	; Was up, remember now down
    return

PB_LPF_wasDown
    banksel	Buttons
    btfss	Buttons,PB_LPF_BIT  ; If it is still down
    return			; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_LPF	; remember released


    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Gain_LPF_Flags

    btfss	Gain_LPF_Flags,LPFLoop	; Skip if ON; go if off
    goto	$+3

    btfsc	Gain_LPF_Flags,LPFLoop	; Skip if OFF; go if on
    goto	$+3

    bsf		Gain_LPF_Flags,LPFLoop
    return

    bcf		Gain_LPF_Flags,LPFLoop
    return

    return

LCDLine1_LPF
    pagesel	LCDaddr
    movlw	H'00'		; Move cursor the 1th line.
    call 	LCDaddr

    pagesel	DisLName
    call	DisLName	; Display L port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	LPF_L_Value
    movf	LPF_L_Value,W
    pagesel	DisLPF
    call	DisLPF		; Display Gain Value

    pagesel	DisPortDiv1_Gain_LPF ; Display Port Divider
    call	DisPortDiv1_Gain_LPF

    pagesel	DisRName
    call	DisRName	; Display R port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	LPF_R_Value
    movf	LPF_R_Value,W
    pagesel	DisLPF
    call	DisLPF		; Display Gain Value

    return

LCDLine2_LPF
    pagesel	LCDaddr
    movlw	H'40'		; Move cursor the 1th line.
    call 	LCDaddr

    pagesel	Dis1Name
    call	Dis1Name	; Display L port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	LPF_A_Value
    movf	LPF_A_Value,W
    pagesel	DisLPF
    call	DisLPF		; Display Gain Value

    pagesel	DisPortDiv2_Gain_LPF ; Display Port Divider
    call	DisPortDiv2_Gain_LPF

    pagesel	Dis2Name
    call	Dis2Name	; Display R port Name

    pagesel	DisOutInDiv
    call	DisOutInDiv	; Disp Out In Divider

    banksel	LPF_B_Value
    movf	LPF_B_Value,W
    pagesel	DisLPF
    call	DisLPF		; Display Gain Value

    return


Gain_LPF_PB_L_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	; Check button state
    btfss	PB_State,PB_L	; Was button down?
    goto	Gain_LPF_PB_L_wasDown	; Yes

Gain_LPF_PB_L_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_L	; Is button still up?
    return			; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_L	; Was up, remember now down
    return

Gain_LPF_PB_L_wasDown
    banksel	Buttons
    btfss	Buttons,PB_L	; If it is still down
    return			; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_L	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Gain_LPF_Flags

    btfss	Gain_LPF_Flags,PB_L ; Skip if ON, go if off
    goto	$+3

    btfsc	Gain_LPF_Flags,PB_L ; Skip if OFF, go if on
    goto	$+3

    bsf		Gain_LPF_Flags,PB_L
    return

    bcf		Gain_LPF_Flags,PB_L
    return

Gain_LPF_PB_R_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	; Check button state
    btfss	PB_State,PB_R	; Was button down?
    goto	Gain_LPF_PB_R_wasDown	; Yes

Gain_LPF_PB_R_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_R	; Is button still up?
    return			; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_R	; Was up, remember now down
    return

Gain_LPF_PB_R_wasDown
    banksel	Buttons
    btfss	Buttons,PB_R	; If it is still down
    return			; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_R	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Gain_LPF_Flags

    btfss	Gain_LPF_Flags,PB_R ; Skip if ON, go if off
    goto	$+3

    btfsc	Gain_LPF_Flags,PB_R ; Skip if OFF, go if on
    goto	$+3

    bsf		Gain_LPF_Flags,PB_R
    return

    bcf		Gain_LPF_Flags,PB_R
    return

Gain_LPF_PB_A_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	; Check button state
    btfss	PB_State,PB_A	; Was button down?
    goto	Gain_LPF_PB_A_wasDown	; Yes

Gain_LPF_PB_A_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_A	; Is button still up?
    return			; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_A	; Was up, remember now down
    return

Gain_LPF_PB_A_wasDown
    banksel	Buttons
    btfss	Buttons,PB_A	; If it is still down
    return			; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_A	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Gain_LPF_Flags

    btfss	Gain_LPF_Flags,PB_A ; Skip if ON, go if off
    goto	$+3

    btfsc	Gain_LPF_Flags,PB_A ; Skip if OFF, go if on
    goto	$+3

    bsf		Gain_LPF_Flags,PB_A
    return

    bcf		Gain_LPF_Flags,PB_A
    return

Gain_LPF_PB_B_Poll
    banksel	PORTA
    movf	PORTA,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	; Check button state
    btfss	PB_State,PB_B	; Was button down?
    goto	Gain_LPF_PB_B_wasDown	; Yes

Gain_LPF_PB_B_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_B	; Is button still up?
    return			; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_B	; Was up, remember now down
    return

Gain_LPF_PB_B_wasDown
    banksel	Buttons
    btfss	Buttons,PB_B	; If it is still down
    return			; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_B	; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Gain_LPF_Flags

    btfss	Gain_LPF_Flags,PB_B ; Skip if ON, go if off
    goto	$+3

    btfsc	Gain_LPF_Flags,PB_B ; Skip if OFF, go if on
    goto	$+3

    bsf		Gain_LPF_Flags,PB_B
    return

    bcf		Gain_LPF_Flags,PB_B
    return

Gain_Adjust_Loop
    pagesel	BackLightSubs
    call	BackLightSubs

    pagesel	LCDLine1_Gain
    call	LCDLine1_Gain	; Display 1st Gain line on LCD
    pagesel	LCDLine2_Gain
    call	LCDLine2_Gain	; Display 2nd Gain line on LCD

    pagesel	Gain_LPF_Poll_LRAB_PB
    call	Gain_LPF_Poll_LRAB_PB

    pagesel	PB_UP_Poll
    call	PB_UP_Poll

    pagesel	PB_DOWN_Poll
    call	PB_DOWN_Poll

    pagesel	ReceiveSerial
    call	ReceiveSerial	; Get received data if possible

    banksel	Gain_LPF_Flags
    movfw	Gain_LPF_Flags
    andlw	H'0F'		; Zero out the non-button bits
    bcf		STATUS,Z	; Reset Status reg
    xorlw	H'0'
    btfsc	STATUS,Z	; Was it Zero?
    return			; Return when all the button bits off

    pagesel	Gain_Adjust_Loop
    goto	Gain_Adjust_Loop

LPF_Adjust_Loop
    pagesel	BackLightSubs
    call	BackLightSubs

    pagesel	LCDLine1_LPF
    call	LCDLine1_LPF	; Display 1st Gain line on LCD
    pagesel	LCDLine2_LPF
    call	LCDLine2_LPF	; Display 2nd Gain line on LCD

    pagesel	Gain_LPF_Poll_LRAB_PB
    call	Gain_LPF_Poll_LRAB_PB

    pagesel	PB_UP_Poll
    call	PB_UP_Poll

    pagesel	PB_DOWN_Poll
    call	PB_DOWN_Poll

    pagesel	ReceiveSerial
    call	ReceiveSerial	; Get received data if possible

    banksel	Gain_LPF_Flags
    movfw	Gain_LPF_Flags
    andlw	H'0F'		; Zero out the non-button bits
    bcf		STATUS,Z	; Reset Status reg
    xorlw	H'0'
    btfsc	STATUS,Z	; Was it Zero?
    return			; Return when all the button bits off

    pagesel	LPF_Adjust_Loop
    goto	LPF_Adjust_Loop

Gain_LPF_Poll_LRAB_PB
    pagesel	Gain_LPF_PB_L_Poll
    call	Gain_LPF_PB_L_Poll

    pagesel	Gain_LPF_PB_R_Poll
    call	Gain_LPF_PB_R_Poll

    pagesel	Gain_LPF_PB_A_Poll
    call	Gain_LPF_PB_A_Poll

    pagesel	Gain_LPF_PB_B_Poll
    call	Gain_LPF_PB_B_Poll
    return

DisPortDiv1_Gain_LPF
    banksel	Gain_LPF_Flags	    ; Skip if PB_L was pressed
    btfss	Gain_LPF_Flags,PB_L ; If not pressed, Display normal divider.
    movlw	"|"		    ; Set W to Port Div

				    ; Skip if PB_L was not pressed
    btfsc	Gain_LPF_Flags,PB_L ; If pressed, Display that L is selected.
    movlw	"*"		    ; Set W to Port Div

    pagesel		LCDletr
    call		LCDletr	; Send Char to LCD

    banksel	Gain_LPF_Flags	    ; Skip if PB_R was pressed
    btfss	Gain_LPF_Flags,PB_R ; If not pressed, Display normal divider.
    movlw	"|"		    ; Set W to Port Div

				    ; Skip if PB_R was not pressed
    btfsc	Gain_LPF_Flags,PB_R ; If pressed, Display that L is selected.
    movlw	"*"		    ; Set W to Port Div

    pagesel		LCDletr
    call		LCDletr	; Send Char to LCD
    return

DisPortDiv2_Gain_LPF
    banksel	Gain_LPF_Flags	    ; Skip if PB_L was pressed
    btfss	Gain_LPF_Flags,PB_A ; If not pressed, Display normal divider.
    movlw	"|"		    ; Set W to Port Div

				    ; Skip if PB_L was not pressed
    btfsc	Gain_LPF_Flags,PB_A ; If pressed, Display that L is selected.
    movlw	"*"		    ; Set W to Port Div

    pagesel		LCDletr
    call		LCDletr	; Send Char to LCD

    banksel	Gain_LPF_Flags	    ; Skip if PB_R was pressed
    btfss	Gain_LPF_Flags,PB_B ; If not pressed, Display normal divider.
    movlw	"|"		    ; Set W to Port Div

				    ; Skip if PB_R was not pressed
    btfsc	Gain_LPF_Flags,PB_B ; If pressed, Display that L is selected.
    movlw	"*"		    ; Set W to Port Div

    pagesel		LCDletr
    call		LCDletr	; Send Char to LCD
    return

PB_UP_Poll
    banksel	PORTC
    movf	PORTC,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	; Check button state
    btfss	PB_State,PB_UP  ; Was button down?
    goto	PB_UP_wasDown	; Yes

PB_UP_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_UP_BIT ; Is button still up?
    return			; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_UP  ; Was up, remember now down
    return

PB_UP_wasDown
    banksel	Buttons
    btfss	Buttons,PB_UP_BIT ; If it is still down
    return			; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_UP  ; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    pagesel	Inc_Gain
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,GainLoop
    call	Inc_Gain

    pagesel	Inc_LPF
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,LPFLoop
    call	Inc_LPF

    return

Inc_Gain
    pagesel	Inc_Gain_L
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_L
    call	Inc_Gain_L

    pagesel	Inc_Gain_R
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_R
    call	Inc_Gain_R

    pagesel	Inc_Gain_A
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_A
    call	Inc_Gain_A

    pagesel	Inc_Gain_B
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_B
    call	Inc_Gain_B
    return

Inc_LPF
    pagesel	Inc_LPF_L
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_L
    call	Inc_LPF_L

    pagesel	Inc_LPF_R
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_R
    call	Inc_LPF_R

    pagesel	Inc_LPF_A
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_A
    call	Inc_LPF_A

    pagesel	Inc_LPF_B
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_B
    call	Inc_LPF_B
    return

PB_DOWN_Poll
    banksel	PORTC
    movf	PORTC,W		; Get inputs
    banksel	Buttons
    movwf	Buttons

    banksel	PB_State	    ; Check button state
    btfss	PB_State,PB_DOWN    ; Was button down?
    goto	PB_DOWN_wasDown	    ; Yes

PB_DOWN_wasUp
    banksel	Buttons
    btfsc	Buttons,PB_DOWN_BIT ; Is button still up?
    return			    ; Was up and still up, do nothing
    banksel	PB_State
    bcf		PB_State,PB_DOWN    ; Was up, remember now down
    return

PB_DOWN_wasDown
    banksel	Buttons
    btfss	Buttons,PB_DOWN_BIT ; If it is still down
    return			    ; Was down and still down, do nothing
    banksel	PB_State
    bsf		PB_State,PB_DOWN    ; remember released

    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    pagesel	Dec_Gain
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,GainLoop
    call	Dec_Gain

    pagesel	Dec_LPF
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,LPFLoop
    call	Dec_LPF

    return

Dec_Gain
    pagesel	Dec_Gain_L
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_L
    call	Dec_Gain_L

    pagesel	Dec_Gain_R
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_R
    call	Dec_Gain_R

    pagesel	Dec_Gain_A
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_A
    call	Dec_Gain_A

    pagesel	Dec_Gain_B
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_B
    call	Dec_Gain_B
    return

Dec_LPF
    pagesel	Dec_LPF_L
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_L
    call	Dec_LPF_L

    pagesel	Dec_LPF_R
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_R
    call	Dec_LPF_R

    pagesel	Dec_LPF_A
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_A
    call	Dec_LPF_A

    pagesel	Dec_LPF_B
    banksel	Gain_LPF_Flags
    btfsc	Gain_LPF_Flags,PB_B
    call	Dec_LPF_B
    return


Inc_Gain_L
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_L_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	Pot_L_Value,W	; Move Pot Count to W
    xorlw	POTMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    incf	Pot_L_Value,F	; Button was down and now it's up,

    ; Call subruteen to update the pot
    movlw	H'00'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_L_Write
    call	EEPROM_Pot_L_Write  ; Write port count to EEPROM

    return

Inc_Gain_R
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_R_Value

    bcf		STATUS,Z
    movf	Pot_R_Value,W	; Move Pot Count to W
    xorlw	POTMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return

    incf	Pot_R_Value,F	; Button was down and now it's up,
				; we need to increment the counter

    ; Call subruteen to update the pot
    movlw	H'01'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_R_Write
    call	EEPROM_Pot_R_Write  ; Write port count to EEPROM
    return

Inc_Gain_A
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_A_Value

    bcf		STATUS,Z
    movf	Pot_A_Value,W	; Move Pot Count to W
    xorlw	POTMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    incf	Pot_A_Value,F	; Button was down and now it's up,
				; we need to increment the counter

    ; Call subruteen to update the pot
    movlw	H'02'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_A_Write
    call	EEPROM_Pot_A_Write	; Write port count to EEPROM
    return

Inc_Gain_B
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_B_Value

    bcf		STATUS,Z
    movf	Pot_B_Value,W	; Move Pot Count to W
    xorlw	POTMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    incf	Pot_B_Value,F	; Button was down and now it's up,

    ; Call subruteen to update the pot
    movlw	H'03'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_B_Write
    call	EEPROM_Pot_B_Write	; Write port count to EEPROM
    return

Dec_Gain_L
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_L_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	Pot_L_Value,W	; Move Pot Count to W
    xorlw	POTMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	Pot_L_Value,F	; Button was down and now it's up,

    ; Call subruteen to update the pot
    movlw	H'00'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_L_Write
    call	EEPROM_Pot_L_Write	; Write port count to EEPROM
    return

Dec_Gain_R
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_R_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	Pot_R_Value,W	; Move Pot Count to W
    xorlw	POTMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	Pot_R_Value,F	; Button was down and now it's up,

    ; Call subruteen to update the pot
    movlw	H'01'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_R_Write
    call	EEPROM_Pot_R_Write	; Write port count to EEPROM
    return

Dec_Gain_A
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_A_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	Pot_A_Value,W	; Move Pot Count to W
    xorlw	POTMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	Pot_A_Value,F	; Button was down and now it's up,

    ; Call subruteen to update the pot
    movlw	H'02'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_A_Write
    call	EEPROM_Pot_A_Write	; Write port count to EEPROM
    return

Dec_Gain_B
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	Pot_B_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	Pot_B_Value,W	; Move Pot Count to W
    xorlw	POTMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	Pot_B_Value,F	; Button was down and now it's up,

    ; Call subruteen to update the pot
    movlw	H'03'
    pagesel	Update_Pot
    call	Update_Pot

    pagesel	EEPROM_Pot_B_Write
    call	EEPROM_Pot_B_Write	; Write port count to EEPROM
    return

EEPROM_Pot_L_Write
    banksel	Pot_L_Value
    movf	Pot_L_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_L_POT	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_Pot_R_Write
    banksel	Pot_R_Value
    movf	Pot_R_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_R_POT	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_Pot_A_Write
    banksel	Pot_A_Value
    movf	Pot_A_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_A_POT	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_Pot_B_Write
    banksel	Pot_B_Value
    movf	Pot_B_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_B_POT	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

Inc_LPF_L
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_L_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	LPF_L_Value,W	; Move Pot Count to W
    xorlw	LPFMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    incf	LPF_L_Value,F	; Button was down and now it's up,

    movlw	H'00'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_L_Write
    call	EEPROM_LPF_L_Write	; Write port count to EEPROM

    return

Inc_LPF_R
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_R_Value

    bcf		STATUS,Z
    movf	LPF_R_Value,W	; Move Pot Count to W
    xorlw	LPFMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return

    incf	LPF_R_Value,F	; Button was down and now it's up,
				; we need to increment the counter

    movlw	H'01'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_R_Write
    call	EEPROM_LPF_R_Write	; Write port count to EEPROM
    return

Inc_LPF_A
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_A_Value

    bcf		STATUS,Z
    movf	LPF_A_Value,W	; Move Pot Count to W
    xorlw	LPFMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    incf	LPF_A_Value,F	; Button was down and now it's up,
				; we need to increment the counter

    movlw	H'02'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_A_Write
    call	EEPROM_LPF_A_Write	; Write port count to EEPROM
    return

Inc_LPF_B
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_B_Value

    bcf		STATUS,Z
    movf	LPF_B_Value,W	; Move Pot Count to W
    xorlw	LPFMAX		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    incf	LPF_B_Value,F	; Button was down and now it's up,

    movlw	H'03'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_B_Write
    call	EEPROM_LPF_B_Write	; Write port count to EEPROM
    return

Dec_LPF_L
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_L_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	LPF_L_Value,W	; Move Pot Count to W
    xorlw	LPFMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	LPF_L_Value,F	; Button was down and now it's up,

    movlw	H'00'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_L_Write
    call	EEPROM_LPF_L_Write	; Write port count to EEPROM
    return

Dec_LPF_R
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_R_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	LPF_R_Value,W	; Move Pot Count to W
    xorlw	LPFMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	LPF_R_Value,F	; Button was down and now it's up,

    movlw	H'01'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_R_Write
    call	EEPROM_LPF_R_Write	; Write port count to EEPROM
    return

Dec_LPF_A
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_A_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	LPF_A_Value,W	; Move Pot Count to W
    xorlw	LPFMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	LPF_A_Value,F	; Button was down and now it's up,

    movlw	H'02'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_A_Write
    call	EEPROM_LPF_A_Write	; Write port count to EEPROM
    return

Dec_LPF_B
    pagesel	FullBackLight
    call	FullBackLight	; Restore LCD Backlight

    banksel	LPF_B_Value

    bcf		STATUS,Z	; Test if count is at max value.
    movf	LPF_B_Value,W	; Move Pot Count to W
    xorlw	LPFMIN		; Is the Pot Count equal the
    btfsc	STATUS,Z	; to the max port number
    return			; if Yes, do nothing

    decf	LPF_B_Value,F	; Button was down and now it's up,

    movlw	H'03'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    pagesel	EEPROM_LPF_B_Write
    call	EEPROM_LPF_B_Write	; Write port count to EEPROM
    return

EEPROM_LPF_L_Write
    banksel	LPF_L_Value
    movf	LPF_L_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_L_LPF	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_LPF_R_Write
    banksel	LPF_R_Value
    movf	LPF_R_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_R_LPF	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_LPF_A_Write
    banksel	LPF_A_Value
    movf	LPF_A_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_A_LPF	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

EEPROM_LPF_B_Write
    banksel	LPF_B_Value
    movf	LPF_B_Value,W

    banksel	EEADRL

    movwf	EEDATL

    movlw	EE_B_LPF	; Set the EEPROM address
    movwf	EEADRL

    bcf		EECON1,CFGS	; Deselect Config Space
    bcf		EECON1,EEPGD	; Point to DATA memory
    bsf		EECON1,WREN	; Enable EEPROM write
    bcf		INTCON, GIE	; Disable Interutps
    movlw	H'55'		; -Start of Required Sequence
    movwf	EECON2		; Write 0x55
    movlw	H'AA'		;
    movwf	EECON2		; Write 0XAA
    bsf		EECON1, WR	; Set WR bit to write
				; -End of Required Sequence
    bsf		INTCON, GIE	; Enable Interutps
    bcf		EECON1,WREN	; Disable EEPROM write
    btfsc	EECON1,WR	; Wait for write to complete
    goto	$-2		; Finshed

    return

SerialGainStatusDisplay
    pagesel	SerNewLine
    call	SerNewLine

    movlw	"G"
    call	SerialSendChar
    call	SerComma

    movlw	H'00'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	Pot_L_Value
    movf	Pot_L_Value,W
    call	SerialSendChar

    call	SerComma

    movlw	H'01'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	Pot_R_Value
    movf	Pot_R_Value,W
    call	SerialSendChar

    call	SerComma

    movlw	H'02'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	Pot_A_Value
    movf	Pot_A_Value,W
    call	SerialSendChar

    call 	SerComma

    movlw	H'03'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	Pot_B_Value
    movf	Pot_B_Value,W
    call	SerialSendChar

    call 	SerComma

    call	SerNewLine

    return

SerialLPFStatusDisplay
    pagesel	SerNewLine
    call	SerNewLine

    movlw	"F"
    call	SerialSendChar
    call	SerComma

    movlw	H'00'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	LPF_L_Value
    movf	LPF_L_Value,W
    call	SerialSendChar

    call	SerComma

    movlw	H'01'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	LPF_R_Value
    movf	LPF_R_Value,W
    call	SerialSendChar

    call	SerComma

    movlw	H'02'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	LPF_A_Value
    movf	LPF_A_Value,W
    call	SerialSendChar

    call 	SerComma

    movlw	H'03'
    call 	SerDisInNum

    call	SerOutInDiv

    banksel	LPF_B_Value
    movf	LPF_B_Value,W
    call	SerialSendChar

    call 	SerComma

    call	SerNewLine

    return

Init_Max270
    movlw	H'00'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    movlw	H'01'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    movlw	H'02'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    movlw	H'03'
    pagesel	Set_Max270_Filter
    call	Set_Max270_Filter

    return

Set_Max270_Filter
    banksel	Test
    movwf	Test

    pagesel	Get_A0_and_CS_Low	    ; Chip Select Low to tell MAX270
    call	Get_A0_and_CS_Low	    ; to watch WR.
					    ; CS MAX270 #1 - PCF8574 #2 P0
					    ; CS MAX270 #2 - PCF8574 #2 P1
					    ; Set A0 : A0 PCF8574 #2 P5
					    ; A0 High - Filter 1
					    ; A0 Low  - Filter 2
    banksel	Temp
    movwf	Temp			    ; Save PCF8574 value to use later

    banksel	Pcf8574_Data
    movwf	Pcf8574_Data
    movlw	Pcf8574_W2_Addr		    ; Write to PCF8574 #2
    pagesel	Update_Pcf8574
    call	Update_Pcf8574
    pagesel	i2c_LFP_Filter_Data

    ; Address-Setup Time is 30ns

    banksel	Test
    movfw	Test

    bcf		STATUS,Z		    ; Get the Filter Number
    pagesel	Get_LPF_1
    movf	Test,W
    xorlw	H'00'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_LPF_1
    pagesel	Get_LPF_2
    movf	Test,W
    xorlw	H'01'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_LPF_2
    pagesel	Get_LPF_3
    movf	Test,W
    xorlw	H'02'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_LPF_3
    pagesel	Get_LPF_4
    movf	Test,W
    xorlw	H'03'
    btfsc	STATUS,Z		    ; Was it Zero?
    goto	Get_LPF_4

    return

Get_LPF_1
    banksel	LPF_L_Value
    movfw	LPF_L_Value
    goto	i2c_LFP_Filter_Data
Get_LPF_2
    banksel	LPF_R_Value
    movfw	LPF_R_Value
    goto	i2c_LFP_Filter_Data
Get_LPF_3
    banksel	LPF_A_Value
    movfw	LPF_A_Value
    goto	i2c_LFP_Filter_Data
Get_LPF_4
    banksel	LPF_B_Value
    movfw	LPF_B_Value
    goto	i2c_LFP_Filter_Data

i2c_LFP_Filter_Data
    banksel	Pcf8574_Data
    movwf	Pcf8574_Data

    movlw	Pcf8574_W1_Addr		    ; Write to PCF8574 #1
    pagesel	Update_Pcf8574
    call	Update_Pcf8574
    pagesel	i2c_LFP_Filter_Data

    ; Address-Setup Time is 30 ns
    ; Data-Setup Time is 30ns

    ;CS to WR Setup time is 0 ns

    banksel	Temp
    movfw	Temp
    banksel	Pcf8574_Data
    movwf	Pcf8574_Data

    movlw	B'00010000'		    ; Set WR low to store LFP number and
    xorwf	Pcf8574_Data		    ; A0 state.
					    ; WR - PCF8574 #2 P5

    movlw	Pcf8574_W2_Addr		    ; Write to PCF8574 #2
    pagesel	Update_Pcf8574
    call	Update_Pcf8574
    pagesel	i2c_LFP_Filter_Data

    ; WR Pulse Width is 100ns

    banksel	Pcf8574_Data
    movlw	B'00010000'		    ; Set WR high to start to latch the
    xorwf	Pcf8574_Data		    ; data.

    movlw	Pcf8574_W2_Addr		    ; Write to PCF8574 #2
    pagesel	Update_Pcf8574
    call	Update_Pcf8574
    pagesel	i2c_LFP_Filter_Data

    ; Address-Hold time is 10ns
    ; Data-Hold time is 10ns

    banksel	Test
    movfw	Test

    pagesel	Get_CS_High		    ; Set CS high to change filter.
    call	Get_CS_High

    banksel	Pcf8574_Data
    movwf	Pcf8574_Data
    movlw	Pcf8574_W2_Addr		    ; Write to PCF8574 #2
    pagesel	Update_Pcf8574
    call	Update_Pcf8574
    pagesel	i2c_LFP_Filter_Data

    ;CS to WR Hold is 0 ns

    return

    ;Bit order is reversed on the PCF8574
    ;P7-P6-P5-P4-P3-P2-P1-P0
    ;PCF8574 #2
    ;P0 - MAX270 #1 CS
    ;P1 - MAX270 #2 CS
    ;P2 - MAX270 #1	SHDN
    ;P3 - MAX270 #2 SHDN
    ;P4 - WR (Both #1 and #2)
    ;P5 - A0 (Both #1 and #2)
    ;P6 - NC
    ;P7 - NC
Get_A0_and_CS_Low
    brw
    dt	B'00111110',B'00011110',B'00111101',B'00011101'

Get_CS_High
    brw
    dt	B'00111111',B'00011111',B'00111111',B'00011111'

    end
