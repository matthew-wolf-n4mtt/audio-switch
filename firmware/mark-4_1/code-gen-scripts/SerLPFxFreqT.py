x = 0,

for i in range(0,128):
    print  "SerLPF%sFreqT\n" % i,
    print  "		movf		LPFCharIdx,W\n",
    print  "		pagesel		LPF%sTs\n" % i,
    print  "		call		LPF%sTs\n" % i, 
    print  "		xorlw		H'00'			; Test to see if char is Zero\n",
    print  "		btfsc		STATUS,Z		; Was it Zero?\n",
    print  "		return	\n",
    print  "		pagesel		SerialSendChar\n",
    print  "		call		SerialSendChar		; Display Chr on LCD\n",
    print  "		banksel		LPFCharIdx\n",	
    print  "		incf		LPFCharIdx,F		; Point to the next char\n",
    print  "		pagesel		SerLPF%sFreqT\n" % i,
    print  "		goto		SerLPF%sFreqT\n\n" % i, 		