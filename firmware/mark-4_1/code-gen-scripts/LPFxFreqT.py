x = 0,

for i in range(0,128):
    print  "LPF%sFreqT\n" % i,
    print  "		movf		LPFCharIdx,W\n",
    print  "		pagesel		LPF%sTs\n" % i,
    print  "		call		LPF%sTs\n" % i, 
    print  "		xorlw		H'00'			; Test to see if char is Zero\n",
    print  "		btfsc		STATUS,Z		; Was it Zero?\n",
    print  "		return	\n",
    print  "		pagesel		LCDletr\n",
    print  "		call		LCDletr			; Display Chr on LCD\n",
    print  "		banksel		LPFCharIdx\n",	
    print  "		incf		LPFCharIdx,F		; Point to the next char\n",
    print  "		pagesel		LPF%sFreqT\n" % i,
    print  "		goto		LPF%sFreqT\n\n" % i, 		
