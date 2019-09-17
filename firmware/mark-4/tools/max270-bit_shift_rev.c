#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

uint8_t input;
uint8_t output;
uint8_t bit;
uint8_t temp;

uint8_t output_byte=0;

unsigned int i = 0;
int count=-1;

void main (int argc, char *argv[]) {

   printf(	"brw\n	dt	");

   for (i=0;i<=127;i++) {
	input=i; 
	//input=(i<<1);
	temp = input;

	for(count=1;count<=8;count++) { 
		bit= input & 0x01;
		input=input>>1;
		output=output<<1;
		if(bit==1) 
		output=output+1;

	}
        
        //printf( "i: %d in: %d %x o: %d %x\n",i,temp,temp,output,output);
	printf("i: %d : ",i);
	while(temp) {
	    if (temp & 1) {
        	printf("1");
	    } else {
        	printf("0");
	    }

	    temp >>= 1;
	}
	//printf("\n");

        printf( " - %x o: ",i);
        temp = output;
	while(temp) {
	    if (temp & 1) {
        	printf("1");
	    } else {
        	printf("0");
	    }

	    temp >>= 1;
	}
	printf(" - %x\n",output);
/*
	if ( i % 10 == 0){ 
	   printf("\n	dt	");
	}
 
 	printf("H\'%x\',",output);  
*/
        
   }

   printf("\n");
}



