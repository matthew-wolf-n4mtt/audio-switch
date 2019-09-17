#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int i =-1;


double vstep = 0;
double d = 0;
double db = 0;
double v = 0;
double r = 0;

double vhigh = 2.2448;
double vlow = -2.2448;
double steps = 256;

int main () {

    vstep = (vhigh-vlow)/(steps-(double)1);	
    printf("Vstep: %f\n",vstep);
    
    // values for step 0
    v = vhigh;   // value at pot value 0
    d = v/(double)23; 	 // 23:1 volt div
    db = d / -0.0061; // THAT2180 db ratio
    r = (pow(10,(db/(double)20))); // Volt in out ration	

    printf("0: %fV div: %f %fdB r: %f \n",v,d,db,r);

    for(i=1;i<=255;i++) {
    	v = v - vstep;   
    	d = v/(double)23; // 23:1 volt div
    	db = d / -0.0061; // THAT2180 db ratio
    	r = (pow(10,(db/(double)20))); // Volt in out ration
        printf("%d: %fV div: %f %2.3fdB r: %f \n",i,v,d,db,r);
    }


}
