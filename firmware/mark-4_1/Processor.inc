; Processor.inc - Select include based on processor symbol
		nolist
;**
;  This file includes the appropriate procesor include file
;  based on the processor symbol passed in from the IDE.
;
;  NOTE - 18-pin parts >=1K appropriate for PIC-EL only
;**
;  WB8RCR - 23-Nov-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:12:20-04 $

		IFDEF		__16F83
		include		p16f83.inc
		nolist
PROC=84
		ENDIF

		IFDEF		__16F84
		include		p16f84.inc
		nolist
PROC=84
		ENDIF

		IFDEF		__16F84A
		include		p16f84a.inc
		nolist
PROC=84
		ENDIF

		IFDEF		__16F627
		include		p16f627.inc
		nolist
PROC=627
		ENDIF

		IFDEF		__16F627A
PROC=627
		ENDIF

		IFDEF		__16F628
		include		p16f628.inc
		nolist
PROC=627
		ENDIF

		IFDEF		__16F628A
		include		p16f628a.inc
		nolist
PROC=627
		ENDIF

		IFDEF		__16F648A
		include		p16f648a.inc
		nolist
PROC=627
		ENDIF

		IFDEF		__16F88
		include		p16f88.inc
		nolist
PROC=88
		ENDIF

		IFDEF		__16F819
		include		p16f819.inc
		nolist
PROC=819
		ENDIF

		IFDEF		__16F818
		include		p16f818.inc
		nolist
PROC=818
		ENDIF

		IFDEF		__16F716
		include		p16f716.inc
		nolist
PROC=716
		ENDIF

;	28 pin parts

		IFDEF		__16F872
		include		p16f872.inc
		nolist
PROC=872
		ENDIF

		IFDEF		__16F873
		include		p16f873.inc
		nolist
PROC=872
		ENDIF

		IFDEF		__16F876
		include		p16f876.inc
		nolist
PROC=872
		ENDIF

		IFDEF		__16F1938
		include		p16f1938.inc
		nolist
PROC=872
		ENDIF

		IFDEF		__16F1933
		include		p16f1933.inc
		nolist
PROC=872
		ENDIF
		list
