x = 0,

for i in range(0,256):
    print  "		pagesel		Gain%sValueT\n" % i,
    print  "		movf		GainIdx,W\n",
    print  "		xorlw		H'%X'\n" % i,
    print  "		btfsc		STATUS,Z		 ;Was it Zero?\n",
    print  "		goto		Gain%sValueT\n" % i,

