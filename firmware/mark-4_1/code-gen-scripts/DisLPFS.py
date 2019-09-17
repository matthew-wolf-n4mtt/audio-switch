x = 0,

for i in range(0,128):
    print  "		pagesel		LPF%sFreqT\n" % i,
    print  "		movf		LPFIdx,W\n",
    print  "		xorlw		H'%X'\n" % i,
    print  "		btfsc		STATUS,Z		 ;Was it Zero?\n",
    print  "		goto		LPF%sFreqT\n" % i,

