#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int get_cutoff_freq_code(int in_freq);


float user_freq = -1;

int freq = -1;
int filter_code = -1;


void main (int argc, char *argv[]) {

  printf("Enter Low Pass Cutoff Frequency in kHz, 1 to 25 kHz up to 3 decimal points:\n");
  scanf("%f",&user_freq);
  
  //round up to two decimal points
  user_freq = ceilf(user_freq * 1000) / 1000;

  // convert entened frequency to a int 
  freq = (int)(user_freq *1000);

  printf("user in: %2.3f kHz %d Hz\n",user_freq,freq);

  if ( user_freq < 1 || freq < 1000 ) {
     printf ("Frequency Too Low\n");
     return;
  }

  if ( user_freq > 25 || freq > 25000 ) {
     printf ("Frequency Too High\n");
     return;
  }

  filter_code = get_cutoff_freq_code(freq);
  printf("Main - %d Hz - %2.3f kHz Filter Code: %d\n",freq,user_freq,filter_code);

/*

 for (freq=1000;freq<=2000;freq = freq + 100){

     filter_code = get_cutoff_freq_code(freq);
   
     printf("Main - %d Hz - %2.1f kHz Filter Code: %d\n",freq,((float)freq/1000),filter_code);     
 }

}

*/

int get_cutoff_freq_code(int in_freq) {

  int fcode = -1;

  /* http://stackoverflow.com/questions/2422712/c-rounding-integer-division-instead-of-truncating
  The standard idiom for integer rounding up
  You add the divisor minus one to the dividend.
  */

  if ( in_freq >= 1000 && in_freq <= 3570) {
  // LPF code eq for 1kHz to 3.57 kHZ:
  // Data sheet page 9
  // Fc= 87.5 / (87.5-CODE)  - fc in kHz
  //
  // CODE = -(87.5 / Fc ) + 87.5
  // -codes (0 to 63), 63 is 3.57
 
     fcode =  -(87500/in_freq) + 87.5;

  } 

  else if ( in_freq > 3570 && in_freq <= 25000 ) {
  // LPF code eq for 3.57 to 25 kHZ:   
  // Fc= 262.5 / (137.5-CODE)
  //
  // CODE = -(262.5/ Fc) + 137.5)
  // -codes (64 to 127), 64 is 3.57

     fcode =  -(262500/in_freq) + 137.5;

  }
  //printf("Filter Code: %d\n",fcode);  

  return(fcode);

}
